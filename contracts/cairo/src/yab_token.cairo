use starknet::ContractAddress;

#[starknet::interface]
trait IYABToken<T> {
    fn mint(self: @T, account: ContractAddress, amount: u256);
}

#[starknet::interface]
trait IERC20<T> {
    fn get_name(self: @T) -> felt252;
    fn get_symbol(self: @T) -> felt252;
    fn get_decimals(self: @T) -> u8;
    fn get_total_supply(self: @T) -> u256;
    fn balance_of(self: @T, account: ContractAddress) -> u256;
    fn allowance(self: @T, owner: ContractAddress, spender: ContractAddress) -> u256;
    fn transfer(ref self: T, recipient: ContractAddress, amount: u256);
    fn transfer_from(ref self: T, sender: ContractAddress, recipient: ContractAddress, amount: u256);
    fn approve(ref self: T, spender: ContractAddress, amount: u256);
    fn increase_allowance(ref self: T, spender: ContractAddress, added_value: u256);
    fn decrease_allowance(ref self: T, spender: ContractAddress, subtracted_value: u256);
}

#[starknet::contract]
mod YABToken {
    use starknet::{get_caller_address, ContractAddress};
    use openzeppelin::access::ownable::Ownable;
    use openzeppelin::token::erc20::ERC20;
    use openzeppelin::token::erc20::interface::IERC20;
    use super::IYABToken;

    #[storage]
    struct Storage { }

    #[constructor]
    fn constructor(ref self: ContractState) {
        let mut state = Ownable::unsafe_new_contract_state();
        let owner = get_caller_address();
        Ownable::InternalImpl::initializer(ref state, owner);

        let mut state = ERC20::unsafe_new_contract_state();
        ERC20::InternalImpl::initializer(ref state, 'YABEthereum', 'yabETH');
    }


    #[external(v0)]
    impl YABTokenImpl of IYABToken<ContractState> {
        fn mint(
            self: @ContractState,
            account: ContractAddress,
            amount: u256
        ) {
            // This function can only be called by the bridge
            let state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@state);

            let mut state = ERC20::unsafe_new_contract_state();
            ERC20::InternalImpl::_mint(ref state, account, amount);
        }
    }

    // ERC20 Impl
    #[external(v0)]
    impl IERC20Impl of IERC20<ContractState> {
        fn name(self: @ContractState) -> felt252 {
            let state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::name(@state)
        }

        fn symbol(self: @ContractState) -> felt252 {
            let state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::symbol(@state)
        }

        fn decimals(self: @ContractState) -> u8 {
            let state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::decimals(@state)
        }

        fn total_supply(self: @ContractState) -> u256 {
            let state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::total_supply(@state)
        }

        fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
            let state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::balance_of(@state, account)
        }

        fn allowance(
            self: @ContractState, owner: ContractAddress, spender: ContractAddress
        ) -> u256 {
            let state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::allowance(@state, owner, spender)
        }

        fn transfer(ref self: ContractState, recipient: ContractAddress, amount: u256) -> bool {
            let mut state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::transfer(ref state, recipient, amount)
        }

        fn transfer_from(
            ref self: ContractState,
            sender: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) -> bool {
            let mut state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::transfer_from(ref state, sender, recipient, amount)
        }

        fn approve(ref self: ContractState, spender: ContractAddress, amount: u256) -> bool {
            let mut state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::approve(ref state, spender, amount)
        }
    }
}
