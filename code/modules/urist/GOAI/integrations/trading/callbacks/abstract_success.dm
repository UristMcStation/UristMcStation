/*
// This module provides procs for resolving a Contract success state
// in an abstract fashion (i.e. we ignore the actual physical items and
// just update the abstract resources they correspond to).
*/

/proc/trade_apply_instant_abstract_success(var/datum/trade_contract/contract)
	/* Simple callback meant as a default, resolves the trade instantly */
	set waitfor = FALSE

	GOAI_LOG_DEBUG("INFO: RUNNING trade_apply_instant_abstract_success() @ [__LINE__] in [__FILE__]")
	ASSETS_TABLE_LAZY_INIT(TRUE)
	sleep(0)

	if(!istype(contract))
		GOAI_LOG_ERROR("ERROR: trade_apply_instant_success() received an invalid input type [contract] ([NULL_TO_TEXT(contract?.type)]) @ [__LINE__] in [__FILE__]")
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
		GOAI_LOG_ERROR("ERROR: trade_apply_instant_abstract_success contract creator ([NULL_TO_TEXT(my_creator)]) is not a datum @ L[__LINE__] in [__FILE__]")
		return

	var/creator_global_id = GET_GLOBAL_ID_LAZY(my_creator)

	if(isnull(creator_global_id))
		GOAI_LOG_ERROR("ERROR: trade_apply_instant_abstract_success contract creator ([NULL_TO_TEXT(my_creator)]) has no global ID @ L[__LINE__] in [__FILE__]")
		return

	var/creator_has_account = HAS_REGISTERED_ASSETS(creator_global_id)
	if(!creator_has_account)
		CREATE_ASSETS_TRACKER(creator_global_id)

	// ...and now the same for the Contract receiver
	var/datum/my_receiver = contract.receiver

	if(!istype(my_receiver))
		GOAI_LOG_ERROR("ERROR: trade_apply_instant_abstract_success contract receiver ([NULL_TO_TEXT(my_receiver)]) is not a datum @ L[__LINE__] in [__FILE__]")
		return

	var/receiver_global_id = GET_GLOBAL_ID_LAZY(my_receiver)

	if(isnull(receiver_global_id))
		GOAI_LOG_ERROR("ERROR: trade_apply_instant_abstract_success contract receiver ([NULL_TO_TEXT(my_receiver)]) has no global ID @ L[__LINE__] in [__FILE__]")
		return

	var/receiver_has_account = HAS_REGISTERED_ASSETS(receiver_global_id)
	if(!receiver_has_account)
		CREATE_ASSETS_TRACKER(receiver_global_id)

	// Allocate the assets table if it's uninitialized
	ASSETS_TABLE_LAZY_INIT(TRUE)

	// Figuring out what kind of good goes to whom
	var/creator_is_seller = contract.commodity_amount > 0
	var/creator_is_payer = contract.cash_value > 0

	var/datum/goods_receiver = (creator_is_seller ? my_receiver : my_creator)
	var/datum/money_receiver = (creator_is_payer ? my_receiver : my_creator)

	// Iterate through the assoc; route goods to buyer, money to seller
	for(var/escrow_key in contract.escrow)
		// Iteration through an assoc gives us a key, grab the value by a lookup
		// (effectively doing a Python dict.items()-style iterator)
		var/escrow_val = contract.escrow[escrow_key]

		if(!escrow_val)
			// not worth the hassle if the value is zero, and null means something went wrong
			continue

		//var/datum/curr_sender = null
		var/datum/curr_recipient = null

		if(escrow_key == NEED_WEALTH)
			//curr_sender = money_sender
			curr_recipient = money_receiver
			GOAI_LOG_DEBUG("DEBUG: trade_apply_instant_abstract_success current receiver for [escrow_key] @ [escrow_val] is the money receiver ([NULL_TO_TEXT(curr_recipient)]) @Time: [world.time];  @ L[__LINE__] in [__FILE__]")

		else
			//curr_sender = goods_sender
			curr_recipient = goods_receiver
			GOAI_LOG_DEBUG("DEBUG: trade_apply_instant_abstract_success current receiver for [escrow_key] @ [escrow_val] is the goods receiver ([NULL_TO_TEXT(curr_recipient)]) @Time: [world.time]; @ L[__LINE__] in [__FILE__]")

		if(isnull(curr_recipient))
			GOAI_LOG_ERROR("ERROR: trade_apply_instant_abstract_success current receiver ([NULL_TO_TEXT(curr_recipient)]) is null @ L[__LINE__] in [__FILE__]")
			continue

		var/receiver_id = GET_GLOBAL_ID_LAZY(curr_recipient)
		var/list/receiver_assets = GET_ASSETS_TRACKER(receiver_id)

		if(!istype(receiver_assets))
			// If null/corrupted, overwrite with a clean list
			GET_ASSETS_TRACKER(receiver_id) = list()

		var/transferred_amt = abs(escrow_val)

		var/current_receiver_amt = GET_ASSETS_TRACKER(receiver_id)[escrow_key]
		var/new_receiver_asset_amt = (current_receiver_amt || 0) + transferred_amt
		GET_ASSETS_TRACKER(receiver_id)[escrow_key] = new_receiver_asset_amt

		// The only logic needed here is just us handling each Receiver.
		// The Sender should just put things into escrow and decrement their account themselves in the process
		// during the contract's earlier lifecycle.

		// Drop the value from the key to avoid duplication
		// We could null it, but this way we should be able to spot errors more easily
		// If there's anything nonzero left, we hadn't cleaned this up properly.
		contract.escrow[escrow_key] = escrow_val - transferred_amt

	// All done!
	contract.is_open = FALSE
	GOAI_LOG_DEBUG("INFO: FINISHED trade_apply_instant_abstract_success() @ L[__LINE__] in [__FILE__]")
	return
