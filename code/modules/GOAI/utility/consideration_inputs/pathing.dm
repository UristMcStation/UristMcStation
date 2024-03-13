/*
// Consideration procs that deal with Pathfinding.
//
// This is a bit more narrow and specific than Spatial - we're ONLY dealing with Paths,
// we don't care on the basis of WHAT they've been constructed. Hell, we could put GOAP
// plan handling here for all I care.
*/


CONSIDERATION_CALL_SIGNATURE(/proc/_cihelper_get_planned_path)
	// This is not a 'proper' Consideration, but it has the same interface as one; it's a way of DRYing
	// the code to fetch a Memory-ized path for various ACTUAL Considerations (e.g. 'Path Exists' or 'Path Length Is...')
	// These proper Considerations should just forward their callsig to this Helper.

	var/datum/brain/requesting_brain = _cihelper_get_requester_brain(requester, "_cihelper_get_planned_path")

	if(!istype(requesting_brain))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("_cihelper_get_planned_path Brain is null ([requesting_brain || "null"]) @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/from_ctx = consideration_args?["from_context"]
	DEBUGLOG_UTILITY_INPUT_FETCHERS("_cihelper_get_planned_path from_ctx is [from_ctx] @ L[__LINE__] in [__FILE__]")
	if(isnull(from_ctx))
		from_ctx = TRUE

	var/pos_key = "position"

	if(!isnull(consideration_args))
		pos_key = consideration_args["input_key"] || pos_key

	var/pos = (from_ctx ? context[pos_key] : consideration_args[pos_key])
	//DEBUGLOG_UTILITY_INPUT_FETCHERS("Raw query target is [raw_qry_target || "null"] @ L[__LINE__] in [__FILE__]")

	if(isnull(pos))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("_cihelper_get_planned_path Target Pos is null ([pos || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	var/path = requesting_brain.GetMemoryValue(MEM_PATH_ACTIVE)

	return path



CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_has_planned_path)
	// Simple binary Consideration - did we plan a path to this location (using any method)?
	// Primarily intended to 'gate' fancy planned move procs behind planning procs.
	// If there is no plan, the Utility of planned moves will be zero and the Utility of *planning* will be high-ish.
	// If there *is* a plan, the Utility of planning will be low, and the Utility of the move will depend on the tactical situation.

	var/path = _cihelper_get_planned_path(action_template, context, requester, consideration_args)

	if(isnull(path))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_has_planned_path Path is null @ L[__LINE__] in [__FILE__]")
		var/default = consideration_args["default"]
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_has_planned_path Path defaulted to [default || "null"] @ L[__LINE__] in [__FILE__]")
		return default

	return TRUE



CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_is_on_chunkpath)
	// Simple binary Consideration - did we plan a path to this location (using any method)?
	// Primarily intended to 'gate' fancy planned move procs behind planning procs.
	// If there is no plan, the Utility of planned moves will be zero and the Utility of *planning* will be high-ish.
	// If there *is* a plan, the Utility of planning will be low, and the Utility of the move will depend on the tactical situation.

	var/from_ctx = consideration_args["from_context"]
	if(isnull(from_ctx))
		from_ctx = TRUE

	var/pos_key = consideration_args["input_key"] || "position"
	var/candidate = (from_ctx ? context[pos_key] : consideration_args[pos_key])

	if(isnull(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_is_on_chunkpath Candidate is null @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/list/path = _cihelper_get_planned_path(action_template, context, requester, consideration_args)

	if(isnull(path))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_is_on_chunkpath Path is null @ L[__LINE__] in [__FILE__]")
		return FALSE

	for(var/datum/chunk/path_chunk in path)
		if(isnull(path_chunk))
			continue

		if(path_chunk.ContainsAtom(candidate))
			return TRUE

	return FALSE



CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_is_on_chunkpath_gradient)
	// Funkier variant of consideration_input_is_on_chunkpath - instead of a boolean, we'll return
	// *the number of path elements left from the last matching position*.
	//
	// Okay, that sounds complicated. Breaking this down - if our candidate is in the last path position,
	// we return 0 - because there's zero steps to travel left after we are there == it's the closest.
	//
	// If our candidate is not on the path at all, we return the length of the whole path (b/c we'd first
	// have to get on the path, then traverse it all).
	//
	// We go through all this trouble because this yields itself nicely to optimization - we know the best case
	// (if it's zero), and everything beyond that is incrementally worse, so we can avoid that with anti<foo> curves.
	//
	// If we tried to maximize a number instead of minimizing that, we would have a problem as we'd have to a priori
	// know the distance to the target on the best possible path, which kinda goes against the whole 'needing pathfinding' idea.

	var/from_ctx = consideration_args["from_context"]
	if(isnull(from_ctx))
		from_ctx = TRUE

	var/pos_key = consideration_args["input_key"] || "position"
	var/candidate = (from_ctx ? context[pos_key] : consideration_args[pos_key])

	if(isnull(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_is_on_chunkpath Candidate is null @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/list/path = _cihelper_get_planned_path(action_template, context, requester, consideration_args)

	if(isnull(path))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_is_on_chunkpath Path is null @ L[__LINE__] in [__FILE__]")
		return FALSE

	for(var/path_idx = path.len + 0, path_idx > 0, path_idx--)
		var/datum/chunk/path_chunk = path[path_idx]

		if(path_chunk?.ContainsAtom(candidate))
			return path.len - path_idx

	return path.len



CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_is_on_path)
	// Like consideration_input_is_on_chunkpath, but works on precise (turf-level) paths instead.

	// The higher this is, the more permissive we are;
	// At 0, only turfs EXACTLY on the path are allowed to terminate.
	// At 1, we can be on the path or adjacent
	// At 2+, it's effectively chunking but with dynamic tile positions (so not cacheable)

	var/from_ctx = DEFAULT_IF_NULL(consideration_args?["from_context"], TRUE)

	var/min_dist_to_path = consideration_args?["minimum_distance_to_path_tile"]
	if(isnull(min_dist_to_path))
		min_dist_to_path = 0

	var/pos_key = consideration_args?["input_key"] || "position"
	var/candidate = (from_ctx ? context[pos_key] : consideration_args[pos_key])

	if(isnull(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_is_on_path Candidate is null @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/list/path = _cihelper_get_planned_path(action_template, context, requester, consideration_args)

	if(isnull(path) || !istype(path))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_is_on_path Path is null @ L[__LINE__] in [__FILE__]")
		var/default_on_null = DEFAULT_IF_NULL(consideration_args?["default_on_null"], FALSE)
		return default_on_null

	for(var/path_idx = (path?.len || 0) + 0, path_idx > 0, path_idx--)
		var/turf/T = path[path_idx]

		if(get_dist(T, candidate) <= min_dist_to_path)
			return TRUE

	return FALSE



CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_is_on_path_gradient)
	// Like consideration_input_is_on_chunkpath_gradient, but works on precise (turf-level) paths instead.

	// The higher this is, the more permissive we are;
	// At 0, only turfs EXACTLY on the path are allowed to terminate.
	// At 1, we can be on the path or adjacent
	// At 2+, it's effectively chunking but with dynamic tile positions (so not cacheable)

	var/from_ctx = consideration_args?["from_context"]
	if(isnull(from_ctx))
		from_ctx = TRUE

	var/min_dist_to_path = consideration_args?["minimum_distance_to_path_tile"]
	if(isnull(min_dist_to_path))
		min_dist_to_path = 0

	var/pos_key = consideration_args?["input_key"] || "position"
	var/candidate = (from_ctx ? context[pos_key] : consideration_args[pos_key])

	if(isnull(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_is_on_path_gradient Candidate is null @ L[__LINE__] in [__FILE__]")
		return FALSE

	var/list/path = _cihelper_get_planned_path(action_template, context, requester, consideration_args)

	if(isnull(path) || !istype(path))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_is_on_path_gradient Path is null @ L[__LINE__] in [__FILE__]")

		var/default_on_null = consideration_args?["default_on_null"]
		if(isnull(default_on_null))
			default_on_null = 0

		return default_on_null

	for(var/path_idx = path.len + 0, path_idx > 0, path_idx--)
		var/turf/T = path[path_idx]

		if(get_dist(T, candidate) <= min_dist_to_path)
			return 1 + (path_idx / path.len)

	return 0
