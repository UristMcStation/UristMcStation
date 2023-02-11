
/datum/power/revenant/bs_power
	// How much total Distortion we need to unlock this
	// By default, 600 = 1 minute of growth w/o using other powers
	var/distortion_threshold = 0


var/list/revenant_powers = (typesof(/datum/power/revenant/bs_power) - /datum/power/revenant/bs_power)


/datum/bluespace_revenant/proc/get_powers_by_tag() // -> assoc list<flavor : power type>
	// Indexes available BsRevenant powers by flavor tag, for procgenning a selection.

	var/list/tagged_list = list()

	if(isnull(GLOB.revenant_powerinstances))
		src.initialize_powerinstances()

	for(var/P in revenant_powers)
		var/datum/power/revenant/bs_power/instanceP = GLOB.revenant_powerinstances[P]

		for(var/flavor_tag in instanceP.flavor_tags)
			var/list/existing_list = tagged_list[flavor_tag]

			if(isnull(existing_list))
				existing_list = list()

			existing_list += instanceP
			tagged_list[flavor_tag] = existing_list

	return tagged_list


/datum/bluespace_revenant/proc/select_powers(var/list/flavors_override = null)
	var/helper_result = src.select_bsrevenant_attributes(flavors_override, /datum/bluespace_revenant/proc/get_powers_by_tag, 7, "Power")
	return helper_result


/datum/bluespace_revenant/proc/HandlePowerUpdates()
	var/added_powers = 0
	var/mob/M = null

	if(istype(src.mob_ref))
		M = src.mob_ref.resolve()

	if(!istype(M))
		return

	for(var/datum/power/revenant/bs_power/P in src.power_set)
		if(P in src.unlocked_powers)
			continue

		if(src.total_distortion >= P.distortion_threshold)
			src.unlockPower(M.mind, P, FALSE)
			added_powers++

	if(added_powers)
		M.make_bsrevenant()

	return
