

CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_manhattan_distance_to_requester)
	//
	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(isnull(requester_ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("Requester is not an AI (from [NULL_TO_TEXT(requester)] raw val) @ L[__LINE__] in [__FILE__]")
		return null

	var/atom/requester_entity = requester_ai?.GetPawn()

	if(!istype(requester_entity))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("Requesting identity is invalid (from [NULL_TO_TEXT(requester)] raw val) @ L[__LINE__] in [__FILE__]")
		return null

	var/default = consideration_args?["default"]
	var/from_memory = consideration_args?["from_memory"]
	var/from_ctx = consideration_args?["from_context"]

	if(isnull(from_ctx))
		from_ctx = !from_memory

	var/pos_key = consideration_args?[CONSIDERATION_INPUTKEY_KEY] || "position"

	var/raw_qry_target = null

	if(from_memory)
		var/datum/brain/ai_brain = requester_ai.brain

		if(!istype(ai_brain))
			DEBUGLOG_UTILITY_INPUT_FETCHERS("Requester has no Brain (from [NULL_TO_TEXT(requester)] raw val) @ L[__LINE__] in [__FILE__]")
			return default

		raw_qry_target = ai_brain.GetMemoryValue(pos_key)

	else if(from_ctx)
		raw_qry_target = context[pos_key]

	else
		raw_qry_target = consideration_args[pos_key]

	if(isnull(raw_qry_target))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_manhattan_distance_to_requester raw_qry_target is null ([raw_qry_target || "null"]) @ L[__LINE__] in [__FILE__]")
		return default

	var/atom/query_target = raw_qry_target

	if(isnull(query_target))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_manhattan_distance_to_requester query_target is null ([query_target || "null"]) @ L[__LINE__] in [__FILE__]")
		return default

	var/result = ManhattanDistance(requester_entity, query_target)
	return result


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_chebyshev_distance_to_requester)
	//
	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(isnull(requester_ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("Requester is not an AI (from [NULL_TO_TEXT(requester)] raw val) @ L[__LINE__] in [__FILE__]")
		return null

	var/atom/requester_entity = requester_ai?.GetPawn()

	if(!istype(requester_entity))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("Requesting identity is invalid (from [NULL_TO_TEXT(requester)] raw val) @ L[__LINE__] in [__FILE__]")
		return null

	var/from_memory = consideration_args?["from_memory"]

	var/from_ctx = consideration_args?["from_context"]
	if(isnull(from_ctx))
		from_ctx = !from_memory

	var/pos_key = consideration_args?[CONSIDERATION_INPUTKEY_KEY] || "position"

	var/raw_qry_target = null

	if(from_memory)
		raw_qry_target = _cihelper_get_brain_data(action_template, context, requester, consideration_args)

	else if(from_ctx)
		raw_qry_target = context[pos_key]

	else
		raw_qry_target = consideration_args[pos_key]

	if(isnull(raw_qry_target))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_chebyshev_distance_to_requester raw_qry_target is null ([raw_qry_target || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	var/atom/query_target = raw_qry_target
	//DEBUGLOG_UTILITY_INPUT_FETCHERS("Query target is [query_target || "null"] @ L[__LINE__] in [__FILE__]")

	if(isnull(query_target))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_chebyshev_distance_to_requester query_target is null ([query_target || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	var/result = ChebyshevDistance(requester_entity, query_target)
	return result


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_manhattan_distance_to_tagged_target)
	//
	var/search_tag = consideration_args?["locate_tag_as_target"]

	if(isnull(search_tag))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("Target tag is null (from [search_tag || "null"] raw val) @ L[__LINE__] in [__FILE__]")
		return null

	var/atom/tag_target = locate(search_tag)

	if(isnull(tag_target))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("Tagged target not found (from [search_tag || "null"] raw val) @ L[__LINE__] in [__FILE__]")
		return null

	var/raw_qry_target = context[CTX_KEY_POSITION]
	//DEBUGLOG_UTILITY_INPUT_FETCHERS("Raw query target is [raw_qry_target || "null"] @ L[__LINE__] in [__FILE__]")

	var/atom/query_target = raw_qry_target
	//DEBUGLOG_UTILITY_INPUT_FETCHERS("Query target is [query_target || "null"] @ L[__LINE__] in [__FILE__]")

	if(isnull(query_target))
		return null

	var/result = ManhattanDistance(tag_target, query_target)
	//DEBUGLOG_UTILITY_INPUT_FETCHERS("ManhattanDistance input is [result || "null"] @ L[__LINE__] in [__FILE__]")
	return result


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_is_passable)
	//
	var/default_from_arg = consideration_args?["default"]
	var/default = isnull(default_from_arg) ? TRUE : default_from_arg

	var/raw_queried_object = context[CTX_KEY_POSITION]
	//DEBUGLOG_UTILITY_INPUT_FETCHERS("Raw query target is [raw_qry_target || "null"] @ L[__LINE__] in [__FILE__]")

	var/turf/queried_turf = raw_queried_object
	//DEBUGLOG_UTILITY_INPUT_FETCHERS("Query target is [query_target || "null"] @ L[__LINE__] in [__FILE__]")

	if(isnull(raw_queried_object))
		return default

	var/raw_find_type = consideration_args?["locate_type_as_target"]
	var/find_type = text2path(raw_find_type)
	DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_is_passable find_type is [find_type || "null"] ([raw_find_type || "null"]) @ L[__LINE__] in [__FILE__]")

	if(!isnull(find_type))
		var/atom/found_instance = (locate(find_type) in queried_turf.contents)

		if(isnull(found_instance))
			DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_is_passable found_instance is null @ L[__LINE__] in [__FILE__]")
			return default

		var/datum/directional_blocker/dirblocker = found_instance.GetBlockerData(TRUE, TRUE)

		if(isnull(dirblocker))
			DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_is_passable DirBlocker is null @ L[__LINE__] in [__FILE__]")
			return TRUE

		var/instance_result = !(dirblocker.is_active && dirblocker.block_all)
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_is_passable instance_result is [instance_result] @ L[__LINE__] in [__FILE__]")
		return instance_result

	// Basic implementation not using colliders yet!!!
	var/blocked = queried_turf.IsBlocked(TRUE, FALSE)

	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(isnull(requester_ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("Requester is not an AI (from [NULL_TO_TEXT(requester)] raw val) @ L[__LINE__] in [__FILE__]")
		return null

	var/atom/requester_atom = requester_ai?.GetPawn()
	DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_is_passable blocked is [blocked] @ L[__LINE__] in [__FILE__]")

	if(istype(requester_atom))
		if(get_dist(requester_atom, queried_turf) <= 1)
			var/turf/requester_turf = get_turf(requester_atom)
			var/entry_dir = get_dir(requester_turf, queried_turf)

			// Can we exit the current pos in that direction?
			blocked = blocked || GoaiDirBlocked(requester_turf, null, entry_dir)

			// Can we enter the target pos from that direction?
			blocked = blocked || GoaiDirBlocked(queried_turf, entry_dir, null)

	var/result = (!blocked)
	DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_is_passable result is [result] @ L[__LINE__] in [__FILE__]")
	return result


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_raytrace_impactee_distance_to_target)
	// Checks whether we have a clear LoS to the target.
	// If we do, this
	// WARNING: this check is pretty expensive, you should put it near the tail of the Consideration array.
	// Target can be fetched from args, context, or memories
	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(isnull(requester_ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_raytrace_impactee_distance_to_target requester_ai is null ([requester_ai || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	var/atom/pawn = requester_ai?.GetPawn()

	if(!istype(pawn))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_raytrace_impactee_distance_to_target Pawn is null @ L[__LINE__] in [__FILE__]")
		return null

	var/default = consideration_args["default"] || PLUS_INF
	var/strict = consideration_args["strict"] || FALSE  // only accept strict identity (in case cover is in the same tile)
	var/reverse = consideration_args["reverse"] || FALSE  // raytrace from target to source instead of the opposite (for self-cover checks)
	CONSIDERATION_GET_INPUT_KEY(var/pos_key)
	var/check_glancing_angles = consideration_args["check_glancing_angles"] || FALSE
	var/candidate = null

	var/from_ctx = FALSE
	var/from_memory_key = FALSE

	var/datum/brain/requesting_brain = _cihelper_get_requester_brain(requester, "consideration_input_raytrace_impactee_distance_to_target")

	if(isnull(candidate))
		// Try context:
		from_ctx = consideration_args["from_context"]
		if(isnull(from_ctx))
			from_ctx = TRUE

		if(from_ctx)
			candidate = context[pos_key]

	if(isnull(candidate))
		// Try memories:
		from_memory_key = consideration_args["from_memory_key"]
		if(isnull(from_memory_key))
			from_memory_key = FALSE

		if(from_memory_key)
			if(!istype(requesting_brain))
				DEBUGLOG_MEMORY_FETCH("consideration_input_raytrace_impactee_distance_to_target Brain is null ([requesting_brain || "null"]) @ L[__LINE__] in [__FILE__]")
				return default

			candidate = requesting_brain.GetMemoryValue(from_memory_key)

	if(isnull(candidate))
		// Try args:
		candidate = consideration_args?[pos_key]

	if(isnull(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_in_line_of_sight Candidate is null @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/raytype = consideration_args?["raytype"]
	if(isnull(raytype))
		raytype = RAYTYPE_LOS

	var/ignore_enemies = consideration_args?["ignore_enemies"]

	var/list/enemies = null
	if(ignore_enemies && istype(requesting_brain))
		enemies = requesting_brain?.GetMemoryValue(MEM_ENEMIES)

	var/list/ignorelist = ((reverse || isnull(enemies)) ? list() : enemies.Copy())

	if(reverse)
		ignorelist.Add(candidate)
	else
		ignorelist.Add(pawn)

	var/atom/forecasted_impactee = (reverse ? AtomDensityRaytrace(candidate, pawn, ignorelist, raytype, check_glancing_angles) : AtomDensityRaytrace(pawn, candidate, ignorelist, raytype, check_glancing_angles))

	if(isnull(forecasted_impactee))
		return default

	var/result = default

	if(strict)
		result = reverse ? ((forecasted_impactee == pawn) ? 0 : default) : ((forecasted_impactee == candidate) ? 0 : default)

	else
		result = reverse ? get_dist(forecasted_impactee, pawn) : get_dist(forecasted_impactee, candidate)

	return result


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_distance_to_arg)
	//
	var/default = consideration_args?["default"]
	var/frompos_key = consideration_args?["from_key"]
	var/topos_key = consideration_args?["to_key"]
	var/disttype = consideration_args?["disttype"] || 0

	var/atom/frompos = null
	var/atom/topos = null

	if(isnull(frompos_key))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("WARNING: consideration_input_manhattan_distance_to_arg 'from_key' is null @ L[__LINE__] in [__FILE__]")
		return default

	if(isnull(topos_key))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("WARNING: consideration_input_manhattan_distance_to_arg 'to_key' is null @ L[__LINE__] in [__FILE__]")
		return default

	var/from_from_memory = consideration_args?["from_from_memory"] || FALSE
	var/to_from_memory = consideration_args?["from_from_memory"] || FALSE

	var/from_from_context = consideration_args?["from_from_context"] || FALSE
	var/to_from_context = consideration_args?["to_from_context"] || FALSE

	if(from_from_memory || to_from_memory)
		var/datum/utility_ai/mob_commander/requester_ai = requester

		if(!istype(requester_ai))
			UTILITYBRAIN_DEBUG_LOG("WARNING: requester for consideration_input_manhattan_distance_to_arg is not an AI @ L[__LINE__] in [__FILE__]!")
			return null

		var/datum/brain/requesting_brain = requester_ai.brain

		if(!istype(requesting_brain))
			UTILITYBRAIN_DEBUG_LOG("WARNING: requesting_brain for consideration_input_manhattan_distance_to_arg is null @ L[__LINE__] in [__FILE__]!")
			return null

		if(from_from_memory)
			frompos = requesting_brain.GetMemoryValue(frompos_key)

		if(to_from_memory)
			topos = requesting_brain.GetMemoryValue(topos_key)

	if(from_from_context)
		frompos = context?[frompos_key]

	if(to_from_context)
		topos = context?[topos_key]

	if(isnull(frompos))
		frompos = consideration_args[frompos_key]

	if(isnull(frompos))
		UTILITYBRAIN_DEBUG_LOG("WARNING: frompos for consideration_input_manhattan_distance_to_arg is null @ L[__LINE__] in [__FILE__]!")
		return default

	if(isnull(topos))
		topos = consideration_args[topos_key]

	if(isnull(topos))
		UTILITYBRAIN_DEBUG_LOG("WARNING: topos for consideration_input_manhattan_distance_to_arg is null @ L[__LINE__] in [__FILE__]!")
		return default

	var/result

	switch(disttype)
		if(0) result = get_dist(frompos, topos)
		if(1) result = ManhattanDistance(frompos, topos)

	return result
