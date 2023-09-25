
/proc/yeet_offset(var/xoff, var/yoff)
	deepmaint_yeet_trg(usr, xoff, yoff)
	return


/proc/yeet_rand()
	deepmaint_yeet_trg(usr, rand(0, DEEPMAINT_VARIANT_REPEATS_X), rand(0, DEEPMAINT_VARIANT_REPEATS_Y))
	return


/mob/verb/generate_deepmaint_verb()
	if(!GLOB.wfc_deepmaint_zlevels_by_instance)
		log_and_message_admins("failed to generate Deepmaint - no Deepmaint Z-levels registered!")
		return

	for(var/area/map_template/deepmaint_wfc/deepmaint_area in GLOB.wfc_deepmaint_zlevels_by_instance)
		var/success = deepmaint_area.generate_deepmaint("deepmaint.json", "genmap.json")
		if(success)
			log_and_message_admins("has generated a DeepmaintRooms map.")
			break
		else
			log_and_message_admins("has unsuccessfully attempted to generate a DeepmaintRooms map.")

	return


/mob/verb/deepmaint_rebuild_mapfile_verb()
	deepmaint_rebuild_mapfile()


/mob/verb/deepmaint_send_trg_verb()
	deepmaint_send_trg(usr)
