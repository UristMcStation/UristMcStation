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
/singleton/cultural_info/culture/ipc
	description = "Positronic intelligence is an emerging technology in the workforce, and you are one of the prototypes. \
	IPCs (Integrated Positronic Chassis) are a loose category of self-willed robots with a humanoid form. They are \
	reliable and dedicated workers, albeit more than slightly inhuman in outlook and perspective. <br><br> Typical positronic brains \
	are roughly as intelligent as a human on the smarter side of average, and are fast learners.

/datum/species/machine
	available_cultural_info = list(
		TAG_CULTURE = list(
			CULTURE_POSITRONICS
		),
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_MARS,
			HOME_SYSTEM_LUNA,
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
			HOME_SYSTEM_RYCLIES,
			HOME_SYSTEM_READE,
			HOME_SYSTEM_PROCYON,
			HOME_SYSTEM_OTHER
		),
		TAG_FACTION = list(
			FACTION_OTHER,
			FACTION_NANOTRASEN,
			FACTION_XYNERGY,
			FACTION_HEPHAESTUS,
			FACTION_SOL_CENTRAL,
			FACTION_INDIE_CONFED,
			FACTION_FREETRADE,
			FACTION_ORMA
		)
	)

	default_cultural_info = list(
		TAG_CULTURE = CULTURE_POSITRONICS,
		TAG_HOMEWORLD = HOME_SYSTEM_MARS,
		TAG_FACTION = FACTION_POSITRONICS
	)
