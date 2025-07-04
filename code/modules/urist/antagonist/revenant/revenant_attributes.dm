/* Managing Powers/Hungers/Distortions */


/datum/power/revenant
	/* This is an abstract base class for Revenant Hungers and Powers.
	   Do NOT use this directly, it won't work. It's just to abstract
	   shared functionality of Hungers and Powers without copypasta.
	*/

	// List of tags to determine the overall flavor of the Revenant
	var/list/flavor_tags

	// Announce the power unlock to the owning mob so they know what's up; optional.
	var/activate_message


/datum/power/revenant/proc/Activate(datum/mind/M)
	if(!M)
		return FALSE

	var/mob/CM = M.current

	if(!CM || !istype(CM))
		return FALSE

	if(src.isVerb)
		if(!(src in CM.verbs))
			CM.verbs += src.verbpath

	else if(src.verbpath)
		call(CM, src.verbpath)()

	if(src.activate_message)
		to_chat(CM, src.activate_message)
	return TRUE


/datum/power/revenant/proc/Deactivate(datum/mind/M)
	if(!M)
		return TRUE

	var/mob/CM = M.current

	if(!CM || !istype(CM))
		return TRUE

	if(src.isVerb)
		CM.verbs?.Remove(src.verbpath)

	else if(src.verbpath)
		var/reverted = src.revertEffects(M)
		if(!reverted)
			return FALSE

	return TRUE


/datum/power/revenant/proc/revertEffects(datum/mind/M)
	// Reverts the effects of non-Verb powers.
	// Override per BSR power/hunger as needed.
	return TRUE


/datum/power/revenant/New(list/init_flavor_tags = null)
	. = ..()

	if(init_flavor_tags && istype(init_flavor_tags))
		src.flavor_tags = init_flavor_tags

	return


/datum/bluespace_revenant/proc/select_flavors(amt = 2, list/choices_override = null) // -> assoc list<flavor_tag : weight>
	var/safe_amt = max(0, amt)

	var/list/choices = null

	if(istype(choices_override) && length(choices_override))
		choices = choices_override.Copy()

	if(!length(choices))
		choices = BSR_ALL_FLAVORS_LIST

	// We increase the weights exponentially. This is the base of the exponent.
	// 'log-base', because log of base weight_log_base increases linearly
	// This is to make one option the 'primary' flavor, and the rest spice it up.
	var/const/weight_log_base = 2

	// Reserve weight 1 for generic filler, least important
	var/flavor_weight = weight_log_base * weight_log_base

	var/list/flavors = list()

	while(choices && (length(flavors) < safe_amt))
		var/picked_flavor = pick(choices)
		flavors[picked_flavor] = flavor_weight
		choices.Remove(picked_flavor)

		// Exponentially increase the weights, so that we have one main flavor and
		// some secondary ones. We prefer the last pick, because mults are easier.
		flavor_weight *= weight_log_base

	# ifdef BSR_DEBUGGING_ENABLED
	if(length(flavors) < safe_amt)
		BSR_DEBUG_LOG("WARNING: Bluespace Revenant exhausted all choices before picking the requested amount. Proceeding with the smaller amount available!")
	# endif

	// Fallback/extra spice - if we have no other choice, pick any power
	flavors[BSR_FLAVOR_GENERIC] = 1
	return flavors


/datum/bluespace_revenant/proc/select_bsrevenant_attributes(list/flavors_override = null, options_callable = null, count = 1, identifier = "attribute", abort_on_flv_miss = FALSE)
	// This is a generic helper used by Power/Hunger/Distortions procgen

	if(isnull(options_callable))
		BSR_DEBUG_LOG("BLUESPACE REVENANT: ERROR - select_bsrevenant_attributes called without an options callable!")
		return

	if(isnull(count) || count < 0)
		BSR_DEBUG_LOG("BLUESPACE REVENANT: ERROR - select_bsrevenant_attributes called with an invalid count arg: [count]!")
		return

	var/list/true_flavors = flavors_override

	if(isnull(true_flavors))
		true_flavors = src.flavors.Copy()

	if(isnull(true_flavors))
		true_flavors = src.select_flavors()

	var/list/power_options = call(src, options_callable)()
	var/list/powerset = list()

	var/num_powers = count
	var/list/pickable_powers = list()

	var/max_attempts = max(0, count) * 2
	var/attempts = 0
	var/list/generic_powers = power_options[BSR_FLAVOR_GENERIC]

	while(length(powerset) < num_powers)
		sleep(-1)

		if(!length(power_options))
			BSR_DEBUG_LOG("BLUESPACE REVENANT: No power options, aborting [identifier] selection!")
			break

		if(attempts++ >= max_attempts)
			BSR_DEBUG_LOG("BLUESPACE REVENANT: Exceeded max tries ([attempts] out of [max_attempts]), aborting [identifier] selection!")
			break

		pickable_powers.Cut() // we're reusing the same list object a bunch for efficiency

		var/rolled_flavor = sample_with_weights(true_flavors)

		if(isnull(rolled_flavor))
			BSR_DEBUG_LOG("BLUESPACE REVENANT: Flavor is null. Falling back to generic flavor...")
			rolled_flavor = BSR_FLAVOR_GENERIC

		if(isnull(rolled_flavor))
			BSR_DEBUG_LOG("BLUESPACE REVENANT: Flavor is null. This should never happen, aborting [identifier] selection!")
			break

		var/list/flavor_powers = power_options[rolled_flavor]

		if(isnull(flavor_powers) && abort_on_flv_miss)
			BSR_DEBUG_LOG("BLUESPACE REVENANT: Flavor [rolled_flavor] does not correspond to a valid option in [power_options] ([length(power_options)]). This should never happen, aborting [identifier] selection!")
			break

		for(var/datum/power/revenant/FP in flavor_powers)
			if(!istype(FP))
				BSR_DEBUG_LOG("BSR: skipping [identifier] [FP] - wrong type!")
				continue

			if(FP in powerset)
				BSR_DEBUG_LOG("BSR: skipping [identifier] [FP] - already selected!")
				continue

			pickable_powers.Add(FP)

		// NOTE: this could use weights as well, potentially
		var/datum/power/revenant/selected_power = null

		if(!length(pickable_powers))
			BSR_DEBUG_LOG("BSR: falling back to a generic set for [identifier]!")
			pickable_powers = generic_powers
			true_flavors.Remove(rolled_flavor)

		if(length(pickable_powers))
			selected_power = pick(pickable_powers)

		if(selected_power && !(selected_power in powerset))
			powerset.Add(selected_power)

	return powerset


/datum/bluespace_revenant/proc/unlockPower(datum/mind/M, Pname, remake_verbs = 1, identifier = "attribute")
	if(!M || !M.bluespace_revenant)
		return

	var/datum/power/revenant/Thepower = null

	if(ispath(Pname))
		Thepower = GLOB.revenant_powerinstances[Pname]

	else if(istype(Pname, /datum/power/revenant))
		Thepower = Pname

	else
		for (var/Ptype in GLOB.revenant_powerinstances)
			var/datum/power/revenant/P = GLOB.revenant_powerinstances[Ptype]
			if(P.name == Pname)
				Thepower = P

	if(isnull(Thepower))
		to_chat(M.current, "This is awkward.  Revenant unlock failed for [identifier] `[Pname]`, please report this bug to a coder!")
		return

	if(Thepower in src.unlocked_powers)
		BSR_DEBUG_LOG("Attempted to unlock an already unlocked Bluespace Revenant [identifier] `[Thepower]` for [M]")
		return

	src.unlocked_powers += Thepower

	Thepower.Activate(M)

	if(remake_verbs)
		M.current.make_bsrevenant()

	BSR_DEBUG_LOG("Unlocked [identifier] `[Thepower]` for mind [M] ([M?.current || "no mob"])")
	return
