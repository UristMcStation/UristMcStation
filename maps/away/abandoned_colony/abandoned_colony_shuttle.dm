/datum/shuttle/autodock/overmap/morninglight
	name = "ICS Morning Light"
	warmup_time = 15
	move_time = 50
	shuttle_area = list(/area/morninglight/cargo, /area/morninglight/main, /area/morninglight/engineering, /area/morninglight/atmos, /area/morninglight/entrance, /area/morninglight/dorms)
	current_location = "nav_morninglight"
	landmark_transition = "nav_morninglight_transit"
	dock_target = "morninglight_shuttle"
//	fuel_consumption = 1.2
	defer_initialisation = TRUE

/obj/shuttle_landmark/nav_abandoned_colony/morninglight
	name = "Morning Light Hangar"
	landmark_tag = "nav_morninglight"
	base_area = /area/planet/abandoned_colony
	base_turf = /turf/simulated/floor/reinforced

/obj/shuttle_landmark/nav_abandoned_colony/morninglight_transit
	name = "In transit"
	landmark_tag = "nav_morninglight_transit"

/obj/machinery/computer/shuttle_control/explore/morninglight
	name = "ICS Morning Light control console"
	shuttle_tag = "ICS Morning Light"

/obj/overmap/visitable/ship/landable/morninglight
	name = "ICS Morning Light"
	shuttle = "ICS Morning Light"
	fore_dir = EAST
	vessel_mass = 850
	vessel_size = SHIP_SIZE_SMALL

/area/morninglight
	name = "\improper ICS Morning Light"
	icon_state = "shuttle"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/morninglight/cargo
	name = "\improper ICS Morning Light - Cargo"

/area/morninglight/main
	name = "\improper ICS Morning Light - Main Compartment"

/area/morninglight/engineering
	name = "\improper ICS Morning Light - Engineering"

/area/morninglight/atmos
	name = "\improper ICS Morning Light - Atmospherics"

/area/morninglight/entrance
	name = "\improper ICS Morning Light - Entrance"

/area/morninglight/dorms
	name = "\improper ICS Morning Light - Dorms"
