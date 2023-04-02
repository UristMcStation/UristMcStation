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

/*/datum/map/proc/setup_map()
	var/lobby_track_type
	if(lobby_tracks.len)
		lobby_track_type = pick(lobby_tracks)
	else
		lobby_track_type = pick(subtypesof(/music_track))

	lobby_track = Singletons.get(lobby_track_type)

	if(!date_offset)
		game_year = 2556

	world.update_status()

/datum/map/proc/send_welcome()
	return

/datum/map/proc/perform_map_generation()
	return

/datum/map/proc/build_away_sites()
#ifdef UNIT_TEST
	report_progress("Unit testing, so not loading away sites")
	return // don't build away sites during unit testing
#else
	report_progress("Loading away sites...")
	var/list/sites_by_spawn_weight = list()
	for (var/site_name in SSmapping.away_sites_templates)
		var/datum/map_template/ruin/away_site/site = SSmapping.away_sites_templates[site_name]

		if((site.template_flags & TEMPLATE_FLAG_SPAWN_GUARANTEED) && site.load_new_z()) // no check for budget, but guaranteed means guaranteed
			report_progress("Loaded guaranteed away site [site]!")
			away_site_budget -= site.cost
			continue

		sites_by_spawn_weight[site] = site.spawn_weight
	while (away_site_budget > 0 && sites_by_spawn_weight.len)
		var/datum/map_template/ruin/away_site/selected_site = pickweight(sites_by_spawn_weight)
		if (!selected_site)
			break
		sites_by_spawn_weight -= selected_site
		if(selected_site.cost > away_site_budget)
			continue
		var/starttime = world.timeofday
		if (selected_site.load_new_z())
			report_progress("Loaded away site [selected_site] in [(world.timeofday - starttime)/10] seconds!")
			away_site_budget -= selected_site.cost
	report_progress("Finished loading away sites, remaining budget [away_site_budget], remaining sites [sites_by_spawn_weight.len]")
#endif

/datum/map/proc/build_exoplanets()
	if(!use_overmap)
		return

	for(var/i = 0, i < num_exoplanets, i++)
		var/exoplanet_type = pick(subtypesof(/obj/effect/overmap/visitable/exoplanet))
		var/obj/effect/overmap/visitable/exoplanet/new_planet = new exoplanet_type(null, planet_size[1], planet_size[2])
		new_planet.build_level()

// Used to apply various post-compile procedural effects to the map.
/datum/map/proc/refresh_mining_turfs(var/zlevel)

	set background = 1
	set waitfor = 0

	for(var/thing in mining_walls["[zlevel]"])
		var/turf/simulated/mineral/M = thing
		M.update_icon()
	for(var/thing in mining_floors["[zlevel]"])
		var/turf/simulated/floor/asteroid/M = thing
		if(istype(M))
			M.updateMineralOverlays()

/datum/map/proc/get_network_access(var/network)
	return 0

// By default transition randomly to another zlevel
/datum/map/proc/get_transit_zlevel(var/current_z_level)
	var/list/candidates = GLOB.using_map.accessible_z_levels.Copy()
	candidates.Remove(num2text(current_z_level))

	if(!candidates.len)
		return current_z_level
	return text2num(pickweight(candidates))

/datum/map/proc/get_empty_zlevel()
	if(empty_levels == null)
		world.maxz++
		empty_levels = list(world.maxz)
	return pick(empty_levels)


/datum/map/proc/setup_economy()
	news_network.CreateFeedChannel("Nyx Daily", "[FACTION_SOL_CENTRAL] Minister of Information", 1, 1)
	news_network.CreateFeedChannel("The Gibson Gazette", "Editor Mike Hammers", 1, 1)

	for(var/loc_type in typesof(/datum/trade_destination) - /datum/trade_destination)
		var/datum/trade_destination/D = new loc_type
		weighted_randomevent_locations[D] = D.viable_random_events.len
		weighted_mundaneevent_locations[D] = D.viable_mundane_events.len

	if(!station_account)
		station_account = create_account("[station_name()] Primary Account", starting_money)

	for(var/job in allowed_jobs)
		var/datum/job/J = Singletons.get(job)
		if(J.department)
			station_departments |= J.department
	for(var/department in station_departments)
		department_accounts[department] = create_account("[department] Account", department_money)

	department_accounts["Vendor"] = create_account("Vendor Account", 0)
	vendor_account = department_accounts["Vendor"]

/datum/map/proc/map_info(var/client/victim)
	return

/datum/map/proc/bolt_saferooms()
	return // overriden by torch

/datum/map/proc/unbolt_saferooms()
	return // overriden by torch

/datum/map/proc/make_maint_all_access(var/radstorm = 0) // parameter used by torch
	maint_all_access = 1
	priority_announcement.Announce("The maintenance access requirement has been revoked on all maintenance airlocks.", "Attention!")

/datum/map/proc/revoke_maint_all_access(var/radstorm = 0) // parameter used by torch
	maint_all_access = 0
	priority_announcement.Announce("The maintenance access requirement has been readded on all maintenance airlocks.", "Attention!")

// Access check is of the type requires one. These have been carefully selected to avoid allowing the janitor to see channels he shouldn't
// This list needs to be purged but people insist on adding more cruft to the radio.
/datum/map/proc/default_internal_channels()
	return list(
		num2text(PUB_FREQ)   = list(),
		num2text(AI_FREQ)    = list(access_synth),
		num2text(ENT_FREQ)   = list(),
		num2text(ERT_FREQ)   = list(access_cent_specops),
		num2text(COMM_FREQ)  = list(access_bridge),
		num2text(ENG_FREQ)   = list(access_engine_equip, access_atmospherics),
		num2text(MED_FREQ)   = list(access_medical_equip),
		num2text(MED_I_FREQ) = list(access_medical_equip),
		num2text(SEC_FREQ)   = list(access_security),
		num2text(SEC_I_FREQ) = list(access_security),
		num2text(SCI_FREQ)   = list(access_tox,access_robotics,access_xenobiology),
		num2text(SUP_FREQ)   = list(access_cargo),
		num2text(SRV_FREQ)   = list(access_janitor, access_hydroponics),
	)
*/
/datum/map/proc/RoundEndInfo()
	if(all_money_accounts.len)
		var/datum/money_account/max_profit = all_money_accounts[1]
		var/datum/money_account/max_loss = all_money_accounts[1]
		for(var/datum/money_account/D in all_money_accounts)
			if(D == vendor_account) //yes we know you get lots of money
				continue
			var/saldo = D.get_balance()
			if(saldo >= max_profit.get_balance())
				max_profit = D
			if(saldo <= max_loss.get_balance())
				max_loss = D

		to_world("<b>[max_profit.owner_name]</b> received most <font color='green'><B>PROFIT</B></font> today, with net profit of <b>T[max_profit.get_balance()]</b>.")
		to_world("On the other hand, <b>[max_loss.owner_name]</b> had most <font color='red'><B>LOSS</B></font>, with total loss of <b>T[max_loss.get_balance()]</b>.")

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
