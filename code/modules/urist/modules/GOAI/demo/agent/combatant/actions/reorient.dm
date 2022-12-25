
/*
/mob/goai/combatant/proc/HandleReorient(var/datum/ActionTracker/tracker)
	if(!tracker)
		return

	if(!brain)
		// The whole point is to set some brain data
		// No brain - we're done.
		tracker.SetDone()
		return

	var/list/path = tracker?.BBGet("reorient_path", null)

	if(waypoint && isnull(path))
		var/turf/target = get_turf(waypoint)

		if(isnull(target))
			target = get_turf(waypoint.loc)

		var/turf/startpos = get_turf(src.loc)
		var/init_dist = 30
		var/sqrt_dist = get_dist(startpos, target) * 0.5

		if(init_dist < 40)
			world.log << "[src] entering ASTARS STAGE"
			path = AStar(src, target, /turf/proc/CardinalTurfs, /turf/proc/Distance, null, init_dist, min_target_dist = sqrt_dist, exclude = null)
			world.log << "[src] found ASTAR 1 path from [startpos] to [target]: [path] ([path?.len])"

			if(path)
				world.log << "[src] entering HAPPYPATH"
				/*for(var/turf/pathitem in path)
					world.log << "[src] HAPPYPATH: [pathitem]"*/

			else if(!(path && path.len))
				// No unobstructed path to target!
				// Let's try to get a direct path and check for obstacles.
				path = AStar(src, target, /turf/proc/CardinalTurfsNoblocks, /turf/proc/Distance, null, init_dist, min_target_dist = sqrt_dist, exclude = null)
				world.log << "[src] found ASTAR 2 path from [startpos] to [target]: [path] ([path?.len])"

				if(path)
					var/path_pos = 0

					for(var/turf/pathitem in path)
						path_pos++
						//world.log << "[src]: [pathitem]"

						if(isnull(pathitem))
							continue

						if(path_pos <= 1)
							continue

						var/turf/previous = path[path_pos-1]

						if(isnull(previous))
							continue

						var/last_link_blocked = LinkBlocked(previous, pathitem)
						if(last_link_blocked)
							world.log << "[src]: LINK BETWEEN [previous] & [pathitem] OBSTRUCTED"
							// find the obstacle
							var/atom/obstruction = null

							if(!obstruction)
								for(var/atom/potential_obstruction_curr in pathitem.contents)
									var/datum/directional_blocker/blocker = potential_obstruction_curr?.directional_blocker
									if(!blocker)
										continue

									var/dirDelta = get_dir(previous, potential_obstruction_curr)
									var/blocks = blocker.Blocks(dirDelta)

									if(blocks)
										obstruction = potential_obstruction_curr
										break

							if(!obstruction && path_pos > 2) // check earlier steps
								for(var/atom/potential_obstruction_prev in previous.contents)
									var/datum/directional_blocker/blocker = potential_obstruction_prev?.directional_blocker
									if(!blocker)
										continue

									var/dirDeltaPrev = get_dir(path[path_pos-2], potential_obstruction_prev)
									var/blocksPrev = blocker.Blocks(dirDeltaPrev)

									if(blocksPrev)
										obstruction = potential_obstruction_prev
										break

							world.log << "[src]: LINK OBSTRUCTION => [obstruction] @ [obstruction?.loc]"
							var/obj/cover/door/D = obstruction
							if(D && istype(D))
								brain.SetMemory(MEM_OBSTRUCTION, obstruction, 1000)
								var/obs_need_key = "Passable @ [D]"
								needs[obs_need_key] = NEED_MINIMUM
								AddAction("Open [D]", list(), list(obs_need_key = NEED_MAXIMUM, NEED_COVER = NEED_SATISFIED, NEED_OBEDIENCE = NEED_SATISFIED), /mob/goai/combatant/proc/HandleOpenDoor, 5, 1)
							// Update Actions, somehow - fetch actions from obstruction?
							break

			if(path)
				tracker?.BBSet("reorient_path", path)

	tracker.SetDone()
	return
*/
