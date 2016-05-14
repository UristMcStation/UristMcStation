/obj/machinery/camera/emp_proof/engine
	network = list(NETWORK_ENGINE)

/obj/machinery/mass_driver/sm_launcher
	name = "gravity driver"
	desc = "A special mass driver keyed to launch the supermatter when ejected."


/obj/machinery/mass_driver/sm_launcher/Crossed(O as obj)
	..()
	if(istype(O, /obj/machinery/power/supermatter))
		sleep(25) //so the sm can land
		drive()

/obj/machinery/door/airlock/multi_tile/security
	name = "Security Airlock"
	icon = 'icons/urist/structures&machinery/doors/Door2x1security.dmi'
	opacity = 0
	glass = 1


/obj/machinery/door/airlock/multi_tile/command
	name = "Command Airlock"
	icon = 'icons/urist/structures&machinery/doors/Door2x1command.dmi'
	opacity = 0
	glass = 1

/obj/machinery/door/airlock/multi_tile/medical
	name = "Medical Airlock"
	icon = 'icons/urist/structures&machinery/doors/Door2x1medbay.dmi'
	opacity = 0
	glass = 1

/obj/machinery/door/airlock/multi_tile/engineering
	name = "Engineering Airlock"
	icon = 'icons/urist/structures&machinery/doors/Door2x1engine.dmi'
	opacity = 0
	glass = 1


/obj/machinery/door/airlock/multi_tile/research
	name = "Research Airlock"
	icon = 'icons/urist/structures&machinery/doors/Door2x1research.dmi'
	opacity = 0
	glass = 1