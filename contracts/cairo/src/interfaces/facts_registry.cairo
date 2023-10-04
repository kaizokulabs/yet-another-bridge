#[derive(Serde, Drop)]
struct StorageSlot {
    word_1: felt252,
    word_2: felt252,
    word_3: felt252,
    word_4: felt252
}

#[starknet::interface]
trait IFactsRegistry<T> {
    fn get_storage(
        self: T,
        block: felt252,
        account_160: felt252,
        slot: StorageSlot,
        proof_sizes_bytes_len: felt252,
        proof_sizes_bytes: Array<felt252>,
        proof_sizes_words_len: felt252,
        proof_sizes_words: Array<felt252>,
        proofs_concat_len: felt252,
        proofs_concat: Array<felt252>
    ) -> Array<felt252>;

    fn get_storage_uint(
        self: T,
        block: felt252,
        account_160: felt252,
        slot: StorageSlot,
        proof_sizes_bytes_len: felt252,
        proof_sizes_bytes: Array<felt252>,
        proof_sizes_words_len: felt252,
        proof_sizes_words: Array<felt252>,
        proofs_concat_len: felt252,
        proofs_concat: Array<felt252>
    ) -> u256;
}
