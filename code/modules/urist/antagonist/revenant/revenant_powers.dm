/datum/power/revenant
	// list of tags to determine the overall flavor of the Revenant
	var/list/flavor_tags


var/list/revenant_powers = (typesof(/datum/power/revenant) - /datum/power/revenant)


/datum/bluespace_revenant/proc/get_powers_by_tag() // -> assoc list<flavor : power type>
	// Indexes available BsRevenant powers by flavor tag, for procgenning a selection.

	var/list/tagged_list = list()

	for(var/datum/power/revenant/P in revenant_powers)

		for(var/flavor_tag in P.flavor_tags)
			var/list/existing_list = tagged_list[flavor_tag]

			if(isnull(existing_list))
				tagged_list[flavor_tag] = list()

			tagged_list[flavor_tag] += P

	return tagged_list


/datum/bluespace_revenant/proc/select_flavors(var/amt = 2, var/list/choices_override = null) // -> assoc list<flavor_tag : weight>
	var/safe_amt = max(0, amt)
	var/list/flavors = list()

	var/list/choices = null

	if(istype(choices_override) && choices_override.len)
		choices = choices_override.Copy()

	if(!(choices?.len))
		choices = BSR_ALL_FLAVORS_LIST

	var/flavor_weight = 1

	while(choices && (flavors.len < safe_amt))
		var/picked_flavor = pick(choices)
		flavors[picked_flavor] = flavor_weight
		choices.Remove(picked_flavor)

		// Exponentially increase the weights, so that we have one main flavor and
		// some secondary ones. We prefer the last pick, because mults are easier.
		flavor_weight *= 3

	if(flavors.len < safe_amt)
		to_world_log("WARNING: Bluespace Revenant exhausted all choices before picking the requested amount. Proceeding with the smaller amount available!")

	return flavors


/datum/bluespace_revenant/proc/select_powers(var/list/flavors_override = null)
	var/list/true_flavors = flavors_override

	if(isnull(true_flavors))
		true_flavors = src.flavors

	if(isnull(true_flavors))
		true_flavors = src.select_flavors()

	var/list/power_options = src.get_powers_by_tag()
	var/list/powerset = list()

	var/num_powers = 5
	var/list/pickable_powers = list()

	while(power_options?.len && powerset.len < num_powers)
		pickable_powers.Cut() // we're reusing the same list object a bunch for efficiency

		var/rolled_flavor = sample_with_weights(true_flavors)

		if(isnull(rolled_flavor))
			to_world_log("BLUESPACE REVENANT: Flavor is null. Aborting!")
			break

		var/list/flavor_powers = power_options[rolled_flavor]

		if(isnull(flavor_powers))
			to_world_log("BLUESPACE REVENANT: Flavor [rolled_flavor] does not correspond to a valid option. Aborting!")
			break

		for(var/datum/power/revenant/FP in flavor_powers)
			if(!istype(FP))
				continue

			if(FP in powerset)
				continue

			pickable_powers.Add(FP)

		// NOTE: this could use weights as well, potentially
		var/datum/power/revenant/selected_power = pick(pickable_powers)
		if(selected_power)
			powerset.Add(selected_power)

	return powerset
