/*
// This module is largely debug-ish verbs (albeit these could be adapted for gameplay someday).
// In various ways, these impose goals on GOAI Agents for the AI system to solve for.
*/

/mob/verb/CommanderGiveFollowOrder(datum/utility_ai/mob_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), mob/Trg in world)
	set category = "Commander Orders"

	if(!M)
		return

	if(!(M?.brain))
		return

	var/datum/memory/created_mem = M.brain.SetMemory("ai_target", Trg, PLUS_INF)
	M.brain.SetMemory("ReplanRouteToTargetRequested", 1, M.ai_tick_delay * 4)

	var/atom/waypoint = created_mem?.val

	to_chat(usr, (waypoint ? "[M] now tracking [waypoint]" : "[M] not tracking waypoints"))
	return waypoint


/mob/verb/CommanderGiveFleeOrder(datum/utility_ai/mob_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), mob/Trg in world)
	set category = "Commander Orders"

	if(!M)
		return

	if(!(M?.brain))
		return

	var/datum/memory/created_mem = M.brain.SetMemory("fleethreat", Trg, PLUS_INF)
	M.brain.SetMemory("ReplanRouteToTargetRequested", 1, M.ai_tick_delay * 4)

	var/atom/waypoint = created_mem?.val

	to_chat(usr, (waypoint ? "[M] now fleeing from [waypoint]" : "[M] not fleeing!"))
	return waypoint


/mob/verb/CommanderGiveMoveOrder(datum/utility_ai/mob_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), posX as num, posY as num)
	set category = "Commander Orders"

	if(!(M?.brain))
		return

	var/trueX = posX % world.maxx
	var/trueY = posY % world.maxy
	var/trueZ = max(1, src.z)

	var/turf/position = locate(trueX, trueY, trueZ)
	if(!position)
		to_chat(usr, "Target position ([trueX], [trueY], [trueZ]) does not exist!")
		return

	var/datum/memory/created_mem = M.brain.SetMemory("ai_target", position, PLUS_INF)
	M.brain.SetMemory("ReplanRouteToTargetRequested", 1, M.ai_tick_delay * 4)
	var/atom/waypoint = created_mem?.val

	to_chat(usr, (waypoint ? "[M] now tracking [waypoint] @ ([trueX], [trueY], [trueZ])" : "[M] not tracking waypoints"))

	return waypoint


/mob/verb/CommanderCancelOrders(datum/utility_ai/mob_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
	set category = "Commander Orders"

	if(!(M?.brain))
		return

	M.brain.DropMemory("ai_target")
	M.brain.DropMemory("ReplanRouteToTargetRequested")

	//to_chat(usr, (waypoint ? "[M] tracking [waypoint]" : "[M] no longer tracking waypoints"))

	return TRUE


/mob/verb/CommanderSetForcedFriendTag(datum/utility_ai/mob_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), tag as text)
	set category = "Commander Orders"

	if(!M)
		return

	if(!tag)
		return

	M.SetRelationshipTag(tag, GOAI_REL_LUDICROUS_VALUE, GOAI_REL_LUDICROUS_WEIGHT)
	return


/mob/verb/CommanderSetForcedFoeTag(datum/utility_ai/mob_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), tag as text)
	set category = "Commander Orders"

	if(!M)
		return

	if(!tag)
		return

	M.SetRelationshipTag(tag, -GOAI_REL_LUDICROUS_VALUE, GOAI_REL_LUDICROUS_WEIGHT)
	return


/mob/verb/CommanderDropRelationshipTag(datum/utility_ai/mob_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), tag as text)
	set category = "Commander Orders"

	if(!M)
		return

	if(!tag)
		return

	var/result = M.DropRelationshipTag(tag)
	to_chat(usr, "[M] - Tag [tag] [result ? "dropped successfully" : "failed to drop"]!")
	return
