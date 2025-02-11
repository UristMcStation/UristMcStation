//Areas

/area/pod/start
	name = "\improper Escape Pod"
	icon_state = "shuttlered"
	requires_power = 1
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED
	base_turf = /turf/simulated/floor/plating/airless

/area/hatchling/start
	name = "\improper Hatchling"
	icon_state = "shuttlered"
	requires_power = 1
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/rescue/start
	name = "\improper Rescue Pod"
	icon_state = "shuttlered"
	requires_power = 1
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED

/obj/effect/overmap/visitable/ship/wyrm
	name = "ISC Wyrm"
	vessel_mass = 150
	fore_dir = WEST
	initial_generic_waypoints = list(
		"wyrm_prim_fore",
		"wyrm_prim_star",
		"wyrm_prim_port",
		"wyrm_prim_aft",
		"wyrm_sub_fore",
		"wyrm_sub_star",
		"wyrm_sub_port",
		"wyrm_sub_aft"
	)
	initial_restricted_waypoints = list(
		"Hatchling" = list("wyrm_docked_hatchling"),
		"Rescue Pod" = list("wyrm_docked_rescue")
	)

/obj/effect/shuttle_landmark/wyrm/primary/fore
	name = "Primary Deck - Fore"
	landmark_tag = "wyrm_prim_fore"

/obj/effect/shuttle_landmark/wyrm/primary/star
	name = "Primary Deck - Starboard"
	landmark_tag = "wyrm_prim_star"

/obj/effect/shuttle_landmark/wyrm/primary/port
	name = "Primary Deck - Portside"
	landmark_tag = "wyrm_prim_port"

/obj/effect/shuttle_landmark/wyrm/primary/aft
	name = "Primary Deck - Aft"
	landmark_tag = "wyrm_prim_aft"

/obj/effect/shuttle_landmark/wyrm/sub/fore
	name = "Sub Deck - Fore"
	landmark_tag = "wyrm_sub_fore"

/obj/effect/shuttle_landmark/wyrm/sub/star
	name = "Sub Deck - Starboard"
	landmark_tag = "wyrm_sub_star"

/obj/effect/shuttle_landmark/wyrm/sub/port
	name = "Sub Deck - Portside"
	landmark_tag = "wyrm_sub_port"

/obj/effect/shuttle_landmark/wyrm/sub/aft
	name = "Sub Deck - Aft"
	landmark_tag = "wyrm_sub_aft"

/obj/machinery/computer/shuttle_control/explore/hatchling
	name = "Hatchling Control Console"
	shuttle_tag = "Hatchling"

/obj/machinery/computer/shuttle_control/explore/lanius
	name = "Aura Control Console"
	shuttle_tag = "Aura"

/obj/machinery/computer/shuttle_control/explore/escape
	name = "Pod Control"
	shuttle_tag = "Escape Pod"

/obj/machinery/computer/shuttle_control/explore/rescue
	name = "Rescue Pod Control"
	shuttle_tag = "Rescue Pod"

/obj/machinery/computer/shuttle_control/explore/admin
	shuttle_tag = "CHANGE_ME"

/datum/shuttle/autodock/overmap/hatchling
	name = "Hatchling"
	move_time = 90
	shuttle_area = /area/hatchling/start
	dock_target = "hatchling_dock"
	current_location = "wyrm_docked_hatchling"
	landmark_transition = "nav_transit_hatchling"

/datum/shuttle/autodock/ferry/escape_pod/pod
	name = "Escape Pod"
	shuttle_area = /area/pod/start
	dock_target = "escape_pod"
	arming_controller = "escape_pod_berth"
	waypoint_station = "nav_docked_pod"
	landmark_transition = "nav_transit_pod"
	waypoint_offsite = "nav_escaped_pod"

/datum/shuttle/autodock/overmap/rescue
	name = "Rescue Pod"
	move_time = 30
	shuttle_area = /area/rescue/start
	current_location = "wyrm_docked_rescue"
	landmark_transition = "nav_transit_rescue"

/obj/effect/shuttle_landmark/pod/docked
	name = "Docking Port"
	landmark_tag = "nav_docked_pod"

/obj/effect/shuttle_landmark/wyrm/docked/hatchling
	name = "Docking Port"
	landmark_tag = "wyrm_docked_hatchling"
	docking_controller = "wyrm_docking_hatch"

/obj/effect/shuttle_landmark/wyrm/docked/rescue
	name = "Docking Port"
	landmark_tag = "wyrm_docked_rescue"

/obj/effect/shuttle_landmark/pod/transit
	name = "In transit"
	landmark_tag = "nav_transit_pod"

/obj/effect/shuttle_landmark/wyrm/transit/hatchling
	name = "In transit"
	landmark_tag = "nav_transit_hatchling"

/obj/effect/shuttle_landmark/wyrm/transit/lanius
	name = "In transit"
	landmark_tag = "nav_transit_lanius"

/obj/effect/shuttle_landmark/wyrm/transit/rescue
	name = "In transit"
	landmark_tag = "nav_transit_rescue"

/obj/effect/shuttle_landmark/pod/escaped
	name = "Escaped"
	landmark_tag = "nav_escaped_pod"

// completely 'normal' mining away

/obj/effect/overmap/visitable/cluster
	name = "asteroid cluster"
	desc = "Large group of asteroids. Mineral content detected."
	icon_state = "sector"
	initial_generic_waypoints = list(
		"nav_cluster_1"
	)

/obj/effect/shuttle_landmark/away
	base_area = /area/mine/explored

/obj/effect/shuttle_landmark/away/pod
	name = "Asteroid Navpoint #1"
	landmark_tag = "nav_cluster_1"

/obj/effect/overmap/visitable/random
	name = "unidentified signal"
	desc = "Unknown object detected. No further data avaliable."
	icon_state = "sector"
	initial_restricted_waypoints = list(
		"Hatchling" = list("random_away")
	)

/obj/effect/shuttle_landmark/random
	name = "Unknown Navpoint"
	landmark_tag = "random_away"

// illegal mining colony & maint drone takeover

/obj/effect/overmap/visitable/asteroid
	name = "mineral field"
	desc = "Mineral field detected."
	icon_state = "sector"
	initial_generic_waypoints = list(
		"asteroid_away"
	)

/obj/effect/shuttle_landmark/asteroid
	name = "Unknown Navpoint"
	landmark_tag = "asteroid_away"

// glloydstation jungle

/obj/effect/overmap/visitable/planet
	name = "rainforest exoplanet"
	desc = "Biological scans report non-manifest lifeforms."
	icon_state = "planet"
	initial_generic_waypoints = list(
		"planet_away"
	)

/obj/effect/shuttle_landmark/planet
	name = "Jungle Landing Site"
	landmark_tag = "planet_away"
	base_area = /area/planet/jungle/shuttle

// Diona takeover away

/obj/effect/shuttle_landmark/diona
	name = "Unknown Navpoint"
	landmark_tag = "diona_away"
	base_area = /area/away/dionaship
	base_turf = /turf/simulated/floor/diona

/obj/effect/overmap/visitable/diona
	name = "unknown biomass structure"
	desc = "Scans report unknown polymer materials in addition t- ERR: Malformed data packets received //SCN_DAT_END 0x00."
	initial_generic_waypoints = list(
		"diona_away"
	)

// 'Refueling' away

/area/away/refueling
	name = "\improper Refueling Station"

/obj/effect/shuttle_landmark/refueling
	name = "Docking Bay"
	landmark_tag = "docking_bay"
	base_area = /area/away/refueling
	base_turf = /turf/simulated/floor/plating

/obj/effect/overmap/visitable/refueling
	name = "refueling station"
	desc = ""
	initial_generic_waypoints = list(
		"docking_bay"
	)
