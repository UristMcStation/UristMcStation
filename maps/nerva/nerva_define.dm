/datum/map/nerva
	name = "Nerva"
	full_name = "ICS Nerva"
	path = "nerva"

	lobby_icon = 'maps/nerva/nerva_lobby.dmi'

	station_levels = list(1,2,3)
	contact_levels = list(1,2,3)
	player_levels = list(1,2,3)
	admin_levels = list(4)
	empty_levels = list(5)
	accessible_z_levels = list("1"=5,"2"=5,"3"=5)
	overmap_size = 36
	overmap_event_areas = 32

	allowed_spawns = list("Cryogenic Storage", "Secondary Cryogenic Storage", "Cyborg Storage")
	default_spawn = "Cryogenic Storage"

	station_name  = "ICS Nerva"
	station_short = "Nerva"
	dock_name     = "TBD"
	boss_name     = "Automated Announcement Systems"
	boss_short    = "AAS"
	company_name  = "Automated Announcement Systems"
	company_short = "AAS"

	map_admin_faxes = list("Automated Announcement System")

	shuttle_docked_message = "Attention all hands: Jump preparation complete. The bluespace drive is now spooling up, secure all stations for departure. Time to jump: approximately %ETD%."
	shuttle_leaving_dock = "Attention all hands: Jump initiated, exiting bluespace in %ETA%."
	shuttle_called_message = "Attention all hands: Jump sequence initiated. Transit procedures are now in effect. Jump in %ETA%."
	shuttle_recall_message = "Attention all hands: Jump sequence aborted, return to normal operating conditions."

	starting_money = 20000		//Money in station account //tweak this value
	department_money = 1000		//Money in department accounts
	salary_modifier	= 1			//Multiplier to starting character money

	supply_currency_name = "Thalers"
	supply_currency_name_short = "Th."

	using_new_cargo = 1 //this var inits the stuff related to the contract system, the new trading system, and other misc things including the endround station profit report.
	new_cargo_inflation = 45 //used to calculate how much points are now. this needs balancing

	evac_controller_type = /datum/evacuation_controller/starship

	default_law_type = /datum/ai_laws/manifest
	use_overmap = 1

	num_exoplanets = 2
	planet_size = list(129,129)

	away_site_budget = 6

	date_offset = 564
	available_cultural_info = list(
		TAG_HOMEWORLD = list(
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
			HOME_SYSTEM_RYCLIES,
			HOME_SYSTEM_READE,
			HOME_SYSTEM_PROCYON,
			HOME_SYSTEM_OTHER
		),
		TAG_FACTION = list(
			FACTION_NANOTRASEN,
			FACTION_XYNERGY,
			FACTION_HEPHAESTUS,
			FACTION_PCRC,
			FACTION_ORMA,
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
			CULTURE_HUMAN_CETI,
			CULTURE_HUMAN_SPACER,
			CULTURE_HUMAN_SPAFRO,
			CULTURE_HUMAN_CONFED,
			CULTURE_HUMAN_UHA_OFFTERRA,
			CULTURE_HUMAN_ORMA,
			CULTURE_HUMAN_NT,
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
		),
		TAG_EDUCATION = list(
			EDUCATION_NONE,
			EDUCATION_DROPOUT,
			EDUCATION_HIGH_SCHOOL,
			EDUCATION_TRADE_SCHOOL,
			EDUCATION_UNDERGRAD,
			EDUCATION_MASTERS,
			EDUCATION_DOCTORATE,
			EDUCATION_MEDSCHOOL
		)

	)

	default_cultural_info = list(
		TAG_HOMEWORLD = HOME_SYSTEM_MARS,
		TAG_FACTION =   FACTION_SOL_CENTRAL,
		TAG_CULTURE =   CULTURE_HUMAN_MARTIAN,
		TAG_RELIGION =  RELIGION_AGNOSTICISM
	)


	base_floor_type = /turf/simulated/floor/reinforced/airless
	base_floor_area = /area/maintenance/exterior

/datum/map/nerva/setup_map()
	..()
	system_name = generate_system_name()
	minor_announcement = new(new_sound = sound('sound/AI/torch/commandreport.ogg', volume = 45))
	contracts += new /datum/contract/nanotrasen/anomaly

/datum/map/nerva/map_info(victim)
	to_chat(victim, "<h2>Current map information</h2>")
	to_chat(victim, "You're aboard the <b>ICS Nerva</b>, an independently contracted vessel owned by the Captain. Its primary mission is whatever the Captain dictates, which can include trading, scavenging or exploration.")
	to_chat(victim, "The vessel is staffed with a mix of personnel, hailing from multiple different backgrounds and factions. While the ship itself is an independently contracted vessel, the crew may have their own loyalties.")
	to_chat(victim, "This area of space is on the frontier, and is largely unsettled and unexplored. Any extensive settlements were destroyed during the Galactic Crisis.")
	to_chat(victim, "You might encounter remote outposts, pirates, or drifting hulks, but no one faction can claim to fully control this sector.")

/datum/map/nerva/send_welcome()
	var/welcome_text = "<center><br /><font size = 3><b>ICS Nerva</b> Sensor Readings:</font><hr />"
	welcome_text += "Report generated on [stationdate2text()] at [stationtime2text()]</center><br /><br />"
	welcome_text += "Current system:<br /><b>[system_name()]</b><br />"
	welcome_text += "Next system targeted for jump:<br /><b>[generate_system_name()]</b><br />"
	welcome_text += "Travel time to Sol:<br /><b>[rand(5,10)] days</b><br />"
	welcome_text += "Time since last port visit:<br /><b>[rand(30,50)] days</b><br />"
	welcome_text += "Scan results:<br />"
	var/list/space_things = list()
	var/obj/effect/overmap/nerva = map_sectors["1"]
	for(var/zlevel in map_sectors)
		var/obj/effect/overmap/O = map_sectors[zlevel]
		if(O.name == nerva.name)
			continue
		space_things |= O

	for(var/obj/effect/overmap/O in space_things)
		var/location_desc = " at present co-ordinates."
		if (O.loc != nerva.loc)
			var/bearing = round(90 - Atan2(O.x - nerva.x, O.y - nerva.y),5) //fucking triangles how do they work
			if(bearing < 0)
				bearing += 360
			location_desc = ", bearing [bearing]."
		welcome_text += "<li>\A <b>[O.name]</b>[location_desc]</li>"
	welcome_text += "<br>No distress calls logged.<br />"

	post_comm_message("ICS Nerva Sensor Readings", welcome_text)
	minor_announcement.Announce(message = "New [GLOB.using_map.company_name] Update available at all communication consoles.")