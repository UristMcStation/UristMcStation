/datum/brain/New(
	var/list/actions = null,
	var/list/init_memories = null,
	var/init_action = null,
	var/datum/brain/with_hivemind = null,
	var/list/init_personality = null,
	var/newname = null,
	var/dict/init_relationships = null
)
	// Initialize the Brain
	// Various modules are macro'd in if included.
	..()

	src.name = (newname ? newname : name)
	src.attachments = new()
	src.hivemind = with_hivemind

	src.perceptions = new()

	#ifdef BRAIN_MODULE_INCLUDED_METRICS
	src.last_need_update_times = list()
	#endif

	#ifdef BRAIN_MODULE_INCLUDED_MEMORY
	src.memories = new /dict(init_memories)
	#endif

	#ifdef BRAIN_MODULE_INCLUDED_RELATIONS
	src.relations = new(init_relationships)
	#endif

	#ifdef BRAIN_MODULE_INCLUDED_PERSONALITY
	if(init_personality)
		src.personality = init_personality

	else if(isnull(src.personality) && !isnull(src.personality_template_filepath))
		src.personality = PersonalityTemplateFromJson(src.personality_template_filepath)
	#endif

	#ifdef BRAIN_MODULE_INCLUDED_ACTIONS
	if(actions)
		src.actionslist = actions.Copy()

	PUT_EMPTY_LIST_IN(src.pending_instant_actions)

	if(init_action && (init_action in actionslist))
		src.running_action_tracker = DoAction(init_action)
	#endif

	#ifdef BRAIN_MODULE_INCLUDED_NEEDS
	src.InitNeeds()
	#endif

	#ifdef BRAIN_MODULE_INCLUDED_STATES
	src.InitStates()
	#endif

	src.RegisterBrain()
	return
