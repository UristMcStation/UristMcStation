/obj/machinery/computer/shuttle_control/arrivals
	name = "arrival shuttle console"
	shuttle_tag = "Arrival"
	//req_access =
	//circuit = /obj/item/weapon/circuitboard/

/datum/shuttle/ferry/arrival

/datum/shuttle/ferry/proc/AnnounceArrival()
	if (ticker.current_state == GAME_STATE_PLAYING)
		var/obj/item/device/radio/intercom/a = new /obj/item/device/radio/intercom(null)
		a.autosay("The Arrivals Shuttle has docked with the Station.", "Arrivals Announcement Computer")
		qdel(a)


/datum/shuttle/ferry/arrival/arrived()
	if(location == 0)
		AnnounceArrival()
		sleep(200) //20 seconds give or take some lag.
		launch()

	return