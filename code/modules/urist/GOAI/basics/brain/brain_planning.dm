
/datum/brain
	var/list/active_plan

	/* Used to monitor if the brain has gotten 'stuck', unable to create a new plan.
	// This can be observed downstream (even in other objects) by a handler.
	// Successfully creating a plan resets this to TRUE.
	*/
	var/last_plan_successful = TRUE

	/* Bookkeeping for action execution */
	var/is_planning = 0
	var/list/pending_instant_actions = null
	var/selected_action = null
	var/datum/ActionTracker/running_action_tracker = null

	/* GOAP parameters */
	var/planning_iter_cutoff = 30
	var/datum/GOAP/planner


/datum/brain/proc/CreatePlan(var/list/status, var/list/goal, var/list/actions = null)
	return


/datum/brain/proc/AbortPlan()
	return
