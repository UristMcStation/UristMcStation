// Those Actions are only used for development, either as placeholders or for emitting debugging data.

/datum/utility_ai/proc/PrintArg(var/datum/ActionTracker/tracker, var/printarg)
	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("ActionTracker is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(tracker.IsStopped())
		return

	to_world("PrintArg action from [src] - printarg is: [printarg || "null"]")

	tracker.SetDone()
	return


/datum/utility_ai/proc/GlobalWorldstateFlipBoolean(var/datum/ActionTracker/tracker, var/list/worldstate_keys)
	// Toggles the values of boolean World State globals to their negation (so FALSE -> TRUE and TRUE -> FALSE)

	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("ActionTracker is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(tracker.IsStopped())
		return

	if(isnull(src.ai_worldstate)) { src.ai_worldstate = list() }

	for(var/worldstate_key in worldstate_keys)
		var/current = src.ai_worldstate[worldstate_key]

		if(isnull(current))
			current = FALSE

		var/newval = !current
		src.ai_worldstate[worldstate_key] = newval

	tracker.SetDone()
	return



/datum/utility_ai/proc/GlobalWorldstateSetStateMap(var/datum/ActionTracker/tracker, var/list/new_worldstate_map)
	// Sets the values of World State globals to the values provided in the input hashmap.
	// Stateless and idempotent, some risk of race conditions.

	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("ActionTracker is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(tracker.IsStopped())
		return

	if(isnull(src.ai_worldstate)) { src.ai_worldstate = list() }

	if(isnull(new_worldstate_map))
		return

	for(var/worldstate_key in new_worldstate_map)
		var/new_worldstate_val = new_worldstate_map[worldstate_key]
		src.ai_worldstate[worldstate_key] = new_worldstate_val

	tracker.SetDone()
	return
