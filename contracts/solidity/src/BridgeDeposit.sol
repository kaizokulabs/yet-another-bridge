// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.21;

contract BridgeDeposit {
    struct DepositInfo {
        uint256 destAddress;
        uint128 destChainId;
        uint128 amount;
    }

    event Deposit(uint256 indexed depositId, address depositor, DepositInfo depositInfo);

    uint256 public currentDepositId = 0;

    // depositId => DepositInfo
    mapping(uint256 => DepositInfo) public deposits;

    function deposit(
        DepositInfo calldata depositInfo
    ) payable external {
        assert(msg.value == depositInfo.amount);

        deposits[currentDepositId] = depositInfo;
        currentDepositId += 1;

        emit Deposit(currentDepositId, msg.sender, depositInfo);
    }
}
