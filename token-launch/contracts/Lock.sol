// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title Lock
 * @dev A simple time-locked contract for testing Hardhat setup.
 * @notice This is a sample contract for environment validation only.
 */
contract Lock {
    uint256 public unlockTime;
    address payable public owner;

    event Withdrawal(uint256 amount, uint256 when);

    constructor(uint256 _unlockTime) payable {
        require(
            block.timestamp < _unlockTime,
            "Lock: unlock time is in the past"
        );
        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }

    function withdraw() public {
        require(
            block.timestamp >= unlockTime,
            "Lock: you can't withdraw yet"
        );
        require(msg.sender == owner, "Lock: you are not the owner");

        emit Withdrawal(address(this).balance, block.timestamp);

        owner.transfer(address(this).balance);
    }
}
