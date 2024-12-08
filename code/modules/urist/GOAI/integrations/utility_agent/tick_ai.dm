/*
// For messy, historical reasons, the core AI loop had been implemented in the Brain class rather than the AI class
// (namely: the AI object came later by factoring out the AI from the mob class).
//
// This is the NEW implementation - the AI holds the whole logic and only uses the Brain as a data store.
//
// This might be messy for a while as brain stuff gets ported.
*/


/datum/utility_ai
	// Add all the vars for bookkeeping plan/execution states
	var/is_planning = 0
	var/list/pending_instant_actions = null
	var/selected_action = null
	var/datum/ActionTracker/running_action_tracker = null
	var/list/active_plan = null

	// Cached queue for sorting highest priorities
	// This saves us doing a full object alloc on each decision tick
	var/PriorityQueue/utility_ranking

	//
	var/unranked_actions = FALSE

	// Optional path to proc.
	// Proc must take a single argument, which is the reference to the calling AI.
	// It should return an LOD level constant (use macros for convenience).
	//
	// The LOD level determines how much detail we allow for the AI - high LOD means
	// full fidelity, low LOD means we simplify and abstract for higher performance
	// when players wouldn't see these details.
	//
	// For example, there is no point running full pathfinding (max LOD) for AI mobs
	// on a ship that hasn't yet been encountered by the players. We MAYBE want to
	// run only coarse simulation to move the pawns between rooms on a schedule
	// or something (lower LOD) if it's within 'medium' range, but we can disable it
	// entirely (zero LOD) if it's in the 'far' range.
	//
	// If null, this step is simply ignored, defaulting to a sane LOD.
	var/dynamic_lod_check = null

	// Tracking current state.
	// Nuke the dynamic_lod_check and set this manually if you want to override it for badmin reasons.
	var/current_lod = GOAI_LOD_STANDARD

	// AI LODs at which to run this.
	// min <= current <= max to tick.
	var/min_lod = GOAI_LOD_FACTION_LOW
	var/max_lod = GOAI_LOD_HIGHEST


/datum/utility_ai/proc/AbortPlan(var/mark_failed = TRUE)
	if(mark_failed)
		// Mark the plan as failed
		src.brain.last_plan_successful = FALSE
		src.running_action_tracker?.SetFailed()

	// Cancel current tracker, if any is running
	if(src.running_action_tracker)
		src.running_action_tracker.process = FALSE
		src.running_action_tracker = null

	// Cancel all instant and regular Actions
	PUT_EMPTY_LIST_IN(src.pending_instant_actions)
	PUT_EMPTY_LIST_IN(src.active_plan)
	src.selected_action = null

	return TRUE


/datum/utility_ai/proc/NextPlanStep()
	if(src.running_action_tracker)
		src.running_action_tracker.process = FALSE
		src.running_action_tracker = null

	return TRUE


/datum/utility_ai/proc/GetAvailableActions(var/no_cache = null)
	var/_no_cache = DEFAULT_IF_NULL(no_cache, src.disable_so_cache)
	var/list/actionsets = list()

	var/list/smartobjects = src.brain?.GetMemoryValue("SmartObjects", null)
	var/list/smart_paths = src.brain?.GetMemoryValue("AbstractSmartPaths", null)
	var/list/smart_plans = src.brain?.GetMemoryValue("SmartPlans", null)
	var/list/smart_orders = src.brain?.GetMemoryValue("SmartOrders", null)

	if(isnull(smartobjects))
		smartobjects = list()

	if(smart_paths)
		for(var/path_key in smart_paths)
			var/datum/path_smartobject/path_so = smart_paths[path_key]
			if(istype(path_so))
				smartobjects.Add(path_so)

	if(smart_plans)
		for(var/datum/plan_smartobject/plan_so in smart_plans)
			smartobjects.Add(plan_so)

	if(smart_orders)
		for(var/datum/order_smartobject/order_so in smart_orders)
			smartobjects.Add(order_so)

	// Innate actions; note that these should be used fairly sparingly
	// (to avoid checking for actions we could never take anyway).
	// Mostly useful for abstract AIs that have no natural pawns some of the time.
	smartobjects.Add(src)

	// currently implicit since we always can see ourselves
	// should prolly do a 'if X not in list already', but BYOOOOND

	// The Pawn is a SmartObject too!
	var/datum/pawn = src.GetPawn()
	if(!isnull(pawn))
		smartobjects.Add(pawn)

	if(smartobjects)
		for(var/datum/SO in smartobjects)
			var/list/SO_actionsets = src.GetActionSetsFromSmartObject(SO, src, null, _no_cache)

			if(!isnull(SO_actionsets))
				actionsets.Add(SO_actionsets)

	/*
	if(src.smart_objects)
		if(isnull(src.smartobject_last_fetched))
			src.smartobject_last_fetched = list()

		for(var/datum/smart_object/SO in src.smart_objects)
	*/

	return actionsets


/datum/utility_ai/proc/ScoreActions(var/list/actionsets)
	set waitfor = FALSE

	if(src.unranked_actions)
		// already running, don't call again
		return

	src.unranked_actions = TRUE
	sleep(-1)

	if(isnull(src.utility_ranking))
		// initialize if not done yet
		src.utility_ranking = new DEFAULT_PRIORITY_QUEUE_IMPL(/datum/Triple/proc/FirstTwoCompare)
	else
		// clear last tick's data so we start fresh
		src.utility_ranking.L.Cut()

	# ifdef UTILITYBRAIN_LOG_ACTIONCOUNT
	var/template_count = 0
	# endif

	var/our_lod = DEFAULT_IF_NULL(src.current_lod, GOAI_LOD_STANDARD)

	for(var/datum/action_set/actionset in actionsets)
		if(!(actionset?.active))
			continue

		var/list/actions = actionset?.actions
		if(!actions)
			continue

		for(var/datum/utility_action_template/action_template in actions)
			# ifdef UTILITYBRAIN_LOG_ACTIONCOUNT
			template_count++
			# endif

			var/action_minlod = DEFAULT_IF_NULL(action_template.min_lod, GOAI_LOD_LOWEST)
			if(our_lod < action_minlod)
				continue

			var/action_maxlod = DEFAULT_IF_NULL(action_template.max_lod, GOAI_LOD_STANDARD)
			if(our_lod > action_maxlod)
				continue

			var/list/contexts = action_template.GetCandidateContexts(src)

			if(contexts)
				# ifdef UTILITYBRAIN_LOG_CONTEXTS
				UTILITYBRAIN_DEBUG_LOG("Found contexts ([contexts.len]) | <@[src]>")
				# endif

				# ifdef UTILITYBRAIN_LOG_CONTEXTS
				var/ctxidx = 0
				# endif

				for(var/ctx in contexts)
					# ifdef UTILITYBRAIN_LOG_CONTEXTS
					// Yes, this is a triple-nested for-loop, and that's fine since we're looping
					// over different categories. In particular, the first two loops are effectively
					// one loop with a top-level optimization (skip all disabled actions in a set).
					//
					// That said, the amount of evaluated Contexts should be kept tightly constrained.
					// Only fetch contexts that are likely to be a) relevant & b) executed.
					UTILITYBRAIN_DEBUG_LOG("ScoreAction context: [ctx]")
					var/subctx_idx = 0
					for(var/subctx in ctx)
						subctx_idx++
						try
							UTILITYBRAIN_DEBUG_LOG("ScoreAction subcontext: [subctx] [ctx[subctx]] @ [subctx_idx]")
						catch(var/exception/e)
							UTILITYBRAIN_DEBUG_LOG("[e]")
							UTILITYBRAIN_DEBUG_LOG("ScoreAction subcontext: [subctx] @ [subctx_idx]")
						DEBUG_LOG_LIST_ASSOC(subctx, to_world_log)
					# endif

					var/utility = action_template.ScoreAction(action_template, ctx, src)
					if(utility > 0.01)
						// tiebreaker noise
						utility -= (0.01 * rand())

					# ifdef UTILITYBRAIN_LOG_UTILITIES
					UTILITYBRAIN_DEBUG_LOG("Utility for [action_template?.name]([json_encode(ctx)]): [utility] (priority: [action_template?.priority_class]) | <@[src]>")
					UTILITYBRAIN_DEBUG_LOG("=========================")
					UTILITYBRAIN_DEBUG_LOG(" ")
					# endif

					if(utility <= 0)
						// To prevent impossible actions from being considered!
						continue

					var/datum/Triple/scored_action = new(utility, action_template, ctx)
					src.utility_ranking.Enqueue(scored_action)

			else
				// Some actions could have a 'null' context (i.e. they don't care about the world-state)
				// We should support this to avoid alloc-ing empty lists for efficiency, at the cost of smol code duplication
				var/utility = action_template.ScoreAction(action_template, null, src) // null/default context

				if(utility <= 0)
					// To prevent impossible actions from being considered!

					# ifdef UTILITYBRAIN_LOG_UTILITIES
					UTILITYBRAIN_DEBUG_LOG("REJECTED [action_template?.name] due to zero Utility score [utility]")
					# endif

					continue

				var/datum/Triple/scored_action = new(utility, action_template, null) // ...and here, as a triple!
				src.utility_ranking.Enqueue(scored_action)


	# ifdef UTILITYBRAIN_LOG_ACTIONCOUNT
	UTILITYBRAIN_DEBUG_LOG(" ")
	UTILITYBRAIN_DEBUG_LOG("INFO: Processed [template_count] ActionTemplates")
	UTILITYBRAIN_DEBUG_LOG(" ")
	#endif

	src.unranked_actions = FALSE
	return utility_ranking


/datum/utility_ai/proc/HandlePlanningState()
	/* Main selection logic.
	// Runs through all available actions,
	// scores them by utility,
	// selects a high-utility action.
	*/

	set waitfor = FALSE
	sleep(0)

	var/loop_retries = 0

	// selection left intentionally vague; will probably do deterministic as PoC and weighted sampling later

	if(!is_planning)
		is_planning = TRUE

		var/list/actionsets = src.GetAvailableActions()

		if(!actionsets)
			RUN_ACTION_DEBUG_LOG("WARNING: Actionsets empty! (len: [length(actionsets)]) | <@[src]> | [__FILE__] -> L[__LINE__]")
			return

		var/datum/Triple/best_act_tup = null
		src.ScoreActions(actionsets)

		while(src.unranked_actions && loop_retries < 10)
			loop_retries++
			sleep(1)

		while(src.utility_ranking.L && loop_retries < 10)
			// pop first not-null item
			var/best_act_res = utility_ranking.Dequeue()

			best_act_tup = best_act_res
			if(best_act_tup)
				break

			loop_retries++

		if(isnull(best_act_tup))
			RUN_ACTION_DEBUG_LOG("ERROR: Best action tuple is null! [best_act_tup], Actionset count: [length(actionsets)] | <@[src]> | [__FILE__] -> L[__LINE__]")
			return

		var/datum/utility_action_template/best_action_template = best_act_tup.middle
		var/list/best_action_ctx = best_act_tup.right
		var/datum/utility_action/best_action = best_action_template.ToAction(best_action_ctx)

		src.brain.SetMemory("SelectedActionTemplate", best_action_template)

		if(best_action)
			PUT_EMPTY_LIST_IN(src.active_plan)
			src.active_plan.Add(best_action)

		else
			RUN_ACTION_DEBUG_LOG("ERROR: Best action is null! | <@[src]> | [__FILE__] -> L[__LINE__]")

	else //satisfied, can be lazy
		Idle()

	is_planning = FALSE
	return


/datum/utility_ai/proc/OnBeginLifeTick()
	return


/datum/utility_ai/proc/LifeTick()
	set waitfor = FALSE

	if(src.paused)
		return

	if(!src.brain)
		return

	// LOD checks
	var/lod_level = null
	if(src.dynamic_lod_check)
		lod_level = call(src.dynamic_lod_check)(src)

	lod_level = DEFAULT_IF_NULL(DEFAULT_IF_NULL(lod_level, src.current_lod), GOAI_LOD_STANDARD)
	src.current_lod = lod_level

	if(!isnull(src.min_lod))
		if(src.current_lod < src.min_lod)
			return

	if(!isnull(src.max_lod))
		if(src.current_lod > src.max_lod)
			return

	// Should run, probably.
	src.OnBeginLifeTick() // hook

	if(src.paused)
		// yes, again - in case the hook pauses us
		return

	var/list/active_plan = src.active_plan

	var/run_count = 0
	var/target_run_count = 1
	var/do_plan = FALSE

	while(run_count++ < target_run_count)
		/* STATE: Running */
		sleep(0)

		if(src.running_action_tracker) // processing action
			RUN_ACTION_DEBUG_LOG("ACTIVE ACTION: [src.running_action_tracker.tracked_action] @ [src.running_action_tracker.IsRunning()] | <@[src]>")

			if(src.running_action_tracker.replan)
				do_plan = TRUE
				target_run_count++
				src.AbortPlan(FALSE)

			else if(src.running_action_tracker.is_done)
				src.NextPlanStep()
				//target_run_count++

			else if(src.running_action_tracker.is_failed)
				RUN_ACTION_DEBUG_LOG("[src.running_action_tracker.tracked_action] failed, aborting")
				src.AbortPlan(TRUE)

		/* STATE: Ready */
		else if(src.selected_action) // ready to go
			RUN_ACTION_DEBUG_LOG("SELECTED ACTION: [src.selected_action]([src.selected_action?:arguments && json_encode(src.selected_action:arguments)]) | <@[src]>")

			src.running_action_tracker = src.DoAction(src.selected_action)
			target_run_count++

			src.selected_action = null

		/* STATE: Pending next stage */
		else if(active_plan?.len)
			//step done, move on to the next
			//TODO consider if plan needs to be a list for Utility AIs at all
			RUN_ACTION_DEBUG_LOG("ACTIVE PLAN: [active_plan ? json_encode(active_plan) : "[]"] | <@[src]>")
			DEBUG_LOG_LIST_ASSOC(active_plan, RUN_ACTION_DEBUG_LOG)

			while(active_plan && isnull(src.selected_action))
				// Unlike GOAP as of writing, active_plan is a STACK.
				// (it's faster this way and GOAP should use a stack too but honk)
				src.selected_action = pop(active_plan)

				var/datum/utility_action/action = src.selected_action
				UTILITYBRAIN_DEBUG_LOG("Selected action: [action?.name || "NONE"]([action?.arguments && json_encode(action?.arguments)]) | <@[src]>")

				// do instants in one tick
				if(action?.instant)
					RUN_ACTION_DEBUG_LOG("Instant ACTION: [action?.name || "NONE"]([action?.arguments && json_encode(action?.arguments)]) | <@[src]>")
					src.DoAction(src.selected_action)
					src.selected_action = null

				else
					RUN_ACTION_DEBUG_LOG("Regular ACTION: [action?.name || "NONE"]([action?.arguments && json_encode(action?.arguments)]) | <@[src]>")


		else //no plan & need to make one
			do_plan = TRUE


		/* STATE: Planning */
		if(do_plan)
			var/prev_plan = active_plan

			var/should_retry = src.HandlePlanningState()

			if(should_retry)
				target_run_count++

			if(isnull(prev_plan) && active_plan)
				// If we created a new plan, execute straight away
				target_run_count++

	// handle actions
	sleep(0)

	if(src.running_action_tracker?.process)
		// If the process attr is set to false (or there's no action), we skip this for now.
		// This is an optimization to avoid calling HandleAction and its children if this would
		// just tell us to shut up and wait
		var/tracked_action = src.running_action_tracker.tracked_action

		if(tracked_action)
			src.HandleAction(tracked_action, src.running_action_tracker)

	return TRUE

