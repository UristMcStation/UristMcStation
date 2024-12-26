/mob/verb/SquadList()
	set category = "Squad Debug"

	for(var/datum/squad/target_squad in GOAI_LIBBED_GLOB_ATTR(global_squad_registry))
		to_chat(usr, "Squad [target_squad.registry_index] - members [json_encode(target_squad.members)]")

	return

/mob/verb/SquadUndeploy(var/squad_idx as num)
	set category = "Squad Debug"

	if(!GOAI_LIBBED_GLOB_ATTR(global_squad_registry))
		return

	var/registry_len = length(GOAI_LIBBED_GLOB_ATTR(global_squad_registry))

	var/safe_idx = FLOOR(squad_idx)
	if(safe_idx > registry_len)
		return

	var/datum/squad/target_squad = (GOAI_LIBBED_GLOB_ATTR(global_squad_registry))[safe_idx]
	if(!istype(target_squad))
		return

	target_squad.UndeployMembers()
	to_chat(usr, "Squad [target_squad.registry_index] undeployed!")
	return


/mob/verb/SquadDeploy(var/squad_idx as num)
	set category = "Squad Debug"

	if(!GOAI_LIBBED_GLOB_ATTR(global_squad_registry))
		return

	var/registry_len = length(GOAI_LIBBED_GLOB_ATTR(global_squad_registry))

	var/safe_idx = FLOOR(squad_idx)
	if(safe_idx > registry_len)
		return

	var/datum/squad/target_squad = (GOAI_LIBBED_GLOB_ATTR(global_squad_registry))[safe_idx]
	if(!istype(target_squad))
		return

	target_squad.DeployMembers(usr.loc)
	to_chat(usr, "Squad [target_squad.registry_index] deployed!")
	return


/mob/verb/CommanderOrderSquadMoveTo2d(var/squad_id as num, var/x as num, var/y as num)
	set category = "Commander Orders"

	var/datum/squad/ordered_squad = GOAI_LIBBED_GLOB_ATTR(global_squad_registry)[squad_id]

	if(!istype(ordered_squad))
		to_chat(usr, "Could not find squad ID [NULL_TO_TEXT(squad_id)] in the Squad Registry")
		return

	ordered_squad.autonomy = 0
	ordered_squad.MoveToPos(x, y, usr.z)

	to_chat(usr, "Squad [ordered_squad.registry_index] now moving to @ ([x], [y], [usr.z])")

	return ordered_squad


/mob/verb/CommanderOrderSquadSyncToLeader(var/squad_id as num)
	set category = "Commander Orders"

	var/datum/squad/ordered_squad = GOAI_LIBBED_GLOB_ATTR(global_squad_registry)[squad_id]

	if(!istype(ordered_squad))
		to_chat(usr, "Could not find squad ID [NULL_TO_TEXT(squad_id)] in the Squad Registry")
		return

	ordered_squad.autonomy = 1
	ordered_squad.SyncToLeaderLoop()

	to_chat(usr, "Squad [ordered_squad.registry_index] now following its leader")

	return ordered_squad


/*
/mob/proc/Junk(var/datum/squad/ordered_squad in GOAI_LIBBED_GLOB_ATTR(global_squad_registry))
	// Didn't think this through properly; squads can already be moved to order squaddies around.
	// I will need this general structure for other Squad order things, so commenting out for now.
	set category = "Commander Orders"

	if(!istype(ordered_squad))
		return

	var/datum/brain/squad_brain = ordered_squad.squad_brain

	if(!istype(squad_brain))
		return

	var/datum/memory/created_mem = squad_brain.SetMemory("ai_target", position, PLUS_INF)
	squad_brain.SetMemory("ai_target_mindist", 1, PLUS_INF)
	M.brain.SetMemory(MEM_WAYPOINT_IDENTITY, position, PLUS_INF)

	var/atom/waypoint = created_mem?.val

	to_chat(usr, (waypoint ? "[ordered_squad] now following squad @ ([trueX], [trueY], [trueZ])" : "[M] not following squad"))

	return waypoint
*/
