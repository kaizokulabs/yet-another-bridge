# YAB - Yet Another Bridge

## Description

YAB is simple PoC lock and mint bridge from Ethereum to Starknet using Herodotus. The main objective is develop a functional prototype that allows to deposit an ERC-20 on an Ethereum Smart Contract and mint its equivalent in Starknet. The mint function will be allowed if and only if there is a valid Storage Proof created by Herodotus and registered in the Registry Factory.

## Architecture

### Smart Contracts

- Deposit contract: Contract with custody of the ERC-20 deposits in Ethereum. Users will send their tokens and a Storage Proof will be generate from the state of this contract.
- Mint Contract: Modified ERC-20 contract that allows users to mint tokens by verifying the Storage Proof of the Deposit Contract. Verifying the Storage Proofs is done by interacting with Herodotus Fact Registry.

## Next Steps

- [ ] Enable burn functionality
- [ ] Allow native ETH
