
/mob/verb/CommanderGiveFollowOrder(datum/goai/mob_commander/combat_commander/M in global_goai_registry, mob/Trg in world)
	set category = "Commander Orders"

	if(!M)
		return

	if(!(M?.brain))
		return

	var/datum/memory/created_mem = M.brain.SetMemory(MEM_WAYPOINT_IDENTITY, Trg, PLUS_INF)
	var/atom/waypoint = created_mem?.val

	M.SetState(STATE_DOWNTIME, FALSE)
	usr << "Set [M] downtime-state to [FALSE]"

	// This is NOT equivalent to ~STATE_DOWNTIME!
	M.SetState(STATE_HASWAYPOINT, TRUE)
	usr << "Set [M] waypoint-state to [TRUE]"

	usr << (waypoint ? "[M] now tracking [waypoint]" : "[M] not tracking waypoints")

	return waypoint


/mob/verb/CommanderGiveMoveOrder(datum/goai/mob_commander/combat_commander/M in global_goai_registry, posX as num, posY as num)
	set category = "Commander Orders"

	var/trueX = posX % world.maxx
	var/trueY = posY % world.maxy
	var/trueZ = src.z

	var/turf/position = locate(trueX, trueY, trueZ)
	if(!position)
		usr << "Target position does not exist!"
		return

	if(!(M?.brain))
		return

	var/datum/memory/created_mem = M.brain.SetMemory(MEM_WAYPOINT_IDENTITY, position, PLUS_INF)
	var/atom/waypoint = created_mem?.val

	M.SetState(STATE_DOWNTIME, FALSE)
	usr << "Set [M] downtime-state to [FALSE]"

	M.SetState(STATE_HASWAYPOINT, TRUE)
	usr << "Set [M] waypoint-state to [TRUE]"

	usr << (waypoint ? "[M] now tracking [waypoint] @ ([trueX], [trueY], [trueZ])" : "[M] not tracking waypoints")

	return waypoint


/mob/verb/CommanderCancelOrders(datum/goai/mob_commander/combat_commander/M in global_goai_registry)
	set category = "Commander Orders"

	M.SetState(STATE_DOWNTIME, TRUE)
	usr << "Set [M] downtime-state to [TRUE]"

	M.SetState(STATE_HASWAYPOINT, FALSE)
	usr << "Set [M] waypoint-state to [FALSE]"

	//usr << (waypoint ? "[M] tracking [waypoint]" : "[M] no longer tracking waypoints")

	return TRUE


/mob/verb/CommanderDisarm(datum/goai/mob_commander/combat_commander/M in global_goai_registry)
	set category = "Commander Orders"

	var/curr_firing_state = ((STATE_CANFIRE in M.states) ? M.states[STATE_CANFIRE] : FALSE)
	M.states[STATE_CANFIRE] = !curr_firing_state

	usr << "[M] CAN_FIRE set to [M.states[STATE_CANFIRE]]"

	return


/mob/verb/CommanderPanic(datum/goai/mob_commander/combat_commander/M in global_goai_registry)
	set category = "Commander Orders"

	var/curr_panic_state = M.GetState(STATE_PANIC)
	usr << "[M] curr_panic_state is [curr_panic_state]"
	/* Panic/Calm are mutually exclusive, but we often need to express Action constraints
	// on one or the other, and it's not possible without building some weirder, more fancy
	// algebra of States, so the lazy solution is to just have two independent variables.
	*/
	M.needs[NEED_COMPOSURE] = (curr_panic_state ? NEED_SATISFIED : NEED_MINIMUM)
	if(M.brain)
		M.brain.SetNeed(NEED_COMPOSURE, (curr_panic_state ? NEED_SATISFIED : NEED_MINIMUM))

	M.SetState(STATE_PANIC, (curr_panic_state ? FALSE : TRUE))
	usr << "[M] [curr_panic_state ? "unpanicked" : "panicked"]!"
	return
