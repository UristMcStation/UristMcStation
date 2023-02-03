/datum/mind
	var/datum/bluespace_revenant/bluespace_revenant


/datum/bluespace_revenant
	/* Holder for data associated with a Revenant, antag or not. */

	// Metadata controlling the looping, 'private' vars
	var/_ticker_active = TRUE // FALSE to kill the ticker
	var/_tick_delay = 100 // sleep delay, in deciseconds
	var/_distortion_per_tick = 10 // Distortion increase *per tick_time*
	// The ticker resolution is tunable and possibly should be tuned; this doesn't need
	// to be real-time, higher tick time/per-tick rate can be nicer on the CPU.

	// Flavor tags selected for this Revenant. Influences the overall vibe.
	var/list/flavors

	// Avaiable powers (randomized!)
	var/list/power_set

	// Unlocked powers.
	var/list/unlocked_powers

	// Effectively, power level accumulated. Unlocks powers. Increases over time.
	var/total_distortion = 0

	// Reduction in Distortion 'leaking out'. Indulging Hungers increases this.
	var/suppressed_distortion = 0

	// Holding mob
	var/weakref/mob_ref


/datum/bluespace_revenant/New(var/mob/M, var/list/flavors_override = null, var/list/powers_override = null)
	. = ..()

	src.unlocked_powers = list()
	src.flavors = (flavors_override ? flavors_override : src.select_flavors())
	src.power_set = (powers_override ? powers_override : src.select_powers())
	src.mob_ref = weakref(M)
	src.start_ticker()

	return


// Ticker stuff
/datum/bluespace_revenant/proc/Tick(var/ticks = 1)
	var/safe_ticks = (ticks || 0)
	src.total_distortion += (src._distortion_per_tick * safe_ticks)
	return TRUE


/datum/bluespace_revenant/proc/start_ticker()
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
