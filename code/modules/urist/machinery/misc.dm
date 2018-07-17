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