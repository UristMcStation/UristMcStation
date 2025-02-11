
/proc/deepmaint_yeet_trg(var/atom/movable/trg, var/xoffset = 1, var/yoffset = 1)
	if(!ismovable(trg))
		// This would be silly
		return FALSE

	if(isnull(trg.loc))
		// No un-qdel-ing by accident!
		return

	if(ismob(trg) && !istype(trg, DEEPMAINT_TELEPORTABLE_MOBTYPE))
		// Don't teleport AI eyes, ghosts, irate admins...
		return

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


/proc/deepmaint_send_trg(var/atom/movable/trg)
	if(!ismovable(trg))
		// This would be silly
		return FALSE

	if(isnull(trg.loc))
		// No un-qdel-ing by accident!
		return

	if(ismob(trg) && !istype(trg, DEEPMAINT_TELEPORTABLE_MOBTYPE))
		// Don't teleport AI eyes, ghosts, irate admins...
		return

	var/tries = 1
	var/success = FALSE

	var/list/predicates = list(/proc/not_turf_contains_dense_objects)

	while(tries --> 0)
		var/turf/T = pick_area_turf(/area/map_template/deepmaint_wfc/alpha, predicates)

		if(isnull(T))
			continue

		var/mob/M = trg
		if(istype(M))
			M.Stun(1)
			M.flash_eyes(
				intensity = FLASH_PROTECTION_MAJOR * 10,
				override_blindness_check = TRUE,
				affect_silicon = TRUE,
				visual = FALSE,
				type = /obj/screen/fullscreen/blackout
			)

		success = trg.forceMove(T)
		if(success)
			break

	return TRUE


/proc/deepmaint_return_trg(var/atom/movable/trg)
	if(!ismovable(trg))
		// This would be silly
		return FALSE

	if(isnull(trg.loc))
		// No un-qdel-ing by accident!
		return

	if(ismob(trg) && !istype(trg, DEEPMAINT_TELEPORTABLE_MOBTYPE))
		// Don't teleport AI eyes, ghosts, irate admins...
		return

	var/tries = 1
	var/success = FALSE

	var/list/predicates = list(/proc/is_station_turf, /proc/not_turf_contains_dense_objects, /proc/IsTurfAtmosSafe)

	while(tries --> 0)
		var/area/location = pick_area(list(/proc/is_not_space_area, /proc/is_station_area, /proc/is_maint_area))

		if(isnull(location))
			continue

		var/turf/T = pick_area_turf(location, predicates)

		if(isnull(T))
			continue

		var/mob/M = trg
		if(istype(M))
			M.Stun(1)
			M.flash_eyes(
				intensity = FLASH_PROTECTION_MAJOR * 10,
				override_blindness_check = TRUE,
				affect_silicon = TRUE,
				visual = FALSE,
				type = /obj/screen/fullscreen/blackout
			)

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
		return TRUE

	return FALSE


/proc/deepmaint_conditional_send(var/atom/movable/trg, var/tele_proba = 10)
	var/proba = (isnull(tele_proba) ? 10 : tele_proba)

	if(prob(proba))
		deepmaint_send_trg(trg)
		return TRUE

	return FALSE


/proc/deepmaint_conditional_stationyeet(var/atom/movable/trg, var/tele_proba = 2)
	var/proba = (isnull(tele_proba) ? 2 : tele_proba)

	if(prob(proba))
		deepmaint_return_trg(trg)
		return TRUE

	return FALSE


/obj/wfc_step_trigger/deepmaint_teleport
	step_callback = /proc/deepmaint_conditional_yeet


/obj/wfc_step_trigger/deepmaint_entrance
	icon_state = "rdn"
	step_callback = /proc/deepmaint_conditional_send


/obj/wfc_step_trigger/deepmaint_exit
	icon_state = "rup"
	step_callback = /proc/deepmaint_conditional_stationyeet
