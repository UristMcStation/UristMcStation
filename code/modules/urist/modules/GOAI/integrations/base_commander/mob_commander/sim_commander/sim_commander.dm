/datum/goai/sim_commander
	name = "sim commander"

	var/atom/pawn
	var/datum/ActivePathTracker/active_path

	var/is_repathing = 0
	var/is_moving = 0


/datum/goai/mob_commander/sim_commander/Life()
	. = ..()

	// Perception updates
	spawn(0)
		while(src.life)
			src.SensesSystem()
			sleep(COMBATAI_SENSE_TICK_DELAY)

	// Movement updates
	spawn(0)
		while(src.life)
			src.MovementSystem()
			sleep(COMBATAI_MOVE_TICK_DELAY)

	// AI
	spawn(0)
		while(src.life)
			// Fix the tickrate to prevent runaway loops in case something messes with it.
			// Doing it here is nice, because it saves us from sanitizing it all over the place.
			src.ai_tick_delay = max((src?.ai_tick_delay || 0), 1)

			// Run the Life update function.
			src.LifeTick()

			// Wait until the next update tick.
			sleep(src.ai_tick_delay)



/datum/goai/mob_commander/sim_commander/LifeTick()
	//to_world_log("Mob Commander [src.name] [src] <[src.pawn]> LifeTick()")

	// quick hack:
	var/datum/brain/concrete/simCommander = brain
	var/panicking = GetState(STATE_PANIC, FALSE)
	var/is_different = FALSE

	if(simCommander && (simCommander.GetNeed(NEED_COMPOSURE, NEED_SATISFIED) < NEED_THRESHOLD))
		is_different = (panicking != TRUE)
		panicking = TRUE

	else if(simCommander && (simCommander.GetNeed(NEED_COMPOSURE, NEED_SATISFIED) >= NEED_THRESHOLD))
		is_different = (panicking != FALSE)
		panicking = FALSE

	if(is_different)
		SetState(STATE_PANIC, panicking)


	if(brain)
		if(brain.last_plan_successful)
			//brain.SetMemory(MEM_TRUST_BESTPOS, TRUE)
		else
			//to_world_log("[src]: Getting disoriented!")
			SetState(STATE_DISORIENTED, TRUE)
			//brain.SetMemory(MEM_TRUST_BESTPOS, FALSE, 1000)

		to_world_log("Calling LifeTick()")
		brain.LifeTick()

		for(var/datum/ActionTracker/instant_action_tracker in brain.pending_instant_actions)
			var/tracked_instant_action = instant_action_tracker?.tracked_action
			if(tracked_instant_action)
				HandleInstantAction(tracked_instant_action, instant_action_tracker)

		if(brain.running_action_tracker)
			var/tracked_action = brain.running_action_tracker.tracked_action

			if(tracked_action)
				HandleAction(tracked_action, brain.running_action_tracker)


	return

