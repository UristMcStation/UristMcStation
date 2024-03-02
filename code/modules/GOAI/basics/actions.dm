/* GOAI Action datastructure.
//
// This is effectively a metadata wrapper for the AI.
// The attributes mark up details about the Action for the planner.
*/

/datum/goai_action
	/* What initial state we need to be in to initiate the Action.
	//
	// NOTE: This is *NOT* guaranteed to be fulfilled at runtime.
	//       The Planner will *try* to ensure that it is to the best of
	//       its knowledge, but it might be mistaken.
	//       If that happens, the action may or may not fail at runtime.
	*/
	var/list/preconditions

	/* What state changes will executing this Action result in.
	//
	// NOTE: This does *NOT* need to be strictly true (and we can
	//       leverage this to keep the AI pursuing the same goal),
	//       but if we lie too badly, the plans will often fail.
	*/
	var/list/effects

	/* Parameters to pass to the Action, as an assoc array.
	// Basically like Python **kwargs, will be unpacked into named args.
	*/
	var/list/arguments

	/* Priority */
	var/cost = 10 // standard

	/* Name, for debugging */
	var/name = "Action"

	/* If < 1, action not available for execution.
	// Each execution depletes the charges.
	// For one-off, dynamically inserted Actions mostly.
	*/
	var/charges = PLUS_INF

	/* If TRUE, finishes 'instantly' from the AI PoV, so we
	// run it in the same AI tick and go to the next Action
	// (or finish the current plan and create a new one).
	//
	// Any number of Instant actions can run before a non-Instant
	// action; they all follow the same rules on preconds/effects
	// as non-Instants.
	//
	// This can be a good tool to set up dependencies for another
	// Action without wasting ticks or baking them in in the dependant.
	// For example,  we can factor out pathfinding to an Instant Action
	// that sets up a non-Instant, MoveTo action.
	*/
	var/instant = FALSE

	/* Optional list of proc references; each should return a boolean.
	// If set, will be called by the IsValid() method to
	// test the instance of the calling Action.
	//
	// Note that this is NOT the same as Preconditions! An invalid Action
	// is one that had been CORRECTLY planned for, but became invalid LATER;
	// for example, OpenDoorForTarget(D, T) becomes invalid if the door D
	// had been deleted or the target T has changed.
	//
	// ORDER MATTERS! The Action will be invalidated on the first failing Validator.
	*/
	var/list/validators = null
	// potentially carry an arglist for validators too?

	var/cost_updater = null


/datum/goai_action/New(var/list/new_preconds, var/list/new_effects, var/new_cost = null, var/new_name = null, var/new_charges = null, var/is_instant = null, var/list/action_args = null, var/list/new_validators = null, var/new_cost_updater = null)
	src.name = (isnull(new_name) ? name : new_name)
	src.cost = (isnull(new_cost) ? cost : new_cost)
	src.preconditions = (new_preconds || list())
	src.effects = (new_effects || list())
	src.charges = (isnull(new_charges) ? charges : new_charges)
	src.instant = (isnull(is_instant) ? instant : is_instant)
	src.arguments = (action_args || list())
	src.validators = ((new_validators && new_validators.len) ? new_validators : src.validators)
	src.cost_updater = (new_cost_updater ? new_cost_updater : src.cost_updater)


/datum/goai_action/proc/ReduceCharges(var/amt=1)
	src.charges -= amt
	return src.charges


/datum/goai_action/proc/ReviewPriority()
	if(!(src.cost_updater))
		return src.cost

	var/new_cost = call(src.cost_updater)(src)

	if(isnull(new_cost))
		return src.cost

	return new_cost


/datum/goai_action/proc/IsValid()
	/* Action-side pre-flight validation.
	//
	// IOW: this allows the Action to invalidate itself by returning FALSE
	// to indicate it should no longer be available BEFORE getting launched
	// but AFTER getting planned.
	//
	// This would usually happen if the world has changed beneath our feet;
	// for example, the target of an action got deleted or died.
	//
	// This is NOT meant to check Preconditions, generally speaking, unless
	// you want to be 100% sure the Action doesn't make sense if a Precondition
	// is not in an expected state - most of the time though, let the Planner worry
	// about these kinds of scenarios.
	//
	// NOTE: the AI Brains can do their own validation on top of this.
	*/

	if(isnull(src.charges) || src.charges <= 0)
		return FALSE

	if(src.validators)
		for(var/validator in validators)
			// Dynamic proc call. Validator is a Fn(Action) -> bool.
			var/valid = call(validator)(src)
			if(!valid)
				return FALSE

	return TRUE
