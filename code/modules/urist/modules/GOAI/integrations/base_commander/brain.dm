
/datum/goai/proc/GeneratePersonality()
	var/dict/new_personality = new()
	return new_personality


/datum/goai/proc/CreateBrain(var/list/custom_actionslist = null, var/list/init_memories = null, var/list/init_action = null, var/datum/brain/with_hivemind = null, var/dict/custom_personality = null)
	var/list/new_actionslist = (custom_actionslist ? custom_actionslist : actionslist)
	var/dict/new_personality = (isnull(custom_personality) ? GeneratePersonality() : custom_personality)
	var/datum/brain/concrete/new_brain = new(new_actionslist, init_memories, init_action, with_hivemind, new_personality)
	new_brain.states = states ? states.Copy() : new_brain.states
	return new_brain


/datum/goai/proc/AttachToBrain()
	/* Injects a component (simple AI ID) into the Brain.
	// This is so that we can check if the ID is valid; if not,
	// we can tell that the Brain has been 'orphaned' and can potentially delete it.
	// As the AI ID is a primitive integer value, we don't need to worry about GC!
	*/
	if(!(src.brain))
		return

	var/dict/brain_attachments = src.brain.attachments

	if(isnull(brain_attachments))
		brain_attachments = new()
		src.brain.attachments = brain_attachments

	src.brain.attachments[ATTACHMENT_CONTROLLER_BACKREF] = src.registry_index
	return brain


/datum/goai/proc/UpdateBrain()
	if(!(src.brain))
		return

	src.brain.needs = needs.Copy()
	src.brain.states = states.Copy()

	return brain
