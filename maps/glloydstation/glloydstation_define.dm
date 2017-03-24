/datum/map/glloydstation
	name = "Urist"
	full_name = "NSS Urist"
	path = "glloydstation"

	station_name  = "NSS Urist"
	station_short = "Urist"
	dock_name     = "NAS Crescent"
	boss_name     = "Central Command"
	boss_short    = "Centcomm"
	company_name  = "NanoTrasen"
	company_short = "NT"

	station_levels = list(1)
	admin_levels = list(2)
	contact_levels = list(1,5,6,8)
	player_levels = list(1,3,4,5,6,8)
	sealed_levels = list(6)
	empty_levels = list(6)
	base_turf_by_z = list("6" = /turf/simulated/floor/asteroid, "8" = /turf/simulated/jungle/clear)

	shuttle_docked_message = "The scheduled Crew Transfer Shuttle to %Dock_name% has docked with the station. It will depart in approximately %ETD%"
	shuttle_leaving_dock = "The Crew Transfer Shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock_name%."
	shuttle_called_message = "A crew transfer to %Dock_name% has been scheduled. The shuttle has been called. It will arrive in approximately %ETA%"
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The Emergency Shuttle has docked with the station. You have approximately %ETD% to board the Emergency Shuttle."
	emergency_shuttle_leaving_dock = "The Emergency Shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive in approximately %ETA%"
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."

	evac_controller_type = /datum/evacuation_controller/shuttle
	allowed_spawns = list("Cryogenic Storage", "Cyborg Storage", "Arrivals Shuttle")

/datum/map/glloydstation/perform_map_generation()
	new /datum/random_map/automata/cave_system(null, 1, 1, 5, 255, 255) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, 5, 64, 64)         // Create the mining ore distribution map.
	return 1