use yab::interfaces::herodotus::{StorageProof, StorageSlot};

#[starknet::interface]
trait IBridgeTarget<TContractState> {
    fn get_used_deposit(self: @TContractState, deposit_id: u256) -> bool;

    fn withdraw(
        ref self: TContractState, 
        deposit_id: u256,
        block: felt252,
        slot: StorageSlot,
        proof_0: StorageProof,
        proof_1: StorageProof
    );
}

#[starknet::contract]
mod BridgeTarget {
    use starknet::ContractAddress;
    use yab::yab_eth::{IYABETHDispatcher, IYABETHDispatcherTrait};
    use yab::interfaces::herodotus::{StorageProof, StorageSlot, IFactsRegistryDispatcher, IFactsRegistryDispatcherTrait};

    const HERODOTUS_FACTS_REGISTRY: felt252 = 0x07c88f02f0757b25547af4d946445f92dbe3416116d46d7b2bd88bcfad65a06f;
    const ETH_DEPOSIT_CONTRACT: felt252 = 0x0;
    const CHAIN_ID: u128 = 0x534e5f474f45524c49;

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Withdraw: Withdraw,
    }

    #[derive(Drop, starknet::Event)]
    struct Withdraw {
        #[key]
        deposit_id: u256,
        address: ContractAddress,
        amount: u128
    }

    #[storage]
    struct Storage {
        yab_eth: ContractAddress,
        used_deposits: LegacyMap::<u256, bool>
    }

    #[constructor]
    fn constructor(ref self: ContractState, yab_eth: ContractAddress) {
        self.yab_eth.write(yab_eth);
    }

    #[external(v0)]
    impl BridgeTarget of super::IBridgeTarget<ContractState> {
        fn get_used_deposit(self: @ContractState, deposit_id: u256) -> bool {
            self.used_deposits.read(deposit_id)
        }

        fn withdraw(
            ref self: ContractState, 
            deposit_id: u256,
            block: felt252,
            slot: StorageSlot,
            proof_0: StorageProof,
            proof_1: StorageProof
        ) {
            // 1. Verify deposit has not been used
            assert(!self.used_deposits.read(deposit_id), 'Deposit already used');

            // 2. Read deposit info from the facts registry

            //struct DepositInfo {
                //uint256 destAddress;
                //uint128 destChainId;
                //uint128 amount;
            //}

            let mut slot_1 = slot.clone();
            slot_1.word_4 += 1;

            let slot_0 = slot;

            // Slot n contains the address of the recipient
            let slot_0_value = IFactsRegistryDispatcher { contract_address: HERODOTUS_FACTS_REGISTRY.try_into().unwrap() }.get_storage_uint(
                block,
                ETH_DEPOSIT_CONTRACT,
                slot_0,
                proof_0.proof_sizes_bytes_len,
                proof_0.proof_sizes_bytes,
                proof_0.proof_sizes_words_len,
                proof_0.proof_sizes_words,
                proof_0.proofs_concat_len,
                proof_0.proofs_concat
            );
            let address_felt252: felt252 = slot_0_value.try_into().expect('Invalid address');
            let address: ContractAddress = address_felt252.try_into().unwrap();

            // Slot n+1 contains the chainId and amount
            let slot_1_value = IFactsRegistryDispatcher { contract_address: HERODOTUS_FACTS_REGISTRY.try_into().unwrap() }.get_storage_uint(
                block,
                ETH_DEPOSIT_CONTRACT,
                slot_1,
                proof_1.proof_sizes_bytes_len,
                proof_1.proof_sizes_bytes,
                proof_1.proof_sizes_words_len,
                proof_1.proof_sizes_words,
                proof_1.proofs_concat_len,
                proof_1.proofs_concat
            );

            let chain_id = slot_1_value.high;
            let amount = slot_1_value.low;

            // 3. Verify chain id
            assert(chain_id == CHAIN_ID, 'Invalid chain id');

            // 4. Mark deposit as used
            self.used_deposits.write(deposit_id, true);

            // 5. Mint tokens
            IYABETHDispatcher { contract_address: self.yab_eth.read() }.mint(address, amount.into());

            self.emit(Withdraw {
                deposit_id,
                address,
                amount
            });
        }
    }
}
