/* Movement system (in the ECS sense) and movement helpers. */

/mob/goai/combatant/proc/FindPathTo(var/trg, var/min_dist = 0, var/avoid = null, var/proc/adjproc = null, var/proc/distanceproc = null, var/list/adjargs = null)
	var/true_avoid = (avoid || src.brain?.GetMemoryValue("BadStartTile", null))

	var/proc/true_adjproc = (isnull(adjproc) ? /proc/fCardinalTurfs : adjproc)
	var/proc/true_distproc = (isnull(distanceproc) ? /proc/fDistance : distanceproc)

	var/list/path = AStar(
		start = get_turf(loc),
		end = get_turf(trg),
		adjacent = true_adjproc,
		dist = true_distproc,
		max_nodes = 0,
		max_node_depth = pathing_dist_cutoff,
		min_target_dist = min_dist,
		min_node_dist = null,
		adj_args = adjargs,
		exclude = true_avoid
	)
	return path



/mob/goai/combatant/proc/ValidateWaypoint(var/PriorityQueue/queue, var/trust_first = null)
	var/atom/best_local_pos = null

	var/_trust_first = trust_first
	if(isnull(trust_first))
		_trust_first = brain?.GetMemoryValue(MEM_TRUST_BESTPOS, FALSE)

	while(queue && queue.L)
		// Iterate over found positions, AStar-ing into them and
		//   throwing out candidates that are unreachable.
		//
		// Most of the time, this should succeed on the first try;
		//   the point is to avoid the AI getting stuck in a spot forever.
		var/datum/Quadruple/best_cand_quad = queue.Dequeue()

		if(!best_cand_quad)
			world.log << "[src.name] No Quad found, breaking the ValidateWaypoint loop!"
			break

		best_local_pos = best_cand_quad.fourth
		if(!best_local_pos)
			continue

		if(_trust_first)
			break

		// NOTE TO SELF: Optimization: taint turfs in a radius around the first failed
		var/list/found_path = FindPathTo(best_local_pos,  0, null)
		if(found_path)
			break

		// This might take a while, better yield to higher-priority tasks
		sleep(-1)

	return best_local_pos


/mob/goai/combatant/proc/GetCurrentChunk()
	var/datum/chunkserver/chunkserver = GetOrSetChunkserver()
	var/datum/chunk/startchunk = chunkserver.ChunkForAtom(src)
	return startchunk


/mob/goai/combatant/proc/BuildPathTrackerTo(var/trg, var/min_dist = 0, var/avoid = null, var/inh_frustration = 0, var/proc/costproc = null)
	var/datum/ActivePathTracker/pathtracker = null
	var/cost_function = (isnull(costproc) ? /proc/fDistance : costproc)
	//var/list/adjacency_args = list(owner = src))

	var/list/path = FindPathTo(
		trg,
		min_dist,
		avoid,
		//adjproc = /proc/mCombatantAdjacents,
		//adjargs = adjacency_args,
		distanceproc = cost_function
	)

	if(!path)
		path = FindPathTo(
			trg,
			world.view,
			avoid,
			//adjproc = /proc/mCombatantAdjacents,
			//adjargs = adjacency_args,
			distanceproc = cost_function,
		)

	if(path)
		pathtracker = new /datum/ActivePathTracker(trg, path, min_dist, inh_frustration)

	return pathtracker


/mob/goai/combatant/proc/StartNavigateTo(var/trg, var/min_dist = 0, var/avoid = null, var/inh_frustration = 0, var/refresh_loc_memories = TRUE, var/proc/costproc = null)
	is_repathing = 1

	if(brain && refresh_loc_memories)
		var/atom/previous_oldloc = brain.GetMemoryValue("Location-1")

		if(previous_oldloc && prob(10))
			brain.SetMemory("Location-2", previous_oldloc)

		brain.SetMemory("Location-1", src.loc)

	var/datum/ActivePathTracker/pathtracker = BuildPathTrackerTo(trg, min_dist, avoid, inh_frustration, costproc)

	if(pathtracker)
		active_path = pathtracker
	else
		var/atom/curr_loc = get_turf(src)
		world.log << "[src]: Could not build a pathtracker to [trg] @ [curr_loc]"
		//brain?.SetMemory("BadStartTile", curr_loc, 1000)

	var/turf/trg_turf = trg
	if(trg_turf)
		trg_turf.DrawVectorbeam()

	is_repathing = 0
	return active_path


/mob/goai/combatant/proc/CancelNavigate()
	active_path = null
	is_repathing = 0
	return TRUE


/mob/goai/combatant/proc/MovementSystem()
	if(!(active_path) || active_path.IsDone() || is_moving)
		return

	var/success = FALSE
	var/atom/next_step = ((active_path.path && active_path.path.len) ? active_path.path[1] : null)

	var/atom/followup_step = ((active_path.path && active_path.path.len >= 2) ? active_path.path[2] : null)

	if(next_step)

		if(active_path.frustration > 2)
			//brain?.SetMemory("UnreachableTile", active_path.target)
			randMove()
			return

		if(active_path.frustration > 4 && (is_repathing <= 0) && followup_step && followup_step != active_path.target)
			// repath
			var/frustr_x = followup_step.x
			var/frustr_y = followup_step.y
			world.log << "[src]: FRUSTRATION, repath avoiding [next_step] @ ([frustr_x], [frustr_y])!"
			StartNavigateTo(active_path.target, active_path.min_dist, next_step, active_path.frustration)
			return

		var/step_result = step_towards(src, next_step, 0)
		//success = (is_moving || step_result)

		success = (
			step_result || (
				(src.x == next_step.x) && (src.y == next_step.y)
			)
		)

		if(success)
			active_path.frustration = 0

		else
			active_path.frustration++
	else
		world.log << "[src]: Setting path to Done"
		active_path.SetDone()

	if(success)
		lpop(active_path.path)

	return



/mob/goai/combatant/Move()
	. = ..()


/mob/goai/combatant/proc/randMove()
	if(is_moving)
		return FALSE

	is_moving = 1

	var/turf/curr_loc = get_turf(src)
	var/list/neighbors = fCombatantAdjacents(curr_loc, src)

	if(neighbors)
		var/movedir = pick(neighbors)
		step_to(src, movedir)

	is_moving = 0
	return TRUE
