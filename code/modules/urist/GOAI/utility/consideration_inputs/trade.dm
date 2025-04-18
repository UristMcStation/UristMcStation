/*
// Considerations around trades and contracts.
//
// Note that this is not exhaustive; these are just logic that would be hard to express using a combination of 'pure' considerations.
//
// For example, Net Commodity Desirability is a *difference* between the Raw Commodity Desirability and the Raw Cash Desirability.
//
// On the other side, the raw desire for buying healing items can be expressed just by health CIs, which would not live here.
*/

CONSIDERATION_CALL_SIGNATURE(/proc/consideration_trade_desirability)
	// Returns a normalized (0 <-> 1 float) score representing how much we want to buy/sell a commodity IN ABSTRACT.
	// In other words, how much we would want to buy a product if we could get a fair price or better, guaranteed.
	//
	// This is determined by an interaction of two factors:
	// 1) how much we value having the goods (Commodity Preference Factor, CPF)
	// 2) how much we value having cash on hand (Money Preference Factor, MPF)
	//
	// For BUYING:
	// If we really need the goods (high CPF) and don't mind spending cash (low MPF), the desirability is high.
	// If we don't need them (low CPF), then it doesn't matter how much we want cash (any MPF), we won't buy.
	// If we both really need the goods AND need to be stingy (both high), the utility will be lower, but still reasonable;
	//    however, it will never be our top choice AND they will drop off much more sharply as CPF drops.
	//
	// For SELLING, these roles are simply reversed (MPF on sell-side acts like CPF on buy-side and likewise substitute CPF for MPF above for the seller)
	// So, we only sell when MPF is high and prefer to sell commodities we don't really need.

	/*
	//          -----------------------------
	//           CONSIDERATION USAGE NOTE!!!
	//          -----------------------------
	//
	// Choose your high watermark carefully for this!
	// Very few offers will ever reach a score of 1 - that would require a ridiculously good offer.
	//
	// Instead, think of it as more of an indifference curve - above a certain watermark, all deals
	// are treated as a bargain for the AI. The high threshold should represent how 'picky' the AI
	// is (the higher, the more picky - decent but less ideal deals will still be chosen, but rarely)
	*/

	var/datum/utility_action_template/candidate = action_template

	if(isnull(requester))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_trade_desirability - Requester must be provided for this Consideration! @ L[__LINE__] in [__FILE__]")
		return null

	if(!istype(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_trade_desirability for [requester] - Candidate is not an ActionTemplate! @ L[__LINE__] in [__FILE__]")
		return null

	var/datum/utility_ai/ai = requester

	if(!istype(ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_trade_desirability for [requester] - Requester must be an AI for this Consideration (found: [ai.type])! @ L[__LINE__] in [__FILE__]")
		return null

	var/from_ctx = consideration_args?["from_context"]
	if(isnull(from_ctx))
		from_ctx = TRUE

	var/datasource = from_ctx ? context : consideration_args
	CONSIDERATION_GET_INPUT_KEY(var/datasource_key)

	if(isnull(datasource_key))
		GOAI_LOG_ERROR("ERROR: consideration_trade_desirability for [requester]: datasource_key [datasource_key || "null"] is null")
		return 0

	var/datum/trade_offer/offer = datasource[datasource_key]

	if(!istype(offer))
		GOAI_LOG_ERROR("ERROR: consideration_trade_desirability for [requester]: received offer [offer || "null"] is not of a valid trade_offer type!")
		return 0

	var/commodity = offer.commodity_key
	var/cash_value = offer.cash_value || 0
	var/raw_volume = offer.commodity_amount || 0

	// Supply-side reverses the preferences in the formula. Default to demand-side.
	var/is_sell = raw_volume < 0

	if(isnull(is_sell))
		is_sell = FALSE

	var/desirability = ai.GetCommodityDesirability(commodity, raw_volume, cash_value)

	if(isnull(desirability))
		// Either a need went negative, or the proc straight up crashed somewhere.
		// In both cases, do not pass go, do not collect 200 trades.
		TRADE_DEBUG_LOG("DEBUG: consideration_trade_desirability for [requester]: Desirability for [commodity] x [raw_volume] @ [cash_value] == null!")
		return 0

	return desirability


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_offers_pending)
	/*
	// Returns the number of trade offers held by the AI Brain.
	// This can (and is mainly meant to) be used to throttle the creation of more offers.
	//
	// As a Utility Consideration, this throttling can be as soft or hard as you want to configure it to be,
	// with binary curves providing a hard cutoff at max number of offers allowed.
	*/
	var/datum/utility_action_template/candidate = action_template

	if(isnull(requester))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_contracts_pending - Requester must be provided for this Consideration! @ L[__LINE__] in [__FILE__]")
		return null

	if(!istype(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_contracts_pending for [requester] - Candidate is not an ActionTemplate! @ L[__LINE__] in [__FILE__]")
		return null

	var/datum/utility_ai/ai = requester

	if(!istype(ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_contracts_pending for [requester] - Requester is not an AI! @ L[__LINE__] in [__FILE__]")
		return null

	var/datum/brain/requesting_brain = ai.brain

	if(!istype(requesting_brain))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_contracts_pending for [requester] - Requester has no Brain! @ L[__LINE__] in [__FILE__]")
		return null

	var/default = consideration_args?["default"] || 0

	if(!requesting_brain.active_offers)
		return default

	var/result = 0
	var/now = world.time

	for(var/offer_id in requesting_brain.active_offers)
		if(isnull(offer_id))
			continue

		var/datum/trade_offer/offer
		GET_OFFER_FROM_MARKETPLACE(offer_id, offer)

		if(!istype(offer))
			continue

		if(offer.expiry_time <= now)
			continue

		result++

	return result


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_contracts_pending)
	/*
	// Returns the number of contracts held by the AI Brain.
	// This can (and is mainly meant to) be used to throttle the creation of more contracts.
	//
	// As a Utility Consideration, this throttling can be as soft or hard as you want to configure it to be,
	// with binary curves providing a hard cutoff at max number of contracts allowed.
	*/
	var/datum/utility_action_template/candidate = action_template

	if(isnull(requester))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_contracts_pending - Requester must be provided for this Consideration! @ L[__LINE__] in [__FILE__]")
		return null

	if(!istype(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_contracts_pending for [requester] - Candidate is not an ActionTemplate! @ L[__LINE__] in [__FILE__]")
		return null

	var/datum/utility_ai/ai = requester

	if(!istype(ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_contracts_pending for [requester] - Requester is not an AI! @ L[__LINE__] in [__FILE__]")
		return null

	var/datum/brain/requesting_brain = ai.brain

	if(!istype(requesting_brain))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_contracts_pending for [requester] - Requester has no Brain! @ L[__LINE__] in [__FILE__]")
		return null

	var/default = consideration_args?["default"] || 0

	var/result = default
	if(requesting_brain.active_contracts)
		result = length(requesting_brain.active_contracts)

	return result


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_get_our_assets)
	/*
	// Returns the number of contracts held by the AI Brain.
	// This can (and is mainly meant to) be used to throttle the creation of more contracts.
	//
	// As a Utility Consideration, this throttling can be as soft or hard as you want to configure it to be,
	// with binary curves providing a hard cutoff at max number of contracts allowed.
	*/
	var/datum/utility_action_template/candidate = action_template

	if(isnull(requester))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_get_our_assets - Requester must be provided for this Consideration! @ L[__LINE__] in [__FILE__]")
		return null

	if(!istype(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_get_our_assets for [requester] Candidate is not an ActionTemplate! @ L[__LINE__] in [__FILE__]")
		return null

	var/datum/utility_ai/ai = requester

	if(!istype(ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_get_our_assets for [requester] - Requester is not an AI! @ L[__LINE__] in [__FILE__]")
		return null

	var/datum/pawn = ai.GetPawn()

	if(!istype(pawn))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_get_our_assets for [requester] - Requester has no Pawn! @ L[__LINE__] in [__FILE__]")
		return null

	if(isnull(pawn.global_id))
		pawn.InitializeGlobalId()

	var/list/assets = GET_ASSETS_TRACKER(pawn.global_id)
	return assets


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_we_can_fulfill)
	/*
	// Checks if we are able to fulfill a Contract at a given moment.
	// This is defined as being able to ringfence enough of our assets into the Escrow.
	*/
	var/datum/utility_action_template/candidate = action_template

	if(!istype(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_we_can_fulfill Candidate is not an ActionTemplate! @ L[__LINE__] in [__FILE__]")
		return null

	var/from_ctx = TRUE //consideration_args["from_context"]
	if(isnull(from_ctx))
		from_ctx = TRUE

	var/datum/trade_contract/contract = null

	CONSIDERATION_GET_INPUT_KEY(var/input_key)
	if(from_ctx)
		contract = context[input_key]
	else
		contract = consideration_args[input_key]

	if(isnull(requester))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_we_can_fulfill - Requester must be provided for this Consideration! @ L[__LINE__] in [__FILE__]")
		return null

	if(!istype(contract))
		GOAI_LOG_ERROR("ERROR: consideration_we_can_fulfill for [requester] - Contract is not a valid type! @ L[__LINE__] in [__FILE__]")
		return null

	if(!contract.is_open)
		return FALSE

	var/datum/utility_ai/ai = requester

	if(!istype(ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_we_can_fulfill for [requester] - Requester is not an AI! @ L[__LINE__] in [__FILE__]")
		return null

	var/datum/pawn = ai.GetPawn()

	if(!istype(pawn))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_we_can_fulfill for [requester] - Requester has no Pawn! @ L[__LINE__] in [__FILE__]")
		return null

	if(isnull(pawn.global_id))
		pawn.InitializeGlobalId()

	var/list/assets = GET_ASSETS_TRACKER(pawn.global_id)

	if(!assets)
		return FALSE

	var/creator_is_seller = contract.commodity_amount > 0
	var/creator_is_payer = contract.cash_value > 0

	var/datum/creator_datum = contract.creator
	var/datum/contractor_datum = contract.receiver

	var/datum/goods_sender = (creator_is_seller ? creator_datum : contractor_datum)
	var/datum/money_sender = (creator_is_payer ? creator_datum : contractor_datum)

	// initialized as True so we can just do an AND check later.
	var/can_provide_goods = TRUE
	var/can_pay = TRUE

	if(pawn == goods_sender)
		var/goods_needed = contract.EscrowGetNeededAmt(contract.commodity_key)
		var/goods_available = assets[contract.commodity_key]
		can_provide_goods = goods_available >= goods_needed

	if(pawn == money_sender)
		var/cash_needed = contract.EscrowGetNeededAmt(NEED_WEALTH)
		var/cash_available = assets[NEED_WEALTH]
		can_pay = cash_available >= cash_needed

	return (can_provide_goods && can_pay)

