# ifdef GOAI_LIBRARY_FEATURES


/atom/movable/proc/DoMove(var/dir, var/mover, var/external = FALSE)
	var/turf/curr_loc = get_turf(src)
	var/turf/new_loc = get_step(src, dir)

	if(!istype(new_loc))
		return FALSE

	var/enterable = src.MayEnterTurf(new_loc, curr_loc, FALSE)

	if(!enterable && new_loc.IsBlocked(TRUE, TRUE))
		return FALSE

	. = step(src, dir)
	return .


/atom/movable/proc/MayMove()
	. = (!src.managed_movement)
	return .


/atom/movable/proc/MayEnterTurf(var/turf/T, var/atom/From = null, var/check_blocked = TRUE)
	if(!istype(T))
		return FALSE

	if(T.IsBlocked(TRUE, FALSE))
		return FALSE

	var/turf/startpos = (From ? get_turf(From) : null)

	if(isnull(startpos))
		// Assume we're going there in a straight line
		var/prevstep = get_dir(T, src)
		var/turf/prevturf = get_step(T, prevstep)
		if(!isnull(prevturf))
			startpos = prevturf

	if(!startpos)
		return FALSE

	. = T?.Enter(src, startpos)

	return .

# endif
