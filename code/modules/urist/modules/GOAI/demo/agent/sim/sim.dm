
/mob/goai/sim
	var/decay_per_dsecond = 0.1


/mob/goai/sim/verb/InspectGoaiLife()
	set src in view(1)
	usr << "X=======================X"
	usr << "|"
	usr << "| [name] - ALIVE: [life]"
	usr << "|"

	var/path_list = (active_path ? active_path.path : "<No path for null>")
	var/list/brain_plan = null
	var/plan_len = "<No len for null>"
	var/brain_is_planning = null

	if(brain)
		brain_plan = brain.active_plan
		plan_len = (brain_plan ? brain_plan.len : plan_len)
		brain_is_planning = brain.is_planning

		for (var/need_key in brain.needs)
			usr << "| [need_key]: [needs[need_key]]"
	else
		usr << "| (brainless)"

	usr << "|"
	usr << "| ACTIVE PATH: [active_path] ([path_list])"
	usr << "| ACTIVE PLAN: [brain_plan] ([plan_len])"
	usr << "|"
	usr << "| PLANNING: [brain_is_planning]"
	usr << "| REPATHING: [is_repathing]"
	usr << "|"
	usr << "X=======================X"




/mob/goai/sim/proc/GetActionLookup()
	var/list/action_lookup = list()
	action_lookup["Sleep"] = /mob/goai/sim/proc/HandleSleeping
	action_lookup["Idle"] = /mob/goai/sim/proc/HandleIdling
	action_lookup["Eat"] = /mob/goai/sim/proc/HandleEating
	action_lookup["Work"] = /mob/goai/sim/proc/HandleWorking
	action_lookup["Party"] = /mob/goai/sim/proc/HandlePartying
	action_lookup["Shop"] = /mob/goai/sim/proc/HandleShopping
	return action_lookup


/mob/goai/sim/proc/HandleAction(var/datum/goai_action/action, var/datum/ActionTracker/tracker)
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

			/*for(var/alkey in action_lookup)
				world.log << "[src] action lookup: [alkey] => [action_lookup[alkey]]"*/

			//world.log << "[src]: Actionproc for [action] is [actionproc || "null"]"

			if(isnull(actionproc))
				tracker.SetFailed()

			else
				call(src, actionproc)(tracker)

				if(action.instant)
					break

		var/safe_ai_delay = max(1, AI_TICK_DELAY)
		sleep(safe_ai_delay)



/*
/mob/goai/sim/verb/DoAction(Act as anything in actionslist)
	world.log << "DoAction act: [Act]"

	if(!(Act in actionslist))
		return null

	if(!brain)
		return null

	var/datum/ActionTracker/new_actiontracker = brain.DoAction(Act)

	return new_actiontracker


/mob/goai/sim/proc/CreatePlan(var/list/status, var/list/goal)
	if(!brain)
		return

	var/list/path = brain.CreatePlan(status, goal)
	return path
*/

/*/mob/goai/sim/proc/DecayNeeds()
	brain.DecayNeeds()*/


/mob/goai/sim/Life()
	// Movement updates
	spawn(0)
		while(life)
			MovementSystem()
			sleep(AI_TICK_DELAY)

	// AI
	spawn(0)
		while(life)
			LifeTick()
			sleep(AI_TICK_DELAY)


/mob/goai/sim/proc/MovementSystem()
	if(!(active_path))
		return

	var/atom/next_step = ((active_path.path && active_path.path.len) ? active_path.path[1] : null)
	if(next_step == src.loc)
		lpop(active_path.path)
		next_step = ((active_path.path && active_path.path.len) ? lpop(active_path.path) : null)

	var/atom/followup_step = ((active_path.path && active_path.path.len >= 2) ? active_path.path[2] : null)

	if(next_step)
		step_towards(src, next_step, 0)

		var/success = ((src.x == next_step.x) && (src.y == next_step.y))

		if(success)
			active_path.frustration = 0
			lpop(active_path.path)

		else
			active_path.frustration++

		if(active_path.frustration > 2)
			randMove()

		if(active_path.frustration > 7 && (is_repathing <= 0) && followup_step)
			// repath
			var/frustr_x = followup_step.x
			var/frustr_y = followup_step.y
			world.log << "FRUSTRATIoN, repath avoiding [next_step] @ ([frustr_x], [frustr_y])!"
			StartNavigateTo(active_path.target, active_path.min_dist, next_step, active_path.frustration)

	return


/mob/goai/sim/proc/LifeTick()
	if(brain)
		brain.LifeTick()

		if(brain.running_action_tracker)
			var/tracked_action = brain.running_action_tracker.tracked_action
			if(tracked_action)
				HandleAction(tracked_action, brain.running_action_tracker)

	return


/mob/goai/sim/Move()
	..()


/mob/goai/sim/proc/randMove()
	var/moving_to = 0 // otherwise it always picks 4
	moving_to = pick(SOUTH, NORTH, WEST, EAST)
	dir = moving_to //How about we turn them the direction they are moving, yay.
	Move(get_step(src,moving_to))


/mob/goai/sim/proc/Idle()
	if(prob(10))
		randMove()

