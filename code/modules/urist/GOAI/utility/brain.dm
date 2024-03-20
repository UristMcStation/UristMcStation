/* Concrete implementation of the Brain logic using IAUS-style Utility
//
//
// The underscore in the filename is just to trick DM into sorting this correctly.
*/



/datum/brain/utility
	// NOTE: we'll reuse actionslist from the parent for ActionSets; this is not ideal
	//       but I don't want to refactor the parent into a GOAPy subclass.
	var/list/file_actionsets = null


/datum/brain/utility/GetAiController()
	var/datum/commander = null
	var/__commander_backref = src.attachments.Get(ATTACHMENT_CONTROLLER_BACKREF)

	# ifdef UTILITYBRAIN_LOG_CONTROLLER_LOOKUP
	UTILITYBRAIN_DEBUG_LOG("Backref is [__commander_backref] @ L[__LINE__] in [__FILE__]")
	# endif

	if(IS_REGISTERED_AI(__commander_backref))
		commander = GOAI_LIBBED_GLOB_ATTR(global_goai_registry[__commander_backref])

	ASSERT(commander)
	return commander


/datum/brain/utility/CleanDelete()
	deregister_ai_brain(src.registry_index)
	qdel(src)
	return TRUE



/datum/brain/utility/proc/ShouldCleanup()
	. = FALSE

	if(src.cleanup_detached_threshold < 0)
		return FALSE

	if(src._ticks_since_detached > src.cleanup_detached_threshold)
		return TRUE

	return


/datum/brain/utility/proc/CheckForCleanup()
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


/*
/datum/brain/utility/Life()
	while(life)
		CheckForCleanup()
		LifeTick()
		sleep(AI_TICK_DELAY)
	return
*/

/datum/brain/utility/proc/OnBeginLifeTick()
	return


/datum/brain/utility/proc/OnInvalidAction(var/action_key) // str -> bool
	/* If the Action is invalid, what do we do?
	//
	// Returns a bool, indicating whether to try planning again in the same tick.
	*/

	// By default, abandon ship.
	RUN_ACTION_DEBUG_LOG("INVALID ACTION: [action_key] | <@[src]> | [__FILE__] -> L[__LINE__]")
	src.AbortPlan()
	return TRUE


/datum/brain/utility/proc/GetRequester() // () -> Any
	var/datum/utility_ai/mob_commander/controller = src.GetAiController()
	//var/pawn = controller?.GetPawn()
	//return pawn
	return controller


/datum/brain/utility/proc/ScoreActions(var/list/actionsets)
	var/PriorityQueue/utility_ranking = new /PriorityQueue(/datum/Triple/proc/FirstTwoCompare)
	var/requester = src.GetRequester()

	# ifdef UTILITYBRAIN_LOG_ACTIONCOUNT
	var/template_count = 0
	# endif

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

			var/list/contexts = action_template.GetCandidateContexts(requester)

			if(contexts)
				# ifdef UTILITYBRAIN_LOG_CONTEXTS
				UTILITYBRAIN_DEBUG_LOG("Found contexts ([contexts.len])")
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
					to_world_log("ScoreAction context: [ctx]")
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

					var/utility = action_template.ScoreAction(action_template, ctx, requester)
					if(utility > 0.01)
						// tiebreaker noise
						utility -= (0.01 * rand())

					# ifdef UTILITYBRAIN_LOG_UTILITIES
					UTILITYBRAIN_DEBUG_LOG("Utility for [action_template?.name]: [utility] (priority: [action_template?.priority_class])")
					UTILITYBRAIN_DEBUG_LOG("=========================")
					UTILITYBRAIN_DEBUG_LOG(" ")
					# endif

					if(utility <= 0)
						// To prevent impossible actions from being considered!
						continue

					var/datum/Triple/scored_action = new(utility, action_template, ctx)
					utility_ranking.Enqueue(scored_action)

			else
				// Some actions could have a 'null' context (i.e. they don't care about the world-state)
				// We should support this to avoid alloc-ing empty lists for efficiency, at the cost of smol code duplication
				var/utility = action_template.ScoreAction(action_template, null, requester) // null/default context

				if(utility <= 0)
					// To prevent impossible actions from being considered!

					# ifdef UTILITYBRAIN_LOG_UTILITIES
					UTILITYBRAIN_DEBUG_LOG("REJECTED [action_template?.name] due to zero Utility score [utility]")
					# endif

					continue

				var/datum/Triple/scored_action = new(utility, action_template, null) // ...and here, as a triple!
				utility_ranking.Enqueue(scored_action)


	# ifdef UTILITYBRAIN_LOG_ACTIONCOUNT
	UTILITYBRAIN_DEBUG_LOG(" ")
	UTILITYBRAIN_DEBUG_LOG("INFO: Processed [template_count] ActionTemplates")
	UTILITYBRAIN_DEBUG_LOG(" ")
	#endif

	return utility_ranking


/datum/brain/utility/proc/GetActionSetFromFile(var/filename)
	if(isnull(src.file_actionsets))
		src.file_actionsets = list()

	var/datum/action_set/file_actionset = src.file_actionsets[filename]

	var/local_cache_miss = FALSE
	var/global_cache_miss = FALSE

	if(isnull(file_actionset))
		local_cache_miss = TRUE

		if(isnull(actionset_file_cache))
			actionset_file_cache = list()

		file_actionset = actionset_file_cache[filename]

		if(isnull(file_actionset))
			global_cache_miss = TRUE

	if(global_cache_miss)
		file_actionset = ActionSetFromJsonFile(filename)
		actionset_file_cache[filename] = file_actionset

		if(local_cache_miss)
			src.file_actionsets[filename] = file_actionset

	return file_actionset


var/global/list/demo_plan = null
var/global/last_plan_time = null


/datum/brain/utility/GetAvailableActions()
	var/list/actionsets = list()

	var/list/smartobjects = src.GetMemoryValue("SmartObjects", null)
	var/list/smart_paths = src.GetMemoryValue("AbstractSmartPaths", null)
	var/list/smart_plans = src.GetMemoryValue("SmartPlans", null)
	var/list/smart_orders = src.GetMemoryValue("SmartOrders", null)

	if(isnull(smartobjects))
		smartobjects = list()

	if(!isnull(smart_paths))
		for(var/path_key in smart_paths)
			var/datum/path_smartobject/path_so = smart_paths[path_key]
			if(istype(path_so))
				smartobjects.Add(path_so)

	if(!isnull(smart_plans))
		for(var/datum/plan_smartobject/plan_so in smart_plans)
			smartobjects.Add(plan_so)

	if(!isnull(smart_orders))
		for(var/datum/order_smartobject/order_so in smart_orders)
			smartobjects.Add(order_so)

	var/requester = src.GetRequester()
	ASSERT(!isnull(requester))

	// currently implicit since we always can see ourselves
	// should prolly do a 'if X not in list already', but BYOOOOND

	var/datum/utility_ai/mob_commander/mob_controller = requester

	if(istype(mob_controller))
		// For Mob Controllers, the Pawn is a SmartObject too!
		var/datum/pawn = mob_controller.GetPawn()
		smartobjects.Add(pawn)


	if(!isnull(smartobjects))

		for(var/datum/SO in smartobjects)
			var/list/SO_actionsets = src.GetActionSetsFromSmartObject(SO, requester)

			if(!isnull(SO_actionsets))
				actionsets.Add(SO_actionsets)

	/*
	if(src.smart_objects)
		if(isnull(src.smartobject_last_fetched))
			src.smartobject_last_fetched = list()

		for(var/datum/smart_object/SO in src.smart_objects)
	*/

	return actionsets


/datum/brain/utility/proc/HandlePlanningState()
	/* Main selection logic.
	// Runs through all available actions,
	// scores them by utility,
	// selects a high-utility action.
	*/

	set waitfor = FALSE

	// selection left intentionally vague; will probably do deterministic as PoC and weighted sampling later

	if(!is_planning)
		is_planning = TRUE
		sleep(0)

		var/list/actionsets = GetAvailableActions()

		var/PriorityQueue/utility_ranking = src.ScoreActions(actionsets)
		var/datum/Triple/best_act_tup = null

		while(utility_ranking.L)
			var/best_act_res = utility_ranking.Dequeue()

			best_act_tup = best_act_res
			if(!isnull(best_act_tup))
				break

		if(!best_act_tup)
			RUN_ACTION_DEBUG_LOG("ERROR: Best action tuple is null! [best_act_tup] | <@[src]> | [__FILE__] -> L[__LINE__]")
			return

		var/datum/utility_action_template/best_action_template = best_act_tup.middle
		var/list/best_action_ctx = best_act_tup.right
		var/datum/utility_action/best_action = best_action_template.ToAction(best_action_ctx)

		src.SetMemory("SelectedActionTemplate", best_action_template)

		if(best_action)
			PUT_EMPTY_LIST_IN(src.active_plan)
			src.active_plan.Add(best_action)

		else
			RUN_ACTION_DEBUG_LOG("ERROR: Best action is null! | <@[src]> | [__FILE__] -> L[__LINE__]")

	else //satisfied, can be lazy
		Idle()

	is_planning = FALSE
	return


/datum/brain/utility/LifeTick()
	var/run_count = 0
	var/target_run_count = 1
	var/do_plan = FALSE

	OnBeginLifeTick() // hook

	while(run_count++ < target_run_count)
		/* STATE: Running */
		if(running_action_tracker?.process) // processing action
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
			RUN_ACTION_DEBUG_LOG("SELECTED ACTION: [selected_action]([selected_action?:arguments && json_encode(selected_action:arguments)]) | <@[src]>")

			running_action_tracker = src.DoAction(selected_action)
			target_run_count++

			selected_action = null


		/* STATE: Pending next stage */
		else if(active_plan && active_plan.len)
			//step done, move on to the next
			RUN_ACTION_DEBUG_LOG("ACTIVE PLAN: [active_plan] ([active_plan.len]) | <@[src]>")
			DEBUG_LOG_LIST_ASSOC(active_plan, RUN_ACTION_DEBUG_LOG)

			while(active_plan.len && isnull(selected_action))
				// Unlike GOAP as of writing, active_plan is a STACK.
				// (it's faster this way and GOAP should use a stack too but honk)
				selected_action = pop(active_plan)

				var/datum/utility_action/action = selected_action
				UTILITYBRAIN_DEBUG_LOG("Selected action: [action?.name || "NONE"]")

				// do instants in one tick
				if(action?.instant)
					RUN_ACTION_DEBUG_LOG("Instant ACTION: [selected_action] | <@[src]>")
					DoInstantAction(selected_action)
					selected_action = null

				else
					RUN_ACTION_DEBUG_LOG("Regular ACTION: [selected_action] | <@[src]>")


		else //no plan & need to make one
			do_plan = TRUE


		/* STATE: Planning */
		if(do_plan)
			var/prev_plan = src.active_plan

			var/should_retry = HandlePlanningState()

			if(should_retry)
				target_run_count++

			if(isnull(prev_plan) && src.active_plan)
				// If we created a new plan, execute straight away
				target_run_count++

	return

/datum/brain/utility/proc/Idle()
	return


/datum/brain/utility/proc/NextPlanStep()
	if(src.running_action_tracker)
		src.running_action_tracker.process = FALSE
	return TRUE


/datum/brain/utility/AbortPlan(var/mark_failed = TRUE)
	if(mark_failed)
		// Mark the plan as failed
		src.last_plan_successful = FALSE
		src.running_action_tracker?.SetFailed()

	// Cancel current tracker, if any is running
	if(src.running_action_tracker)
		src.running_action_tracker.process = FALSE

	// Cancel all instant and regular Actions
	PUT_EMPTY_LIST_IN(src.pending_instant_actions)
	src.active_plan = null
	src.selected_action = null

	return TRUE


/datum/brain/utility/DoAction(Act as anything in src.GetAvailableActions())
	RUN_ACTION_DEBUG_LOG("INFO: Running DoAction: [Act] | <@[src]> | L[__LINE__] in [__FILE__]")

	var/datum/utility_action/utility_act = Act

	var/datum/ActionTracker/new_actiontracker = src.running_action_tracker

	if(isnull(new_actiontracker))
		new_actiontracker = new /datum/ActionTracker(utility_act)
	else
		// Object pooling
		var/should_run = new_actiontracker.IsStopped()  // if already running, no need to spin up a thread
		new_actiontracker.Initialize(utility_act, run=should_run)

	if(!new_actiontracker)
		RUN_ACTION_DEBUG_LOG("ERROR: Failed to create a tracker for [utility_act]! | <@[src]> | L[__LINE__] in [__FILE__]")
		return null

	running_action_tracker = new_actiontracker

	// Update the tracked Action stack for Considerations
	src.SetMemory(MEM_ACTION_MINUS_TWO, src.GetMemoryValue(MEM_ACTION_MINUS_ONE), RETAIN_LAST_ACTIONS_TTL)
	src.SetMemory(MEM_ACTION_MINUS_ONE, utility_act.name, RETAIN_LAST_ACTIONS_TTL)
	src.SetMemory("LastActionEffects", utility_act.name, RETAIN_LAST_ACTIONS_TTL)

	return new_actiontracker


/* Motives */
/datum/brain/utility/proc/GetMotive(var/motive_key)
	if(isnull(motive_key))
		return

	if(!(motive_key in needs))
		return

	var/curr_value = needs[motive_key]
	return curr_value


/datum/brain/utility/proc/ChangeMotive(var/motive_key, var/value)
	if(isnull(motive_key))
		return

	var/fixed_value = min(NEED_MAXIMUM, max(NEED_MINIMUM, (value)))
	needs[motive_key] = fixed_value
	last_need_update_times[motive_key] = world.time
	MOTIVES_DEBUG_LOG("Curr [motive_key] = [needs[motive_key]] <@[src]>")


/datum/brain/utility/proc/AddMotive(var/motive_key, var/amt)
	if(isnull(motive_key))
		return

	var/curr_val = needs[motive_key]
	ChangeMotive(motive_key, curr_val + amt)
