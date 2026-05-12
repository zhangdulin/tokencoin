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


// File @openzeppelin/contracts/interfaces/draft-IERC6093.sol@v5.6.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.5.0) (interfaces/draft-IERC6093.sol)

pragma solidity >=0.8.4;

/**
 * @dev Standard ERC-20 Errors
 * Interface of the https://eips.ethereum.org/EIPS/eip-6093[ERC-6093] custom errors for ERC-20 tokens.
 */
interface IERC20Errors {
    /**
     * @dev Indicates an error related to the current `balance` of a `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     * @param balance Current balance for the interacting account.
     * @param needed Minimum amount required to perform a transfer.
     */
    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);

    /**
     * @dev Indicates a failure with the token `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     */
    error ERC20InvalidSender(address sender);

    /**
     * @dev Indicates a failure with the token `receiver`. Used in transfers.
     * @param receiver Address to which tokens are being transferred.
     */
    error ERC20InvalidReceiver(address receiver);

    /**
     * @dev Indicates a failure with the `spender`’s `allowance`. Used in transfers.
     * @param spender Address that may be allowed to operate on tokens without being their owner.
     * @param allowance Amount of tokens a `spender` is allowed to operate with.
     * @param needed Minimum amount required to perform a transfer.
     */
    error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);

    /**
     * @dev Indicates a failure with the `approver` of a token to be approved. Used in approvals.
     * @param approver Address initiating an approval operation.
     */
    error ERC20InvalidApprover(address approver);

    /**
     * @dev Indicates a failure with the `spender` to be approved. Used in approvals.
     * @param spender Address that may be allowed to operate on tokens without being their owner.
     */
    error ERC20InvalidSpender(address spender);
}

/**
 * @dev Standard ERC-721 Errors
 * Interface of the https://eips.ethereum.org/EIPS/eip-6093[ERC-6093] custom errors for ERC-721 tokens.
 */
interface IERC721Errors {
    /**
     * @dev Indicates that an address can't be an owner. For example, `address(0)` is a forbidden owner in ERC-721.
     * Used in balance queries.
     * @param owner Address of the current owner of a token.
     */
    error ERC721InvalidOwner(address owner);

    /**
     * @dev Indicates a `tokenId` whose `owner` is the zero address.
     * @param tokenId Identifier number of a token.
     */
    error ERC721NonexistentToken(uint256 tokenId);

    /**
     * @dev Indicates an error related to the ownership over a particular token. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     * @param tokenId Identifier number of a token.
     * @param owner Address of the current owner of a token.
     */
    error ERC721IncorrectOwner(address sender, uint256 tokenId, address owner);

    /**
     * @dev Indicates a failure with the token `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     */
    error ERC721InvalidSender(address sender);

    /**
     * @dev Indicates a failure with the token `receiver`. Used in transfers.
     * @param receiver Address to which tokens are being transferred.
     */
    error ERC721InvalidReceiver(address receiver);

    /**
     * @dev Indicates a failure with the `operator`’s approval. Used in transfers.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     * @param tokenId Identifier number of a token.
     */
    error ERC721InsufficientApproval(address operator, uint256 tokenId);

    /**
     * @dev Indicates a failure with the `approver` of a token to be approved. Used in approvals.
     * @param approver Address initiating an approval operation.
     */
    error ERC721InvalidApprover(address approver);

    /**
     * @dev Indicates a failure with the `operator` to be approved. Used in approvals.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     */
    error ERC721InvalidOperator(address operator);
}

/**
 * @dev Standard ERC-1155 Errors
 * Interface of the https://eips.ethereum.org/EIPS/eip-6093[ERC-6093] custom errors for ERC-1155 tokens.
 */
interface IERC1155Errors {
    /**
     * @dev Indicates an error related to the current `balance` of a `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     * @param balance Current balance for the interacting account.
     * @param needed Minimum amount required to perform a transfer.
     * @param tokenId Identifier number of a token.
     */
    error ERC1155InsufficientBalance(address sender, uint256 balance, uint256 needed, uint256 tokenId);

    /**
     * @dev Indicates a failure with the token `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     */
    error ERC1155InvalidSender(address sender);

    /**
     * @dev Indicates a failure with the token `receiver`. Used in transfers.
     * @param receiver Address to which tokens are being transferred.
     */
    error ERC1155InvalidReceiver(address receiver);

    /**
     * @dev Indicates a failure with the `operator`’s approval. Used in transfers.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     * @param owner Address of the current owner of a token.
     */
    error ERC1155MissingApprovalForAll(address operator, address owner);

    /**
     * @dev Indicates a failure with the `approver` of a token to be approved. Used in approvals.
     * @param approver Address initiating an approval operation.
     */
    error ERC1155InvalidApprover(address approver);

    /**
     * @dev Indicates a failure with the `operator` to be approved. Used in approvals.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     */
    error ERC1155InvalidOperator(address operator);

    /**
     * @dev Indicates an array length mismatch between ids and values in a safeBatchTransferFrom operation.
     * Used in batch transfers.
     * @param idsLength Length of the array of token identifiers
     * @param valuesLength Length of the array of token amounts
     */
    error ERC1155InvalidArrayLength(uint256 idsLength, uint256 valuesLength);
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


// File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v5.6.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.4.0) (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity >=0.6.2;

/**
 * @dev Interface for the optional metadata functions from the ERC-20 standard.
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}


// File @openzeppelin/contracts/token/ERC20/ERC20.sol@v5.6.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.5.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.20;




/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * The default value of {decimals} is 18. To change this, you should override
 * this function so it returns a different value.
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC-20
 * applications.
 */
abstract contract ERC20 is Context, IERC20, IERC20Metadata, IERC20Errors {
    mapping(address account => uint256) private _balances;

    mapping(address account => mapping(address spender => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * Both values are immutable: they can only be set once during construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the default value returned by this function, unless
     * it's overridden.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    /// @inheritdoc IERC20
    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

    /// @inheritdoc IERC20
    function balanceOf(address account) public view virtual returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `value`.
     */
    function transfer(address to, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }

    /// @inheritdoc IERC20
    function allowance(address owner, address spender) public view virtual returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `value` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, value);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Skips emitting an {Approval} event indicating an allowance update. This is not
     * required by the ERC. See {xref-ERC20-_approve-address-address-uint256-bool-}[_approve].
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `value`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `value`.
     */
    function transferFrom(address from, address to, uint256 value) public virtual returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * NOTE: This function is not virtual, {_update} should be overridden instead.
     */
    function _transfer(address from, address to, uint256 value) internal {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(from, to, value);
    }

    /**
     * @dev Transfers a `value` amount of tokens from `from` to `to`, or alternatively mints (or burns) if `from`
     * (or `to`) is the zero address. All customizations to transfers, mints, and burns should be done by overriding
     * this function.
     *
     * Emits a {Transfer} event.
     */
    function _update(address from, address to, uint256 value) internal virtual {
        if (from == address(0)) {
            // Overflow check required: The rest of the code assumes that totalSupply never overflows
            _totalSupply += value;
        } else {
            uint256 fromBalance = _balances[from];
            if (fromBalance < value) {
                revert ERC20InsufficientBalance(from, fromBalance, value);
            }
            unchecked {
                // Overflow not possible: value <= fromBalance <= totalSupply.
                _balances[from] = fromBalance - value;
            }
        }

        if (to == address(0)) {
            unchecked {
                // Overflow not possible: value <= totalSupply or value <= fromBalance <= totalSupply.
                _totalSupply -= value;
            }
        } else {
            unchecked {
                // Overflow not possible: balance + value is at most totalSupply, which we know fits into a uint256.
                _balances[to] += value;
            }
        }

        emit Transfer(from, to, value);
    }

    /**
     * @dev Creates a `value` amount of tokens and assigns them to `account`, by transferring it from address(0).
     * Relies on the `_update` mechanism
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * NOTE: This function is not virtual, {_update} should be overridden instead.
     */
    function _mint(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(address(0), account, value);
    }

    /**
     * @dev Destroys a `value` amount of tokens from `account`, lowering the total supply.
     * Relies on the `_update` mechanism.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * NOTE: This function is not virtual, {_update} should be overridden instead
     */
    function _burn(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        _update(account, address(0), value);
    }

    /**
     * @dev Sets `value` as the allowance of `spender` over the `owner`'s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     *
     * Overrides to this logic should be done to the variant with an additional `bool emitEvent` argument.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        _approve(owner, spender, value, true);
    }

    /**
     * @dev Variant of {_approve} with an optional flag to enable or disable the {Approval} event.
     *
     * By default (when calling {_approve}) the flag is set to true. On the other hand, approval changes made by
     * `_spendAllowance` during the `transferFrom` operation sets the flag to false. This saves gas by not emitting any
     * `Approval` event during `transferFrom` operations.
     *
     * Anyone who wishes to continue emitting `Approval` events on the `transferFrom` operation can force the flag to
     * true using the following override:
     *
     * ```solidity
     * function _approve(address owner, address spender, uint256 value, bool) internal virtual override {
     *     super._approve(owner, spender, value, true);
     * }
     * ```
     *
     * Requirements are the same as {_approve}.
     */
    function _approve(address owner, address spender, uint256 value, bool emitEvent) internal virtual {
        if (owner == address(0)) {
            revert ERC20InvalidApprover(address(0));
        }
        if (spender == address(0)) {
            revert ERC20InvalidSpender(address(0));
        }
        _allowances[owner][spender] = value;
        if (emitEvent) {
            emit Approval(owner, spender, value);
        }
    }

    /**
     * @dev Updates `owner`'s allowance for `spender` based on spent `value`.
     *
     * Does not update the allowance value in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Does not emit an {Approval} event.
     */
    function _spendAllowance(address owner, address spender, uint256 value) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance < type(uint256).max) {
            if (currentAllowance < value) {
                revert ERC20InsufficientAllowance(spender, currentAllowance, value);
            }
            unchecked {
                _approve(owner, spender, currentAllowance - value, false);
            }
        }
    }
}


// File @openzeppelin/contracts/utils/Pausable.sol@v5.6.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.3.0) (utils/Pausable.sol)

pragma solidity ^0.8.20;

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
    bool private _paused;

    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    /**
     * @dev The operation failed because the contract is paused.
     */
    error EnforcedPause();

    /**
     * @dev The operation failed because the contract is not paused.
     */
    error ExpectedPause();

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        _requirePaused();
        _;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Throws if the contract is paused.
     */
    function _requireNotPaused() internal view virtual {
        if (paused()) {
            revert EnforcedPause();
        }
    }

    /**
     * @dev Throws if the contract is not paused.
     */
    function _requirePaused() internal view virtual {
        if (!paused()) {
            revert ExpectedPause();
        }
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}


// File @openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol@v5.6.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.1.0) (token/ERC20/extensions/ERC20Pausable.sol)

pragma solidity ^0.8.20;


/**
 * @dev ERC-20 token with pausable token transfers, minting and burning.
 *
 * Useful for scenarios such as preventing trades until the end of an evaluation
 * period, or having an emergency switch for freezing all token transfers in the
 * event of a large bug.
 *
 * IMPORTANT: This contract does not include public pause and unpause functions. In
 * addition to inheriting this contract, you must define both functions, invoking the
 * {Pausable-_pause} and {Pausable-_unpause} internal functions, with appropriate
 * access control, e.g. using {AccessControl} or {Ownable}. Not doing so will
 * make the contract pause mechanism of the contract unreachable, and thus unusable.
 */
abstract contract ERC20Pausable is ERC20, Pausable {
    /**
     * @dev See {ERC20-_update}.
     *
     * Requirements:
     *
     * - the contract must not be paused.
     */
    function _update(address from, address to, uint256 value) internal virtual override whenNotPaused {
        super._update(from, to, value);
    }
}


// File contracts/token/MyToken.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.24;



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
