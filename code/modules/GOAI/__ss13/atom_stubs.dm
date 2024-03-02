# ifdef GOAI_LIBRARY_FEATURES

/atom/movable
	var/managed_movement = FALSE


/atom/movable/proc/DoMove(var/dir, var/mover, var/external = FALSE)
	var/turf/new_loc = get_step(src, dir)

	if(!istype(new_loc))
		return FALSE

	var/enterable = src.MayEnterTurf(new_loc)

	if(!enterable)
		return FALSE

	. = step(src, dir)
	return .


/atom/movable/proc/MayMove()
	. = (!src.managed_movement)
	return .


/atom/movable/proc/MayEnterTurf(var/turf/T, var/atom/From = null)
	var/turf/startpos = (From ? get_turf(From) : get_turf(src))
	if(!startpos)
		return FALSE

	if(T.density)
		return FALSE

	. = T?.Enter(src, startpos)

	return .

# endif
