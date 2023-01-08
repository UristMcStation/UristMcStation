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


/datum/GOAP/demoGoap/combatCommanderGoap/compare_op(var/curr_val, var/targ_val)
	var/absCurr = abs(curr_val)
	var/absTarg = abs(targ_val)

	var/result = (absCurr >= absTarg)

	// curr_val should be always positive, but just in case:
	if(targ_val < 0 && curr_val > 0)
		// Complement notation for negatives, e.g. precond=-30 => 'cannot be 30+'
		result = !result

	return result


/datum/brain/concrete/combatCommander


/datum/brain/concrete/combatCommander/New(var/list/actions, var/list/init_memories = null, var/init_action = null, var/datum/brain/with_hivemind = null, var/dict/init_personality = null, var/newname = null)
	..(actions, init_memories, init_action, with_hivemind, init_personality, newname)

	var/datum/GOAP/demoGoap/new_planner = new /datum/GOAP/demoGoap/combatCommanderGoap/(actionslist)
	planner = new_planner
