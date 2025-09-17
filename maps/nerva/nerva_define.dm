/datum/map/nerva
	name = "\improper Nerva"
	full_name = "\improper ICS Nerva"
	path = "nerva"
	config_path = "config/nerva_config.txt"

	station_levels = list(1,2,3,4)
	contact_levels = list(1,2,3,4)
	player_levels = list(1,2,3,4)
	admin_levels = list(5)
	empty_levels = list(6)
	accessible_z_levels = list("1"=5,"2"=5,"3"=5,"4"=5,"6"=30)
	overmap_size = 36
	overmap_event_areas = 32
	usable_email_tlds = list ("freemail.net", "nerva.ics, nerva.nt") // Free, Intranet, NT

	allowed_spawns = list("Cryogenic Storage", "Secondary Cryogenic Storage", "Cyborg Storage")
	default_spawn = "Cryogenic Storage"

	station_name  = "\improper ICS Nerva"
	station_short = "\improper Nerva"
	dock_name     = "TBD"
	boss_name     = "Automated Announcement Systems"
	boss_short    = "AAS"
	company_name  = "Automated Announcement Systems"
	company_short = "AAS"
	ert_context = "The Emergency Response Team works for Asset Protection; your job is to protect NanoTrasen's ass-ets. There is a severe emergency on the ICS Nerva and you are tasked to go and fix the problem.\nYou should first gear up and discuss a plan with your team. More members may be joining, don't move out before you're ready."

	map_admin_faxes = list(
		"Nanotrasen Central Office",
		"Nanotrasen Research & Development Sector",
		"Terran Confederacy Sector Headquarters",
		"United Human Alliance Outpost",
		"Pirate Listening Post" // maybe not this, we'll see
	)

	shuttle_docked_message = "Attention all hands: Jump preparation complete. The bluespace drive is now spooling up, secure all stations for departure. Time to jump: approximately %ETD%."
	shuttle_leaving_dock = "Attention all hands: Jump initiated, exiting bluespace in %ETA%."
	shuttle_called_message = "Attention all hands: Jump sequence initiated. Transit procedures are now in effect. Jump in %ETA%."
	shuttle_recall_message = "Attention all hands: Jump sequence aborted, return to normal operating conditions."

	evac_controller_type = /datum/evacuation_controller/starship

	default_law_type = /datum/ai_laws/manifest
	use_overmap = 1
	num_exoplanets = 1

	away_site_budget = 5
	min_offmap_players = 0

	id_hud_icons = 'maps/nerva/icons/assignment_hud.dmi'
	welcome_sound = 'sound/AI/welcome.ogg'

	use_bluespace_interlude = FALSE // nah.

	using_new_cargo = TRUE //this var inits the stuff related to the contract system, the new trading system, and other misc things including the endround station profit report.
	new_cargo_inflation = 45 //used to calculate how much points are now. this needs balancing //i didn't make this clear, it's the original point value times this number
	trading_faction = /datum/factions/nanotrasen //this is used to determine rep points/bonuses from trading and certain contracts
	logo = "\[nervalogo\]"
