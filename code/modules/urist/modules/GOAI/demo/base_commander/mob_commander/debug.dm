
/mob/verb/InspectGoaiMobCommanderVars(datum/goai/mob_commander/commander in GLOB?.global_goai_registry)
	set category = "Debug GOAI Commanders"

	if(isnull(commander))
		return

	usr << " "
	usr << "#============================================#"
	usr << "|          GOAI Mob Commander: [commander]          "
	usr << "#============================================#"
	usr << "|"

	for(var/V in commander.vars)
		usr << "| - [V] = [commander.vars[V]]"

	usr << "#============================================#"

	return


/mob/verb/InspectGoaiMobCommanderTrackerVars(datum/goai/mob_commander/commander in GLOB?.global_goai_registry)
	set category = "Debug GOAI Commanders"

	if(isnull(commander))
		return

	usr << " "
	usr << "#============================================#"
	usr << "|          GOAI Mob Commander: [commander]          "
	usr << "#============================================#"
	usr << "|"

	var/list/tracker_vars = commander.active_path?.vars
	if(isnull(tracker_vars))
		return

	for(var/V in tracker_vars)
		usr << "| - [V] = [tracker_vars[V]]"

	usr << "#============================================#"

	return


/mob/verb/CleanupDetachedCommanders()
	set category = "Debug GOAI Commanders"

	var/removed = 0

	for(var/datum/goai/mob_commander/commander in GLOB?.global_goai_registry)
		var/mob/living/L = commander?.pawn

		if(!(commander?.pawn) || (L && istype(L) && L.stat == DEAD))
			usr << "Deregistering [commander?.name]..."
			deregister_ai(commander?.registry_index)
			removed++

	usr << "Finished GOAI mob commander cleanup! Removed entry count: [removed]"
	return
