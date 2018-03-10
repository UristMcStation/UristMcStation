/datum/map/asteroid
	name = "Station"
	full_name = "Station #6446"
	path = "asteroid"

	station_name  = "Station #6446"
	station_short = "Station"
	dock_name     = "N/A"
	boss_name     = "N/A"
	boss_short    = "N/A"
	company_name  = "N/A"
	company_short = "N/A"

	lobby_icon = 'maps/glloydstation/glloydstation_lobby.dmi'

	station_levels = list(1,2,3)
	admin_levels = list(4)
	contact_levels = list(1,2,3)
	player_levels = list(1,2,3,4,5)
	sealed_levels = list(4)
	empty_levels = list(5)
	base_turf_by_z = list("1" = /turf/simulated/open,"2" = /turf/simulated/open,"3" = /turf/simulated/open)
	accessible_z_levels = list("1"=10, "2"=10, "3"=10)

	evac_controller_type = /datum/evacuation_controller/station
	allowed_spawns = list("Cryogenic Storage", "Cyborg Storage", "Arrivals Shuttle")

/datum/map/asteroid/perform_map_generation()
	new /datum/random_map/automata/cave_system(null, 1, 1, 2, 255, 255)
	new /datum/random_map/noise/ore(null, 1, 1, 2, 64, 64)         // Create the mining ore distribution map.
	return 1