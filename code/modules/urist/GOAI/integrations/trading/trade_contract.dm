
#define DEFAULT_TRADE_COMPLETION_PROC /proc/trade_apply_instant_abstract_success
#define DEFAULT_TRADE_FAILURE_PROC /proc/trade_apply_instant_abstract_failure

/datum/trade_contract
	/*
	// This is very nearly a copypasta of trade_offer. This is entirely on purpose.
	// A contract is a 'materialized' offer, so the parameters will be heavily aligned.
	// ...and if they ain't, we can add and remove values from this at will!
	*/

	// Whether the offer is standing, independent of the expiry time.
	// Primarily meant for invalidating fulfilled contracts.
	var/is_open = TRUE

	// A bitflag tracking the current state of the trade.
	// Use GOAI_CONTRACT_IS_COMPLETED(src.lifecycle_state) to check if the deal can be considered fulfilled.
	var/lifecycle_state = GOAI_CONTRACT_LIFECYCLE_INITIAL

	// Similar to lifecycle_state, auxiliary bitflag.
	// Tracks whether either party at least made *an effort* to fulfill the deal.
	var/progressed_state = GOAI_CONTRACT_LIFECYCLE_INITIAL

	// So that we can put these into a hugh jass array and assign the index from the array here for tracking.
	var/id = null

	// Who is offering
	var/creator = null

	// Who is receiving the offer
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
	// +A & -P is a disposal contract to holder (take our trash and we'll pay you)
	// -A & +P is a disposal contract to creator (we'll take your trash, for a price)

	// Deadline for fulfillment. Can be null for no limit for options.
	var/deadline = null

	// If there is a timer running, this will be set. This ensures only one expiry check happens.
	var/check_timer_id = null

	// Assoc list for storing each party's contributions to the deal so far.
	//
	// Used to ensure funds for the trade are 'locked down'.
	// Can be used by the callbacks to either add/return values
	// directly to each party or to create liabilities on each party to be satisfied later,
	// depending on the desired simulation LOD.
	var/list/escrow = null

	// Lifecycle callbacks
	// Apply the effects of the contract / clawbacks etc. in the case of failure.
	var/on_completion_proc = DEFAULT_TRADE_COMPLETION_PROC
	var/on_failure_proc = DEFAULT_TRADE_FAILURE_PROC

	// Arguments to lifecycle callbacks, as assoc lists
	// NOTE: These are NOT passed in directly; rather, the callback gets passed the whole Contract
	//       and can look up these args or any other data associated with a contract as it sees fit.
	//       This keeps the callback signatures lean and avoids alloc hell.
	var/list/on_completion_proc_args = null
	var/list/on_failure_proc_args = null


/datum/trade_contract/proc/Create(var/source, var/receiver, var/commodity_key, var/commodity_amt, var/cash_amt, var/contract_deadline = null, var/on_completed = null, var/on_failure = null, var/list/on_completed_args = null, var/list/on_failure_args = null)
	src.is_open = TRUE
	src.creator = source
	src.receiver = receiver
	src.commodity_key = commodity_key
	src.commodity_amount = commodity_amt
	src.cash_value = cash_amt

	// TODO: consider object-pooling on this list
	src.escrow = list()
	src.escrow.Cut()

	SET_IF_NOT_NULL(contract_deadline, src.deadline)
	SET_IF_NOT_NULL(on_completed, src.on_completion_proc)
	SET_IF_NOT_NULL(on_failure, src.on_failure_proc)
	SET_IF_NOT_NULL(on_completed_args, src.on_completion_proc_args)
	SET_IF_NOT_NULL(on_failure_args, src.on_failure_proc_args)

	// deadline-handling
	src.check_timer_id = null
	if(!isnull(src.deadline))
		// start a timer to check if the deadline passed
		src.ScheduleExpiryCheck()


	return


/datum/trade_contract/New(var/source, var/receiver, var/commodity_key, var/commodity_amt, var/cash_amt, var/contract_deadline = null, var/on_completed = null, var/on_failure = null, var/list/on_completed_args = null, var/list/on_failure_args = null)
	// We'll shunt the init to a custom proc so we can object-pool and reuse these.
	src.Create(
		source,
		receiver,
		commodity_key,
		commodity_amt,
		cash_amt,
		contract_deadline,
		on_completed,
		on_failure,
		on_completed_args,
		on_failure_args
	)
	return


/*
// $$$  Offer => Contract  $$$
*/


/datum/trade_offer/proc/ToContract(var/claimed_by = null) // () -> trade_contract datum
	/*
	// Binds the offer to a contract. This represents both sides accepting the deal.
	*/

	// Do not reuse the offer object until it's properly reinited as a new offer.
	src.is_open = FALSE

	// If claimed_by is set, use it. Otherwise use receiver.
	// GENERALLY non-receivers shouldn't see the offer to claim it.
	// A possible exception is something like a Faction AI claiming on behalf of its Faction etc.
	var/target = DEFAULT_IF_NULL(claimed_by, src.receiver)

	// Currently just alloc a new object; may object-pool in the future.
	var/datum/trade_contract/contract = new(
		src.creator,
		target,
		src.commodity_key,
		src.commodity_amount,
		src.cash_value,
		src.deadline,
		src.on_completion_proc,
		src.on_failure_proc,
		src.on_completion_proc_args,
		src.on_failure_proc_args
	)

	to_world_log("Contract [contract] <ID #[NULL_TO_TEXT(contract.id)]> ([contract.commodity_key] x [contract.commodity_amount] @ [contract.cash_value] by [NULL_TO_TEXT(contract.deadline)]) created between creator [contract.creator] and contractor [contract.receiver]")
	return contract


/*
// $$$  Contract => Fulfilment (or not)  $$$
*/

/datum/trade_contract/proc/EscrowPut(var/datum/party, var/key, var/value, var/allow_partial = ESCROW_PUT_PARTIAL_ALLOWED_DEFAULT)
	/*
	// To fulfill a contract, both parties commit resources into the Escrow,
	// which acts as an impartial tracker for their amounts and locks them down
	// for the lifetime of the contract so they are not 'double-booked'.
	//
	// This method represents this activity. The caller specifies the source of
	// resources (party, e.g. faction or mob), the type of thing they are committing
	// to the trade (key) and the amount of that thing (value).
	//
	// The proc will validate that the Party has at least that much of the asset.
	// If they do, it will update the Escrow and return TRUE.
	// If they don't, it will return FALSE.
	// If something goes wrong, the proc will return null.
	*/

	if(!istype(party))
		return null

	if(!key)
		return null

	// Allocate the assets table if it's uninitialized
	ASSETS_TABLE_LAZY_INIT(TRUE)

	if(isnull(party.global_id))
		to_world_log("ERROR: EscrowPut party ([NULL_TO_TEXT(party)]) has no global ID.")
		return null

	var/list/assets = GET_ASSETS_TRACKER(party.global_id)

	if(!assets)
		// If we don't even have a list entry, we sure as hell don't have enough stuff to put here.
		to_world_log("WARNING: EscrowPut party ([NULL_TO_TEXT(party)]) has no assets.")
		return FALSE

	var/owned_key_amt = assets[key]

	if(!owned_key_amt)
		// We ain't got it, abort.
		to_world_log("WARNING: EscrowPut party ([NULL_TO_TEXT(party)]) has no asset '[key]' (assets: [json_encode(assets)]).")
		return FALSE

	if(!allow_partial && (owned_key_amt < value))
		// We got some, but not enough - still abort.
		to_world_log("WARNING: EscrowPut party ([NULL_TO_TEXT(party)]) has insufficient amount of [key] - needs [value], has [owned_key_amt].")
		return FALSE

	if(!istype(src.escrow))
		src.escrow = list()

	var/curr_escrow_amt = src.escrow[key] || 0

	// NOTE: if allow_partial is FALSE, the min here should always resolve to value
	//       (otherwise we would have errored out earlier)
	var/safe_val = min(value, owned_key_amt)

	var/new_owned_amt = owned_key_amt - safe_val
	var/new_escrow_amt = curr_escrow_amt + safe_val

	// this whole block is logically a transaction (in the DB sense)
	src.escrow[key] = new_escrow_amt
	assets[key] = new_owned_amt
	UPDATE_ASSETS_TRACKER(party.global_id, assets)

	return TRUE


/datum/trade_contract/proc/EscrowGetNeededAmt(var/key)
	/*
	// This helper tells us how much of a given resource we need to add to fulfill
	// the contractual obligations of this contract.
	*/

	if(!key)
		return 0

	if(!istype(src.escrow))
		src.escrow = list()

	var/required_amt = null
	var/curr_escrow_amt = src.escrow[key] || 0

	if(key == NEED_WEALTH)
		required_amt = max(0, (abs(src.cash_value) - curr_escrow_amt))
	else
		required_amt = max(0, (abs(src.commodity_amount) - curr_escrow_amt))

	return required_amt


/datum/trade_contract/proc/CheckFulfilled(var/list/escrow_override = null)
	/*
	// Verifies if the terms of the contract have been fulfilled.
	//
	// Optional escrow_override can be used to check if the terms WOULD be fulfilled
	// given some user-provided state; by default - uses the actual current state of
	// the current contract.
	*/
	var/list/target_escrow = DEFAULT_IF_NULL(escrow_override, src.escrow)

	if(!target_escrow)
		// All contracts should have some failure state, so an empty escrow should always make it unfulfilled.
		return FALSE

	for(var/escrow_key in target_escrow)
		var/is_goods = (escrow_key == src.commodity_key)
		var/is_money = (escrow_key == NEED_WEALTH)

		if(!(is_goods || is_money))
			continue

		var/escrow_val = target_escrow[escrow_key]
		var/expected_val = is_goods ? abs(src.commodity_amount) : abs(cash_value)

		if(escrow_val < expected_val)
			return FALSE

	// if we got here, nothing failed - so we're all good
	return TRUE


/datum/trade_contract/proc/ScheduleExpiryCheck()
	/*
	// Creates a delayed check that auto-expires the job after the deadline has passed,
	// if there is one. Returns TRUE if the schedule is set up and FALSE if not.
	*/

	set waitfor = FALSE

	// will return FALSE if it failed to set up
	. = FALSE

	if(isnull(src.deadline))
		// no deadline - no waiting
		return FALSE

	if(!src.is_open)
		// already finished
		return FALSE

	var/current_id = "deadline-timer-[world.time]"

	// NOTE: This will effectively discard any running timer for this instance.
	//       This means if the Contracts are object-pooled, we don't
	//       wind up tripping over timers from the previous Contract.
	src.check_timer_id = current_id

	// Sleep until just past the deadline
	var/offset_time = max(-1, (src.deadline - world.time))
	sleep(offset_time + 1)

	// We don't need to worry about checking for success here
	// The Expire proc handles that case for us.
	if(src.check_timer_id == current_id)
		// The if-check ensures old timers are ignored
		src.Expire()

	return


/datum/trade_contract/proc/Signoff(var/signoff_party)
	/*
	// Represents a party in the trade signing off on its fulfilment.
	// The user must pass an entity as the argument that should match either the creator or the receiver of the offer.
	// This functions like providing that side's "signature" and allows switching the appropriate flag.
	// The contracts require the signoff from both sides to be considered successfully closed.
	*/

	if(isnull(signoff_party))
		to_world_log("TradeContract [src] received a call to Signoff() with a null signoff_party. This is not critical, but generally should not happen.")
		return src

	if(signoff_party == src.creator)
		src.lifecycle_state |= GOAI_CONTRACT_LIFECYCLE_SIGNOFF_CREATOR
		return src

	if(signoff_party == src.receiver)
		src.lifecycle_state |= GOAI_CONTRACT_LIFECYCLE_SIGNOFF_CONTRACTOR
		return src

	return null


/*
// The two procs below handle success/failure for the Contract... in theory.
//
// In reality, those provide a minimal shared API for handling the Contract
//  in an appropriate state and validating that it is in fact the right state,
//  but the actual *LOGIC* is applied by callbacks.
//
// What this means for you is if you don't like how the contract resolves,
//  you're likely better off replacing the callbacks instead of  overriding
//  these methods.
*/

/datum/trade_contract/proc/Complete(var/require_signoff = TRUE)
	/*
	// Job's done. Apply effects.
	//
	// - require_signoff: Boolean, default TRUE. Checks if both parties signed off.
	//                    If FALSE, contracts without signoff that are otherwise completed
	//                        will be treated as successful.
	//                    FALSE is primarily meant to be used to force-close Contracts that
	//                        might have hanged in a weird state for whatever reason.
	*/

	// Verify signoff, refuse to complete if there's anything unsettled left.
	if(!GOAI_CONTRACT_IS_COMPLETED(src.lifecycle_state, src.progressed_state))
		if(require_signoff && GOAI_CONTRACT_COMPLETED_IF_SIGNED(src.lifecycle_state, src.progressed_state))
			// if we got here, the only missing thing is signoff
			// if signoff is not required, we just keep going to completion state
			to_world_log("Contract [src] could not complete - missing required signoff ([src.lifecycle_state])")
			return FALSE

	// Mark the contract as closed.
	src.is_open = FALSE

	// Call the callback shuttle
	if(!isnull(src.on_completion_proc))
		call(on_completion_proc)(src)

	return TRUE


/datum/trade_contract/proc/Expire()
	/*
	// Failed-to-deliver, fission mailed.
	*/

	// If somehow we forgot to mark the contract as completed
	// but it is in a success state as of expiry, just complete it now.
	if(GOAI_CONTRACT_IS_COMPLETED(src.lifecycle_state, src.progressed_state))
		var/completed = src.Complete(FALSE)
		if(completed)
			// If we could not force completion, this block will not be reached
			// and so we'll fall through back to failing the deal.
			return completed

	// Mark the contract as closed.
	src.is_open = FALSE

	// Call the callback shuttle
	if(!isnull(src.on_failure_proc))
		call(on_failure_proc)(src)

	return TRUE
