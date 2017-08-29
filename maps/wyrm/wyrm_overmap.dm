//Areas

/area/pod/start
	name = "\improper Escape Pod"
	icon_state = "shuttlered"
	requires_power = 1
	dynamic_lighting = 1
	flags = AREA_RAD_SHIELDED

/area/hatchling/start
	name = "\improper Hatchling"
	icon_state = "shuttlered"
	requires_power = 1
	dynamic_lighting = 1
	flags = AREA_RAD_SHIELDED

/area/lanius/start
	name = "\improper Aura"
	icon_state = "shuttlered"
	requires_power = 1
	dynamic_lighting = 1
	flags = AREA_RAD_SHIELDED

/obj/effect/overmap/ship/wyrm
	name = "ISC Wyrm"
	vessel_mass = 150
	fore_dir = WEST
	generic_waypoints = list(
		"wyrm_prim_fore",
		"wyrm_prim_star",
		"wyrm_prim_port",
		"wyrm_prim_aft",
		"wyrm_sub_fore",
		"wyrm_sub_star",
		"wyrm_sub_port",
		"wyrm_sub_aft"
	)
	restricted_waypoints = list(
		"Hatchling" = list("wyrm_docked_hatchling")
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

/datum/shuttle/autodock/overmap/hatchling
	name = "Hatchling"
	move_time = 90
	shuttle_area = /area/hatchling/start
	dock_target = "hatchling_airlock"
	current_location = "wyrm_docked_hatchling"
	landmark_transition = "nav_transit_hatchling"

/datum/shuttle/autodock/overmap/lanius
	name = "Aura"
	move_time = 40
	shuttle_area = /area/lanius/start
	current_location = "contact_light_lanius"
	landmark_transition = "nav_transit_lanius"

/datum/shuttle/autodock/ferry/escape_pod/pod
	name = "Escape Pod"
	shuttle_area = /area/pod/start
	dock_target = "escape_pod"
	arming_controller = "escape_pod_berth"
	waypoint_station = "nav_docked_pod"
	landmark_transition = "nav_transit_pod"
	waypoint_offsite = "nav_escaped_pod"

/obj/effect/shuttle_landmark/pod/docked
	name = "Docking Port"
	landmark_tag = "nav_docked_pod"

/obj/effect/shuttle_landmark/wyrm/docked/hatchling
	name = "Docking Port"
	landmark_tag = "wyrm_docked_hatchling"

/obj/effect/shuttle_landmark/pod/transit
	name = "In transit"
	landmark_tag = "nav_transit_pod"

/obj/effect/shuttle_landmark/wyrm/transit/hatchling
	name = "In transit"
	landmark_tag = "nav_transit_hatchling"

/obj/effect/shuttle_landmark/wyrm/transit/lanius
	name = "In transit"
	landmark_tag = "nav_transit_lanius"

/obj/effect/shuttle_landmark/pod/escaped
	name = "Escaped"
	landmark_tag = "nav_escaped_pod"

/obj/effect/overmap/sector/cluster
	name = "asteroid cluster"
	desc = "Large group of asteroids. Mineral content detected."
	icon_state = "sector"
	generic_waypoints = list(
		"nav_cluster_1"
	)

/obj/effect/shuttle_landmark/away
	base_area = /area/mine/explored

/obj/effect/shuttle_landmark/away/pod
	name = "Asteroid Navpoint #1"
	landmark_tag = "nav_cluster_1"

/obj/effect/overmap/sector/random
	name = "unidentified signal"
	desc = "Unknown object detected. No further data avaliable."
	icon_state = "sector"
	restricted_waypoints = list(
		"Hatchling" = list("random_away")
	)

/obj/effect/shuttle_landmark/random
	name = "Unknown Navpoint"
	landmark_tag = "random_away"

/obj/effect/overmap/sector/distress
	name = "distress signal"
	desc = "Emergency signal detected. No further data avaliable."
	icon_state = "event"
	restricted_waypoints = list(
		"Hatchling" = list("distress_signal"),
		"Aura" = list("contact_light_lanius")
	)

/obj/effect/shuttle_landmark/distress
	name = "Unknown Navpoint"
	landmark_tag = "distress_signal"

/obj/effect/shuttle_landmark/contact_light_lanius
	name = "Unknown Navpoint"
	landmark_tag = "contact_light_lanius"

/obj/effect/overmap/sector/asteroid
	name = "mineral field"
	desc = "Mineral field detected."
	icon_state = "sector"
	generic_waypoints = list(
		"asteroid_away"
	)

/obj/effect/shuttle_landmark/asteroid
	name = "Unknown Navpoint"
	landmark_tag = "asteroid_away"

/obj/effect/overmap/sector/planet
	name = "Rainforest Exoplanet"
	desc = "Biological scans report non-manifest lifeforms."
	icon_state = "planet"
	generic_waypoints = list(
		"planet_away"
	)

/obj/effect/shuttle_landmark/planet
	name = "Jungle Landing Site"
	landmark_tag = "planet_away"
	base_area = /area/jungle/shuttle