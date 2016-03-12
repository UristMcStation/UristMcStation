//stuff that doesn't go anywhere else.

/obj/effect/stop/Uncross(atom/movable/O)
	if(victim == O)
		return 0
	return 1