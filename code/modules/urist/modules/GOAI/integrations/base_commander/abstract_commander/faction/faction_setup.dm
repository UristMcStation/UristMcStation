
/datum/goai/goai_commander/faction_ai/InitSenses()
	senses = ..()
	return senses


/datum/goai/goai_commander/faction_ai/InitNeeds()
	needs = ..()
	needs["Idled"] = NEED_MINIMUM
	return needs


/datum/goai/goai_commander/faction_ai/InitStates()
	states = ..()

	return states


/datum/goai/goai_commander/faction_ai/InitActionsList()
	/* TODO: add Time as a resource! */
	// Name, Req-ts, Effects, Priority, [Charges]
	// Priority - higher is better; -INF would only be used if there's no other option.

	src.AddAction(
		"Idle",
		list("Idled" = FALSE),
		list("Idled" = NEED_MAXIMUM),
		/datum/goai/proc/HandleIdling,
		-99999
	)

	return src.actionslist



/datum/goai/goai_commander/faction_ai/CreateBrain(var/list/custom_actionslist = null, var/list/init_memories = null, var/list/init_action = null, var/datum/brain/with_hivemind = null, var/dict/custom_personality = null)
	var/list/new_actionslist = (custom_actionslist ? custom_actionslist : actionslist)
	var/dict/new_personality = (isnull(custom_personality) ? GeneratePersonality() : custom_personality)

	var/datum/brain/concrete/faction/new_brain = new /datum/brain/concrete/faction(new_actionslist, init_memories, src.initial_action, with_hivemind, new_personality, "brain of [src.name]")

	new_brain.needs = (isnull(src.needs) ? new_brain.needs : src.needs)
	new_brain.states = (isnull(src.states) ? new_brain.states : src.states)
	return new_brain
