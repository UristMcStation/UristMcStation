/*
// Alternative trading procs with mocked out steps to test the logic
*/

#warn DEBUG MODULE INCLUDED!


/datum/utility_ai/proc/DebugFulfilContractInstant(var/datum/ActionTracker/tracker, var/input)
	/*
	// Debug variant of fulfillment logic.
	// Will instantly set the contract to its resolved state.
	*/
	if(isnull(tracker))
		return

	if(tracker.IsStopped())
		return

	var/datum/trade_contract/contract = input

	if(!istype(contract))
		to_world_log("DebugFulfilContractInstant ([src]): Invalid offer type for contract object [NULL_TO_TEXT(contract)]!")
		tracker.SetFailed()
		return

	var/ai_pawn = src.GetPawn()  // usually a faction, though COULD be a mob too

	if(isnull(ai_pawn))
		to_world_log("DebugFulfilContractInstant ([src]): Does not have a pawn ([NULL_TO_TEXT(ai_pawn)]).")
		tracker.SetFailed()
		return

	// We'll directly set everything up for success here
	contract.escrow[contract.commodity_key] = abs(contract.commodity_amount)
	contract.escrow[NEED_WEALTH] = abs(contract.cash_value)
	contract.lifecycle_state = GOAI_CONTRACT_LIFECYCLE_FULFILLED

	var/completed = contract.Complete()

	# warn TODO, debug logs for contract fulfillment
	if(completed)
		tracker.SetDone()
		to_world_log("FULFILLED a contract for [contract.commodity_key] * [contract.commodity_amount]u @ [contract.cash_value]$")
	else
		tracker.SetFailed()
		to_world_log("FAILED a contract for [contract.commodity_key] * [contract.commodity_amount]u @ [contract.cash_value]$")

	return


/datum/utility_ai/proc/DebugFulfilContractInstantWithTransfers(var/datum/ActionTracker/tracker, var/input)
	/*
	// Debug variant of fulfillment logic.
	// Slightly more realistic than DebugFulfilContractInstant - while the transfer is instant, it is a *real* (abstract) transfer.
	// However, here the required goods are magically spawned into each party's accounts before transferring,
	// so we do not need to worry about them having them on hand.
	*/

	if(isnull(tracker))
		return

	if(tracker.IsStopped())
		return

	var/datum/trade_contract/contract = input

	if(!istype(contract))
		to_world_log("DebugFulfilContractInstantWithTransfers ([src]): Invalid offer type for contract object [NULL_TO_TEXT(contract)]!")
		tracker.SetFailed()
		return

	if(!(contract.is_open))
		to_world_log("DebugFulfilContractInstantWithTransfers ([src]): Contract [contract] is closed (expired or already fulfilled)!")
		tracker.SetFailed()
		return

	var/ai_pawn = src.GetPawn()  // usually a faction, though COULD be a mob too

	if(isnull(ai_pawn))
		to_world_log("DebugFulfilContractInstantWithTransfers ([src]): Does not have a pawn ([NULL_TO_TEXT(ai_pawn)]).")
		tracker.SetFailed()
		return

	var/creator_is_seller = contract.commodity_amount > 0
	var/creator_is_payer = contract.cash_value < 0

	var/datum/creator_datum = contract.creator
	var/datum/contractor_datum = contract.receiver

	var/trade_volume = abs(contract.commodity_amount)
	var/cash_volume = abs(contract.cash_value)

	var/datum/goods_sender = (creator_is_seller ? contractor_datum : creator_datum)
	var/datum/money_sender = (creator_is_payer ? creator_datum : contractor_datum)

	ASSETS_TABLE_LAZY_INIT(TRUE)

	CREATE_ASSETS_TRACKER_IF_NEEDED((creator_datum.global_id || creator_datum.InitializeGlobalId()))
	CREATE_ASSETS_TRACKER_IF_NEEDED((contractor_datum.global_id || contractor_datum.InitializeGlobalId()))

	var/list/goods_sender_assets = GET_ASSETS_TRACKER(goods_sender.global_id)
	var/list/money_sender_assets = GET_ASSETS_TRACKER(money_sender.global_id)

	goods_sender_assets[contract.commodity_key] = ((goods_sender_assets[contract.commodity_key] || 0) + trade_volume)
	money_sender_assets[NEED_WEALTH] = ((money_sender_assets[NEED_WEALTH] || 0) + cash_volume)

	UPDATE_ASSETS_TRACKER(goods_sender.global_id, goods_sender_assets)
	UPDATE_ASSETS_TRACKER(money_sender.global_id, money_sender_assets)

	contract.EscrowPut(goods_sender, contract.commodity_key, trade_volume)
	contract.EscrowPut(money_sender, NEED_WEALTH, cash_volume)

	contract.Signoff(contract.creator)
	contract.Signoff(contract.receiver)

	contract.lifecycle_state |= GOAI_CONTRACT_LIFECYCLE_GOODS_DELIVERED
	contract.lifecycle_state |= GOAI_CONTRACT_LIFECYCLE_PAID

	var/completed = contract.Complete()

	# warn TODO, debug logs for contract fulfillment
	if(completed)
		tracker.SetDone()
		to_world_log("FULFILLED a contract for [contract.commodity_key] * [contract.commodity_amount]u @ [contract.cash_value]$")
	else
		tracker.SetFailed()
		to_world_log("FAILED a contract for [contract.commodity_key] * [contract.commodity_amount]u @ [contract.cash_value]$")

	return


/datum/utility_ai/proc/DebugFulfilContractInstantRealistic(var/datum/ActionTracker/tracker, var/input)
	/*
	// Debug variant of fulfillment logic.
	// This is the closest thing to real application
	// to the point of being copypastable AS a real instant trade handler,
	// if you don't mind us handling BOTH sides (as opposed to each AI signing off separately).
	*/

	if(isnull(tracker))
		return

	if(tracker.IsStopped())
		return

	var/datum/trade_contract/contract = input

	if(!istype(contract))
		to_world_log("DebugFulfilContractInstantRealistic ([src]): Invalid offer type for contract object [NULL_TO_TEXT(contract)]!")
		tracker.SetFailed()
		return

	var/ai_pawn = src.GetPawn()  // usually a faction, though COULD be a mob too

	if(isnull(ai_pawn))
		to_world_log("DebugFulfilContractInstantRealistic ([src]): Does not have a pawn ([NULL_TO_TEXT(ai_pawn)]).")
		tracker.SetFailed()
		return

	var/creator_is_seller = contract.commodity_amount > 0
	var/creator_is_payer = contract.cash_value < 0

	var/datum/creator_datum = contract.creator
	var/datum/contractor_datum = contract.receiver

	var/trade_volume = abs(contract.commodity_amount)
	var/cash_volume = abs(contract.cash_value)

	var/datum/goods_sender = (creator_is_seller ? contractor_datum : creator_datum)
	var/datum/money_sender = (creator_is_payer ? creator_datum : contractor_datum)

	ASSETS_TABLE_LAZY_INIT(TRUE)
	CREATE_ASSETS_TRACKER_IF_NEEDED((creator_datum.global_id || creator_datum.InitializeGlobalId()))
	CREATE_ASSETS_TRACKER_IF_NEEDED((contractor_datum.global_id || contractor_datum.InitializeGlobalId()))

	contract.EscrowPut(goods_sender, contract.commodity_key, trade_volume)
	contract.EscrowPut(money_sender, NEED_WEALTH, cash_volume)

	contract.Signoff(contract.creator)
	contract.Signoff(contract.receiver)

	contract.lifecycle_state |= GOAI_CONTRACT_LIFECYCLE_GOODS_DELIVERED
	contract.lifecycle_state |= GOAI_CONTRACT_LIFECYCLE_PAID

	var/completed = contract.Complete()

	# warn TODO, debug logs for contract fulfillment
	if(completed)
		tracker.SetDone()
		to_world_log("FULFILLED a contract for [contract.commodity_key] * [contract.commodity_amount]u @ [contract.cash_value]$")
	else
		tracker.SetFailed()
		to_world_log("FAILED a contract for [contract.commodity_key] * [contract.commodity_amount]u @ [contract.cash_value]$")

	return
