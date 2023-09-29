/datum/shuttle/autodock/ferry/freight
	name = "Freight Elevator"
	shuttle_area = /area/logistics/freight
	warmup_time = 3	//give those below some time to get out of the way
	waypoint_station = "nav_wyrm_lift_top"
	waypoint_offsite = "nav_wyrm_lift_bottom"
	sound_takeoff = 'sound/effects/lift_heavy_start.ogg'
	sound_landing = 'sound/effects/lift_heavy_stop.ogg'
	ceiling_type = null
	knockdown = 0

/obj/machinery/computer/shuttle_control/lift
	name = "freight elevator controls"
	shuttle_tag = "Freight Elevator"
	ui_template = "shuttle_control_console_lift.tmpl"
	icon_state = "tiny"
	icon_keyboard = "tiny_keyboard"
	icon_screen = "lift"
	density = FALSE

/area/logistics/freight
	name = "Freight Elevator"
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/freight/top
	name = "Top Deck"
	landmark_tag = "nav_wyrm_lift_top"
	flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/freight/bottom
	name = "Lower Deck"
	landmark_tag = "nav_wyrm_lift_bottom"
	base_area = /area/logistics/loading
	base_turf = /turf/simulated/floor/plating
/datum/shuttle/autodock/ferry/supply/drone
	name = "Supply Drone"
	location = 1
	warmup_time = 10
	shuttle_area = /area/supply/dock
	waypoint_offsite = "nav_cargo_start"
	waypoint_station = "nav_cargo_station"

/obj/effect/shuttle_landmark/supply/centcom
	name = "IMS Hecate"
	landmark_tag = "nav_cargo_start"

/obj/effect/shuttle_landmark/supply/station
	name = "Hangar"
	landmark_tag = "nav_cargo_station"
	base_area = /area/supply/external
	base_turf = /turf/simulated/floor/reinforced

/area/pod/start
	name = "\improper Escape Pod"
	icon_state = "shuttlered"
	area_flags = AREA_FLAG_RAD_SHIELDED
