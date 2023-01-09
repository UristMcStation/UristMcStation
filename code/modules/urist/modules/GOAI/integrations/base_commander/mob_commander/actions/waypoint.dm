// # define OBSTACLEHUNT_DEBUG_LOGGING 0

# ifdef OBSTACLEHUNT_DEBUG_LOGGING
# define OBSTACLEHUNT_DEBUG_LOG(X) to_world_log(X)
# else
# define OBSTACLEHUNT_DEBUG_LOG(X)
# endif


/datum/goai/mob_commander/proc/SpotObstacles(var/datum/goai/mob_commander/owner, var/atom/target = null, var/default_to_waypoint = TRUE, var/proc/adjproc = null, var/proc/costproc = null)
	if(!(owner))
		// No mob - no point.
		return

	var/atom/pawn = owner.GetPawn()
	if(!pawn)
		return

	var/datum/brain/owner_brain = owner?.brain
	if(isnull(owner_brain))
		// No point processing this if there's no memories to use
		// Might not be a precondition later.
		return

	var/atom/goal = target

	if(isnull(goal) && default_to_waypoint)
		var/atom/waypoint = owner.brain.GetMemoryValue(MEM_WAYPOINT_IDENTITY, null, FALSE, TRUE)
		goal = waypoint

	if(isnull(goal) || !goal)
		// Nothing to spot.
		return

	var/true_adjproc = adjproc
	if(isnull(true_adjproc))
		true_adjproc = /proc/fCardinalTurfs

	var/true_costproc = costproc
	if(isnull(true_costproc))
		true_costproc = DEFAULT_GOAI_DISTANCE_PROC

	var/list/path = null
	var/turf/target_turf = get_turf(goal)

	if(isnull(target_turf))
		target_turf = get_turf(goal.loc)

	var/turf/startpos = get_turf(pawn)
	var/init_dist = 30
	// NOTE: somehow, this once runtimed with the distance seemingly being -1, wtf?
	//       the max() was added as a measure to ensure sane input
	var/sqrt_dist = (max(0, get_dist(startpos, target)) ** 0.5) * 0.5

	if(init_dist < 40)
		OBSTACLEHUNT_DEBUG_LOG("[owner] entering ASTARS STAGE")
		path = GoaiAStar(get_turf(pawn), target_turf, /proc/fCardinalTurfs, DEFAULT_GOAI_DISTANCE_PROC, null, init_dist, min_target_dist = sqrt_dist, exclude = null)

		OBSTACLEHUNT_DEBUG_LOG("[owner] found ASTAR 1 path from [startpos] to [target_turf]: [path] ([path?.len])")

		if(path && path.len)
			OBSTACLEHUNT_DEBUG_LOG("[owner] entering HAPPYPATH")
			return

		// No unobstructed path to target!
		// Let's try to get a direct path and check for obstacles.
		path = GoaiAStar(get_turf(pawn), target_turf, /proc/fCardinalTurfsNoblocks, DEFAULT_GOAI_DISTANCE_PROC, null, init_dist, min_target_dist = sqrt_dist, exclude = null)

		OBSTACLEHUNT_DEBUG_LOG("[src] found ASTAR 2 path from [startpos] to [target_turf]: [path] ([path?.len])")

		if(!path)
			return

		var/path_pos = 0

		OBSTACLEHUNT_DEBUG_LOG("[owner] entering OBSTACLE HUNT STAGE")
		for(var/turf/pathitem in path)
			path_pos++

			if(isnull(pathitem))
				continue

			if(path_pos <= 1)
				continue

			var/turf/previous = path[path_pos-1]

			if(isnull(previous))
				continue

			var/last_link_blocked = GoaiLinkBlocked(previous, pathitem)

			if(last_link_blocked)
				OBSTACLEHUNT_DEBUG_LOG("[owner]: LINK BETWEEN [previous] ([previous.x],[previous.y]) & [pathitem] ([pathitem.x],[pathitem.y]) OBSTRUCTED")
				// find the obstacle
				var/atom/obstruction = null

				if(!obstruction)
					for(var/atom/potential_obstruction_curr in pathitem.contents)
						var/datum/directional_blocker/blocker = potential_obstruction_curr.GetBlockerData(TRUE, TRUE)
						if(!blocker)
							continue

						var/dirDelta = get_dir(previous, potential_obstruction_curr)
						var/blocks = blocker.Blocks(dirDelta, src)

						if(blocks)
							obstruction = potential_obstruction_curr
							break

				if(!obstruction && path_pos > 2) // check earlier steps
					for(var/atom/potential_obstruction_prev in previous.contents)
						var/datum/directional_blocker/blocker = potential_obstruction_prev.GetBlockerData(TRUE, TRUE)
						if(!blocker)
							continue

						var/dirDeltaPrev = get_dir(path[path_pos-2], potential_obstruction_prev)
						var/blocksPrev = blocker.Blocks(dirDeltaPrev, src)

						if(blocksPrev)
							obstruction = potential_obstruction_prev
							break

				OBSTACLEHUNT_DEBUG_LOG("[owner]: LINK OBSTRUCTION => [obstruction] @ [get_turf(obstruction)]")
				owner.brain.SetMemory(MEM_OBSTRUCTION, obstruction, MEM_TIME_LONGTERM)
				break

	return


/datum/goai/mob_commander/proc/HandleWaypoint(var/datum/ActionTracker/tracker, var/move_handler, var/move_action_name = null)
	// Locate waypoint
	// Capture any obstacles
	// Add Action Goto<Goal> with clearing obstacles as a precond

	var/atom/movable/pawn = src.GetPawn()
	if(!pawn)
		tracker?.SetFailed()
		to_world_log("[src] does not have an owned mob!")
		return

	if(!src || !(src?.brain))
		tracker?.SetFailed()
		return

	var/atom/waypoint = brain.GetMemoryValue(MEM_WAYPOINT_IDENTITY, null, FALSE, TRUE)
	if(isnull(waypoint))
		tracker?.SetFailed() // b/c we shouldn't have triggered this in the first place if it's null
		return

	// Astar checking for obstacles
	src.SpotObstacles(owner=src, target=waypoint, default_to_waypoint=FALSE)

	var/list/goto_preconds = list(
		STATE_HASWAYPOINT = TRUE,
		STATE_PANIC = -TRUE,
		//STATE_DISORIENTED = -TRUE,
	)

	var/list/common_preconds = list(
		STATE_PANIC = -TRUE,
		//STATE_DISORIENTED = -TRUE,
	)

	var/atom/obstruction = brain.GetMemoryValue(MEM_OBSTRUCTION)
	var/_move_action_name = (move_action_name || "MoveTowards")

	var/handled = HandleWaypointObstruction(
		obstruction = obstruction,
		waypoint = waypoint,
		shared_preconds = common_preconds,
		target_preconds = goto_preconds,
		move_action_name = _move_action_name,
		move_handler = move_handler,
		unique = TRUE,
		allow_failed = TRUE
	)

	SetState(STATE_DISORIENTED, FALSE)

	if(handled)
		tracker.SetDone()

	else
		tracker.SetFailed()

	return

