use starknet::ContractAddress;

#[starknet::interface]
trait IYABETH<TContractState> {
    fn mint(ref self: TContractState, account: ContractAddress, amount: u256);
}

#[starknet::contract]
mod YABETH {
    use starknet::{get_caller_address, ContractAddress};
    use openzeppelin::access::ownable::Ownable;
    use openzeppelin::token::erc20::ERC20;
    use openzeppelin::token::erc20::interface::IERC20;
    use super::IYABETH;

    #[storage]
    struct Storage {}

    #[constructor]
    fn constructor(ref self: ContractState) {
        let mut unsafe_state = Ownable::unsafe_new_contract_state();
        let owner = get_caller_address();
        Ownable::InternalImpl::initializer(ref unsafe_state, owner);

        let name = 'YABEther';
        let symbol = 'yabETH';

        let mut unsafe_state = ERC20::unsafe_new_contract_state();
        ERC20::InternalImpl::initializer(ref unsafe_state, name, symbol);
    }


    #[external(v0)]
    impl YABTokenImpl of IYABETH<ContractState> {
        fn mint(
            ref self: ContractState,
            account: ContractAddress,
            amount: u256
        ) {
            // This function can only be called by the bridge
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);

            let mut unsafe_state = ERC20::unsafe_new_contract_state();
            ERC20::InternalImpl::_mint(ref unsafe_state, account, amount);
        }
    }

    // ERC20 Impl
    #[external(v0)]
    impl IERC20Impl of IERC20<ContractState> {
        fn name(self: @ContractState) -> felt252 {
            let unsafe_state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::name(@unsafe_state)
        }

        fn symbol(self: @ContractState) -> felt252 {
            let unsafe_state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::symbol(@unsafe_state)
        }

        fn decimals(self: @ContractState) -> u8 {
            let unsafe_state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::decimals(@unsafe_state)
        }

        fn total_supply(self: @ContractState) -> u256 {
            let unsafe_state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::total_supply(@unsafe_state)
        }

        fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
            let unsafe_state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::balance_of(@unsafe_state, account)
        }

        fn allowance(
            self: @ContractState, owner: ContractAddress, spender: ContractAddress
        ) -> u256 {
            let unsafe_state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::allowance(@unsafe_state, owner, spender)
        }

        fn transfer(ref self: ContractState, recipient: ContractAddress, amount: u256) -> bool {
            let mut unsafe_state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::transfer(ref unsafe_state, recipient, amount)
        }

        fn transfer_from(
            ref self: ContractState,
            sender: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) -> bool {
            let mut unsafe_state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::transfer_from(ref unsafe_state, sender, recipient, amount)
        }

        fn approve(ref self: ContractState, spender: ContractAddress, amount: u256) -> bool {
            let mut unsafe_state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::approve(ref unsafe_state, spender, amount)
        }
    }
}
