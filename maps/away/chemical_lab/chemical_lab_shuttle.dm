
/datum/shuttle/autodock/overmap/vulture
	name = "Vulture"
	warmup_time = 10
	move_time = 60
	shuttle_area = /area/ship/chemical_lab/vulture
	current_location = "nav_vulture_dock"
	landmark_transition = "nav_vulture_transit"
	dock_target = "vulture_shuttle"
	fuel_consumption = 0.5
	range = 1
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/nav_chemical_lab/vulture
	name = "Vulture Dock"
	landmark_tag = "nav_vulture_dock"
	docking_controller = "cargo"
	base_area = /area/space
	base_turf = /turf/space

/obj/effect/shuttle_landmark/nav_vulture/vulture_transit
	name = "In transit"
	landmark_tag = "nav_vulture_transit"

/obj/machinery/computer/shuttle_control/explore/vulture
	name = "vulture control console"
	shuttle_tag = "Vulture"

/area/ship/chemical_lab/vulture
	name = "\improper Vulture"
	icon_state = "shuttle"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
