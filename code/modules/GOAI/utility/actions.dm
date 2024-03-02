/* ==  ACTION EXECUTION  == */

/datum/utility_action
	/* This class represents an action *execution*.
	// A true Action is ActionTemplate + Context.
	// For example, Attack(<X>) is a Template where X is a context variable.
	// Attack(BadDude) is an Action where we bound BadDude as the value of X in the Attack(<X>) Template.
	*/
	var/id // this will/may be assigned at runtime, as a position index in an array
	var/name = "UtilityAction"
	var/handler = null // proc
	var/handlertype = HANDLERTYPE_SRCMETHOD // whether the handler is an agent method (default), or a function
	var/instant = FALSE
	var/charges = PLUS_INF
	var/list/arguments

	// Special marker used for GOAP/Utility integration only.
	// If a positive int, nulls out a SmartPlan with that index upon success.
	var/_terminates_plan = null


/datum/utility_action/New(var/name, var/handler, var/handlertype, var/charges, var/instant = FALSE, var/list/action_args = null)
	SET_IF_NOT_NULL(name, src.name)
	SET_IF_NOT_NULL(handler, src.handler)
	SET_IF_NOT_NULL(handlertype, src.handlertype)
	SET_IF_NOT_NULL(charges, src.charges)
	SET_IF_NOT_NULL(instant, src.instant)
	SET_IF_NOT_NULL(action_args, src.arguments)


/datum/utility_action/proc/ReduceCharges(var/amt=1)
	src.charges -= amt
	return src.charges
