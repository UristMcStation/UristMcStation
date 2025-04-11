// Escape shuttle and pods

/datum/shuttle/autodock/ferry/emergency/centcom
	name = "Escape Shuttle"
	location = 1
	shuttle_area = /area/shuttle/escape/centcom
	dock_target = "escape_shuttle"
	waypoint_station = "station_escape_port"
	landmark_transition = "escape_transition"
	waypoint_offsite = "centcom_escape_port"

/obj/shuttle_landmark/escape/centcom
	name = "Centcom - Escape"
	landmark_tag = "centcom_escape_port"
	docking_controller = "centcom_dock"

/obj/shuttle_landmark/escape/transition
	name = "Transition - Escape"
	landmark_tag = "escape_transition"

/obj/shuttle_landmark/escape/station
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

/obj/shuttle_landmark/pod_1/station
	name = "Escape Pod 1 - Station"
	landmark_tag = "escape_pod_1_docked"
	docking_controller = "escape_pod_1_berth"

/obj/shuttle_landmark/pod_1/transition
	name = "Escape Pod 1 - Transition"
	landmark_tag = "escape_pod_1_transition"

/obj/shuttle_landmark/pod_1/recovery
	name = "Escape Pod 1 - Recovery"
	landmark_tag = "escape_pod_1_recovery"
	docking_controller = "escape_pod_1_recovery"

/datum/shuttle/autodock/ferry/escape_pod/escape_pod_two
	name = "Escape Pod 2"
	warmup_time = 0
	shuttle_area = /area/shuttle/escape_pod2/station
	arming_controller = "escape_pod_2_berth"
	dock_target = "escape_pod_2"
	waypoint_station = "escape_pod_2_docked"
	landmark_transition = "escape_pod_2_transition"
	waypoint_offsite = "escape_pod_2_recovery"

/obj/shuttle_landmark/pod_2/station
	name = "Escape Pod 2 - Station"
	landmark_tag = "escape_pod_2_docked"
	docking_controller = "escape_pod_2_berth"

/obj/shuttle_landmark/pod_2/transition
	name = "Escape Pod 2 - Transition"
	landmark_tag = "escape_pod_2_transition"

/obj/shuttle_landmark/pod_2/recovery
	name = "Escape Pod 2 - Recovery"
	landmark_tag = "escape_pod_2_recovery"
	docking_controller = "escape_pod_2_recovery"

/datum/shuttle/autodock/ferry/escape_pod/escape_pod_three
	name = "Escape Pod 3"
	warmup_time = 0
	shuttle_area = /area/shuttle/escape_pod3/station
	arming_controller = "escape_pod_3_berth"
	dock_target = "escape_pod_3"
	waypoint_station = "escape_pod_3_docked"
	landmark_transition = "escape_pod_3_transition"
	waypoint_offsite = "escape_pod_3_recovery"

/obj/shuttle_landmark/pod_3/station
	name = "Escape Pod 3 - Station"
	landmark_tag = "escape_pod_3_docked"
	docking_controller = "escape_pod_3_berth"

/obj/shuttle_landmark/pod_3/transition
	name = "Escape Pod 3 - Transition"
	landmark_tag = "escape_pod_3_transition"

/obj/shuttle_landmark/pod_3/recovery
	name = "Escape Pod 3 - Recovery"
	landmark_tag = "escape_pod_3_recovery"
	docking_controller = "escape_pod_3_recovery"

/datum/shuttle/autodock/ferry/escape_pod/escape_pod_four
	name = "Escape Pod 4"
	warmup_time = 0
	shuttle_area = /area/shuttle/escape_pod5/station
	arming_controller = "escape_pod_5_berth"
	dock_target = "escape_pod_5"
	waypoint_station = "escape_pod_5_docked"
	landmark_transition = "escape_pod_5_transition"
	waypoint_offsite = "escape_pod_5_recovery"

/obj/shuttle_landmark/pod_5/station
	name = "Escape Pod 5 - Station"
	landmark_tag = "escape_pod_5_docked"
	docking_controller = "escape_pod_5_berth"

/obj/shuttle_landmark/pod_5/transition
	name = "Escape Pod 5 - Transition"
	landmark_tag = "escape_pod_5_transition"

/obj/shuttle_landmark/pod_5/recovery
	name = "Escape Pod 5 - Recovery"
	landmark_tag = "escape_pod_5_recovery"
	docking_controller = "escape_pod_5_recovery"

// Cargo ship

/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply"
	location = 1
	warmup_time = 10
	shuttle_area = /area/supply/dock
	dock_target = "supply_shuttle"
	waypoint_station = "station_cargo_bay"
	waypoint_offsite = "centcom_cargo_port"

/obj/shuttle_landmark/supply/centcom
	name = "Centcom - Cargo"
	landmark_tag = "centcom_cargo_port"

/obj/shuttle_landmark/supply/station
	name = "Cargo Bay"
	landmark_tag = "station_cargo_bay"
	docking_controller = "cargo_bay"

// Assorted planet shuttles

/datum/shuttle/autodock/ferry/engineering
	name = "Engineering"
	warmup_time = 10
	shuttle_area = /area/shuttle/constructionsite/station
	dock_target = "engineering_shuttle"
	waypoint_station = "station_engi"
	waypoint_offsite = "pbase_engi"

/obj/shuttle_landmark/engineering/station
	name = "Station - Engineering Port"
	landmark_tag = "station_engi"
	docking_controller = "engineering_dock_airlock"

/obj/shuttle_landmark/engineering/planet
	name = "Planet Base - Engineering"
	landmark_tag = "pbase_engi"
	docking_controller = "edock_airlock"
	base_area = /area/planet/jungle
	base_turf = /turf/simulated/floor/plating

/datum/shuttle/autodock/ferry/mining
	name = "Mining"
	warmup_time = 10
	shuttle_area = /area/shuttle/mining/station
	dock_target = "mining_shuttle"
	waypoint_station = "station_mining"
	waypoint_offsite = "pbase_mining"

/obj/shuttle_landmark/mining/station
	name = "Station - Mining Port"
	landmark_tag = "station_mining"

/obj/shuttle_landmark/mining/planet
	name = "Planet Base - Mining"
	landmark_tag = "pbase_mining"
	docking_controller = "mining_outpost_airlock"
	base_area = /area/planet/jungle
	base_turf = /turf/simulated/floor/plating

/datum/shuttle/autodock/ferry/research
	name = "Research"
	warmup_time = 10
	shuttle_area = /area/shuttle/research/station
	dock_target = "research_shuttle"
	waypoint_station = "station_research"
	waypoint_offsite = "pbase_research"

/obj/shuttle_landmark/research/station
	name = "Station - Research Port"
	landmark_tag = "station_research"

/obj/shuttle_landmark/research/planet
	name = "Planet Base - Research"
	landmark_tag = "pbase_research"
	docking_controller = "research_outpost_dock"
	base_area = /area/planet/jungle
	base_turf = /turf/simulated/floor/plating

/datum/shuttle/autodock/ferry/security
	name = "Security"
	warmup_time = 10
	shuttle_area = /area/shuttle/securityoutpost/station
	dock_target = "security_shuttle"
	waypoint_station = "security_dock_airlock"
	waypoint_offsite = "secdock_airlock"

/obj/shuttle_landmark/security/station
	name = "Station - Security Port"
	landmark_tag = "security_dock_airlock"
	docking_controller = "security_docking_station"

/obj/shuttle_landmark/security/planet
	name = "Planet Base - Security"
	landmark_tag = "secdock_airlock"
	docking_controller = "security_docking_planet"
	base_area = /area/planet/jungle
	base_turf = /turf/simulated/floor/plating

/datum/shuttle/autodock/ferry/planet
	name = "Planet"
	warmup_time = 10
	shuttle_area = /area/shuttle/planet/station
	dock_target = "planet_shuttle"
	waypoint_station = "public_planet_shuttle_station"
	waypoint_offsite = "public_planet_shuttle_planet"

/obj/machinery/computer/shuttle_control/planet
	name = "planet shuttle console"
	shuttle_tag = "Planet"

/obj/shuttle_landmark/planet/station
	name = "Station - Public Shuttle"
	landmark_tag = "public_planet_shuttle_station"
	docking_controller = "station_planet_dock"

/obj/shuttle_landmark/planet/planet
	name = "Planet - Public"
	landmark_tag = "public_planet_shuttle_planet"
	docking_controller = "outpost_planet_dock"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/planet/jungle

// Centcom shuttles

/datum/shuttle/autodock/ferry/centcom_arrivals
	name = "Arrivals"
	warmup_time = 5
	move_time = 15
	shuttle_area = /area/shuttle/arrivals/centcom
	dock_target = "arrival_shuttle"
	waypoint_station = "arrivals_centcom"
	landmark_transition = "arrivals_transit"
	waypoint_offsite = "arrivals_station"

/datum/shuttle/autodock/ferry/centcom_arrivals/proc/AnnounceArrival()
	if (GAME_STATE >= RUNLEVEL_GAME)
		GLOB.global_announcer.autosay("The Arrivals Shuttle has docked with the Station.", "Arrivals Announcement Computer", "Common")


/datum/shuttle/autodock/ferry/centcom_arrivals/arrived()
	if(location == 1)
		AnnounceArrival()
		sleep(200) //20 seconds give or take some lag.
		launch()

	return

/obj/shuttle_landmark/centcom/arrivals/centcom
	name = "Centcom Arrivals"
	landmark_tag = "arrivals_centcom"
	docking_controller = "centcom_arrival_dock"

/obj/shuttle_landmark/centcom/arrivals/transit
	name = "In Transition"
	landmark_tag = "arrivals_transit"

/obj/shuttle_landmark/centcom/arrivals/station
	name = "Station Arrivals"
	landmark_tag = "arrivals_station"
	docking_controller = "station_arrival_dock"

/datum/shuttle/autodock/ferry/centcom
	name = "Transport"
	warmup_time = 10
	shuttle_area = /area/shuttle/transport1/centcom
	dock_target = "centcom_shuttle"
	waypoint_station = "centcom_shuttle_dock_airlock"
	waypoint_offsite = "centcom_shuttle_bay"

/obj/shuttle_landmark/centcom/transport/centcom
	name = "Transport - Centcom"
	landmark_tag = "centcom_shuttle_bay"
	docking_controller = "centcom_shuttle"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/centcom

/obj/shuttle_landmark/centcom/transport/station
	name = "Transport - Station"
	landmark_tag = "centcom_shuttle_dock_airlock"
	docking_controller = "centcom_transport_station"

/datum/shuttle/autodock/ferry/administration
	name = "Administration"
	warmup_time = 10	//want some warmup time so people can cancel.
	shuttle_area = /area/shuttle/administration/centcom
	dock_target = "admin_shuttle"
	waypoint_station = "admin_shuttle_dock_airlock"
	waypoint_offsite = "admin_shuttle_bay"

/obj/shuttle_landmark/centcom/admin/centcom
	name = "Administration - Centcom"
	landmark_tag = "admin_shuttle_bay"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/centcom

/obj/shuttle_landmark/centcom/admin/station
	name = "Administration - Station"
	landmark_tag = "admin_shuttle_dock_airlock"

// Typically unused Naval Shuttle

/datum/shuttle/autodock/ferry/naval
	name = "Naval"
	warmup_time = 10
	shuttle_area = /area/shuttle/naval1/centcom
//	dock_target = "naval_shuttle"
	waypoint_station = "naval_shuttle_centcom"
	waypoint_offsite = "naval_shuttle_urist"

/obj/shuttle_landmark/centcom/naval/centcom
	name = "Naval Shuttle - Centcom"
	landmark_tag = "naval_shuttle_centcom"

/obj/shuttle_landmark/centcom/naval/station
	name = "Naval Shuttle - Station"
	landmark_tag = "naval_shuttle_urist"

/obj/machinery/computer/shuttle_control/naval_shuttle
	name = "naval shuttle console"
	shuttle_tag = "Naval"

// Merchant ship

/datum/shuttle/autodock/ferry/merchant
	name = "Merchant"
	warmup_time = 10
	shuttle_area = /area/shuttle/merchant/home
	waypoint_station = "nav_merchant_start"
	waypoint_offsite = "nav_merchant_out"
	dock_target = "merchant_ship_dock"

/obj/shuttle_landmark/merchant/start
	name = "Merchant Base"
	landmark_tag = "nav_merchant_start"
	docking_controller = "merchant_station_dock"

/obj/shuttle_landmark/merchant/out
	name = "Docking Bay"
	landmark_tag = "nav_merchant_out"
	docking_controller = "merchant_shuttle_station_dock"

// Emergency Response Team shuttle

/datum/shuttle/autodock/ferry/specops/ert
	name = "Special Operations"
	warmup_time = 10
	shuttle_area = /area/shuttle/specops/centcom
	dock_target = "specops_shuttle_port"
	waypoint_station = "specops_centcom_dock"
	waypoint_offsite = "specops_dock_airlock"

/obj/shuttle_landmark/specops/start
	name = "Home Base"
	landmark_tag = "specops_centcom_dock"
	docking_controller = "centcom_ert_dock"

/obj/shuttle_landmark/specops/station
	name = "Urist McStation Dock"
	landmark_tag = "specops_dock_airlock"


// Antag Multi-target ships

/datum/shuttle/autodock/multi/antag/mercenary
	name = "Mercenary"
	warmup_time = 0
	destination_tags = list(
		"merc_ship_start",
		"merc_NW_urist",
		"merc_N_urist",
		"merc_NE_urist",
		"merc_SW_urist",
		"merc_S_urist",
		"merc_SE_urist",
		"merc_ship_planet"
		)

	shuttle_area = /area/syndicate_station/start
	dock_target = "merc_shuttle"
	current_location = "merc_ship_start"
	landmark_transition = "merc_ship_transit"
	announcer = "NDV Icarus"
	home_waypoint = "merc_ship_start"

/datum/shuttle/autodock/multi/antag/mercenary/New()
	arrival_message = "Attention, [GLOB.using_map.station_short], you have a large signature approaching the station - looks unarmed to surface scans. We're too far out to intercept - brace for visitors."
	departure_message = "Your visitors are on their way out of the system, [GLOB.using_map.station_short], burning delta-v like it's nothing. Good riddance."
	..()

/obj/shuttle_landmark/mercenary/start
	name = "Mercenary Base"
	landmark_tag = "merc_ship_start"
	base_turf = /turf/unsimulated/floor/snow
	base_area = /area/map_template/syndicate_mothership

/obj/shuttle_landmark/mercenary/transit
	name = "In Transit"
	landmark_tag = "merc_ship_transit"

/obj/shuttle_landmark/mercenary/NW_station
	name = "Northwest of the Station"
	landmark_tag = "merc_NW_urist"

/obj/shuttle_landmark/mercenary/N_station
	name = "North of the Station"
	landmark_tag = "merc_N_urist"

/obj/shuttle_landmark/mercenary/NE_station
	name = "Northeast of the Station"
	landmark_tag = "merc_NE_urist"

/obj/shuttle_landmark/mercenary/SW_station
	name = "Southwest of the Station"
	landmark_tag = "merc_SW_urist"

/obj/shuttle_landmark/mercenary/S_station
	name = "Close South to the Station"
	landmark_tag = "merc_S_urist"

/obj/shuttle_landmark/mercenary/SE_station
	name = "Southeast of the Station"
	landmark_tag = "merc_SE_urist"

/obj/shuttle_landmark/mercenary/planetside
	name = "Down on the Planet"
	landmark_tag = "merc_ship_planet"
	base_area = /area/planet/jungle
	base_turf = /turf/simulated/floor/planet/jungle/clear

/datum/shuttle/autodock/multi/antag/skipjack
	name = "Skipjack"
	warmup_time = 0
	destination_tags = list(
		"raider_start_point",
		"raider_NE_urist",
		"raider_NW_urist",
		"raider_SE_urist",
		"raider_SW_urist",
		"raider_planetside"
		)
	shuttle_area = /area/map_template/skipjack_station/start
	home_waypoint = "raider_start_point"
	current_location = "raider_start_point"
	landmark_transition = "raider_in_transit"
	announcer = "NDV Icarus"

/datum/shuttle/autodock/multi/antag/skipjack/New()
	arrival_message = "Attention, [GLOB.using_map.station_short], we just tracked a small target bypassing our defensive perimeter. Can't fire on it without hitting the station - you've got incoming visitors, like it or not."
	departure_message = "Your guests are pulling away, [GLOB.using_map.station_short] - moving too fast for us to draw a bead on them. Looks like they're heading out of the system at a rapid clip."
	..()

/obj/shuttle_landmark/raider_skipjack/start
	name = "Raider Base"
	landmark_tag = "raider_start_point"

/obj/shuttle_landmark/raider_skipjack/transit
	name = "In Transit"
	landmark_tag = "raider_in_transit"

/obj/shuttle_landmark/raider_skipjack/NE_solars
	name = "Northeast Solars"
	landmark_tag = "raider_NE_urist"

/obj/shuttle_landmark/raider_skipjack/NW_solars
	name = "Northwest Solars"
	landmark_tag = "raider_NW_urist"

/obj/shuttle_landmark/raider_skipjack/SE_solars
	name = "Southeast Solars"
	landmark_tag = "raider_SE_urist"

/obj/shuttle_landmark/raider_skipjack/SW_solars
	name = "Southwest Solars"
	landmark_tag = "raider_SW_urist"

/obj/shuttle_landmark/raider_skipjack/planetside
	name = "Planetside"
	landmark_tag = "raider_planetside"
	base_area = /area/planet/jungle
	base_turf = /turf/simulated/floor/planet/jungle/clear

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
