/obj/machinery/door/airlock/multi_tile/marine/infestation
	var/specialact = 0

/obj/machinery/door/airlock/multi_tile/marine/infestation/proc/lockup()
	if(locked == 0)
		locked = 1
		icon_state = "door_locked"

	else if(locked == 1)
		locked = 0
		icon_state = "door_closed"

