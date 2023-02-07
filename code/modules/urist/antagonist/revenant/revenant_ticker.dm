// Ticker stuff

/datum/bluespace_revenant
	/* Partial definition for ticker bits! See revenant_datum.dm for main defintion! */

	// Metadata controlling the looping, 'private' vars
	var/_ticker_active = FALSE // FALSE to kill the ticker
	var/_tick_delay = 100 // sleep delay, in deciseconds
	// The ticker resolution is tunable and possibly should be tuned; this doesn't need
	// to be real-time, higher tick time/per-tick rate can be nicer on the CPU.


/datum/bluespace_revenant/proc/Tick(var/ticks = 1)
	var/safe_ticks = (ticks || 0)

	src.HandleDistortionUpdates(safe_ticks)
	src.SpreadDistortion(safe_ticks)

	if(callbacks)
		for(var/method in callbacks)
			call(src, method)(safe_ticks)

	return TRUE


/datum/bluespace_revenant/proc/start_ticker()
	if(src._ticker_active)
		return

	src._ticker_active = TRUE

	spawn(0)
		while (src && src._ticker_active)
			if(!(src._tick_delay))
				to_world_log("BSR: [src] ticker killed - tick delay became null!")

			src.Tick(1)

			// prevent runaway tickers in case someone VVs irresponsibly
			src._tick_delay = max(1, src._tick_delay)

			// this sleeps in a separate pseudo-threat, so it's not blocking the caller
			sleep(src._tick_delay)

	return TRUE


/datum/bluespace_revenant/proc/stop_ticker()
	src._ticker_active = FALSE
	return TRUE
