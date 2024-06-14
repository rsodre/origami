use starknet::{ContractAddress, ClassHash};
use dojo::world::IWorldDispatcher;

#[dojo::interface]
trait IERC721MintableBurnablePreset<TState> {
    // IERC721
    fn name(world: @IWorldDispatcher) -> ByteArray;
    fn symbol(world: @IWorldDispatcher) -> ByteArray;
    fn token_uri(ref world: IWorldDispatcher, token_id: u256) -> ByteArray;
    fn owner_of(world: @IWorldDispatcher, account: ContractAddress) -> bool;
    fn balance_of(world: @IWorldDispatcher, account: ContractAddress) -> u256;
    fn get_approved(world: @IWorldDispatcher, token_id: u256) -> ContractAddress;
    fn transfer_from(
        ref world: IWorldDispatcher, from: ContractAddress, to: ContractAddress, token_id: u256
    );
    fn approve(ref world: IWorldDispatcher, to: ContractAddress, token_id: u256);

    // IERC721CamelOnly
    fn tokenURI(ref world: IWorldDispatcher, token_id: u256) -> ByteArray;
    fn balanceOf(world: @IWorldDispatcher, account: ContractAddress) -> u256;
    fn transferFrom(
        ref world: IWorldDispatcher, from: ContractAddress, to: ContractAddress, token_id: u256
    );

    // IWorldProvider
    fn world(world: @IWorldDispatcher,) -> IWorldDispatcher;

    fn initializer(
        ref world: IWorldDispatcher,
        name: ByteArray,
        symbol: ByteArray,
        base_uri: ByteArray,
        recipient: ContractAddress,
        token_ids: Span<u256>
    );
    fn mint(ref world: IWorldDispatcher, to: ContractAddress, token_id: u256);
    fn burn(ref world: IWorldDispatcher, token_id: u256);
    fn dojo_resource(world: @IWorldDispatcher,) -> felt252;
}

#[dojo::interface]
trait IERC721MintableBurnableInit<TState> {
    fn initializer(
        ref world: IWorldDispatcher,
        name: ByteArray,
        symbol: ByteArray,
        base_uri: ByteArray,
        recipient: ContractAddress,
        token_ids: Span<u256>
    );
}

#[dojo::interface]
trait IERC721MintableBurnableMintBurn<TState> {
    fn mint(ref world: IWorldDispatcher, to: ContractAddress, token_id: u256);
    fn burn(ref world: IWorldDispatcher, token_id: u256);
}

#[dojo::interface]
trait IERC721Internal<TState> {
    fn mint_assets(
        ref world: IWorldDispatcher, recipient: ContractAddress,token_ids: Span<u256>
    );
}

#[dojo::contract]
mod ERC721MintableBurnable {
    use starknet::ContractAddress;
    use starknet::{get_caller_address, get_contract_address};
    use token::components::security::initializable::initializable_component;
    use token::components::token::erc721::erc721_approval::erc721_approval_component;
    use token::components::token::erc721::erc721_balance::erc721_balance_component;
    use token::components::token::erc721::erc721_burnable::erc721_burnable_component;
    use token::components::token::erc721::erc721_metadata::erc721_metadata_component;
    use token::components::token::erc721::erc721_mintable::erc721_mintable_component;
    use token::components::token::erc721::erc721_owner::erc721_owner_component;

    component!(path: initializable_component, storage: initializable, event: InitializableEvent);

    component!(
        path: erc721_approval_component, storage: erc721_approval, event: ERC721ApprovalEvent
    );
    component!(path: erc721_balance_component, storage: erc721_balance, event: ERC721BalanceEvent);
    component!(
        path: erc721_burnable_component, storage: erc721_burnable, event: ERC721BurnableEvent
    );
    component!(
        path: erc721_metadata_component, storage: erc721_metadata, event: ERC721MetadataEvent
    );
    component!(
        path: erc721_mintable_component, storage: erc721_mintable, event: ERC721MintableEvent
    );
    component!(path: erc721_owner_component, storage: erc721_owner, event: ERC721OwnerEvent);

    impl InitializableImpl = initializable_component::InitializableImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721ApprovalImpl =
        erc721_approval_component::ERC721ApprovalImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721ApprovalCamelImpl =
        erc721_approval_component::ERC721ApprovalCamelImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721BalanceImpl =
        erc721_balance_component::ERC721BalanceImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721BalanceCamelImpl =
        erc721_balance_component::ERC721BalanceCamelImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721MetadataImpl =
        erc721_metadata_component::ERC721MetadataImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721MetadataCamelImpl =
        erc721_metadata_component::ERC721MetadataCamelImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC721OwnerImpl = erc721_owner_component::ERC721OwnerImpl<ContractState>;

    impl InitializableInternalImpl = initializable_component::InternalImpl<ContractState>;
    impl ERC721ApprovalInternalImpl = erc721_approval_component::InternalImpl<ContractState>;
    impl ERC721BalanceInternalImpl = erc721_balance_component::InternalImpl<ContractState>;
    impl ERC721BurnableInternalImpl = erc721_burnable_component::InternalImpl<ContractState>;
    impl ERC721MetadataInternalImpl = erc721_metadata_component::InternalImpl<ContractState>;
    impl ERC721MintableInternalImpl = erc721_mintable_component::InternalImpl<ContractState>;
    impl ERC721OwnerInternalImpl = erc721_owner_component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        initializable: initializable_component::Storage,
        #[substorage(v0)]
        erc721_approval: erc721_approval_component::Storage,
        #[substorage(v0)]
        erc721_balance: erc721_balance_component::Storage,
        #[substorage(v0)]
        erc721_burnable: erc721_burnable_component::Storage,
        #[substorage(v0)]
        erc721_metadata: erc721_metadata_component::Storage,
        #[substorage(v0)]
        erc721_mintable: erc721_mintable_component::Storage,
        #[substorage(v0)]
        erc721_owner: erc721_owner_component::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        InitializableEvent: initializable_component::Event,
        ERC721ApprovalEvent: erc721_approval_component::Event,
        ERC721BalanceEvent: erc721_balance_component::Event,
        ERC721BurnableEvent: erc721_burnable_component::Event,
        ERC721MetadataEvent: erc721_metadata_component::Event,
        ERC721MintableEvent: erc721_mintable_component::Event,
        ERC721OwnerEvent: erc721_owner_component::Event,
    }

    mod Errors {
        const CALLER_IS_NOT_OWNER: felt252 = 'ERC721: caller is not owner';
    }

    #[abi(embed_v0)]
    impl ERC721InitializerImpl of super::IERC721MintableBurnableInit<ContractState> {
        fn initializer(
            ref world: IWorldDispatcher,
            name: ByteArray,
            symbol: ByteArray,
            base_uri: ByteArray,
            recipient: ContractAddress,
            token_ids: Span<u256>
        ) {
            assert(
                self.world().is_owner(get_caller_address(), get_contract_address().into()),
                Errors::CALLER_IS_NOT_OWNER
            );

            self.erc721_metadata.initialize(name, symbol, base_uri);
            self.mint_assets(recipient, token_ids);

            self.initializable.initialize();
        }
    }

    #[abi(embed_v0)]
    impl ERC721MintBurnImpl of super::IERC721MintableBurnableMintBurn<ContractState> {
        fn mint(ref world: IWorldDispatcher, to: ContractAddress, token_id: u256) {
            self.erc721_mintable.mint(to, token_id)
        }

        fn burn(ref world: IWorldDispatcher, token_id: u256) {
            self.erc721_burnable.burn(token_id)
        }
    }


    impl ERC721InternalImpl of super::IERC721Internal<ContractState> {
        fn mint_assets(
            ref world: IWorldDispatcher, recipient: ContractAddress, mut token_ids: Span<u256>
        ) {
            loop {
                if token_ids.len() == 0 {
                    break;
                }
                let id = *token_ids.pop_front().unwrap();

                self.erc721_mintable.mint(recipient, id);
            }
        }
    }
}
