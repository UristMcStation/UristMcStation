

/// Builds a list of z-level populations to allow for easier pauses on processing when nobody is around to care
SUBSYSTEM_DEF(presence)
	name = "Player Presence"
	priority = SS_PRIORITY_PRESENCE
	runlevels = RUNLEVEL_GAME
	wait = 2 SECONDS
	var/static/list/levels = list()
	var/static/list/queue = list()
	var/static/list/build
	#ifdef INCLUDE_URIST_CODE
	var/static/list/activated_levels = list()
	#endif


/datum/controller/subsystem/presence/Recover()
	queue.Cut()
	build.Cut()


/datum/controller/subsystem/presence/fire(resume, no_mc_tick)
	if (!resume)
		queue = GLOB.player_list.Copy()
		build = list()
	var/cut_until = 1
	for (var/mob/living/player as anything in GLOB.living_players)
		++cut_until
		if (QDELETED(player) || player.stat == DEAD)
			continue
		++build["[get_z(player)]"]
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
			return
	++build["[GLOB.using_map.overmap_z]"]
	levels = build
	queue.Cut()


#if !defined(UNIT_TEST) && !defined(DEBUG_GENERATE_WORTHS)

/datum/controller/subsystem/presence/flags = SS_NO_INIT

/// 0, or the number of living players on level
/datum/controller/subsystem/presence/proc/population(level)
	#ifndef INCLUDE_URIST_CODE
	return levels["[level]"] || 0
	#else
	// Urist edit - caching levels that HAD pop at some point
	var/pop = levels["[level]"]
	if(pop)
		activated_levels["[level]"] = pop
	return pop || 0
	#endif

#ifdef INCLUDE_URIST_CODE
/// like .population(), but returns the cached value
/datum/controller/subsystem/presence/proc/population_from_cache(level)
	return activated_levels["[level]"]
#endif

#else

/datum/controller/subsystem/presence/flags = SS_NO_INIT | SS_NO_FIRE

/datum/controller/subsystem/presence/proc/population(level)
	return 1

#ifdef INCLUDE_URIST_CODE
/datum/controller/subsystem/presence/proc/population_from_cache(level)
	return 1
#endif

#endif
