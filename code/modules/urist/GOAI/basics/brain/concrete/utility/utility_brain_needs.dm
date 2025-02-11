
/datum/brain/utility/SetNeed(var/key, var/val)
	if(isnull(key))
		return

	// Clamp needs to range
	var/fixed_value = isnull(val) ? null : clamp(val, NEED_MINIMUM, NEED_MAXIMUM)

	// Parent logic handles the rest
	. = ..(key, fixed_value)

	// Extra bookkeeping on top
	#ifdef BRAIN_MODULE_INCLUDED_METRICS

	if(isnull(src.last_need_update_times))
		src.last_need_update_times = list()

	src.last_need_update_times[key] = world.time

	#endif
	MOTIVES_DEBUG_LOG("Curr [key] = [needs[key]] | <@[src]>")

	return .
