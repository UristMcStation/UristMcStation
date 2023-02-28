/obj/machinery/mass_driver/sm_launcher
	name = "gravity driver"
	desc = "A special mass driver keyed to launch the supermatter when ejected."


/obj/machinery/mass_driver/sm_launcher/Crossed(O as obj)
	..()
	if(istype(O, /obj/machinery/power/supermatter))
		sleep(25) //so the sm can land
		drive()

/obj/machinery/door/airlock/multi_tile/ror
	name = "Rusted Airlock"
	icon = 'maps/wyrm/icons/awaymission.dmi'
	layer = ABOVE_HUMAN_LAYER
	plane = ABOVE_HUMAN_PLANE
	width = 2

/obj/structure/curtain/var/id = null

/obj/machinery/button/remote/curtains
	name = "remote curtains-control"
	desc = "It controls curtains, remotely."

/obj/machinery/button/remote/curtains/trigger()
	for(var/obj/structure/curtain/D in world)
		if(D.id == src.id)
			D.toggle()

//old comp sprite stuff
/obj/machinery/computer/rdconsole/old
	name = "research computer"
	desc = "A stationary computer."
	icon = 'icons/urist/structures&machinery/machinery.dmi'
	icon_state = "1980_computer_on"

/obj/machinery/computer/cloning/old
	name = "cloning computer"
	desc = "A large computer."
	icon = 'icons/urist/structures&machinery/machinery.dmi'
	icon_state = "research_on"

//wood ladder sprite
/obj/structure/stairs/west
	dir = WEST
	bound_width = 64

/obj/structure/stairs/wood
	icon = 'icons/urist/structures&machinery/civStairs.dmi'
	icon_state = "wood2_stairs"

/obj/structure/ladder/wood
//	allowed_directions = DOWN
	icon = 'icons/urist/structures&machinery/civStairs.dmi'
	icon_state = "hole_top"

/obj/structure/ladder/up/wood
//	allowed_directions = UP
	icon = 'icons/urist/structures&machinery/civStairs.dmi'
	icon_state = "hole_bottom"

/obj/structure/ladder/updown/wood
//	allowed_directions = UP|DOWN
	icon = 'icons/urist/structures&machinery/civStairs.dmi'
	icon_state = "hole_updown"

