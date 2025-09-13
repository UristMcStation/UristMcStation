
CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_target_manhattan_distance_to_squad_pos)
	// This is a specialized version of the Spatial Considerations.
	// We could theoretically make it work with consideration_input_distance_to_arg, but
	// since Squads are pure data with 'fake' coords, this would have been fairly obnoxious.

	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(isnull(requester_ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_manhattan_distance_to_squad_pos Requester is not an AI (from [NULL_TO_TEXT(requester)] raw val) @ L[__LINE__] in [__FILE__]")
		return null

	var/datum/brain/ai_brain = requester_ai.brain

	if(!istype(ai_brain))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_manhattan_distance_to_squad_pos Requester has no Brain! (brain: [NULL_TO_TEXT(ai_brain)]) @ L[__LINE__] in [__FILE__]")
		return null

	var/datum/squad/our_squad = ai_brain.GetSquad()

	if(!istype(our_squad))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_manhattan_distance_to_squad_pos Requester has no Squad! (squad: [NULL_TO_TEXT(our_squad)], ID: [ai_brain.squad_idx]) @ L[__LINE__] in [__FILE__]")
		return null

	// How far from the center of the squad we can be
	// Mechanically, we subtract the radius from the full distance and max(0, ...) it,
	// so all positions within the radius are the same distance from the center.
	var/radius = consideration_args?["radius"] || 0

	var/frompos_key = consideration_args?["from_key"]
	var/from_pawn = consideration_args?["from_pawn"] || FALSE
	var/from_memory = consideration_args?["from_memory"] || FALSE
	var/from_context = consideration_args?["from_context"] || FALSE
	var/atom/frompos = null

	if(from_pawn)
		frompos = requester_ai.GetPawn()

	if(from_memory)
		frompos = ai_brain.GetMemoryValue(frompos_key)

	if(from_context)
		frompos = context?[frompos_key]

	if(isnull(frompos))
		frompos = consideration_args[frompos_key]

	if(!istype(frompos))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_manhattan_distance_to_squad_pos invalid input Position ([NULL_TO_TEXT(frompos)]) @ L[__LINE__] in [__FILE__]")
		return null

	// Z-level distance penalty multiplier; we usually want pawns to navigate to the same Z-level rather than spreading out across floors.
	//
	// Worked example: if mult=5, then a tile directly above the goal is counted as a distance of 5, and the next floor up - as 10.
	//   Similarly, the tile *right next* to goal is 1, the same position but on the next Z-level is 6, and two up is 11.
	//
	// If set to a very high value, e.g. 1e6, will tend to ignore positions on adjacent Z-levels and cluster them horizontally.
	// Conversely at very low values, e.g. 0.1, will tend to spread squaddies out vertically across different Z-levels.
	//
	// DEFAULT: 10, somewhat arbitrarily. Should be high enough to discourage, but not outright ban, multi-z spread.
	var/zdelta_penalty_mult = consideration_args?["zdelta_penalty_mult"] || 10

	var/raw_result = MANHATTAN_DISTANCE_NUMERIC_THREED(frompos.x, frompos.y, frompos.z, our_squad.x, our_squad.y, our_squad.z, zdelta_penalty_mult)
	var/result = max(0, (raw_result - radius))
	return result


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_manhattan_distance_delta_to_squad_pos)
	// Similar to consideration_input_target_manhattan_distance_to_squad_pos(), but calculates the DELTA
	// between two positions I & C (usually, initial and candidate) as:
	//
	//     Delta = Dist(I, Squad) - Dist(C, Squad).
	//
	// In other words, the higher the value, the more the move to C brings us towards the squad.

	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(isnull(requester_ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_manhattan_distance_to_squad_pos Requester is not an AI (from [NULL_TO_TEXT(requester)] raw val) @ L[__LINE__] in [__FILE__]")
		return null

	var/datum/brain/ai_brain = requester_ai.brain

	if(!istype(ai_brain))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_manhattan_distance_to_squad_pos Requester has no Brain! (brain: [NULL_TO_TEXT(ai_brain)]) @ L[__LINE__] in [__FILE__]")
		return null

	var/datum/squad/our_squad = ai_brain.GetSquad()

	if(!istype(our_squad))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_manhattan_distance_to_squad_pos Requester has no Squad! (squad: [NULL_TO_TEXT(our_squad)], ID: [ai_brain.squad_idx]) @ L[__LINE__] in [__FILE__]")
		return null

	var/radius = consideration_args?["radius"] || 0

	var/frompos_key = consideration_args?["from_key"]
	var/from_from_pawn = consideration_args?["from_from_pawn"] || FALSE
	var/from_from_memory = consideration_args?["from_from_memory"] || FALSE
	var/from_from_context = consideration_args?["from_from_context"] || FALSE
	var/atom/frompos = null

	var/topos_key = consideration_args?["to_key"]
	var/to_from_pawn = consideration_args?["to_from_pawn"] || FALSE
	var/to_from_memory = consideration_args?["to_from_memory"] || FALSE
	var/to_from_context = consideration_args?["to_from_context"] || FALSE
	var/atom/topos = null

	if(from_from_pawn)
		frompos = requester_ai.GetPawn()

	if(from_from_memory)
		frompos = ai_brain.GetMemoryValue(frompos_key)

	if(from_from_context)
		frompos = context?[frompos_key]

	if(isnull(frompos))
		frompos = consideration_args[frompos_key]

	if(!istype(frompos))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_manhattan_distance_to_squad_pos invalid FROM Position ([NULL_TO_TEXT(frompos)]) @ L[__LINE__] in [__FILE__]")
		return null

	if(to_from_pawn)
		topos = requester_ai.GetPawn()

	if(to_from_memory)
		topos = ai_brain.GetMemoryValue(topos_key)

	if(to_from_context)
		topos = context?[topos_key]

	if(isnull(topos))
		topos = consideration_args[topos_key]

	if(!istype(topos))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_manhattan_distance_to_squad_pos invalid TO Position ([NULL_TO_TEXT(frompos)]) @ L[__LINE__] in [__FILE__]")
		return null

	// Z-level distance penalty multiplier; we usually want pawns to navigate to the same Z-level rather than spreading out across floors.
	//
	// Worked example: if mult=5, then a tile directly above the goal is counted as a distance of 5, and the next floor up - as 10.
	//   Similarly, the tile *right next* to goal is 1, the same position but on the next Z-level is 6, and two up is 11.
	//
	// If set to a very high value, e.g. 1e6, will tend to ignore positions on adjacent Z-levels and cluster them horizontally.
	// Conversely at very low values, e.g. 0.1, will tend to spread squaddies out vertically across different Z-levels.
	//
	// DEFAULT: 10, somewhat arbitrarily. Should be high enough to discourage, but not outright ban, multi-z spread.
	var/zdelta_penalty_mult = consideration_args?["zdelta_penalty_mult"] || 10

	var/raw_from_dist = MANHATTAN_DISTANCE_NUMERIC_THREED(frompos.x, frompos.y, frompos.z, our_squad.x, our_squad.y, our_squad.z, zdelta_penalty_mult)
	var/raw_to_dist = MANHATTAN_DISTANCE_NUMERIC_THREED(topos.x, topos.y, topos.z, our_squad.x, our_squad.y, our_squad.z, zdelta_penalty_mult)

	var/from_dist = max(0, (raw_from_dist - radius))
	var/to_dist = max(0, (raw_to_dist - radius))

	var/result = (from_dist - to_dist)
	return result


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_squad_autonomy)
	// Returns the Autonomy of the squad we belong to.
	//
	// Autonomy controls how much we defer decisions to the squad itself;
	// the lower, the more control an external system (another AI or the player) has.
	//
	// Linear(Lo=0, Hi=1) enables an Action ONLY if squad has autonomy, for example.

	var/datum/utility_ai/mob_commander/requester_ai = requester
	var/default = consideration_args?["default"]

	if(isnull(requester_ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_rank_in_squad Requester is not an AI (from [NULL_TO_TEXT(requester)] raw val) @ L[__LINE__] in [__FILE__]")
		return default

	var/datum/brain/ai_brain = requester_ai.brain

	if(!istype(ai_brain))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_rank_in_squad Requester has no Brain! (brain: [NULL_TO_TEXT(ai_brain)]) @ L[__LINE__] in [__FILE__]")
		return default

	var/atom/pawn = requester_ai.GetPawn()

	if(!istype(pawn))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_rank_in_squad Requester has no Pawn! (brain: [NULL_TO_TEXT(ai_brain)]) @ L[__LINE__] in [__FILE__]")
		return default

	var/datum/squad/our_squad = ai_brain.GetSquad()

	if(!istype(our_squad))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_rank_in_squad Requester has no Squad! (squad: [NULL_TO_TEXT(our_squad)], ID: [ai_brain.squad_idx]) @ L[__LINE__] in [__FILE__]")
		return default

	if(!our_squad.members)
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_input_rank_in_squad Squad (ID: [ai_brain.squad_idx]) has no members, but we are somehow still in it! @ L[__LINE__] in [__FILE__]")
		return default

	var/require_found = consideration_args?["require_found"]
	var/found = FALSE
	var/rank = 0

	for(var/atom/squaddie in our_squad.members)
		rank++

		if(squaddie == pawn)
			found = TRUE
			break

	var/result = rank

	if(require_found && !found)
		result = default

	return result


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_rank_in_squad)
	// Returns the rank of the Pawn in the squad it belongs to.
	// Lower is higher, e.g. 1 is Leader, 2 is Second-in-Command, etc.
	//
	// Linear(Lo=1, Hi=2) gives you all *non-Leader* squaddies, e.g. for following.
	// Antilinear(Lo=1, Hi=2) conversely gives you the Leader, e.g. for setting orders.

	var/datum/utility_ai/mob_commander/requester_ai = requester
	var/default = consideration_args?["default"]

	if(isnull(requester_ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_rank_in_squad Requester is not an AI (from [NULL_TO_TEXT(requester)] raw val) @ L[__LINE__] in [__FILE__]")
		return default

	var/datum/brain/ai_brain = requester_ai.brain

	if(!istype(ai_brain))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_rank_in_squad Requester has no Brain! (brain: [NULL_TO_TEXT(ai_brain)]) @ L[__LINE__] in [__FILE__]")
		return default

	var/atom/pawn = requester_ai.GetPawn()

	if(!istype(pawn))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_rank_in_squad Requester has no Pawn! (brain: [NULL_TO_TEXT(ai_brain)]) @ L[__LINE__] in [__FILE__]")
		return default

	var/datum/squad/our_squad = ai_brain.GetSquad()

	if(!istype(our_squad))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_rank_in_squad Requester has no Squad! (squad: [NULL_TO_TEXT(our_squad)], ID: [ai_brain.squad_idx]) @ L[__LINE__] in [__FILE__]")
		return default

	if(!our_squad.members)
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: consideration_input_rank_in_squad Squad (ID: [ai_brain.squad_idx]) has no members, but we are somehow still in it! @ L[__LINE__] in [__FILE__]")
		return default

	var/require_found = consideration_args?["require_found"]
	var/found = FALSE
	var/rank = 0

	for(var/atom/squaddie in our_squad.members)
		rank++

		if(squaddie == pawn)
			found = TRUE
			break

	var/result = rank

	if(require_found && !found)
		result = default

	return result
