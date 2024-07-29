SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	priority = SS_PRIORITY_MOB
	flags = SS_NO_INIT | SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 2 SECONDS
	var/static/list/mob/mob_list = list()
	var/static/list/mob/queue = list()


/datum/controller/subsystem/mobs/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..({"\
		Mobs: [length(mob_list)] \
		Run Empty Levels: [config.run_empty_levels ? "Y" : "N"]\
		Run Empty Levels strictness: [config.run_empty_levels_throttled_perc]%\
	"})


/datum/controller/subsystem/mobs/Recover()
	queue.Cut()


/datum/controller/subsystem/mobs/fire(resume, no_mc_tick)
	if (!resume)
		queue = mob_list.Copy()
	var/cut_until = 1
	#ifdef INCLUDE_URIST_CODE
	var/throttle_on_empty = prob(config.run_empty_levels_throttled_perc) // Urist edit!
	#endif
	for (var/mob/mob as anything in queue)
		++cut_until
		if (QDELETED(mob))
			continue
		#ifndef INCLUDE_URIST_CODE
		if (!config.run_empty_levels && !SSpresence.population(get_z(mob)))
			continue
		#else
		// Allow 'leaky' processing of empty, activated z-levels
		if (!config.run_empty_levels)
			var/holder_z = get_z(mob)
			var/zlevel_has_pop = SSpresence.population(holder_z)
			if(!zlevel_has_pop)
				var/zlevel_had_pop = SSpresence.population_from_cache(holder_z)
				if(!zlevel_had_pop || throttle_on_empty)
					continue
		#endif
		mob.Life()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
			return
	queue.Cut()


#define START_PROCESSING_MOB(MOB) \
if (MOB.is_processing) {\
	if (MOB.is_processing != SSmobs) {\
		crash_with("Failed to start processing mob. Already being processed by [MOB.is_processing].")\
	}\
}\
else {\
	MOB.is_processing = SSmobs;\
	SSmobs.mob_list += MOB;\
}


#define STOP_PROCESSING_MOB(MOB) \
if(MOB.is_processing == SSmobs) {\
	MOB.is_processing = null;\
	SSmobs.mob_list -= MOB;\
}\
else if (MOB.is_processing) {\
	crash_with("Failed to stop processing mob. Being processed by [MOB.is_processing] instead.")\
}


/mob/dview/Initialize()
	. = ..()
	STOP_PROCESSING_MOB(src)
