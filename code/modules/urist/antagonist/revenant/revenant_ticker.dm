// Ticker stuff

/datum/bluespace_revenant/proc/Tick(var/ticks = 1)
	var/safe_ticks = (ticks || 0)
	src.total_distortion += (src._distortion_per_tick * safe_ticks)

	if(callbacks)
		for(var/method in callbacks)
			call(src, method)(ticks)

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
