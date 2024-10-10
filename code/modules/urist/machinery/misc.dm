/obj/machinery/door/airlock/multi_tile/ror
	name = "Rusted Airlock"
	icon = 'maps/wyrm/icons/awaymission.dmi'
	layer = ABOVE_HUMAN_LAYER
//	plane = ABOVE_HUMAN_LAYER
	width = 2

/obj/structure/curtain/var/id = null

/obj/machinery/button/remote/curtains
	name = "remote curtains-control"
	desc = "It controls curtains, remotely."

/obj/machinery/button/remote/curtains/activate()
	for(var/obj/structure/curtain/D in world)
		if(D.id == src.id_tag)
			D.toggle()

//old comp sprite stuff
/obj/machinery/computer/rdconsole/old
	name = "research computer"
	desc = "A stationary computer."
	icon = 'icons/urist/structures&machinery/machinery.dmi'
	icon_state = "1980_computer_on"

/obj/structure/stairs/wood
	icon = 'icons/urist/structures&machinery/civStairs.dmi'
	icon_state = "wood2_stairs"
