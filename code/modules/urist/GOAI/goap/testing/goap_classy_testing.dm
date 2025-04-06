

/* TESTING VERBS */
/mob/verb/testGetPlansByArgsClassy()
	var/iter_cutoff = input("Enter cutoff", "Cutoff", null) as num|null
	/*var/state_inputs = input("Enter a comma-separated string of initial state", "State", null) as text|null
	var/goal_inputs = input("Enter a comma-separated string of integer goals", "Goals", null) as text|null*/
	/*var/list/formatted_state = (state_inputs && length(state_inputs)) ? splittext(state_inputs, ",") : null
	var/list/formatted_goals = (goal_inputs && length(goal_inputs)) ? splittext(goal_inputs, ",") : null
	var/list/formatted_state = list()
	var/list/formatted_goals = list()*/
	var/formatted_state = null
	var/formatted_goals = null

	return src.testGetPlansClassy(formatted_state, formatted_goals, iter_cutoff)


/mob/verb/testGetPlansSimpleClassy()
	return src.testGetPlansClassy()


/mob/proc/testGetPlansClassy(var/list/state, var/list/goals, var/cutoff)
	var/true_state = state
	var/true_goals = goals
	var/true_cutoff = cutoff

	var/list/test_actions = list(
		"Eat" = new /datum/goai_action(list("HasFood" = 1, "HasCleanDishes" = 1), list("HasDirtyDishes" = 1, "HasCleanDishes" = -1, "Fed" = 1, "HasFood" = -1), 10),
		"Shop" = new /datum/goai_action(list("Money" = 10), list("HasFood" = 1, "Money" = -10), 10),
		"Party" = new /datum/goai_action(list("Money" = 11), list("Rested" = 1, "Money" = -11, "Fun" = 4), 10),
		"Sleep" = new /datum/goai_action(list("Fed" = 1), list("Rested" = 10), 10),
		"DishWash" = new /datum/goai_action(list("HasDirtyDishes" = 1, "Rested" = 1), list("HasDirtyDishes" = -1, "HasCleanDishes" = 1, "Rested" = -1), 10),
		"Work" = new /datum/goai_action(list("Rested" = 1), list("Money" = 10), 10),
		"Idle" = new /datum/goai_action(list(), list("Rested" = 1), 10)
	)

	if(!(state && state.len))
		true_state = list("HasFood" = 0, "HasDirtyDishes" = 2)

	if(!(goals && goals.len))
		true_goals = list("Fed" = 2, "HasCleanDishes" = 2)
		//true_goals = list("Money" = 20)

	if (isnull(cutoff))
		true_cutoff = 30

	var/datum/GOAP/demoGoap/Planner = new /datum/GOAP/demoGoap(test_actions)

	var/list/params = list()
	// You don't have to pass args like this; this is just to make things a bit more readable.
	params["start"] = true_state
	params["goal"] = true_goals
	params["cutoff_iter"] = true_cutoff

	var/result = Planner.Plan(arglist(params))

	if (result)
		var/list/path = result
		//to_world("Result cost: [result.left]")
		to_world("Path: [path] ([path.len])")
		for (var/act in path)
			to_world("Step: [act]")

	else
		to_world("NO PATH FOUND!")

	to_world("   ")
