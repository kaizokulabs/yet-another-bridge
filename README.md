# YAB - Yet Another Bridge

> <picture>
>   <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/Mqxx/GitHub-Markdown/main/blockquotes/badge/light-theme/danger.svg">
>   <img alt="Danger" src="https://raw.githubusercontent.com/Mqxx/GitHub-Markdown/main/blockquotes/badge/dark-theme/danger.svg">
> </picture><br>
>
> This bridge is highly experimental, interacting with it will lead to loss of funds!

## Description

YAB is simple PoC lock and mint bridge from Ethereum to Starknet using Herodotus. The main objective is develop a functional prototype that allows to deposit a native ETH on an Ethereum Smart Contract and mint its equivalent in Starknet. The mint function will be allowed if and only if there is a valid Storage Proof created by Herodotus and registered in the FactRegistry.

## Architecture

![image](https://github.com/kaizokulabs/yet-another-bridge/assets/13773225/d7c72ccc-26d2-4acd-8d08-2fd213ad9f08)


## Things to note

### Double Spending

In a naive architecture there would be 2 possible ways of double spending, here is how to fix it:

- **Same chain double spending:** to prevent this we need to use deposit IDs (or a nonce) and keep track of which ones have been consumed on the destination chain. The deposit ID can be incremental.
- **Different chain double spending:** to prevent this we need to add the target chain ID and when minting tokens we have to verify if the chain ID matches. For non-EVM chains (e.g. Starknet), we need to use a predefined chain ID

### Deposit address type

The `destinationAddress` field on the `DepositInfo` chain **MUST NOT** be of address type. While this works on EVM chains, it might not work on non-EVM chains where address sizes differ. For example, the address type on EVM can hold 20 bytes but Starknet addresses are ~31 bytes.

### Off-chain Logic

In the current version of Herodotus to prove facts to the facts registry we need to perform 1 off-chain request (the newer version will not require this and can be 100% on chain).

The request to the Herodotus API is done when the user deposit is confirmed on the origin chain, which will generate a task ID. We need to wait for the task status to be completed in order to withdraw the funds on the destination chain. The process of querying the status of the task is done on the client side and the pending IDs are stored in the browser cookies.

Alternatively, we can have a server constantly listening for deposit events, sending the requests to the Herodotus API, and calling the withdrawal on the destination chain. This solution doesn’t require continually polling the Herodotus API for the task status, due to the webhooks integration available on the API.

### Withdrawing / Minting process

This will require 1 tx on the target chain. To send the tx the users will need to wait until Herodotus updates the Fact Registry with the required task (as described in the off-chain section).

Once the withdrawal function is called on the destination chain, we mint new yabETH tokens that can be exchanged 1:1 with ETH.


## Next Steps

- [ ] Enable burn functionality
- [ ] Replace off-chain logic for a server instead of the frontend
