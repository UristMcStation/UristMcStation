/datum/mind
	var/datum/bluespace_revenant/bluespace_revenant


/datum/bluespace_revenant
	/* Holder for data associated with a Revenant, antag or not. */

	// Flavor tags selected for this Revenant. Influences the overall vibe.
	var/list/flavors

	// Available powers (randomized!)
	var/list/power_set

	// Hungers (randomized!); always all active
	var/list/hungers

	// Distortion FX (randomized!)
	var/list/distortions

	// Slaps - penalty for ignoring Distortion too much
	var/list/slaps

	// Unlocked powers.
	var/list/unlocked_powers

	// Holding mob
	var/weakref/mob_ref

	// Kitchen sink string-keyed assoc list-of-lists for tracking objects of interest.
	// Make sure you use weakrefs for anything atoms/datums you track here!
	var/list/trackers

	// A (plain non-assoc) list of callable methods on this datum.
	// Can be extended by Powers et al. for running additional logic periodically.
	var/list/callbacks



/datum/bluespace_revenant/proc/initialize_powerinstances()
	if(isnull(GLOB.revenant_powerinstances))
		GLOB.revenant_powerinstances = list()

	if(!length(GLOB.revenant_powerinstances))
		// NOTE: we're currently doing both Powers and Hungers in one instances list
		// If we get enough of 'em that iteration is slow, consider splitting.
		for(var/RP in revenant_powers)
			var/datum/power/revenant/bs_power/newRP = new RP()
			GLOB.revenant_powerinstances[RP] = newRP

		for(var/RH in revenant_hungers)
			var/datum/power/revenant/bs_hunger/newRH = new RH()
			GLOB.revenant_powerinstances[RH] = newRH

		for(var/RD in revenant_distortions)
			var/datum/power/revenant/distortion/newRD = new RD()
			GLOB.revenant_powerinstances[RD] = newRD

		for(var/RS in revenant_slaps)
			var/datum/power/revenant/bs_slap/newRS = new RS()
			GLOB.revenant_powerinstances[RS] = newRS

	return GLOB.revenant_powerinstances


/datum/bluespace_revenant/proc/RebuildPhenomena(mob/M, list/flavors_override = null, list/powers_override = null, list/hungers_override = null, list/distortions_override = null)
	src.flavors = (isnull(flavors_override) ? src.select_flavors() : flavors_override)
	src.power_set = (isnull(powers_override) ? src.select_powers() : powers_override)
	src.hungers = (isnull(hungers_override) ? src.select_hungers() : hungers_override)
	src.distortions = (isnull(distortions_override) ? src.select_distortions() : distortions_override)
	src.slaps = src.select_slaps()

	if(!istype(M) && src.mob_ref)
		M = src.mob_ref.resolve()

	if(!istype(M))
		return

	if(!(M?.mind))
		return

	M.mind.bluespace_revenant = src

	M.remove_bsrevenant_powers()

	// Activate all Hungers
	BSR_DEBUG_LOG("Initiating Hunger unlock...")
	for(var/H in src.hungers)
		BSR_DEBUG_LOG("Proccing hunger [H] for unlockPower")
		src.unlockPower(M.mind, H, 0)

	// Insight is a free power, because Stat() is ugly and slow
	src.unlockPower(M.mind, /datum/power/revenant/bs_power/bsrevenant_insight, 0)

	// Rebuild verbs to account for added stuff
	M.make_bsrevenant()

	return TRUE


/datum/bluespace_revenant/proc/AddCallback(callback)
	if(!istype(src.callbacks))
		src.callbacks = list()

	if(isnull(callback))
		return

	if(!(callback in src.callbacks))
		src.callbacks.Add(callback)

	return src


/datum/bluespace_revenant/proc/Init(mob/M, list/flavors_override = null, list/powers_override = null, list/hungers_override = null)

	// Make sure this exists; will only do any work if it wasn't set up already
	initialize_powerinstances()

	src.callbacks = list()
	src.unlocked_powers = list()
	src.mob_ref = weakref(M)

	// Config stuff:

	if(!isnull(config?.bluespace_revenant_distortion_rate))
		src._distortion_per_tick = config.bluespace_revenant_distortion_rate

	if(!isnull(config?.bluespace_revenant_tickrate))
		src._tick_delay = max(1, config.bluespace_revenant_tickrate)  // sleep delay, in deciseconds

	if(!isnull(config?.bluespace_revenant_radius_three_distortion_threshold))
		src._threshold_threetile = max(0, config.bluespace_revenant_radius_three_distortion_threshold)

	if(!isnull(config?.bluespace_revenant_radius_five_distortion_threshold))
		src._threshold_threetile = max(0, config.bluespace_revenant_radius_five_distortion_threshold)

	if(!isnull(config?.bluespace_revenant_radius_seven_distortion_threshold))
		src._threshold_threetile = max(0, config.bluespace_revenant_radius_seven_distortion_threshold)

	if(!isnull(config?.bluespace_revenant_radius_zlevel_spread_enabled))
		// this is a boolean - if we try to process > 3 z-levels, this will be way too heavy
		src.distortion_radius_z = clamp(config.bluespace_revenant_radius_zlevel_spread_enabled, 0, 1)

	// Aaaand off we go!

	src.start_ticker()
	src.RebuildPhenomena(M, flavors_override, powers_override, hungers_override)

	return src


/datum/bluespace_revenant/New(mob/M, list/flavors_override = null, list/powers_override = null, list/hungers_override = null)
	. = ..()

	src.Init(M, flavors_override, powers_override, hungers_override)
	return
