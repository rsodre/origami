use starknet::ContractAddress;
use starknet::contract_address_const;

// const NAME: ByteArray = "NAME";
// const SYMBOL: ByteArray = "SYMBOL";
const DECIMALS: u8 = 18_u8;
const SUPPLY: u256 = 2000;
const VALUE: u256 = 300;
const ROLE: felt252 = 'ROLE';
const OTHER_ROLE: felt252 = 'OTHER_ROLE';
// const URI: ByteArray = "URI";
const TOKEN_ID: u256 = 21;
const TOKEN_AMOUNT: u256 = 42;
const TOKEN_ID_2: u256 = 2;
const TOKEN_ID_3: u256 = 78;
const TOKEN_AMOUNT_2: u256 = 69;
const PUBKEY: felt252 = 'PUBKEY';
const OTHER_ID: felt252 = 'OTHER_ID';
// const DATA: Span<felt252> = 'DATA'.span();

fn ADMIN() -> ContractAddress {
    contract_address_const::<'ADMIN'>()
}

fn AUTHORIZED() -> ContractAddress {
    contract_address_const::<'AUTHORIZED'>()
}

fn ZERO() -> ContractAddress {
    contract_address_const::<0>()
}

fn CALLER() -> ContractAddress {
    contract_address_const::<'CALLER'>()
}

fn OWNER() -> ContractAddress {
    contract_address_const::<'OWNER'>()
}

fn NEW_OWNER() -> ContractAddress {
    contract_address_const::<'NEW_OWNER'>()
}

fn OTHER() -> ContractAddress {
    contract_address_const::<'OTHER'>()
}

fn OTHER_ADMIN() -> ContractAddress {
    contract_address_const::<'OTHER_ADMIN'>()
}

fn SPENDER() -> ContractAddress {
    contract_address_const::<'SPENDER'>()
}

fn RECIPIENT() -> ContractAddress {
    contract_address_const::<'RECIPIENT'>()
}

fn OPERATOR() -> ContractAddress {
    contract_address_const::<'OPERATOR'>()
}

fn BRIDGE() -> ContractAddress {
    contract_address_const::<'BRIDGE'>()
}
