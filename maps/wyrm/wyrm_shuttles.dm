/area/turbolift
	name = "\improper Turbolift"
	icon_state = "shuttle"
	requires_power = 0
	dynamic_lighting = 1
	flags = AREA_RAD_SHIELDED

/area/turbolift/freightmain
	name = "Main Deck"
	base_turf = /turf/simulated/open

/area/turbolift/freightsub
	name = "Sub Deck"
	base_turf = /turf/simulated/floor/plating

/datum/shuttle/autodock/ferry/supply/drone
	name = "Supply Drone"
	location = 1
	warmup_time = 10
	shuttle_area = /area/supply/dock
	waypoint_offsite = "nav_cargo_start"
	waypoint_station = "nav_cargo_station"

/obj/effect/shuttle_landmark/supply/centcom
	name = "Centcom"
	landmark_tag = "nav_cargo_start"

/obj/effect/shuttle_landmark/supply/station
	name = "Hangar"
	landmark_tag = "nav_cargo_station"
	base_area = /area/logistics/loading
	base_turf = /turf/simulated/floor/reinforced