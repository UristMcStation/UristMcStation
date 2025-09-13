
/datum/brain/concrete/proc/HandlePlanningState()
	/* Wrapper around CreatePlan() logic. Ensures the plan is valid.*/

	#ifdef BRAIN_MODULE_INCLUDED_STATES
	var/list/curr_state = src.states.Copy()
	#endif
	#ifndef BRAIN_MODULE_INCLUDED_STATES
	var/list/curr_state = list()
	#endif

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
