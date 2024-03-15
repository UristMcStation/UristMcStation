/*
// This will most likely be pretty huge, so it deserves its own file.
//
*/

CTXFETCHER_CALL_SIGNATURE(/proc/ctxfetcher_cover_candidates)
	// This is something of a 'specialized' brother of ctxfetcher_turfs_in_view().
	// Like its sibling, it fetches turfs; unlike it, it pre-filters turfs aggressively.
	// This is to reduce the load on the core Utility evaluation - each turf is a new context,
	// and worst-case we can have 121 turfs in view at the default world.view size.
	// Even with the optimizations, that's a bunch of processing to do per mob.

	if(isnull(requester))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_cover_candidates is null @ L[__LINE__] in [__FILE__]!")
		return null

	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(!istype(requester_ai))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requester for ctxfetcher_cover_candidates is not an AI @ L[__LINE__] in [__FILE__]!")
		return null

	var/datum/brain/requesting_brain = requester_ai.brain

	if(!istype(requesting_brain))
		UTILITYBRAIN_DEBUG_LOG("WARNING: requesting_brain for ctxfetcher_cover_candidates is null @ L[__LINE__] in [__FILE__]!")
		return null

	var/list/curr_view = requesting_brain.perceptions[SENSE_SIGHT_CURR]

	if(!istype(curr_view))
		UTILITYBRAIN_DEBUG_LOG("WARNING: curr_view for ctxfetcher_cover_candidates is not a list @ L[__LINE__] in [__FILE__]!")
		return null

	var/turf/unreachable = requesting_brain.GetMemoryValue("UnreachableTile", null)
	var/list/_threats = (requesting_brain.GetMemoryValue(MEM_ENEMIES) || list())
	var/atom/primary_threat = requesting_brain.GetMemoryValue(MEM_THREAT)

	// Note: this may be null, it's optional here
	var/atom/pawn = requester_ai.GetPawn()
	var/mob/pawn_mob = pawn
	var/datum/utility_ai/mob_commander/mob_ai = requester_ai

	var/context_key = context_args?["output_context_key"] || "position"
	var/check_enemies = context_args?["check_enemies"]
	var/min_safe_dist = context_args?["min_safe_dist"] || 2

	if(isnull(check_enemies))
		check_enemies = TRUE

	var/list/contexts = list()
	var/list/processed = list()

	for(var/atom/candidate_cover in curr_view)
		// Need to aggressively trim down processed types here or this will take forever in object-dense areas
		if(!(istype(candidate_cover, /mob) || istype(candidate_cover, /obj/machinery) || istype(candidate_cover, /obj/mecha) || istype(candidate_cover, /obj/structure) || istype(candidate_cover, /obj/vehicle) || istype(candidate_cover, /turf)))
			// need to make it more elegant
			continue

		var/turf/cover_loc = (istype(candidate_cover, /turf) ? candidate_cover : get_turf(candidate_cover))

		if(cover_loc in processed)
			continue
		else
			processed.Add(cover_loc)

		if(!isnull(unreachable) && candidate_cover == unreachable)
			continue

		if(istype(pawn_mob))
			if(!(pawn_mob.MayEnterTurf(cover_loc)))
				continue

		var/has_cover = candidate_cover?.HasCover(get_dir(candidate_cover, primary_threat), FALSE)
		// IsCover here is Transitive=FALSE b/c has_cover will have checked transitives already)
		var/is_cover = candidate_cover?.IsCover(FALSE, get_dir(candidate_cover, primary_threat), FALSE)

		if(!(has_cover || is_cover))
			continue

		var/invalid_tile = FALSE

		if(check_enemies && istype(mob_ai))
			// Skip covers that cannot possibly actually *cover* us
			// NOTE: tempted to yeet that to actual Considerations
			//       for now gated that behind an option
			for(var/atom/enemy in _threats)
				var/threat_dist = mob_ai.GetThreatDistance(cover_loc, enemy)
				var/threat_angle = mob_ai.GetThreatAngle(cover_loc, enemy)
				var/threat_dir = angle2dir(threat_angle)

				var/tile_is_cover = (cover_loc.IsCover(TRUE, threat_dir, FALSE))

				var/atom/maybe_cover = get_step(cover_loc, threat_dir)

				if(maybe_cover && !(tile_is_cover ^ maybe_cover.IsCover(TRUE, threat_dir, FALSE)))
					invalid_tile = TRUE
					break

				if(threat_dist < min_safe_dist)
					invalid_tile = TRUE
					break

		if(invalid_tile)
			continue

		var/list/ctx = list()

		ctx[context_key] = cover_loc
		contexts[++(contexts.len)] = ctx

	return contexts
