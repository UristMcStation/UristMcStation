/datum/map/wyrm
	name = "Wyrm"
	full_name = "ISC Wyrm"
	path = "wyrm"

	current_lobby_screen = 'icons/default_lobby.png'

	station_levels = list(1,2)
	contact_levels = list(1,2)
	player_levels = list(1,2)
	admin_levels = list(3)
	empty_levels = list(4)
	accessible_z_levels = list("1"=5,"2"=5,"4"=50)
	overmap_size = 30
	overmap_event_areas = 25
//	usable_email_tlds = list("torch.ec.scg", "torch.fleet.mil", "torch.marine.mil", "freemail.nt")

	allowed_spawns = list("Cryogenic Storage", "Cyborg Storage")
	default_spawn = "Cryogenic Storage"

	station_name  = "ISC Wyrm"
	station_short = "Wyrm"
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

	evac_controller_type = /datum/evacuation_controller/starship

	default_law_type = /datum/ai_laws/manifest
	use_overmap = 1

	num_exoplanets = 1
	planet_size = list(129,129)

	away_site_budget = 5

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
		TAG_FACTION =   FACTION_OTHER,
		TAG_CULTURE =   CULTURE_HUMAN_MARTIAN,
		TAG_RELIGION =  RELIGION_AGNOSTICISM
	)

/datum/map/wyrm/setup_map()
	..()
	system_name = generate_system_name()
	minor_announcement = new(new_sound = sound('sound/AI/torch/commandreport.ogg', volume = 45))

/datum/map/wyrm/send_welcome()
	var/obj/effect/overmap/visitable/ship/wyrm = SSshuttle.ship_by_type(/obj/effect/overmap/visitable/ship/wyrm)

	var/welcome_text = "<center><br /><font size = 3><b>ISC Wyrm</b> Sensor Readings:</font><hr />"
	welcome_text += "Report generated on [stationdate2text()] at [stationtime2text()]</center><br /><br />"
	welcome_text += "Current system:<br /><b>[wyrm ? system_name : "Unknown"]</b><br />"
	if(wyrm)
		welcome_text += "Next system targeted for jump:<br /><b>[generate_system_name()]</b><br />"
		welcome_text += "Travel time to Sol:<br /><b>[rand(5,10)] days</b><br />"
		welcome_text += "Time since last port visit:<br /><b>[rand(30,50)] days</b><br />"
		welcome_text += "Scan results:<br />"
		var/list/space_things = list()
		var/obj/effect/overmap/torch = map_sectors["1"]
		for(var/zlevel in map_sectors)
			var/obj/effect/overmap/O = map_sectors[zlevel]
			if(O.name == torch.name)
				continue
			space_things |= O

		for(var/obj/effect/overmap/O in space_things)
			var/location_desc = " at present co-ordinates."
			if (O.loc != torch.loc)
				var/bearing = round(90 - Atan2(O.x - torch.x, O.y - torch.y),5) //fucking triangles how do they work
				if(bearing < 0)
					bearing += 360
				location_desc = ", bearing [bearing]."
			welcome_text += "<li>\A <b>[O.name]</b>[location_desc]</li>"
		welcome_text += "<br>No distress calls logged.<br />"

	post_comm_message("ISC Wyrm Sensor Readings", welcome_text)
	minor_announcement.Announce(message = "New Astrogation Update available at all communication consoles.")
