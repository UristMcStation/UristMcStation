/mob
	var/moving           = FALSE

/mob/proc/SelfMove(direction)
	if(DoMove(direction, src) & MOVEMENT_HANDLED)
		return TRUE // Doesn't necessarily mean the mob physically moved

/mob/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(ismob(mover))
		var/mob/moving_mob = mover
		if ((other_mobs && moving_mob.other_mobs))
			return 1
		return (!mover.density || !density || lying)
	else
		return (!mover.density || !density || lying)

/mob/proc/SetMoveCooldown(timeout)
	var/datum/movement_handler/mob/delay/delay = GetMovementHandler(/datum/movement_handler/mob/delay)
	if(delay)
		delay.SetDelay(timeout)

/mob/proc/ExtraMoveCooldown(timeout)
	var/datum/movement_handler/mob/delay/delay = GetMovementHandler(/datum/movement_handler/mob/delay)
	if(delay)
		delay.AddDelay(timeout)

/mob/proc/checkMoveCooldown()
	if(world.time < next_move)
		return FALSE // Need to wait more.
	return TRUE

/client/proc/client_dir(input, direction=-1)
	return turn(input, direction*dir2angle(dir))

/client/Northeast()
	diagonal_action(NORTHEAST)
/client/Northwest()
	diagonal_action(NORTHWEST)
/client/Southeast()
	diagonal_action(SOUTHEAST)
/client/Southwest()
	diagonal_action(SOUTHWEST)

/client/proc/diagonal_action(direction)
	switch(client_dir(direction, 1))
		if(NORTHEAST)
			swap_hand()
			return
		if(SOUTHEAST)
			attack_self()
			return
		if(SOUTHWEST)
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.toggle_throw_mode()
			else
				to_chat(usr, SPAN_WARNING("This mob type cannot throw items."))
			return
		if(NORTHWEST)
			mob.hotkey_drop()

/mob/proc/hotkey_drop()
	to_chat(src, SPAN_WARNING("This mob type cannot drop items."))

/mob/living/carbon/hotkey_drop()
	var/obj/item/hand = get_active_hand()
	if(!hand)
		to_chat(src, SPAN_WARNING("You have nothing to drop in your hand."))
	else if(hand.can_be_dropped_by_client(src))
		drop_item()

//This gets called when you press the delete button.
/client/verb/delete_key_pressed()
	set hidden = 1

	if(!usr.pulling)
		to_chat(usr, SPAN_NOTICE("You are not pulling anything."))
		return
	usr.stop_pulling()

/client/verb/swap_hand()
	set hidden = 1
	if(istype(mob, /mob/living/carbon))
		mob:swap_hand()
	if(istype(mob,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = mob
		R.cycle_modules()
	return



/client/verb/attack_self()
	set hidden = 1
	if(mob)
		mob.mode()
	return


/client/verb/toggle_throw_mode()
	set hidden = 1
	if(!istype(mob, /mob/living/carbon))
		return
	if (!mob.stat && isturf(mob.loc) && !mob.restrained())
		mob:toggle_throw_mode()
	else
		return


/client/verb/drop_item()
	set hidden = 1
	if(!isrobot(mob) && mob.stat == CONSCIOUS && isturf(mob.loc))
		var/obj/item/I = mob.get_active_hand()
		if(I && I.can_be_dropped_by_client(mob))
			mob.drop_item()

//This proc should never be overridden elsewhere at /atom/movable to keep directions sane.
/atom/movable/Move(newloc, direct)
	if (direct & (direct - 1))
		if (direct & 1)
			if (direct & 4)
				if (step(src, NORTH))
					step(src, EAST)
				else
					if (step(src, EAST))
						step(src, NORTH)
			else
				if (direct & 8)
					if (step(src, NORTH))
						step(src, WEST)
					else
						if (step(src, WEST))
							step(src, NORTH)
		else
			if (direct & 2)
				if (direct & 4)
					if (step(src, SOUTH))
						step(src, EAST)
					else
						if (step(src, EAST))
							step(src, SOUTH)
				else
					if (direct & 8)
						if (step(src, SOUTH))
							step(src, WEST)
						else
							if (step(src, WEST))
								step(src, SOUTH)
	else
		var/atom/A = src.loc

		var/olddir = dir //we can't override this without sacrificing the rest of movable/New()
		. = ..()
		if(direct != olddir)
			dir = olddir
			set_dir(direct)

		src.move_speed = world.time - src.l_move_time
		src.l_move_time = world.time
		if ((A != src.loc && A && A.z == src.z))
			src.last_move = get_dir(A, src.loc)

	if(!inertia_moving)
		inertia_next_move = world.time + inertia_move_delay
		space_drift(direct ? direct : last_move)

/client/Move(n, direction)
	if(!user_acted(src))
		return
	if(!mob)
		return // Moved here to avoid nullrefs below
	return mob.SelfMove(direction)


/mob/Process_Spacemove(allow_movement)
	. = ..()
	if (.)
		return

	var/atom/movable/backup = get_spacemove_backup()
	if (backup)
		if (istype(backup) && allow_movement)
			return backup
		return TRUE

/mob/proc/space_do_move(allow_move, direction)
	if(ismovable(allow_move))//push off things in space
		handle_space_pushoff(allow_move, direction)
		allow_move = -1

	if(allow_move == -1 && handle_spaceslipping())
		return 0

	return 1

/mob/proc/handle_space_pushoff(atom/movable/AM, direction)
	if(AM.anchored)
		return

	if(ismob(AM))
		var/mob/M = AM
		if(M.check_space_footing())
			return

	AM.inertia_ignore = src
	if(step(AM, turn(direction, 180)))
		to_chat(src, "<span class='info'>You push off of [AM] to propel yourself.</span>")
		inertia_ignore = AM

/mob/proc/get_spacemove_backup()
	var/shoegrip = Check_Shoegrip()

	for(var/thing in trange(1,src))//checks for walls or grav turf first
		var/turf/T = thing
		if(T.density || T.is_wall() || (T.is_floor() && (shoegrip || T.has_gravity())))
			return T

	var/obj/item/grab/G = locate() in src
	for(var/A in range(1, get_turf(src)))
		if(ismovable(A))
			var/atom/movable/AM = A
			if(AM == src || AM == inertia_ignore || !AM.simulated || !AM.mouse_opacity || AM == buckled)	//mouse_opacity is hacky as hell, need better solution
				continue
			if(ismob(AM))
				var/mob/M = AM
				if(M.buckled)
					continue
			if(AM.density || !AM.CanPass(src))
				if(AM.anchored)
					return AM
				if(G && AM == G.affecting)
					continue
				. = AM

/mob/proc/check_space_footing()	//checks for gravity or maglockable turfs to prevent space related movement
	if(has_gravity() || anchored || buckled)
		return 1

	if(Check_Shoegrip())
		for(var/thing in trange(1,src))	//checks for turfs that one can maglock to
			var/turf/T = thing
			if(T.density || T.is_wall() || T.is_floor())
				return 1

	return 0

/mob/proc/Check_Shoegrip()
	return 0

//return 1 if slipped, 0 otherwise
/mob/proc/handle_spaceslipping()
	if(prob(slip_chance(5)) && !buckled)
		to_chat(src, SPAN_WARNING("You slipped!"))
		step(src,turn(last_move, pick(45,-45)))
		return 1
	return 0

/mob/proc/slip_chance(prob_slip = 10)
	if(stat)
		return 0
	if(Check_Shoegrip())
		return 0
	if(MOVING_DELIBERATELY(src))
		prob_slip *= 0.5
	return prob_slip

#define DO_MOVE(this_dir) var/final_dir = turn(this_dir, -dir2angle(dir)); Move(get_step(mob, final_dir), final_dir);

/client/verb/moveup()
	set name = ".moveup"
	set instant = 1
	DO_MOVE(NORTH)

/client/verb/movedown()
	set name = ".movedown"
	set instant = 1
	DO_MOVE(SOUTH)

/client/verb/moveright()
	set name = ".moveright"
	set instant = 1
	DO_MOVE(EAST)

/client/verb/moveleft()
	set name = ".moveleft"
	set instant = 1
	DO_MOVE(WEST)

#undef DO_MOVE

/mob/proc/set_next_usable_move_intent()
	var/checking_intent = (istype(move_intent) ? move_intent.type : move_intents[1])
	for(var/i = 1 to length(move_intents)) // One full iteration of the move set.
		checking_intent = next_in_list(checking_intent, move_intents)
		if(set_move_intent(GET_SINGLETON(checking_intent)))
			return

/mob/proc/set_move_intent(singleton/move_intent/next_intent)
	if(next_intent && move_intent != next_intent && next_intent.can_be_used_by(src))
		move_intent = next_intent
		if(hud_used)
			hud_used.move_intent.icon_state = move_intent.hud_icon_state
		return TRUE
	return FALSE

/mob/proc/get_movement_datum_by_flag(move_flag = MOVE_INTENT_DELIBERATE)
	for(var/m_intent in move_intents)
		var/singleton/move_intent/check_move_intent = GET_SINGLETON(m_intent)
		if(check_move_intent.flags & move_flag)
			return check_move_intent

/mob/proc/get_movement_datum_by_missing_flag(move_flag = MOVE_INTENT_DELIBERATE)
	for(var/m_intent in move_intents)
		var/singleton/move_intent/check_move_intent = GET_SINGLETON(m_intent)
		if(!(check_move_intent.flags & move_flag))
			return check_move_intent

/mob/proc/get_movement_datums_by_flag(move_flag = MOVE_INTENT_DELIBERATE)
	. = list()
	for(var/m_intent in move_intents)
		var/singleton/move_intent/check_move_intent = GET_SINGLETON(m_intent)
		if(check_move_intent.flags & move_flag)
			. += check_move_intent

/mob/proc/get_movement_datums_by_missing_flag(move_flag = MOVE_INTENT_DELIBERATE)
	. = list()
	for(var/m_intent in move_intents)
		var/singleton/move_intent/check_move_intent = GET_SINGLETON(m_intent)
		if(!(check_move_intent.flags & move_flag))
			. += check_move_intent

/mob/verb/SetDefaultWalk()
	set name = "Set Default Walk"
	set desc = "Select your default walking style."
	set category = "IC"
	var/choice = input(usr, "Select a default walk.", "Set Default Walk") as null|anything in get_movement_datums_by_missing_flag(MOVE_INTENT_QUICK)
	if(choice && (choice in get_movement_datums_by_missing_flag(0)))
		default_walk_intent = choice
		to_chat(src, "You will now default to [default_walk_intent] when moving deliberately.")

/mob/verb/SetDefaultRun()
	set name = "Set Default Run"
	set desc = "Select your default running style."
	set category = "IC"
	var/choice = input(usr, "Select a default run.", "Set Default Run") as null|anything in get_movement_datums_by_flag(MOVE_INTENT_QUICK)
	if(choice && (choice in get_movement_datums_by_flag(MOVE_INTENT_QUICK)))
		default_run_intent = choice
		to_chat(src, "You will now default to [default_run_intent] when moving quickly.")

/client/verb/setmovingslowly()
	set hidden = TRUE
	if (!mob)
		return
	if (mob.get_preference_value(/datum/client_preference/toggle_run) == GLOB.PREF_NO)
		mob.set_moving_slowly()


/mob/proc/set_moving_slowly()
	if (!default_walk_intent)
		default_walk_intent = get_movement_datum_by_missing_flag(MOVE_INTENT_QUICK)
	if (default_walk_intent && move_intent != default_walk_intent)
		set_move_intent(default_walk_intent)


/client/verb/setmovingquickly()
	set hidden = TRUE
	if (!mob)
		return
	if (mob.get_preference_value(/datum/client_preference/toggle_run) == GLOB.PREF_NO)
		mob.set_moving_quickly()
	else
		mob.toggle_moving_quickly()


/mob/proc/set_moving_quickly()
	if (!default_run_intent)
		default_run_intent = get_movement_datum_by_flag(MOVE_INTENT_QUICK)
	if (default_run_intent && move_intent != default_run_intent)
		set_move_intent(default_run_intent)


/mob/proc/toggle_moving_quickly()
	var/quick = get_movement_datum_by_flag(MOVE_INTENT_QUICK)
	if (move_intent == quick)
		var/slow = get_movement_datum_by_missing_flag(MOVE_INTENT_QUICK)
		if (slow && move_intent != slow)
			set_move_intent(slow)
	else if (quick)
		set_move_intent(quick)


/mob/proc/can_sprint()
	return FALSE

/mob/proc/adjust_stamina(amt)
	return

/mob/proc/get_stamina()
	return 100
