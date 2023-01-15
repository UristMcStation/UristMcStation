
/mob/verb/CommanderGiveFollowOrder(datum/goai/mob_commander/combat_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), mob/Trg in world)
	set category = "Commander Orders"

	if(!M)
		return

	if(!(M?.brain))
		return

	var/datum/memory/created_mem = M.brain.SetMemory(MEM_WAYPOINT_IDENTITY, Trg, PLUS_INF)
	var/atom/waypoint = created_mem?.val

	M.SetState(STATE_DOWNTIME, FALSE)
	to_chat(usr, "Set [M] downtime-state to [FALSE]")

	// This is NOT equivalent to ~STATE_DOWNTIME!
	M.SetState(STATE_HASWAYPOINT, TRUE)
	to_chat(usr, "Set [M] waypoint-state to [TRUE]")

	to_chat(usr, (waypoint ? "[M] now tracking [waypoint]" : "[M] not tracking waypoints"))

	return waypoint


/mob/verb/CommanderGiveMoveOrder(datum/goai/mob_commander/combat_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), posX as num, posY as num)
	set category = "Commander Orders"

	var/trueX = posX % world.maxx
	var/trueY = posY % world.maxy
	var/trueZ = src.z

	var/turf/position = locate(trueX, trueY, trueZ)
	if(!position)
		to_chat(usr, "Target position does not exist!")
		return

	if(!(M?.brain))
		return

	var/datum/memory/created_mem = M.brain.SetMemory(MEM_WAYPOINT_IDENTITY, position, PLUS_INF)
	var/atom/waypoint = created_mem?.val

	M.SetState(STATE_DOWNTIME, FALSE)
	to_chat(usr, "Set [M] downtime-state to [FALSE]")

	M.SetState(STATE_HASWAYPOINT, TRUE)
	to_chat(usr, "Set [M] waypoint-state to [TRUE]")

	to_chat(usr, (waypoint ? "[M] now tracking [waypoint] @ ([trueX], [trueY], [trueZ])" : "[M] not tracking waypoints"))

	return waypoint


/mob/verb/CommanderCancelOrders(datum/goai/mob_commander/combat_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
	set category = "Commander Orders"

	M.SetState(STATE_DOWNTIME, TRUE)
	to_chat(usr, "Set [M] downtime-state to [TRUE]")

	M.SetState(STATE_HASWAYPOINT, FALSE)
	to_chat(usr, "Set [M] waypoint-state to [FALSE]")

	//to_chat(usr, (waypoint ? "[M] tracking [waypoint]" : "[M] no longer tracking waypoints"))

	return TRUE


/mob/verb/CommanderDisarm(datum/goai/mob_commander/combat_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
	set category = "Commander Orders"

	var/curr_firing_state = ((STATE_CANFIRE in M.states) ? M.states[STATE_CANFIRE] : FALSE)
	M.states[STATE_CANFIRE] = !curr_firing_state

	to_chat(usr, "[M] CAN_FIRE set to [M.states[STATE_CANFIRE]]")

	return


/datum/goai/mob_commander/combat_commander/proc/ForceSwitchPanic(var/curr_panic_state = FALSE)
	/* Panic/Calm are mutually exclusive, but we often need to express Action constraints
	// on one or the other, and it's not possible without building some weirder, more fancy
	// algebra of States, so the lazy solution is to just have two independent variables.
	*/
	src.needs[NEED_COMPOSURE] = (curr_panic_state ? NEED_SATISFIED : NEED_MINIMUM)
	if(src.brain)
		src.brain.SetNeed(NEED_COMPOSURE, (curr_panic_state ? NEED_SATISFIED : NEED_MINIMUM))

	src.SetState(STATE_PANIC, (curr_panic_state ? FALSE : TRUE))
	to_chat(usr, "[src] [curr_panic_state ? "unpanicked" : "panicked"]!")

	return TRUE


/mob/verb/CommanderPanic(datum/goai/mob_commander/combat_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
	set category = "Commander Orders"

	var/curr_panic_state = M.GetState(STATE_PANIC)
	to_chat(usr, "[M] curr_panic_state is [curr_panic_state]")
	M.ForceSwitchPanic(curr_panic_state)
	to_chat(usr, "[M] [curr_panic_state ? "unpanicked" : "panicked"]!")
	return



/mob/verb/CommanderSetForcedFriendTag(datum/goai/mob_commander/combat_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), tag as text)
	set category = "Commander Orders"

	if(!M)
		return

	if(!tag)
		return

	M.SetRelationshipTag(tag, GOAI_REL_LUDICROUS_VALUE, GOAI_REL_LUDICROUS_WEIGHT)
	return


/mob/verb/CommanderSetForcedFoeTag(datum/goai/mob_commander/combat_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), tag as text)
	set category = "Commander Orders"

	if(!M)
		return

	if(!tag)
		return

	M.SetRelationshipTag(tag, -GOAI_REL_LUDICROUS_VALUE, GOAI_REL_LUDICROUS_WEIGHT)
	return


/mob/verb/CommanderDropRelationshipTag(datum/goai/mob_commander/combat_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry), tag as text)
	set category = "Commander Orders"

	if(!M)
		return

	if(!tag)
		return

	var/result = M.DropRelationshipTag(tag)
	to_chat(usr, "[M] - Tag [tag] [result ? "dropped successfully" : "failed to drop"]!")
	return


/datum/goai/mob_commander/combat_commander/proc/ForceSwitchBerserk(var/curr_berserk_state = FALSE)
	/* Panic/Calm are mutually exclusive, but we often need to express Action constraints
	// on one or the other, and it's not possible without building some weirder, more fancy
	// algebra of States, so the lazy solution is to just have two independent variables.
	*/
	src.SetState("BERSERK", (curr_berserk_state ? FALSE : TRUE))

	return TRUE


/mob/verb/CommanderMakeBerserk(datum/goai/mob_commander/combat_commander/M in GOAI_LIBBED_GLOB_ATTR(global_goai_registry))
	set category = "Commander Orders"

	var/curr_berserk_state = M.GetState("BERSERK")
	to_chat(usr, "[M] curr_berserk_state is [curr_berserk_state]")
	M.ForceSwitchBerserk(curr_berserk_state)
	to_chat(usr, "[M] [curr_berserk_state ? "kalmed" : "BERSERKED"]!")
	return
