
/datum/goai/proc/GeneratePersonality()
	var/dict/new_personality = new()
	return new_personality


/datum/goai/proc/CreateBrain(var/list/custom_actionslist = null, var/list/init_memories = null, var/list/init_action = null, var/datum/brain/with_hivemind = null, var/dict/custom_personality = null)
	var/list/new_actionslist = (custom_actionslist ? custom_actionslist : actionslist)
	var/dict/new_personality = (isnull(custom_personality) ? GeneratePersonality() : custom_personality)
	var/datum/brain/concrete/new_brain = new(new_actionslist, init_memories, init_action, with_hivemind, new_personality)
	new_brain.states = states ? states.Copy() : new_brain.states
	return new_brain


/datum/goai/proc/UpdateBrain()
	if(!brain)
		return

	brain.needs = needs.Copy()
	brain.states = states.Copy()

	return brain
