/*
// This module provides procs for resolving a Contract success state
// in an abstract fashion (i.e. we ignore the actual physical items and
// just update the abstract resources they correspond to).
*/

/proc/trade_apply_instant_abstract_failure(var/datum/trade_contract/contract)
	/*
	// This is an evil twin of trade_apply_instant_abstract_failure.
	// Where the success transfers the goods from party to counterparty,
	// recipients from the escrow, this failure proc returns whatever
	// each party deposited *back to them*.
	*/
	set waitfor = FALSE
	GOAI_LOG_DEBUG("INFO: RUNNING trade_apply_instant_abstract_failure() @ [__LINE__] in [__FILE__]")
	ASSETS_TABLE_LAZY_INIT(TRUE)
	sleep(0)

	if(!istype(contract))
		GOAI_LOG_ERROR("ERROR: trade_apply_instant_abstract_failure() received an invalid input type [contract] ([NULL_TO_TEXT(contract?.type)]) @ [__LINE__] in [__FILE__]")
		return

	if(!contract.escrow)
		// Nothing to do here, return early.
		// The Complete() proc should ensure this doesn't get here
		// if the Contract has any unfulfilled terms, so should be rare.
		return

	/* Currently both parties MUST be at least datums to support maintaining global IDs into the assets table */
	// Cast and validate this for the Contract creator...
	var/datum/my_creator = contract.creator

	if(!istype(my_creator))
		GOAI_LOG_ERROR("ERROR: trade_apply_instant_abstract_failure contract creator ([NULL_TO_TEXT(my_creator)]) is not a datum")
		return

	if(isnull(my_creator.global_id))
		GOAI_LOG_DEBUG("WARNING: trade_apply_instant_abstract_failure contract receiver ([NULL_TO_TEXT(my_creator)]) has no global ID - attempting to initialize")
		my_creator.InitializeGlobalId()

	if(isnull(my_creator.global_id))
		GOAI_LOG_ERROR("ERROR: trade_apply_instant_abstract_failure contract receiver ([NULL_TO_TEXT(my_creator)]) has no global ID")
		return

	var/creator_has_account = HAS_REGISTERED_ASSETS(my_creator.global_id)
	if(!creator_has_account)
		CREATE_ASSETS_TRACKER(my_creator.global_id)

	// ...and now the same for the Contract receiver
	var/datum/my_receiver = contract.receiver

	if(!istype(my_receiver))
		GOAI_LOG_ERROR("ERROR: trade_apply_instant_abstract_failure contract receiver ([NULL_TO_TEXT(my_receiver)]) is not a datum")
		return

	if(isnull(my_receiver.global_id))
		GOAI_LOG_DEBUG("WARNING: trade_apply_instant_abstract_failure contract receiver ([NULL_TO_TEXT(my_receiver)]) has no global ID - attempting to initialize")
		my_receiver.InitializeGlobalId()

	if(isnull(my_receiver.global_id))
		GOAI_LOG_ERROR("ERROR: trade_apply_instant_abstract_failure contract receiver ([NULL_TO_TEXT(my_receiver)]) has no global ID")
		return

	var/receiver_has_account = HAS_REGISTERED_ASSETS(my_receiver.global_id)
	if(!receiver_has_account)
		CREATE_ASSETS_TRACKER(my_receiver.global_id)

	// Both parties are datums, yay.
	// Allocate the assets table if it's uninitialized
	ASSETS_TABLE_LAZY_INIT(TRUE)

	// Figuring out what kind of good goes to whom
	var/creator_is_seller = contract.commodity_amount > 0
	var/creator_is_payer = contract.cash_value < 0

	var/datum/goods_sender = (creator_is_seller ? my_receiver : my_creator)
	var/datum/goods_receiver = (creator_is_seller ? my_creator : my_receiver)

	var/datum/money_sender = (creator_is_payer ? my_receiver : my_creator)
	var/datum/money_receiver = (creator_is_payer ? my_creator : my_receiver)

	// +1 for each case where the goods sender didn't sent enough goods to be worth seizing
	// In that case, we apply a cash penalty instead.
	var/failed_to_deliver_sufficient = 0

	// We'll need it for later to save some computations
	var/abs_contract_value = abs(contract.cash_value)

	// Iterate through the assoc; route goods back to seller, money back to buyer, applying penalties.
	for(var/escrow_key in contract.escrow)
		// Iteration through an assoc gives us a key, grab the value by a lookup
		// (effectively doing a Python dict.items()-style iterator)
		var/escrow_val = contract.escrow[escrow_key]

		if(!escrow_val)
			// not worth the hassle if the value is zero, and null means something went wrong
			continue

		var/datum/curr_sender = null
		var/datum/curr_recipient = null

		// How much of each traded thing we retain as a penalty, in whatever units it is in Escrow
		var/penalty = 0  // none by default, will get adjusted below case-by-case

		/* Wired 'backwards' from the success */
		if(escrow_key == NEED_WEALTH)
			curr_sender = money_sender
			curr_recipient = money_receiver

			// 5% of contract value taken as penalty
			// TODO: might do this in a fancier way later
			if(escrow_val < abs_contract_value)
				// The payer failed to pay in full, apply a penalty on them
				penalty = 0.05 * abs_contract_value

			else
				// The payer did their duty, the goods provider is at fault only
				penalty = 0

		else
			curr_sender = goods_sender
			curr_recipient = goods_receiver

			var/expected_goods_amt = abs(contract.commodity_amount)

			if(escrow_val < expected_goods_amt)
				// This is deliberately chosen to start from 2, so that small-volume trades
				// (most likely rare valuables) resolve with cash penalties instead of seizure.
				var/minimum_amt = max(2, round(0.2 * expected_goods_amt))

				if(escrow_val < minimum_amt)
					// not worth seizing, pay the price in cash
					failed_to_deliver_sufficient++
					penalty = 0 // we'll deal with the cash penalty for this later

				else
					// seize the goods as the penalty
					penalty = minimum_amt

			else
				// the sender did their duty, the fault is on the payer only
				penalty = 0

		if(isnull(curr_recipient))
			GOAI_LOG_ERROR("ERROR: trade_apply_instant_abstract_failure current receiver ([NULL_TO_TEXT(curr_recipient)]) is null")
			continue

		var/list/receiver_assets = GET_ASSETS_TRACKER(curr_recipient.global_id)

		if(!istype(receiver_assets))
			// If null/corrupted, overwrite with a clean list
			receiver_assets = list()

		// Whoever was supposed to get the thing, still gets at least the penalty amount (if there is any for this key)
		var/new_receiver_asset_amt = (receiver_assets[escrow_key] || 0) + penalty
		receiver_assets[escrow_key] = new_receiver_asset_amt
		UPDATE_ASSETS_TRACKER(curr_recipient.global_id, receiver_assets)

		// Return everything else to the Sender.

		if(isnull(curr_sender))
			GOAI_LOG_ERROR("ERROR: trade_apply_instant_abstract_failure current sender ([NULL_TO_TEXT(curr_sender)]) is not a datum")
			continue

		var/list/sender_assets = GET_ASSETS_TRACKER(curr_sender.global_id)

		if(!istype(sender_assets))
			// If null/corrupted, overwrite with a clean list
			sender_assets = list()

		// Whoever was supposed to send the thing, gets it back less the penalty (if any)
		var/new_sender_asset_amt = (sender_assets[escrow_key] || 0) + abs(escrow_val) - penalty
		sender_assets[escrow_key] = new_sender_asset_amt
		UPDATE_ASSETS_TRACKER(curr_sender.global_id, sender_assets)

		// Drop the value from the key to avoid duplication
		contract.escrow[escrow_key] = null

	if(failed_to_deliver_sufficient)
		// Apply the cash penalty for goods that failed to deliver and could not be seized as penalty
		// Currently 5% of contract value for each unfulfilled deliverable
		// (as Contract API currently only supports one trade good, this makes the penalties symmetrical)
		var/cash_penalty = (failed_to_deliver_sufficient * 0.05) * abs_contract_value

		var/list/payer_assets = GET_ASSETS_TRACKER(money_sender.global_id) || list()
		var/new_payer_wealth = (payer_assets[NEED_WEALTH] || 0) + cash_penalty
		payer_assets[NEED_WEALTH] = new_payer_wealth

		var/list/provider_assets = GET_ASSETS_TRACKER(goods_sender.global_id) || list()
		var/new_provider_wealth = (provider_assets[NEED_WEALTH] || 0) - cash_penalty
		provider_assets[NEED_WEALTH] = new_provider_wealth

		UPDATE_ASSETS_TRACKER(money_sender.global_id, payer_assets)
		UPDATE_ASSETS_TRACKER(goods_sender.global_id, provider_assets)

	// All done!
	contract.is_open = FALSE
	GOAI_LOG_DEBUG("INFO: FINISHED trade_apply_instant_abstract_failure() @ [__LINE__] in [__FILE__]")
	return
