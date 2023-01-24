
/datum/goai/proc/SensesSystem()
	/* We're rolling ECS-style */
	for(var/sense/sensor in senses)
		if(sensor?.enabled)
			sensor?.ProcessTick(src)
	return
