// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MyToken
 * @dev ERC20 token with advanced security features.
 * @notice Security Features:
 *         - Pausable transfers (with timelock)
 *         - Blacklist functionality (with timelock)
 *         - Transfer limits (per transaction & per wallet)
 *         - Transfer lock period
 *         - Excluded addresses (whitelist for DEX, pools)
 *         - Anti-bot protection
 *         - Anti-whale sell limits (per tx & 24h)
 *         - Buy/Sell cooldown system
 *         - Liquidity lock
 *         - Flash loan protection
 *         - Router/Pair validation
 *         - Permanent supply lock option
 */
contract MyToken is ERC20, ERC20Pausable, Ownable {
    /// @notice Maximum total supply (10 billion tokens * 10^18)
    uint256 public constant MAX_SUPPLY = 10_000_000_000 * 10**18;

    /// @notice Timelock delay for critical operations
    uint256 public timelockDelay;

    // ============================================
    // BLACKLIST
    // ============================================
    /// @notice Blacklisted addresses cannot transfer tokens
    mapping(address => bool) public isBlacklisted;

    // ============================================
    // BURN AUTHORIZATION
    // ============================================
    /// @notice Addresses authorized for burnFrom
    mapping(address => bool) public authorizedBurnFrom;

    // ============================================
    // TRANSFER LIMITS
    // ============================================
    /// @notice Maximum tokens per transfer (0 = no limit)
    uint256 public maxTransferAmount;

    /// @notice Maximum balance per wallet (0 = no limit)
    uint256 public maxWalletBalance;

    /// @notice Daily mint limit per address (0 = no limit)
    mapping(address => uint256) public dailyMintAmount;
    mapping(address => uint256) public lastMintDay;

    // ============================================
    // TRANSFER LOCK
    // ============================================
    /// @notice Timestamp when transfers unlock (0 = already unlocked)
    uint256 public transferUnlockTime;

    // ============================================
    // ANTI-BOT
    // ============================================
    /// @notice Minimum delay between transfers for same address (in seconds)
    uint256 public antiBotDelay;

    /// @notice Last transfer timestamp per address
    mapping(address => uint256) public lastTransferTime;

    // ============================================
    // ANTI-WHALE SELL LIMITS
    // ============================================
    /// @notice Maximum tokens per sell transaction (0 = no limit)
    uint256 public maxSellAmount;

    /// @notice Maximum tokens per 24-hour window per address (0 = no limit)
    uint256 public maxSellAmountPerDay;

    /// @notice Sell amount in last 24 hours per address
    mapping(address => uint256) public sellAmountLast24h;
    mapping(address => uint256) public lastSellResetDay;

    // ============================================
    // COOLDOWN SYSTEM
    // ============================================
    /// @notice Cooldown after buy in seconds (0 = disabled)
    uint256 public buyCooldown;

    /// @notice Cooldown after sell in seconds (0 = disabled)
    uint256 public sellCooldown;

    /// @notice Last buy timestamp per address
    mapping(address => uint256) public lastBuyTime;

    /// @notice Last sell timestamp per address
    mapping(address => uint256) public lastSellTime;

    // ============================================
    // LIQUIDITY LOCK
    // ============================================
    /// @notice LP pair address (for liquidity lock verification)
    address public liquidityPair;

    /// @notice Timestamp when liquidity unlocks (0 = locked forever)
    uint256 public liquidityUnlockTime;

    /// @notice Whether liquidity is permanently locked
    bool public liquidityPermanentlyLocked;

    // ============================================
    // FLASH LOAN PROTECTION
    // ============================================
    /// @notice Whether flash loan protection is enabled
    bool public flashLoanProtectionEnabled;

    /// @notice Maximum flash loan amount in basis points (100 = 1%)
    uint256 public flashLoanThreshold;

    // ============================================
    // ROUTER/PAIR VALIDATION
    // ============================================
    /// @notice Known router addresses (to prevent fake router attacks)

    /// @notice Known pair addresses for trading
    mapping(address => bool) public knownPairs;

    // ============================================
    // SUPPLY LOCK
    // ============================================
    /// @notice Whether supply is permanently locked (no more mints)
    bool public supplyLocked;

    // ============================================
    // EXCLUDED ADDRESSES
    // ============================================
    /// @notice Addresses excluded from transfer limits (DEX, pools, team wallets)
    mapping(address => bool) public isExcludedFromLimits;

    // ============================================
    // TIMELOCK
    // ============================================
    /// @notice Pending timelock actions
    mapping(bytes32 => uint256) public pendingActions;

    // ============================================
    // EVENTS
    // ============================================
    event Blacklisted(address indexed account);
    event UnBlacklisted(address indexed account);
    event Minted(address indexed to, uint256 amount);
    event AuthorizedForBurn(address indexed account);
    event DeauthorizedForBurn(address indexed account);
    event Burned(address indexed from, uint256 amount);
    event TimelockScheduled(bytes32 indexed actionId, uint256 executeAt);
    event TimelockExecuted(bytes32 indexed actionId);
    event TimelockCancelled(bytes32 indexed actionId);
    event TimelockDelayUpdated(uint256 oldDelay, uint256 newDelay);
    event TokensRescued(address indexed token, address indexed to, uint256 amount);
    event TransferLimitUpdated(uint256 maxAmount, uint256 maxWallet);
    event AntiBotDelayUpdated(uint256 oldDelay, uint256 newDelay);
    event TransferUnlockTimeUpdated(uint256 unlockTime);
    event ExcludedAddressUpdated(address indexed account, bool excluded);

    // Anti-Whale
    event MaxSellAmountUpdated(uint256 maxSellAmount, uint256 maxSellAmountPerDay);
    event SellAmountLimitReached(address indexed account);

    // Cooldown
    event BuyCooldownUpdated(uint256 cooldown);
    event SellCooldownUpdated(uint256 cooldown);

    // Liquidity Lock
    event LiquidityPairUpdated(address indexed pair);
    event LiquidityLocked(uint256 unlockTime);
    event LiquidityPermanentlyLocked();

    // Flash Loan
    event FlashLoanProtectionUpdated(bool enabled, uint256 threshold);

    // Router Validation
    event KnownPairUpdated(address indexed pair, bool known);

    // Supply Lock
    event SupplyLocked();
    event DailyMintLimitUpdated(address indexed account, uint256 dailyLimit);

    /**
     * @dev Constructor
     */
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initialSupply,
        address initialOwner,
        uint256 timelockDelay_
    ) ERC20(name_, symbol_) Ownable(initialOwner) {
        _mint(_msgSender(), initialSupply);
        emit Minted(_msgSender(), initialSupply);
        timelockDelay = timelockDelay_;
        maxTransferAmount = 0;
        maxWalletBalance = 0;
        antiBotDelay = 0;
        transferUnlockTime = 0;
    }

    // ============================================
    // MODIFIERS
    // ============================================
    modifier notBlacklisted(address account) {
        require(!isBlacklisted[account], "MyToken: account is blacklisted");
        _;
    }

    modifier timelockNotExpired(bytes32 actionId) {
        require(pendingActions[actionId] != 0, "MyToken: action not scheduled");
        require(block.timestamp >= pendingActions[actionId], "MyToken: timelock not expired");
        _;
    }

    // ============================================
    // INTERNAL HELPERS
    // ============================================
    function _scheduleTimelockAction(bytes32 actionId) internal returns (uint256) {
        require(pendingActions[actionId] == 0, "MyToken: action already scheduled");
        uint256 executeAt = block.timestamp + timelockDelay;
        pendingActions[actionId] = executeAt;
        emit TimelockScheduled(actionId, executeAt);
        return executeAt;
    }

    function _executeTimelockAction(bytes32 actionId) internal timelockNotExpired(actionId) {
        pendingActions[actionId] = 0;
        emit TimelockExecuted(actionId);
    }

    function _checkTransferLimits(address from, address to, uint256 amount) internal view {
        if (isExcludedFromLimits[from] || isExcludedFromLimits[to]) {
            return;
        }

        if (maxTransferAmount > 0) {
            require(amount <= maxTransferAmount, "MyToken: exceeds max transfer amount");
        }

        if (maxWalletBalance > 0) {
            require(balanceOf(to) + amount <= maxWalletBalance, "MyToken: exceeds max wallet balance");
        }
    }

    function _checkAntiBot(address from) internal view {
        if (antiBotDelay > 0 && !isExcludedFromLimits[from]) {
            require(
                block.timestamp >= lastTransferTime[from] + antiBotDelay,
                "MyToken: anti-bot delay not passed"
            );
        }
    }

    function _checkAntiWhale(address from, uint256 amount) internal view {
        if (isExcludedFromLimits[from]) {
            return;
        }

        // Check per-transaction sell limit
        if (maxSellAmount > 0) {
            require(amount <= maxSellAmount, "MyToken: exceeds max sell amount");
        }

        // Check 24-hour sell limit (read-only check, state update happens in _update)
        if (maxSellAmountPerDay > 0) {
            uint256 today = block.timestamp / 1 days;
            uint256 currentSellAmount = sellAmountLast24h[from];
            if (lastSellResetDay[from] != today) {
                currentSellAmount = 0;
            }
            require(
                currentSellAmount + amount <= maxSellAmountPerDay,
                "MyToken: exceeds daily sell limit"
            );
        }
    }

    function _checkCooldown(address from, address to) internal view {
        // Check buy cooldown (when receiving from a known pair)
        if (buyCooldown > 0 && knownPairs[from] && !isExcludedFromLimits[to]) {
            require(
                block.timestamp >= lastBuyTime[to] + buyCooldown,
                "MyToken: buy cooldown not passed"
            );
        }

        // Check sell cooldown (when sending to a known pair)
        if (sellCooldown > 0 && knownPairs[to] && !isExcludedFromLimits[from]) {
            require(
                block.timestamp >= lastSellTime[from] + sellCooldown,
                "MyToken: sell cooldown not passed"
            );
        }
    }

    function _checkFlashLoan(address from, uint256 value) internal view {
        if (!flashLoanProtectionEnabled || isExcludedFromLimits[from]) {
            return;
        }
        // Flash loan threshold as percentage of supply (in basis points)
        uint256 maxFlashLoan = (MAX_SUPPLY * flashLoanThreshold) / 10000;
        require(value <= maxFlashLoan, "MyToken: flash loan amount exceeds limit");
    }

    function _update(
        address from,
        address to,
        uint256 value
    ) internal override(ERC20, ERC20Pausable) whenNotPaused notBlacklisted(from) notBlacklisted(to) {
        // Check transfer lock
        if (transferUnlockTime > 0) {
            require(block.timestamp >= transferUnlockTime, "MyToken: transfers locked");
        }

        // Check transfer limits
        _checkTransferLimits(from, to, value);

        // Check anti-bot
        _checkAntiBot(from);

        // Check anti-whale (for sells)
        _checkAntiWhale(from, value);

        // Check cooldown
        _checkCooldown(from, to);

        // Check flash loan
        _checkFlashLoan(from, value);

        // Check liquidity lock
        if (liquidityPair != address(0) && !liquidityPermanentlyLocked) {
            if (liquidityUnlockTime > 0) {
                if (from == liquidityPair || to == liquidityPair) {
                    require(block.timestamp >= liquidityUnlockTime, "MyToken: liquidity locked");
                }
            }
        }

        // Update last transfer time
        if (!isExcludedFromLimits[from]) {
            lastTransferTime[from] = block.timestamp;
        }

        // Update buy/sell tracking
        if (knownPairs[from] && !isExcludedFromLimits[to]) {
            lastBuyTime[to] = block.timestamp;
        }
        if (knownPairs[to] && !isExcludedFromLimits[from]) {
            // Update 24h sell amount
            uint256 today = block.timestamp / 1 days;
            if (lastSellResetDay[from] != today) {
                lastSellResetDay[from] = today;
                sellAmountLast24h[from] = 0;
            }
            sellAmountLast24h[from] += value;
            lastSellTime[from] = block.timestamp;
        }

        super._update(from, to, value);
    }

    // ============================================
    // TIMELOCKED OPERATIONS
    // ============================================
    function cancelAction(bytes32 actionId) external onlyOwner {
        require(pendingActions[actionId] != 0, "MyToken: action not scheduled");
        pendingActions[actionId] = 0;
        emit TimelockCancelled(actionId);
    }

    function pause() external onlyOwner {
        bytes32 actionId = keccak256(abi.encodePacked("pause"));
        _scheduleTimelockAction(actionId);
    }

    function executePause() external onlyOwner {
        bytes32 actionId = keccak256(abi.encodePacked("pause"));
        _executeTimelockAction(actionId);
        _pause();
    }

    function unpause() external onlyOwner {
        bytes32 actionId = keccak256(abi.encodePacked("unpause"));
        _scheduleTimelockAction(actionId);
    }

    function executeUnpause() external onlyOwner {
        bytes32 actionId = keccak256(abi.encodePacked("unpause"));
        _executeTimelockAction(actionId);
        _unpause();
    }

    function blacklist(address account) external onlyOwner {
        require(account != owner(), "MyToken: cannot blacklist owner");
        bytes32 actionId = keccak256(abi.encodePacked("blacklist", account));
        _scheduleTimelockAction(actionId);
    }

    function executeBlacklist(address account) external onlyOwner {
        require(account != owner(), "MyToken: cannot blacklist owner");
        bytes32 actionId = keccak256(abi.encodePacked("blacklist", account));
        _executeTimelockAction(actionId);
        isBlacklisted[account] = true;
        emit Blacklisted(account);
    }

    function unBlacklist(address account) external onlyOwner {
        bytes32 actionId = keccak256(abi.encodePacked("unBlacklist", account));
        _scheduleTimelockAction(actionId);
    }

    function executeUnBlacklist(address account) external onlyOwner {
        bytes32 actionId = keccak256(abi.encodePacked("unBlacklist", account));
        _executeTimelockAction(actionId);
        isBlacklisted[account] = false;
        emit UnBlacklisted(account);
    }

    // ============================================
    // MINT & BURN
    // ============================================
    function mint(address to, uint256 amount) external onlyOwner {
        require(!supplyLocked, "MyToken: supply is locked");
        require(!isBlacklisted[to], "MyToken: cannot mint to blacklisted address");
        require(totalSupply() + amount <= MAX_SUPPLY, "MyToken: exceeds max supply");

        // Check and enforce daily mint limit
        uint256 dailyLimit = dailyMintAmount[msg.sender];
        if (dailyLimit > 0) {
            uint256 today = block.timestamp / 1 days;
            if (lastMintDay[msg.sender] != today) {
                // Reset daily allowance on new day
                lastMintDay[msg.sender] = today;
                dailyMintAmount[msg.sender] = dailyLimit;
            }
            require(
                amount <= dailyMintAmount[msg.sender],
                "MyToken: exceeds daily mint limit"
            );
            dailyMintAmount[msg.sender] -= amount;
        }

        _mint(to, amount);
        emit Minted(to, amount);
    }

    /**
     * @dev Set daily mint limit for an address
     * @param account Address to set limit for
     * @param dailyLimit Daily mint limit (0 = no limit)
     */
    function setDailyMintLimit(address account, uint256 dailyLimit) external onlyOwner {
        require(dailyLimit <= MAX_SUPPLY, "MyToken: daily limit too high");
        dailyMintAmount[account] = dailyLimit;
        emit DailyMintLimitUpdated(account, dailyLimit);
    }

    function burn(uint256 amount) external {
        _burn(_msgSender(), amount);
        emit Burned(_msgSender(), amount);
    }

    function authorizeBurnFrom(address account) external onlyOwner {
        authorizedBurnFrom[account] = true;
        emit AuthorizedForBurn(account);
    }

    function deauthorizeBurnFrom(address account) external onlyOwner {
        authorizedBurnFrom[account] = false;
        emit DeauthorizedForBurn(account);
    }

    function burnFrom(address account, uint256 amount) external onlyOwner {
        require(authorizedBurnFrom[account], "MyToken: not authorized for burn");
        _burn(account, amount);
        emit Burned(account, amount);
    }

    // ============================================
    // ADMIN FUNCTIONS (Multi-Sig Required)
    // ============================================

    /**
     * @dev Update timelock delay
     */
    function updateTimelockDelay(uint256 newDelay) external onlyOwner {
        require(newDelay >= 1 hours, "MyToken: delay too short");
        require(newDelay <= 7 days, "MyToken: delay too long");
        uint256 oldDelay = timelockDelay;
        timelockDelay = newDelay;
        emit TimelockDelayUpdated(oldDelay, newDelay);
    }

    /**
     * @dev Set transfer limits (max per transaction and per wallet)
     * @param maxAmount Maximum tokens per transfer (0 = no limit)
     * @param maxWallet Maximum balance per wallet (0 = no limit)
     */
    function setTransferLimits(uint256 maxAmount, uint256 maxWallet) external onlyOwner {
        require(maxAmount <= MAX_SUPPLY, "MyToken: max amount too high");
        require(maxWallet <= MAX_SUPPLY, "MyToken: max wallet too high");
        bytes32 actionId = keccak256(abi.encodePacked("setTransferLimits", maxAmount, maxWallet));
        _scheduleTimelockAction(actionId);
    }

    function executeSetTransferLimits(uint256 maxAmount, uint256 maxWallet) external onlyOwner {
        require(maxAmount <= MAX_SUPPLY, "MyToken: max amount too high");
        require(maxWallet <= MAX_SUPPLY, "MyToken: max wallet too high");
        bytes32 actionId = keccak256(abi.encodePacked("setTransferLimits", maxAmount, maxWallet));
        _executeTimelockAction(actionId);
        maxTransferAmount = maxAmount;
        maxWalletBalance = maxWallet;
        emit TransferLimitUpdated(maxAmount, maxWallet);
    }

    /**
     * @dev Set anti-bot delay (minimum time between transfers)
     * @param delay Delay in seconds (0 = disabled)
     */
    function setAntiBotDelay(uint256 delay) external onlyOwner {
        require(delay <= 1 hours, "MyToken: delay too long");
        uint256 oldDelay = antiBotDelay;
        antiBotDelay = delay;
        emit AntiBotDelayUpdated(oldDelay, delay);
    }

    /**
     * @dev Set transfer unlock time (for initial lock period)
     * @param unlockTime Unix timestamp when transfers unlock (0 = already unlocked)
     */
    function setTransferUnlockTime(uint256 unlockTime) external onlyOwner {
        require(unlockTime == 0 || unlockTime > block.timestamp, "MyToken: invalid unlock time");
        transferUnlockTime = unlockTime;
        emit TransferUnlockTimeUpdated(unlockTime);
    }

    /**
     * @dev Exclude or include an address from transfer limits
     * @param account Address to update
     * @param excluded True to exclude (whitelist), false to include
     */
    function setExcludedFromLimits(address account, bool excluded) external onlyOwner {
        isExcludedFromLimits[account] = excluded;
        emit ExcludedAddressUpdated(account, excluded);
    }

    /**
     * @dev Rescue tokens accidentally sent to contract
     * @param token Token address
     * @param to Recipient address
     * @param amount Amount to rescue
     */
    function rescueTokens(IERC20 token, address to, uint256 amount) external onlyOwner {
        require(to != address(0), "MyToken: cannot rescue to zero");
        require(amount > 0, "MyToken: amount is zero");
        require(token.balanceOf(address(this)) >= amount, "MyToken: insufficient balance");
        emit TokensRescued(address(token), to, amount);
        require(token.transfer(to, amount), "MyToken: transfer failed");
    }

    // ============================================
    // ANTI-WHALE SELL LIMITS
    // ============================================

    /**
     * @dev Set maximum sell amounts (per transaction and per 24h)
     * @param maxAmount Maximum tokens per sell transaction (0 = no limit)
     * @param maxAmountPerDay Maximum tokens per 24-hour period (0 = no limit)
     */
    function setMaxSellAmounts(uint256 maxAmount, uint256 maxAmountPerDay) external onlyOwner {
        require(maxAmount <= MAX_SUPPLY, "MyToken: max amount too high");
        require(maxAmountPerDay <= MAX_SUPPLY, "MyToken: max daily amount too high");
        bytes32 actionId = keccak256(abi.encodePacked("setMaxSellAmounts", maxAmount, maxAmountPerDay));
        _scheduleTimelockAction(actionId);
    }

    function executeSetMaxSellAmounts(uint256 maxAmount, uint256 maxAmountPerDay) external onlyOwner {
        require(maxAmount <= MAX_SUPPLY, "MyToken: max amount too high");
        require(maxAmountPerDay <= MAX_SUPPLY, "MyToken: max daily amount too high");
        bytes32 actionId = keccak256(abi.encodePacked("setMaxSellAmounts", maxAmount, maxAmountPerDay));
        _executeTimelockAction(actionId);
        maxSellAmount = maxAmount;
        maxSellAmountPerDay = maxAmountPerDay;
        emit MaxSellAmountUpdated(maxAmount, maxAmountPerDay);
    }

    // ============================================
    // COOLDOWN SYSTEM
    // ============================================

    /**
     * @dev Set cooldown period after buying
     * @param cooldownSecs Cooldown in seconds (0 = disabled)
     */
    function setBuyCooldown(uint256 cooldownSecs) external onlyOwner {
        require(cooldownSecs <= 24 hours, "MyToken: cooldown too long");
        buyCooldown = cooldownSecs;
        emit BuyCooldownUpdated(cooldownSecs);
    }

    /**
     * @dev Set cooldown period after selling
     * @param cooldownSecs Cooldown in seconds (0 = disabled)
     */
    function setSellCooldown(uint256 cooldownSecs) external onlyOwner {
        require(cooldownSecs <= 24 hours, "MyToken: cooldown too long");
        sellCooldown = cooldownSecs;
        emit SellCooldownUpdated(cooldownSecs);
    }

    // ============================================
    // LIQUIDITY LOCK
    // ============================================

    /**
     * @dev Set the LP pair address for liquidity lock verification
     * @param pair LP pair address (PancakeSwap/Uniswap pair)
     */
    function setLiquidityPair(address pair) external onlyOwner {
        require(pair != address(0), "MyToken: pair is zero");
        liquidityPair = pair;
        knownPairs[pair] = true;
        emit LiquidityPairUpdated(pair);
    }

    /**
     * @dev Lock liquidity until a specific timestamp
     * @param unlockTimestamp When liquidity unlocks (0 = lock forever)
     */
    function lockLiquidity(uint256 unlockTimestamp) external onlyOwner {
        require(liquidityPair != address(0), "MyToken: liquidity pair not set");
        liquidityUnlockTime = unlockTimestamp;
        liquidityPermanentlyLocked = false;
        emit LiquidityLocked(unlockTimestamp);
    }

    /**
     * @dev Permanently lock liquidity (cannot be undone)
     */
    function lockLiquidityPermanently() external onlyOwner {
        require(liquidityPair != address(0), "MyToken: liquidity pair not set");
        liquidityUnlockTime = 0;
        liquidityPermanentlyLocked = true;
        emit LiquidityPermanentlyLocked();
    }

    // ============================================
    // FLASH LOAN PROTECTION
    // ============================================

    /**
     * @dev Enable flash loan protection with threshold
     * @param thresholdBps Threshold in basis points (100 = 1% of supply)
     */
    function enableFlashLoanProtection(uint256 thresholdBps) external onlyOwner {
        require(thresholdBps > 0 && thresholdBps <= 1000, "MyToken: invalid threshold"); // Max 10%
        flashLoanProtectionEnabled = true;
        flashLoanThreshold = thresholdBps;
        emit FlashLoanProtectionUpdated(true, thresholdBps);
    }

    /**
     * @dev Disable flash loan protection
     */
    function disableFlashLoanProtection() external onlyOwner {
        flashLoanProtectionEnabled = false;
        emit FlashLoanProtectionUpdated(false, 0);
    }

    // ============================================
    // ROUTER/PAIR VALIDATION
    // ============================================

    /**
     * @dev Add a known pair address
     * @param pair Pair address to whitelist
     */
    function addKnownPair(address pair) external onlyOwner {
        require(pair != address(0), "MyToken: pair is zero");
        knownPairs[pair] = true;
        emit KnownPairUpdated(pair, true);
    }

    /**
     * @dev Remove a known pair address
     * @param pair Pair address to remove
     */
    function removeKnownPair(address pair) external onlyOwner {
        knownPairs[pair] = false;
        emit KnownPairUpdated(pair, false);
    }

    // ============================================
    // SUPPLY LOCK
    // ============================================

    /**
     * @dev Permanently lock the supply (no more mints possible)
     * Once locked, cannot be undone
     */
    function lockSupply() external onlyOwner {
        bytes32 actionId = keccak256(abi.encodePacked("lockSupply"));
        _scheduleTimelockAction(actionId);
    }

    function executeLockSupply() external onlyOwner {
        bytes32 actionId = keccak256(abi.encodePacked("lockSupply"));
        _executeTimelockAction(actionId);
        supplyLocked = true;
        emit SupplyLocked();
    }

    // ============================================
    // VIEW FUNCTIONS
    // ============================================

    /**
     * @dev Get if an address is excluded from all limits
     */
    function isExcluded(address account) external view returns (bool) {
        return isExcludedFromLimits[account];
    }

    /**
     * @dev Get current transfer status
     */
    function getTransferStatus() external view returns (bool isPaused, bool locked, uint256 unlockTime) {
        isPaused = paused();
        locked = transferUnlockTime > block.timestamp;
        unlockTime = transferUnlockTime;
    }
}
