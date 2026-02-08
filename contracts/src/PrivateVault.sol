// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "forge-std/interfaces/IERC20.sol";

/// @title PrivateVault
/// @notice Privacy-preserving DeFi vault for COTI V2
/// @dev Designed for COTI's confidential computation layer
contract PrivateVault {
    struct Deposit {
        address token;
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => Deposit[]) private deposits;
    mapping(address => mapping(address => uint256)) private balances;

    event Deposited(address indexed user, address indexed token, uint256 amount);
    event Withdrawn(address indexed user, address indexed token, uint256 amount);

    function deposit(address token, uint256 amount) external {
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        balances[msg.sender][token] += amount;
        deposits[msg.sender].push(Deposit(token, amount, block.timestamp));
        emit Deposited(msg.sender, token, amount);
    }

    function withdraw(address token, uint256 amount) external {
        require(balances[msg.sender][token] >= amount, "insufficient balance");
        balances[msg.sender][token] -= amount;
        IERC20(token).transfer(msg.sender, amount);
        emit Withdrawn(msg.sender, token, amount);
    }

    function getBalance(address token) external view returns (uint256) {
        return balances[msg.sender][token];
    }

    function getDepositCount() external view returns (uint256) {
        return deposits[msg.sender].length;
    }
}
