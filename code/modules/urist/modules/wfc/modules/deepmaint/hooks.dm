/hook/death/proc/deepmaint_death_handler(mob/living/carbon/human/H, gibbed = FALSE)
	var/mob/living/carbon/human/deadman = H

	if(isnull(deadman))
		return FALSE

	#ifdef UNIT_TEST
	// skip for unit-tests since they have no valid areas for this
	return TRUE
	#endif

	var/area/map_template/deepmaint_wfc/deepmaint_area = get_area(deadman)
	if(!istype(deepmaint_area))
		return TRUE

	// check area
	// if deepmaint, move to station maint
	// if gibbed, spawn gibspawner

	// Note: this is VERY similar to the logic for teleporter callbacks to return players to the station
	// However, ATM it's hard to create shared code due to subtle differences in the logic here vs there.
	var/turf/T = pick_area_turf(/area/maintenance, list(/proc/is_station_turf, /proc/not_turf_contains_dense_objects))

	if(isnull(T))
		return FALSE

	if(gibbed)
		gibs(T, deadman.dna)
		T.visible_message("A pile of horribly misshapen organs, meat, and blood sprays out of thin air.", "You hear a series of disgustingly wet thuds and squelches.")

	else
		H.forceMove(T)
		H.visible_message("[H] materializes on \the [T], seemingly out of thin air.")

	return TRUE
