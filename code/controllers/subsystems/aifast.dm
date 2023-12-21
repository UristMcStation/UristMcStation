SUBSYSTEM_DEF(aifast)
	name = "AI (Fast)"
	init_order = SS_INIT_AIFAST
	priority = SS_PRIORITY_AI
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 0.25 SECONDS
	var/static/list/datum/ai_holder/ai_holders = list()
	var/static/list/datum/ai_holder/queue = list()


/datum/controller/subsystem/aifast/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..({"\
		Active AI: [length(ai_holders)] \
		Run Empty Levels: [config.run_empty_levels ? "Y" : "N"]\
		Run Empty Levels strictness: [config.run_empty_levels_throttled_perc]%\
	"})


/datum/controller/subsystem/aifast/fire(resume, no_mc_tick)
	if (!resume)
		queue = ai_holders.Copy()
		if (!length(queue))
			return
	var/cut_until = 1
	#ifdef INCLUDE_URIST_CODE
	var/throttle_on_empty = prob(config.run_empty_levels_throttled_perc) // Urist edit!
	#endif
	for (var/datum/ai_holder/ai as anything in queue)
		++cut_until
		if (QDELETED(ai) || ai.busy)
			continue
		if (!ai.holder)
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
		ai.handle_tactics()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
			return
	queue.Cut()


#if defined(UNIT_TEST) || defined(DEBUG_GENERATE_WORTHS)
/datum/controller/subsystem/aifast/flags = SS_NO_INIT | SS_NO_FIRE
#else
/datum/controller/subsystem/aifast/flags = SS_NO_INIT
#endif
