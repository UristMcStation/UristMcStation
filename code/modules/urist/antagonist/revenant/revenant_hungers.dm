/datum/power/revenant/bs_hunger
	/* This is abusing /datum/power and /datum/power/revenant as parents, since these will share a lot of functionality */

var/global/list/revenant_hungers = (typesof(/datum/power/revenant/bs_hunger) - /datum/power/revenant/bs_hunger)


/datum/bluespace_revenant/proc/get_hungers_by_tag() // -> assoc list<flavor : hunger type>
	// Indexes available BsRevenant hungers by flavor tag, for procgenning a selection.
	var/list/tagged_list = list()

	if(isnull(GLOB.revenant_powerinstances))
		src.initialize_powerinstances()

	for(var/P in revenant_hungers)

		var/datum/power/revenant/bs_hunger/instanceP = GLOB.revenant_powerinstances[P]

		for(var/flavor_tag in instanceP.flavor_tags)
			var/list/existing_list = tagged_list[flavor_tag]

			if(isnull(existing_list))
				existing_list = list()

			existing_list += instanceP
			tagged_list[flavor_tag] = existing_list

	return tagged_list


/datum/bluespace_revenant/proc/select_hungers(list/flavors_override = null)
	var/helper_result = src.select_bsrevenant_attributes(flavors_override, /datum/bluespace_revenant/proc/get_hungers_by_tag, 1, "Hunger")
	return helper_result
