// faking stairs/ladders

# ifdef GOAI_LIBRARY_FEATURES

/turf/simulated/open
	icon = 'icons/turf/snow.dmi'
	icon_state = "dimsnow"
	pathweight = 10


/turf/simulated/open/proc/GetBelow()
	var/new_z = max(1, src.z - 1)
	var/turf/below = locate(src.x, src.y, new_z)
	return below


/turf/simulated/open/Enter(var/atom/movable/O, var/atom/oldloc)
	if(get_dist(O, src) > 1)
		return ..()

	var/turf/below = src.GetBelow()

	if(!below)
		return 0

	O.Move(below)
	return 1


/* LADDERS */
/obj/structure/ladder
	icon = 'icons/obj/structures.dmi'
	icon_state = "ladder11"
	density = FALSE
	opacity = FALSE

	var/base_icon_state = "ladder"

	var/atom/above = null
	var/atom/below = null


/obj/structure/ladder/proc/UpdateIconstate()
	var/_base_icon_state = isnull(src.base_icon_state) ? "ladder" : src.base_icon_state
	var/has_above = isnull(src.above) ? FALSE : TRUE
	var/has_below = isnull(src.below) ? FALSE : TRUE

	icon_state = "[_base_icon_state][has_above][has_below]"
	return icon_state


/obj/structure/ladder/New()
	src.UpdateIconstate()


/obj/structure/ladder/proc/ClimbNow(var/atom/movable/climber, var/preferred_dir = null)
	// core climbing logic, no timers or other nonsense
	if(!istype(climber))
		return

	if(!(above || below))
		return

	if(get_dist(climber, src) > 1)
		return

	var/climbdir = null

	var/turf/upturf = above ? get_turf(above) : null
	var/turf/downturf = below ? get_turf(below) : null

	if(!(upturf && downturf))
		if(above)
			climbdir = UP
		else if(below)
			climbdir = DOWN
		else
			return

	else
		climbdir = preferred_dir ? preferred_dir : UP

	switch(climbdir)
		if(UP) . = climber.Move(upturf)
		if(DOWN) . = climber.Move(downturf)

	return


/obj/structure/ladder/verb/Climb()
	set src in view(1)

	src.ClimbNow(usr)


/* STAIRS */
/obj/structure/stairs
	icon = 'icons/obj/structures.dmi'
	icon_state = "rampbottom"
	density = FALSE
	opacity = FALSE

	// where do we go from here (above; below is handled by Open turfs)
	var/turf/above = null


/obj/structure/stairs/proc/UpdateIconstate()
	var/new_icon_state = "rampbottom"
	if(src.above && (src.above.z <= src.z))
		new_icon_state = "ramptop"

	src.icon_state = new_icon_state
	return new_icon_state


/obj/structure/stairs/Cross(var/atom/movable/A)
	if(get_dist(A, src) > 1)
		return ..()

	if(A && A.z == src.z)
		if(src.above)
			. = 1
			spawn(0.5)
				if(A in src.loc)
					A.Move(src.above)
			return .

	return ..()

# endif
