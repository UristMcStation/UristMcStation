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
	ert_context = "NanoTrasen"
	lobby_screens = list('maps/glloydstation/glloydstation_lobby.png')
	current_lobby_screen = 'maps/glloydstation/glloydstation_lobby.png'

	station_levels = list(1)
	admin_levels = list(2)
	contact_levels = list(1,2,5,6,7)
	player_levels = list(1,3,4,5,6,7)
	sealed_levels = list(6)
	empty_levels = list(6)
	base_turf_by_z = list("5" = /turf/simulated/floor/asteroid/glloydplanet, "7" = /turf/simulated/floor/planet/jungle/clear)
	accessible_z_levels = list("1"=15, "3"=15, "4"=25, "6"=35)

	id_hud_icons = 'maps/glloydstation/icons/assignment_hud.dmi'
	logo = "bluentlogo.png"

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

	has_skybox_image = TRUE

	blacklisted_programs = list(/datum/computer_file/program/deck_management,/datum/computer_file/program/docking)

	game_year = 2556 //forever trapped in time

	objective_items = list(
		"the captain's antique laser gun" = /obj/item/gun/energy/captain,
		"a bluespace rift generator" = /obj/item/integrated_circuit/manipulation/bluespace_rift,
		"a captain's jumpsuit" = /obj/item/clothing/under/rank/captain,
		"a functional AI" = /obj/item/aicard,
		"the NSS Urist blueprints" = /obj/item/blueprints,
		"a piece of corgi meat" = /obj/item/reagent_containers/food/snacks/meat/corgi,
		"a research director's jumpsuit" = /obj/item/clothing/under/rank/research_director,
		"a chief engineer's jumpsuit" = /obj/item/clothing/under/rank/chief_engineer,
		"a head of security's jumpsuit" = /obj/item/clothing/under/rank/head_of_security,
		"a head of personnel's jumpsuit" = /obj/item/clothing/under/rank/head_of_personnel,
		"the captain's pinpointer" = /obj/item/pinpointer
		)

/obj/effect/overmap/visitable/urist
	name = "NSS Urist"
	desc = "Starbase records report: NT owned, unknown crew status."
	base = TRUE
	start_x = 11
	start_y = 12

/obj/effect/overmap/visitable/uristplanet
	name = "Nyx Phi III"
	desc = "Geneseeded world detected, possible intelligent life detected."
	base = TRUE
	start_x = 12
	start_y = 13