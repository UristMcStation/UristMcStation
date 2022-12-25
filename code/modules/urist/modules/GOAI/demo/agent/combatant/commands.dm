/* Methods for manipulating the NPC AI by external agents
   (read - some player, probably, but potentially also
   'hivemind'/'AI director'-style NPC agents).
 */


/mob/goai/combatant/verb/GiveFollowOrder(mob/M in world)
	set src in view()
	if(!M)
		return

	if(!(src?.brain))
		return

	var/datum/memory/created_mem = brain.SetMemory(MEM_WAYPOINT_IDENTITY, M, PLUS_INF)
	var/atom/waypoint = created_mem?.val

	SetState(STATE_DOWNTIME, FALSE)
	usr << "Set [src] downtime-state to [FALSE]"

	// This is NOT equivalent to ~STATE_DOWNTIME!
	SetState(STATE_HASWAYPOINT, TRUE)
	usr << "Set [src] waypoint-state to [TRUE]"

	usr << (waypoint ? "[src] now tracking [waypoint]" : "[src] not tracking waypoints")

	return waypoint


/mob/goai/combatant/verb/GiveMoveOrder(posX as num, posY as num)
	set src in view()

	var/trueX = posX % world.maxx
	var/trueY = posY % world.maxy
	var/trueZ = src.z

	var/turf/position = locate(trueX, trueY, trueZ)
	if(!position)
		usr << "Target position does not exist!"
		return

	if(!(src?.brain))
		return

	var/datum/memory/created_mem = brain.SetMemory(MEM_WAYPOINT_IDENTITY, position, PLUS_INF)
	var/atom/waypoint = created_mem?.val

	SetState(STATE_DOWNTIME, FALSE)
	usr << "Set [src] downtime-state to [FALSE]"

	SetState(STATE_HASWAYPOINT, TRUE)
	usr << "Set [src] waypoint-state to [TRUE]"

	usr << (waypoint ? "[src] now tracking [waypoint] @ ([trueX], [trueY], [trueZ])" : "[src] not tracking waypoints")

	return waypoint


/mob/goai/combatant/verb/CancelOrders()
	set src in view()

	SetState(STATE_DOWNTIME, TRUE)
	usr << "Set [src] downtime-state to [TRUE]"

	SetState(STATE_HASWAYPOINT, FALSE)
	usr << "Set [src] waypoint-state to [FALSE]"

	//usr << (waypoint ? "[src] tracking [waypoint]" : "[src] no longer tracking waypoints")

	return TRUE


/mob/goai/combatant/verb/Disarm()
	set src in view()

	var/curr_firing_state = ((STATE_CANFIRE in states) ? states[STATE_CANFIRE] : FALSE)
	states[STATE_CANFIRE] = !curr_firing_state

	usr << "[src] CAN_FIRE set to [states[STATE_CANFIRE]]"

	return


/mob/goai/combatant/verb/Panic()
	set src in view()

	var/curr_panic_state = GetState(STATE_PANIC)
	usr << "[src] curr_panic_state is [curr_panic_state]"
	/* Panic/Calm are mutually exclusive, but we often need to express Action constraints
	// on one or the other, and it's not possible without building some weirder, more fancy
	// algebra of States, so the lazy solution is to just have two independent variables.
	*/
	needs[NEED_COMPOSURE] = (curr_panic_state ? NEED_SATISFIED : NEED_MINIMUM)
	if(brain)
		brain.SetNeed(NEED_COMPOSURE, (curr_panic_state ? NEED_SATISFIED : NEED_MINIMUM))

	SetState(STATE_PANIC, (curr_panic_state ? FALSE : TRUE))
	usr << "[src] [curr_panic_state ? "unpanicked" : "panicked"]!"
	return
