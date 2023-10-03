%lang starknet

from openzeppelin.access.accesscontrol.library import AccessControl

import src.YABToken

const BRIDGE_ROLE = 0x08fb31c3e81624356c3314088aa971b73bcc82d22bc3e3b184b4593077ae327

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (contract_address: felt) = get_contract_address();
    let (caller_address: felt) = get_caller_address();

    AccessControl.initializer();
    AccessControl._grant_role(BRIDGE_ROLE, contract_address);

    // TODO: this grant is just used for testing purposes on PoC
    // should be removed in any non PoC context
    AccessControl._grant_role(BRIDGE_ROLE, caller_address);

    return ();
}

@external
func withdraw{recipient: felt, amount: felt}() {
    AccessControl.assert_only_role(BRIDGE_ROLE);

    // TODO: verify facts registry and mint token
    // think about how to avoid double minting
}
