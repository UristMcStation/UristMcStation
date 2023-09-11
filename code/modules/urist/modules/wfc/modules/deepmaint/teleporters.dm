
/proc/deepmaint_yeet_trg(var/atom/movable/trg, var/xoffset = 1, var/yoffset = 1)
	if(!istype(trg, /atom/movable))
		return FALSE

	var/raw_pos_x = DEEPMAINT_RELATIVE_POS(trg.x, DEEPMAINT_VARIANT_SIZE_X, DEEPMAINT_VARIANT_SPACING_X) + DEEPMAINT_YEET_POS(0, xoffset, DEEPMAINT_VARIANT_SIZE_X, DEEPMAINT_VARIANT_SPACING_X)
	var/raw_pos_y = DEEPMAINT_RELATIVE_POS(trg.y, DEEPMAINT_VARIANT_SIZE_Y, DEEPMAINT_VARIANT_SPACING_Y) + DEEPMAINT_YEET_POS(0, yoffset, DEEPMAINT_VARIANT_SIZE_Y, DEEPMAINT_VARIANT_SPACING_Y)

	var/pos_x = raw_pos_x % world.maxx
	var/pos_y = raw_pos_y % world.maxy
	var/pos_z = trg.z

	var/turf/outturf = locate(pos_x, pos_y, pos_z)

	if(isnull(outturf))
		return FALSE

	trg.loc = outturf
	return TRUE


/proc/deepmaint_return_trg(var/atom/movable/trg)
	if(!istype(trg, /atom/movable))
		return FALSE

	var/tries = 1
	var/success = FALSE

	var/list/predicates = list(/proc/is_station_turf, /proc/not_turf_contains_dense_objects)

	while(tries --> 0)
		var/turf/T = pick_area_turf(/area/maintenance, predicates)

		if(isnull(T))
			continue

		success = trg.forceMove(T)
		if(success)
			break

	return TRUE


/proc/deepmaint_conditional_yeet(var/atom/movable/trg, var/tele_proba = 60)
	var/proba = (isnull(tele_proba) ? 60 : tele_proba)

	if(prob(proba))
		var/xoff = rand(0, DEEPMAINT_VARIANT_REPEATS_X)
		var/yoff = rand(0, DEEPMAINT_VARIANT_REPEATS_Y)
		deepmaint_yeet_trg(trg, xoff, yoff)

	return


/proc/deepmaint_conditional_stationyeet(var/atom/movable/trg, var/tele_proba = 1)
	var/proba = (isnull(tele_proba) ? 1 : tele_proba)

	if(prob(proba))
		deepmaint_return_trg(trg)

	return


/obj/wfc_step_trigger/deepmaint_teleport
	unstep_callback = /proc/deepmaint_conditional_yeet


/obj/wfc_step_trigger/deepmaint_exit
	unstep_callback = /proc/deepmaint_conditional_stationyeet

