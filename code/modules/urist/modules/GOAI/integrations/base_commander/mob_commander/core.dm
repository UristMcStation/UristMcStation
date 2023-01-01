/datum/goai/mob_commander
	name = "mob commander"

	var/weakref/pawn_ref
	var/datum/ActivePathTracker/active_path

	var/is_repathing = 0
	var/is_moving = 0


/datum/goai/mob_commander/proc/GetPawn()
	var/atom/movable/mypawn = pawn_ref?.resolve()
	return mypawn
