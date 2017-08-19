/datum/map/wyrm
	name = "Wyrm"
	full_name = "ISC Wyrm"
	path = "wyrm"

	lobby_icon = 'maps/torch/icons/lobby.dmi'

	station_levels = list(1,2)
	contact_levels = list(1,2)
	player_levels = list(1,2)
	admin_levels = list(3)
	empty_levels = list(4)
	accessible_z_levels = list("1"=5,"2"=5,"4"=50)
	overmap_size = 40
	overmap_event_areas = 30
//	usable_email_tlds = list("torch.ec.scg", "torch.fleet.mil", "torch.marine.mil", "freemail.nt")
	base_turf_by_z = list("5" = /turf/simulated/floor/plating/planet/jungle/clear)

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

	//These should probably be moved into the evac controller...
	shuttle_docked_message = "Attention all hands: Jump preparation complete. The bluespace drive is now spooling up, secure all stations for departure. Time to jump: approximately %ETD%."
	shuttle_leaving_dock = "Attention all hands: Jump initiated, exiting bluespace in %ETA%."
	shuttle_called_message = "Attention all hands: Jump sequence initiated. Transit procedures are now in effect. Jump in %ETA%."
	shuttle_recall_message = "Attention all hands: Jump sequence aborted, return to normal operating conditions."

	evac_controller_type = /datum/evacuation_controller/starship

	default_law_type = /datum/ai_laws/solgov
	use_overmap = 1

/datum/map/wyrm/setup_map()
	..()
	system_name = generate_system_name()
	minor_announcement = new(new_sound = sound('sound/AI/torch/commandreport.ogg', volume = 45))

/datum/map/wyrm/send_welcome()
	var/welcome_text = "<center><br /><font size = 3><b>ISC Wyrm</b> Sensor Readings:</font><hr />"
	welcome_text += "Report generated on [stationdate2text()] at [stationtime2text()]</center><br /><br />"
	welcome_text += "Current system:<br /><b>[system_name()]</b><br />"
	welcome_text += "Next system targeted for jump:<br /><b>[generate_system_name()]</b><br />"
	welcome_text += "Travel time to Sol:<br /><b>[rand(15,45)] days</b><br />"
	welcome_text += "Time since last port visit:<br /><b>[rand(60,180)] days</b><br />"
	welcome_text += "Scan results:<br />"
	var/list/scan_results = list()
	for(var/poi in points_of_interest)
		if(poi == "TBD")
			continue
		if(isnull(scan_results[poi]))
			scan_results[poi] = 1
		else
			scan_results[poi] += 1
	for(var/result in scan_results)
		var/count = scan_results[result]
		if(count == 1)
			welcome_text += "\A <b>[result]</b><br />"
		else
			welcome_text += "[count] <b>[result]\s</b><br />"

	post_comm_message("ISC Wyrm Sensor Readings", welcome_text)
	minor_announcement.Announce(message = "New [GLOB.using_map.company_name] Update available at all communication consoles.")

/datum/map/wyrm/perform_map_generation()
	new /datum/random_map/automata/cave_system(null,1,1,1,world.maxx,world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null,1,1,1,64, 64)             // Create the mining ore distribution map.
	return 1