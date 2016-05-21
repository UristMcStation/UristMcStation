/datum/shuttle/ferry/infestation/arrived()
	if(location == 1)
		for(var/obj/machinery/door/airlock/multi_tile/marine/infestation/I in machines)
			I.lockup()

/obj/machinery/computer/shuttle_control/infestation/i1
	name = "ANFOR shuttle console"
	shuttle_tag = "Infestation1"

/obj/machinery/computer/shuttle_control/infestation/i2
	name = "ANFOR shuttle console"
	shuttle_tag = "Infestation2"

