
/// 
/// An empty implementation of the ERC721BalanceHooksTrait
/// 
/// When the hook is not required, import together with the component:
/// use token::components::token::erc721::erc721_balance::erc721_balance_component;
/// use token::components::token::erc721::erc721_balance_hooks::ERC721BalanceHooksEmptyImpl;
/// 
/// Or implement your own (example on erc721_balance_hooks_mock.cairo)
/// 

use starknet::ContractAddress;
use token::components::token::erc721::erc721_balance::erc721_balance_component;

impl ERC721BalanceHooksEmptyImpl<TContractState> of erc721_balance_component::ERC721BalanceHooksTrait<TContractState> {
    fn before_transfer(
        ref self: erc721_balance_component::ComponentState<TContractState>,
        from: ContractAddress,
        to: ContractAddress,
        token_id: u256,
    ) {}
    fn after_transfer(
        ref self: erc721_balance_component::ComponentState<TContractState>,
        from: ContractAddress,
        to: ContractAddress,
        token_id: u256,
    ) {}
}
