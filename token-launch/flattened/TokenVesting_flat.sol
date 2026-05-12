// WARNING: You are currently using Node.js v23.9.0, which is not supported by Hardhat. This can lead to unexpected behavior. See https://v2.hardhat.org/nodejs-versions


// Sources flattened with hardhat v2.28.6 https://hardhat.org

// SPDX-License-Identifier: MIT

// File @openzeppelin/contracts/utils/Context.sol@v5.6.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

pragma solidity ^0.8.20;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}


// File @openzeppelin/contracts/access/Ownable.sol@v5.6.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

pragma solidity ^0.8.20;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


// File @openzeppelin/contracts/utils/StorageSlot.sol@v5.6.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.1.0) (utils/StorageSlot.sol)
// This file was procedurally generated from scripts/generate/templates/StorageSlot.js.

pragma solidity ^0.8.20;

/**
 * @dev Library for reading and writing primitive types to specific storage slots.
 *
 * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
 * This library helps with reading and writing to such slots without the need for inline assembly.
 *
 * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
 *
 * Example usage to set ERC-1967 implementation slot:
 * ```solidity
 * contract ERC1967 {
 *     // Define the slot. Alternatively, use the SlotDerivation library to derive the slot.
 *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
 *
 *     function _getImplementation() internal view returns (address) {
 *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
 *     }
 *
 *     function _setImplementation(address newImplementation) internal {
 *         require(newImplementation.code.length > 0);
 *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
 *     }
 * }
 * ```
 *
 * TIP: Consider using this library along with {SlotDerivation}.
 */
library StorageSlot {
    struct AddressSlot {
        address value;
    }

    struct BooleanSlot {
        bool value;
    }

    struct Bytes32Slot {
        bytes32 value;
    }

    struct Uint256Slot {
        uint256 value;
    }

    struct Int256Slot {
        int256 value;
    }

    struct StringSlot {
        string value;
    }

    struct BytesSlot {
        bytes value;
    }

    /**
     * @dev Returns an `AddressSlot` with member `value` located at `slot`.
     */
    function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `BooleanSlot` with member `value` located at `slot`.
     */
    function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `Bytes32Slot` with member `value` located at `slot`.
     */
    function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `Uint256Slot` with member `value` located at `slot`.
     */
    function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `Int256Slot` with member `value` located at `slot`.
     */
    function getInt256Slot(bytes32 slot) internal pure returns (Int256Slot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `StringSlot` with member `value` located at `slot`.
     */
    function getStringSlot(bytes32 slot) internal pure returns (StringSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
     */
    function getStringSlot(string storage store) internal pure returns (StringSlot storage r) {
        assembly ("memory-safe") {
            r.slot := store.slot
        }
    }

    /**
     * @dev Returns a `BytesSlot` with member `value` located at `slot`.
     */
    function getBytesSlot(bytes32 slot) internal pure returns (BytesSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
     */
    function getBytesSlot(bytes storage store) internal pure returns (BytesSlot storage r) {
        assembly ("memory-safe") {
            r.slot := store.slot
        }
    }
}


// File @openzeppelin/contracts/utils/ReentrancyGuard.sol@v5.6.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.5.0) (utils/ReentrancyGuard.sol)

pragma solidity ^0.8.20;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If EIP-1153 (transient storage) is available on the chain you're deploying at,
 * consider using {ReentrancyGuardTransient} instead.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 *
 * IMPORTANT: Deprecated. This storage-based reentrancy guard will be removed and replaced
 * by the {ReentrancyGuardTransient} variant in v6.0.
 *
 * @custom:stateless
 */
abstract contract ReentrancyGuard {
    using StorageSlot for bytes32;

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.ReentrancyGuard")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant REENTRANCY_GUARD_STORAGE =
        0x9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f00;

    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    /**
     * @dev Unauthorized reentrant call.
     */
    error ReentrancyGuardReentrantCall();

    constructor() {
        _reentrancyGuardStorageSlot().getUint256Slot().value = NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    /**
     * @dev A `view` only version of {nonReentrant}. Use to block view functions
     * from being called, preventing reading from inconsistent contract state.
     *
     * CAUTION: This is a "view" modifier and does not change the reentrancy
     * status. Use it only on view functions. For payable or non-payable functions,
     * use the standard {nonReentrant} modifier instead.
     */
    modifier nonReentrantView() {
        _nonReentrantBeforeView();
        _;
    }

    function _nonReentrantBeforeView() private view {
        if (_reentrancyGuardEntered()) {
            revert ReentrancyGuardReentrantCall();
        }
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be NOT_ENTERED
        _nonReentrantBeforeView();

        // Any calls to nonReentrant after this point will fail
        _reentrancyGuardStorageSlot().getUint256Slot().value = ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _reentrancyGuardStorageSlot().getUint256Slot().value = NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _reentrancyGuardStorageSlot().getUint256Slot().value == ENTERED;
    }

    function _reentrancyGuardStorageSlot() internal pure virtual returns (bytes32) {
        return REENTRANCY_GUARD_STORAGE;
    }
}


// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v5.6.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.4.0) (token/ERC20/IERC20.sol)

pragma solidity >=0.4.16;

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}


// File contracts/token/TokenVesting.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.24;



/**
 * @title TokenVesting
 * @dev A simple vesting contract that releases tokens linearly over time.
 * @notice Implements:
 *         - Linear vesting over a specified duration
 *         - Configurable start time and beneficiary
 *         - Emergency withdrawal of tokens by owner (limited to 10% max)
 *         - Cliff period support
 *         - Two-step emergency withdrawal with 48-hour delay
 */
contract TokenVesting is Ownable, ReentrancyGuard {
    /// @notice ERC20 token being vested
    IERC20 public token;

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
    uint256 public maxEmergencyWithdrawBps = 1000;

    /// @notice Delay for emergency withdrawal (48 hours)
    uint256 public constant EMERGENCY_WITHDRAW_DELAY = 48 hours;

    /// @notice Timestamp when emergency withdraw was requested
    uint256 public emergencyWithdrawRequestedAt;

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
     */
    constructor(address token_, address initialOwner) Ownable(initialOwner) {
        require(token_ != address(0), "TokenVesting: token is zero address");
        token = IERC20(token_);
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

        released += releasableAmount;
        token.transfer(beneficiary, releasableAmount);

        emit TokensReleased(beneficiary, releasableAmount);
    }

    /**
     * @dev Request emergency withdrawal. Must wait 48 hours before executing.
     * Only owner can call.
     */
    function requestEmergencyWithdraw() external onlyOwner {
        require(emergencyWithdrawRequestedAt == 0, "TokenVesting: request already pending");
        uint256 balance = token.balanceOf(address(this));
        require(balance > 0, "TokenVesting: no tokens to withdraw");

        // Calculate max withdrawal (10% of totalTokens by default)
        uint256 maxWithdraw = (totalTokens * maxEmergencyWithdrawBps) / 10000;
        if (balance < maxWithdraw) {
            maxWithdraw = balance;
        }

        emergencyWithdrawRequestedAt = block.timestamp;
        emit EmergencyWithdrawRequested(emergencyWithdrawRequestedAt, maxWithdraw);
    }

    /**
     * @dev Execute emergency withdrawal after 48-hour delay.
     * Limited to maxEmergencyWithdrawBps of totalTokens.
     * @param to Address to withdraw to
     */
    function executeEmergencyWithdraw(address to) external onlyOwner {
        require(to != address(0), "TokenVesting: cannot withdraw to zero");
        require(emergencyWithdrawRequestedAt != 0, "TokenVesting: no pending request");
        require(
            block.timestamp >= emergencyWithdrawRequestedAt + EMERGENCY_WITHDRAW_DELAY,
            "TokenVesting: emergency withdraw delay not passed"
        );

        uint256 balance = token.balanceOf(address(this));
        require(balance > 0, "TokenVesting: no tokens to withdraw");

        // Calculate max withdrawal (10% of totalTokens by default)
        uint256 maxWithdraw = (totalTokens * maxEmergencyWithdrawBps) / 10000;
        if (balance < maxWithdraw) {
            maxWithdraw = balance;
        }

        emergencyWithdrawRequestedAt = 0;
        token.transfer(to, maxWithdraw);
        emit EmergencyWithdraw(to, maxWithdraw);
    }

    /**
     * @dev Cancel pending emergency withdrawal request.
     * Only owner can call.
     */
    function cancelEmergencyWithdraw() external onlyOwner {
        require(emergencyWithdrawRequestedAt != 0, "TokenVesting: no pending request");
        emergencyWithdrawRequestedAt = 0;
        emit EmergencyWithdrawRequestCancelled();
    }

    /**
     * @dev Set max emergency withdrawal basis points.
     * @param bps New max basis points (e.g., 1000 = 10%)
     */
    function setMaxEmergencyWithdrawBps(uint256 bps) external onlyOwner {
        require(bps <= 10000, "TokenVesting: bps cannot exceed 10000");
        maxEmergencyWithdrawBps = bps;
    }

    /**
     * @dev Get remaining locked tokens (totalTokens - released)
     */
    function getLockedTokens() public view returns (uint256) {
        return totalTokens - released;
    }
}
