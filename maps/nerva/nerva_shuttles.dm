////////////////
//main shuttle//
////////////////

/area/exploration_shuttle
	name = "\improper Trajan"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/floor/plating
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP

/area/exploration_shuttle/cockpit
	name = "\improper Trajan - Cockpit"
	req_access = list(access_expedition_shuttle_helm)

/area/exploration_shuttle/atmos
	name = "\improper Trajan - Atmos Compartment"
	req_access = list(access_expedition_shuttle_helm)

/area/exploration_shuttle/power
	name = "\improper Trajan - Power Compartment"
	req_access = list(access_expedition_shuttle_helm)

/area/exploration_shuttle/main
	name = "\improper Trajan - Main Compartment"

/area/exploration_shuttle/cargo
	name = "\improper Trajan - Cargo Bay"

/obj/machinery/computer/shuttle_control/explore/trajan
	name = "Trajan Control Console"
	shuttle_tag = "Trajan"

/datum/shuttle/autodock/overmap/exploration_shuttle
	name = "Trajan"
	move_time = 30
	shuttle_area = list(/area/exploration_shuttle/cockpit, /area/exploration_shuttle/atmos, /area/exploration_shuttle/power, /area/exploration_shuttle/main, /area/exploration_shuttle/cargo)
	dock_target = "calypso_shuttle"
	current_location = "nav_hangar_trajan"
	landmark_transition = "nav_transit_trajan"
	logging_home_tag = "nav_hangar_trajan"
	logging_access = access_expedition_shuttle_helm

/obj/shuttle_landmark/nerva/hangar/exploration_shuttle
	name = "Trajan Hangar"
	landmark_tag = "nav_hangar_trajan"
	base_area = /area/logistics/hangar
	base_turf = /turf/simulated/floor/plating

/obj/shuttle_landmark/nerva/deck1/exploration_shuttle
	name = "Space near First Deck"
	landmark_tag = "nav_deck1_trajan"

/obj/shuttle_landmark/nerva/deck2/exploration_shuttle
	name = "Space near Second Deck"
	landmark_tag = "nav_deck2_trajan"

/obj/shuttle_landmark/nerva/deck3/exploration_shuttle
	name = "Space near Third Deck"
	landmark_tag = "nav_deck3_trajan"

/obj/shuttle_landmark/nerva/deck4/exploration_shuttle
	name = "Space near Fourth Deck"
	landmark_tag = "nav_deck4_trajan"

/obj/shuttle_landmark/nerva/transit/exploration_shuttle
	name = "In transit"
	landmark_tag = "nav_transit_trajan"

//////////////
//little guy//
//////////////

/datum/shuttle/autodock/overmap/antonine
	name = "Antonine"
	warmup_time = 5
	move_time = 15
	shuttle_area = /area/antonine_hangar/start
	dock_target ="antonine_shuttle"
	current_location = "nav_hangar_antonine"
	landmark_transition = "nav_transit_antonine"
	sound_takeoff = 'sound/effects/rocket.ogg'
	sound_landing = 'sound/effects/rocket_backwards.ogg'
	fuel_consumption = 2
//	logging_home_tag = "nav_hangar_antonine"

/obj/shuttle_landmark/nerva/hangar/antonine
	name = "Antonine Hangar"
	landmark_tag = "nav_hangar_antonine"
	base_area = /area/logistics/hangar
	base_turf = /turf/simulated/floor/plating

/obj/shuttle_landmark/nerva/transit/antonine
	name = "In transit"
	landmark_tag = "nav_transit_antonine"

/obj/shuttle_landmark/nerva/deck1/antonine
	name = "Space near First Deck"
	landmark_tag = "nav_deck1_antonine"

/obj/shuttle_landmark/nerva/deck2/antonine
	name = "Space near Second Deck"
	landmark_tag = "nav_deck2_antonine"

/obj/shuttle_landmark/nerva/deck3/antonine
	name = "Space near Third Deck"
	landmark_tag = "nav_deck3_antonine"

/obj/shuttle_landmark/nerva/deck4/antonine
	name = "Space near Fourth Deck"
	landmark_tag = "nav_deck4_antonine"

/area/antonine_hangar/start
	name = "\improper Antonine"
	icon_state = "shuttlered"
	requires_power = 1
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP
	req_access = list(access_expedition_shuttle_helm)

/obj/machinery/computer/shuttle_control/explore/antonine
	name = "Antonine control console"
	shuttle_tag = "Antonine"

///////////
//science//
///////////

/datum/shuttle/autodock/overmap/hadrian
	name = "Hadrian"
	warmup_time = 5
	move_time = 15
	shuttle_area = list(/area/hadrian/storage, /area/hadrian/main)
	dock_target ="hadrian_shuttle"
	current_location = "nav_hangar_hadrian"
	landmark_transition = "nav_transit_hadrian"
	sound_takeoff = 'sound/effects/rocket.ogg'
	sound_landing = 'sound/effects/rocket_backwards.ogg'
//	fuel_consumption = 2
	logging_home_tag = "nav_hangar_hadrian"
	logging_access = access_xenobiology
	ceiling_type = /turf/simulated/floor/shuttle_ceiling

/obj/shuttle_landmark/nerva/hangar/hadrian
	name = "Hadrian Dock"
	landmark_tag = "nav_hangar_hadrian"
	base_area = /area/space
	base_turf = /turf/space
	docking_controller = "hadrian_shuttle_dock_airlock"

/obj/shuttle_landmark/nerva/transit/hadrian
	name = "In transit"
	landmark_tag = "nav_transit_hadrian"

/obj/shuttle_landmark/nerva/deck1/hadrian
	name = "Space near First Deck"
	landmark_tag = "nav_deck1_hadrian"

/obj/shuttle_landmark/nerva/deck2/hadrian
	name = "Space near Second Deck"
	landmark_tag = "nav_deck2_hadrian"

/obj/shuttle_landmark/nerva/deck3/hadrian
	name = "Space near Third Deck"
	landmark_tag = "nav_deck3_hadrian"

/obj/shuttle_landmark/nerva/deck4/hadrian
	name = "Space near Fourth Deck"
	landmark_tag = "nav_deck4_hadrian"

/area/hadrian
	name = "\improper Hadrian"
	icon_state = "shuttlered"
	requires_power = 1
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP
	req_access = list(access_research)

/area/hadrian/main
	name = "\improper Hadrian - Main Compartment"

/area/hadrian/storage
	name = "\improper Hadrian - Storage Compartment"

/obj/machinery/computer/shuttle_control/explore/hadrian
	name = "Hadrian control console"
	shuttle_tag = "Hadrian"
	req_access = list(access_xenobiology)

//////////
//supply//
//////////

/datum/shuttle/autodock/ferry/supply/drone
	name = "Supply Drone"
	location = 1
	warmup_time = 5
	move_time = 30
	shuttle_area = /area/supply/dock
	waypoint_offsite = "nav_cargo_start"
	waypoint_station = "nav_cargo_station"
	var/doorid = "supplyshuttledoors"

/obj/shuttle_landmark/supply/away
	name = "Away"
	landmark_tag = "nav_cargo_start"

/obj/shuttle_landmark/supply/station
	name = "Station"
	landmark_tag = "nav_cargo_station"
	base_area = /area/spacestations/nanotrasenspace
	base_turf = /turf/simulated/floor/reinforced

/datum/shuttle/autodock/ferry/supply/drone/attempt_move(obj/shuttle_landmark/destination)
	if(!destination)
		return FALSE

	else
		..()

/datum/shuttle/autodock/ferry/supply/drone/arrived()
	if(location == 0)
		for(var/obj/machinery/door/blast/M in SSmachines.machinery)
			if(M.id_tag == src.doorid)
				if(M.density)
					spawn(0)
						M.open()
						return
				else
					spawn(0)
						M.close()
						return

/datum/shuttle/autodock/ferry/supply/drone/launch()
	if(location == 0)
		for(var/obj/machinery/door/blast/M in SSmachines.machinery)
			if(M.id_tag == src.doorid)
				if(M.density)
					spawn(0)
						M.open()
						return
				else
					spawn(0)
						M.close()
						return

	..()

////////////
//merchant//
////////////

/area/shuttle/merchant/home
	name = "\improper Merchant Ship"

/datum/shuttle/autodock/ferry/merchant
	name = "Merchant"
	warmup_time = 10
	shuttle_area = /area/shuttle/merchant/home
	waypoint_station = "nav_merchant_start"
	waypoint_offsite = "nerva_north_dock"
	dock_target = "merchant_ship_dock"

/obj/shuttle_landmark/merchant
	name = "Merchant Base"
	landmark_tag = "nav_merchant_start"
	docking_controller = "merchant_station_dock"

//////////////
//escape pod//
//////////////

//Some helpers because so much copypasta for pods
/datum/shuttle/autodock/ferry/escape_pod/nervapod
	category = /datum/shuttle/autodock/ferry/escape_pod/nervapod
	sound_takeoff = 'sound/effects/rocket.ogg'
	sound_landing = 'sound/effects/rocket_backwards.ogg'
	var/number

/datum/shuttle/autodock/ferry/escape_pod/nervapod/New()
	name = "Escape Pod [number]"
	dock_target = "escape_pod_[number]"
	arming_controller = "escape_pod_[number]_berth"
	waypoint_station = "escape_pod_[number]_start"
	landmark_transition = "escape_pod_[number]_internim"
	waypoint_offsite = "escape_pod_[number]_out"
	..()

/obj/shuttle_landmark/escape_pod/var/number

/obj/shuttle_landmark/escape_pod/start
	name = "Docked"

/obj/shuttle_landmark/escape_pod/start/New()
	landmark_tag = "escape_pod_[number]_start"
	docking_controller = "escape_pod_[number]_berth"
	..()

/obj/shuttle_landmark/escape_pod/transit
	name = "In transit"

/obj/shuttle_landmark/escape_pod/transit/New()
	landmark_tag = "escape_pod_[number]_internim"
	..()

/obj/shuttle_landmark/escape_pod/out
	name = "Escaped"

/obj/shuttle_landmark/escape_pod/out/New()
	landmark_tag = "escape_pod_[number]_out"
	..()

//Pods

/datum/shuttle/autodock/ferry/escape_pod/nervapod/escape_pod1
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod1/station
	number = 1
/obj/shuttle_landmark/escape_pod/start/pod1
	number = 1
	base_turf = /turf/simulated/floor/reinforced/airless
/obj/shuttle_landmark/escape_pod/out/pod1
	number = 1
/obj/shuttle_landmark/escape_pod/transit/pod1
	number = 1

/datum/shuttle/autodock/ferry/escape_pod/nervapod/escape_pod2
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod2/station
	number = 2
/obj/shuttle_landmark/escape_pod/start/pod2
	number = 2
	base_turf = /turf/simulated/floor/plating
/obj/shuttle_landmark/escape_pod/out/pod2
	number = 2
/obj/shuttle_landmark/escape_pod/transit/pod2
	number = 2

/datum/shuttle/autodock/ferry/escape_pod/nervapod/escape_pod3
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod3/station
	number = 3
/obj/shuttle_landmark/escape_pod/start/pod3
	number = 3
	base_turf = /turf/simulated/floor/plating
/obj/shuttle_landmark/escape_pod/out/pod3
	number = 3
/obj/shuttle_landmark/escape_pod/transit/pod3

/area/shuttle/escape_pod1/station
	name = "Escape Pod One"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT
	base_turf = /turf/simulated/floor/reinforced/airless
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE

/area/shuttle/escape_pod2/station
	name = "Escape Pod Two"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT
	base_turf = /turf/simulated/floor/plating
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE

/area/shuttle/escape_pod3/station
	name = "Escape Pod Three"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT
	base_turf = /turf/simulated/floor/plating
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE

//Admin

/*/datum/shuttle/autodock/ferry/administration
	name = "Administration"
	warmup_time = 10	//want some warmup time so people can cancel.
	shuttle_area = /area/shuttle/administration/centcom
	dock_target = "admin_shuttle"
	waypoint_station = "nav_admin_start"
	waypoint_offsite = "nav_admin_out"

/obj/shuttle_landmark/admin/start
	name = "Centcom"
	landmark_tag = "nav_admin_start"
	docking_controller = "admin_shuttle"
	base_area = /area/centcom
	base_turf = /turf/simulated/floor/plating

/obj/shuttle_landmark/admin/out
	name = "Docking Bay"
	landmark_tag = "nav_admin_out"
	docking_controller = "admin_shuttle_dock_airlock"*/

//Transport

/datum/shuttle/autodock/ferry/centcom
	name = "Transport"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/transport1/centcom
	dock_target = "centcom_shuttle"
	waypoint_offsite = "nav_ferry_start"
	waypoint_station = "nav_ferry_out"

/obj/shuttle_landmark/ferry/start
	name = "Centcom"
	landmark_tag = "nav_ferry_start"
	docking_controller = "centcom_shuttle_bay"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/centcom

/obj/shuttle_landmark/ferry/out
	name = "Docking Bay"
	landmark_tag = "nav_ferry_out"
	docking_controller = "centcom_shuttle_dock_airlock"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/hallway/centralfourth

/area/shuttle/transport1/centcom
	icon_state = "shuttle"
	name = "\improper Transport Shuttle Centcom"

/obj/machinery/computer/shuttle_control/transport_shuttle
	name = "transport shuttle console"
	shuttle_tag = "Transport"

//NT rescue shuttle

/datum/shuttle/autodock/ferry/rescue_base
	name = "Rescue"
	location = 1
	warmup_time = 10
	shuttle_area = /area/rescue_base/start
	dock_target = "rescue_shuttle"
	waypoint_offsite = "nav_ert_start"
	waypoint_station = "nerva_south_dock"

/area/rescue_base
	name = "\improper Response Team Base"
	icon_state = "yellow"
	requires_power = 0
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/rescue_base/base
	name = "\improper Barracks"
	icon_state = "yellow"
	dynamic_lighting = 0

/area/rescue_base/start
	name = "\improper Response Team Base"
	icon_state = "shuttlered"

/obj/shuttle_landmark/ERT/start
	name = "Response Team Base"
	landmark_tag = "nav_ert_start"
	docking_controller = "rescue_base"
	base_turf = /turf/unsimulated/floor
	base_area = /area/rescue_base/base

/obj/machinery/computer/shuttle_control/ERT
	name = "rescue shuttle console"
	shuttle_tag = "Rescue"

//ANTAGS


//Ninja Shuttle.
/datum/shuttle/autodock/multi/antag/nervaninja
	name = "Tremulous Intent"
	warmup_time = 0
	destination_tags = list(
		"nav_ninja_deck1",
		"nav_ninja_deck2",
		"nav_ninja_deck3",
		"nav_ninja_deck4",
		"nav_away_6",
		"nav_derelict_5",
		"nav_cluster_6",
		"nav_ninja_start",
		"nav_lost_supply_base_antag",
		"nav_marooned_antag",
		"nav_smugglers_antag",
		"nav_magshield_antag",
		"nav_casino_antag",
		"nav_yacht_antag",
		"nav_slavers_base_antag",
		)
	shuttle_area = /area/ninja_dojo/start
	current_location = "nav_ninja_start"
	landmark_transition = "nav_ninja_transition"
	announcer = "ICS Nerva Sensor Array"
	home_waypoint = "nav_ninja_start"
	arrival_message = "Attention, anomalous sensor reading detected entering vessel proximity."
	departure_message = "Attention, anomalous sensor reading detected leaving vessel proximity."


/obj/shuttle_landmark/ninja/start
	name = "Operations Bunker"
	landmark_tag = "nav_ninja_start"

/obj/shuttle_landmark/ninja/internim
	name = "In transit"
	landmark_tag = "nav_ninja_transition"

/obj/shuttle_landmark/ninja/deck1
	name = "South of the First Deck"
	landmark_tag = "nav_ninja_deck1"

/obj/shuttle_landmark/ninja/deck2
	name = "South of the Second Deck"
	landmark_tag = "nav_ninja_deck2"

/obj/shuttle_landmark/ninja/deck3
	name = "Northeast of the Third Deck"
	landmark_tag = "nav_ninja_deck3"

/obj/shuttle_landmark/ninja/deck4
	name = "East of the Fourth Deck"
	landmark_tag = "nav_ninja_deck4"

// Ninja areas
/area/ninja_dojo
	name = "\improper Operative Base"
	icon_state = "green"
	requires_power = 0
	dynamic_lighting = TRUE
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_syndicate)

/area/ninja_dojo/dojo
	name = "\improper Operations Bunker"
	dynamic_lighting = 0

/area/ninja_dojo/start
	name = "\improper Operations Bunker"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/floor/plating

//Merc

/datum/shuttle/autodock/multi/antag/mercenary
	name = "Mercenary"
	warmup_time = 0
	destination_tags = list(
		"nav_merc_deck1",
		"nav_merc_deck2",
		"nav_merc_deck3",
		"nav_merc_deck4",
		"nav_away_5",
		"nav_derelict_6",
		"nav_cluster_5",
		"nav_merc_dock",
		"nav_merc_start",
		"nav_lost_supply_base_antag",
		"nav_marooned_antag",
		"nav_smugglers_antag",
		"nav_magshield_antag",
		"nav_casino_antag",
		"nav_yacht_antag",
		"nav_slavers_base_antag",
		)
	shuttle_area = /area/syndicate_station/start
	dock_target = "synd"
	current_location = "nav_merc_start"
	landmark_transition = "nav_merc_transition"
	announcer = "ICS Nerva Sensor Array"
	home_waypoint = "nav_merc_start"
	arrival_message = "Attention, unknown vessel detected entering vessel proximity."
	departure_message = "Attention, unknown vessel detected leaving vessel proximity."

/obj/shuttle_landmark/merc/start
	name = "Mercenary Base"
	landmark_tag = "nav_merc_start"
	docking_controller = "merc_home"
	base_turf = /turf/unsimulated/floor/snow
	base_area = /area/map_template/syndicate_mothership

/obj/shuttle_landmark/merc/internim
	name = "In transit"
	landmark_tag = "nav_merc_transition"

/obj/shuttle_landmark/merc/dock
	name = "Docking Port"
	landmark_tag = "nav_merc_dock"
	docking_controller = "nuke_shuttle_dock_airlock"
	base_turf = /turf/simulated/floor/reinforced/airless
	base_area = /area/space

/obj/shuttle_landmark/merc/deck1
	name = "Northeast of the First Deck"
	landmark_tag = "nav_merc_deck1"

/obj/shuttle_landmark/merc/deck2
	name = "Northeast of the Second Deck"
	landmark_tag = "nav_merc_deck2"

/obj/shuttle_landmark/merc/deck3
	name = "Southeast of the Third deck"
	landmark_tag = "nav_merc_deck3"

/obj/shuttle_landmark/merc/deck4
	name = "South of the Fourth deck"
	landmark_tag = "nav_merc_deck4"

/area/map_template/syndicate_mothership
	name = "\improper Mercenary Base"
	icon_state = "syndie-ship"
	requires_power = 0
	dynamic_lighting = 0

/area/syndicate_station/start
	name = "\improper Mercenary Forward Operating Base"
	icon_state = "yellow"
	requires_power = 0
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

//Skipjack

/datum/shuttle/autodock/multi/antag/nervaskipjack
	name = "Skipjack"
	warmup_time = 0
	destination_tags = list(
		"nav_skipjack_deck1",
		"nav_skipjack_deck2",
		"nav_skipjack_deck3",
		"nav_skipjack_deck4",
		"nav_away_7",
		"nav_derelict_7",
		"nav_cluster_7",
		"nerva_south_dock",
		"nav_skipjack_start",
		"nav_lost_supply_base_antag",
		"nav_marooned_antag",
		"nav_smugglers_antag",
		"nav_magshield_antag",
		"nav_casino_antag",
		"nav_yacht_antag",
		"nav_slavers_base_antag",
		)
	shuttle_area =  /area/map_template/skipjack_station/start
	dock_target = "skipjack_shuttle"
	current_location = "nav_skipjack_start"
	landmark_transition = "nav_skipjack_transition"
	announcer = "ICS Nerva Sensor Array"
	home_waypoint = "nav_skipjack_start"
	arrival_message = "Attention, vessel detected entering vessel proximity."
	departure_message = "Attention, vessel detected leaving vessel proximity."

/obj/shuttle_landmark/skipjack/start
	name = "Raider Outpost"
	landmark_tag = "nav_skipjack_start"
	docking_controller = "skipjack_base"

/obj/shuttle_landmark/skipjack/internim
	name = "In transit"
	landmark_tag = "nav_skipjack_transition"

/obj/shuttle_landmark/skipjack/deck1
	name = "Northwest of the First Deck"
	landmark_tag = "nav_skipjack_deck1"

/obj/shuttle_landmark/skipjack/deck2
	name = "Northwest of the Second Deck"
	landmark_tag = "nav_skipjack_deck2"

/obj/shuttle_landmark/skipjack/deck3
	name = "Southwest of the Third deck"
	landmark_tag = "nav_skipjack_deck3"

/obj/shuttle_landmark/skipjack/deck4
	name = "Southeast of the Fourth deck"
	landmark_tag = "nav_skipjack_deck4"

/area/skipjack_station
	name = "Raider Outpost"
	icon_state = "yellow"
	requires_power = 0


//Makes the deck management program use hangar access
/datum/nano_module/deck_management
	default_access = list(access_expedition_shuttle_helm, access_cargo, access_heads)

/////////////////////
//generic waypoints//
/////////////////////
/*
/obj/shuttle_landmark/nerva/first/fore
	name = "First Deck - Fore"
	landmark_tag = "wyrm_prim_fore"

/obj/shuttle_landmark/nerva/first/star
	name = "First Deck - Starboard"
	landmark_tag = "wyrm_prim_star"

/obj/shuttle_landmark/nerva/first/port
	name = "First Deck - Portside"
	landmark_tag = "wyrm_prim_port"

/obj/shuttle_landmark/nerva/first/aft
	name = "First Deck - Aft"
	landmark_tag = "wyrm_prim_aft"

/obj/shuttle_landmark/nerva/second/fore
	name = "Second Deck- Fore"
	landmark_tag = "wyrm_sub_fore"

/obj/shuttle_landmark/nerva/second/star
	name = "Second Deck - Starboard"
	landmark_tag = "wyrm_sub_star"

/obj/shuttle_landmark/nerva/second/port
	name = "Second Deck - Portside"
	landmark_tag = "wyrm_sub_port"

/obj/shuttle_landmark/nerva/second/aft
	name = "Second Deck - Aft"
	landmark_tag = "wyrm_sub_aft"

/obj/shuttle_landmark/nerva/third/fore
	name = "Second Deck- Fore"
	landmark_tag = "wyrm_sub_fore"

/obj/shuttle_landmark/nerva/third/star
	name = "Second Deck - Starboard"
	landmark_tag = "wyrm_sub_star"

/obj/shuttle_landmark/nerva/third/port
	name = "Second Deck - Portside"
	landmark_tag = "wyrm_sub_port"

/obj/shuttle_landmark/nerva/third/aft
	name = "Second Deck - Aft"
	landmark_tag = "wyrm_sub_aft"*/

/////////////////////
//docking waypoints//
/////////////////////
/obj/shuttle_landmark/nerva/docking
	name = "You shouldn't see this."
	base_turf = /turf/space
	base_area = /area/space

/obj/shuttle_landmark/nerva/docking/south
	name = "Starboard Docking Airlock"
	landmark_tag = "nerva_south_dock"
	docking_controller = "skipjack_shuttle_dock_airlock"

/obj/shuttle_landmark/nerva/docking/north
	name = "Port Docking Airlock"
	landmark_tag = "nerva_north_dock"
	docking_controller = "merchant_shuttle_station_dock"

/obj/shuttle_landmark/nerva/docking/east //currently unused
	name = "Fore Docking Airlock"
	landmark_tag = "nerva_east_dock"
	docking_controller = "nerva_docking_east"

/obj/shuttle_landmark/nerva/docking/west //same here
	name = "Aft Docking Airlock"
	landmark_tag = "nerva_west_dock"
	docking_controller = "nerva_docking_west"
