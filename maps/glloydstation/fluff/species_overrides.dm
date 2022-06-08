//humans
/datum/species/human
	description = "Humanity originated in the Sol system, and over the last five centuries has spread \
	colonies across a wide swathe of space. They hold a wide range of forms and creeds.<br/><br/> \
	Although the Terran Confederacy maintains control over much of human-controlled space, it currently \
	exercises no control over megacorporations like NanoTrasen, who operate as distinct political entities. \
	Moreover, powerful corporate interests, rampant cyber and 	bio-augmentation, interstellar piracy, and \
	secretive factions make life on most human worlds tumultous at best."

	available_cultural_info = list(
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
			CULTURE_HUMAN_CETI,
			CULTURE_HUMAN_SPACER,
			CULTURE_HUMAN_SPAFRO,
			CULTURE_HUMAN_ORMA,
			CULTURE_HUMAN_NT,
			CULTURE_HUMAN_OTHER,
			CULTURE_OTHER
		)
	)

//machines
/datum/species/machine
	available_cultural_info = list(
		TAG_CULTURE = list(
			CULTURE_POSITRONICS
		),
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_ROOT,
			HOME_SYSTEM_EARTH,
			HOME_SYSTEM_LUNA,
			HOME_SYSTEM_MARS,
			HOME_SYSTEM_VENUS,
			HOME_SYSTEM_CERES,
			HOME_SYSTEM_PLUTO,
			HOME_SYSTEM_TAU_CETI,
			HOME_SYSTEM_OTHER
		),
		TAG_FACTION = list(
			FACTION_POSITRONICS,
			FACTION_SOL_CENTRAL,
			FACTION_NANOTRASEN,
			FACTION_FREETRADE,
			FACTION_XYNERGY,
			FACTION_OTHER
		)
	)

	default_cultural_info = list(
		TAG_CULTURE = CULTURE_POSITRONICS,
		TAG_HOMEWORLD = HOME_SYSTEM_ROOT,
		TAG_FACTION = FACTION_POSITRONICS
	)