

/datum/goai/mob_commander/sim_commander/InitStates()
	states = ..()

	return states


/datum/goai/mob_commander/sim_commander/InitNeeds()
	needs = ..()

	needs[MOTIVE_SLEEP] = NEED_THRESHOLD
	needs[MOTIVE_FOOD] = NEED_THRESHOLD
	needs[MOTIVE_FUN] = NEED_THRESHOLD
	return needs


/datum/goai/mob_commander/sim_commander/InitActionsList()
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
		/datum/goai/mob_commander/sim_commander/proc/HandleEating,
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
		/datum/goai/mob_commander/sim_commander/proc/HandleShopping,
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
		/datum/goai/mob_commander/sim_commander/proc/HandlePartying,
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
		/datum/goai/mob_commander/sim_commander/proc/HandleSleeping,
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
		/datum/goai/mob_commander/sim_commander/proc/HandleSleeping,
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
		/datum/goai/mob_commander/sim_commander/proc/HandleWorking,
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
		/datum/goai/mob_commander/sim_commander/proc/HandleIdle,
		10,
		PLUS_INF,
		FALSE
	)

	return src.actionslist


/datum/goai/mob_commander/sim_commander/CreateBrain(var/list/custom_actionslist = null, var/list/init_memories = null, var/list/init_action = null, var/datum/brain/with_hivemind = null, var/dict/custom_personality = null)
	var/list/new_actionslist = (custom_actionslist ? custom_actionslist : actionslist)
	var/dict/new_personality = (isnull(custom_personality) ? GeneratePersonality() : custom_personality)

	var/datum/brain/concrete/sim/new_brain = new /datum/brain/concrete/sim(new_actionslist, init_memories, src.initial_action, with_hivemind, new_personality, "brain of [src]")

	new_brain.needs = (isnull(src.needs) ? new_brain.needs : src.needs)
	new_brain.states = (isnull(src.states) ? new_brain.states : src.states)
	return new_brain
