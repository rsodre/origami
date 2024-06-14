use starknet::{ContractAddress, ClassHash};
use dojo::world::IWorldDispatcher;

#[dojo::interface]
trait IERC20BalanceMock<TState> {
    // IERC20
    fn total_supply(world: @IWorldDispatcher,) -> u256;
    fn balance_of(world: @IWorldDispatcher, account: ContractAddress) -> u256;
    fn allowance(world: @IWorldDispatcher, owner: ContractAddress, spender: ContractAddress) -> u256;
    fn transfer(ref world: IWorldDispatcher, recipient: ContractAddress, amount: u256) -> bool;
    fn transfer_from(
        ref world: IWorldDispatcher, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;
    fn approve(ref world: IWorldDispatcher, spender: ContractAddress, amount: u256) -> bool;

    // IERC20CamelOnly
    fn totalSupply(world: @IWorldDispatcher,) -> u256;
    fn balanceOf(world: @IWorldDispatcher, account: ContractAddress) -> u256;
    fn transferFrom(
        ref world: IWorldDispatcher, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;

    // IWorldProvider
    fn world(world: @IWorldDispatcher,) -> IWorldDispatcher;

    fn initializer(ref world: IWorldDispatcher, initial_supply: u256, recipient: ContractAddress,);
}

#[dojo::interface]
trait IERC20BalanceMockInit<TState> {
    fn initializer(ref world: IWorldDispatcher, initial_supply: u256, recipient: ContractAddress,);
}

#[dojo::contract]
mod erc20_balance_mock {
    use starknet::ContractAddress;
    use token::components::token::erc20::erc20_allowance::erc20_allowance_component;
    use token::components::token::erc20::erc20_balance::erc20_balance_component;

    component!(
        path: erc20_allowance_component, storage: erc20_allowance, event: ERC20AllowanceEvent
    );
    component!(path: erc20_balance_component, storage: erc20_balance, event: ERC20BalanceEvent);

    #[abi(embed_v0)]
    impl ERC20AllowanceImpl =
        erc20_allowance_component::ERC20AllowanceImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC20BalanceImpl =
        erc20_balance_component::ERC20BalanceImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC20BalanceCamelImpl =
        erc20_balance_component::ERC20BalanceCamelImpl<ContractState>;

    impl ERC20AllowanceInternalImpl = erc20_allowance_component::InternalImpl<ContractState>;
    impl ERC20BalanceInternalImpl = erc20_balance_component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc20_allowance: erc20_allowance_component::Storage,
        #[substorage(v0)]
        erc20_balance: erc20_balance_component::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ERC20AllowanceEvent: erc20_allowance_component::Event,
        ERC20BalanceEvent: erc20_balance_component::Event,
    }

    #[abi(embed_v0)]
    impl InitializerImpl of super::IERC20BalanceMockInit<ContractState> {
        fn initializer(ref world: IWorldDispatcher, initial_supply: u256, recipient: ContractAddress,) {
            // set balance for recipient
            self.erc20_balance.update_balance(recipient, 0, initial_supply);
        }
    }
}
