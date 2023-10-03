%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address, get_contract_address

from openzeppelin.access.accesscontrol.library import AccessControl

from interfaces.IFactsRegistry import IFactsRegistry, StorageSlot
from src.YABToken import initializer, mint

const BRIDGE_ROLE = 0x08fb31c3e81624356c3314088aa971b73bcc82d22bc3e3b184b4593077ae327;
// This seems to be the class hash
// the contract addr: 0x07c88f02f0757b25547af4d946445f92dbe3416116d46d7b2bd88bcfad65a06f
// validate which to use
const FACTS_REGISTRY_ADDRESS = 0x0183d02c1eab527004f479bef2709ad213ed5f54204754bbd0013324c5754d5c;

@storage_var
func _eth_bridge_address() -> (address: felt) {
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(eth_bridge_address: felt) {
    _eth_bridge_address.write(eth_bridge_address);
    initializer();

    AccessControl.initializer();
    let (contract_address: felt) = get_contract_address();
    AccessControl._grant_role(BRIDGE_ROLE, contract_address);

    // TODO: this grant is just used for testing purposes on PoC
    // should be removed in any non PoC context
    let (caller_address: felt) = get_caller_address();
    AccessControl._grant_role(BRIDGE_ROLE, caller_address);

    return ();
}

@external
func withdraw{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    recipient: felt,
    block: felt,
    slot: StorageSlot,
    proof_sizes_bytes_len: felt,
    proof_sizes_bytes: felt*,
    proof_sizes_words_len: felt,
    proof_sizes_words: felt*,
    proofs_concat_len: felt,
    proofs_concat: felt*,
) {
    alloc_locals;
    AccessControl.assert_only_role(BRIDGE_ROLE);

    let (local eth_bridge_address) = _eth_bridge_address.read();
    let (value: Uint256) = IFactsRegistry.get_storage_uint(
        contract_address=FACTS_REGISTRY_ADDRESS,
        block=block,
        account_160=eth_bridge_address,
        slot=slot,
        proof_sizes_bytes_len=proof_sizes_bytes_len,
        proof_sizes_bytes=proof_sizes_bytes,
        proof_sizes_words_len=proof_sizes_words_len,
        proof_sizes_words=proof_sizes_words,
        proofs_concat_len=proofs_concat_len,
        proofs_concat=proofs_concat,
    );

    // naive approach that mints the value in the passed struct
    // TODO:
    // - store transferId, and check if it was already transfered
    // - validate the recipient against eth bridge contract transferId
    mint(recipient, value);
    return ();
}

