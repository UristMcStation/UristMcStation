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

	lobby_icon = 'maps/glloydstation/glloydstation_lobby.dmi'

	station_levels = list(1)
	admin_levels = list(2)
	contact_levels = list(1,2,5,6,7)
	player_levels = list(1,3,4,5,6,7)
	sealed_levels = list(6)
	empty_levels = list(6)
	base_turf_by_z = list("5" = /turf/simulated/floor/asteroid, "7" = /turf/simulated/floor/planet/jungle/clear)
	accessible_z_levels = list("1"=15, "3"=15, "4"=25)

	id_hud_icons = 'maps/glloydstation/icons/assignment_hud.dmi'

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

	available_cultural_info = list(
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_EARTH,
			HOME_SYSTEM_LUNA,
			HOME_SYSTEM_MARS,
			HOME_SYSTEM_VENUS,
			HOME_SYSTEM_CERES,
			HOME_SYSTEM_PLUTO,
			HOME_SYSTEM_TAU_CETI,
			HOME_SYSTEM_HELIOS,
			HOME_SYSTEM_TERRA,
			HOME_SYSTEM_TERSTEN,
			HOME_SYSTEM_LORRIMAN,
			HOME_SYSTEM_CINU,
			HOME_SYSTEM_YUKLID,
			HOME_SYSTEM_LORDANIA,
			HOME_SYSTEM_KINGSTON,
			HOME_SYSTEM_GAIA,
			HOME_SYSTEM_OTHER
		),
		TAG_FACTION = list(
			FACTION_NANOTRASEN,
			FACTION_FREETRADE,
			FACTION_XYNERGY,
			FACTION_HEPHAESTUS,
			FACTION_PCRC,
			FACTION_OTHER
		),
		TAG_CULTURE = list(
			CULTURE_HUMAN,
			CULTURE_HUMAN_MARTIAN,
			CULTURE_HUMAN_MARSTUN,
			CULTURE_HUMAN_LUNAPOOR,
			CULTURE_HUMAN_LUNARICH,
			CULTURE_HUMAN_VENUSIAN,
			CULTURE_HUMAN_VENUSLOW,
			CULTURE_HUMAN_BELTER,
			CULTURE_HUMAN_PLUTO,
			CULTURE_HUMAN_EARTH,
			CULTURE_HUMAN_CETI,
			CULTURE_HUMAN_SPACER,
			CULTURE_HUMAN_SPAFRO,
			CULTURE_HUMAN_CONFED,
			CULTURE_HUMAN_OTHER,
			CULTURE_OTHER
		),
		TAG_RELIGION = list(
			RELIGION_OTHER,
			RELIGION_JUDAISM,
			RELIGION_HINDUISM,
			RELIGION_BUDDHISM,
			RELIGION_ISLAM,
			RELIGION_CHRISTIANITY,
			RELIGION_AGNOSTICISM,
			RELIGION_DEISM,
			RELIGION_ATHEISM,
			RELIGION_THELEMA,
			RELIGION_SPIRITUALISM
		)
	)

	default_cultural_info = list(
		TAG_HOMEWORLD = HOME_SYSTEM_MARS,
		TAG_FACTION =   FACTION_NANOTRASEN,
		TAG_CULTURE =   CULTURE_HUMAN_MARTIAN,
		TAG_RELIGION =  RELIGION_AGNOSTICISM
	)

	blacklisted_programs = list(/datum/computer_file/program/deck_management,/datum/computer_file/program/docking)

/datum/map/glloydstation/perform_map_generation()
	new /datum/random_map/automata/cave_system(null, 1, 1, 5, 255, 255) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, 5, 64, 64)         // Create the mining ore distribution map.
	return 1

/obj/effect/overmap/sector/urist
	name = "NSS Urist"
	desc = "Starbase records report: NT owned, unknown crew status."
	base = TRUE
	start_x = 11
	start_y = 12

/obj/effect/overmap/sector/uristplanet
	name = "Nyx Phi III"
	desc = "Geneseeded world detected, possible intelligent life detected."
	base = TRUE
	start_x = 12
	start_y = 13