# define COMBAT_WAYFINDER_LOG(X) to_world_log(X)

/sense/combatant_commander_coverleap_wayfinder
	/* Pathfinding service for 'alert' (non-relaxed) movement.
	//
	// Periodically selects the best position to move to and adds
	// Actions that allow the owner to move to that position.
	//
	// The waypoint is selected by ignoring obstacles with handlers.
	// Such obstacles that can be overcome with an Action,
	// e.g. doors (Open/Break), tables (Climb), etc..
	//
	// If the movement is unobstructed, the move will be a single Action.
	// Otherwise, we split the move into three stages:
	// 1) Approach the obstacle
	// 2) Deal with the obstacle
	// 3) Go to the actual target
	//
	// Note that this sequence is still subject to normal GOAI planning;
	// any of the stages' Actions might have Preconditions that require
	// additional steps to be sandwiched between the stages above.
	*/
	var/last_run_time = null


/sense/combatant_commander_coverleap_wayfinder/proc/ScorePositions(var/datum/goai/mob_commander/owner, var/atom/startpos = null, var/atom/primary_threat = null, var/turf/prev_loc_memdata = null, var/list/threats = null, var/min_safe_dist = null)
	if(!(owner && istype(owner)))
		COMBAT_WAYFINDER_LOG("[src] does not have an owner! <[owner]>")
		return

	var/datum/brain/brain = owner.brain
	if(!(brain && istype(brain)))
		COMBAT_WAYFINDER_LOG("[owner] does not have a brain! <[brain]>")
		return

	var/atom/pawn = owner.GetPawn()

	if(!pawn)
		COMBAT_WAYFINDER_LOG("[src] does not have an owned pawn!")
		return

	var/pathing_fuzz_factor = owner.pathfinding_fuzz_perc
	var/waypoint_fuzz_tiles_x = owner.waypoint_fuzz_tiles_x
	var/waypoint_fuzz_tiles_y = owner.waypoint_fuzz_tiles_y

	// Pathfinding/search
	var/atom/_startpos = (startpos || get_turf(pawn))
	var/list/_threats = (threats || list())
	var/_min_safe_dist = (isnull(min_safe_dist) ? 0 : min_safe_dist)

	//var/list/processed = list(_startpos)
	var/list/processed = list()

	var/PriorityQueue/cover_queue = new /PriorityQueue(/datum/Quadruple/proc/TriCompare)

	var/datum/chunkserver/chunkserver = GetOrSetChunkserver()
	var/datum/chunk/startchunk = chunkserver.ChunkForAtom(_startpos)

	var/list/curr_view = brain?.perceptions?.Get(SENSE_SIGHT_CURR)
	curr_view.Add(_startpos)

	var/turf/safespace_loc = brain?.GetMemoryValue(MEM_SAFESPACE, null)
	if(safespace_loc)
		curr_view.Add(safespace_loc)

	var/turf/hysteresis_bestpos = brain.GetMemoryValue("LastBestPos", null)

	var/effective_waypoint_x = null
	var/effective_waypoint_y = null

	var/mob/pawn_mob = pawn

	var/atom/waypoint_ident = brain?.GetMemoryValue(MEM_WAYPOINT_IDENTITY, null, FALSE, TRUE)
	var/datum/chunk/waypointchunk = null

	if(waypoint_ident)
		// This only applies to the case where the brain has a Waypoint stored, i.e. when we're
		//   deliberately moving towards a specific location as opposed to patrolling randomly.
		// This lets us reuse one handler for both random and directed cover leapfrogs.
		var/list/waypoint_memdata = brain?.GetMemoryValue(MEM_WAYPOINT_LKP, null, FALSE, TRUE)
		var/mem_waypoint_x = waypoint_memdata?[KEY_GHOST_X]
		var/mem_waypoint_y = waypoint_memdata?[KEY_GHOST_Y]

		if(!isnull(mem_waypoint_x) && !isnull(mem_waypoint_y))
			effective_waypoint_x = mem_waypoint_x
			effective_waypoint_y = mem_waypoint_y

		else
			var/datum/Tuple/waypoint_position = waypoint_ident.CurrentPositionAsTuple()
			var/waypoint_fuzz_shared = max(1, min(waypoint_fuzz_tiles_x, waypoint_fuzz_tiles_y))

			var/waypoint_dist = max(waypoint_fuzz_shared, ChebyshevDistanceNumeric(
				pawn.x,
				pawn.y,
				waypoint_position.left,
				waypoint_position.right
			))

			/* The further we are, the more noisy our estimate is.
			// Practically speaking, this means that our search radius
			// gets wider and we wander around more.
			//
			*/
			var/fuzz_factor = min(5, max(1, log(waypoint_fuzz_shared, waypoint_dist)))
			var/fuzz_x = round(rand(waypoint_fuzz_tiles_x, waypoint_fuzz_tiles_x * fuzz_factor) * pick(1, -1))
			var/fuzz_y = round(rand(waypoint_fuzz_tiles_y, waypoint_fuzz_tiles_y * fuzz_factor) * pick(1, -1))

			effective_waypoint_x = (waypoint_position.left + fuzz_x)
			effective_waypoint_y = (waypoint_position.right + fuzz_y)

			if((waypoint_dist <= GOAI_CHEAT_SEE_WAYPOINT_TURF_MAXDIST_CUTOFF) && prob(GOAI_CHEAT_SEE_WAYPOINT_TURF_ODDS))
				var/turf/waypoint_turf = locate(effective_waypoint_x, effective_waypoint_y, pawn.z)

				if(waypoint_turf)
					curr_view.Add(waypoint_turf)
					var/list/waypoint_adjacents = fCardinalTurfsNoblocks(waypoint_turf)
					if(waypoint_adjacents)
						curr_view.Add(waypoint_adjacents)

		waypointchunk = chunkserver.ChunkForTile(effective_waypoint_x, effective_waypoint_y, pawn.z)

	var/turf/unreachable = brain?.GetMemoryValue("UnreachableTile", null)

	for(var/atom/candidate_cover in curr_view)
		// Need to aggressively trim down processed types here or this will take forever in object-dense areas
		if(!(istype(candidate_cover, /mob) || istype(candidate_cover, /obj/machinery) || istype(candidate_cover, /obj/mecha) || istype(candidate_cover, /obj/structure) || istype(candidate_cover, /obj/vehicle) || istype(candidate_cover, /turf)))
			continue

		if(unreachable && candidate_cover == unreachable)
			continue

		var/has_cover = candidate_cover?.HasCover(get_dir(candidate_cover, primary_threat), FALSE)
		// IsCover here is Transitive=FALSE b/c has_cover will have checked transitives already)
		var/is_cover = candidate_cover?.IsCover(FALSE, get_dir(candidate_cover, primary_threat), FALSE)

		if(!(has_cover || is_cover))
			continue

		var/turf/cover_loc = (istype(candidate_cover, /turf) ? candidate_cover : get_turf(candidate_cover))
		var/list/adjacents = (has_cover ? list(candidate_cover) : (cover_loc?.CardinalTurfs(TRUE, TRUE, TRUE) || list()))
		/*var/list/adjacents = cover_loc?.CardinalTurfs(TRUE) || list()

		if(has_cover)
			adjacents.Add(candidate_cover)*/

		if(!adjacents)
			continue

		var/same_chunk_penalty = 0

		var/datum/chunk/candchunk = chunkserver.ChunkForAtom(candidate_cover)

		// We want substantial progress and not just oscillations around the same bad position...
		if(candchunk == startchunk)
			// ... unless we're close to the target - then we can make small adjustments.
			if(candchunk != waypointchunk)
				continue
				//same_chunk_penalty = MAGICNUM_DISCOURAGE_SOFT

		for(var/turf/cand in adjacents)
			if(unreachable && cand == unreachable)
				ACTION_RUNTIME_DEBUG_LOG("Cover [cand] is unreachable!")
				continue

			if(!(pawn_mob && istype(pawn_mob)))
				if(!(pawn_mob.MayEnterTurf(cand)))
					continue

			if(cand in processed)
				continue

			if(!(cand in curr_view) && (cand != prev_loc_memdata))
				continue

			var/penalty = 0
			penalty += same_chunk_penalty

			if(cand == candidate_cover || cand == get_turf(candidate_cover))
				penalty -= 50

			if(prev_loc_memdata && prev_loc_memdata == cand)
				penalty += MAGICNUM_DISCOURAGE_SOFT

			var/threat_dist = PLUS_INF
			var/invalid_tile = FALSE

			for(var/dict/threat_ghost in _threats)
				threat_dist = owner.GetThreatDistance(cand, threat_ghost)
				var/threat_angle = owner.GetThreatAngle(cand, threat_ghost)
				var/threat_dir = angle2dir(threat_angle)

				var/tile_is_cover = (cand.IsCover(TRUE, threat_dir, FALSE))

				var/atom/maybe_cover = get_step(cand, threat_dir)

				if(maybe_cover && !(tile_is_cover ^ maybe_cover.IsCover(TRUE, threat_dir, FALSE)))
					invalid_tile = TRUE
					break

				if(threat_ghost && threat_dist < _min_safe_dist)
					invalid_tile = TRUE
					break

			if(invalid_tile)
				continue

			var/cand_dist = ManhattanDistance(cand, pawn)
			if(cand_dist < 3)
				// we want substantial moves only
				penalty += MAGICNUM_DISCOURAGE_SOFT
				//continue

			/*if (cand.CurrentPositionAsTuple() ~= shot_at_where)
				penalty += MAGICNUM_DISCOURAGE_SOFT*/
				//continue

			//var/open_lines = cand.GetOpenness()

			var/targ_dist = 0

			if(!isnull(effective_waypoint_x) && !isnull(effective_waypoint_y))
				targ_dist = ManhattanDistanceNumeric(cand.x, cand.y, effective_waypoint_x, effective_waypoint_y)

			if(cand == hysteresis_bestpos)
				// Favor previously picked bestpos, if available
				targ_dist = targ_dist //* 0.8

			penalty += -targ_dist  // the closer to target, the better

			/* Inject some noise to stop AIs getting stuck in corners.
			// max +/- 10% discount factor.
			*/
			var/noisy_dist = targ_dist * RAND_PERCENT_MULT(pathing_fuzz_factor)

			// Reminder to self: higher values are higher priority
			// Smaller penalty => also higher priority
			var/datum/Quadruple/cover_quad = new(-noisy_dist, -penalty, -cand_dist, cand)
			cover_queue.Enqueue(cover_quad)
			processed.Add(cand)

	return cover_queue


/sense/combatant_commander_coverleap_wayfinder/proc/ValidateWaypoint(var/datum/goai/mob_commander/owner, var/PriorityQueue/queue, var/trust_first = null, var/adjproc = null, var/distanceproc = null)
	if(!(owner && istype(owner)))
		COMBAT_WAYFINDER_LOG("[src] does not have an owner! <[owner]>")
		return

	var/datum/brain/brain = owner.brain
	if(!(brain && istype(brain)))
		COMBAT_WAYFINDER_LOG("[owner] does not have a brain! <[brain]>")
		return

	var/atom/best_local_pos = null

	var/_trust_first = trust_first
	if(isnull(trust_first))
		_trust_first = brain?.GetMemoryValue(MEM_TRUST_BESTPOS, FALSE)

	var/list/found_path = null
	var/_adjproc = DEFAULT_IF_NULL(adjproc, /proc/fCardinalTurfsNoblocksObjpermissive)

	while(queue && queue.L)
		// Iterate over found positions, AStar-ing into them and
		//   throwing out candidates that are unreachable.
		//
		// Most of the time, this should succeed on the first try;
		//   the point is to avoid the AI getting stuck in a spot forever.
		var/datum/Quadruple/best_cand_quad = queue.Dequeue()

		if(!best_cand_quad)
			to_world_log("[owner.name]: No Quad found, breaking the ValidateWaypoint loop!")
			break

		best_local_pos = best_cand_quad.fourth
		if(!best_local_pos)
			continue

		if(_trust_first)
			break

		// NOTE TO SELF: Optimization: taint turfs in a radius around the first failed
		found_path = owner.FindPathTo(best_local_pos,  0, null, _adjproc, distanceproc)
		if(found_path)
			break

		// This might take a while, better yield to higher-priority tasks
		sleep(-1)

	return found_path



/sense/combatant_commander_coverleap_wayfinder/proc/CheckForObstacles(var/datum/goai/mob_commander/owner, var/list/dirty_path)
	if(!(owner && istype(owner)))
		COMBAT_WAYFINDER_LOG("[src] does not have an owner! <[owner]>")
		return

	var/atom/pawn = owner.GetPawn()

	/*
	// DUPLICATED CODE FROM WAYPOINT.DM!!!
	*/
	var/path_pos = 0
	var/obstruction_pos = 0
	var/obstruction = null

	for(var/turf/pathitem in dirty_path)
		path_pos++

		if(isnull(pathitem))
			continue

		if(path_pos <= 1)
			continue

		var/turf/previous = dirty_path[path_pos-1]

		if(isnull(previous))
			continue

		var/last_link_blocked = GoaiLinkBlocked(previous, pathitem)

		if(last_link_blocked)
			// find the obstacle

			if(!obstruction)
				for(var/atom/movable/potential_obstruction_curr in pathitem.contents)
					if(potential_obstruction_curr == pawn)
						continue

					var/datum/directional_blocker/blocker = potential_obstruction_curr?.directional_blocker
					if(!blocker)
						continue

					var/dirDelta = get_dir(previous, potential_obstruction_curr)
					var/blocks = blocker.Blocks(dirDelta, src)

					if(blocks)
						obstruction = potential_obstruction_curr
						break

			if(!obstruction && path_pos > 2) // check earlier steps
				for(var/atom/movable/potential_obstruction_prev in previous.contents)
					if(potential_obstruction_prev == pawn)
						continue

					var/datum/directional_blocker/blocker = potential_obstruction_prev?.directional_blocker
					if(!blocker)
						continue

					var/dirDeltaPrev = get_dir(dirty_path[path_pos-2], potential_obstruction_prev)
					var/blocksPrev = blocker.Blocks(dirDeltaPrev, src)

					if(blocksPrev)
						obstruction = potential_obstruction_prev
						break

			break

	world.log << "OBSTRUCTION [obstruction] @ IDX [path_pos] ([dirty_path?[path_pos]])"
	obstruction_pos = path_pos
	var/datum/Tuple/obs_tuple = new(obstruction_pos, obstruction)

	return obs_tuple


/sense/combatant_commander_coverleap_wayfinder/proc/ValidatePosition(var/datum/goai/mob_commander/owner, var/PriorityQueue/cover_queue, var/trust_first = null, var/checker_proc = null)
	var/_checker_proc = (isnull(checker_proc) ? /proc/fCardinalTurfsNoblocksObjpermissive : checker_proc)
	var/turf/best_local_pos = src.ValidateWaypoint(owner, cover_queue, trust_first, _checker_proc)
	return best_local_pos


/sense/combatant_commander_coverleap_wayfinder/proc/PlanPath(var/datum/goai/mob_commander/combat_commander/owner)
	src.last_run_time = world.time

	if(!owner)
		// No owner - no point.
		COMBAT_WAYFINDER_LOG("[src] does not have an owner! <[owner]>")
		return

	var/atom/pawn = owner.GetPawn()

	if(!(pawn))
		// No mob - no point.
		COMBAT_WAYFINDER_LOG("[owner] does not have a pawn! <[pawn]>")
		return

	var/datum/brain/owner_brain = owner.brain
	if(isnull(owner_brain))
		// No point processing this if there's no memories to use
		// Might not be a precondition later.
		COMBAT_WAYFINDER_LOG("[owner] does not have a brain! <[owner_brain]>")
		return

	// ^^^ END PREFLIGHT CHECKS ^^^


	var/list/threats = new()
	var/min_safe_dist = owner_brain.GetPersonalityTrait(KEY_PERS_MINSAFEDIST, 2)
	var/turf/prev_loc_memdata = owner_brain?.GetMemoryValue(MEM_PREVLOC, null, FALSE)

	// Main threat:
	var/dict/primary_threat_ghost = owner.GetActiveThreatDict()
	var/datum/Tuple/primary_threat_pos_tuple = owner.GetThreatPosTuple(primary_threat_ghost)
	var/atom/primary_threat = null
	if(!(isnull(primary_threat_pos_tuple?.left) || isnull(primary_threat_pos_tuple?.right)))
		primary_threat = locate(primary_threat_pos_tuple.left, primary_threat_pos_tuple.right, pawn.z)

	if(primary_threat_ghost)
		threats[primary_threat_ghost] = primary_threat

	// Secondary threat:
	var/dict/secondary_threat_ghost = owner.GetActiveSecondaryThreatDict()
	var/datum/Tuple/secondary_threat_pos_tuple = owner.GetThreatPosTuple(secondary_threat_ghost)
	var/atom/secondary_threat = null
	if(!(isnull(secondary_threat_pos_tuple?.left) || isnull(secondary_threat_pos_tuple?.right)))
		secondary_threat = locate(secondary_threat_pos_tuple.left, secondary_threat_pos_tuple.right, pawn.z)

	if(secondary_threat_ghost)
		threats[secondary_threat_ghost] = secondary_threat


	// Find positions in view range and score them by suitability
	var/PriorityQueue/cover_queue = src.ScorePositions(
		owner,
		get_turf(pawn), // optional for now, but to be safe...
		primary_threat,
		prev_loc_memdata,
		threats,
		min_safe_dist,
	)

	// Find the first reachable position with the highest score and return a raw path to it
	var/list/best_pos_path = src.ValidatePosition(
		owner,
		cover_queue,
		FALSE,
		null
	)

	var/turf/best_pos = null

	if(best_pos_path && best_pos_path.len)
		best_pos = best_pos_path[best_pos_path.len]

	owner_brain.SetMemory("LastBestPos", best_pos, 3000)

	// Check the raw path for the first obstacle and return it if it exists
	var/datum/Tuple/obs_tuple = src.CheckForObstacles(owner, best_pos_path)
	var/obstruction_pos = obs_tuple?.left
	var/atom/obstruction = obs_tuple?.right
	COMBAT_WAYFINDER_LOG("Wayfinder found obstruction [obstruction]")

	var/list/premove_preconds = list()
	var/list/premove_effects = list()

	premove_preconds[STATE_HASWAYPOINT] = TRUE

	var/list/postmove_preconds = list()
	var/list/postmove_effects = list()

	postmove_preconds["PostmoveUsedUp"] = FALSE

	postmove_effects[NEED_COVER] = NEED_SATISFIED
	postmove_effects[NEED_OBEDIENCE] = NEED_SATISFIED
	postmove_effects[NEED_COMPOSURE] = NEED_SATISFIED
	postmove_effects[STATE_INCOVER] = TRUE
	postmove_effects["PostmoveUsedUp"] = TRUE
	//postmove_effects["UsedUpAction [action_name]"] = TRUE

	var/handled = isnull(obstruction) // if obs is null, counts as handled
	var/generic_move_name_suffix = "Move towards"
	var/base_movement_proc = /datum/goai/mob_commander/proc/SimpleMove

	COMBAT_WAYFINDER_LOG("Wayfinder entering move adding")

	if(obstruction)
		world.log << "Obstruction exists branch!"

		var/list/common_preconds = list(
			STATE_NEAR_ATOM(obstruction)
		)

		handled = owner.HandleWaypointObstruction(
			obstruction = obstruction,
			waypoint = best_pos,
			shared_preconds = common_preconds,
			target_preconds = null,
			move_action_name = null, //disable adding a post-obstacle action
			move_handler = null,
			unique = FALSE,
			allow_failed = FALSE,
			base_obshandle_effects = list("ObstacleHandled" = TRUE)
		)
		world.log << "Obstruction handled: [handled ? "TRUE" : "FALSE"]"

		premove_preconds[STATE_HASWAYPOINT] = TRUE
		premove_preconds["PremoveUsedUp"] = FALSE

		premove_effects["PremoveUsedUp"] = TRUE

		postmove_preconds["ObstacleHandled"] = TRUE

		// todo: grab dirblocker from Obstruction and check if we can enter the turf (e.g. for tables)
		// in that case, the position for pre-obstacle will be just [obstruction_pos], without the '-1'

		if(handled)
			world.log << "Handled, adding moves!"

			var/turf/best_premove_pos = best_pos_path[obstruction_pos-1]

			ADD_NEARNESS_EFFECT_TO(premove_effects, best_premove_pos, __nearTurf)
			ADD_NEARNESS_EFFECT_TO(postmove_effects, best_pos, __nearTurf)

			premove_effects["PremoveUsedUp"] = TRUE

			owner.AddAction(
				name = "(Pre-obstacle) [generic_move_name_suffix]",
				preconds = premove_preconds,
				effects = premove_effects,
				handler = base_movement_proc,
				cost = 5,
				charges = PLUS_INF,
				instant = FALSE,
				action_args = list("best_local_pos" = best_premove_pos, "sense_callback" = FALSE)
			)

			owner.AddAction(
				name = "(Post-obstacle) [generic_move_name_suffix]",
				preconds = postmove_preconds,
				effects = postmove_effects,
				handler = base_movement_proc,
				cost = 4,
				charges = PLUS_INF,
				instant = FALSE,
				action_args = list("best_local_pos" = best_pos, "sense_callback" = TRUE)
			)

			owner.SetState("NoObstacle", -1)

	else
		world.log << "No obstacle, adding moves!"
		ADD_NEARNESS_EFFECT_TO(postmove_effects, best_pos, __nearTurf)

		owner.SetState("NoObstacle", 1)
		postmove_preconds["NoObstacle"] = 1

		owner.AddAction(
			name = "[generic_move_name_suffix]",
			preconds = postmove_preconds,
			effects = postmove_effects,
			handler = base_movement_proc,
			cost = 16,
			charges = 5,
			instant = FALSE,
			action_args = list("best_local_pos" = best_pos, "sense_callback" = TRUE)
		)

	return


/sense/combatant_commander_coverleap_wayfinder/ProcessTick(var/owner)
	..(owner)

	if(processing)
		return

	var/datum/goai/ai_owner = owner
	var/datum/brain/ai_brain = ai_owner?.brain

	if(ai_brain && istype(ai_brain) && (ai_brain.running_action_tracker || ai_brain.selected_action))
		return

	processing = TRUE

	// This is the Sense's proc, not the mob's; name's the same:
	world.log << "Running Sense PlanPath"
	src.PlanPath(owner)

	spawn(src.GetOwnerAiTickrate(owner) * 20)
	//spawn(src.GetOwnerAiTickrate(owner) * 1)
		// Sense-side delay to avoid spamming view() scans too much
		processing = FALSE


	//processing = FALSE

	return
