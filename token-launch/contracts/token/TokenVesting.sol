// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title TokenVesting
 * @dev A simple vesting contract that releases tokens linearly over time.
 * @notice Implements:
 *         - Linear vesting over a specified duration
 *         - Configurable start time and beneficiary
 *         - Emergency withdrawal of tokens by owner (limited to 10% max)
 *         - Cliff period support
 *         - Two-step emergency withdrawal with configurable delay
 */
contract TokenVesting is Ownable, ReentrancyGuard {
    /// @notice ERC20 token being vested (immutable after construction)
    IERC20 public immutable token;

    /// @notice Beneficiary address receiving vested tokens
    address public beneficiary;

    /// @notice Timestamp when vesting starts
    uint256 public startTime;

    /// @notice Duration of the vesting period in seconds
    uint256 public duration;

    /// @notice Duration of the cliff period in seconds
    uint256 public cliffDuration;

    /// @notice Total amount of tokens to be vested
    uint256 public totalTokens;

    /// @notice Amount of tokens already released
    uint256 public released;

    /// @notice Whether vesting has been initialized (prevents re-initialization)
    bool public isInitialized;

    /// @notice Maximum emergency withdrawal in basis points (1000 = 10%)
    uint256 public maxEmergencyWithdrawBps;

    /// @notice Delay for emergency withdrawal (configurable, default 48 hours)
    uint256 public emergencyWithdrawDelay;

    /// @notice Timestamp when emergency withdraw was requested
    uint256 public emergencyWithdrawRequestedAt;

    /// @notice Delay at time of emergency withdraw request (prevents delay manipulation)
    uint256 public emergencyWithdrawDelayAtRequest;

    /// @notice Emitted when vesting is initialized
    event VestingInitialized(
        address indexed beneficiary,
        uint256 totalTokens,
        uint256 startTime,
        uint256 duration
    );

    /// @notice Emitted when tokens are released
    event TokensReleased(address indexed beneficiary, uint256 amount);

    /// @notice Emitted when emergency withdraw is called
    event EmergencyWithdraw(address indexed to, uint256 amount);

    /// @notice Emitted when emergency withdraw is requested
    event EmergencyWithdrawRequested(uint256 requestedAt, uint256 availableAmount);

    /// @notice Emitted when emergency withdraw request is cancelled
    event EmergencyWithdrawRequestCancelled();

    /**
     * @dev Constructor that sets the token address and initial owner.
     * @param token_ Address of the ERC20 token being vested
     * @param initialOwner Initial owner address
     * @param maxEmergencyWithdrawBps_ Max basis points for emergency withdraw (e.g., 500 = 5%)
     * @param emergencyWithdrawDelay_ Delay in seconds for emergency withdraw (e.g., 172800 = 48 hours)
     */
    constructor(
        address token_,
        address initialOwner,
        uint256 maxEmergencyWithdrawBps_,
        uint256 emergencyWithdrawDelay_
    ) Ownable(initialOwner) {
        require(token_ != address(0), "TokenVesting: token is zero address");
        require(maxEmergencyWithdrawBps_ <= 2000, "TokenVesting: bps cannot exceed 20%");
        token = IERC20(token_);
        maxEmergencyWithdrawBps = maxEmergencyWithdrawBps_;
        emergencyWithdrawDelay = emergencyWithdrawDelay_;
    }

    /**
     * @dev Initialize vesting for a beneficiary.
     * @param beneficiary_ Address that will receive vested tokens
     * @param totalTokens_ Total tokens to be vested
     * @param duration_ Vesting duration in seconds
     * @param cliffDuration_ Cliff duration in seconds (can be 0)
     */
    function initializeVesting(
        address beneficiary_,
        uint256 totalTokens_,
        uint256 duration_,
        uint256 cliffDuration_
    ) external onlyOwner {
        require(!isInitialized, "TokenVesting: already initialized");
        require(beneficiary_ != address(0), "TokenVesting: beneficiary is zero");
        require(duration_ > 0, "TokenVesting: duration is zero");
        require(totalTokens_ > 0, "TokenVesting: totalTokens is zero");
        require(
            token.balanceOf(address(this)) >= totalTokens_,
            "TokenVesting: insufficient token balance"
        );

        beneficiary = beneficiary_;
        totalTokens = totalTokens_;
        duration = duration_;
        cliffDuration = cliffDuration_;
        startTime = block.timestamp;
        released = 0;
        isInitialized = true;

        emit VestingInitialized(beneficiary_, totalTokens_, startTime, duration_);
    }

    /**
     * @dev Calculate releasable amount based on current time and vesting schedule.
     */
    function releasable() public view returns (uint256) {
        if (block.timestamp < startTime + cliffDuration) {
            return 0;
        }
        if (block.timestamp >= startTime + duration) {
            return totalTokens - released;
        }
        uint256 timeFromStart = block.timestamp - startTime;
        uint256 vestedAmount = (totalTokens * timeFromStart) / duration;
        return vestedAmount - released;
    }

    /**
     * @dev Release available vested tokens to beneficiary.
     */
    function release() external nonReentrant {
        require(beneficiary != address(0), "TokenVesting: not initialized");
        uint256 releasableAmount = releasable();
        require(releasableAmount > 0, "TokenVesting: no tokens to release");

        // Cap at actual balance to handle precision loss from integer division
        uint256 actualRelease = releasableAmount;
        uint256 contractBalance = token.balanceOf(address(this));
        if (actualRelease > contractBalance) {
            actualRelease = contractBalance;
        }

        released += actualRelease;
        emit TokensReleased(beneficiary, actualRelease);
        bool success = token.transfer(beneficiary, actualRelease);
        require(success, "TokenVesting: transfer failed");
    }

    /**
     * @dev Request emergency withdrawal. Must wait delay before executing.
     * Only owner can call.
     */
    function requestEmergencyWithdraw() external onlyOwner {
        require(emergencyWithdrawRequestedAt == 0, "TokenVesting: request already pending");
        uint256 balance = token.balanceOf(address(this));
        require(balance > 0, "TokenVesting: no tokens to withdraw");

        // Calculate max withdrawal based on LOCKED tokens, not totalTokens
        uint256 lockedTokens = totalTokens - released;
        uint256 maxWithdraw = (lockedTokens * maxEmergencyWithdrawBps) / 10000;
        if (balance < maxWithdraw) {
            maxWithdraw = balance;
        }

        emergencyWithdrawRequestedAt = block.timestamp;
        emergencyWithdrawDelayAtRequest = emergencyWithdrawDelay; // Store delay at request time
        emit EmergencyWithdrawRequested(emergencyWithdrawRequestedAt, maxWithdraw);
    }

    /**
     * @dev Execute emergency withdrawal after delay.
     * Limited to maxEmergencyWithdrawBps of locked tokens.
     * @param to Address to withdraw to
     */
    function executeEmergencyWithdraw(address to) external onlyOwner {
        require(to != address(0), "TokenVesting: cannot withdraw to zero");
        require(emergencyWithdrawRequestedAt != 0, "TokenVesting: no pending request");
        require(
            block.timestamp >= emergencyWithdrawRequestedAt + emergencyWithdrawDelayAtRequest,
            "TokenVesting: emergency withdraw delay not passed"
        );

        uint256 balance = token.balanceOf(address(this));
        require(balance > 0, "TokenVesting: no tokens to withdraw");

        // Calculate max withdrawal based on LOCKED tokens, not totalTokens
        uint256 lockedTokens = totalTokens - released;
        uint256 maxWithdraw = (lockedTokens * maxEmergencyWithdrawBps) / 10000;
        if (balance < maxWithdraw) {
            maxWithdraw = balance;
        }

        emergencyWithdrawRequestedAt = 0;
        emergencyWithdrawDelayAtRequest = 0;
        emit EmergencyWithdraw(to, maxWithdraw);
        bool success = token.transfer(to, maxWithdraw);
        require(success, "TokenVesting: transfer failed");
    }

    /**
     * @dev Cancel pending emergency withdrawal request.
     * Only owner can call.
     */
    function cancelEmergencyWithdraw() external onlyOwner {
        require(emergencyWithdrawRequestedAt != 0, "TokenVesting: no pending request");
        emergencyWithdrawRequestedAt = 0;
        emergencyWithdrawDelayAtRequest = 0;
        emit EmergencyWithdrawRequestCancelled();
    }

    /**
     * @dev Set max emergency withdrawal basis points.
     * @param bps New max basis points (e.g., 1000 = 10%). Cannot exceed 2000 (20%).
     */
    function setMaxEmergencyWithdrawBps(uint256 bps) external onlyOwner {
        require(bps <= 2000, "TokenVesting: bps cannot exceed 20%"); // Max 20% for safety
        uint256 oldBps = maxEmergencyWithdrawBps;
        maxEmergencyWithdrawBps = bps;
        emit MaxEmergencyWithdrawBpsUpdated(oldBps, bps);
    }

    /**
     * @dev Set emergency withdrawal delay.
     * @param delay New delay in seconds (min 1 hour, max 30 days)
     */
    function setEmergencyWithdrawDelay(uint256 delay) external onlyOwner {
        require(delay >= 1 hours, "TokenVesting: delay too short");
        require(delay <= 30 days, "TokenVesting: delay too long");
        uint256 oldDelay = emergencyWithdrawDelay;
        emergencyWithdrawDelay = delay;
        emit EmergencyWithdrawDelayUpdated(oldDelay, delay);
    }

    // ============================================
    // ADMIN FUNCTIONS (Requires Multi-Sig)
    // ============================================

    /**
     * @dev Rescue tokens accidentally sent to contract. Only owner can call.
     * Requires multi-sig approval via Safe for production.
     * Cannot rescue tokens that are part of the vesting.
     * @param tokenToRescue Address of token to rescue
     * @param to Address to send rescued tokens
     * @param amount Amount to rescue
     */
    function rescueTokens(IERC20 tokenToRescue, address to, uint256 amount) external onlyOwner {
        require(to != address(0), "TokenVesting: cannot rescue to zero");
        require(amount > 0, "TokenVesting: amount is zero");
        // Check that this won't affect vested tokens (only for the vested token)
        if (address(tokenToRescue) == address(token)) {
            uint256 lockedTokens = getLockedTokens();
            uint256 contractBalance = tokenToRescue.balanceOf(address(this));
            require(
                contractBalance - amount >= lockedTokens,
                "TokenVesting: cannot rescue vested tokens"
            );
        }
        emit TokensRescued(address(tokenToRescue), to, amount);
        bool success = tokenToRescue.transfer(to, amount);
        require(success, "TokenVesting: transfer failed");
    }

    /**
     * @dev Get remaining locked tokens (totalTokens - released)
     */
    function getLockedTokens() public view returns (uint256) {
        return totalTokens - released;
    }

    // ============================================
    // EVENTS
    // ============================================

    /// @notice Emitted when max emergency withdraw bps is updated
    event MaxEmergencyWithdrawBpsUpdated(uint256 oldBps, uint256 newBps);

    /// @notice Emitted when emergency withdraw delay is updated
    event EmergencyWithdrawDelayUpdated(uint256 oldDelay, uint256 newDelay);

    /// @notice Emitted when tokens are rescued
    event TokensRescued(address indexed token, address indexed to, uint256 amount);
}
