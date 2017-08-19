//Areas

/area/pod/start
	name = "\improper General Use Pod"
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

/obj/effect/overmap/ship/wyrm
	name = "ISC Wyrm"
	vessel_mass = 150
	fore_dir = WEST

	restricted_waypoints = list(
		"Hatchling" = list("wyrm_docked_hatchling"),
		"Pod" = list("wyrm_docked_pod")
	)

/obj/effect/overmap/ship/subship/hatchling
	name = "Hatchling"
	vessel_mass = 10
	fore_dir = WEST
	owner_type = /obj/effect/overmap/ship/wyrm

/obj/machinery/computer/helm/subship/hatchling
	name = "Hatchling Sublight Control"
	subship = "Hatchling"

/obj/machinery/computer/shuttle_control/explore/hatchling
	name = "Hatchling Control Console"
	shuttle_tag = "Hatchling"

/obj/machinery/computer/shuttle_control/explore/escape
	name = "Pod Control"
	shuttle_tag = "Pod"

/datum/shuttle/autodock/overmap/hatchling
	name = "Hatchling"
	move_time = 90
	shuttle_area = /area/hatchling/start
	current_location = "wyrm_docked_hatchling"
	landmark_transition = "nav_transit_hatchling"

/datum/shuttle/autodock/overmap/pod
	name = "Pod"
	warmup_time = 5
	move_time = 30
	shuttle_area = /area/pod/start
	current_location = "wyrm_docked_pod"
	landmark_transition = "nav_transit_pod"
	sound_takeoff = 'sound/effects/rocket.ogg'
	sound_landing = 'sound/effects/rocket_backwards.ogg'

/obj/effect/shuttle_landmark/wyrm/docked/pod
	name = "Docking Port"
	landmark_tag = "wyrm_docked_pod"
	base_area = /area/space
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/wyrm/docked/hatchling
	name = "Docking Port"
	landmark_tag = "wyrm_docked_hatchling"
	base_area = /area/space
	base_turf = /turf/space

/obj/effect/shuttle_landmark/wyrm/transit/pod
	name = "In transit"
	landmark_tag = "nav_transit_pod"

/obj/effect/shuttle_landmark/wyrm/transit/hatchling
	name = "In transit"
	landmark_tag = "nav_transit_hatchling"

/obj/effect/overmap/sector/cluster
	name = "asteroid cluster"
	desc = "Large group of asteroids. Mineral content detected."
	icon_state = "sector"
	generic_waypoints = list(
		"nav_cluster_1",
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
		"Hatchling" = list("distress_signal")
	)

/obj/effect/shuttle_landmark/distress
	name = "Unknown Navpoint"
	landmark_tag = "distress_signal"

/obj/effect/overmap/sector/asteroid
	name = "mineral field"
	desc = "Mineral field detected."
	icon_state = "sector"
	restricted_waypoints = list(
		"Hatchling" = list("asteroid_away")
	)

/obj/effect/shuttle_landmark/asteroid
	name = "Unknown Navpoint"
	landmark_tag = "asteroid_away"

/obj/effect/overmap/sector/planet
	name = "Jungle Planetoid"
	desc = "Biological scans report non-manifest lifeforms."
	icon_state = "planet"
	restricted_waypoints = list(
		"Hatchling" = list("planet_away")
	)

/obj/effect/shuttle_landmark/planet
	name = "Jungle Landing Site"
	landmark_tag = "planet_away"
	base_area = /area/jungle/shuttle