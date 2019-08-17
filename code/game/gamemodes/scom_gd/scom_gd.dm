/datum/game_mode/scom_gd
	name = "SCOM Galactic Defense" //And by galactic I mean solar, but that doesn't sound interesting.
	config_tag = "scom_gd"
	round_description = "You've been assigned to defend the Ryclies system. Ensure protection of all planets, and yourself."
	extended_round_description = "The SCOM contigency force has been activated, and you've been conscripted to assist in defense against the alien menace. Attempt to protect all of the planets in your solar system."
	required_players = 1//5
	auto_recall_shuttle = 1
	end_on_antag_death = 1
	antag_tags = list(MODE_SCOM_GD)
	addantag_allowed = ADDANTAG_ADMIN

/datum/game_mode/scom_gd/on_selection()
	GLOB.using_map.allowed_jobs = list(/datum/job/scom/captain)
	job_master.ResetOccupations()
	world << "Standard job table overwriten, please reselect your job."

	if(GLOB.using_map.use_overmap)
		for(var/square in block(locate(1,1,GLOB.using_map.overmap_z), locate(GLOB.using_map.overmap_size,GLOB.using_map.overmap_size,GLOB.using_map.overmap_z)))
			var/turf/T = square
			for(var/obj/O in T)
				qdel(O)
	else
		GLOB.using_map.use_overmap = TRUE
		build_overmap()
	world << "Overmap prepared"

	GLOB.latejoin = list()
	GLOB.latejoin_cryo = list()
	GLOB.latejoin_cyborg = list()

	maploader.load_map('maps/templates/scomhq.dmm')
	maploader.load_map('maps/templates/scomcruiser.dmm')
	world << "SCOM Z-levels setup"

