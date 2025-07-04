/* Simple object type, calls a proc when "stepped" on by something */

/obj/step_trigger
	var/affect_ghosts = 0
	var/stopper = 1 // stops throwers
	invisibility = INVISIBILITY_ABSTRACT // nope cant see this shit
	anchored = TRUE

/obj/step_trigger/proc/Trigger(atom/movable/A)
	return 0

/obj/step_trigger/Crossed(H as mob|obj)
	..()
	if(!H)
		return
	if(isobserver(H) && !(isghost(H) && affect_ghosts))
		return
	Trigger(H)



/* Tosses things in a certain direction */

/datum/movement_handler/no_move/toss

/obj/step_trigger/thrower
	var/direction = SOUTH // the direction of throw
	var/tiles = 3	// if 0: forever until atom hits a stopper
	var/immobilize = 1 // if nonzero: prevents mobs from moving while they're being flung
	var/speed = 1	// delay of movement
	var/facedir = 0 // if 1: atom faces the direction of movement
	var/nostop = 0 // if 1: will only be stopped by teleporters
	var/list/affecting = list()

/obj/step_trigger/thrower/Trigger(atom/movable/AM)
	if(!AM || !istype(AM) || !AM.simulated)
		return
	var/curtiles = 0
	var/stopthrow = 0
	for(var/obj/step_trigger/thrower/T in orange(2, src))
		if(AM in T.affecting)
			return

	if(ismob(AM))
		var/mob/M = AM
		if(immobilize)
			M.AddMovementHandler(/datum/movement_handler/no_move/toss)

	affecting.Add(AM)
	while(AM && !stopthrow)
		if(tiles)
			if(curtiles >= tiles)
				break
		if(AM.z != src.z)
			break

		curtiles++

		sleep(speed)

		// Calculate if we should stop the process
		if(!nostop)
			for(var/obj/step_trigger/T in get_step(AM, direction))
				if(T.stopper && T != src)
					stopthrow = 1
		else
			for(var/obj/step_trigger/teleporter/T in get_step(AM, direction))
				if(T.stopper)
					stopthrow = 1

		if(AM)
			var/predir = AM.dir
			step(AM, direction)
			if(!facedir)
				AM.set_dir(predir)



	affecting.Remove(AM)

	if(ismob(AM))
		var/mob/M = AM
		if(immobilize)
			M.RemoveMovementHandler(/datum/movement_handler/no_move/toss)

/* Stops things thrown by a thrower, doesn't do anything */

/obj/step_trigger/stopper

/* Instant teleporter */

/obj/step_trigger/teleporter
	var/teleport_x = 0	// teleportation coordinates (if one is null, then no teleport!)
	var/teleport_y = 0
	var/teleport_z = 0

/obj/step_trigger/teleporter/Trigger(atom/movable/A)
	if(teleport_x && teleport_y && teleport_z)

		A.x = teleport_x
		A.y = teleport_y
		A.z = teleport_z

/* Random teleporter, teleports atoms to locations ranging from teleport_x - teleport_x_offset, etc */

/obj/step_trigger/teleporter/random
	opacity = 1
	var/teleport_x_offset = 0
	var/teleport_y_offset = 0
	var/teleport_z_offset = 0

/obj/step_trigger/teleporter/random/Trigger(atom/movable/A)
	var/turf/T = locate(rand(teleport_x, teleport_x_offset), rand(teleport_y, teleport_y_offset), rand(teleport_z, teleport_z_offset))
	if(T)
		A.forceMove(T)

/* Radio Trap */

/obj/step_trigger/radio
	var/freq
	var/filter
	var/list/newdata

	var/datum/radio_frequency/radio_connection

/obj/step_trigger/radio/Initialize()
	. = ..()
	if(!freq || !filter)
		return INITIALIZE_HINT_QDEL
	radio_connection = radio_controller.add_object(src, freq, filter)

/obj/step_trigger/radio/Trigger(atom/movable/A)
	var/datum/signal/S = new
	S.data = newdata
	radio_connection.post_signal(src, S, filter)
