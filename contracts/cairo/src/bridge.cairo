
#[starknet::contract]
mod Bridge {
    use starknet::{
        get_caller_address,
        get_contract_address,
        contract_address_const,
        ContractAddress,
        EthAddress,
    };
    
    use openzeppelin::access::accesscontrol::AccessControl;

    use yab_cairo::yab_token::{IYABTokenDispatcherTrait, IYABTokenDispatcher};
    use yab_cairo::interfaces::facts_registry::{StorageSlot, IFactsRegistryDispatcherTrait, IFactsRegistryDispatcher};

    const BRIDGE_ROLE: felt252 = 'BRIDGE_ROLE';

    #[storage]
    struct Storage {
        token: ContractAddress,
        eth_bridge_address: EthAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState, eth_bridge_address: EthAddress) {
        self.eth_bridge_address.write(eth_bridge_address);
        //let token_addr = YABToken::constructor();
        //self.token.write(token_addr);

        let mut access_state = AccessControl::unsafe_new_contract_state();
        let contract_address = get_contract_address();
        AccessControl::InternalImpl::initializer(ref access_state);
        AccessControl::InternalImpl::_grant_role(
            ref access_state,
            BRIDGE_ROLE,
            contract_address
        );
        
        // TODO: this grant is just used for testing purposes on PoC
        // should be removed in any non PoC context
        let caller_address = get_caller_address();
        AccessControl::InternalImpl::_grant_role(
            ref access_state,
            BRIDGE_ROLE,
            caller_address
        );
    }

    #[external(v0)]
    fn withdraw(
        ref self: ContractState,
        recipient: ContractAddress,
        block: felt252,
        slot: StorageSlot,
        proof_sizes_bytes_len: felt252,
        proof_sizes_bytes: Array<felt252>,
        proof_sizes_words_len: felt252,
        proof_sizes_words: Array<felt252>,
        proofs_concat_len: felt252,
        proofs_concat: Array<felt252>,
    ) {
        let access_state = AccessControl::unsafe_new_contract_state();
        AccessControl::InternalImpl::assert_only_role(@access_state, BRIDGE_ROLE);

        // TODO: test removing some params (e.g. length)
        let amount = IFactsRegistryDispatcher {
            contract_address: contract_address_const::<0x041fd22b238fa21cfcf5dd45a8548974d8263b3a531a60388411c5e230f97023>()
            }.get_storage_uint(
                block,
                self.eth_bridge_address.read().into(),
                slot,
                proof_sizes_bytes_len,
                proof_sizes_bytes,
                proof_sizes_words_len,
                proof_sizes_words,
                proofs_concat_len,
                proofs_concat,
            );
    
        // naive approach that mints the value in the passed struct
        // TODO:
        // - store transferId, and check if it was already transfered
        // - validate the recipient against eth bridge contract transferId
        IYABTokenDispatcher {
            contract_address: self.token.read()
        }.mint(recipient, amount);
    }
}
