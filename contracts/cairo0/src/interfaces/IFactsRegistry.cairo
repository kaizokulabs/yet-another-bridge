%lang starknet

from starkware.cairo.common.uint256 import Uint256

struct StorageSlot {
    word_1: felt,
    word_2: felt,
    word_3: felt,
    word_4: felt,
}

@contract_interface
namespace IFactsRegistry {
  func get_storage(
      block: felt,
      account_160: felt,
      slot: StorageSlot,
      proof_sizes_bytes_len: felt,
      proof_sizes_bytes: felt*,
      proof_sizes_words_len: felt,
      proof_sizes_words: felt*,
      proofs_concat_len: felt,
      proofs_concat: felt*,
  ) -> (res_bytes_len: felt, res_len: felt, res: felt*) {
  }

  func get_storage_uint(
      block: felt,
      account_160: felt,
      slot: StorageSlot,
      proof_sizes_bytes_len: felt,
      proof_sizes_bytes: felt*,
      proof_sizes_words_len: felt,
      proof_sizes_words: felt*,
      proofs_concat_len: felt,
      proofs_concat: felt*,
  ) -> (res: Uint256) {
  }
}
