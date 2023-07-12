/*
/obj/machinery/computer/shuttle_control/arrivals
	name = "arrival shuttle console"
	shuttle_tag = "Arrivals"
	//req_access =
	//circuit = /obj/item/stock_parts/circuitboard

/datum/shuttle/ferry/arrivals
	name = "Arrivals"
	location = 1
	warmup_time = 10
	area_offsite = /area/shuttle/arrivals/centcom
	area_station = /area/shuttle/arrivals/station
	area_transition = /area/shuttle/arrivals/transit
	docking_controller_tag = "arrival_shuttle"
	dock_target_station = "station_arrival_dock"
	dock_target_offsite = "centcom_arrival_dock"
	transit_direction = WEST
	move_time = 10

/datum/shuttle/ferry/arrivals/proc/AnnounceArrival()
	if (ticker.current_state == GAME_STATE_PLAYING)
		var/obj/item/device/radio/intercom/a = new /obj/item/device/radio/intercom(null)
		a.autosay("The Arrivals Shuttle has docked with the Station.", "Arrivals Announcement Computer")
		qdel(a)


/datum/shuttle/ferry/arrivals/arrived()
	if(location == 0)
		AnnounceArrival()
		sleep(200) //20 seconds give or take some lag.
		launch()

	return
*/
