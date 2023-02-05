
/datum/power/revenant/bs_power


/*
/datum/power			//Could be used by other antags too
	var/name = "Power"
	var/desc = "Placeholder"
	var/helptext = ""
	var/isVerb = 1 	// Is it an active power, or passive?
	var/verbpath // Path to a verb that contains the effects.
*/

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
				tagged_list[flavor_tag] = list()

			tagged_list[flavor_tag] += P

	return tagged_list


/datum/bluespace_revenant/proc/select_powers(var/list/flavors_override = null)
	var/helper_result = src.select_bsrevenant_attributes(flavors_override, /datum/bluespace_revenant/proc/get_powers_by_tag, 5)
	return helper_result
