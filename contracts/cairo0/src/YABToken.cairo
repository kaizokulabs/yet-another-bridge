%lang starknet

from openzeppelin.token.erc20.library import ERC20

// Getters ERC20

@view
func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
    return ERC20.name();
}

@view
func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (symbol: felt) {
    return ERC20.symbol();
}

@view
func totalSupply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (totalSupply: Uint256) {
    let (totalSupply) = ERC20.total_supply();
    return (totalSupply,);
}

@view
func decimals{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (decimals: felt) {
    return ERC20.decimals();
}

@view
func balanceOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(account: felt) -> (balance: Uint256) {
    return ERC20.balance_of(account);
}

@view
func allowance{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(owner: felt, spender: felt) -> (remaining: Uint256) {
    return ERC20.allowance(owner, spender);
}

// External ERC20

@external
func transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(recipient: felt, amount: Uint256) -> (success: felt) {
    let (from_) = get_caller_address();
    incentivized_erc20_before_token_transfer(from_, recipient);
    ERC20.transfer(recipient, amount);
    return (TRUE,);
}

@external
func transferFrom{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(sender: felt, recipient: felt, amount: Uint256) -> (success: felt) {
    incentivized_erc20_before_token_transfer(sender, recipient);
    ERC20.transfer_from(sender, recipient, amount);
    return (TRUE,);
}

@external
func approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(spender: felt, amount: Uint256) -> (success: felt) {
    ERC20.approve(spender, amount);
    return (TRUE,);
}

@external
func increaseAllowance{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(spender: felt, added_value: Uint256) -> (success: felt) {
    ERC20.increase_allowance(spender, added_value);
    return (TRUE,);
}

@external
func decreaseAllowance{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(spender: felt, subtracted_value: Uint256) -> (success: felt) {
    ERC20.decrease_allowance(spender, subtracted_value);
    return (TRUE,);
}

@external
func mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(recipient: felt, amount: Uint256) {
    ERC20._mint(recipient, amount);
    return ();
}

@external
func burn{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(account: felt, amount: Uint256) {
    ERC20._burn(account, amount);
    return ();
}
