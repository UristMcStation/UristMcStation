/datum/mind
	var/datum/bluespace_revenant/bluespace_revenant


/datum/bluespace_revenant
	/* Holder for data associated with a Revenant, antag or not. */

	// Metadata controlling the looping, 'private' vars
	var/_ticker_active = FALSE // FALSE to kill the ticker
	var/_tick_delay = 100 // sleep delay, in deciseconds
	var/_distortion_per_tick = 10 // Distortion increase *per tick_time*
	// The ticker resolution is tunable and possibly should be tuned; this doesn't need
	// to be real-time, higher tick time/per-tick rate can be nicer on the CPU.

	// Flavor tags selected for this Revenant. Influences the overall vibe.
	var/list/flavors

	// Available powers (randomized!)
	var/list/power_set

	// Hungers (randomized!); always all active
	var/list/hungers

	// Unlocked powers.
	var/list/unlocked_powers

	// Effectively, power level accumulated. Unlocks powers. Increases over time.
	var/total_distortion = 0

	// Reduction in Distortion 'leaking out'. Indulging Hungers increases this.
	var/suppressed_distortion = 0

	// Holding mob
	var/weakref/mob_ref

	// Kitchen sink string-keyed assoc list-of-lists for tracking objects of interest.
	// Make sure you use weakrefs for anything atoms/datums you track here!
	var/list/trackers



/datum/bluespace_revenant/proc/initialize_powerinstances()
	if(isnull(GLOB.revenant_powerinstances))
		GLOB.revenant_powerinstances = list()

	if(!(GLOB.revenant_powerinstances.len))
		// NOTE: we're currently doing both Powers and Hungers in one instances list
		// If we get enough of 'em that iteration is slow, consider splitting.
		for(var/RP in revenant_powers)
			var/datum/power/revenant/bs_power/newRP = new RP()
			GLOB.revenant_powerinstances[RP] = newRP

		for(var/RH in revenant_hungers)
			var/datum/power/revenant/bs_hunger/newRH = new RH()
			GLOB.revenant_powerinstances[RH] = newRH

	return GLOB.revenant_powerinstances


/datum/bluespace_revenant/proc/Init(var/mob/M, var/list/flavors_override = null, var/list/powers_override = null, var/list/hungers_override = null)
	. = ..()

	// Make sure this exists; will only do any work if it wasn't set up already
	initialize_powerinstances()

	src.unlocked_powers = list()
	src.flavors = (isnull(flavors_override) ? src.select_flavors() : flavors_override)
	src.power_set = (isnull(powers_override) ? src.select_powers() : powers_override)
	src.hungers = (isnull(hungers_override) ? src.select_hungers() : hungers_override)
	src.mob_ref = weakref(M)
	src.start_ticker()

	if(!(M?.mind))
		return

	M.mind.bluespace_revenant = src
	to_world_log("Set Revenant on mob mind!")

	// Activate all Hungers
	to_world_log("Initiating Hunger unlock...")
	for(var/H in src.hungers)
		to_world_log("Proccing hunger [H] for unlockPower")
		src.unlockPower(M.mind, H, 0)

	// Temporary dev measure - unlock all powers immediately
	to_world_log("Initiating debug power unlock...")
	for(var/P in src.power_set)
		to_world_log("Proccing power [P] for unlockPower")
		src.unlockPower(M.mind, P, 0)

	// Rebuild verbs to account for added stuff
	M.make_bsrevenant()
	return src


/datum/bluespace_revenant/New(var/mob/M, var/list/flavors_override = null, var/list/powers_override = null, var/list/hungers_override = null)
	. = ..()

	src.Init(M, flavors_override, powers_override, hungers_override)
	return


// Ticker stuff
/datum/bluespace_revenant/proc/Tick(var/ticks = 1)
	var/safe_ticks = (ticks || 0)
	src.total_distortion += (src._distortion_per_tick * safe_ticks)
	return TRUE


/datum/bluespace_revenant/proc/start_ticker()
	if(src._ticker_active)
		return

	src._ticker_active = TRUE

	spawn(0)
		while (src && src._ticker_active)
			if(!(src._tick_delay))
				to_world_log("[src] ticker killed - tick delay became null!")

			src.Tick(1)

			// prevent runaway tickers in case someone VVs irresponsibly
			src._tick_delay = max(1, src._tick_delay)

			// this sleeps in a separate pseudo-threat, so it's not blocking the caller
			sleep(src._tick_delay)

	return TRUE


/datum/bluespace_revenant/proc/stop_ticker()
	src._ticker_active = FALSE
	return TRUE


// Helpers
/datum/bluespace_revenant/proc/get_effective_distortion(var/total_distortion_override = null, var/suppressed_distortion_override = null)
	var/raw_true_total_distortion = (isnull(total_distortion_override) ? src.total_distortion : total_distortion_override)
	var/raw_true_suppressed_distortion = (isnull(suppressed_distortion_override) ? src.suppressed_distortion : suppressed_distortion_override)

	var/true_total_distortion = max(0, raw_true_total_distortion)
	var/true_suppressed_distortion = max(0, raw_true_suppressed_distortion)

	var/raw_effective_distortion = (true_total_distortion - true_suppressed_distortion)
	var/effective_distortion = max(0, raw_effective_distortion)

	return effective_distortion

