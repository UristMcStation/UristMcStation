/* ==  ACTION TEMPLATES  == */


/datum/utility_action_template
	/* This class represents an action *template*.
	// A true Action is Template + Context.
	// For example, Attack(<X>) is a Template where X is a context variable.
	// Attack(BadDude) is an Action where we bound BadDude as the value of X in the Attack(<X>) Template.
	//
	// IMPORTANT: While you *can* technically subclass these, a better idea is to use JSONs and SerDe methods to
	//            load in ActionTemplates from files. This makes the AI much faster to iterate on and 'moddable'.
	*/
	var/name = "Action"
	var/description = null

	var/origin = null  // who gave us this ActionTemplate (most likely an ActionSet)

	var/active = TRUE  // meant to granularly disable options (e.g. for cooldowns) without affecting the whole ActionSet.

	var/list/context_fetchers = null // a list of procs that generate candidate context for the action
	var/list/context_args = null // a list of lists of arguments argslisted into the context_fetchers; index should correspond to the ContextFetcher to route args to; optional

	// Hard Args let us parametrize functions with stuff that doesn't vary with Context (hence hard - hardcoded)
	var/list/hard_args = null // a list of arguments argslisted into the handler with the Context; optional

	var/handler = null // a proc to run if the action is actually taken
	var/handlertype = HANDLERTYPE_SRCMETHOD // whether the handler is an agent method (default), or a function

	var/instant = FALSE
	var/charges = PLUS_INF

	// Weight multiplier for a given action's urgency; please use the macro'd values for this!
	var/priority_class = UTILITY_PRIORITY_BROKEN // If SerDe goes bad, this will wind up being zero and so ignore malformed Templates

	// An arraylist of Considerations to check when deciding.
	var/list/considerations

	// GOAP data for planning + for Utility to query their status at plan execution
	var/list/preconditions
	var/list/effects

	// Special marker used for GOAP/Utility integration only.
	// If a positive int, nulls out a SmartPlan with that index upon success.
	var/_terminates_plan = null


/datum/utility_action_template/New(var/list/bound_considerations, var/handler = null, var/handlertype = null, var/context_fetchers = null, var/list/context_args = null, var/priority = null, var/charges = null, var/instant = null, var/list/hard_args = null, var/name_override = null, var/description_override = null, var/active = null, var/list/preconditions = null, var/list/effects = null)
	SET_IF_NOT_NULL(bound_considerations, src.considerations)
	SET_IF_NOT_NULL(context_fetchers, src.context_fetchers)
	SET_IF_NOT_NULL(context_args, src.context_args)
	SET_IF_NOT_NULL(handler, src.handler)
	SET_IF_NOT_NULL(handlertype, src.handlertype)
	SET_IF_NOT_NULL(priority, src.priority_class)
	SET_IF_NOT_NULL(charges, src.charges)
	SET_IF_NOT_NULL(instant, src.instant)
	SET_IF_NOT_NULL(hard_args, src.hard_args)
	SET_IF_NOT_NULL(name_override, src.name)
	SET_IF_NOT_NULL(description_override, src.description)
	SET_IF_NOT_NULL(active, src.active)
	// GOAP
	SET_IF_NOT_NULL(preconditions, src.preconditions)
	SET_IF_NOT_NULL(effects, src.effects)

	# ifdef UTILITYBRAIN_DEBUG_LOGGING
	if(!src.considerations)
		UTILITYBRAIN_DEBUG_LOG("WARNING: no Considerations bound to Action [src.name] @ L[__LINE__]!")
	# endif

	# ifdef UTILITYBRAIN_DEBUG_LOGGING
	if(!src.handler)
		UTILITYBRAIN_DEBUG_LOG("WARNING: no Handler bound to Action [src.name] @ L[__LINE__]!")
	# endif

/datum/utility_action_template/proc/GetCandidateContexts(var/requester) // Optional<Any> -> Optional<array<assoc>>
	/*
	// A mostly-convenience-API for fetching all *RELEVANT* contexts.
	// Little more than a wrapper over a dispatch to the bound proc.
	//
	// Emphasis on relevant b/c you SHOULD NOT test all possible candidates;
	// if a context is not particularly likely to succeed, don't fetch it at all!
	*/
	if(!(src.context_fetchers))
		UTILITYBRAIN_DEBUG_LOG("WARNING: no ContextFetchers bound to Action [src.name] @ L[__LINE__]!")
		return

	var/list/contexts = list()
	var/ctx_idx = 0

	for(var/context_fetcher in src.context_fetchers)
		if(!context_fetcher)
			continue

		ctx_idx++

		var/list/ctx_args = null

		if(src.context_args?.len >= ctx_idx)
			ctx_args = src.context_args[ctx_idx]

		var/list/sub_context = call(context_fetcher)(src, requester, ctx_args)
		contexts.Add(sub_context)

	UTILITYBRAIN_DEBUG_LOG("INFO: found [contexts?.len] contexts for Action [src.name] @ L[__LINE__]")
	return contexts


/datum/utility_action_template/proc/ScoreAction(var/datum/utility_action_template/action_template, var/list/context, var/requester) // (</datum/utility_action_template>, Optional<assoc>, Optional<Any>) -> float
	// Evaluates the Utility of a potential Action in the given context.
	// One Action might have different Utility for different Contexts.
	// As such, we can check multiple combinations of Template + Context and only turn the best into true Actions.
	var/score = run_considerations(
		inputs=src.considerations,
		action_template=action_template,
		context=context,
		cutoff_thresh=null,
		requester=requester,
	)
	var/utility = score * src.priority_class
	return utility


/datum/utility_action_template/proc/ToAction(var/list/bound_context, var/handler_override = null, var/handlertype_override = null, var/charges_override = null, var/instant_override = null, var/list/hard_args_override) // (Optional<assoc>, Optional<proc_ref>, Optional<num>, Optional<bool>, Optional<assoc>) -> UtilityAction
	// Turns a template into a concrete Action for the Agent to run; effectively an Action factory.
	var/action_name = src.name // todo bind args here too
	var/handler = DEFAULT_IF_NULL(handler_override, src.handler)
	var/handlertype = DEFAULT_IF_NULL(handlertype_override, src.handlertype)
	var/charges = DEFAULT_IF_NULL(charges_override, src.charges)
	var/instant = DEFAULT_IF_NULL(instant_override, src.instant)
	var/list/hard_args = DEFAULT_IF_NULL(hard_args_override, src.hard_args)

	var/list/action_args = (hard_args?.Copy() || list())

	for(var/key in bound_context)
		if(isnull(key))
			continue

		var/ctx_val = bound_context[key]
		if(!isnull(ctx_val))
			// Overwrite on conflict - context is more dynamic
			action_args[key] = ctx_val

	var/datum/utility_action/new_action = new(action_name, handler, handlertype, charges, instant, action_args)
	new_action._terminates_plan = src._terminates_plan  // sneaky sneaky
	return new_action

