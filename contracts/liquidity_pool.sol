// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LiquidityPool {
    IERC20 public tokenA; // Token A in the trading pair
    IERC20 public tokenB; // Token B in the trading pair
    address public owner;

    uint256 public reserveA; // Reserve of token A in the pool
    uint256 public reserveB; // Reserve of token B in the pool

    event LiquidityAdded(address indexed provider, uint256 amountA, uint256 amountB);
    event TokensSwapped(address indexed user, uint256 amountAIn, uint256 amountBOut);
    event CheckBalance(string text, uint amount);

    // Uncomment the constructor and complete argument details in scripts/deploy.ts to deploy the contract with arguments

    // constructor(address _tokenA, address _tokenB) {
    //     tokenA = IERC20(_tokenA);
    //     tokenB = IERC20(_tokenB);
    //     owner = msg.sender;
    // }

    // Add liquidity to the pool
    function addLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Amounts must be greater than zero");

        require(tokenA.transferFrom(msg.sender, address(this), amountA), "Transfer of tokenA failed");
        require(tokenB.transferFrom(msg.sender, address(this), amountB), "Transfer of tokenB failed");

        reserveA += amountA;
        reserveB += amountB;

        emit LiquidityAdded(msg.sender, amountA, amountB);
    }

    // Swap tokenA for tokenB or vice versa
    function swapTokens(uint256 amountAIn, uint256 amountBOut) external {
        require(amountAIn > 0 || amountBOut > 0, "At least one amount must be greater than zero");

        uint256 amountBIn = amountAIn * reserveB / reserveA;

        require(amountBIn > 0 && amountBIn <= reserveB, "Insufficient liquidity for the trade");

        require(tokenA.transferFrom(msg.sender, address(this), amountAIn), "Transfer of tokenA failed");
        require(tokenB.transfer(msg.sender, amountBOut), "Transfer of tokenB failed");

        reserveA += amountAIn;
        reserveB -= amountBIn;

        emit TokensSwapped(msg.sender, amountAIn, amountBOut);
    }
    
    function getBalance(address user_account) external returns (uint){
       string memory data = "User Balance is : ";
       uint user_bal = user_account.balance;
       emit CheckBalance(data, user_bal );
       return (user_bal);

    }
}
