// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.13;

contract Bridge {
    mapping(address => uint256) public addrAmount;

    constructor() {}

    function deposit() external payable {
        addrAmount[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(addrAmount[msg.sender] >= amount, "Insufficient balance");
        addrAmount[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
}
