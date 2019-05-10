/obj/effect/overmap/ship/combat/nerva
	name = "ICS Nerva"
	shipid = "nerva"
	vessel_mass = 200 //bigger than wyrm, smaller than torch
	fore_dir = EAST
	start_x = 6
	start_y = 7
	can_board = TRUE

	evac_x = 142
	evac_y = 106
	evac_z = 2

	initial_generic_waypoints = list(
		"nav_deck1_antonine",
		"nav_deck2_antonine",
		"nav_deck3_antonine",
		"nav_deck1_trajan",
		"nav_deck2_trajan",
		"nav_deck3_trajan",
		"nav_deck1_hadrian",
		"nav_deck2_hadrian",
		"nav_deck3_hadrian"
	)

	initial_restricted_waypoints = list(
		"Trajan" = list("nav_hangar_trajan"),
		"Antonine" = list("nav_hangar_antonine"),
		"Transport" = list("nav_ferry_out"),
		"Hadrian" = list("nav_hangar_hadrian")
	)

	hostile_factions = list(
		"pirate",
		"xenos",
		"hostile"
	)

/obj/effect/overmap/ship/combat/nerva/Initialize()
	GLOB.using_map.overmap_ship = src

	.=..()