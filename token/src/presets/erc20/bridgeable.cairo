use starknet::{ContractAddress, ClassHash};
use dojo::world::IWorldDispatcher;

#[dojo::interface]
trait IERC20BridgeablePreset<TState> {
    // IWorldProvider
    fn world(world: @IWorldDispatcher,) -> IWorldDispatcher;

    // IUpgradeable
    fn upgrade(ref world: IWorldDispatcher, new_class_hash: ClassHash);

    // IERC20Metadata
    fn decimals(world: @IWorldDispatcher,) -> u8;
    fn name(world: @IWorldDispatcher,) -> ByteArray;
    fn symbol(world: @IWorldDispatcher,) -> ByteArray;

    // IERC20MetadataTotalSupply
    fn total_supply(world: @IWorldDispatcher,) -> u256;

    // IERC20MetadataTotalSupplyCamel
    fn totalSupply(world: @IWorldDispatcher,) -> u256;

    // IERC20Balance
    fn balance_of(world: @IWorldDispatcher, account: ContractAddress) -> u256;
    fn transfer(ref world: IWorldDispatcher, recipient: ContractAddress, amount: u256) -> bool;
    fn transfer_from(
        ref world: IWorldDispatcher, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;

    // IERC20BalanceCamel
    fn balanceOf(world: @IWorldDispatcher, account: ContractAddress) -> u256;
    fn transferFrom(
        ref world: IWorldDispatcher, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;

    // IERC20Allowance
    fn allowance(world: @IWorldDispatcher, owner: ContractAddress, spender: ContractAddress) -> u256;
    fn approve(ref world: IWorldDispatcher, spender: ContractAddress, amount: u256) -> bool;

    // IERC20Bridgeable
    fn burn(ref world: IWorldDispatcher, account: ContractAddress, amount: u256);
    fn l2_bridge_address(world: @IWorldDispatcher,) -> ContractAddress;
    fn mint(ref world: IWorldDispatcher, recipient: ContractAddress, amount: u256);

    // WITHOUT INTERFACE !!!
    fn initializer(
        ref world: IWorldDispatcher,
        name: ByteArray,
        symbol: ByteArray,
        initial_supply: u256,
        recipient: ContractAddress,
        l2_bridge_address: ContractAddress
    );
    fn dojo_resource(world: @IWorldDispatcher,) -> felt252;
}


///
/// Interface required to remove compiler warnings and future
/// deprecation.
///
#[dojo::interface]
trait IERC20BridgeableInitializer<TState> {
    fn initializer(
        ref world: IWorldDispatcher,
        name: ByteArray,
        symbol: ByteArray,
        initial_supply: u256,
        recipient: ContractAddress,
        l2_bridge_address: ContractAddress
    );
}

#[dojo::contract]
mod ERC20Bridgeable {
    use integer::BoundedInt;
    use starknet::ContractAddress;
    use starknet::{get_caller_address, get_contract_address};
    use zeroable::Zeroable;

    use token::components::security::initializable::initializable_component;

    use token::components::token::erc20::erc20_metadata::erc20_metadata_component;
    use token::components::token::erc20::erc20_balance::erc20_balance_component;
    use token::components::token::erc20::erc20_allowance::erc20_allowance_component;
    use token::components::token::erc20::erc20_mintable::erc20_mintable_component;
    use token::components::token::erc20::erc20_burnable::erc20_burnable_component;
    use token::components::token::erc20::erc20_bridgeable::erc20_bridgeable_component;

    component!(path: initializable_component, storage: initializable, event: InitializableEvent);

    component!(path: erc20_metadata_component, storage: erc20_metadata, event: ERC20MetadataEvent);
    component!(path: erc20_balance_component, storage: erc20_balance, event: ERC20BalanceEvent);
    component!(
        path: erc20_allowance_component, storage: erc20_allowance, event: ERC20AllowanceEvent
    );
    component!(path: erc20_mintable_component, storage: erc20_mintable, event: ERC20MintableEvent);
    component!(path: erc20_burnable_component, storage: erc20_burnable, event: ERC20BurnableEvent);
    component!(
        path: erc20_bridgeable_component, storage: erc20_bridgeable, event: ERC20BridgeableEvent
    );

    #[storage]
    struct Storage {
        #[substorage(v0)]
        initializable: initializable_component::Storage,
        #[substorage(v0)]
        erc20_metadata: erc20_metadata_component::Storage,
        #[substorage(v0)]
        erc20_balance: erc20_balance_component::Storage,
        #[substorage(v0)]
        erc20_allowance: erc20_allowance_component::Storage,
        #[substorage(v0)]
        erc20_mintable: erc20_mintable_component::Storage,
        #[substorage(v0)]
        erc20_burnable: erc20_burnable_component::Storage,
        #[substorage(v0)]
        erc20_bridgeable: erc20_bridgeable_component::Storage,
    }

    #[event]
    #[derive(Copy, Drop, starknet::Event)]
    enum Event {
        InitializableEvent: initializable_component::Event,
        ERC20MetadataEvent: erc20_metadata_component::Event,
        ERC20BalanceEvent: erc20_balance_component::Event,
        ERC20AllowanceEvent: erc20_allowance_component::Event,
        ERC20MintableEvent: erc20_mintable_component::Event,
        ERC20BurnableEvent: erc20_burnable_component::Event,
        ERC20BridgeableEvent: erc20_bridgeable_component::Event,
    }

    mod Errors {
        const CALLER_IS_NOT_OWNER: felt252 = 'ERC20: caller is not owner';
    }


    impl InitializableImpl = initializable_component::InitializableImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC20MetadataImpl =
        erc20_metadata_component::ERC20MetadataImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC20MetadataTotalSupplyImpl =
        erc20_metadata_component::ERC20MetadataTotalSupplyImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC20MetadataTotalSupplyCamelImpl =
        erc20_metadata_component::ERC20MetadataTotalSupplyCamelImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC20BalanceImpl =
        erc20_balance_component::ERC20BalanceImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC20BalanceCamelImpl =
        erc20_balance_component::ERC20BalanceCamelImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC20AllowanceImpl =
        erc20_allowance_component::ERC20AllowanceImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC20BridgeableImpl =
        erc20_bridgeable_component::ERC20BridgeableImpl<ContractState>;


    //
    // Internal Impls
    //

    impl InitializableInternalImpl = initializable_component::InternalImpl<ContractState>;
    impl ERC20MetadataInternalImpl = erc20_metadata_component::InternalImpl<ContractState>;
    impl ERC20BalanceInternalImpl = erc20_balance_component::InternalImpl<ContractState>;
    impl ERC20AllowanceInternalImpl = erc20_allowance_component::InternalImpl<ContractState>;
    impl ERC20MintableInternalImpl = erc20_mintable_component::InternalImpl<ContractState>;
    impl ERC20BurnableInternalImpl = erc20_burnable_component::InternalImpl<ContractState>;
    impl ERC20BridgeableInternalImpl = erc20_bridgeable_component::InternalImpl<ContractState>;

    //
    // Initializer
    //

    #[abi(embed_v0)]
    impl ERC20InitializerImpl of super::IERC20BridgeableInitializer<ContractState> {
        fn initializer(
            ref world: IWorldDispatcher,
            name: ByteArray,
            symbol: ByteArray,
            initial_supply: u256,
            recipient: ContractAddress,
            l2_bridge_address: ContractAddress,
        ) {
            assert(
                self.world().is_owner(get_caller_address(), get_contract_address().into()),
                Errors::CALLER_IS_NOT_OWNER
            );

            self.erc20_metadata.initialize(name, symbol, 18);
            self.erc20_mintable.mint(recipient, initial_supply);
            self.erc20_bridgeable.initialize(l2_bridge_address);

            self.initializable.initialize();
        }
    }
}
