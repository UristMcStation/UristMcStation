/turf
	var/wfc_overwritable = FALSE

	// list of refs to objects to delete on overwrite
	var/list/associated_wfc_overwritables = null


/turf/procgen
	icon = 'icons/urist/turf/uristturf.dmi'
	icon_state = "tramfloor"

	wfc_overwritable = TRUE
	parent_type = DEEPMAINT_TURF_BASE


/turf/procgen/wfc


/proc/WfcChangeTurf(turf/trg, new_type)
	// This cannot be an isturf() because that only works on instances, not paths!
	if(!ispath(new_type, /turf))
		return

	if(!isnull(trg.associated_wfc_overwritables))
		for(var/overwritten in trg.associated_wfc_overwritables)
			qdel_from_weakref(overwritten)

	trg.icon_state = initial(trg.icon_state)

	#ifdef STUB_OUT_SS13
	var/turf/new_turf = new new_type(trg)
	#else
	trg.ChangeTurf(new_type)
	#endif

	return
