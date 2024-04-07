# ifdef GOAI_LIBRARY_FEATURES

// Dev-only cover objects for testing logic

/* Abstract Base Class */
/obj/cover
	// Abstract Base Class, do not use directly!
	icon = 'icons/obj/structures.dmi'
	icon_state = "woodenbarricade"
	density = TRUE


/obj/cover/proc/Setup()
	// Generic New() code, except New() handles some stuff on top.
	// So, effectively a lifecycle hook.
	return


/obj/cover/proc/GenerateCoverData()
	src.cover_data = new()
	return src.cover_data


/obj/cover/proc/UpdateIcon()
	return icon_state


/obj/cover/New()
	Setup()
	GenerateCoverData()
	UpdateIcon()


/* Barricade. Simple obj-based (as opposed to turf-based) cover. */
/obj/cover/barricade
	name = "Barricade"
	icon_state = "woodenbarricade"


/obj/cover/barricade/Setup()
	. = ..()
	directional_blocker = new(null, null, TRUE, TRUE)


/* Table. Flippable. If flipped, acts as a unidirectional barricade. */
/obj/cover/table
	name = "Table"
	icon_state = "wood_table" // fsr cannot use a var here

	var/icon_standing = "wood_table"
	var/icon_flipped = "woodflip0"
	var/flipped = FALSE

	raycast_block_all = RAYCAST_BLOCK_CALLPROC
	raycast_cover_proc = /obj/cover/table/proc/GetTableRaytraceBlocking


/obj/cover/table/proc/GetTableRaytraceBlocking(var/hit_angle = null, var/raytype = null)
	if(!flipped)
		// Unflipped gets 30% coverage (covers legs a bit)
		return prob(30)

	var/hit_dir = angle2dir(hit_angle)
	var/hit_antidir = dir2opposite(hit_dir)

	// Flipped protects against head-on hits...
	if(src.dir == hit_dir)
		return prob(70)

	// ...but allows to fire from behind it safely
	else if (src.dir == hit_antidir)
		return FALSE

	// Perpendicular dir gets no coverage
	return FALSE


/obj/cover/table/Setup()
	directional_blocker = new()
	directional_blocker.attached_to = src  // REMOVE ME!

	if(flipped)
		directional_blocker.blocks_entry = src.dir
		directional_blocker.blocks_exit = src.dir


/obj/cover/table/UpdateIcon()
	icon_state = (flipped ? icon_flipped : icon_standing)

	layer = ((flipped && (dir != NORTH)) ? (MOB_LAYER + 1) : OBJ_LAYER)
	return


/obj/cover/table/GenerateCoverData()
	src.cover_data = ..()
	src.cover_data.is_active = flipped
	src.cover_data.cover_all = FALSE
	src.cover_data.cover_dir = dir
	return src.cover_data


/obj/cover/table/proc/pFlip(var/flip_dir = null)
	if(isnull(flip_dir))
		return

	dir = flip_dir
	flipped = TRUE
	src.cover_data.is_active = TRUE
	src.cover_data.cover_dir = flip_dir

	if(isnull(directional_blocker))
		directional_blocker = new()

	density = FALSE

	directional_blocker.is_active = TRUE
	directional_blocker.blocks_entry = flip_dir
	directional_blocker.blocks_exit = flip_dir

	UpdateIcon()
	return flipped


/obj/cover/table/proc/pUnflip()
	if(!flipped)
		return

	flipped = FALSE
	src.cover_data.is_active = FALSE

	density = TRUE

	if(directional_blocker)
		directional_blocker.is_active = FALSE

	UpdateIcon()
	return flipped


/obj/cover/table/verb/Flip()
	set src in view(1)

	var/dist = get_dist(src, usr)
	if(dist < 1)
		return FALSE

	dir = get_dir(src, usr)
	var/result = pFlip(dir)
	return result


/obj/cover/table/verb/Unflip()
	set src in view(1)

	var/dist = get_dist(src, usr)
	if(dist < 1)
		return FALSE

	var/result = pUnflip()
	return result


/* Simple, non-powered door */
/obj/cover/door
	icon = 'icons/obj/doors/mineral_doors.dmi'
	icon_state = "wood"

	var/open = FALSE
	density = FALSE



/obj/cover/door/proc/UpdateOpen()
	density = (open ? FALSE : FALSE)
	opacity = (open ? FALSE : TRUE)
	icon_state = (open ? "woodopen" : "wood")

	if(directional_blocker)
		directional_blocker.is_active = (open ? FALSE : TRUE)

	return src


/obj/cover/door/GenerateCoverData()
	src.cover_data = ..()
	src.cover_data.is_active = (!open)
	src.cover_data.cover_all = TRUE
	return src.cover_data


/obj/cover/door/Setup()
	..()
	name = "[name] @ [COORDS_TUPLE(src)]"
	directional_blocker = new(null, null, TRUE, TRUE)
	UpdateOpen()


/obj/cover/door/proc/pOpen()
	open = TRUE
	UpdateOpen()
	return open


/obj/cover/door/verb/Open()
	set src in range(1)
	var/result = pOpen()
	return result


/obj/cover/door/proc/pClose()
	open = FALSE
	UpdateOpen()
	return !open


/* Automated, self-closing door */
/obj/cover/autodoor
	icon = 'icons/obj/doors/Door1.dmi'
	icon_state = "cdoor1"

	var/close_door_at = 0
	var/autoclose = TRUE
	var/autoclose_time = 50
	var/open = FALSE
	var/scheduled_reopen = FALSE

	var/start_screwed = FALSE
	var/start_welded = FALSE
	var/start_bolted = FALSE

	density = FALSE


/obj/cover/autodoor/proc/UpdateOpen()
	density = (open ? FALSE : FALSE)
	opacity = (open ? FALSE : TRUE)

	if(directional_blocker)
		directional_blocker.is_active = (open ? FALSE : TRUE)

	src.SetWorldstate("IsOpen", src.open)
	src.UpdateIcon()
	return src


/obj/cover/autodoor/UpdateIcon()
	icon_state = "cdoor1"

	var/screwed = src.GetWorldstateValue("screwed", FALSE)
	var/welded = src.GetWorldstateValue("welded", FALSE)
	var/bolted = src.GetWorldstateValue("bolted", FALSE)
	var/is_open = src.GetWorldstateValue("IsOpen", FALSE)

	if(is_open)
		icon_state = "codoor0"

	else if(bolted && screwed && welded)
		icon_state = "codoorl_locked"

	else if(bolted && welded)
		icon_state = "cdoorl_locked"

	else if(bolted && screwed)
		icon_state = "co_door_locked"

	else if(screwed && welded)
		icon_state = "co_doorl"

	else if(screwed)
		icon_state = "co_door1"

	else if(welded)
		icon_state = "cdoorl"

	else if(bolted)
		icon_state = "cdoor_locked"

	else
		icon_state = "cdoor1"

	return src


/obj/cover/autodoor/proc/Weld(var/atom/welder)
	/*
	if(isnull(welder))
		return FALSE
	*/
	var/welded = src.GetWorldstateValue("welded", FALSE)
	src.SetWorldstate("welded", !welded)
	src.UpdateIcon()
	return TRUE


/proc/WeldUsing(var/atom/target, var/atom/welder)
	if(isnull(target))
		return FALSE

	/*
	if(isnull(welder))
		return FALSE
	*/

	var/obj/cover/autodoor/AD = target
	if(istype(AD))
		AD.Weld(welder)
		return TRUE

	return FALSE


/obj/cover/autodoor/proc/Screw(var/atom/screwdriver)
	/*
	if(isnull(screwdriver))
		return FALSE
	*/
	var/screwed = src.GetWorldstateValue("screwed", FALSE)
	src.SetWorldstate("screwed", !screwed)
	src.UpdateIcon()

	return TRUE


/proc/ScrewUsing(var/atom/target, var/atom/screwdriver)
	if(isnull(target))
		return FALSE

	/*
	if(isnull(screwdriver))
		return FALSE
	*/

	var/obj/cover/autodoor/AD = target
	if(istype(AD))
		AD.Screw(screwdriver)
		return TRUE

	return FALSE


/proc/HackUsing(var/atom/target, var/atom/hacktool)
	if(isnull(target))
		return FALSE

	/*
	if(isnull(hacktool))
		return FALSE
	*/

	var/obj/cover/autodoor/AD = target
	if(istype(AD))
		AD.SetWorldstate("bolted", !AD.GetWorldstate("bolted", FALSE))
		return TRUE

	return FALSE


/obj/cover/autodoor/proc/NextCloseTime()
	var/curr_autoclose = close_door_at

	if(!curr_autoclose)
		curr_autoclose = world.time + autoclose_time
		close_door_at = curr_autoclose

	return curr_autoclose + autoclose_time


/obj/cover/autodoor/GenerateCoverData()
	src.cover_data = ..()
	src.cover_data.is_active = (!open)
	src.cover_data.cover_all = TRUE
	return src.cover_data


/obj/cover/autodoor/proc/ProcessTick()
	if(close_door_at && world.time >= close_door_at)
		if(autoclose)
			close_door_at = NextCloseTime()
			pClose()
		else
			close_door_at = 0


/obj/cover/autodoor/InitWorldstate()
	. = ..()

	src.worldstate["screwed"] = src.start_screwed
	src.worldstate["welded"] = src.start_welded
	src.worldstate["bolted"] = src.start_bolted

	return


/obj/cover/autodoor/Setup()
	..()
	name = "[name] @ [COORDS_TUPLE(src)]"
	directional_blocker = new(null, null, TRUE, TRUE)
	src.InitWorldstate()

	UpdateOpen()
	UpdateIcon()

	spawn(0)
		while(src)
			ProcessTick()
			sleep(autoclose_time / 4)


/obj/cover/autodoor/proc/pOpen()
	if(src.GetWorldstateValue("screwed")) return open
	if(src.GetWorldstateValue("welded"))  return open
	if(src.GetWorldstateValue("bolted"))  return open

	Toggle(FALSE)
	return open


/obj/cover/autodoor/proc/pClose()
	Toggle(TRUE)
	return !open


/obj/cover/autodoor/proc/Toggle(var/forced_state = null)
	var/is_open = (isnull(forced_state) ? open : forced_state)

	if(is_open)
		var/turf/my_loc = get_turf(src)
		if(my_loc)
			for(var/mob/M in my_loc.contents)
				if(M)
					close_door_at = NextCloseTime()
					return

	open = !is_open
	UpdateOpen()
	close_door_at = NextCloseTime()

	return open


/obj/cover/autodoor/verb/Open()
	set src in view(1)
	var/result = Toggle(TRUE)
	return result

# endif
