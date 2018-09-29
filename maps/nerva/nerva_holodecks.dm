/datum/map/nerva

	holodeck_programs = list(
		"battle arena"		= new/datum/holodeck_program(/area/holodeck/source_battle_arena, list('sound/music/THUNDERDOME.ogg')),
		"beach sim"			= new/datum/holodeck_program(/area/holodeck/source_beach, list()),
		"winter sim"		= new/datum/holodeck_program(/area/holodeck/source_winter, list()),
		"chapel"			= new/datum/holodeck_program(/area/holodeck/source_chapel, list()),
		"turnoff"			= new/datum/holodeck_program(/area/holodeck/source_plating, list())
	)

	holodeck_supported_programs = list(

		"NervaMainPrograms" = list(
			"Battle Arena"       = "battle arena",
			"Beach Simulation"   = "beach sim",
			"Winter Simulation"  = "winter sim",
			"Holographic Chapel" = "chapel"
		)

	)