
/proc/yeet_offset(var/xoff, var/yoff)
	deepmaint_yeet_trg(usr, xoff, yoff)
	return


/proc/yeet_rand()
	deepmaint_yeet_trg(usr, rand(0, DEEPMAINT_VARIANT_REPEATS_X), rand(0, DEEPMAINT_VARIANT_REPEATS_Y))
	return


/mob/verb/generate_deepmaint_verb()
	generate_deepmaint()


/mob/verb/deepmaint_rebuild_mapfile_verb()
	deepmaint_rebuild_mapfile()


/mob/verb/deepmaint_send_trg_verb()
	deepmaint_send_trg(usr)
