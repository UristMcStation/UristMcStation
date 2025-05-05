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
	params["adjacent"] = GLOBAL_PROC_REF(get_actions_agent)
	params["check_preconds"] = GLOBAL_PROC_REF(check_preconds_agent)
	params["goal_check"] = GLOBAL_PROC_REF(goal_checker_agent)
	params["get_effects"] = GLOBAL_PROC_REF(get_effects_agent)
	*/
	params["cutoff_iter"] = planning_iter_cutoff

	// For the classy API variant:
	/* Dynamically update actions; this isn't strictly necessary for a simple AI,
	// but it lets us do things like Smart Object updating our actionspace by
	// serving 'their' actions (similar to how BYOND Verbs can broadcast themselves
	// to other nearby objects with set src in whatever).
	*/
	#ifdef BRAIN_MODULE_INCLUDED_ACTIONS
	planner.graph = (isnull(actions) ? GetAvailableActions() : actions)
	#else
	planner.graph = (isnull(actions) ? list() : actions)
	#endif

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


#ifdef BRAIN_MODULE_INCLUDED_ACTIONS

/datum/brain/concrete/DoAction(Act as anything in actionslist)
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


/datum/brain/concrete/DoInstantAction(Act as anything in actionslist)
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

#endif

/datum/brain/concrete/proc/Idle()
	return


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

	#ifdef BRAIN_MODULE_INCLUDED_METRICS
	last_need_update_times[motive_key] = world.time
	#endif

	MOTIVES_DEBUG_LOG("Curr [motive_key] = [needs[motive_key]] <@[src]>")


/datum/brain/concrete/proc/AddMotive(var/motive_key, var/amt)
	if(isnull(motive_key))
		return

	var/curr_val = needs[motive_key] || ((NEED_MAXIMUM - NEED_MINIMUM) / 2)
	ChangeMotive(motive_key, curr_val + amt)
