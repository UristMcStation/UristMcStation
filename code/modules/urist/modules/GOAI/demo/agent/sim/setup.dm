
/mob/goai/sim/InitStates()
	states = ..()

	return states


/mob/goai/sim/InitNeeds()
	needs = ..()

	needs[MOTIVE_SLEEP] = NEED_THRESHOLD
	needs[MOTIVE_FOOD] = NEED_THRESHOLD
	needs[MOTIVE_FUN] = NEED_THRESHOLD
	return needs


/mob/goai/sim/InitActionsList()
	/* TODO: add Time as a resource! */

	AddAction(
		"Eat",
		list(
			RESOURCE_FOOD = 1,
		),
		list(
			MOTIVE_FOOD = 40,
			RESOURCE_FOOD = -1
		),
		/mob/goai/sim/proc/HandleEating,
		10,
		PLUS_INF,
		FALSE
	)

	AddAction(
		"Shop",
		list(
			RESOURCE_MONEY = 10,
		),
		list(
			RESOURCE_MONEY = -10,
			RESOURCE_FOOD = 1
		),
		/mob/goai/sim/proc/HandleShopping,
		10,
		PLUS_INF,
		FALSE
	)

	AddAction(
		"Party",
		list(
			RESOURCE_MONEY = 11,
		),
		list(
			RESOURCE_MONEY = -11,
			MOTIVE_SLEEP = 15,
			MOTIVE_FUN = 40,
		),
		/mob/goai/sim/proc/HandlePartying,
		10,
		PLUS_INF,
		FALSE
	)

	AddAction(
		"Sleep",
		list(
			MOTIVE_FOOD = 50,
		),
		list(
			MOTIVE_SLEEP = 50,
		),
		/mob/goai/sim/proc/HandleSleeping,
		10,
		PLUS_INF,
		FALSE
	)

	/*
	AddAction(
		"DishWash",
		list(
			"HasDirtyDishes" = 1,
		),
		list(
			"HasDirtyDishes" = -1,
			"HasCleanDishes" = 1
		),
		/mob/goai/sim/proc/HandleSleeping,
		10,
		PLUS_INF,
		FALSE
	)
	*/

	AddAction(
		"Work",
		list(
			MOTIVE_SLEEP = 25,
		),
		list(
			RESOURCE_MONEY = 10,
		),
		/mob/goai/sim/proc/HandleWorking,
		10,
		PLUS_INF,
		FALSE
	)

	AddAction(
		"Idle",
		list(

		),
		list(
			MOTIVE_SLEEP = 5,
		),
		/mob/goai/sim/proc/HandleIdling,
		10,
		PLUS_INF,
		FALSE
	)

	return src.actionslist



/mob/goai/sim/Equip()
	. = ..()
	return


/mob/goai/sim/CreateBrain(var/list/custom_actionslist = null, var/list/init_memories = null, var/list/init_action = null, var/datum/brain/with_hivemind = null, var/dict/custom_personality = null)
	var/list/new_actionslist = (custom_actionslist ? custom_actionslist : actionslist)
	var/datum/brain/concrete/sim/new_brain = new /datum/brain/concrete/sim(new_actionslist)

	new_brain.needs = (isnull(src.needs) ? new_brain.needs : src.needs)
	new_brain.states = (isnull(src.states) ? new_brain.states : src.states)
	return new_brain
