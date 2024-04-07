/* Concrete implementation of the Brain logic using GOAP planners
//
// This would be the MAIN brain code implementation!
// The underscore in the filename is just to trick DM into sorting this correctly.
*/


/datum/brain/concrete


/datum/brain/concrete/CreatePlan(var/list/status, var/list/goal, var/list/actions = null)
	is_planning = 1
	var/list/path = null

	var/list/params = list()
	// You don't have to pass args like this; this is just to make things a bit more readable.
	params["start"] = status
	params["goal"] = goal
	/* For functional API variant:
	params["graph"] = available_actions
	params["adjacent"] = /proc/get_actions_agent
	params["check_preconds"] = /proc/check_preconds_agent
	params["goal_check"] = /proc/goal_checker_agent
	params["get_effects"] = /proc/get_effects_agent
	*/
	params["cutoff_iter"] = planning_iter_cutoff

	// For the classy API variant:
	/* Dynamically update actions; this isn't strictly necessary for a simple AI,
	// but it lets us do things like Smart Object updating our actionspace by
	// serving 'their' actions (similar to how BYOND Verbs can broadcast themselves
	// to other nearby objects with set src in whatever).
	*/
	planner.graph = (isnull(actions) ? GetAvailableActions() : actions)

	for(var/goalkey in goal)
		PLANNING_DEBUG_LOG("[src] CreatePlan goal: [goalkey] => [goal[goalkey]]")

	path = planner.Plan(arglist(params))
	last_plan_successful = (!isnull(path))

	is_planning = 0
	return path


/datum/brain/concrete/CleanDelete()
	deregister_ai_brain(src.registry_index)
	qdel(src)
	return TRUE



/datum/brain/concrete/ShouldCleanup()
	. = FALSE

	if(src.cleanup_detached_threshold < 0)
		return FALSE

	if(src._ticks_since_detached > src.cleanup_detached_threshold)
		return TRUE

	return


/datum/brain/concrete/CheckForCleanup()
	. = ..()

	if(.)
		return .

	var/should_clean = src.ShouldCleanup()
	if(should_clean)
		src.CleanDelete()
		qdel(src)
		return TRUE

	if(!(src.attachments && istype(src.attachments)))
		return FALSE

	var/ai_index = src.attachments[ATTACHMENT_CONTROLLER_BACKREF]
	var/orphaned = (IS_REGISTERED_AIBRAIN(ai_index))

	if(orphaned)
		src._ticks_since_detached++
	else
		src._ticks_since_detached = 0

	return


/datum/brain/concrete/Life()
	while(life)
		CheckForCleanup()
		LifeTick()
		sleep(AI_TICK_DELAY)
	return


/datum/brain/concrete/proc/OnBeginLifeTick()
	return


/datum/brain/concrete/proc/BuildGoalState(var/list/curr_state) // -> assoc list(k: v)
	/* Builds a Map of {Goal Key: Target Val} for the Planner to solve for. */
	var/list/goal_state = list()

	/* This class follows a simple scheme: "get all Needs above a threshold min. value";
	// expressive, but requires all Needs to be perfectly satisfiable.
	//
	// A potential alternative strategy is to pick a single Need with max priority or a mix
	// where one Need MUST be fully satisfied, but others just need to be above a 'meh' level.
	*/
	for (var/need_key in needs)
		var/need_val = needs[need_key]
		curr_state[need_key] = need_val

		if (need_val < NEED_THRESHOLD)
			goal_state[need_key] = NEED_SAFELEVEL

	return goal_state


/datum/brain/concrete/proc/OnInvalidAction(var/action_key) // -> bool
	/* If the Action is invalid, what do we do?
	//
	// Returns a bool, indicating whether to try planning again in the same tick.
	*/

	// By default, abandon ship.
	var/datum/goai_action/action = src.actionslist[action_key]
	RUN_ACTION_DEBUG_LOG("INVALID ACTION: [action_key]/[action] | <@[src]>")
	action?.ReduceCharges(action.charges)
	src.AbortPlan()
	return TRUE


/datum/brain/concrete/proc/HandlePlanningState()
	/* Wrapper around CreatePlan() logic. Ensures the plan is valid.*/

	var/list/curr_state = src.states.Copy()

	// Build the state we're solving for
	var/list/goal_state = BuildGoalState(curr_state)

	if (goal_state && goal_state.len && (!is_planning))
		var/list/curr_available_actions = GetAvailableActions()

		spawn(0)
			var/list/raw_active_plan = CreatePlan(curr_state, goal_state, curr_available_actions)

			if(raw_active_plan)
				var/first_clean_pos = 0

				for (var/planstep in raw_active_plan)
					first_clean_pos++

					if(planstep in curr_available_actions)
						break

				raw_active_plan.Cut(0, first_clean_pos)
				src.active_plan = raw_active_plan
				src.last_plan_successful = TRUE

			else
				RUN_ACTION_DEBUG_LOG("Failed to create a plan | <@[src]>")

	else //satisfied, can be lazy
		Idle()

	return


/datum/brain/concrete/LifeTick()
	var/run_count = 0
	var/target_run_count = 1
	var/do_plan = FALSE

	OnBeginLifeTick() // hook

	while(run_count++ < target_run_count)
		/* STATE: Running */
		if(running_action_tracker) // processing action
			RUN_ACTION_DEBUG_LOG("ACTIVE ACTION: [running_action_tracker.tracked_action] @ [running_action_tracker.IsRunning()] | <@[src]>")

			if(running_action_tracker.replan)
				do_plan = TRUE
				target_run_count++
				src.AbortPlan(FALSE)

			else if(running_action_tracker.is_done)
				src.NextPlanStep()
				target_run_count++

			else if(running_action_tracker.is_failed)
				src.AbortPlan(FALSE)


		/* STATE: Ready */
		else if(selected_action) // ready to go
			RUN_ACTION_DEBUG_LOG("SELECTED ACTION: [selected_action] | <@[src]>")

			var/is_valid = src.IsActionValid(selected_action)

			RUN_ACTION_DEBUG_LOG("SELECTED ACTION [selected_action] VALID: [is_valid ? "TRUE" : "FALSE"]")

			if(is_valid)
				running_action_tracker = src.DoAction(selected_action)

			else
				var/should_rerun = src.OnInvalidAction(selected_action)
				if(should_rerun)
					target_run_count++

			selected_action = null


		/* STATE: Pending next stage */
		else if(active_plan && active_plan.len)
			//step done, move on to the next
			RUN_ACTION_DEBUG_LOG("ACTIVE PLAN: [active_plan] ([active_plan.len]) | <@[src]>")
			DEBUG_LOG_LIST_ARRAY(active_plan, RUN_ACTION_DEBUG_LOG)

			while(active_plan.len && isnull(selected_action))
				// do instants in one tick
				selected_action = lpop(active_plan)

				if(!(selected_action in actionslist))
					continue

				var/datum/goai_action/goai_act = src.actionslist[selected_action]

				if(!goai_act)
					continue

				if(goai_act.instant)
					RUN_ACTION_DEBUG_LOG("Instant ACTION: [selected_action] | <@[src]>")
					DoInstantAction(selected_action)
					selected_action = null

				else
					RUN_ACTION_DEBUG_LOG("Regular ACTION: [selected_action] | <@[src]>")


		else //no plan & need to make one
			do_plan = TRUE


		/* STATE: Planning */
		if(do_plan)
			var/should_retry = HandlePlanningState()
			if(should_retry)
				target_run_count++

	return


/datum/brain/verb/DoAction(Act as anything in actionslist)
	if(!(Act in actionslist))
		return null

	var/datum/goai_action/goai_act = actionslist[Act]

	if(!goai_act)
		return null

	var/datum/ActionTracker/new_actiontracker = new /datum/ActionTracker(goai_act)

	if(!new_actiontracker)
		RUN_ACTION_DEBUG_LOG("[src]: Failed to create a tracker for [goai_act]!")
		return null

	running_action_tracker = new_actiontracker
	return new_actiontracker


/datum/brain/verb/DoInstantAction(Act as anything in actionslist)
	if(!(Act in actionslist))
		return null

	var/datum/goai_action/goai_act = actionslist[Act]

	if(!goai_act)
		return null

	var/datum/ActionTracker/new_actiontracker = new /datum/ActionTracker(goai_act)

	if(!new_actiontracker)
		RUN_ACTION_DEBUG_LOG("[src]: Failed to create a tracker for [goai_act]!")
		return null

	pending_instant_actions.Add(new_actiontracker)

	return new_actiontracker


/datum/brain/concrete/proc/Idle()
	return


/datum/brain/concrete/proc/NextPlanStep()
	src.running_action_tracker = null
	return TRUE


/datum/brain/concrete/AbortPlan(var/mark_failed = TRUE)
	if(mark_failed)
		// Mark the plan as failed
		src.last_plan_successful = FALSE
		src.running_action_tracker?.SetFailed()

	// Cancel current tracker, if any is running
	src.running_action_tracker = null

	// Cancel all instant and regular Actions
	PUT_EMPTY_LIST_IN(src.pending_instant_actions)
	src.active_plan = null
	src.selected_action = null

	return TRUE


/* Motives */
/datum/brain/concrete/proc/GetMotive(var/motive_key)
	if(isnull(motive_key))
		return

	if(!(motive_key in needs))
		return

	var/curr_value = needs[motive_key]
	return curr_value


/datum/brain/concrete/proc/ChangeMotive(var/motive_key, var/value)
	if(isnull(motive_key))
		return

	var/fixed_value = min(NEED_MAXIMUM, max(NEED_MINIMUM, (value)))
	needs[motive_key] = fixed_value
	last_need_update_times[motive_key] = world.time
	MOTIVES_DEBUG_LOG("Curr [motive_key] = [needs[motive_key]] <@[src]>")


/datum/brain/concrete/proc/AddMotive(var/motive_key, var/amt)
	if(isnull(motive_key))
		return

	var/curr_val = needs[motive_key] || ((NEED_MAXIMUM - NEED_MINIMUM) / 2)
	ChangeMotive(motive_key, curr_val + amt)
