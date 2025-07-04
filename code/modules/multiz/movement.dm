/mob/verb/up()
	set name = "Move Upwards"
	set category = "IC"

	move_up()

/mob/verb/down()
	set name = "Move Down"
	set category = "IC"

	SelfMove(DOWN)

/mob/proc/move_up()
	SelfMove(UP)

/mob/living/carbon/human/move_up()
	var/turf/old_loc = loc
	..()
	if(loc != old_loc)
		return

	var/turf/simulated/open/O = GetAbove(src)
	var/atom/climb_target
	if(istype(O))
		for(var/turf/T in trange(1,O))
			if(!isopenspace(T) && T.is_floor())
				climb_target = T
			else
				for(var/obj/I in T)
					if(I.obj_flags & OBJ_FLAG_NOFALL)
						climb_target = I
						break
			if(climb_target)
				break

	if(climb_target)
		climb_up(climb_target)

/mob/proc/zPull(direction)
	//checks and handles pulled items across z levels
	if(!pulling)
		return 0

	var/turf/start = pulling.loc
	var/turf/destination = (direction == UP) ? GetAbove(pulling) : GetBelow(pulling)

	if(!start.CanZPass(pulling, direction))
		to_chat(src, SPAN_WARNING("\The [start] blocked your pulled object!"))
		stop_pulling()
		return 0

	if(!destination.CanZPass(pulling, direction))
		to_chat(src, SPAN_WARNING("The [pulling] you were pulling bumps up against \the [destination]."))
		stop_pulling()
		return 0

	for(var/atom/A in destination)
		if(!A.CanMoveOnto(pulling, start, 1.5, direction))
			to_chat(src, SPAN_WARNING("\The [A] blocks the [pulling] you were pulling."))
			stop_pulling()
			return 0

	pulling.forceMove(destination)
	return 1

/**
 * Whether or not an atom can move through or onto the same tile as this atom. Primarily used for z-level transitioning in multi-z areas.
 *
 * By default, passes directly to `CanPass()` and also checks upward movement with climbable atoms.
 *
 * **Parameters**:
 * - `mover` - The atom attempting to move onto `target`.
 * - `target` - The originally targeted turf that `src `may be blocking.
 * - `height` (float) -
 * - `direction` (bitflag/direction) - The direction of movement. This should only ever be `DOWN` or `UP`.
 *
 * Returns boolean.
 */
/atom/proc/CanMoveOnto(atom/movable/mover, turf/target, height=1.5, direction = 0)
	return CanPass(mover, target, height, 0) || (direction == DOWN && (atom_flags & ATOM_FLAG_CLIMBABLE))

/mob/proc/can_overcome_gravity()
	return FALSE

/mob/living/carbon/human/can_overcome_gravity()
	//First do species check
	if(species && species.can_overcome_gravity(src))
		return 1
	else
		if (isturf(loc))
			var/turf/T = loc
			if(((T.height + T.get_fluid_depth()) >= FLUID_DEEP) || T.get_fluid_depth() >= FLUID_MAX_DEPTH)
				return can_float()

			for(var/atom/a in src.loc)
				if(a.atom_flags & ATOM_FLAG_CLIMBABLE)
					return 1

		//Last check, list of items that could plausibly be used to climb but aren't climbable themselves
		var/list/objects_to_stand_on = list(
				/obj/item/stool,
				/obj/structure/bed,
			)
		for(var/type in objects_to_stand_on)
			if(locate(type) in src.loc)
				return 1
	return 0

/mob/proc/can_ztravel()
	return 0

/mob/living/carbon/human/can_ztravel()
	if(Process_Spacemove())
		return 1

	if(Check_Shoegrip())	//scaling hull with magboots
		for(var/turf/simulated/T in trange(1,src))
			if(T.density)
				return 1

/mob/living/silicon/robot/can_ztravel()
	if(Process_Spacemove()) //Checks for active jetpack
		return 1

	for(var/turf/simulated/T in trange(1,src)) //Robots get "magboots"
		if(T.density)
			return 1

//FALLING STUFF

//Holds fall checks that should not be overriden by children
/atom/movable/proc/fall(lastloc)
	if(!isturf(loc))
		return

	var/turf/below = GetBelow(src)
	if(!below)
		return

	var/turf/T = loc
	if(!T.CanZPass(src, DOWN) || !below.CanZPass(src, DOWN))
		return

	// No gravity in space, apparently.
	if(!has_gravity())
		return

	if(throwing)
		return

	if(can_fall())
		begin_falling(lastloc, below)

// We timer(0) here to let the current move operation complete before we start falling. fall() is normally called from
// Entered() which is part of Move(), by spawn()ing we let that complete.  But we want to preserve if we were in client movement
// or normal movement so other move behavior can continue.
/atom/movable/proc/begin_falling(lastloc, below)
	if (QDELETED(src))
		return
	addtimer(new Callback(src, PROC_REF(fall_callback), below), 0)

/atom/movable/proc/fall_callback(turf/below)
	var/mob/M = src
	var/is_client_moving = (ismob(M) && M.moving)
	if(is_client_moving) M.moving = 1
	handle_fall(below)
	if(is_client_moving) M.moving = 0

//For children to override
/atom/movable/proc/can_fall(anchor_bypass = FALSE, turf/location_override = loc)
	if(!simulated)
		return FALSE

	if(anchored && !anchor_bypass)
		return FALSE

	//Override will make checks from different location used for prediction
	if(location_override)
		for(var/obj/O in location_override)
			if(O.obj_flags & OBJ_FLAG_NOFALL)
				return FALSE

		var/turf/below = GetBelow(location_override)
		for(var/atom/A in below)
			if(!A.CanPass(src, location_override))
				return FALSE

		if(location_override.get_fluid_depth() >= FLUID_DEEP)
			if(below == loc) //We are checking above,
				if(!(below.get_fluid_depth() >= 0.95 * FLUID_MAX_DEPTH)) //No salmon skipping up a stream of falling water
					return TRUE
			return !can_float()

	return TRUE

/obj/can_fall(anchor_bypass = FALSE, turf/location_override = loc)
	return ..(anchor_fall)

/obj/effect/can_fall(anchor_bypass = FALSE, turf/location_override = loc)
	return FALSE

/obj/decal/cleanable/can_fall(anchor_bypass = FALSE, turf/location_override = loc)
	return TRUE

/obj/item/pipe/can_fall(anchor_bypass = FALSE, turf/location_override = loc)
	var/turf/simulated/open/below = loc
	below = below.below

	. = ..()

	if(anchored)
		return FALSE

	if((locate(/obj/structure/disposalpipe/up) in below) || locate(/obj/machinery/atmospherics/pipe/zpipe/up) in below)
		return FALSE

/mob/living/carbon/human/can_fall(anchor_bypass = FALSE, turf/location_override = loc)
	if(..())
		return species.can_fall(src)

/atom/movable/proc/handle_fall(turf/landing)
	forceMove(landing)
	if(locate(/obj/structure/stairs) in landing)
		return 1
	else if(landing.get_fluid_depth() >= FLUID_DEEP)
		visible_message(SPAN_NOTICE("\The [src] falls into the water!"), SPAN_NOTICE("What a splash!"))
		playsound(src,  'sound/effects/watersplash.ogg', 30, TRUE)
		return 1
	else
		handle_fall_effect(landing)

/atom/movable/proc/handle_fall_effect(turf/landing)
	if(istype(landing, /turf/simulated/open))
		visible_message("\The [src] falls through \the [landing]!", "You hear a whoosh of displaced air.")
	else
		visible_message("\The [src] slams into \the [landing]!", "You hear something slam into the deck.")
		var/obj/item/rig/rig = get_rig()
		if (istype(rig))
			for (var/obj/item/rig_module/actuators/A in rig.installed_modules)
				if (A.active)
					visible_message(
						SPAN_NOTICE("\The [src]'s suit whirrs loudly as \the [rig] absorbs the fall!"),
						SPAN_NOTICE("You hear an electric <i>*whirr*</i> right after the slam!")
					)

		if (fall_damage())
			for (var/mob/living/M in landing.contents)
				if (M == src)
					continue
				visible_message("\The [src] hits \the [M.name]!")
				M.take_overall_damage(fall_damage())


/atom/movable/proc/fall_damage()
	return 0

/obj/fall_damage()
	if(w_class == ITEM_SIZE_TINY)
		return 0
	if(w_class == ITEM_SIZE_NO_CONTAINER)
		return 150
	return BASE_STORAGE_COST(w_class)

/mob/living/carbon/human/handle_fall_effect(turf/landing)
	if(species && species.handle_fall_special(src, landing))
		return

	if(src.mind && src.mind.changeling && src.mind.changeling.tendons_reinforced)
		return

	var/obj/item/rig/rig = get_rig()
	if (istype(rig))
		for (var/obj/item/rig_module/actuators/A in rig.installed_modules)
			if (A.active && rig.check_power_cost(src, 50 KILOWATTS, A, 0))
				return

	..()

	var/min_damage = 7
	var/max_damage = 14
	apply_damage(rand(min_damage, max_damage), DAMAGE_BRUTE, BP_HEAD, armor_pen = 50)
	apply_damage(rand(min_damage, max_damage), DAMAGE_BRUTE, BP_CHEST, armor_pen = 50)
	apply_damage(rand(min_damage, max_damage), DAMAGE_BRUTE, BP_GROIN, armor_pen = 75)
	apply_damage(rand(min_damage, max_damage), DAMAGE_BRUTE, BP_L_LEG, armor_pen = 100)
	apply_damage(rand(min_damage, max_damage), DAMAGE_BRUTE, BP_R_LEG, armor_pen = 100)
	apply_damage(rand(min_damage, max_damage), DAMAGE_BRUTE, BP_L_FOOT, armor_pen = 100)
	apply_damage(rand(min_damage, max_damage), DAMAGE_BRUTE, BP_R_FOOT, armor_pen = 100)
	apply_damage(rand(min_damage, max_damage), DAMAGE_BRUTE, BP_L_ARM, armor_pen = 75)
	apply_damage(rand(min_damage, max_damage), DAMAGE_BRUTE, BP_R_ARM, armor_pen = 75)
	weakened = max(weakened, 3)
	if(prob(10))
		var/list/victims = list()
		for(var/tag in list(BP_L_FOOT, BP_R_FOOT, BP_L_ARM, BP_R_ARM))
			var/obj/item/organ/external/E = get_organ(tag)
			if(E && !E.is_stump() && !E.dislocated && !BP_IS_ROBOTIC(E))
				victims += E
		if(length(victims))
			var/obj/item/organ/external/victim = pick(victims)
			victim.dislocate()
			to_chat(src, SPAN_WARNING("You feel a sickening pop as your [victim.joint] is wrenched out of the socket."))
	updatehealth()


/mob/living/carbon/human/proc/climb_up(atom/A)
	if(!isturf(loc) || !bound_overlay || bound_overlay.destruction_timer || is_physically_disabled())	// This destruction_timer check ideally wouldn't be required, but I'm not awake enough to refactor this to not need it.
		return FALSE

	var/turf/T = get_turf(A)
	var/turf/above = GetAbove(src)
	var/obj/item/rig/rig = get_rig()
	if(above && T.Adjacent(bound_overlay) && above.CanZPass(src, UP)) //Certain structures will block passage from below, others not

		if (istype(rig)) ///RIG actuator jumps overcome gravity.
			for (var/obj/item/rig_module/actuators/R in rig.installed_modules)
				if (R.active && rig.check_power_cost(src, 50 KILOWATTS, A, 0))
					visible_message(
						SPAN_NOTICE("\The [src] prepares to leap upwards onto \the [A]!"),
						SPAN_NOTICE("You crouch, preparing to leap upwards onto \the [A]!")
					)
					if (do_after(src, 2 SECONDS, A, DO_PUBLIC_UNIQUE))
						if(src.incapacitated() || src.restrained())
							to_chat(src, SPAN_WARNING("You are in no condition to activate your suit."))
							return TRUE
						visible_message(
							SPAN_NOTICE("\The [src]'s suit whirrs aggressively as they leap up to \the [A]!"),
							SPAN_NOTICE("You leap to \the [A]!")
						)
						src.Move(T)
						return TRUE

		if(loc.has_gravity() && !can_overcome_gravity())
			return FALSE

		visible_message(SPAN_NOTICE("[src] starts climbing onto \the [A]!"), SPAN_NOTICE("You start climbing onto \the [A]!"))
		if(do_after(src, 5 SECONDS, A, DO_PUBLIC_UNIQUE))
			visible_message(SPAN_NOTICE("[src] climbs onto \the [A]!"), SPAN_NOTICE("You climb onto \the [A]!"))
			src.Move(T)
		else
			visible_message(SPAN_WARNING("[src] gives up on trying to climb onto \the [A]!"), SPAN_WARNING("You give up on trying to climb onto \the [A]!"))
		return TRUE

/atom/movable/proc/can_float()
	return FALSE

/mob/living/can_float()
	return !is_physically_disabled()

/mob/living/aquatic/can_float()
	return TRUE

/mob/living/carbon/human/can_float()
	return species.can_float(src)

/mob/living/silicon/can_float()
	return FALSE //If they can fly otherwise it will be checked first

/mob/living
	var/atom/movable/z_observer/z_eye

/atom/movable/z_observer
	name = ""
	simulated = FALSE
	anchored = TRUE
	mouse_opacity = FALSE
	var/mob/living/owner

/atom/movable/z_observer/Initialize(mapload, mob/living/user)
	. = ..()
	owner = user
	follow()
	GLOB.moved_event.register(owner, src, PROC_REF(follow))

/atom/movable/z_observer/proc/follow()

/atom/movable/z_observer/z_up/follow()
	forceMove(get_step(owner, UP))
	if(isturf(src.loc))
		var/turf/T = src.loc
		if(T.z_flags & ZM_MIMIC_BELOW)
			return
	owner.reset_view(null)
	owner.z_eye = null
	qdel(src)

/atom/movable/z_observer/z_down/follow()
	forceMove(get_step(owner, DOWN))
	var/turf/T = get_turf(owner)
	if(T && (T.z_flags & ZM_MIMIC_BELOW))
		return
	owner.reset_view(null)
	owner.z_eye = null
	qdel(src)

/atom/movable/z_observer/Destroy()
	GLOB.moved_event.unregister(owner, src, PROC_REF(follow))
	owner = null
	return ..()

/atom/movable/z_observer/can_fall()
	return FALSE

/atom/movable/z_observer/ex_act()
	SHOULD_CALL_PARENT(FALSE)
	return

/atom/movable/z_observer/singularity_act()
	return

/atom/movable/z_observer/singularity_pull()
	return

/atom/movable/z_observer/singuloCanEat()
	return
