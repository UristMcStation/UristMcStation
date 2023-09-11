/mob/verb/test_wfc_full()
	var/area/map_template/deepmaint_wfc/deepmaint_area = locate()
	var/zlevel = deepmaint_area.z

	var/ruleset = "deepmaint.json"
	var/mapname = "genmap.json"

	generate_wfc_map(ruleset)
	generate_from_wfc_file(mapname, overwrite_all = FALSE, zlevel = zlevel)

	return


/*
/mob/verb/test_wfc_full_force()
	generate_wfc_map_full("rules.json", TRUE)
	return
*/

/mob/verb/yeet_offset(xoff as num, yoff as num)
	deepmaint_yeet_trg(usr, xoff, yoff)
	return


/mob/verb/yeet_rand()
	deepmaint_yeet_trg(usr, rand(0, DEEPMAINT_VARIANT_REPEATS_X), rand(0, DEEPMAINT_VARIANT_REPEATS_Y))
	return


/mob/verb/test_wfc_rebuild_data()
	generate_wfc_map()
	to_chat(usr, "Map data rebuilt")
	return


/mob/verb/test_wfc_pregenerated(zlevel as num)
	var/mapname = "genmap.json"
	generate_from_wfc_file(mapname, overwrite_all = FALSE, zlevel = zlevel)
	return


/mob/verb/test_wfc_periodic_gen(zlevel as num)
	var/ruleset = "deepmaint.json"
	var/mapname = "genmap.json"

	spawn(0)
		while(TRUE)
			generate_wfc_map(ruleset)
			generate_from_wfc_file(mapname, overwrite_all = FALSE, zlevel = zlevel)
			generate_from_wfc_file(mapname, overwrite_all = FALSE, zlevel = (zlevel + 1))
			to_chat(usr, "Regenerating in 20s")
			sleep(200)
			to_chat(usr, "Regenerating!")
	return
