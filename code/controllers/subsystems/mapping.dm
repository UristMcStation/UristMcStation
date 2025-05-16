SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = SS_INIT_MAPPING
	flags = SS_NO_FIRE

	var/list/map_templates = list()
	var/list/space_ruins_templates = list()
	var/list/exoplanet_ruins_templates = list()
	var/list/away_sites_templates = list()
	var/list/submaps = list()
	var/list/planet_templates = list()
	var/list/underground_templates = list()
	var/list/ship_templates = list()
	var/list/submap_templates = list()

/datum/controller/subsystem/mapping/UpdateStat(time)
	return

#ifdef DEBUG_GENERATE_WORTHS
/datum/controller/subsystem/mapping/flags = SS_NO_INIT | SS_NO_FIRE
#endif

/datum/controller/subsystem/mapping/Initialize(start_uptime)
	preloadTemplates()


/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
	map_templates = SSmapping.map_templates
	space_ruins_templates = SSmapping.space_ruins_templates
	exoplanet_ruins_templates = SSmapping.exoplanet_ruins_templates
	away_sites_templates = SSmapping.away_sites_templates
	planet_templates = SSmapping.planet_templates
	underground_templates = SSmapping.underground_templates
	ship_templates = SSmapping.ship_templates

/datum/controller/subsystem/mapping/proc/preloadTemplates(path = "maps/templates/") //see master controller setup
	var/list/filelist = flist(path)
	for(var/map in filelist)
		var/datum/map_template/T = new(list("[path][map]"), rename = "[map]")
		map_templates[T.name] = T

	preloadOtherTemplates()
	preloadBlacklistableTemplates()

	admin_notice("<span class='danger'>Templates Preloaded</span>", R_DEBUG)

/datum/controller/subsystem/mapping/proc/preloadBlacklistableTemplates()
	// Still supporting bans by filename
	var/list/banned_exoplanet_dmms = generateMapList("config/exoplanet_ruin_blacklist.txt")
	var/list/banned_space_dmms = generateMapList("config/space_ruin_blacklist.txt")
	var/list/banned_away_site_dmms = generateMapList("config/away_site_blacklist.txt")

	if (!banned_exoplanet_dmms || !banned_space_dmms || !banned_away_site_dmms)
		report_progress("One or more map blacklist files are not present in the config directory!")

	var/list/banned_maps = list() + banned_exoplanet_dmms + banned_space_dmms + banned_away_site_dmms

	for(var/item in sortTim(subtypesof(/datum/map_template), GLOBAL_PROC_REF(cmp_ruincost_priority)))
		var/datum/map_template/map_template_type = item
		// screen out the abstract subtypes
		if(!initial(map_template_type.id))
			continue
		var/datum/map_template/MT = new map_template_type()

		if (banned_maps)
			var/is_banned = FALSE
			for (var/mappath in MT.mappaths)
				if(banned_maps.Find(mappath))
					is_banned = TRUE
					break
			if (is_banned)
				continue

		if(istype(MT, /datum/map_template/submap))
			submap_templates[MT.name] = MT
		else
			map_templates[MT.name] = MT

		// This is nasty..
		if(istype(MT, /datum/map_template/ruin/exoplanet))
			exoplanet_ruins_templates[MT.name] = MT
		else if(istype(MT, /datum/map_template/ruin/space))
			space_ruins_templates[MT.name] = MT
		else if(istype(MT, /datum/map_template/ruin/away_site))
			away_sites_templates[MT.name] = MT

/datum/controller/subsystem/mapping/proc/preloadOtherTemplates()
	var/list/potentialSpaceRuins = generateMapList(filename = "config/spaceRuins.txt")
	for(var/ruin in potentialSpaceRuins)
		var/datum/map_template/T = new(list(ruin), ruin)
		space_ruins_templates[T.name] = T

	var/list/potentialPlanetTemplates = generateMapList(filename = "config/planetTemplates.txt")
	for(var/ruin in potentialPlanetTemplates)
		var/datum/map_template/T = new(list(ruin), ruin)
		planet_templates[T.name] = T

	var/list/potentialUndergroundTemplates = generateMapList(filename = "config/undergroundTemplates.txt")
	for(var/ruin in potentialUndergroundTemplates)
		var/datum/map_template/T = new(list(ruin), ruin)
		underground_templates[T.name] = T

	var/list/potentialShipTemplates = generateMapList(filename = "config/shipTemplates.txt")
	for(var/ruin in potentialShipTemplates)
		var/datum/map_template/ship/T = new(list(ruin), ruin)
		ship_templates[T.name] = T
		map_templates[T.name] = T

/proc/generateMapList(filename)
	RETURN_TYPE(/list)
	var/list/potentialMaps = list()
	var/list/Lines = world.file2list(filename)
	if(!length(Lines))
		return
	for (var/t in Lines)
		if (!t)
			continue
		t = trimtext(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue
		var/pos = findtext(t, " ")
		var/name = null
		if (pos)
			name = lowertext(copytext(t, 1, pos))
		else
			name = lowertext(t)
		if (!name)
			continue
		potentialMaps.Add(t)
	return potentialMaps
