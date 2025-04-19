// Various spoopiness that happens when too much ambient Distortion accumulates.


/datum/power/revenant/distortion
	isVerb = FALSE // for convenience, as most won't be
	verbpath = null // we'll use Apply() for most cases; keeping this for stuff affecting BsRev (adding callbacks etc.)
	var/distortion_threshold = 0 // here, this means the *unsuppressed* Distortion required to make this effect triggerable


var/global/list/revenant_distortions = (typesof(/datum/power/revenant/distortion) - /datum/power/revenant/distortion)


/datum/power/revenant/distortion/proc/Apply(atom/A, datum/bluespace_revenant/revenant)
	// Does A Thing to an entity, generally someone else than the BsRev
	return


/datum/bluespace_revenant/proc/get_distortions_by_tag() // -> assoc list<flavor : hunger type>
	// Indexes available Distortion effects by flavor tag, for procgenning a selection.
	var/list/tagged_list = list()

	if(isnull(GLOB.revenant_powerinstances))
		src.initialize_powerinstances()

	for(var/P in revenant_distortions)

		var/datum/power/revenant/distortion/instanceP = GLOB.revenant_powerinstances[P]

		for(var/flavor_tag in instanceP.flavor_tags)
			var/list/existing_list = tagged_list[flavor_tag]

			if(isnull(existing_list))
				existing_list = list()

			existing_list += instanceP
			tagged_list[flavor_tag] = existing_list

	return tagged_list


/datum/bluespace_revenant/proc/select_distortions(list/flavors_override = null)
	var/list/helper_result = src.select_bsrevenant_attributes(flavors_override, /datum/bluespace_revenant/proc/get_distortions_by_tag, 4, "Distortion")
	if(!istype(helper_result))
		helper_result = list()

	if(!helper_result.len)
		BSR_DEBUG_LOG("BSR: No Distortions were rolled by tag; picking a random one as a fallback!")
		var/rawD = pick(revenant_distortions)
		var/datum/power/revenant/distortion/instanceD = GLOB.revenant_powerinstances[rawD]
		helper_result.Add(instanceD)

	return helper_result


/datum/bluespace_revenant/proc/roll_for_effects(current_distortion = 0)
	if((current_distortion || 0) <= 0)
		return FALSE

	// Maximum %chance of triggering a Distortion PER TURF - so, this should be fairly low
	var/max_chance_per_turf = config?.bluespace_revenant_distortion_max_chance_per_turf || BSR_DEFAULT_MAXPERC_PER_TURF

	// The point where the odds will be max_chance_per_turf * 0.5
	// Note this DOES NOT hold linearly; e.g. if x=100 => 50%, x=200 => ...66%!
	var/halfway_point = config?.bluespace_revenant_distortion_maxchance_halfway_point || BSR_DEFAULT_HALFWAY_PER_TURF

	// This funny-looking formula is not random; this is an additive smoother calibrated to return %odds.
	// This gives us a nice, smooth function that rises steadily to a maximum without ever quite reaching it
	var/perc_odds = ( (current_distortion) / (current_distortion + halfway_point) ) * max_chance_per_turf

	return perc_odds


/datum/bluespace_revenant/proc/HandleDistortionFX(atom/A)
	if(!istype(A))
		return

	var/turf/T = A
	if(!istype(T))
		// We currently only track Distortion on Turfs; this may get expanded to all atoms later!
		return

	var/current_dist = T.reality_distortion

	var/distortion_proba = src.roll_for_effects(current_dist)
	var/should_distort = prob(distortion_proba)

	if(should_distort)
		BSR_DEBUG_LOG("BSR: ApplyDistortionFX running...")
		var/result = src.ApplyDistortionFX(A)
		// reset Distortion
		if(result)
			T.reality_distortion = 0
			return TRUE


	var/quart_curr_dist = (current_dist / 4)

	if(current_dist > BSR_DEFAULT_HALFWAY_PER_TURF)
		for(var/turf/simulated/NT in T.AdjacentTurfs(FALSE))
			if(NT.reality_distortion < quart_curr_dist)
				// diffuse Distortion to the nearest lower-Dist neighbor
				NT.reality_distortion += quart_curr_dist
				T.reality_distortion -= quart_curr_dist
				break

	return



/datum/bluespace_revenant/proc/ApplyDistortionFX(atom/A)
	if(!istype(A))
		return

	if(!(src.distortions?.len))
		BSR_DEBUG_LOG("BSR: ERROR - HandleDistortionFX called with no Distortions!")
		return

	var/datum/power/revenant/distortion/distEff = null
	var/tries = 5

	var/effective_distortion = src.get_effective_distortion()
	var/list/available_distortions = src.distortions.Copy()

	while(tries --> 0 && !istype(distEff))
		distEff = pick(available_distortions)

		// handle thresholds
		if(isnull(distEff))
			available_distortions.Remove(distEff)
			continue

		if(effective_distortion < distEff.distortion_threshold)
			available_distortions.Remove(distEff)
			continue

	. = distEff?.Apply(A, src)
	return
