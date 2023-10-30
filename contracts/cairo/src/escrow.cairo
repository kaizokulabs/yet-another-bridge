use yab::interfaces::herodotus::{StorageProof, StorageSlot};

#[starknet::interface]
trait IEscrow<TContractState> {
    fn get_deposits_list(self: @ContractState) -> Array<u256>;

    fn get_deposit(self: @ContractState, deposit_id: u256) -> Deposit;

    fn set_deposit(self: @ContractState, deposit_id: u256, deposit: Deposit);

    fn cancel_deposit(self: @ContractState, deposit_id: u256);

    fn get_deposit_status(self: @ContractState, deposit_id: u256) -> bool;

    fn get_reservation(self: @ContractState, deposit_id: u256) -> ContractAddress;

    fn set_reservation(self: @ContractState, deposit_id: u256, address: ContractAddress);

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
mod Escrow {
    use starknet::{ContractAddress, EthAddress};
    use yab::interfaces::herodotus::{
        StorageProof, StorageSlot, IFactsRegistryDispatcher, IFactsRegistryDispatcherTrait
    };

    const NATIVE_TOKEN: felt252 = 0x0;
    const HERODOTUS_FACTS_REGISTRY: felt252 =
        0x07c88f02f0757b25547af4d946445f92dbe3416116d46d7b2bd88bcfad65a06f;

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Deposit: Deposit,
    }

    #[derive(Drop, starknet::Event)]
    struct Deposit {
        #[key]
        deposit_id: u256,
        amount: u256,
        recipient_address: EthAddress,
        fee: u64,
        expiry: u64
    }

    #[storage]
    struct Storage {
        nonce: u256,
        deposits: LegacyMap::<u256, Deposit>,
        deposits_list: Array<u256>,
        deposits_status: LegacyMap::<u256, bool>,
        reservations: LegacyMap::<u256, ContractAddress>
    }

    #[constructor]
    fn constructor(ref self: ContractState, yab_eth: ContractAddress) {
        nonce = 0;
    }

    #[external(v0)]
    impl Escrow of super::IEscrow<ContractState> {
        fn get_deposits_list(self: @ContractState) -> Array<u256> {
            self.deposits_list
        }

        fn get_deposit(self: @ContractState, deposit_id: u256) -> Deposit {
            self.deposits.read(deposit_id)
        }

        fn set_deposit(self: @ContractState, deposit_id: u256, deposit: Deposit) {
            // TODO expiry can't be less than 24h
            self.deposits.write(deposit_id, deposit);
        }

        fn cancel_deposit(self: @ContractState, deposit_id: u256) {
            // TODO the deposit can be cancelled if no one reserved yet
            // the user can retrieve all the funds without waiting for the expiry
            self.deposits.remove(deposit_id);
        }

        fn get_deposit_status(self: @ContractState, deposit_id: u256) -> bool {
            self.deposits_status.read(deposit_id)
        }

        fn get_reservation(self: @ContractState, deposit_id: u256) -> ContractAddress {
            self.reservations.read(deposit_id)
        }

        fn set_reservation(self: @ContractState, deposit_id: u256, address: ContractAddress) {
            assert(!self.reservations.read(deposit_id), 'Deposit already reserved');
            // TODO validate if it's already reserved
            // stake amount to avoid DoS
            self.reservations.write(deposit_id, reservation);
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
            assert(!self.deposit_status.read(deposit_id), 'Deposit already used');
            assert(
                self.reservations.read(deposit_id) == msg.sender,
                'Message sender is not the person who reserved'
            );

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
            let slot_0_value = IFactsRegistryDispatcher {
                contract_address: HERODOTUS_FACTS_REGISTRY.try_into().unwrap()
            }
                .get_storage_uint(
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
            let slot_1_value = IFactsRegistryDispatcher {
                contract_address: HERODOTUS_FACTS_REGISTRY.try_into().unwrap()
            }
                .get_storage_uint(
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
            IYABETHDispatcher { contract_address: self.yab_eth.read() }
                .mint(address, amount.into());

            self.emit(Withdraw { deposit_id, address, amount });
        }
    }
}
