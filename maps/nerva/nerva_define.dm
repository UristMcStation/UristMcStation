/datum/map/nerva
	name = "Nerva"
	full_name = "ICS Nerva"
	path = "nerva"

	lobby_icon = 'maps/glloydstation/glloydstation_lobby.dmi'

	station_levels = list(1,2,3)
	contact_levels = list(1,2,3)
	player_levels = list(1,2,3)
	admin_levels = list(4)
	empty_levels = list(5)
	accessible_z_levels = list("1"=5,"2"=5,"3"=5)
	overmap_size = 30
	overmap_event_areas = 25

	allowed_spawns = list("Cryogenic Storage", "Cyborg Storage")
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

	evac_controller_type = /datum/evacuation_controller/starship

	default_law_type = /datum/ai_laws/manifest
	use_overmap = 1

	num_exoplanets = 1
	planet_size = list(129,129)

	away_site_budget = 5

	citizenship_choices = list(
		"Earth",
		"Mars",
		"New Earth",
		"Luna",
		"Ryclies I",
		"Venus",
		"Moghes",
		"Qerrbalak",
		"Reade III",
		"Procyon"
	)

	home_system_choices = list(
		"Sol",
		"Nyx",
		"Tau Ceti",
		"Epsilon Ursae Minoris",
		"Gilgamesh",
		"Ryclies",
		"Reade"
		)

	faction_choices = list(
		"Terran Confederacy",
		"Outer Rim Miners Alliance",
		"Vey Med",
		"Einstein Engines",
		"Free Trade Union",
		"NanoTrasen",
		"Ward-Takahashi GMB",
		"Gilthari Exports",
		"Grayson Manufactories Ltd.",
		"Aether Atmospherics",
		"Zeng-Hu Pharmaceuticals",
		"Hephaestus Industries",
		)


/datum/map/nerva/setup_map()
	..()
	system_name = generate_system_name()
	minor_announcement = new(new_sound = sound('sound/AI/torch/commandreport.ogg', volume = 45))

/datum/map/wyrm/send_welcome()
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