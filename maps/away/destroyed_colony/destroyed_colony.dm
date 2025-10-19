/area/planet/destroyed_colony
	name = "\improper Destroyed Colony"
	base_turf = /turf/simulated/floor/planet/ariddirt/clear

/area/planet/destroyed_colony/transmitter
	name = "\improper Destroyed Colony - Transmitter"
	icon_state = "yellow"
	icon = 'icons/turf/areas.dmi'

/obj/overmap/visitable/sector/planetoid/destroyed_colony
	name = "destroyed colony"
	desc = "A former Terran Confederation colony, any settlements on this world were destroyed during the Galactic Crisis. Little remains, but sensors are detecting a faint distress signal from a destroyed settlement."
	icon_state = "globe"
	color = "#c2b280"
	assigned_contracts = list(/datum/contract/destroyed_colony)
	initial_generic_waypoints = list(
		"nav_destroyed_colony_1",
		"nav_destroyed_colony_2"
		)

/obj/shuttle_landmark/nav_destroyed_colony/nav1
	name = "Planetary Navpoint #1"
	landmark_tag = "nav_destroyed_colony_1"
	base_area = /area/planet/destroyed_colony
	base_turf = /turf/simulated/floor/planet/ariddirt/clear

/obj/shuttle_landmark/nav_destroyed_colony/nav2
	name = "Planetary Navpoint #2"
	landmark_tag = "nav_destroyed_colony_2"
	base_area = /area/planet/destroyed_colony
	base_turf = /turf/simulated/floor/planet/ariddirt/clear

/datum/map_template/ruin/away_site/destroyed_colony
	name = "Destroyed Colony"
	id = "awaysite_destroyed_colony"
	description = "A former Terran Confederation colony, any settlements on this world were destroyed during the Galactic Crisis. Little remains, but sensors are detecting a faint distress signal from a destroyed settlement."
	suffixes = list("destroyed_colony/destroyed_colony.dmm")
	accessibility_weight = 10
	spawn_cost = 1

//contract stuff

/datum/contract/destroyed_colony
	name = "Distress Signal Investigation Contract"
	desc = "A distress signal has been detected on a nearby graveworld. All ships sent to investigate haven't been heard from since. The situation on the planet's surface is unknown, long range scans only detect the ruins of a colony that was destroyed during the Galactic Crisis. We need you to investigate the signal, and disable it if it is fradulent. Good luck, and be safe, graveworlds can be home to all sorts of dangers."
	rep_points = 6
	money = 10000
	amount = 1

/obj/machinery/radio_beacon/destroyed_colony
	active_power_usage = 0
	construct_state = null
	var/contract_enabled = FALSE

/obj/machinery/radio_beacon/destroyed_colony/Initialize()
	.=..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/radio_beacon/destroyed_colony/LateInitialize()
	if(!contract_enabled && GLOB.using_map.use_overmap)
		contract_enabled = TRUE
		activate_distress()

/obj/machinery/radio_beacon/destroyed_colony/deactivate()
	..()
	if(contract_enabled)
		for(var/datum/contract/destroyed_colony/contract in GLOB.using_map.contracts)
			contract.Complete(1)
			contract_enabled = FALSE

/obj/machinery/radio_beacon/destroyed_colony/Destroy()
	if(contract_enabled)
		for(var/datum/contract/destroyed_colony/contract in GLOB.using_map.contracts)
			addtimer(new Callback(contract, TYPE_PROC_REF(/datum/contract, Complete), 1), 2 SECONDS)

	.=..()
