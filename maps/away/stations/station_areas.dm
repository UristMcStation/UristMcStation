/area/spacestations
	icon_state = "blueold"

/area/spacestations/nanotrasenspace
	name = "NanoTrasen Space Station"

//access

var/global/const/access_away_trading_station = "ACCESS_AWAY_TRADING_STATION"
/datum/access/away_trading_station
	id = access_away_trading_station
	desc = "Trading Station"
	access_type = ACCESS_TYPE_NONE
	region = ACCESS_REGION_NONE

//mining shuttle stuff

/area/spacestations/ntminingshuttle
	name = "Nanotrasen Mining Shuttle"
	icon_state = "shuttle"
	requires_power = 0
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/spacestations/ntminingshuttle/start
	name = "\improper Mining Shuttle"
	icon_state = "shuttle"

/datum/shuttle/autodock/ferry/ntminingshuttle
	name = "Nanotrasen Mining"
	warmup_time = 1 SECOND
	shuttle_area = /area/spacestations/ntminingshuttle/start
	waypoint_station = "nav_ntmining_start"
	waypoint_offsite = "nav_ntmining_end"
	defer_initialisation = TRUE

/datum/shuttle/autodock/ferry/ntminingshuttle/New()
	if(GLOB.using_map.name != "Nerva")
		location = 1
	. = ..()

/obj/machinery/computer/shuttle_control/ntminingshuttle
	name = "mining shuttle console"
	shuttle_tag = "Nanotrasen Mining"

/obj/shuttle_landmark/ntminingshuttle
	name = "NT Mining Shuttle Landing Zone"
	landmark_tag = "nav_ntmining_end"

/obj/shuttle_landmark/ntminingshuttle/start
	name = "Mining Shuttle Dock"
	landmark_tag = "nav_ntmining_start"
	docking_controller = "ntminingshuttle"
	base_turf = /turf/simulated/floor/plating
