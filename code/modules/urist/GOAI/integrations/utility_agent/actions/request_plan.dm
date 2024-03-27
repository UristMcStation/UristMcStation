
/datum/utility_ai/mob_commander/proc/_PlanForGenericGoal(var/target, var/atom/position, var/list/start_state = null, var/list/goal_state, var/planning_budget = DEFAULT_GOAP_PLANNING_BUDGET)
	// Requests a GOAP Plan to handle an arbitrary target state
	// Fails if no Plan was found
	// Otherwise, creates a Utility-friendly SmartObject to deal with execution

	if(isnull(target))
		RUN_ACTION_DEBUG_LOG("Target is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(isnull(goal_state))
		RUN_ACTION_DEBUG_LOG("goal_state is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(isnull(src.brain))
		RUN_ACTION_DEBUG_LOG("Requester brain is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	var/list/init_state = (isnull(start_state) ? list() : start_state)

	var/myref = ref(src)
	var/datum/GOAP/planner = GetGoapResource(myref)
	var/list/plan_items = null

	if(!isnull(planner))
		var/list/actions = GoapActionSetFromJsonFile(GOAPPLAN_METADATA_PATH) // this is doing a lot of constructor work, but the file I/O is optimized away by caching
		var/_planning_budget = isnull(planning_budget) ? DEFAULT_GOAP_PLANNING_BUDGET : planning_budget
		planner.graph = actions

		// Add a dynamic query cache to the planner here!

		PLANNING_DEBUG_LOG("PLANNING! START: [json_encode(start_state)] GOAL: [json_encode(goal_state)], ACTIONS: [json_encode(actions)]")
		plan_items = planner.Plan(init_state, goal_state, cutoff_iter=_planning_budget)
		PLANNING_DEBUG_LOG("PLANNING END - PLAN: [json_encode(plan_items)]")

		FreeGoapResource(planner, myref)

	if(isnull(plan_items))
		PLANNING_DEBUG_LOG("Raw plan is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	var/list/bound_context = list()
	bound_context["action_target"] = target
	var/datum/plan_smartobject/returned_plan = new(plan_items, bound_context)

	return returned_plan


/datum/utility_ai/mob_commander/proc/_StorePlan(var/datum/plan_smartobject/returned_plan, var/plan_ttl = null)
	var/_plan_ttl = isnull(plan_ttl) ? 600 : plan_ttl

	var/list/stored_plans = src.brain.GetMemoryValue("SmartPlans")
	if(isnull(stored_plans))
		stored_plans = list()

	if(stored_plans.len < MAX_STORED_PLANS)
		// Pad out the length lazily if not full
		// Might be better to preallocate MAX_STORED_PLANS' worth of space later.
		ARRAY_APPEND(stored_plans, returned_plan)

	else
		var/eject_idx = 0

		for(var/stored_plan in stored_plans)
			// find empty slots in the buffer, if any
			eject_idx++

			if(isnull(stored_plan))
				// if there's a hole, fill that slot
				break

		if(eject_idx >= MAX_STORED_PLANS)
			// if we went through all, eject at random
			eject_idx = MAX_STORED_PLANS == 1 ? 1 : rand(1, MAX_STORED_PLANS)

		stored_plans[eject_idx] = returned_plan

	src.brain.SetMemory("SmartPlans", stored_plans, _plan_ttl)
	return stored_plans


/datum/utility_ai/mob_commander/proc/PlanForGoal(var/datum/ActionTracker/tracker, var/list/goal_state, var/atom/target, var/atom/position, var/planning_budget = DEFAULT_GOAP_PLANNING_BUDGET)
	// Requests a GOAP Plan to satisfy a specified target state
	// Fails if no Plan was found
	// Otherwise, creates a Utility-friendly SmartObject to deal with execution

	to_world("<><>Running PlanForGoal<><>")

	if(isnull(tracker))
		RUN_ACTION_DEBUG_LOG("Tracker position is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	if(tracker.IsStopped())
		return

	if(isnull(target))
		RUN_ACTION_DEBUG_LOG("Target is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	if(isnull(src.brain))
		RUN_ACTION_DEBUG_LOG("Requester brain is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	var/list/ai_worldstate = src.QueryWorldState()
	// This is pretty nasty; TODO allow GOAP to handle the sub-key structure like Utility does

	var/list/start_state = ai_worldstate["pawn"] || list()

	UPSERT_ASSOC_LTR(target.worldstate, start_state)

	PLANNING_DEBUG_LOG("Running _PlanForGenericGoal for target [target]...")
	var/datum/plan_smartobject/returned_plan = src._PlanForGenericGoal(target, position, start_state, goal_state, planning_budget)

	if(isnull(returned_plan))
		RUN_ACTION_DEBUG_LOG("Plan not found! | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	var/_plan_ttl = 300
	var/list/stored_plans = src._StorePlan(returned_plan, _plan_ttl)

	if(isnull(stored_plans))
		RUN_ACTION_DEBUG_LOG("Plan not stored successfully! | <@[src]> | [__FILE__] -> L[__LINE__]")
		tracker.SetFailed()
		return

	tracker.SetDone()

	// temp devshit, will probably regret it again
	to_world_log("Nulling out SmartOrders! | <@[src]> | [__FILE__] -> L[__LINE__]")
	src.brain.SetMemory("SmartOrders", null)
	return

