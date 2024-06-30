///
/// ERC721Burnable Component
///
#[starknet::component]
mod erc721_burnable_component {
    use starknet::ContractAddress;
    use starknet::get_contract_address;
    use dojo::world::{
        IWorldProvider, IWorldProviderDispatcher, IWorldDispatcher, IWorldDispatcherTrait
    };

    use origami_token::components::token::erc721::erc721_approval::erc721_approval_component as erc721_approval_comp;
    use origami_token::components::token::erc721::erc721_balance::erc721_balance_component as erc721_balance_comp;
    use origami_token::components::token::erc721::erc721_owner::erc721_owner_component as erc721_owner_comp;

    use erc721_approval_comp::InternalImpl as ERC721ApprovalInternal;
    use erc721_balance_comp::InternalImpl as ERC721BalanceInternal;
    use erc721_owner_comp::InternalImpl as ERC721OwnerInternal;


    #[storage]
    struct Storage {}

    #[generate_trait]
    impl InternalImpl<
        TContractState,
        +HasComponent<TContractState>,
        +IWorldProvider<TContractState>,
        impl ERC721Approval: erc721_approval_comp::HasComponent<TContractState>,
        impl ERC721Balance: erc721_balance_comp::HasComponent<TContractState>,
        impl ERC721Owner: erc721_owner_comp::HasComponent<TContractState>,
        +Drop<TContractState>,
    > of InternalTrait<TContractState> {
        fn burn(ref self: ComponentState<TContractState>, token_id: u256) {
            let mut erc721_balance = get_dep_component_mut!(ref self, ERC721Balance);
            let mut erc721_owner = get_dep_component_mut!(ref self, ERC721Owner);
            let owner = erc721_owner.get_owner(token_id).address;
            erc721_balance.transfer_internal(owner, Zeroable::zero(), token_id);
        }
    }
}
