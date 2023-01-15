# ifdef GOAI_LIBRARY_FEATURES

/atom/movable/proc/DoMove(var/dir, var/mover, var/external = FALSE)
	. = step(src, dir)
	return .


/atom/movable/proc/MayMove()
	. = TRUE
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
