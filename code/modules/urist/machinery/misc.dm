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
