/* SAMPLE SETUP: */
var/global/list/actions = list(
	"Eat" = new /datum/Triple (10, list("HasFood" = 1, "HasCleanDishes" = 1), list("HasDirtyDishes" = 1, "HasCleanDishes" = -1, "Fed" = 1, "HasFood" = -1)),
	"Shop" = new /datum/Triple (10, list("Money" = 10), list("HasFood" = 1, "Money" = -10)),
	"Party" = new /datum/Triple (10, list("Money" = 11), list("Rested" = 1, "Money" = -11, "Fun" = 4)),
	"Sleep" = new /datum/Triple (10, list("Fed" = 1), list("Rested" = 10)), // For some reason, the planner REALLY likes going to sleep by default, so we discourage it w/ a lower weight. Mood.
	"DishWash" = new /datum/Triple (10, list("HasDirtyDishes" = 1, "Rested" = 1), list("HasDirtyDishes" = -1, "HasCleanDishes" = 1, "Rested" = -1)),
	//"DishWash" = new /datum/Triple (10, list("HasDirtyDishes" = 1), list("HasDirtyDishes" = -1, "HasCleanDishes" = 1)),
	"Work" = new /datum/Triple (10, list("Rested" = 1), list("Money" = 10)),
	"Idle" = new /datum/Triple (10, list(), list("Rested" = 1))
)


/proc/get_actions_test()
	var/list/all_actions = list()
	for (var/act in actions)
		all_actions.Add(act)
	return all_actions


/proc/get_preconds_test(var/action)
	var/datum/Triple/actiondata = actions[action]
	var/list/preconds = actiondata.middle
	return preconds


/proc/get_effects_test(var/action)
	var/datum/Triple/actiondata = actions[action]
	var/list/effects = actiondata.right
	return effects


/proc/check_preconds_test(var/action, var/list/blackboard)
	var/match = 1
	var/list/preconds = get_preconds_test(action)

	for (var/req_key in preconds)
		var/req_val = preconds[req_key]
		if (isnull(req_val))
			continue

		var/blackboard_val = (req_key in blackboard) ? blackboard[req_key] : null
		if (isnull(blackboard_val) || (blackboard_val < req_val))
			match = 0
			break


	return match


/proc/goal_checker_test(var/pos, var/goal, var/proc/cmp_op = null)
	var/match = 1
	var/list/pos_effects = islist(pos) ? pos : get_effects_test(pos)
	var/proc/comparison = cmp_op ? cmp_op : /proc/greater_or_equal_than

	for (var/state in goal)
		var/goal_val = goal[state]

		//to_world_log("GoalState: [state] = [goal_val]")

		if (isnull(goal_val))
			continue


		var/curr_value = (state in pos_effects) ? pos_effects[state] : 0
		//to_world_log("PosState: [state] = [pos_effects[state]]")
		var/cmp_result = call(comparison)(curr_value, goal_val)
		if (cmp_result <= 0)
			/*to_world_log("MISMATCH: [curr_value] & [goal_val]")
			var/i = 1
			for (var/mispos in pos)
				to_world_log("MISMATCH POS [i] = [mispos], [pos[mispos]]")
				i++*/
			match = 0
			break

	return match


/* TESTING VERBS */
/mob/verb/testGetPlansByArgs()
	var/iter_cutoff = input("Enter cutoff", "Cutoff", null) as num|null
	/*var/state_inputs = input("Enter a comma-separated string of initial state", "State", null) as text|null
	var/goal_inputs = input("Enter a comma-separated string of integer goals", "Goals", null) as text|null*/
	/*var/list/formatted_state = (state_inputs && length(state_inputs)) ? splittext(state_inputs, ",") : null
	var/list/formatted_goals = (goal_inputs && length(goal_inputs)) ? splittext(goal_inputs, ",") : null
	var/list/formatted_state = list()
	var/list/formatted_goals = list()*/
	var/formatted_state = null
	var/formatted_goals = null

	return src.testGetPlans(formatted_state, formatted_goals, iter_cutoff)


/mob/verb/testGetPlansSimple()
	return src.testGetPlans()


/mob/proc/testGetPlans(var/list/state, var/list/goals, var/cutoff)
	var/true_state = state
	var/true_goals = goals
	var/true_cutoff = cutoff

	if(!(state && state.len))
		true_state = list("HasFood" = 0, "HasDirtyDishes" = 2)

	if(!(goals && goals.len))
		//true_goals = list("Fed" = 2, "HasCleanDishes" = 2)
		true_goals = list("Money" = 20)

	if (isnull(cutoff))
		true_cutoff = 30

	var/list/params = list()
	// You don't have to pass args like this; this is just to make things a bit more readable.
	params["graph"] = actions
	params["start"] = true_state
	params["goal"] = true_goals
	params["adjacent"] = /proc/get_actions_test
	params["check_preconds"] = /proc/check_preconds_test
	/*params["handle_backtrack"] = null
	params["handle_backtrack_target"] = null
	params["paths"] = null
	params["visited"] = null
	params["neighbor_measure"] = null
	params["goal_measure"] = null*/
	params["goal_check"] = /proc/goal_checker_test
	params["get_effects"] = /proc/get_effects_test
	params["cutoff_iter"] = true_cutoff

	var/datum/Tuple/result = Plan(arglist(params))

	if (result)
		var/list/path = result.right
		//to_world("Result cost: [result.left]")
		to_world("Path: [path] ([path.len])")
		for (var/act in path)
			to_world("Step: [act]")

	else
		to_world("NO PATH FOUND!")

	to_world("   ")
