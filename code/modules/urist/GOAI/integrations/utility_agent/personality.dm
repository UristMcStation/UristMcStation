
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
