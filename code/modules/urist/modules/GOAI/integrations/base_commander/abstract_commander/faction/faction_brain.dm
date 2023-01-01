
/datum/GOAP/demoGoap/factionGoap


/datum/GOAP/demoGoap/factionGoap/update_op(var/old_val, var/new_val)
	var/result = new_val
	return result


/datum/brain/concrete/faction


/datum/brain/concrete/faction/InitNeeds()
	needs = ..()

	return needs


/datum/brain/concrete/faction/New(var/list/actions, var/list/init_memories = null, var/init_action = null, var/datum/brain/with_hivemind = null, var/dict/init_personality = null, var/newname = null)
	..(actions, init_memories, init_action, with_hivemind, init_personality, newname)

	var/datum/GOAP/demoGoap/new_planner = new /datum/GOAP/demoGoap/factionGoap/(actionslist)
	planner = new_planner
