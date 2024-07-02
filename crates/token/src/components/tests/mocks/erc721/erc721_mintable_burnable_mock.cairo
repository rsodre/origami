#[dojo::contract]
mod erc721_mintable_burnable_mock {
    use origami_token::components::introspection::src5::src5_component;
    use origami_token::components::token::erc721::erc721_approval::erc721_approval_component;
    use origami_token::components::token::erc721::erc721_balance::erc721_balance_component;
    use origami_token::components::token::erc721::erc721_metadata::erc721_metadata_component;
    use origami_token::components::token::erc721::erc721_metadata_hooks::ERC721MetadataHooksEmptyImpl;
    use origami_token::components::token::erc721::erc721_mintable::erc721_mintable_component;
    use origami_token::components::token::erc721::erc721_burnable::erc721_burnable_component;
    use origami_token::components::token::erc721::erc721_enumerable::erc721_enumerable_component;
    use origami_token::components::token::erc721::erc721_owner::erc721_owner_component;

    component!(path: src5_component, storage: src5, event: SRC5Event);
    component!(
        path: erc721_approval_component, storage: erc721_approval, event: ERC721ApprovalEvent
    );
    component!(path: erc721_balance_component, storage: erc721_balance, event: ERC721BalanceEvent);
    component!(
        path: erc721_metadata_component, storage: erc721_metadata, event: ERC721MetadataEvent
    );
    component!(
        path: erc721_mintable_component, storage: erc721_mintable, event: ERC721MintableEvent
    );
    component!(
        path: erc721_burnable_component, storage: erc721_burnable, event: ERC721BurnableEvent
    );
    component!(
        path: erc721_enumerable_component, storage: erc721_enumerable, event: ERC721EnumerableEvent
    );
    component!(path: erc721_owner_component, storage: erc721_owner, event: ERC721OwnerEvent);

    impl ERC721ApprovalInternalImpl = erc721_approval_component::InternalImpl<ContractState>;
    impl ERC721BalanceInternalImpl = erc721_balance_component::InternalImpl<ContractState>;
    impl ERC721MetadataInternalImpl = erc721_metadata_component::InternalImpl<ContractState>;
    impl ERC721MintableInternalImpl = erc721_mintable_component::InternalImpl<ContractState>;
    impl ERC721BurnableInternalImpl = erc721_burnable_component::InternalImpl<ContractState>;
    impl ERC721OwnerInternalImpl = erc721_owner_component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        src5: src5_component::Storage,
        #[substorage(v0)]
        erc721_approval: erc721_approval_component::Storage,
        #[substorage(v0)]
        erc721_balance: erc721_balance_component::Storage,
        #[substorage(v0)]
        erc721_metadata: erc721_metadata_component::Storage,
        #[substorage(v0)]
        erc721_mintable: erc721_mintable_component::Storage,
        #[substorage(v0)]
        erc721_burnable: erc721_burnable_component::Storage,
        #[substorage(v0)]
        erc721_enumerable: erc721_enumerable_component::Storage,
        #[substorage(v0)]
        erc721_owner: erc721_owner_component::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        SRC5Event: src5_component::Event,
        ERC721ApprovalEvent: erc721_approval_component::Event,
        ERC721BalanceEvent: erc721_balance_component::Event,
        ERC721MetadataEvent: erc721_metadata_component::Event,
        ERC721MintableEvent: erc721_mintable_component::Event,
        ERC721BurnableEvent: erc721_burnable_component::Event,
        ERC721EnumerableEvent: erc721_enumerable_component::Event,
        ERC721OwnerEvent: erc721_owner_component::Event
    }
}
