/obj/machinery/disease2/attackby(var/obj/O as obj, var/mob/user as mob)
	if(default_deconstruction_crowbar(user, O))
		return
	else if(default_deconstruction_screwdriver(user, O))
		return
	else if(default_part_replacement(user,O))
		return
	. = ..()