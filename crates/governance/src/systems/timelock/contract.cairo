#[dojo::contract]
mod timelock {
    use origami_governance::libraries::events::timelockevents;
    use origami_governance::models::timelock::{PendingAdmin, QueuedTransactions, TimelockParams};
    use origami_governance::systems::timelock::interface::ITimelock;
    use starknet::{
        ContractAddress, ClassHash, get_caller_address, get_block_timestamp, get_contract_address,
        Zeroable
    };

    // The following constants are defined is seconds based on the Compounds Timelock contract,
    // but can be adjusted to fit the needs of the project.
    const GRACE_PERIOD: u64 = 1_209_600; // 14 days
    const MINIMUM_DELAY: u64 = 172_800; // 2 days;
    const MAXIMUM_DELAY: u64 = 2_592_000; // 30 days;

    #[abi(embed_v0)]
    impl TimelockImpl of ITimelock<ContractState> {
        fn initialize(ref world: IWorldDispatcher, admin: ContractAddress, delay: u64) {
            assert!(!admin.is_zero(), "Timelock::initialize: Admin address cannot be zero.");
            assert!(
                delay >= MINIMUM_DELAY, "Timelock::initialize: Delay must exceed minimum delay."
            );
            assert!(
                delay <= MAXIMUM_DELAY, "Timelock::initialize: Delay must not exceed maximum delay."
            );

            let contract_selector = self.selector();
            let curr_params = get!(world, contract_selector, TimelockParams);
            assert!(
                curr_params.admin == Zeroable::zero(), "Timelock::initialize: Already initialized."
            );
            set!(world, TimelockParams { contract_selector, admin, delay });
            emit!(
                world,
                timelockevents::NewAdmin { contract_selector, address: admin },
                timelockevents::NewDelay { contract_selector, value: delay }
            );
        }

        fn execute_transaction(
            ref world: IWorldDispatcher,
            target_selector: felt252,
            new_implementation: ClassHash,
            eta: u64
        ) {
            let params = get!(world, self.selector(), TimelockParams);
            assert!(
                get_caller_address() == params.admin,
                "Timelock::execute_transaction: Call must come from admin."
            );
            let queued_tx = get!(world, (target_selector, new_implementation), QueuedTransactions);
            assert!(
                queued_tx.queued, "Timelock::execute_transaction: Transaction hasn't been queued."
            );
            let timestamp = get_block_timestamp();
            assert!(
                timestamp >= eta,
                "Timelock::execute_transaction: Transaction hasn't surpassed time lock."
            );
            assert!(
                timestamp <= eta + GRACE_PERIOD,
                "Timelock::execute_transaction: Transaction is stale."
            );
            set!(
                world,
                QueuedTransactions {
                    contract_selector: target_selector,
                    class_hash: new_implementation,
                    queued: false
                }
            );
            let upgraded_class_hash = world.upgrade_contract(target_selector, new_implementation);
            emit!(
                world,
                timelockevents::ExecuteTransaction {
                    target_selector, class_hash: upgraded_class_hash, eta
                }
            );
        }

        fn que_transaction(
            ref world: IWorldDispatcher,
            target_selector: felt252,
            new_implementation: ClassHash,
            eta: u64
        ) {
            let params = get!(world, self.selector(), TimelockParams);
            assert!(
                get_caller_address() == params.admin,
                "Timelock::queue_transaction: Call must come from admin."
            );
            assert!(
                eta >= get_block_timestamp() + params.delay,
                "Timelock::queue_transaction: Estimated execution block must satisfy delay."
            );
            set!(
                world,
                QueuedTransactions {
                    contract_selector: target_selector, class_hash: new_implementation, queued: true
                }
            );
            emit!(
                world,
                timelockevents::QueueTransaction {
                    target_selector, class_hash: new_implementation, eta
                }
            );
        }

        fn cancel_transaction(
            ref world: IWorldDispatcher,
            target_selector: felt252,
            new_implementation: ClassHash,
            eta: u64
        ) {
            let params = get!(world, get_contract_address(), TimelockParams);
            assert!(
                get_caller_address() == params.admin,
                "Timelock::cancel_transaction: Call must come from admin."
            );
            set!(
                world,
                QueuedTransactions {
                    contract_selector: target_selector,
                    class_hash: new_implementation,
                    queued: false
                }
            );
            emit!(
                world,
                timelockevents::CancelTransaction {
                    target_selector, class_hash: new_implementation, eta
                }
            );
        }
    }
}
