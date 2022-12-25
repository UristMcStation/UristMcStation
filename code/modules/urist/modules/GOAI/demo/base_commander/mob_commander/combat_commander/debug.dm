
/mob/verb/InspectGoaiMobCommanderVars(datum/goai/mob_commander/combat_commander/commander in global_goai_registry)
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


/mob/verb/InspectGoaiMobCommanderTrackerVars(datum/goai/mob_commander/combat_commander/commander in global_goai_registry)
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

