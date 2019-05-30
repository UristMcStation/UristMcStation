/datum/shuttle/autodock/overmap/raptor
	name = "Raptor"
	warmup_time = 20
	move_time = 45
	shuttle_area = /area/noctis/raptor
	current_location = "nav_noctis_raptor"
	landmark_transition = "nav_noctis_transit"
	dock_target = "noctis"
	fuel_consumption = 1.2
	range = 3
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/nav_noctis/raptor
	name = "Raptor Hangar"
	landmark_tag = "nav_noctis_raptor"
	base_area = /area/noctis/hangar
	base_turf = /turf/simulated/floor/reinforced

/obj/effect/shuttle_landmark/nav_noctis/raptor_transit
	name = "In transit"
	landmark_tag = "nav_noctis_transit"

/obj/machinery/computer/shuttle_control/explore/raptor
	name = "raptor control console"
	shuttle_tag = "Raptor"

/area/noctis/raptor
	name = "\improper Raptor"
	icon_state = "shuttle"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED