/datum/map/nerva

	holodeck_programs = list(
		"battle arena"		= new/datum/holodeck_program(/area/holodeck/source_battle_arena, list('sound/music/THUNDERDOME.ogg')),
		"beach sim"			= new/datum/holodeck_program(/area/holodeck/source_beach, list()),
		"winter sim"		= new/datum/holodeck_program(/area/holodeck/source_winter, list(
															'sound/effects/wind/wind_2_1.ogg',
											 				'sound/effects/wind/wind_2_2.ogg',
											 				'sound/effects/wind/wind_3_1.ogg',
											 				'sound/effects/wind/wind_4_1.ogg',
											 				'sound/effects/wind/wind_4_2.ogg',
											 				'sound/effects/wind/wind_5_1.ogg'
												 			)
		 												),
		"desert"           = new/datum/holodeck_program(/area/holodeck/source_desert,
														list(
															'sound/effects/wind/wind_2_1.ogg',
											 				'sound/effects/wind/wind_2_2.ogg',
											 				'sound/effects/wind/wind_3_1.ogg',
											 				'sound/effects/wind/wind_4_1.ogg',
											 				'sound/effects/wind/wind_4_2.ogg',
											 				'sound/effects/wind/wind_5_1.ogg'
												 			)
		 												),
		"space"            = new/datum/holodeck_program(/area/holodeck/source_space,
														list(
															'sound/ambience/ambispace.ogg',
															'sound/music/main.ogg',
															'sound/music/space.ogg',
															'sound/music/traitor.ogg',
															)
														),
		"chapel"			= new/datum/holodeck_program(/area/holodeck/source_chapel, list()),
		"emptycourt"        = new/datum/holodeck_program(/area/holodeck/source_emptycourt, list('sound/music/THUNDERDOME.ogg')),
		"boxingcourt"       = new/datum/holodeck_program(/area/holodeck/source_boxingcourt, list('sound/music/THUNDERDOME.ogg')),
		"basketball"        = new/datum/holodeck_program(/area/holodeck/source_basketball, list('sound/music/THUNDERDOME.ogg')),
		"thunderdomecourt"  = new/datum/holodeck_program(/area/holodeck/source_thunderdomecourt, list('sound/music/THUNDERDOME.ogg')),
		"picnicarea"        = new/datum/holodeck_program(/area/holodeck/source_picnicarea, list('sound/music/title2.ogg')),
		"theatre"           = new/datum/holodeck_program(/area/holodeck/source_theatre),
		"meetinghall"       = new/datum/holodeck_program(/area/holodeck/source_meetinghall),
		"courtroom"         = new/datum/holodeck_program(/area/holodeck/source_courtroom, list('sound/music/traitor.ogg')),
		"volleyball"        = new/datum/holodeck_program(/area/holodeck/source_volleyball, list('sound/music/THUNDERDOME.ogg')),
		"wildlifecarp"      = new/datum/holodeck_program(/area/holodeck/source_wildlife, list()),
		"plaza"             = new/datum/holodeck_program(/area/holodeck/source_plaza),
		"cafe"              = new/datum/holodeck_program(/area/holodeck/source_cafe),
		"gym"               = new/datum/holodeck_program(/area/holodeck/source_gym),
		"turnoff"			= new/datum/holodeck_program(/area/holodeck/source_plating, list()),
		"christmas"         = new/datum/holodeck_program(/area/holodeck/source_christmas,  list('sound/effects/wind/tundra0.ogg')),
		"jungle"            = new/datum/holodeck_program(/area/holodeck/source_jungle,  list('sound/ambience/jungle.ogg')),
		"ocean"             = new/datum/holodeck_program(/area/holodeck/source_ocean,	list('sound/ambience/shore.ogg')),
		"rainycafe"         = new/datum/holodeck_program(/area/holodeck/source_rainycafe,	list('sound/ambience/rain_01.ogg'))



	)

	holodeck_supported_programs = list(

		"NervaMainPrograms" = list(
			"Battle Arena"       = "battle arena",
			"Beach Simulation"   = "beach sim",
			"Winter Simulation"  = "winter sim",
			"Holographic Chapel" = "chapel",
			"Basketball Court"   = "basketball",
			"Boxing Ring"        = "boxingcourt",
			"Courtroom"          = "courtroom",
			"Empty Court"        = "emptycourt",
			"Meeting Hall"       = "meetinghall",
			"Picnic Area"        = "picnicarea",
			"Theatre"            = "theatre",
			"Thunderdome Court"  = "thunderdomecourt",
			"Volleyball Court"   = "volleyball",
			"Plaza"              = "plaza",
			"Cafe"               = "cafe",
			"Desert"             = "desert",
			"Gym"                = "gym",
			"Space"              = "space",
			"Christmas"          = "christmas",
			"Jungle"             = "jungle",
			"Ocean"              = "ocean",
			"Rainy Cafe"         = "rainycafe"
		)

	)


	holodeck_restricted_programs = list(

		"NervaMainPrograms" = list(
			"Wildlife Simulation" = "wildlifecarp"
		)

	)

// Holo-Turf

/turf/simulated/floor/holofloor/urist/junglegrass_lightgreen
	name =  "wet grass"
	desc = "Perfectly simulated hot and humid climate included!"
	base_desc = "Perfectly simulated hot and humid climate included!."
	icon = 'icons/jungle.dmi'
	icon_state = "grass4"
	footstep_type = /singleton/footsteps/grass

/turf/simulated/floor/holofloor/urist/junglegrass_green
	name =  "wet grass"
	desc = "Perfectly simulated hot and humid climate included!"
	base_desc = "Perfectly simulated hot and humid climate included!."
	icon = 'icons/jungle.dmi'
	icon_state = "grass3"
	footstep_type = /singleton/footsteps/grass

/turf/simulated/floor/holofloor/urist/junglegrass_darkgreen
	name =  "wet grass"
	desc = "Perfectly simulated hot and humid climate included!"
	base_desc = "Perfectly simulated hot and humid climate included!."
	icon = 'icons/jungle.dmi'
	icon_state = "grass2"
	footstep_type = /singleton/footsteps/grass

/turf/simulated/floor/holofloor/urist/junglegrass_browngreen
	name =  "wet grass"
	desc = "Perfectly simulated hot and humid climate included!"
	base_desc = "Perfectly simulated hot and humid climate included!."
	icon = 'icons/jungle.dmi'
	icon_state = "grass1"
	footstep_type = /singleton/footsteps/grass

/turf/simulated/floor/holofloor/urist/jungle_water
	name =  "murky water"
	desc = "Holographic deep, dank water. You swear you can see something moving below occasionally."
	base_desc = "Holographic deep, dank water. You swear you can see something moving below occasionally."
	icon = 'icons/urist/jungle/turfs.dmi'
	icon_state = "rivernew"
	footstep_type = /singleton/footsteps/water

/turf/simulated/floor/holofloor/urist/pavement
	name = "Pavement"
	desc = "It's pavement, they've even simulated all the dry gum!"
	base_desc = "It's pavement, they've even simulated all the dry gum!"
	icon = 'icons/urist/citymap_icons/pavement.dmi'
	icon_state = "pavement"
	footstep_type = /singleton/footsteps/tiles

/turf/simulated/floor/holofloor/urist/pavement_empty
	name = "Pavement"
	desc = "It's pavement, they've even simulated all the dry gum!"
	base_desc = "It's pavement, they've even simulated all the dry gum!"
	icon = 'icons/urist/citymap_icons/pavement.dmi'
	icon_state = "pave_empty"
	footstep_type = /singleton/footsteps/tiles
