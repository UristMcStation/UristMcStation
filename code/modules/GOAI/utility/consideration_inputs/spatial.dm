

CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_manhattan_distance_to_requester)
	//
	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(isnull(requester_ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("Requester is not an AI (from [requester || "null"] raw val) @ L[__LINE__] in [__FILE__]")
		return null

	var/atom/requester_entity = requester_ai?.GetPawn()

	if(isnull(requester_entity))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("Requesting identity is null (from [requester || "null"] raw val) @ L[__LINE__] in [__FILE__]")
		return null

	var/from_ctx = consideration_args?["from_context"]
	if(isnull(from_ctx))
		from_ctx = TRUE

	var/pos_key = consideration_args?["input_key"] || "position"

	var/raw_qry_target = (from_ctx ? context[pos_key] : consideration_args[pos_key])
	if(isnull(raw_qry_target))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_manhattan_distance_to_requester raw_qry_target is null ([raw_qry_target || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	var/atom/query_target = raw_qry_target
	//DEBUGLOG_UTILITY_INPUT_FETCHERS("Query target is [query_target || "null"] @ L[__LINE__] in [__FILE__]")

	if(isnull(query_target))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_manhattan_distance_to_requester query_target is null ([query_target || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	var/result = ManhattanDistance(requester_entity, query_target)
	//DEBUGLOG_UTILITY_INPUT_FETCHERS("ManhattanDistance input is [result || "null"] @ L[__LINE__] in [__FILE__]")
	return result


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_chebyshev_distance_to_requester)
	//
	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(isnull(requester_ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("Requester is not an AI (from [requester || "null"] raw val) @ L[__LINE__] in [__FILE__]")
		return null

	var/atom/requester_entity = requester_ai?.GetPawn()

	if(isnull(requester_entity))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("Requesting identity is null (from [requester || "null"] raw val) @ L[__LINE__] in [__FILE__]")
		return null

	var/from_ctx = consideration_args?["from_context"]
	if(isnull(from_ctx))
		from_ctx = TRUE

	var/pos_key = consideration_args?["input_key"] || "position"

	var/raw_qry_target = (from_ctx ? context[pos_key] : consideration_args[pos_key])
	if(isnull(raw_qry_target))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_chebyshev_distance_to_requester raw_qry_target is null ([raw_qry_target || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	var/atom/query_target = raw_qry_target
	//DEBUGLOG_UTILITY_INPUT_FETCHERS("Query target is [query_target || "null"] @ L[__LINE__] in [__FILE__]")

	if(isnull(query_target))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_chebyshev_distance_to_requester query_target is null ([query_target || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	var/result = ChebyshevDistance(requester_entity, query_target)
	//DEBUGLOG_UTILITY_INPUT_FETCHERS("ManhattanDistance input is [result || "null"] @ L[__LINE__] in [__FILE__]")
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
		DEBUGLOG_UTILITY_INPUT_FETCHERS("Requester is not an AI (from [requester || "null"] raw val) @ L[__LINE__] in [__FILE__]")
		return null

	var/atom/requester_atom = requester_ai?.GetPawn()
	DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_is_passable blocked is [blocked] @ L[__LINE__] in [__FILE__]")

	if(!isnull(requester_atom))
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



CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_in_line_of_sight)
	// Checks whether we have a clear LoS to the target.
	// WARNING: this check is pretty expensive, you should put it near the tail of the Consideration array.
	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(isnull(requester_ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_in_line_of_sight requester_ai is null ([requester_ai || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	var/mob/pawn = requester_ai?.GetPawn()

	if(isnull(pawn))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_in_line_of_sight Pawn is null @ L[__LINE__] in [__FILE__]")
		return null

	var/from_ctx = consideration_args["from_context"]
	if(isnull(from_ctx))
		from_ctx = TRUE

	var/pos_key = consideration_args["input_key"] || "position"
	var/candidate = (from_ctx ? context[pos_key] : consideration_args[pos_key])

	if(isnull(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_in_line_of_sight Candidate is null @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/forecasted_impactee = AtomDensityRaytrace(pawn, candidate, list(pawn))

	return ( (forecasted_impactee == candidate) )//|| (get_dist(forecasted_impactee, candidate) == 0) )
