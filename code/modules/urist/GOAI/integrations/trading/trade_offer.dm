
/datum/trade_offer
	// A one-off *offer* to exchange resources/services between two parties at fixed prices.
	// This is approximately a generalized commodity option/forward contract
	// (which exactly depends on whether it can be discarded once bound or not).
	// DO NOT confuse this with a trade_contract. A Contract is a 'bound' Offer.

	// Whether the offer is standing, independent of the expiry time.
	// Primarily meant for invalidating already bound offers.
	var/is_open = TRUE

	// So that we can put these into a hugh jass array and assign the index from the array here for tracking.
	var/id = null

	// Who is offering
	var/creator = null

	// Who is receiving the offer - optional, null means open to all
	var/receiver = null

	// String key of what we're trading
	var/commodity_key

	// Positive amount A implies receiver buying A units from creator
	// Negative amount A implies receiver selling A units to creator
	var/commodity_amount = 0

	// Positive price P implies receiver transferring P credits to creator
	// Negative price P implies receiver will receive P credits from creator
	var/cash_value = 0

	// The keys in both assocs should match. Null values shall be assumed to be zero.

	// Note that prices and amounts' signs are independent.
	// +A & +P is a regular buy
	// -A & -P is a regular sell
	// +A & -P is a disposal contract to receiver (take our trash and we'll pay you)
	// -A & +P is a disposal contract to creator (we'll take your trash, for a price)

	// When does the offer go away. Can be null for always valid.
	var/expiry_time = null

	// If bound as a contract, when will that contract expire.
	// This is distinct from the *offer* expiring - this represents by when the services shall be rendered.
	// Can be null for always valid.
	var/deadline = null

	/* All this is just used for (optionally) setting/overriding the contract's corresponding vars: */
	var/on_completion_proc = null
	var/on_failure_proc = null

	var/list/on_completion_proc_args = null
	var/list/on_failure_proc_args = null


/datum/trade_offer/proc/Create(var/source, var/commodity_key, var/commodity_amt, var/cash_amt, var/expires_at = null, var/target = null, var/on_completed = null, var/on_failure = null, var/list/on_completed_args = null, var/list/on_failure_args = null)
	// Should possibly clean the ID/array here, but don't have a Big Ole Array for these yet.
	src.is_open = TRUE
	src.creator = source
	src.commodity_key = commodity_key
	src.commodity_amount = commodity_amt
	src.cash_value = cash_amt
	src.receiver = target

	SET_IF_NOT_NULL(expires_at, src.expiry_time)
	SET_IF_NOT_NULL(on_completed, src.on_completion_proc)
	SET_IF_NOT_NULL(on_failure, src.on_failure_proc)
	SET_IF_NOT_NULL(on_completed_args, src.on_completion_proc_args)
	SET_IF_NOT_NULL(on_failure_args, src.on_failure_proc_args)
	return


/datum/trade_offer/New(var/source, var/commodity_key, var/commodity_amt, var/cash_amt, var/expires_at = null, var/target = null, var/on_completed = null, var/on_failure = null, var/list/on_completed_args = null, var/list/on_failure_args = null)
	// We'll shunt the init to a custom proc so we can object-pool and reuse these.
	..()
	src.Create(source, commodity_key, commodity_amt, cash_amt, expires_at, target, on_completed, on_failure, on_completed_args, on_failure_args)
	return


