/datum/revenant_hunger
	// list of tags to determine the overall flavor of the Revenant
	var/list/flavor_tags


var/list/revenant_hungers = (typesof(/datum/revenant_hunger) - /datum/revenant_hunger)


/datum/bluespace_revenant/proc/get_hungers_by_tag() // -> assoc list<flavor : hunger type>
	// Indexes available BsRevenant hungers by flavor tag, for procgenning a selection.

	var/list/tagged_list = list()

	for(var/datum/revenant_hunger/H in revenant_hungers)

		for(var/flavor_tag in H.flavor_tags)
			var/list/existing_list = tagged_list[flavor_tag]

			if(isnull(existing_list))
				tagged_list[flavor_tag] = list()

			tagged_list[flavor_tag] += H

	return tagged_list


/datum/bluespace_revenant/proc/select_hungers(var/list/flavors_override = null)
	var/list/true_flavors = flavors_override

	if(isnull(true_flavors))
		true_flavors = src.flavors

	if(isnull(true_flavors))
		true_flavors = src.select_flavors()

	var/list/hunger_options = src.get_hungers_by_tag()
	var/list/hungerset = list()

	var/num_hungers = 1
	var/list/pickable_hungers = list()

	while(hunger_options?.len && hungerset.len < num_hungers)
		pickable_hungers.Cut() // we're reusing the same list object a bunch for efficiency

		var/rolled_flavor = sample_with_weights(true_flavors)

		if(isnull(rolled_flavor))
			to_world_log("BLUESPACE REVENANT: Flavor is null. Aborting!")
			break

		var/list/flavor_hungers = hunger_options[rolled_flavor]

		if(isnull(flavor_hungers))
			to_world_log("BLUESPACE REVENANT: Flavor [rolled_flavor] does not correspond to a valid option. Aborting!")
			break

		for(var/datum/revenant_hunger/FH in flavor_hungers)
			if(!istype(FH))
				continue

			if(FH in hungerset)
				continue

			pickable_hungers.Add(FH)

		// NOTE: this could use weights as well, potentially
		var/datum/revenant_hunger/selected_hunger = pick(pickable_hungers)
		if(selected_hunger)
			hungerset.Add(selected_hunger)

	return hungerset
