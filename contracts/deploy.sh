#!/bin/bash

cd /contracts/solidity

#echo `PRIVATE_KEY="$ETH_PRIV_KEY"` > .env
#echo `GOERLI_RPC_URL="$ETH_GOERLI_RPC_URL"` >> .env
#echo `ETHERSCAN_API_KEY="$ETHERSCAN_API_KEY"` >> .env

ETH_BRIDGE_ADDRESS=`~/.foundry/bin/forge script script/Deploy.s.sol:Deploy --rpc-url goerli --broadcast | grep "Contract Address:" | awk '{print $3}'`

echo "ETH_BRIDGE_ADDRESS=$ETH_BRIDGE_ADDRESS"
echo "ETH_BRIDGE_ADDRESS=$ETH_BRIDGE_ADDRESS" >> /contracts/app/.env
