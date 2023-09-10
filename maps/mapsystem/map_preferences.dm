/datum/map
	var/load_legacy_saves = FALSE

//below this is all Urist stuff for Nerva

	var/date_offset = 0 //date offset from the present. if you don't change this, the game year will default to 2556
	var/using_new_cargo = FALSE //for nerva //this var inits the stuff related to the contract system, the new trading system, and other misc things including the endround station profit report.
	var/new_cargo_inflation = 1 //used to calculate how much points are now (original point value multiplied by this number). this needs balancing
	var/list/contracts = list() //the current active contracts
	var/obj/effect/overmap/visitable/ship/combat/overmap_ship = null //this is for space combat, it is the overmap object used by the main map
	var/completed_contracts = 0 //this and destroyed_ships are used for endround stats
	var/contract_money = 0 //likewise
	var/destroyed_ships = 0
	var/datum/factions/trading_faction = null //this is used to determine rep points/bonuses from trading and certain contracts
	var/list/objective_items
	// List of /datum/department types to instantiate at roundstart.
	//var/list/departments = list(
	//	/datum/department/medbay
	//)
	var/logo = "exologo.png" // what is our default logo from the list of logos? Used for the logo macro
	var/list/blacklisted_programs = list()
	var/xenomorph_spawn_sound = sound('sound/AI/torch/aliens.ogg', volume = 45)

/datum/map/New()
	if(!map_levels)
		map_levels = station_levels.Copy()
	if(!allowed_jobs)
		allowed_jobs = list()
		for(var/jtype in subtypesof(/datum/job))
			var/datum/job/job = jtype
			if(initial(job.available_by_default))
				allowed_jobs += jtype
	if(!planet_size)
		planet_size = list(world.maxx, world.maxy)

/datum/map/proc/RoundEndInfo()
	return

/datum/map/proc/RoundEndBusiness()
	return 1
//urist stuff ends now

/datum/map/proc/preferences_key()
	// Must be a filename-safe string. In future if map paths get funky, do some sanitization here.
	return path

// Procs for loading legacy savefile preferences
/datum/map/proc/character_save_path(slot)
	return "/[path]/character[slot]"

/datum/map/proc/character_load_path(savefile/S, slot)
	var/original_cd = S.cd
	S.cd = "/"
	. = private_use_legacy_saves(S, slot) ? "/character[slot]" : "/[path]/character[slot]"
	S.cd = original_cd // Attempting to make this call as side-effect free as possible

/datum/map/proc/private_use_legacy_saves(savefile/S, slot)
	if(!load_legacy_saves) // Check if we're bothering with legacy saves at all
		return FALSE
	if(!S.dir.Find(path)) // If we cannot find the map path folder, load the legacy save
		return TRUE
	S.cd = "/[path]" // Finally, if we cannot find the character slot in the map path folder, load the legacy save
	return !S.dir.Find("character[slot]")
