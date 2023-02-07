// Various spoopiness that happens when too much ambient Distortion accumulates.


/datum/power/revenant/distortion
	isVerb = FALSE // for convenience, as most won't be
	verbpath = null // we'll use Apply() for most cases; keeping this for stuff affecting BsRev (adding callbacks etc.)


var/list/revenant_distortions = (typesof(/datum/power/revenant/distortion) - /datum/power/revenant/distortion)


/datum/power/revenant/distortion/proc/Apply(var/atom/A, var/datum/bluespace_revenant/revenant)
	// Does A Thing to an entity, generally someone else than the BsRev
	return


/datum/bluespace_revenant/proc/get_distortions_by_tag() // -> assoc list<flavor : hunger type>
	// Indexes available Distortion effects by flavor tag, for procgenning a selection.
	var/list/tagged_list = list()

	if(isnull(GLOB.revenant_powerinstances))
		src.initialize_powerinstances()

	for(var/P in revenant_distortions)
		BSR_DEBUG_LOG("BSR: get_distortions_by_tag - processing [P]")

		var/datum/power/revenant/distortion/instanceP = GLOB.revenant_powerinstances[P]

		for(var/flavor_tag in instanceP.flavor_tags)
			var/list/existing_list = tagged_list[flavor_tag]

			if(isnull(existing_list))
				existing_list = list()

			existing_list += instanceP
			tagged_list[flavor_tag] = existing_list
			BSR_DEBUG_LOG("BSR: get_distortions_by_tag - added [instanceP] to a list for [flavor_tag]")

	return tagged_list


/datum/bluespace_revenant/proc/select_distortions(var/list/flavors_override = null)
	var/list/helper_result = src.select_bsrevenant_attributes(flavors_override, /datum/bluespace_revenant/proc/get_distortions_by_tag, 3, "Distortion")
	if(!istype(helper_result))
		helper_result = list()

	if(!helper_result.len)
		BSR_DEBUG_LOG("BSR: No Distortions were rolled by tag; picking a random one as a fallback!")
		var/rawD = pick(revenant_distortions)
		var/datum/power/revenant/distortion/instanceD = GLOB.revenant_powerinstances[rawD]
		helper_result.Add(instanceD)

	return helper_result


/datum/bluespace_revenant/proc/roll_for_effects(var/current_distortion = 0)
	if((current_distortion || 0) <= 0)
		return FALSE

	// Maximum %chance of triggering a Distortion PER TURF - so, this should be fairly low
	var/const/max_chance_per_turf = BSR_DEFAULT_MAXPERC_PER_TURF

	// The point where the odds will be max_chance_per_turf * 0.5
	// Note this DOES NOT hold linearly; e.g. if x=100 => 50%, x=200 => ...66%!
	var/const/halfway_point = BSR_DEFAULT_HALFWAY_PER_TURF

	// This funny-looking formula is not random; this is an additive smoother calibrated to return %odds.
	// This gives us a nice, smooth function that rises steadily to a maximum without ever quite reaching it
	var/perc_odds = ( (current_distortion) / (current_distortion + halfway_point) ) * max_chance_per_turf

	return prob(perc_odds)


/datum/bluespace_revenant/proc/HandleDistortionFX(var/atom/A)
	if(!istype(A))
		return

	var/turf/T = A
	if(!istype(T))
		// We currently only track Distortion on Turfs; this may get expanded to all atoms later!
		return

	var/current_dist = T.reality_distortion

	var/should_distort = src.roll_for_effects(current_dist)

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



/datum/bluespace_revenant/proc/ApplyDistortionFX(var/atom/A)
	if(!istype(A))
		return

	if(!(src.distortions?.len))
		BSR_DEBUG_LOG("BSR: ERROR - HandleDistortionFX called with no Distortions!")
		return

	var/datum/power/revenant/distortion/distEff = null
	var/tries = 0

	while(!istype(distEff) && tries++ < 3)
		distEff = pick(src.distortions)

	. = distEff.Apply(A, src)
	return

