// Escape shuttle and pods

/datum/shuttle/autodock/ferry/emergency/centcom
	name = "Escape Shuttle"
	location = 1
	shuttle_area = /area/shuttle/escape/centcom
	dock_target = "escape_shuttle"
	waypoint_station = "station_escape_port"
	landmark_transition = "escape_transition"
	waypoint_offsite = "centcom_esacpe_port"

/obj/effect/shuttle_landmark/escape/centcom
	name = "Centcom - Escape"
	landmark_tag = "centcom_esacpe_port"
	docking_controller = "centcom_dock"

/obj/effect/shuttle_landmark/escape/transition
	name = "Transition - Escape"
	landmark_tag = "escape_transition"

/obj/effect/shuttle_landmark/escape/station
	name = "Station - Escape"
	landmark_tag = "station_escape_port"
	docking_controller = "escape_dock"

/datum/shuttle/autodock/ferry/escape_pod/escape_pod_one
	name = "Escape Pod 1"
	warmup_time = 0
	shuttle_area = /area/shuttle/escape_pod1/station
	arming_controller = "escape_pod_1_berth"
	dock_target = "escape_pod_1"
	waypoint_station = "escape_pod_1_docked"
	landmark_transition = "escape_pod_1_transition"
	waypoint_offsite = "escape_pod_1_recovery"

/datum/shuttle/autodock/ferry/escape_pod/escape_pod_two
	name = "Escape Pod 2"
	warmup_time = 0
	shuttle_area = /area/shuttle/escape_pod2/station
	arming_controller = "escape_pod_2_berth"
	dock_target = "escape_pod_2"
	waypoint_station = "escape_pod_2_docked"
	landmark_transition = "escape_pod_2_transition"
	waypoint_offsite = "escape_pod_2_recovery"

/datum/shuttle/autodock/ferry/escape_pod/escape_pod_three
	name = "Escape Pod 3"
	warmup_time = 0
	shuttle_area = /area/shuttle/escape_pod3/station
	arming_controller = "escape_pod_3_berth"
	dock_target = "escape_pod_3"
	waypoint_station = "escape_pod_3_docked"
	landmark_transition = "escape_pod_3_transition"
	waypoint_offsite = "escape_pod_3_recovery"

/datum/shuttle/autodock/ferry/escape_pod/escape_pod_four
	name = "Escape Pod 4"
	warmup_time = 0
	shuttle_area = /area/shuttle/escape_pod5/station
	arming_controller = "escape_pod_5_berth"
	dock_target = "escape_pod_5"
	waypoint_station = "escape_pod_5_docked"
	landmark_transition = "escape_pod_5_transition"
	waypoint_offsite = "escape_pod_5_recovery"

/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply"
	location = 1
	warmup_time = 10
	shuttle_area = /area/supply/dock
	dock_target = "supply_shuttle"
	waypoint_station = "station_cargo_bay"
	waypoint_offsite = "centcom_cargo_port"

/obj/effect/shuttle_landmark/supply/centcom
	name = "Centcom - Cargo"
	landmark_tag = "centcom_cargo_port"

/obj/effect/shuttle_landmark/supply/station
	name = "Cargo Bay"
	landmark_tag = "station_cargo_bay"

/datum/shuttle/autodock/ferry/engineering
	name = "Engineering"
	warmup_time = 10
	shuttle_area = /area/shuttle/constructionsite/station
	dock_target = "engineering_shuttle"
	waypoint_station = "station_engi"
	waypoint_offsite = "pbase_engi"

/obj/effect/shuttle_landmark/engineering/station
	name = "Station - Engineering Port"
	landmark_tag = "station_engi"
	docking_controller = "engineering_dock_airlock"

/obj/effect/shuttle_landmark/engineering/planet
	name = "Planet Base - Engineering"
	landmark_tag = "pbase_engi"
	docking_controller = "edock_airlock"
	base_area = /area/jungle
	base_turf = /turf/simulated/floor/plating

/datum/shuttle/autodock/ferry/mining
	name = "Mining"
	warmup_time = 10
	shuttle_area = /area/shuttle/mining/station
	dock_target = "mining_shuttle"
	waypoint_station = "station_mining"
	waypoint_offsite = "pbase_mining"

/obj/effect/shuttle_landmark/mining/station
	name = "Station - Mining Port"
	landmark_tag = "station_mining"

/obj/effect/shuttle_landmark/mining/planet
	name = "Planet Base - Mining"
	landmark_tag = "pbase_mining"
	docking_controller = "mining_outpost_airlock"
	base_area = /area/jungle
	base_turf = /turf/simulated/floor/plating

/datum/shuttle/autodock/ferry/research
	name = "Research"
	warmup_time = 10
	shuttle_area = /area/shuttle/research/station
	dock_target = "research_shuttle"
	waypoint_station = "station_research"
	waypoint_offsite = "pbase_research"

/obj/effect/shuttle_landmark/research/station
	name = "Station - Research Port"
	landmark_tag = "station_research"

/obj/effect/shuttle_landmark/research/planet
	name = "Planet Base - Research"
	landmark_tag = "pbase_research"
	docking_controller = "research_outpost_dock"
	base_area = /area/jungle
	base_turf = /turf/simulated/floor/plating

/datum/shuttle/autodock/ferry/centcom
	name = "Centcom"
	warmup_time = 10
	dock_target = "centcom_shuttle"
	waypoint_station = "centcom_shuttle_dock_airlock"
	waypoint_offsite = "centcom_shuttle_bay"

/datum/shuttle/autodock/ferry/administration
	name = "Administration"
	warmup_time = 10	//want some warmup time so people can cancel.
	dock_target = "admin_shuttle"
	waypoint_station = "admin_shuttle_dock_airlock"
	waypoint_offsite = "admin_shuttle_bay"

/datum/shuttle/autodock/ferry/alien
	name = "Alien"
	flags = SHUTTLE_FLAGS_NONE

/datum/shuttle/autodock/ferry/merchant
	name = "Merchant"
	warmup_time = 10
	dock_target = "merchant_ship_dock"
	waypoint_station = "merchant_station_dock"
	waypoint_offsite = "merchant_shuttle_station_dock"

/datum/shuttle/autodock/multi/antag/mercenary
	name = "Mercenary"
	warmup_time = 0
	destinations = list(
		"Northwest of the station" = /area/syndicate_station/northwest,
		"North of the station" = /area/syndicate_station/north,
		"Northeast of the station" = /area/syndicate_station/northeast,
		"Southwest of the station" = /area/syndicate_station/southwest,
		"South of the station" = /area/syndicate_station/south,
		"Southeast of the station" = /area/syndicate_station/southeast,
		"Telecomms Satellite" = /area/syndicate_station/commssat,
		"Planetside" = /area/syndicate_station/mining,
		)
	dock_target = "merc_shuttle"
	home_waypoint = "merc_base"
	announcer = "NDV Icarus"

/datum/shuttle/autodock/multi/antag/mercenary/New()
	arrival_message = "Attention, [GLOB.using_map.station_short], you have a large signature approaching the station - looks unarmed to surface scans. We're too far out to intercept - brace for visitors."
	departure_message = "Your visitors are on their way out of the system, [GLOB.using_map.station_short], burning delta-v like it's nothing. Good riddance."
	..()

/datum/shuttle/autodock/multi/antag/skipjack
	name = "Skipjack"
	warmup_time = 0
	destinations = list(
		"Fore Starboard Solars" = /area/skipjack_station/northeast_solars,
		"Fore Port Solars" = /area/skipjack_station/northwest_solars,
		"Aft Starboard Solars" = /area/skipjack_station/southeast_solars,
		"Aft Port Solars" = /area/skipjack_station/southwest_solars,
		"Planetside" = /area/skipjack_station/mining
		)
	home_waypoint = "pirate_base"
	announcer = "NDV Icarus"

/datum/shuttle/autodock/multi/antag/skipjack/New()
	arrival_message = "Attention, [GLOB.using_map.station_short], we just tracked a small target bypassing our defensive perimeter. Can't fire on it without hitting the station - you've got incoming visitors, like it or not."
	departure_message = "Your guests are pulling away, [GLOB.using_map.station_short] - moving too fast for us to draw a bead on them. Looks like they're heading out of the system at a rapid clip."
	..()

/*/datum/shuttle/multi_shuttle/rescue
	name = "Rescue"
	warmup_time = 0
	origin = /area/rescue_base/start
	interim = /area/rescue_base/transit
	start_location = "Response Team Base"
	destinations = list(
		"Northwest of the station" = /area/rescue_base/northwest,
		"North of the station" = /area/rescue_base/north,
		"Northeast of the station" = /area/rescue_base/northeast,
		"Southwest of the station" = /area/rescue_base/southwest,
		"South of the station" = /area/rescue_base/south,
		"Southeast of the station" = /area/rescue_base/southeast,
		"Telecomms Satellite" = /area/rescue_base/commssat,
		"Engineering Station" = /area/rescue_base/mining,
		"Arrivals dock" = /area/rescue_base/arrivals_dock,
		)
	dock_target = "rescue_shuttle"
	destination_dock_targets = list(
		"Response Team Base" = "rescue_base",
		"Arrivals dock" = "rescue_shuttle_dock_airlock",
		)
	announcer = "NDV Icarus"

/datum/shuttle/multi_shuttle/rescue/New()
	arrival_message = "Attention, [using_map.station_short], there's a small patrol craft headed your way, it flashed us Asset Protection codes and we let it pass. You've got guests on the way."
	departure_message = "[using_map.station_short], That Asset Protection vessel is headed back the way it came. Hope they were helpful."
	..()*/

/datum/shuttle/autodock/ferry/specops/ert
	name = "Special Operations"
	warmup_time = 10
	dock_target = "specops_shuttle_port"
	waypoint_station = "specops_centcom_dock"
	waypoint_offsite = "specops_dock_airlock"

/datum/shuttle/autodock/ferry/naval
	name = "Naval"
	warmup_time = 10
//	dock_target = "naval_shuttle"
//	waypoint_station = "naval_shuttle_dock_airlock"
//	waypoint_offsite = "naval_shuttle_bay"

/datum/shuttle/autodock/ferry/security
	name = "Security"
	warmup_time = 10
	dock_target = "security_shuttle"
	waypoint_station = "security_dock_airlock"
	waypoint_offsite = "secdock_airlock"

/datum/shuttle/autodock/ferry/planet
	name = "Planet"
	warmup_time = 10
	dock_target = "planet_shuttle"
	waypoint_station = "station_planet_dock"
	waypoint_offsite = "outpost_planet_dock"

/obj/machinery/computer/shuttle_control/planet
	name = "planet shuttle console"
	shuttle_tag = "Planet"
