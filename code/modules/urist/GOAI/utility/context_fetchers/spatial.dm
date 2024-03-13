
CTXFETCHER_CALL_SIGNATURE(/proc/ctxfetcher_in_pawn_turf)
	// Stuff wot is where we stand

	if(isnull(requester))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_cardinal_turfs is null @ L[__LINE__] in [__FILE__]!")
		return null

	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(isnull(requester_ai))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_cardinal_turfs is not an AI @ L[__LINE__] in [__FILE__]!")
		return null

	var/atom/atom_requester = requester_ai.GetPawn()

	var/turf/requester_tile = get_turf(atom_requester)

	if(isnull(requester_tile))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_cardinal_turfs does not have a turf position! @ L[__LINE__] in [__FILE__]!")
		return null

	var/list/contexts = list()
	var/context_key = context_args?["output_context_key"] || "position"
	var/raw_type = context_args?[CTX_KEY_FILTERTYPE]
	var/filter_output_key = null

	var/filter_type = null

	if(!isnull(raw_type))
		filter_type = text2path(raw_type)
		filter_output_key = context_args?["filter_output_key"]

	var/list/ctx = list()

	if(filter_type)
		var/found_type = locate(filter_type) in requester_tile.contents
		if(!isnull(found_type) && !isnull(filter_output_key))
			ctx[filter_output_key] = found_type

	ctx[context_key] = requester_tile
	contexts[++(contexts.len)] = ctx

	//UTILITYBRAIN_DEBUG_LOG("INFO: added position #[posidx] [pos] context [ctx] (len: [ctx?.len]) to contexts (len: [contexts.len]) @ L[__LINE__] in [__FILE__]!")

	return contexts


CTXFETCHER_CALL_SIGNATURE(/proc/ctxfetcher_turfs_in_view)
	// Returns a simple list of visible turfs, suitable e.g. for pathfinding.

	if(isnull(requester))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_turfs_in_view is null @ L[__LINE__] in [__FILE__]!")
		return null

	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(isnull(requester))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_turfs_in_view is not an AI @ L[__LINE__] in [__FILE__]!")
		return null

	var/atom/pawn = requester_ai.GetPawn()

	var/list/contexts = list()
	var/context_key = context_args["output_context_key"] || "position"
	var/raw_type = context_args?[CTX_KEY_FILTERTYPE]
	var/filter_output_key = null

	var/filter_type = null

	if(!isnull(raw_type))
		filter_type = text2path(raw_type)
		filter_output_key = context_args?["filter_output_key"]

	for(var/turf/pos in view(pawn))
		if(isnull(pos))
			continue

		var/list/ctx = list()

		if(filter_type)
			var/found_type = locate(filter_type) in pos.contents

			if(isnull(found_type))
				continue

			if(!isnull(filter_output_key))
				ctx[filter_output_key] = found_type

		ctx[context_key] = pos
		contexts[++(contexts.len)] = ctx
		//UTILITYBRAIN_DEBUG_LOG("INFO: added position #[posidx] [pos] context [ctx] (len: [ctx?.len]) to contexts (len: [contexts.len]) @ L[__LINE__] in [__FILE__]!")

	return contexts


CTXFETCHER_CALL_SIGNATURE(/proc/ctxfetcher_adjacent_turfs)
	// Returns a simple list of visible turfs, suitable e.g. for pathfinding.

	if(isnull(requester))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_turfs_in_view is null @ L[__LINE__] in [__FILE__]!")
		return null

	if(isnull(requester))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_turfs_in_view is null @ L[__LINE__] in [__FILE__]!")
		return null

	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(isnull(requester))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_turfs_in_view is not an AI @ L[__LINE__] in [__FILE__]!")
		return null

	var/atom/atom_requester = requester_ai.GetPawn()

	if(isnull(atom_requester))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_adjacent_turfs is not an atom! @ L[__LINE__] in [__FILE__]!")
		return null

	var/list/contexts = list()
	var/context_key = context_args["output_context_key"] || "position"
	var/raw_type = context_args?[CTX_KEY_FILTERTYPE]
	var/filter_output_key = null

	var/filter_type = null

	if(!isnull(raw_type))
		filter_type = text2path(raw_type)
		filter_output_key = context_args?["filter_output_key"]

	for(var/turf/pos in trangeGeneric(1, atom_requester.x, atom_requester.y, atom_requester.z))
		if(isnull(pos))
			continue

		var/list/ctx = list()

		if(filter_type)
			var/found_type = locate(filter_type) in pos.contents

			if(isnull(found_type))
				continue

			if(!isnull(filter_output_key))
				ctx[filter_output_key] = found_type

		ctx[context_key] = pos
		contexts[++(contexts.len)] = ctx
		//UTILITYBRAIN_DEBUG_LOG("INFO: added position #[posidx] [pos] context [ctx] (len: [ctx?.len]) to contexts (len: [contexts.len]) @ L[__LINE__] in [__FILE__]!")

	return contexts


CTXFETCHER_CALL_SIGNATURE(/proc/ctxfetcher_cardinal_turfs)
	// Returns a simple list of visible turfs, suitable e.g. for pathfinding.

	if(isnull(requester))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_cardinal_turfs is null @ L[__LINE__] in [__FILE__]!")
		return null

	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(isnull(requester_ai))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_cardinal_turfs is not an AI @ L[__LINE__] in [__FILE__]!")
		return null

	var/atom/atom_requester = requester_ai.GetPawn()

	var/turf/requester_tile = get_turf(atom_requester)

	if(isnull(requester_tile))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_cardinal_turfs does not have a turf position! @ L[__LINE__] in [__FILE__]!")
		return null

	var/list/contexts = list()
	var/context_key = context_args?["output_context_key"] || "position"
	var/raw_type = context_args?[CTX_KEY_FILTERTYPE]
	var/filter_output_key = null

	var/filter_type = null

	if(!isnull(raw_type))
		filter_type = text2path(raw_type)
		filter_output_key = context_args?["filter_output_key"]

	for(var/turf/pos in requester_tile.CardinalTurfs())
		if(isnull(pos))
			continue

		var/list/ctx = list()

		if(filter_type)
			var/found_type = locate(filter_type) in pos.contents
			if(isnull(found_type))
				continue

			if(!isnull(filter_output_key))
				ctx[filter_output_key] = found_type

		ctx[context_key] = pos
		contexts[++(contexts.len)] = ctx
		//UTILITYBRAIN_DEBUG_LOG("INFO: added position #[posidx] [pos] context [ctx] (len: [ctx?.len]) to contexts (len: [contexts.len]) @ L[__LINE__] in [__FILE__]!")

	return contexts
