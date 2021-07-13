/datum/map/nerva
	name = "Nerva"
	full_name = "ICS Nerva"
	path = "nerva"

	lobby_icon = 'maps/nerva/nerva_lobby.dmi'

	station_levels = list(1,2,3,4)
	contact_levels = list(1,2,3,4)
	player_levels = list(1,2,3,4)
	admin_levels = list(5)
	empty_levels = list(6)
	accessible_z_levels = list("1"=5,"2"=5,"3"=5,"4"=5,"6"=30)
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

	map_admin_faxes = list("NanoTrasen Central Office")

	shuttle_docked_message = "Attention all hands: Jump preparation complete. The bluespace drive is now spooling up, secure all stations for departure. Time to jump: approximately %ETD%."
	shuttle_leaving_dock = "Attention all hands: Jump initiated, exiting bluespace in %ETA%."
	shuttle_called_message = "Attention all hands: Jump sequence initiated. Transit procedures are now in effect. Jump in %ETA%."
	shuttle_recall_message = "Attention all hands: Jump sequence aborted, return to normal operating conditions."

	starting_money = 22000		//Money in station account //tweak this value
	department_money = 1000		//Money in department accounts
	salary_modifier	= 1			//Multiplier to starting character money

	supply_currency_name = "Thalers"
	supply_currency_name_short = "Th."

	using_new_cargo = TRUE //this var inits the stuff related to the contract system, the new trading system, and other misc things including the endround station profit report.
	new_cargo_inflation = 45 //used to calculate how much points are now. this needs balancing //i didn't make this clear, it's the original point value times this number
	trading_faction = /datum/factions/nanotrasen //this is used to determine rep points/bonuses from trading and certain contracts

	evac_controller_type = /datum/evacuation_controller/starship

	default_law_type = /datum/ai_laws/manifest
	use_overmap = 1

	num_exoplanets = 0

	away_site_budget = 7

	date_offset = 560

	base_floor_type = /turf/simulated/floor/reinforced/airless
	base_floor_area = /area/maintenance/exterior

	species_to_job_blacklist = list(
		/datum/species/unathi  = list(/datum/job/captain),
		/datum/species/skrell  = list(/datum/job/captain),
		/datum/species/machine = list(/datum/job/captain),
		/datum/species/diona   = list(/datum/job/captain),
		/datum/species/teshari = list(/datum/job/captain)
	)

/datum/map/nerva/setup_map()
	var/month = text2num(time2text(world.timeofday, "MM"))
	if(month == 6) //stolen from rainbow background code
		lobby_icon = 'maps/nerva/nerva_rainbow_lobby.dmi'
	..()
	system_name = generate_system_name()
	minor_announcement = new(new_sound = sound('sound/AI/torch/commandreport.ogg', volume = 45))
	SSsupply.movetime = 600 //cutting it in half to reduce waiting at the trading station

/datum/map/nerva/map_info(victim)
	to_chat(victim, "<h2>Current map information</h2>")
	to_chat(victim, "You're aboard the <b>ICS Nerva</b>, an independently contracted vessel owned by the Captain. Its primary mission is whatever the Captain dictates, which can include trading, scavenging or exploration.")
	to_chat(victim, "The vessel is staffed with a mix of personnel, hailing from multiple different backgrounds and factions. While the ship itself is an independently contracted vessel, the crew may have their own loyalties.")
	to_chat(victim, "This area of space is on the frontier, and is largely unsettled and unexplored. Any extensive settlements were destroyed during the Galactic Crisis.")
	to_chat(victim, "You might encounter remote outposts, pirates, or drifting hulks, but no one faction can claim to fully control this sector.")

/datum/map/nerva/send_welcome()
	contracts += new /datum/contract/nanotrasen/anomaly
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
		if(istype(O, /obj/effect/overmap/ship/landable)) //Don't show shuttles
			continue
		space_things |= O

	var/list/distress_calls
	for(var/obj/effect/overmap/O in space_things)
		var/location_desc = " at present co-ordinates."
		if (O.loc != nerva.loc)
			var/bearing = round(90 - Atan2(O.x - nerva.x, O.y - nerva.y),5) //fucking triangles how do they work
			if(bearing < 0)
				bearing += 360
			location_desc = ", bearing [bearing]."
		if(O.has_distress_beacon)
			LAZYADD(distress_calls, "[O.has_distress_beacon][location_desc]")
		welcome_text += "<li>\A <b>[O.name]</b>[location_desc]</li>"
	welcome_text += "<br>No distress calls logged.<br />"

	if(LAZYLEN(distress_calls))
		welcome_text += "<br><b>Distress calls logged:</b><br>[jointext(distress_calls, "<br>")]<br>"
	else
		welcome_text += "<br>No distress calls logged.<br />"
	welcome_text += "<hr>"

	post_comm_message("ICS Nerva Sensor Readings", welcome_text)
	minor_announcement.Announce(message = "New [GLOB.using_map.company_name] Update available at all communication consoles.")
