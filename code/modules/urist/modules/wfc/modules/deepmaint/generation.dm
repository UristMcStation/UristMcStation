/proc/deepmaint_rebuild_mapfile(var/ruleset = "deepmaint.json")
	var/success = generate_wfc_map(ruleset)
	return success

/area/map_template/deepmaint_wfc/proc/deepmaint_rebuild_mapfile(var/ruleset = "deepmaint.json")
	var/success = generate_wfc_map(ruleset)
	return success


/area/map_template/deepmaint_wfc/proc/deepmaint_from_mapfile(var/zlevel, var/mapname = "genmap.json", var/overwrite_all = FALSE)
	var/success = generate_from_wfc_file(mapname, overwrite_all = overwrite_all, zlevel = zlevel)
	return success


/area/map_template/deepmaint_wfc/proc/generate_deepmaint(var/ruleset = "deepmaint.json", var/mapname = "genmap.json")
	var/min_z = null

	// For now, we'll assume the min-valued registered z-level is the start of the generation
	// and that whoever placed the areas accounted for z-level positions in the code downstream

	for(var/typekey in (GLOB.wfc_deepmaint_zlevels_by_instance || list()))
		var/zlevel = GLOB.wfc_deepmaint_zlevels_by_instance[typekey]
		if(isnull(min_z) || zlevel < min_z)
			min_z = zlevel

	if(isnull(min_z))
		log_debug("Deepmaint - failed to locate a valid Z-level!")
		return FALSE

	var/success = TRUE
	success = success && deepmaint_rebuild_mapfile(ruleset)
	log_debug("Deepmaint - deepmaint_rebuild_mapfile() status: [success]")
	success = success && src.deepmaint_from_mapfile(min_z, mapname, overwrite_all = FALSE)
	log_debug("Deepmaint - deepmaint_from_mapfile() status: [success]")

	return success


/area/map_template/deepmaint_wfc/proc/generate_deepmaint_periodic(var/zlevel, var/sleeptime = 200)
	var/ruleset = "deepmaint.json"
	var/mapname = "genmap.json"
	var/_sleeptime = max(1, sleeptime)

	spawn(0)
		while(TRUE)
			deepmaint_rebuild_mapfile(ruleset)
			deepmaint_from_mapfile(mapname, overwrite_all = FALSE, zlevel = zlevel)
			log_debug("Deepmaint - Regenerating in 20s")
			sleep(_sleeptime)
			log_debug("Deepmaint - Regenerating!")
	return
