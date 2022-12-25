/* In this module:
===================

 - Brain definition
 - Operator override for need updates
 - Initial needs
 - Initial states

*/

/datum/GOAP/demoGoap/combatCommanderGoap


/datum/GOAP/demoGoap/combatCommanderGoap/update_op(var/old_val, var/new_val)
	var/result = new_val
	return result


/datum/brain/concrete/combatCommander


/datum/brain/concrete/combatCommander/New(var/list/actions, var/list/init_memories = null, var/init_action = null, var/datum/brain/with_hivemind = null, var/dict/init_personality = null, var/newname = null)
	..(actions, init_memories, init_action, with_hivemind, init_personality, newname)

	var/datum/GOAP/demoGoap/new_planner = new /datum/GOAP/demoGoap/combatCommanderGoap/(actionslist)
	planner = new_planner
