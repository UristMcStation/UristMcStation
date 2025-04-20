SUBSYSTEM_DEF(ai)
	name = "AI"
	init_order = SS_INIT_AI
	priority = SS_PRIORITY_AI
	wait = 2 SECONDS
#ifdef UNIT_TEST
	flags = SS_NO_INIT | SS_NO_FIRE
#else
	flags = SS_NO_INIT
#endif

	/// The set of all ai_holders currently being updated
	var/static/list/datum/ai_holder/ai_holders = list()

	/// The current queue of ai_holder instances to update
	var/static/list/datum/ai_holder/queue = list()

	/// If the queue was not finished, the index to read from on the next run
	var/static/saved_index


/datum/controller/subsystem/ai/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..({"\
		Active AI: [length(ai_holders)] \
		Run Empty Levels: [config.run_empty_levels ? "Y" : "N"]\
		Run Empty Levels strictness: [config.run_empty_levels_throttled_perc]%\
	"})


/datum/controller/subsystem/ai/fire(resumed, no_mc_tick)
	if (!resumed)
		queue = ai_holders.Copy()
		saved_index = 1
	var/queue_length = length(queue)
	if (!queue_length)
		return
	#ifdef INCLUDE_URIST_CODE
	var/throttle_on_empty = prob(config.run_empty_levels_throttled_perc) // Urist edit!
	#endif
	var/datum/ai_holder/ai
	for (var/i = saved_index to queue_length)
		ai = queue[i]
		if (QDELETED(ai) || ai.busy || !ai.holder)
			continue
		#ifndef INCLUDE_URIST_CODE
		if (!config.run_empty_levels && !SSpresence.population(get_z(ai.holder)))
			continue
		#else
		// Allow 'leaky' processing of empty, activated z-levels
		if (!config.run_empty_levels)
			var/holder_z = get_z(ai.holder)
			var/zlevel_has_pop = SSpresence.population(holder_z)
			if(!zlevel_has_pop)
				var/zlevel_had_pop = SSpresence.population_from_cache(holder_z)
				if(!zlevel_had_pop || throttle_on_empty)
					continue
		#endif
		ai.handle_strategicals()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			saved_index = i + 1
			return
	queue.Cut()


#if defined(UNIT_TEST) || defined(DEBUG_GENERATE_WORTHS)
/datum/controller/subsystem/ai/flags = SS_NO_INIT | SS_NO_FIRE
#else
/datum/controller/subsystem/ai/flags = SS_NO_INIT
#endif
