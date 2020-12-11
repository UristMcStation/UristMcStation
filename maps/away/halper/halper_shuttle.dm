// Halper Shuttle

/datum/shuttle/autodock/overmap/valley
	name = "Valley"
	warmup_time = 15
	move_time = 60
	shuttle_area = /area/ship/scrap/valley
	current_location = "nav_halper_dock"
	landmark_transition = "nav_halper_transit"
	dock_target = "valley"
	fuel_consumption = 0.5
	range = 1
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/nav_halper/valley
	name = "Valley Dock"
	landmark_tag = "nav_halper_dock"
	base_area = /area/space
	base_turf = /turf/space

/obj/effect/shuttle_landmark/nav_halper/valley_transit
	name = "In transit"
	landmark_tag = "nav_halper_transit"

/obj/machinery/computer/shuttle_control/explore/valley
	name = "valley control console"
	shuttle_tag = "Valley"

/area/ship/scrap/valley
	name = "\improper Valley"
	icon_state = "shuttle"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED