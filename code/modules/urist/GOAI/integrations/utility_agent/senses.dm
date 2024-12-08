
/datum/utility_ai/proc/SensesSystem()
	// This method generally shouldn't need to be overridden.
	/* We're rolling ECS-style */
	var/our_lod = DEFAULT_IF_NULL(src.current_lod, GOAI_LOD_STANDARD)

	for(var/sense/sensor in senses)
		if(isnull(sensor))
			continue

		if(!(sensor.enabled))
			continue

		var/sense_minlod = DEFAULT_IF_NULL(sensor.min_lod, GOAI_LOD_LOWEST)
		if(our_lod < sense_minlod)
			continue

		var/sense_maxlod = DEFAULT_IF_NULL(sensor.max_lod, GOAI_LOD_STANDARD)
		if(our_lod > sense_maxlod)
			continue

		sensor.ProcessTick(src)

	return


/datum/utility_ai/proc/InitSenses()
	// Can be hooked into by subclasses to add sense presets
	if(isnull(src.senses))
		src.senses = list()

	return src.senses

