// Generic 'magic' logic that should be only enabled for dev


/obj/verb/TestPlanning()
	// Requests a GOAP Plan to handle an arbitrary target state

	set src in view()

	var/datum/target = src

	if(isnull(target) || !istype(target))
		RUN_ACTION_DEBUG_LOG("Target is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	var/raw_goal_state = input(usr, "Enter GoalState as JSON") as message
	var/list/goal_state = json_decode(raw_goal_state)
	var/planning_budget = null

	if(isnull(goal_state))
		to_chat(usr, "goal_state is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	// deliberately not cached so we can edit it quickly
	var/list/start_state = READ_JSON_FILE("debug_start_state.json")

	var/list/targ_curr_state = target.GetWorldstate()
	var/list/init_state = (isnull(targ_curr_state) ? list() : targ_curr_state)

	if(!isnull(start_state))
		// override actual state with user values for testing
		UPSERT_ASSOC_LTR(start_state, init_state)

	var/myref = ref(src)
	var/datum/GOAP/planner = GetGoapResource(myref)
	var/list/plan_items = null

	if(!isnull(planner))
		var/list/actions = GoapActionSetFromJsonFile(GOAPPLAN_METADATA_PATH) // this is doing a lot of constructor work, but the file I/O is optimized away by caching
		var/_planning_budget = isnull(planning_budget) ? 500 : planning_budget
		planner.graph = actions

		to_world_log("PLANNING! START: [json_encode(start_state)] GOAL: [json_encode(goal_state)], ACTIONS: [json_encode(actions)]")
		plan_items = planner.Plan(init_state, goal_state, cutoff_iter=_planning_budget)
		to_world_log("PLANNING END - PLAN: [json_encode(plan_items)]")

		FreeGoapResource(planner, myref)

	if(isnull(plan_items))
		to_chat(usr, "Raw plan is null | <@[src]> | [__FILE__] -> L[__LINE__]")
		return

	to_chat(usr, "PLAN: [json_encode(plan_items)]")
	return


/mob/verb/test_hash_goap_state()
	// deliberately not cached so we can edit it quickly
	var/list/teststate = READ_JSON_FILE("debug_hash_goap_state.json")
	var/statehash = hash_goap_state(teststate)
	to_chat(usr, statehash)
	return
