
/mob/verb/InspectGoaiMobCommanderVars(datum/goai/mob_commander/commander in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
	set category = "Debug GOAI Commanders"

	if(isnull(commander))
		return

	to_chat(usr, " ")
	to_chat(usr, "#============================================#")
	to_chat(usr, "|          GOAI Mob Commander: [commander]          ")
	to_chat(usr, "#============================================#")
	to_chat(usr, "|")

	for(var/V in commander.vars)
		to_chat(usr, "| - [V] = [commander.vars[V]]")

	to_chat(usr, "#============================================#")

	return


/mob/verb/InspectGoaiMobCommanderTrackerVars(datum/goai/mob_commander/commander in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
	set category = "Debug GOAI Commanders"

	if(isnull(commander))
		return

	to_chat(usr, " ")
	to_chat(usr, "#============================================#")
	to_chat(usr, "|          GOAI Mob Commander: [commander]          ")
	to_chat(usr, "#============================================#")
	to_chat(usr, "|")

	var/list/tracker_vars = commander.active_path?.vars
	if(isnull(tracker_vars))
		return

	for(var/V in tracker_vars)
		to_chat(usr, "| - [V] = [tracker_vars[V]]")

	to_chat(usr, "#============================================#")

	return


/mob/verb/CleanupDetachedCommanders()
	set category = "Debug GOAI Commanders"

	var/removed = 0

	for(var/datum/goai/mob_commander/commander in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
		var/atom/pawn = commander?.GetPawn()
		var/mob/living/L = pawn

		if(!(pawn) || (L && istype(L) && L.stat == DEAD))
			to_chat(usr, "Deregistering [commander?.name]...")
			deregister_ai(commander?.registry_index)
			removed++

	to_chat(usr, "Finished GOAI mob commander cleanup! Removed entry count: [removed]")
	return


/mob/verb/SetPathingFuzz(datum/goai/mob_commander/commander in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), amt as num)
	set category = "Debug GOAI Commanders"

	if(isnull(commander))
		return

	if(amt < 0)
		to_chat(usr, "Pathing fuzz must be non-negative!")
		return

	commander.pathfinding_fuzz_perc = amt

	to_chat(usr, "Set Pathing fuzz for [commander] to [commander.pathfinding_fuzz_perc]")

	return


/mob/verb/SetWaypointFuzz(datum/goai/mob_commander/commander in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), amt as num)
	set category = "Debug GOAI Commanders"

	if(isnull(commander))
		return

	if(amt < 0)
		to_chat(usr, "Waypoint fuzz must be non-negative!")
		return

	commander.waypoint_fuzz_tiles_x = amt
	commander.waypoint_fuzz_tiles_y = amt

	to_chat(usr, "Set Waypoint fuzz for [commander] to: [commander.waypoint_fuzz_tiles_x] / [commander.waypoint_fuzz_tiles_y] (X/Y)")

	return
