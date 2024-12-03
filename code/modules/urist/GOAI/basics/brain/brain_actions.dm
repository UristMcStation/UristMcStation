#define BRAIN_MODULE_INCLUDED_ACTIONS 1

/datum/brain
	var/list/actionslist


/datum/brain/proc/GetAvailableActions()
	/* Abstraction layer over Action updates.
	// We need this to let nearby Smart Objects etc. yield
	// Actions to the planner.
	*/

	var/list/available_actions = list()

	for(var/action_key in src.actionslist)
		// Filter out actions w/o charges and non-action items.
		var/datum/goai_action/action = src.actionslist[action_key]

		if(!action)
			continue

		if(action.charges < 1)
			continue

		if(!(action.IsValid()))
			continue

		var/new_cost = action.ReviewPriority()
		if(!(isnull(new_cost)))
			action.cost = new_cost

		available_actions[action_key] = action

	src.actionslist = available_actions
	return available_actions


/datum/brain/proc/AddAction(var/name, var/list/preconds, var/list/effects, var/cost = null, var/charges = PLUS_INF, var/instant = FALSE, clone = FALSE, var/list/action_args = null, var/list/act_validators = null, var/cost_checker = null)
	/*
	//
	// - clone (bool): If TRUE (default), the list is a clone of the actionslist (slower, but safer).
	//                 If FALSE, a reference to the list is returned (faster, but harder to predict)
	*/
	ADD_ACTION_DEBUG_LOG("Adding action [name] with [cost] cost, [charges] charges")
	var/list/available_actions = (clone ? src.actionslist.Copy() : src.actionslist) || list()

	var/datum/goai_action/Action = null
	if(name in available_actions)
		Action = available_actions[name]

	if(isnull(Action) || (!istype(Action)))
		Action = new(preconds, effects, cost, name, charges, instant, action_args, act_validators, cost_checker)

	else
		// If an Action with the same key exists, we can update the existing object rather than reallocating!
		SET_IF_NOT_NULL(cost, Action.cost)
		SET_IF_NOT_NULL(preconds, Action.preconditions)
		SET_IF_NOT_NULL(effects, Action.effects)
		SET_IF_NOT_NULL(charges, Action.charges)
		SET_IF_NOT_NULL(instant, Action.instant)
		SET_IF_NOT_NULL(action_args, Action.arguments)
		SET_IF_NOT_NULL(act_validators, Action.validators)
		SET_IF_NOT_NULL(cost_checker, Action.cost_updater)


	available_actions[name] = Action

	return Action


/datum/brain/proc/IsActionValid(var/action_key)
	/* Brain-side Action validation.
	//
	// An Action is considered invalid if it doesn't make sense to run it.
	// For instance, if the target of the Action has been deleted, we might
	// as well not even start it.
	//
	// Preconditions violation at run-time DOES NOT *ALWAYS* make the Action
	// invalid - Preconds are primarily constraints for _planning_ and can be
	// fudged sometimes to generate specific behaviours.
	//
	// For that matter, INVALID =/= FAILED!
	// INVALID *roughly* maps to 'failed before we even started' or 'not in a runnable state'
	// Failed Actions have started, but for whatever reason we're cancelling them before completion.
	*/

	if(!action_key)
		// Nonexistence is futile.
		VALIDATE_ACTION_DEBUG_LOG("[src] VALIDATION - KEYLESS [action_key]")
		return FALSE

	if(!(action_key in src.actionslist))
		// 'Phantom' actions not allowed!
		VALIDATE_ACTION_DEBUG_LOG("[src] VALIDATION - PHANTOM [action_key]")
		return FALSE

	var/datum/goai_action/checked_action = src.actionslist[action_key]

	if(!checked_action)
		// Nonexistence is futile.
		VALIDATE_ACTION_DEBUG_LOG("[src] VALIDATION - NONEXISTENCE [action_key]/[checked_action]")
		return FALSE

	// Ask the Action to do its own checks:
	var/actionside_valid = checked_action.IsValid()

	if(!actionside_valid)
		// Trust the Action's opinion.
		VALIDATE_ACTION_DEBUG_LOG("[src] VALIDATION - ACTIONSIDE [action_key]/[checked_action]")
		return FALSE

	return TRUE



/datum/brain/verb/DoAction(Act as anything in actionslist)
	return null


/datum/brain/verb/DoInstantAction(Act as anything in actionslist)
	return null
