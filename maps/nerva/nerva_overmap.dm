/obj/overmap/visitable/ship/combat/nerva
	name = "ICS Nerva"
	ship_name = "ICS Nerva"
	classification = "large class vessel"	//???
	shipid = "nerva"
	vessel_mass = 25000 //bigger than wyrm, smaller than torch //:fuckbay:
	fore_dir = EAST
	start_x = 6
	start_y = 7
	can_board = TRUE
	target_x_bounds = list(78,165)
	target_y_bounds = list(63,130)
	announcement_channel = list("public" = "Common", "private" = "Command", "technical" = "Engineering", "combat" = "Combat")
	evac_x = 143
	evac_y = 97
	evac_z = 3
	target_zs = list(1,2,3)
	target_dirs = list(NORTH, SOUTH, EAST)
	sector_flags = OVERMAP_SECTOR_KNOWN|OVERMAP_SECTOR_IN_SPACE|OVERMAP_SECTOR_BASE
	known_ships = list(
		/obj/overmap/visitable/ship/landable/trajan,
		/obj/overmap/visitable/ship/landable/hadrian
	)

	initial_generic_waypoints = list(
		"nerva_north_dock",
		"nerva_south_dock",
		"nav_deck1_antonine",
		"nav_deck2_antonine",
		"nav_deck3_antonine",
		"nav_deck4_antonine",
		"nav_deck1_trajan",
		"nav_deck2_trajan",
		"nav_deck3_trajan",
		"nav_deck4_trajan",
		"nav_deck1_hadrian",
		"nav_deck2_hadrian",
		"nav_deck3_hadrian",
		"nav_deck4_hadrian"
	)

	initial_restricted_waypoints = list(
		"Trajan" = list("nav_hangar_trajan"),
		"Antonine" = list("nav_hangar_antonine"),
		"Transport" = list("nav_ferry_out"),
		"Hadrian" = list("nav_hangar_hadrian"),
		"Mercenary" = list("nav_merc_dock")
	)

	hostile_factions = list(
		"pirate",
		"xenos",
		"hostile"
	)

/obj/overmap/visitable/ship/combat/nerva/Initialize()
	GLOB.using_map.overmap_ship = src

	.=..()

/obj/overmap/visitable/ship/landable/trajan
	name = "Trajan"
	shuttle = "Trajan"
	fore_dir = NORTH
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_SMALL
	known_ships = list(
		/obj/overmap/visitable/ship/combat/nerva,
		/obj/overmap/visitable/ship/landable/hadrian
	)

/obj/overmap/visitable/ship/landable/hadrian
	name = "Hadrian"
	shuttle = "Hadrian"
	fore_dir = EAST
	vessel_mass = 750
	vessel_size = SHIP_SIZE_TINY
	known_ships = list(
		/obj/overmap/visitable/ship/combat/nerva,
		/obj/overmap/visitable/ship/landable/trajan
	)

/obj/overmap/visitable/ship/combat/nerva/pve_mapfire(projectile_type)
	if(ispath(projectile_type))
		var/turf/start_turf = spaceDebrisStartLoc(pick(GLOB.cardinal), 6)
		var/turf/target_turf = locate(100, 100, 6) //set up values for enemy ships
		launch_atom(projectile_type, start_turf, target_turf)
