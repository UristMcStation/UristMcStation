/datum/goai/mob_commander
	name = "mob commander"

	# ifdef GOAI_LIBRARY_FEATURES
	var/atom/pawn
	# endif

	# ifdef GOAI_SS13_SUPPORT
	var/weakref/pawn_ref
	# endif

	var/datum/ActivePathTracker/active_path

	var/is_repathing = 0
	var/is_moving = 0


/datum/goai/mob_commander/proc/GetPawn()
	var/atom/movable/mypawn = null

	# ifdef GOAI_LIBRARY_FEATURES
	mypawn = (mypawn || src.pawn)
	# endif

	# ifdef GOAI_SS13_SUPPORT
	mypawn = (mypawn || (pawn_ref?.resolve()))
	# endif

	return mypawn
