
/datum/goai/proc/SensesSystem()
	/* We're rolling ECS-style */
	for(var/sense/sensor in senses)
		sensor.ProcessTick(src)
	return
