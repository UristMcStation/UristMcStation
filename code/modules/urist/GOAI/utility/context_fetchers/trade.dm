
CTXFETCHER_CALL_SIGNATURE(/proc/ctxfetcher_get_market_trade_offers)
	// Returns a context for each of the (valid) trade offers posted.

	/*
	if(isnull(context_args))
		UTILITYBRAIN_DEBUG_LOG("ERROR: context_args for ctxfetcher_get_market_trade_offers is null @ L[__LINE__] in [__FILE__]!")
		return
	*/

	var/list/contexts = list()

	if(!(GOAI_LIBBED_GLOB_ATTR(global_marketplace)))
		return contexts

	CONTEXT_GET_OUTPUT_KEY(var/context_key)
	var/now = world.time

	var/requester_pawn = null

	var/datum/utility_ai/requester_ai = requester

	if(istype(requester_ai))
		requester_pawn = requester_ai.GetPawn()

	for(var/offer_key in GOAI_LIBBED_GLOB_ATTR(global_marketplace))
		var/datum/trade_offer/offer = (GOAI_LIBBED_GLOB_ATTR(global_marketplace))[offer_key]

		if(!istype(offer))
			// Exclude null/junk offers
			//GOAI_LOG_DEBUG("ctxfetcher_get_market_trade_offers: Rejecting [offer_key] - junk")
			continue

		if(!(offer.is_open))
			// Exclude bound offers
			//GOAI_LOG_DEBUG("ctxfetcher_get_market_trade_offers: Rejecting [offer_key] - no longer open")
			continue

		if(!(isnull(offer.expiry_time) || (offer.expiry_time > now)))
			// Exclude expired offers
			//GOAI_LOG_DEBUG("ctxfetcher_get_market_trade_offers: Rejecting [offer_key] - expired")
			continue

		if(!(isnull(offer.receiver) || (offer.receiver == requester_pawn)))
			// Exclude offers that are specifically directed at someone else.
			//GOAI_LOG_DEBUG("ctxfetcher_get_market_trade_offers: Rejecting [offer_key] - directed at someone else")
			continue

		if(!isnull(requester_pawn) && (offer.creator == requester_pawn))
			// Exclude our own offers; this should be handled by another CF.
			//GOAI_LOG_DEBUG("ctxfetcher_get_market_trade_offers: Rejecting [offer_key] - we created this")
			continue

		var/list/ctx = list()
		ctx[context_key] = offer
		contexts[++(contexts.len)] = ctx

	return contexts


CTXFETCHER_CALL_SIGNATURE(/proc/ctxfetcher_get_own_contracts)
	// Returns a context for each of the Trade Contracts we participate in

	// This could technically be done by more basic CFs, but this is an abstraction
	// that hides the implementation details of tracking and allows nice pre-filtering.

	var/datum/utility_ai/requester_ai = requester
	var/datum/brain/requesting_brain = null
	var/requester_pawn = null

	if(istype(requester_ai))
		requesting_brain = requester_ai.brain
		requester_pawn = requester_ai.GetPawn()

	if(!istype(requesting_brain))
		GOAI_LOG_ERROR("ERROR: ctxfetcher_get_own_contracts: Brain [requesting_brain] for [requester_ai] is not a valid Brain object! @ L[__LINE__] in [__FILE__]")
		return null

	var/list/contexts = list()

	if(isnull(requester_pawn))
		// We MUST have a pawn to determine if we're a receiver or creator of any given offer
		GOAI_LOG_ERROR("WARNING: ctxfetcher_get_own_contracts: Pawn [requester_pawn] for [requester_ai] is null, no contracts will be found! @ L[__LINE__] in [__FILE__]")
		return contexts

	if(!(requesting_brain.active_contracts))
		// simply don't have any
		return contexts

	CONTEXT_GET_OUTPUT_KEY(var/context_key)

	var/exclude_offered = context_args?["exclude_offered"]
	exclude_offered = DEFAULT_IF_NULL(exclude_offered, FALSE)

	var/exclude_received = context_args?["exclude_received"]
	exclude_received = DEFAULT_IF_NULL(exclude_received, FALSE)

	for(var/contract_key in requesting_brain.active_contracts)
		var/datum/trade_contract/contract = requesting_brain.active_contracts[contract_key]

		if(!istype(contract))
			continue

		if(!contract.is_open)
			continue

		if(exclude_offered && (contract.creator == requester_pawn))
			continue

		if(exclude_received && (contract.receiver == requester_pawn))
			continue

		var/list/ctx = list()
		ctx[context_key] = contract
		contexts[++(contexts.len)] = ctx

	return contexts


CTXFETCHER_CALL_SIGNATURE(/proc/ctxfetcher_get_own_assets)

	var/datum/utility_ai/requester_ai = requester
	var/datum/requester_pawn = null

	if(istype(requester_ai))
		requester_pawn = requester_ai.GetPawn()

	if(!istype(requester_pawn))
		GOAI_LOG_ERROR("ERROR: ctxfetcher_get_own_assets: Pawn [requester_pawn] for [requester_ai] is not a valid object! @ L[__LINE__] in [__FILE__]")
		return null

	var/list/contexts = list()

	CONTEXT_GET_OUTPUT_KEY(var/context_key)

	if(isnull(requester_pawn.global_id))
		requester_pawn.InitializeGlobalId()

	var/list/assets = GET_ASSETS_TRACKER(requester_pawn.global_id)

	if(!isnull(assets))
		var/list/ctx = list()
		ctx[context_key] = assets
		contexts[++(contexts.len)] = ctx

	return contexts
