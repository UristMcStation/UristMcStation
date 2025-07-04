// Movement relayed to self handling
/datum/movement_handler/mob/relayed_movement
	VAR_PROTECTED/prevent_host_move = FALSE
	VAR_PROTECTED/list/allowed_movers

/datum/movement_handler/mob/relayed_movement/MayMove(mob/mover, is_external)
	if(is_external)
		return MOVEMENT_PROCEED
	if(mover == mob && !(prevent_host_move && LAZYLEN(allowed_movers) && !LAZYISIN(allowed_movers, mover)))
		return MOVEMENT_PROCEED
	if(LAZYISIN(allowed_movers, mover))
		return MOVEMENT_PROCEED

	return MOVEMENT_STOP

/datum/movement_handler/mob/relayed_movement/proc/AddAllowedMover(mover)
	LAZYDISTINCTADD(allowed_movers, mover)

/datum/movement_handler/mob/relayed_movement/proc/RemoveAllowedMover(mover)
	LAZYREMOVE(allowed_movers, mover)

// Admin object possession
/datum/movement_handler/mob/admin_possess/DoMove(direction)
	if(QDELETED(mob.control_object))
		return MOVEMENT_REMOVE

	. = MOVEMENT_HANDLED

	var/atom/movable/control_object = mob.control_object
	step(control_object, direction)
	if(QDELETED(control_object))
		. |= MOVEMENT_REMOVE
	else
		control_object.set_dir(direction)

// Death handling
/datum/movement_handler/mob/death/DoMove()
	if(mob.stat != DEAD)
		return
	. = MOVEMENT_HANDLED
	if(!mob.client)
		return
	mob.ghostize()

// Incorporeal/Ghost movement
/datum/movement_handler/mob/incorporeal/DoMove(direction)
	. = MOVEMENT_HANDLED
	direction = mob.AdjustMovementDirection(direction)

	var/turf/T = get_step(mob, direction)
	if(!mob.MayEnterTurf(T))
		return

	if(!mob.forceMove(T))
		return

	mob.set_dir(direction)
	mob.PostIncorporealMovement()

/mob/proc/PostIncorporealMovement()
	return

// Eye movement
/datum/movement_handler/mob/eye/DoMove(direction, mob/mover)
	if(IS_NOT_SELF(mover)) // We only care about direct movement
		return
	if(!mob.eyeobj)
		return
	mob.eyeobj.EyeMove(direction)
	return MOVEMENT_HANDLED

/datum/movement_handler/mob/eye/MayMove(mob/mover, is_external)
	if(IS_NOT_SELF(mover))
		return MOVEMENT_PROCEED
	if(is_external)
		return MOVEMENT_PROCEED
	if(!mob.eyeobj)
		return MOVEMENT_PROCEED
	return (MOVEMENT_PROCEED|MOVEMENT_HANDLED)

/datum/movement_handler/mob/space
	var/allow_move

// Space movement
/datum/movement_handler/mob/space/DoMove(direction, mob/mover)
	if(!mob.has_gravity())
		if(!allow_move)
			return MOVEMENT_HANDLED
		if(!mob.space_do_move(allow_move, direction))
			return MOVEMENT_HANDLED

/datum/movement_handler/mob/space/MayMove(mob/mover, is_external)
	if(IS_NOT_SELF(mover) && is_external)
		return MOVEMENT_PROCEED

	if(!mob.has_gravity())
		allow_move = mob.Process_Spacemove(TRUE)
		if(!allow_move)
			return MOVEMENT_STOP

	return MOVEMENT_PROCEED

// Buckle movement
/datum/movement_handler/mob/buckle_relay/DoMove(direction, mover)
	if (!mob.pulledby && !mob.buckled)
		return
	if (isturf(mob.loc))
		var/turf/turf = mob.loc
		if (!turf.has_gravity())
			DoFeedback(SPAN_WARNING("You need gravity to move!"))
			return
	if(istype(mob.buckled, /obj/vehicle))
		//drunk driving
		if(mob.is_confused() && prob(20)) //vehicles tend to keep moving in the same direction
			direction = turn(direction, pick(90, -90))
		mob.buckled.relaymove(mob, direction)
		return MOVEMENT_HANDLED
	if (istype(mob.pulledby, /obj/structure/bed/chair/wheelchair))
		. = MOVEMENT_HANDLED
		mob.pulledby.DoMove(direction, mob)
		return
	if (istype(mob.buckled, /obj/structure/bed/chair/wheelchair))
		. = MOVEMENT_HANDLED
		if(ishuman(mob))
			var/mob/living/carbon/human/driver = mob
			if (!isnull(driver.l_hand) && !isnull(driver.r_hand))
				DoFeedback(SPAN_WARNING("You need at least one free hand to move!"))
				return
			var/obj/item/organ/external/l_hand = driver.get_organ(BP_L_HAND)
			var/obj/item/organ/external/r_hand = driver.get_organ(BP_R_HAND)
			if (!l_hand && !r_hand || l_hand?.is_stump() && r_hand?.is_stump())
				DoFeedback(SPAN_WARNING("You need at least one free hand to move!"))
				return
		direction = mob.AdjustMovementDirection(direction)
		mob.buckled.DoMove(direction, mob)

/datum/movement_handler/mob/buckle_relay/MayMove(mover)
	if(mob.buckled)
		return mob.buckled.MayMove(mover, FALSE) ? (MOVEMENT_PROCEED|MOVEMENT_HANDLED) : MOVEMENT_STOP
	return MOVEMENT_PROCEED

// Movement delay
/datum/movement_handler/mob/delay
	VAR_PROTECTED/next_move

/datum/movement_handler/mob/delay/DoMove(direction, mover, is_external)
	if(is_external)
		return
	next_move = world.time + max(1, mob.movement_delay())

/datum/movement_handler/mob/delay/MayMove(mover, is_external)
	if(IS_NOT_SELF(mover) && is_external)
		return MOVEMENT_PROCEED
	return ((mover && mover != mob) ||  world.time >= next_move) ? MOVEMENT_PROCEED : MOVEMENT_STOP

/datum/movement_handler/mob/delay/proc/SetDelay(delay)
	next_move = max(next_move, world.time + delay)

/datum/movement_handler/mob/delay/proc/AddDelay(delay)
	next_move += max(0, delay)

// Stop effect
/datum/movement_handler/mob/stop_effect/DoMove()
	if(MayMove() == MOVEMENT_STOP)
		return MOVEMENT_HANDLED

/datum/movement_handler/mob/stop_effect/MayMove()
	for(var/obj/stop/S in mob.loc)
		if(S.victim == mob)
			return MOVEMENT_STOP
	return MOVEMENT_PROCEED

// Transformation
/datum/movement_handler/mob/transformation/MayMove()
	return MOVEMENT_STOP

// Consciousness - Is the entity trying to conduct the move conscious?
/datum/movement_handler/mob/conscious/MayMove(mob/mover)
	return (mover ? mover.stat == CONSCIOUS : mob.stat == CONSCIOUS) ? MOVEMENT_PROCEED : MOVEMENT_STOP

// Along with more physical checks
/datum/movement_handler/mob/physically_capable/MayMove(mob/mover)
	// We only check physical capability if the host mob tried to do the moving
	return ((mover && mover != mob) || !mob.incapacitated(INCAPACITATION_DISABLED & ~INCAPACITATION_FORCELYING)) ? MOVEMENT_PROCEED : MOVEMENT_STOP

// Is anything physically preventing movement?
/datum/movement_handler/mob/physically_restrained/MayMove(mob/mover)
	if(mob.anchored)
		if(mover == mob)
			to_chat(mob, SPAN_NOTICE("You're anchored down!"))
		return MOVEMENT_STOP

	if(istype(mob.buckled) && !mob.buckled.buckle_movable)
		if(mover == mob)
			to_chat(mob, SPAN_NOTICE("You're buckled to \the [mob.buckled]!"))
		return MOVEMENT_STOP

	if(LAZYLEN(mob.pinned))
		if(mover == mob)
			to_chat(mob, SPAN_NOTICE("You're pinned down by \a [mob.pinned[1]]!"))
		return MOVEMENT_STOP

	for(var/obj/item/grab/G in mob.grabbed_by)
		if(G.assailant != mob && G.stop_move())
			if(mover == mob)
				to_chat(mob, SPAN_NOTICE("You're stuck in a grab!"))
			mob.ProcessGrabs()
			return MOVEMENT_STOP

	if(mob.restrained())
		for(var/mob/M in range(mob, 1))
			if(M.pulling == mob)
				if(!M.incapacitated() && mob.Adjacent(M))
					if(mover == mob)
						to_chat(mob, SPAN_NOTICE("You're restrained! You can't move!"))
					return MOVEMENT_STOP
				else
					M.stop_pulling()

	return MOVEMENT_PROCEED


/mob/living/ProcessGrabs()
	//if we are being grabbed
	if(length(grabbed_by))
		resist() //shortcut for resisting grabs

/mob/proc/ProcessGrabs()
	return


// Finally.. the last of the mob movement junk
/datum/movement_handler/mob/movement/DoMove(direction, mob/mover)
	. = MOVEMENT_HANDLED

	if(mob.moving)
		return

	if(!mob.lastarea)
		mob.lastarea = get_area(mob.loc)

	//We are now going to move
	mob.moving = 1

	direction = mob.AdjustMovementDirection(direction)
	var/turf/old_turf = get_turf(mob)

	if(direction & (UP|DOWN))
		var/txt_dir = direction & UP ? "upwards" : "downwards"
		old_turf.visible_message(SPAN_NOTICE("[mob] moves [txt_dir]."))
		if(mob.pulling)
			mob.zPull(direction)

	step(mob, direction)
	// In case mobs ceased existing during the step. Silly edge case but it does happen.
	if (!mob)
		return

	// Something with pulling things
	var/extra_delay = HandleGrabs(direction, old_turf)
	mob.ExtraMoveCooldown(extra_delay)

	for (var/obj/item/grab/G in mob)
		if (G.assailant_reverse_facing())
			mob.set_dir(GLOB.reverse_dir[direction])
		G.assailant_moved()
	for (var/obj/item/grab/G in mob.grabbed_by)
		G.adjust_position()

	//Moving with objects stuck in you can cause bad times.
	if(get_turf(mob) != old_turf)
		if(MOVING_QUICKLY(mob))
			mob.last_quick_move_time = world.time
		mob.handle_embedded_and_stomach_objects()

	mob.moving = 0

/datum/movement_handler/mob/movement/MayMove(mob/mover)
	return IS_SELF(mover) &&  mob.moving ? MOVEMENT_STOP : MOVEMENT_PROCEED

/datum/movement_handler/mob/movement/proc/HandleGrabs(direction, old_turf)
	. = 0
	// TODO: Look into making grabs use movement events instead, this is a mess.
	for (var/obj/item/grab/G in mob)
		if(G.assailant == G.affecting)
			return
		. = max(., G.grab_slowdown())
		var/list/L = mob.ret_grab()
		if(islist(L))
			if(length(L) == 2)
				L -= mob
				var/mob/M = L[1]
				if(M)
					if (get_dist(old_turf, M) <= 1)
						if (isturf(M.loc) && isturf(mob.loc))
							if (mob.loc != old_turf && M.loc != mob.loc)
								step(M, get_dir(M.loc, old_turf))
			else
				for(var/mob/M in L)
					M.other_mobs = 1
					if(mob != M)
						M.animate_movement = 3
				for(var/mob/M in L)
					spawn( 0 )
						step(M, direction)
						return
					spawn( 1 )
						M.other_mobs = null
						M.animate_movement = 2
						return
			G.adjust_position()

// Misc. helpers
/mob/proc/MayEnterTurf(turf/T)
	return T && !((mob_flags & MOB_FLAG_HOLY_BAD) && check_is_holy_turf(T))

/mob/proc/AdjustMovementDirection(direction)
	. = direction
	if(!is_confused())
		return

	var/stability = MOVING_DELIBERATELY(src) ? 75 : 25
	if(prob(stability))
		return

	return prob(50) ? GLOB.cw_dir[.] : GLOB.ccw_dir[.]
