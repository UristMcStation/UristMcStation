GLOBAL_LIST(hazard_overlays)

//Define all tape types in policetape.dm
/obj/item/taperoll
	name = "tape roll"
	icon = 'icons/policetape.dmi'
	icon_state = "tape"
	w_class = ITEM_SIZE_SMALL
	var/turf/start
	var/turf/end
	var/tape_type = /obj/item/tape
	var/icon_base = "tape"

	var/apply_tape = FALSE

/obj/item/taperoll/Initialize()
	. = ..()
	if(!GLOB.hazard_overlays)
		GLOB.hazard_overlays = list()
		GLOB.hazard_overlays["[NORTH]"]	= new/image('icons/effects/warning_stripes.dmi', icon_state = "N")
		GLOB.hazard_overlays["[EAST]"]	= new/image('icons/effects/warning_stripes.dmi', icon_state = "E")
		GLOB.hazard_overlays["[SOUTH]"]	= new/image('icons/effects/warning_stripes.dmi', icon_state = "S")
		GLOB.hazard_overlays["[WEST]"]	= new/image('icons/effects/warning_stripes.dmi', icon_state = "W")
	if(apply_tape)
		var/turf/T = get_turf(src)
		if(!T)
			return
		var/obj/machinery/door/airlock/airlock = locate(/obj/machinery/door/airlock) in T
		if(airlock)
			use_after(airlock, null)
		return INITIALIZE_HINT_QDEL

var/global/list/tape_roll_applications = list()

/obj/item/tape
	name = "tape"
	icon = 'icons/policetape.dmi'
	icon_state = "tape"
	layer = BASE_ABOVE_OBJ_LAYER
	randpixel = 0
	anchored = TRUE
	var/lifted = 0
	var/crumpled = 0
	var/tape_dir = 0
	var/icon_base = "tape"
	var/detail_overlay
	var/detail_color

/obj/item/tape/on_update_icon()
	//Possible directional bitflags: 0 (AIRLOCK), 1 (NORTH), 2 (SOUTH), 4 (EAST), 8 (WEST), 3 (VERTICAL), 12 (HORIZONTAL)
	ClearOverlays()
	var/new_state
	switch (tape_dir)
		if(0)  // AIRLOCK
			new_state = "[icon_base]_door"
		if(3)  // VERTICAL
			new_state = "[icon_base]_v"
		if(12) // HORIZONTAL
			new_state = "[icon_base]_h"
		else   // END POINT (1|2|4|8)
			new_state = "[icon_base]_dir"
			dir = tape_dir
	icon_state = "[new_state]_[crumpled]"
	if(detail_overlay)
		var/image/I = overlay_image(icon, "[new_state]_[detail_overlay]", flags=RESET_COLOR)
		I.color = detail_color
		AddOverlays(I)

/obj/item/taperoll/police
	name = "police tape"
	desc = "A roll of police tape used to block off crime scenes from the public."
	tape_type = /obj/item/tape/police
	color = COLOR_RED

/obj/item/tape/police
	name = "police tape"
	desc = "A length of police tape.  Do not cross."
	req_access = list(access_security)
	color = COLOR_RED

/obj/item/taperoll/engineering
	name = "engineering tape"
	desc = "A roll of engineering tape used to block off working areas from the public."
	tape_type = /obj/item/tape/engineering
	color = COLOR_ORANGE

/obj/item/taperoll/engineering/applied
	apply_tape = TRUE

/obj/item/tape/engineering
	name = "engineering tape"
	desc = "A length of engineering tape. Better not cross it."
	req_access = list(list(access_engine,access_atmospherics))
	color = COLOR_ORANGE

/obj/item/taperoll/atmos
	name = "atmospherics tape"
	desc = "A roll of atmospherics tape used to block off working areas from the public."
	tape_type = /obj/item/tape/atmos
	color = COLOR_BLUE_LIGHT

/obj/item/tape/atmos
	name = "atmospherics tape"
	desc = "A length of atmospherics tape. Better not cross it."
	req_access = list(list(access_engine,access_atmospherics))
	color = COLOR_BLUE_LIGHT
	icon_base = "stripetape"
	detail_overlay = "stripes"
	detail_color = COLOR_YELLOW

/obj/item/taperoll/research
	name = "research tape"
	desc = "A roll of research tape used to block off working areas from the public."
	tape_type = /obj/item/tape/research
	color = COLOR_PURPLE

/obj/item/tape/research
	name = "research tape"
	desc = "A length of research tape. Better not cross it."
	req_access = list(access_research)
	color = COLOR_RESEARCH

/obj/item/taperoll/medical
	name = "medical tape"
	desc = "A roll of medical tape used to block off working areas from the public."
	tape_type = /obj/item/tape/medical
	color = COLOR_PALE_BLUE_GRAY

/obj/item/tape/medical
	name = "medical tape"
	desc = "A length of medical tape. Better not cross it."
	req_access = list(access_medical)
	icon_base = "stripetape"
	detail_overlay = "stripes"
	detail_color = COLOR_PALE_BLUE_GRAY

/obj/item/taperoll/bureaucracy
	name = "red tape"
	desc = "A roll of bureaucratic red tape used to block any meaningful work from being done."
	tape_type = /obj/item/tape/bureaucracy
	color = COLOR_RED

/obj/item/tape/bureaucracy
	name = "red tape"
	desc = "A length of bureaucratic red tape. Safely ignored, but darn obstructive sometimes."
	icon_base = "stripetape"
	color = COLOR_RED
	detail_overlay = "stripes"
	detail_color = COLOR_RED

/obj/item/taperoll/on_update_icon()
	ClearOverlays()
	var/image/overlay = image(icon = src.icon)
	overlay.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	if(ismob(loc))
		if(!start)
			overlay.icon_state = "start"
		else
			overlay.icon_state = "stop"
		AddOverlays(overlay)

/obj/item/taperoll/dropped(mob/user)
	update_icon()
	return ..()

/obj/item/taperoll/pickup(mob/user)
	update_icon()
	return ..()

/obj/item/taperoll/attack_hand()
	update_icon()
	return ..()

/obj/item/taperoll/attack_self(mob/user as mob)
	if(!start)
		start = get_turf(src)
		to_chat(usr, SPAN_NOTICE("You place the first end of \the [src]."))
		update_icon()
	else
		end = get_turf(src)
		if(start.y != end.y && start.x != end.x || start.z != end.z)
			start = null
			update_icon()
			to_chat(usr, SPAN_NOTICE("\The [src] can only be laid horizontally or vertically."))
			return

		if(start == end)
			// spread tape in all directions, provided there is a wall/window
			var/turf/T
			var/possible_dirs = 0
			for(var/dir in GLOB.cardinal)
				T = get_step(start, dir)
				if(T && T.density)
					possible_dirs += dir
				else
					for(var/obj/structure/window/W in T)
						if(W.is_fulltile() || W.dir == GLOB.reverse_dir[dir])
							possible_dirs += dir
			if(!possible_dirs)
				start = null
				update_icon()
				to_chat(usr, SPAN_NOTICE("You can't place \the [src] here."))
				return
			if(possible_dirs & (NORTH|SOUTH))
				var/obj/item/tape/TP = new tape_type(start)
				for(var/dir in list(NORTH, SOUTH))
					if (possible_dirs & dir)
						TP.tape_dir += dir
				TP.add_fingerprint(user)
				TP.update_icon()
			if(possible_dirs & (EAST|WEST))
				var/obj/item/tape/TP = new tape_type(start)
				for(var/dir in list(EAST, WEST))
					if (possible_dirs & dir)
						TP.tape_dir += dir
				TP.add_fingerprint(user)
				TP.update_icon()
			start = null
			update_icon()
			to_chat(usr, SPAN_NOTICE("You finish placing \the [src]."))
			return

		var/turf/cur = start
		var/orientation = get_dir(start, end)
		var/dir = 0
		switch(orientation)
			if(NORTH, SOUTH)	dir = NORTH|SOUTH	// North-South taping
			if(EAST,   WEST)	dir =  EAST|WEST	// East-West taping

		var/can_place = 1
		while (can_place)
			if(cur.density)
				can_place = 0
			else if (istype(cur, /turf/space))
				can_place = 0
			else
				for(var/obj/O in cur)
					if(O.density)
						can_place = 0
						break
			if(cur == end)
				break
			cur = get_step_towards(cur,end)
		if (!can_place)
			start = null
			update_icon()
			to_chat(usr, SPAN_WARNING("You can't run \the [src] through that!"))
			return

		cur = start
		var/tapetest
		var/tape_dir
		while (1)
			tapetest = 0
			tape_dir = dir
			if(cur == start)
				var/turf/T = get_step(start, GLOB.reverse_dir[orientation])
				if(T && !T.density)
					tape_dir = orientation
					for(var/obj/structure/window/W in T)
						if(W.is_fulltile() || W.dir == orientation)
							tape_dir = dir
			else if(cur == end)
				var/turf/T = get_step(end, orientation)
				if(T && !T.density)
					tape_dir = GLOB.reverse_dir[orientation]
					for(var/obj/structure/window/W in T)
						if(W.is_fulltile() || W.dir == GLOB.reverse_dir[orientation])
							tape_dir = dir
			for(var/obj/item/tape/T in cur)
				if((T.tape_dir == tape_dir) && (T.icon_base == icon_base))
					tapetest = 1
					break
			if(!tapetest)
				var/obj/item/tape/T = new tape_type(cur)
				T.add_fingerprint(user)
				T.tape_dir = tape_dir
				T.update_icon()
				if(tape_dir & SOUTH)
					T.layer += 0.1 // Must always show above other tapes
			if(cur == end)
				break
			cur = get_step_towards(cur,end)
		start = null
		update_icon()
		to_chat(usr, SPAN_NOTICE("You finish placing \the [src]."))
		return

/obj/item/taperoll/use_before(atom/A, mob/living/user, click_parameters)
	if (istype(A, /obj/machinery/door/airlock))
		var/turf/T = get_turf(A)
		var/obj/item/tape/P = new tape_type(T)
		P.add_fingerprint(user)
		P.update_icon()
		P.layer = ABOVE_DOOR_LAYER
		to_chat(user, SPAN_NOTICE("You finish placing \the [src]."))
		return TRUE

	if (istype(A, /turf/simulated/floor) || istype(A, /turf/unsimulated/floor))
		var/turf/F = A
		var/direction = user.loc == F ? user.dir : turn(user.dir, 180)
		var/hazard_overlay = GLOB.hazard_overlays["[direction]"]
		if(isnull(tape_roll_applications[F]))
			tape_roll_applications[F] = 0

		if(tape_roll_applications[F] & direction)
			user.visible_message("\The [user] uses the adhesive of \the [src] to remove area markings from \the [F].", "You use the adhesive of \the [src] to remove area markings from \the [F].")
			F.CutOverlays(hazard_overlay)
			tape_roll_applications[F] &= ~direction
		else
			user.visible_message("\The [user] applied \the [src] on \the [F] to create area markings.", "You apply \the [src] on \the [F] to create area markings.")
			F.AddOverlays(hazard_overlay)
			tape_roll_applications[F] |= direction
		return TRUE

	return ..()

/obj/item/tape/proc/crumple()
	if(!crumpled)
		crumpled = 1
		update_icon()
		SetName("crumpled [name]")

/obj/item/tape/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!lifted && ismob(mover))
		var/mob/M = mover
		add_fingerprint(M)
		if (!allowed(M))	//only select few learn art of not crumpling the tape
			to_chat(M, SPAN_WARNING("You are not supposed to go past [src]..."))
			if(M.a_intent == I_HELP)
				return 0
			crumple()
	return ..(mover)

/obj/item/tape/use_tool(obj/item/item, mob/living/user, list/click_params)
	if (user.a_intent == I_HELP)
		return ..()
	breaktape(user)

/obj/item/tape/attack_hand(mob/user as mob)
	if (user.a_intent == I_HELP && src.allowed(user))
		user.show_viewers(SPAN_NOTICE("\The [user] lifts \the [src], allowing passage."))
		for(var/obj/item/tape/T in gettapeline())
			T.lift(100) //~10 seconds
	else
		breaktape(user)

/obj/item/tape/proc/lift(time)
	lifted = 1
	layer = ABOVE_HUMAN_LAYER
	spawn(time)
		lifted = 0
		reset_plane_and_layer()

// Returns a list of all tape objects connected to src, including itself.
/obj/item/tape/proc/gettapeline()
	var/list/dirs = list()
	if(tape_dir & NORTH)
		dirs += NORTH
	if(tape_dir & SOUTH)
		dirs += SOUTH
	if(tape_dir & WEST)
		dirs += WEST
	if(tape_dir & EAST)
		dirs += EAST

	var/list/obj/item/tape/tapeline = list()
	for (var/obj/item/tape/T in get_turf(src))
		tapeline += T
	for(var/dir in dirs)
		var/turf/cur = get_step(src, dir)
		var/not_found = 0
		while (!not_found)
			not_found = 1
			for (var/obj/item/tape/T in cur)
				tapeline += T
				not_found = 0
			cur = get_step(cur, dir)
	return tapeline




/obj/item/tape/proc/breaktape(mob/user)
	if(user.a_intent == I_HELP)
		to_chat(user, SPAN_WARNING("You refrain from breaking \the [src]."))
		return
	user.visible_message(SPAN_NOTICE("\The [user] breaks \the [src]!"),SPAN_NOTICE("You break \the [src]."))

	for (var/obj/item/tape/T in gettapeline())
		if(T == src)
			continue
		if(T.tape_dir & get_dir(T, src))
			qdel(T)

	qdel(src) //TODO: Dropping a trash item holding fibers/fingerprints of all broken tape parts
	return
