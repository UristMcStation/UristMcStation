/datum/goai/mob_commander
	name = "mob commander"

	var/atom/movable/pawn
	var/datum/ActivePathTracker/active_path

	var/is_repathing = 0
	var/is_moving = 0