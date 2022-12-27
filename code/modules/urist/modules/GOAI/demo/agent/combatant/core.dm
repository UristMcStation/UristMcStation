/* In this module:
===================

 - HandleAction core logic
 - AI Mainloop (Life()/LifeTick())
 - Init for subsystems per AI (by extension - it's in Life())

*/

# define STEP_SIZE 1
# define STEP_COUNT 1



/mob/goai/combatant/proc/HandleAction(var/datum/goai_action/action, var/datum/ActionTracker/tracker)
	MAYBE_LOG("Tracker: [tracker]")
	var/running = 1

	var/list/action_lookup = actionlookup // abstract maybe
	if(isnull(action_lookup))
		return

	while (tracker && running)
		// TODO: Interrupts
		running = tracker.IsRunning()

		MAYBE_LOG("[src]: Tracker: [tracker] running @ [running]")

		spawn(0)
			// task-specific logic goes here
			MAYBE_LOG("[src]: HandleAction action is: [action]")

			var/actionproc = action_lookup[action.name]

			var/list/action_args = list()
			action_args["tracker"] = tracker
			action_args += action.arguments

			if(isnull(actionproc))
				tracker.SetFailed()

			else
				call(src, actionproc)(arglist(action_args))

				if(action.instant)
					break

		var/safe_ai_delay = max(1, src.ai_tick_delay)
		sleep(safe_ai_delay)


/mob/goai/combatant/proc/HandleInstantAction(var/datum/goai_action/action, var/datum/ActionTracker/tracker)
	MAYBE_LOG("Tracker: [tracker]")

	var/list/action_lookup = actionlookup // abstract maybe
	if(isnull(action_lookup))
		return

	MAYBE_LOG("[src]: Tracker: [tracker] running @ [tracker?.IsRunning()]")
	MAYBE_LOG("[src]: HandleAction action is: [action]")

	var/actionproc = action_lookup[action.name]

	var/list/action_args = list()
	action_args["tracker"] = tracker
	action_args += action.arguments

	if(isnull(actionproc))
		tracker.SetFailed()

	else
		call(src, actionproc)(arglist(action_args))

	return
/*
/mob/goai/combatant/verb/DoAction(Act as anything in actionslist)
	to_world_log("DoAction act: [Act]")

	if(!(Act in actionslist))
		return null

	if(!brain)
		return null

	var/datum/ActionTracker/new_actiontracker = brain.DoAction(Act)

	return new_actiontracker


/mob/goai/combatant/proc/CreatePlan(var/list/status, var/list/goal)
	if(!brain)
		return

	var/list/path = brain.CreatePlan(status, goal)
	return path
*/

/*/mob/goai/combatant/proc/DecayNeeds()
	brain.DecayNeeds()*/


/mob/goai/combatant/Life()
	// Perception updates
	spawn(0)
		while(life)
			SensesSystem()
			sleep(COMBATAI_SENSE_TICK_DELAY)

	// Movement updates
	spawn(0)
		while(life)
			MovementSystem()
			sleep(COMBATAI_MOVE_TICK_DELAY)

	// AI
	spawn(0)
		while(life)
			// Fix the tickrate to prevent runaway loops in case something messes with it.
			// Doing it here is nice, because it saves us from sanitizing it all over the place.
			src.ai_tick_delay = max((src?.ai_tick_delay || 0), 1)

			// Run the Life update function.
			LifeTick()

			// Wait until the next update tick.
			sleep(src.ai_tick_delay)

	// Combat system; decoupled from generic planning/actions to make it run
	// *in parallel* to other behaviours - e.g. run-and-gun or fire from cover
	spawn(0)
		while(life)
			FightTick()
			sleep(COMBATAI_FIGHT_TICK_DELAY)



/mob/goai/combatant/proc/LifeTick()
	// quick hack:
	var/datum/brain/concrete/combatbrain = brain
	var/panicking = GetState(STATE_PANIC, FALSE)
	var/is_different = FALSE

	if(combatbrain && (combatbrain.GetNeed(NEED_COMPOSURE, NEED_SATISFIED) < NEED_THRESHOLD))
		is_different = (panicking != TRUE)
		panicking = TRUE

	else if(combatbrain && (combatbrain.GetNeed(NEED_COMPOSURE, NEED_SATISFIED) >= NEED_THRESHOLD))
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


/mob/goai/combatant/proc/Idle()
	if(prob(50))
		randMove()


/mob/goai/dummy
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "amorphic"
