/datum/utility_ai
	//var/personality_template_filepath = null
	// for dev purposes, hardcoding default personality template for now
	var/personality_template_filepath = DEFAULT_MOBCOMMANDER_PERSONALITY_TEMPLATE


/datum/utility_ai/proc/GeneratePersonality()
	var/list/new_personality

	if(isnull(src.personality_template_filepath))
		new_personality = list()

	else
		new_personality = PersonalityTemplateFromJson(src.personality_template_filepath)

	return new_personality


/datum/utility_ai/proc/CreateBrain(var/list/custom_actionslist = null, var/list/init_memories = null, var/list/init_action = null, var/datum/brain/with_hivemind = null, var/list/custom_personality = null)
	var/list/new_actionslist = (custom_actionslist ? custom_actionslist : actionslist)
	var/list/new_personality = (isnull(custom_personality) ? GeneratePersonality() : custom_personality)
	var/datum/brain/utility/new_brain = new(new_actionslist, init_memories, init_action, with_hivemind, new_personality)
	//new_brain.states = states ? states.Copy() : new_brain.states
	return new_brain


/datum/utility_ai/proc/AttachToBrain()
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


/datum/utility_ai/proc/UpdateBrain()
	if(!(src.brain))
		return

	src.AttachToBrain()

	if(isnull(src.brain.personality))
		src.brain.personality = src.GeneratePersonality()

	src.brain.name = "brain of [src.name]"
	return brain
