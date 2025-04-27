/atom
	// extra cost for pathfinding if this is present
	var/pathing_obstacle_penalty = 0


/atom/proc/GetPathfindingObstacleCost(var/dir)
	var/cost = 0

	if(src.density)
		cost += src.pathing_obstacle_penalty

	var/datum/directional_blocker/dirblocker = src.directional_blocker

	if(!isnull(dirblocker) && dirblocker.is_active)
		if(dirblocker.blocks_entry & dir)
			cost += dirblocker.pathing_entry_penalty

		if(dirblocker.blocks_exit & dir)
			cost += dirblocker.pathing_exit_penalty

	return cost


/mob/living
	pathing_obstacle_penalty = 15


/obj/cover
	pathing_obstacle_penalty = 40


/obj/cover/door
	pathing_obstacle_penalty = 80


/obj/cover/autodoor
	pathing_obstacle_penalty = 80


/obj/cover/table
	pathing_obstacle_penalty = 160


/turf/simulated/open
	pathing_obstacle_penalty = 1600

