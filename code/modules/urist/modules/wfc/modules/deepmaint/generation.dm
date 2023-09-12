/proc/deepmaint_rebuild_mapfile(var/ruleset = "deepmaint.json")
	generate_wfc_map(ruleset)
	return

/area/map_template/deepmaint_wfc/proc/deepmaint_rebuild_mapfile(var/ruleset = "deepmaint.json")
	generate_wfc_map(ruleset)
	return


/area/map_template/deepmaint_wfc/proc/deepmaint_from_mapfile(var/zlevel, var/mapname = "genmap.json", var/overwrite_all = FALSE)
	generate_from_wfc_file(mapname, overwrite_all = overwrite_all, zlevel = zlevel)
	return


/area/map_template/deepmaint_wfc/proc/generate_deepmaint(var/ruleset = "deepmaint.json", var/mapname = "genmap.json")
	if(!GLOB.wfc_deepmaint_zlevels_by_instance)
		return FALSE

	var/min_z = null

	// For now, we'll assume the min-valued registered z-level is the start of the generation
	// and that whoever placed the areas accounted for z-level positions in the code downstream

	for(var/typekey in GLOB.wfc_deepmaint_zlevels_by_instance)
		var/zlevel = GLOB.wfc_deepmaint_zlevels_by_instance[typekey]
		if(isnull(min_z) || zlevel < min_z)
			min_z = zlevel

	deepmaint_rebuild_mapfile(ruleset)
	deepmaint_from_mapfile(min_z, mapname, overwrite_all = FALSE)

	return TRUE


/area/map_template/deepmaint_wfc/proc/generate_deepmaint_periodic(var/zlevel, var/sleeptime = 200)
	var/ruleset = "deepmaint.json"
	var/mapname = "genmap.json"
	var/_sleeptime = max(1, sleeptime)

	spawn(0)
		while(TRUE)
			deepmaint_rebuild_mapfile(ruleset)
			deepmaint_from_mapfile(mapname, overwrite_all = FALSE, zlevel = zlevel)
			to_chat(world, "Regenerating in 20s")
			sleep(_sleeptime)
			to_chat(world, "Regenerating!")
	return
