/datum/shuttle/autodock/overmap/damselfly
	name = "Damselfly"
	warmup_time = 15
	move_time = 60
	shuttle_area = /area/ship/scrap/damselfly
	current_location = "nav_bearcat_dock"
	landmark_transition = "nav_bearcat_transit"
	dock_target = "bearcat_shuttle"
	fuel_consumption = 0.5//it's small
	range = 1
	defer_initialisation = TRUE

/obj/shuttle_landmark/nav_bearcat/damselfly
	name = "Damselfly Dock"
	landmark_tag = "nav_bearcat_dock"
	docking_controller = "cargo"
	base_area = /area/space
	base_turf = /turf/space

/obj/shuttle_landmark/nav_bearcat/damselfly_transit
	name = "In transit"
	landmark_tag = "nav_bearcat_transit"

/obj/machinery/computer/shuttle_control/explore/damselfly
	name = "damselfly control console"
	shuttle_tag = "Damselfly"

/area/ship/scrap/damselfly
	name = "\improper Damselfly"
	icon_state = "shuttle"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
