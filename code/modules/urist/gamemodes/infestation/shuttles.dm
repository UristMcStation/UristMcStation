/datum/shuttle/ferry/infestation
	category = /datum/shuttle/ferry/infestation

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

/datum/shuttle/ferry/infestation/i1
	name = "Infestation 1"
	location = 0
	warmup_time = 20
	area_offsite = /area/shuttle/infestation/i1/station
	area_station = /area/shuttle/infestation/i1/ship
	transit_direction = EAST

/datum/shuttle/ferry/infestation/i2
	name = "Infestation 2"
	location = 0
	warmup_time = 20
	area_offsite = /area/shuttle/infestation/i2/station
	area_station = /area/shuttle/infestation/i2/ship
	transit_direction = EAST