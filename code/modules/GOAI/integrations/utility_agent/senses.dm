
/datum/utility_ai/proc/SensesSystem()
	// This method generally shouldn't need to be overridden.
	/* We're rolling ECS-style */
	for(var/sense/sensor in senses)
		if(sensor?.enabled)
			sensor?.ProcessTick(src)
	return


/datum/utility_ai/proc/InitSenses()
	// Can be hooked into by subclasses to add sense presets
	if(isnull(src.senses))
		src.senses = list()

	return src.senses

