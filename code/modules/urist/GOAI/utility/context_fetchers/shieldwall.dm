/*
// This will most likely be pretty huge, so it deserves its own file.
//
*/

CTXFETCHER_CALL_SIGNATURE(/proc/ctxfetcher_shieldwall_candidates)
	// This is something of a 'specialized' brother of ctxfetcher_turfs_in_view().
	// Like its sibling, it fetches turfs; unlike it, it pre-filters turfs aggressively.
	// This is to reduce the load on the core Utility evaluation - each turf is a new context,
	// and worst-case we can have 121 turfs in view at the default world.view size.
	// Even with the optimizations, that's a bunch of processing to do per mob.

	// The purpose of this variant is to find positions adjacent to friendlies, such that we form a line.

	if(isnull(requester))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_shieldwall_candidates is null @ L[__LINE__] in [__FILE__]!")
		return null

	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(!istype(requester_ai))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_shieldwall_candidates is not an AI @ L[__LINE__] in [__FILE__]!")
		return null

	var/datum/brain/requesting_brain = requester_ai.brain

	if(!istype(requesting_brain))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requesting_brain for ctxfetcher_shieldwall_candidates is null @ L[__LINE__] in [__FILE__]!")
		return null

	var/list/curr_view = requesting_brain.perceptions[SENSE_SIGHT_CURR]

	if(!istype(curr_view))
		UTILITYBRAIN_DEBUG_LOG("WARNING: curr_view for ctxfetcher_shieldwall_candidates is not a list @ L[__LINE__] in [__FILE__]!")
		return null

	var/turf/unreachable = requesting_brain.GetMemoryValue("UnreachableTile", null)
	var/list/friend_positions = (requesting_brain.GetMemoryValue(MEM_FRIENDS_POSITIONS) || list())
	var/list/enemy_positions = (requesting_brain.GetMemoryValue(MEM_ENEMIES_POSITIONS_LATEST) || list())

	var/context_key = context_args?["output_context_key"] || "position"
	var/require_line = context_args?["require_line"]

	if(isnull(require_line))
		require_line = TRUE

	var/list/contexts = list()
	var/list/processed = friend_positions + enemy_positions // we do not want to look at occupied positions

	var/list/friend_adjacents = list()

	for(var/turf/friend_loc in friend_positions)
		if(isnull(friend_loc))
			continue

		for(var/turf/card_pos in friend_loc.CardinalTurfs())
			if(isnull(card_pos))
				continue

			if(card_pos in processed)
				// friend/enemy occupies, or we've seen it (e.g. from another ally on the other side)
				continue
			else
				processed.Add(card_pos)

			if(card_pos.density)
				// no walls -_-
				continue

			if(!isnull(unreachable) && card_pos == unreachable)
				continue

			// if() // need to add a check if there's any OTHER blockers in here

			if(card_pos in friend_adjacents)
				continue

			if(require_line)
				var/offset_dir = get_dir(friend_loc, card_pos)
				var/reverse_offset_dir = get_dir(card_pos, friend_loc)

				var/turf/nextstep = get_step(card_pos, offset_dir)
				var/turf/reversestep = get_step(friend_loc, reverse_offset_dir)

				//if(!(reversestep.density || reversestep in friend_positions))
				if(!((nextstep.density || nextstep in friend_positions) || (reversestep.density || reversestep in friend_positions)))
				//if(!(nextstep.density || nextstep in friend_positions))
					continue

			// If we got here, we implicitly know this is not occupied by a friend or enemy
			friend_adjacents.Add(card_pos)

	for(var/turf/linepos in friend_adjacents)
		var/list/ctx = list()
		ctx[context_key] = linepos
		contexts[++(contexts.len)] = ctx

	return contexts
