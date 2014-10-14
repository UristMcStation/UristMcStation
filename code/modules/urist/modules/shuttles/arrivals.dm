/obj/machinery/computer/shuttle_control/arrivals
	name = "arrival shuttle console"
	shuttle_tag = "Arrival"
	//req_access =
	//circuit = /obj/item/weapon/circuitboard/

/datum/shuttle/ferry/arrival

/datum/shuttle/ferry/proc/AnnounceArrival()
	if (ticker.current_state == GAME_STATE_PLAYING)
		var/obj/item/device/radio/intercom/a = new /obj/item/device/radio/intercom(null)// BS12 EDIT Arrivals Announcement Computer, rather than the AI.
		a.autosay("The Arrivals Shuttle has docked with the Station", "Arrivals Announcement Computer")
		del(a)


/datum/shuttle/ferry/arrival/arrived()
	AnnounceArrival()
	return

/*/datum/shuttle/ferry/arrival/long_jump(var/area/departing, var/area/destination, var/area/interim, var/travel_time, var/direction)
	world << "shuttle/ferry/arrival/long_jump: departing=[departing], destination=[destination], interim=[interim], travel_time=[travel_time]"
	travel_time = move_time
	..()*/
