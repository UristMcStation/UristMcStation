/*
//                            SPECIAL SAUCE
//
// I am not only enough of a madman to write an established AI architecture in *DM*, oh no.
// I went and integrated Utility and GOAP as well to make both better. *In goddamn BYOND*.
//
// This module contains the core of the GOAP/Utility integration. The Serde module has a bit more.
//
// In short, IAUS Utility is the main driver, but we can make requests to GOAP to plan.
// Preconds/Effects are largely shared between both AI subsystems (except for those
// prefixed by an underscore, which are GOAP-only and used to give hints to the planner).
//
// The GOAP plan, if found, gets transformed into a SmartObject providing Utility actions.
//
// This means we get the long-term planning benefits of GOAP with the tactical flexibility of Utility.
//
// For instance, if our GOAP plan expected a door to be locked before opening it, but a friendly NPC
// has handled unlocking for our agent, the unlocking step will be ignored and we'll jump straight to
// getting the door open.
//
// Conversely, if the agent is merrily strolling to open the door and someone locks the door back,
// this approach will allow the agent to backtrack to the unlocking step without requiring a replan.
//
// Considering the massive cost of GOAP replans, this implies a HUGE optimization for the AI system.
// Furthermore, as the plan actions are no longer strictly sequential, we can prune equivalent GOAP
// plans from consideration, further reducing the search space and accelerating planning.
//
// TL;DR - all the strategic power of GOAP with the speed and flexibility of Utility AI.
*/

# define GOAPPLAN_ACTIONSET_PATH "goai_data/smartobject_definitions/goapplan.json"

// DYNAMIC QUERY SYNTAX: <Querytype>:<Typeval>@<Target>=><Outkey> WHERE
// - Querytype: what kind of query this is, e.g. 'type' for type matching
// - Typeval: what exactly are we searching for in this querytype, e.g. '/foo/bar' to find typesof /foo/bar'
// - Target: var to search, e.g. 'contents'
// - Outkey: key to write results to, e.g. 'HasBar'
# define DYNAMIC_WS_QUERY_REGEX @"\?(\w+?):(.+?)@(\w*?)=>(\w+)"


/datum/utility_ai
	var/list/ai_worldstate = null


/proc/RunDynamicWorldStateQuery(var/datum/target, var/query = null, var/parsed_querytype = null, var/parsed_typeval = null, var/parsed_targvar = null)
	// A leading questionmark in a precond/effect indicates a *Dynamic Worldstate Query* (TM)
	// (this is as opposed to a NON-dynamic one, which is just a simple assoc lookup).
	//
	// This is used for info we cannot reasonably calculate upfront,
	// e.g. <type>InInventory - would require nigh-infinite memory to store all possible types.
	//
	// Input can either be a query or the relevant data already parsed OUT of the query.
	// If the data is not provided, the query will be parsed for the details.
	// Otherwise, the explicit parsed data takes precedence.
	//
	// This is primarily to allow users to parse the query earlier and forward the results to this call.

	if(isnull(target))
		return

	var/raw_querytype = parsed_querytype
	var/raw_typeval = parsed_typeval
	var/raw_targvar = parsed_targvar

	if(isnull(parsed_querytype) || isnull(parsed_typeval) || isnull(parsed_targvar))
		// Try to get those from the query
		if(!query)
			return

		// a minimum of 1 for leading '?', 1 for colon, 1 for @ and 3 single-char vars
		// if that's not there, this will never parse so there's no point building a regex
		ASSERT(length(query) >= 6)
		var/not_matched = TRUE

		# ifdef USE_REGEX_CACHE
		if(not_matched)
			// lazy init in case it didn't happen/got nulled out
			REGEX_CACHE_LAZY_INIT(0)

			var/list/uncached_match = GOAI_LIBBED_GLOB_ATTR(regex_cache)[query]

			if(istype(uncached_match) && length(uncached_match) == 4)
				raw_querytype = uncached_match[1]
				raw_typeval = uncached_match[2]
				raw_targvar = uncached_match[3]
				// we don't need the fourth item here
				not_matched = FALSE

			else
				to_world_log("DEBUG: Regex Cache miss for [query]: [uncached_match] ([length(uncached_match)])")
		# endif

		if(not_matched)
			var/regex/ws_query_regex = regex(DYNAMIC_WS_QUERY_REGEX)

			ASSERT(ws_query_regex.Find(query))

			raw_querytype = ws_query_regex.group[1]
			raw_typeval = ws_query_regex.group[2]
			raw_targvar = ws_query_regex.group[3]

			not_matched = FALSE

			# ifdef USE_REGEX_CACHE
			// update the cache
			GOAI_LIBBED_GLOB_ATTR(regex_cache)[query] = list(raw_querytype, raw_typeval, raw_targvar, ws_query_regex.group[4])
			# endif

	var/typeval

	// I'm building a DSL in BYOND. Truly the darkest timeline.
	switch(raw_querytype)
		if("findtype_in_var")
			// Query any var (indicated by the @<varname> syntax) for a matching type.
			typeval = text2path(raw_typeval)
			ASSERT(ispath(typeval))

			var/searchval = target.vars[raw_targvar]

			if(islist(searchval))
				var/list/searchlist = searchval

				// For lists, check if we have any instance of type or subtypes in it
				for(var/itm in searchlist)
					if(istype(itm, typeval))
						return TRUE

			else
				return istype(searchval, typeval)

		if("findtype_in_inventory")
			// Query contents, recursively. Less flexible than findtype_in_var, but recursive.
			// Because this is fairly heavy (modulo caching), it's best used for a 'retrieve from box'-type actions,
			// so that you can get the item from findtype_in_var@contents later

			typeval = text2path(raw_typeval)
			ASSERT(ispath(typeval))

			var/atom/curr_target = null
			var/queue_pos = 1
			// we are not using a PriorityQueue here because a list is cheaper and BFS/DFS likely doesn't make a serious difference
			// (though I may regret saying that later)
			var/list/queue = list(target)

			while(queue_pos <= length(queue))
				// cannot do a for-loop since we're mutating the queue
				curr_target = queue[queue_pos++]

				if(!istype(curr_target))
					continue

				var/list/searchlist = curr_target.contents

				if(!islist(searchlist))
					continue

				for(var/itm in searchlist)
					if(istype(itm, typeval))
						// match, early return
						return TRUE

					if(istype(itm, /atom))
						// no match, but might be a container
						queue.Add(itm)

			// ain't found nothing
			return FALSE

		else
			// parsing error!
			ASSERT(FALSE)

	return FALSE


/datum/utility_ai/proc/QueryWorldState(var/list/trg_queries = null)
	if(isnull(src.ai_worldstate))
		src.ai_worldstate = list()
		src.ai_worldstate["global"] = list()

	var/list/worldstate = src.ai_worldstate.Copy()

	if(trg_queries?.len)
		for(var/datum/trg_key in trg_queries)
			var/list/qry = trg_queries[trg_key]

			if(isnull(qry))
				continue

			if(isnull(worldstate[trg_key]))
				worldstate[trg_key] = list()

			for(var/query_key in qry)
				var/result
				var/output_key = query_key

				if(query_key[1] == "?")
					// question mark signifies a dynamic query
					var/raw_querytype
					var/raw_typeval
					var/raw_targvar
					var/raw_outkey

					var/not_matched = TRUE

					# ifdef USE_REGEX_CACHE
					if(not_matched)
						// lazy init in case it didn't happen/got nulled out
						REGEX_CACHE_LAZY_INIT(0)

						var/list/uncached_match = GOAI_LIBBED_GLOB_ATTR(regex_cache)[query_key]

						if(istype(uncached_match) && length(uncached_match) == 4)
							raw_querytype = uncached_match[1]
							raw_typeval = uncached_match[2]
							raw_targvar = uncached_match[3]
							raw_outkey = uncached_match[4]
							not_matched = FALSE

						else
							to_world_log("DEBUG: Regex Cache miss for [query_key]: [uncached_match] ([length(uncached_match)])")
					# endif

					if(not_matched)
						var/regex/ws_query_regex = regex(DYNAMIC_WS_QUERY_REGEX)

						ASSERT(ws_query_regex.Find(query_key))

						raw_querytype = ws_query_regex.group[1]
						raw_typeval = ws_query_regex.group[2]
						raw_targvar = ws_query_regex.group[3]
						raw_outkey = ws_query_regex.group[4]

						not_matched = FALSE

						# ifdef USE_REGEX_CACHE
						// update the cache
						GOAI_LIBBED_GLOB_ATTR(regex_cache)[query_key] = list(raw_querytype, raw_typeval, raw_targvar, raw_outkey)
						# endif

					ASSERT(!not_matched)
					ASSERT(!isnull(raw_querytype))
					ASSERT(!isnull(raw_typeval))
					ASSERT(!isnull(raw_targvar))
					ASSERT(!isnull(raw_outkey))

					var/awaiting_result = TRUE

					# ifdef USE_DYNAQUERY_CACHE
					var/dynaquery_cache_key = "[trg_key]/[query_key]"

					if(awaiting_result)
						// TODO: TTL FOR CACHE!
						DYNAQUERY_CACHE_LAZY_INIT(0)
						var/cand_ttl = GOAI_LIBBED_GLOB_ATTR(dynamic_query_cache_ttls)[dynaquery_cache_key]
						var/global_ttl = GOAI_LIBBED_GLOB_ATTR(dynamic_query_cache_ttls)["global_ttl"]

						if(isnull(global_ttl))
							// drop the whole cache periodically to avoid garbage accumulation
							// we fuzz the TTL to avoid everything happening all at once
							GOAI_LIBBED_GLOB_ATTR(dynamic_query_cache_ttls)["global_ttl"] = world.time + DYNAMIC_QUERY_CACHE_GLOBAL_TTL + rand(-DYNAMIC_QUERY_CACHE_GLOBAL_TTL_FUZZ, DYNAMIC_QUERY_CACHE_GLOBAL_TTL_FUZZ)
						else
							if(world.time >= global_ttl)
								DYNAQUERY_CACHE_INVALIDATE(0)

						if(!isnull(cand_ttl) && world.time < cand_ttl)
							var/cand_result = GOAI_LIBBED_GLOB_ATTR(dynamic_query_cache)[dynaquery_cache_key]

							if(!isnull(cand_result))
								result = cand_result
								awaiting_result = FALSE
					# endif

					if(awaiting_result)
						result = RunDynamicWorldStateQuery(trg_key, null, raw_querytype, raw_typeval, raw_targvar)
						awaiting_result = FALSE
						# ifdef USE_DYNAQUERY_CACHE
						DYNAQUERY_CACHE_LAZY_INIT(0)
						GOAI_LIBBED_GLOB_ATTR(dynamic_query_cache)[dynaquery_cache_key] = result
						GOAI_LIBBED_GLOB_ATTR(dynamic_query_cache_ttls)[dynaquery_cache_key] = world.time + DYNAMIC_QUERY_CACHE_TTL
						# endif

					//output_key = raw_outkey
					output_key = query_key // I think this will work better; just use the outkey for GOAP

				else
					result = trg_key.GetWorldstateValue(query_key)

				worldstate[trg_key][output_key] = result

	return worldstate


/datum/order_smartobject
	/*
	// A fairly lightweight generic "here's something to solve for with planning" marker.
	// By giving one to an agent, you're effectively requesting the AI to solve for a certain
	// state for a given target.
	//
	// Things like Doors having Actions to plan for opening them are effectively a special case
	// of this pattern where we've offloaded the equivalent logic to an actual physical object.
	//
	// Orders just let us make things a bit more generic and allow users to specify arbitrary
	// goals on arbitrary targets.
	*/

	// optional-ish, identifier for debugging:
	var/name

	// An assoc of worldstate values we require our plan to result in
	// e.g. {"IsOpen": 1} to request a plan to open a door (using Python dict notation as shorthand)
	var/list/goal_state = null

	// Who do we want to apply those worldstate values to (e.g. WHICH door to open)
	var/datum/target

	// Utility Considerations required to *plan*
	// (i.e. separate from the Considerations of plan Actions themselves!)
	var/list/planning_considerations = null

	no_smartobject_caching = TRUE // caching causes pain here


/datum/order_smartobject/New(var/list/new_goal_state, var/datum/new_target, var/list/new_planning_considerations, var/name = null)
	. = ..()
	src.goal_state = new_goal_state
	src.target = new_target
	src.planning_considerations = new_planning_considerations
	src.name = DEFAULT_IF_NULL(name, src.name)
	return


/datum/order_smartobject/GetUtilityActions(var/requester, var/list/args = null) // (Any, assoc) -> [ActionSet]
	var/list/actions = list()

	var/action_key = src.name

	var/list/considerations = (isnull(src.planning_considerations) ? list() : src.planning_considerations)
	considerations.Add(/proc/consideration_input_always) // devjunk, remove me!

	var/list/ctxprocs = list(/proc/ctxfetcher_read_origin_var)
	var/list/context_args = list()
	var/list/hard_args = list()

	var/list/primary_context = list()

	primary_context["variable"] = "target" // i.e. src.target
	primary_context["output_context_key"] = "target" // the arg used by the handler

	// nested sublists =_=
	ARRAY_APPEND(context_args, primary_context)

	hard_args["goal_state"] = src.goal_state

	var/desc = "plan for order: [json_encode(src.goal_state)]"

	var/datum/utility_action_template/new_action_template = new(
		considerations, //considerations
		/datum/utility_ai/mob_commander/proc/PlanForGoal, //handler
		HANDLERTYPE_SRCMETHOD, //handler_type
		ctxprocs, //ctxprocs
		context_args, //context_args
		3, //priority
		2, //charges
		FALSE, //instant
		hard_args, //hard_args
		action_key, //action_key
		desc, //act_description
		TRUE, // instant
		// GOAP stuff
		null, //preconds,
		null //effects
	)

	var/used_name = (src.name || desc)

	new_action_template.name = used_name
	new_action_template.origin = src
	actions.Add(new_action_template)

	var/datum/action_set/myset = new(used_name, actions)

	ASSERT(!isnull(myset))

	var/list/my_action_sets = list()
	myset.origin = src
	my_action_sets.Add(myset)

	return my_action_sets



/datum/plan_smartobject
	/* Represents a Plan of Actions. Grants SO Actions corresponding to what's in the plan. */

	// optional-ish, identifier for debugging:
	var/name

	// the actual plan
	var/list/plan

	// an assoc of metadata; things like the target etc.
	var/list/bound_context

	// number of failed steps; if this is too high, invalidate the plan
	var/frustration = 0

	no_smartobject_caching = TRUE // caching causes pain here


/datum/plan_smartobject/New(var/list/new_plan, var/list/new_bound_context, var/new_name = null)
	if(!isnull(new_name))
		src.name = new_name

	src.plan = new_plan
	src.bound_context = new_bound_context

	if(!isnull(src.name))
		// Potentially, cache by destination later.
		src.smartobject_cache_key = "[json_encode(src.plan)]([json_encode(src.bound_context)])"


/proc/ActionSetFromGoapPlan(var/list/plan, var/list/bound_context, var/name, var/requester = null) // [Action] -> ActionSet
	// Plan assumed to be a simple array-style list of action KEYS
	// (meaning: just strings, no further metadata; we need to do a JOIN)

	if(isnull(GOAI_GLOBAL_LIST_PREFIX(global_plan_actions_repo)))
		InitializeGlobalPlanActionsRepo()

	var/list/planned_actions = list()
	var/list/plan_context = (isnull(bound_context) ? list() : bound_context)

	// wip targetting stuff
	var/action_target = plan_context["action_target"]

	// Running tracker of preconds/effects.
	// To ensure proper sequencing, the preconds of each Action must be the 'base' Preconds AND all predecessors' Effects
	//var/list/preconds_blackboard = list()

	var/plan_len = length(plan)
	var/action_idx = plan_len

	while(action_idx)
		var/action_key = plan[action_idx--]

		var/list/action_data = GOAI_GLOBAL_LIST_PREFIX(global_plan_actions_repo)[action_key]
		ASSERT(!isnull(action_data))

		var/has_movement = action_data[JSON_KEY_PLANACTION_HASMOVEMENT]
		var/target_key = action_data[JSON_KEY_PLANACTION_TARGET_KEY]

		var/list/common_consideration_args = list(
			"target_key" = target_key,
			"from_context" = TRUE
		)

		// Could override hiMark to slightly above 1 if cycling should be possible but heavily discouraged;
		// the higher hiMark is, the more permissive this will be.
		// Should probably be done using some optional JSON var; not gonna bother for now.
		var/datum/consideration/not_cyclic_consideration = new(
			input_val_proc = /proc/consideration_actiontemplate_effects_cycling,
			curve_proc = /proc/curve_antilinear,
			loMark = 0,
			hiMark = 1,
			noiseScale = 0,
			name = "NotCyclic",
			active = TRUE,
			consideration_args = list(
				"memory_key" = "SelectedActionTemplate"
			)
		)

		var/datum/consideration/effects_consideration = new(
			input_val_proc = /proc/consideration_actiontemplate_effects_not_all_met,
			curve_proc = /proc/curve_linear,
			loMark = 0,
			hiMark = 1,
			noiseScale = 0,
			name = "EffectsNotMet",
			active = TRUE,
			consideration_args = common_consideration_args
		)

		var/datum/consideration/preconds_consideration = new(
			input_val_proc = /proc/consideration_actiontemplate_preconditions_met,
			curve_proc = /proc/curve_linear,
			loMark = 0,
			hiMark = 1,
			noiseScale = 0,
			name = "PrecondsAllMet",
			active = TRUE,
			consideration_args = common_consideration_args
		)

		var/list/considerations = list(
			not_cyclic_consideration,
			effects_consideration,
			preconds_consideration
		)
		var/raw_handler_proc = action_data[JSON_KEY_PLANACTION_RAW_HANDLERPROC]
		var/handler_proc = action_data[JSON_KEY_PLANACTION_HANDLERPROC]

		var/list/hard_args = list()

		var/list/context_args = list()

		// targetting, very wip:
		context_args["action_target"] = action_target
		context_args["contextarg_variable"] = "action_target"

		var/loc_key = action_data[JSON_KEY_PLANACTION_HANDLER_LOCARG]
		context_args["output_context_key"] = loc_key

		if(has_movement)
			// Sneakily substitute the raw function with a decorated one
			hard_args["ai_proc"] = handler_proc
			hard_args["location_key"] = loc_key

			// Introspect function path to check whether it's a method or not
			// We need this because of how the call() syntax works
			var/is_func = (findtextEx(raw_handler_proc, "/proc/") == 1)
			hard_args["is_func"] = is_func

			context_args["output_context_key"] = "location" // always this for the hardcoded decorator

			handler_proc = /datum/utility_ai/mob_commander/proc/MoveToAndExecuteWrapper

			// TODO this could be more sophisticated, e.g. a pair of distance considerations (Too Near/Too Far)
			var/datum/consideration/distance_consideration = new(
				input_val_proc = /proc/consideration_input_manhattan_distance_to_requester,
				curve_proc = /proc/curve_linear_leaky,
				loMark = 1,
				hiMark = 20,
				noiseScale = 0,
				name = "TargetNearby",
				active = TRUE,
				consideration_args = list(
					"input_key" = target_key,
					"from_context" = 1
				)
			)
			considerations.Add(distance_consideration)

		var/raw_override_ctxproc = action_data[JSON_KEY_PLANACTION_CTXFETCHER_OVERRIDE]
		var/override_ctxproc = (isnull(raw_override_ctxproc) ? null : STR_TO_PROC(raw_override_ctxproc))
		var/contextfetcher = (isnull(override_ctxproc) ? /proc/ctxfetcher_read_another_contextarg : override_ctxproc)

		var/list/ctxprocs = list(
			// by default, the context is the target of the plan
			contextfetcher
		)

		var/list/extra_ctx_args = action_data[JSON_KEY_PLANACTION_CTXARGS]

		for(var/extra_ctx_section in extra_ctx_args)
			for(var/arg_key in extra_ctx_section)
				var/arg_val = extra_ctx_section[arg_key]
				context_args[arg_key] = arg_val

		var/list/all_context_args = list()
		ARRAY_APPEND(all_context_args, context_args)

		var/priority = action_data[JSON_KEY_PLANACTION_PRIORITY]
		if(isnull(priority))
			priority = DEFAULT_PLANACTION_PRIORITY

		var/charges = null
		var/instant = FALSE
		var/act_description = action_data[JSON_KEY_PLANACTION_DESCRIPTION]

		var/list/raw_preconds = action_data[JSON_KEY_PLANACTION_PRECONDITIONS]
		if(isnull(raw_preconds))
			raw_preconds = list()

		var/list/effects = action_data[JSON_KEY_PLANACTION_EFFECTS]

		if(isnull(effects))
			effects = list()


		// This is meant to sequence actions better
		// Commented out to try reversing the insertion order
		//UPSERT_ASSOC_LTR(effects, preconds_blackboard)
		//var/list/preconds = preconds_blackboard.Copy()
		//UPSERT_ASSOC_LTR(raw_preconds, preconds)
		var/list/preconds = raw_preconds

		var/datum/utility_action_template/new_action_template = new(
			considerations,
			handler_proc,
			HANDLERTYPE_SRCMETHOD,
			ctxprocs,
			all_context_args,
			priority,
			charges,
			instant,
			hard_args,
			action_key,
			act_description,
			TRUE,
			// GOAP stuff
			preconds,
			effects
		)

		if(action_idx == plan_len)
			new_action_template._terminates_plan = 1 + length(planned_actions) // because we append after this
			new_action_template._terminates_plan_hash = ref(plan)

		// Package it up!
		planned_actions.Add(new_action_template)

	var/datum/action_set/plan_actionset = new(
		name = name,
		included_actions = planned_actions,
		origin = isnull(requester) ? plan : requester
		// TODO: could use a freshness proc w/ the plan as args
	)
	return plan_actionset


/datum/plan_smartobject/GetUtilityActions(var/requester, var/list/args = null) // (Any, assoc) -> [ActionSet]
	var/datum/action_set/myset = ActionSetFromGoapPlan(src.plan, src.bound_context, "TestPlan", src)
	ASSERT(!isnull(myset))

	var/list/my_action_sets = list()

	myset.origin = src
	my_action_sets.Add(myset)

	return my_action_sets
