/* In this module:
===================

 - Brain definition
 - Operator override for need updates
 - Initial needs
 - Initial states

*/

/datum/GOAP/demoGoap/combatGoap


/datum/GOAP/demoGoap/combatGoap/update_op(var/old_val, var/new_val)
	var/result = new_val
	return result


/datum/brain/concrete/combat


/*
/datum/brain/concrete/combat/InitNeeds()
	needs = ..()
	needs[NEED_COVER] = NEED_MINIMUM
	//needs[NEED_ENEMIES] = 2
	return needs


/datum/brain/concrete/combat/InitStates()
	states = ..()
	states[STATE_DOWNTIME] = TRUE
	return states
*/

/datum/brain/concrete/combat/New(var/list/actions, var/list/init_memories = null, var/init_action = null, var/datum/brain/with_hivemind = null, var/dict/init_personality = null, var/newname = null)
	..(actions, init_memories, init_action, with_hivemind, init_personality, newname)

	var/datum/GOAP/demoGoap/new_planner = new /datum/GOAP/demoGoap/combatGoap/(actionslist)
	planner = new_planner
