
/datum/utility_ai/verb/DoAction(Act as anything in src.GetAvailableActions())
	set waitfor = FALSE
	sleep(0)

	RUN_ACTION_DEBUG_LOG("INFO: Running DoAction: [Act] | <@[src]> | L[__LINE__] in [__FILE__]")

	var/datum/utility_action/utility_act = Act

	var/datum/ActionTracker/new_actiontracker = src.running_action_tracker

	if(isnull(new_actiontracker))
		new_actiontracker = new /datum/ActionTracker(utility_act)
	else
		// Object pooling
		var/should_run = new_actiontracker.IsStopped()  // if already running, no need to spin up a thread
		new_actiontracker.Initialize(utility_act, run=should_run)

	if(!new_actiontracker)
		RUN_ACTION_DEBUG_LOG("ERROR: Failed to create a tracker for [utility_act]! | <@[src]> | L[__LINE__] in [__FILE__]")
		return null

	running_action_tracker = new_actiontracker

	// Update the tracked Action stack for Considerations
	if(src.brain)
		src.brain.SetMemory(MEM_ACTION_MINUS_TWO, src.brain.GetMemoryValue(MEM_ACTION_MINUS_ONE), RETAIN_LAST_ACTIONS_TTL)
		src.brain.SetMemory(MEM_ACTION_MINUS_ONE, utility_act.name, RETAIN_LAST_ACTIONS_TTL)
		src.brain.SetMemory("LastActionEffects", utility_act.name, RETAIN_LAST_ACTIONS_TTL)

	return new_actiontracker
