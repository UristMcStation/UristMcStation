//stuff that doesn't go anywhere else.

/obj/effect/stop/Uncross(atom/movable/O)
	if(victim == O)
		return 0
	return 1

/var/global/respawntime = 12000 //default 20 mins, adding the var so we can change it for different roundtypes. gotta keep the action rollin'