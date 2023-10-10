#!/bin/bash

cd solidity
ETH_CONTRACT_ADDRESS=`forge script scripts/Deploy.s.sol:Deploy --rpc-url goerli --broadcast | grep "Contract Address:" | awk '{print $3}'`

echo "ETH_CONTRACT_ADDRESS=$ETH_CONTRACT_ADDRESS"
