/*
// This module is largely debug-ish verbs (albeit these could be adapted for gameplay someday).
// In various ways, these impose goals on GOAI Agents for the AI system to solve for.
*/


/mob/proc/CommanderGiveFollowOrder(datum/utility_ai/mob_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), mob/Trg in world)
	set category = "Commander Orders"

	if(!M)
		return

	if(!(M?.brain))
		return

	var/datum/memory/created_mem = M.brain.SetMemory("ai_target", Trg, PLUS_INF)
	M.brain.SetMemory("ai_target_mindist", 2, PLUS_INF)
	M.brain.SetMemory(MEM_WAYPOINT_IDENTITY, Trg, PLUS_INF)
	M.brain.SetMemory("ReplanRouteToTargetRequested", 1, M.ai_tick_delay * 4)

	var/atom/waypoint = created_mem?.val

	to_chat(usr, (waypoint ? "[M] now tracking [waypoint]" : "[M] not tracking waypoints"))
	return waypoint


/mob/proc/AllCommandersGiveFollowOrder(mob/Trg in world)
	set category = "Commander Orders"

	var/turf/trgturf = get_turf(Trg)
	if(isnull(trgturf))
		to_chat(usr, "[Trg] physical location not found")

	for(var/datum/utility_ai/mob_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
		if(!(M?.brain))
			continue

		M.brain.SetMemory("ai_target", trgturf, M.ai_tick_delay * 20)
		M.brain.SetMemory("ai_target_mindist", 2, M.ai_tick_delay * 20)
		M.brain.SetMemory(MEM_WAYPOINT_IDENTITY, trgturf, M.ai_tick_delay * 20)
		M.brain.SetMemory("ReplanRouteToTargetRequested", 1, M.ai_tick_delay * 3)

	return


/mob/proc/CommanderGiveFleeOrder(datum/utility_ai/mob_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), mob/Trg in world)
	set category = "Commander Orders"

	if(!M)
		return

	if(!(M?.brain))
		return

	var/datum/memory/created_mem = M.brain.SetMemory("forced_fleethreat", Trg, PLUS_INF)
	M.brain.SetMemory("ReplanRouteToTargetRequested", 1, M.ai_tick_delay * 4)

	var/atom/waypoint = created_mem?.val

	to_chat(usr, (waypoint ? "[M] now fleeing from [waypoint]" : "[M] not fleeing!"))
	return waypoint


/mob/proc/CommanderGiveMoveOrder(datum/utility_ai/mob_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), posX as num, posY as num)
	set category = "Commander Orders"

	if(!(M?.brain))
		return

	var/trueX = max(1, posX % world.maxx)
	var/trueY = max(1, posY % world.maxy)
	var/trueZ = max(1, src.z)

	var/turf/position = locate(trueX, trueY, trueZ)
	if(!position)
		to_chat(usr, "Target position ([trueX], [trueY], [trueZ]) does not exist!")
		return

	var/datum/memory/created_mem = M.brain.SetMemory("ai_target", position, PLUS_INF)
	M.brain.SetMemory("ai_target_mindist", 1, PLUS_INF)
	M.brain.SetMemory(MEM_WAYPOINT_IDENTITY, position, PLUS_INF)

	M.brain.SetMemory("ReplanRouteToTargetRequested", 1, M.ai_tick_delay * 4)
	var/atom/waypoint = created_mem?.val

	to_chat(usr, (waypoint ? "[M] now tracking [waypoint] @ ([trueX], [trueY], [trueZ])" : "[M] not tracking waypoints"))

	return waypoint


/mob/proc/CommanderGiveMoveOrderThreeD(datum/utility_ai/mob_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), posX as num, posY as num, posZ as num)
	set category = "Commander Orders"

	if(!(M?.brain))
		return

	var/trueX = max(1, posX % (world.maxx + 1))
	var/trueY = max(1, posY % (world.maxy + 1))
	var/trueZ = max(1, posZ % (world.maxz + 1))

	var/turf/position = locate(trueX, trueY, trueZ)
	if(!position)
		to_chat(usr, "Target position ([trueX], [trueY], [trueZ]) does not exist!")
		return

	var/datum/memory/created_mem = M.brain.SetMemory("ai_target", position, PLUS_INF)
	M.brain.SetMemory("ai_target_mindist", 1, PLUS_INF)
	M.brain.SetMemory(MEM_WAYPOINT_IDENTITY, position, PLUS_INF)

	M.brain.SetMemory("ReplanRouteToTargetRequested", 1, M.ai_tick_delay * 4)
	var/atom/waypoint = created_mem?.val

	to_chat(usr, (waypoint ? "[M] now tracking [waypoint] @ ([trueX], [trueY], [trueZ])" : "[M] not tracking waypoints"))

	return waypoint



/mob/proc/CommanderCancelOrders(datum/utility_ai/mob_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
	set category = "Commander Orders"

	if(!(M?.brain))
		return

	M.brain.DropMemory("ai_target")
	M.brain.DropMemory("ai_target_mindist")
	M.brain.DropMemory("ReplanRouteToTargetRequested")

	//to_chat(usr, (waypoint ? "[M] tracking [waypoint]" : "[M] no longer tracking waypoints"))

	return TRUE


/mob/proc/CommanderSetForcedFriendTag(datum/utility_ai/mob_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), tag as text)
	set category = "Commander Orders"

	if(!M)
		return

	if(!tag)
		return

	M.SetRelationshipTag(tag, GOAI_REL_LUDICROUS_VALUE, GOAI_REL_LUDICROUS_WEIGHT)
	return


/mob/proc/CommanderSetForcedFoeTag(datum/utility_ai/mob_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), tag as text)
	set category = "Commander Orders"

	if(!M)
		return

	if(!tag)
		return

	M.SetRelationshipTag(tag, -GOAI_REL_LUDICROUS_VALUE, GOAI_REL_LUDICROUS_WEIGHT)
	return


/mob/proc/CommandersFactionFight()
	set category = "Commander Orders"

	var/list/active_factions = list()

	for(var/datum/utility_ai/mob_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
		var/mob/living/mob_pawn = M.GetPawn()

		if(!istype(mob_pawn))
			continue

		var/mob_faction = mob_pawn.faction
		active_factions[mob_faction] = (active_factions[mob_faction] || list()) + M
		// friendly to self
		M.SetRelationshipTag(mob_faction, GOAI_REL_LUDICROUS_VALUE, GOAI_REL_LUDICROUS_WEIGHT)

	for(var/datum/utility_ai/mob_commander/MC in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
		for(var/other_faction in active_factions)
			var/list/members = active_factions[other_faction]
			if(!(MC in members))
				to_chat(usr, "[MC] now hates [other_faction]")
				MC.SetRelationshipTag(other_faction, -GOAI_REL_LUDICROUS_VALUE, GOAI_REL_LUDICROUS_WEIGHT)

	return


/mob/proc/CommanderDropRelationshipTag(datum/utility_ai/mob_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), tag as text)
	set category = "Commander Orders"

	if(!M)
		return

	if(!tag)
		return

	var/result = M.DropRelationshipTag(tag)
	to_chat(usr, "[M] - Tag [tag] [result ? "dropped successfully" : "failed to drop"]!")
	return


/proc/CommanderGiveGOAPSolverOrderSimple(datum/utility_ai/mob_commander/commander in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), var/raw_jsondata as message, var/object as anything in view())
	set category = "Commander Orders"

	var/jsondata = json_decode(raw_jsondata)

	if(isnull(jsondata))
		to_chat(usr, "JSON Failed to parse: [raw_jsondata] for CommanderGiveGOAPSolverOrderSimple")
		return

	if(isnull(commander))
		to_chat(usr, "Commander [commander] is null for CommanderGiveGOAPSolverOrderSimple!")
		return

	var/datum/brain/commander_brain = commander.brain

	if(isnull(commander_brain))
		to_chat(usr, "Brain for [commander] is null!")
		return

	if(isnull(object))
		to_chat(usr, "Target [isnull(object) ? "null" : object] is null for CommanderGiveGOAPSolverOrderSimple")
		return

	// goal_state, target, considerations
	var/datum/goap_order_smartobject/new_order = new(jsondata, object, null)

	var/list/smart_orders = commander_brain.GetMemoryValue("SmartOrders", null) || list()

	if(smart_orders.len)
		// Try to keep this in slot 1 to avoid runaway array size
		smart_orders[1] = new_order
	else
		smart_orders.Add(new_order)

	commander_brain.SetMemory("SmartOrders", smart_orders)
	to_chat(usr, "Created a new SmartOrder for [commander]")
	return

/mob/proc/RemoveGoaiOrderVerbs()
	set name = "Remove GOAI Order Verbs"
	set category = "Debug"

	usr.verbs -= /mob/proc/CommanderGiveFollowOrder
	usr.verbs -= /mob/proc/AllCommandersGiveFollowOrder
	usr.verbs -= /mob/proc/CommanderGiveFleeOrder
	usr.verbs -= /mob/proc/CommanderGiveMoveOrder
	usr.verbs -= /mob/proc/CommanderGiveMoveOrderThreeD
	//usr.verbs -= /mob/proc/CommanderOrderSquadMoveTo2d
	usr.verbs -= /mob/proc/CommanderCancelOrders
	usr.verbs -= /mob/proc/CommanderSetForcedFriendTag
	usr.verbs -= /mob/proc/CommanderSetForcedFoeTag
	usr.verbs -= /mob/proc/CommandersFactionFight
	usr.verbs -= /mob/proc/CommanderDropRelationshipTag
	usr.verbs -= /proc/CommanderGiveGOAPSolverOrderSimple
	#ifdef GOAI_DEBUG_UI_HACKERY
	usr.verbs -= /mob/proc/CommanderGiveGOAPSolverOrder
	usr.verbs -= /mob/proc/CommanderGiveMoveOrderClick
	#endif
	usr.verbs -= /mob/proc/RemoveGoaiOrderVerbs

	return


#ifdef GOAI_LIBRARY_FEATURES
/mob/verb/GrantGoaiOrderVerbs()
#endif
#ifdef GOAI_SS13_SUPPORT
/mob/proc/GrantGoaiOrderVerbs()
#endif
	set name = "Grant GOAI Order Verbs"
	set category = "Debug"

	usr.verbs |= /mob/proc/CommanderGiveFollowOrder
	usr.verbs |= /mob/proc/AllCommandersGiveFollowOrder
	usr.verbs |= /mob/proc/CommanderGiveFleeOrder
	usr.verbs |= /mob/proc/CommanderGiveMoveOrder
	usr.verbs |= /mob/proc/CommanderGiveMoveOrderThreeD
	//usr.verbs |= /mob/proc/CommanderOrderSquadMoveTo2d
	usr.verbs |= /mob/proc/CommanderCancelOrders
	usr.verbs |= /mob/proc/CommanderSetForcedFriendTag
	usr.verbs |= /mob/proc/CommanderSetForcedFoeTag
	usr.verbs |= /mob/proc/CommandersFactionFight
	usr.verbs |= /mob/proc/CommanderDropRelationshipTag
	usr.verbs |= /proc/CommanderGiveGOAPSolverOrderSimple
	#ifdef GOAI_DEBUG_UI_HACKERY
	usr.verbs |= /mob/proc/CommanderGiveGOAPSolverOrder
	usr.verbs |= /mob/proc/CommanderGiveMoveOrderClick
	#endif
	usr.verbs |= /mob/proc/RemoveGoaiOrderVerbs

	return

