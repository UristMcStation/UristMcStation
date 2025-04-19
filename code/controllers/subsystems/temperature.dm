SUBSYSTEM_DEF(temperature)
	name = "Temperature"
	priority = SS_PRIORITY_TEMPERATURE
	flags = SS_NO_INIT
	wait = 5 SECONDS

	var/static/list/processing = list()
	var/static/list/queue


/datum/controller/subsystem/temperature/fire(resume, no_mc_tick)
	if (!resume)
		queue = processing.Copy()
	var/queue_length = length(queue)
	if (!queue_length)
		return
	var/atom/atom
	for (var/i = 1 to queue_length)
		atom = queue[i]
		if (QDELETED(atom))
			processing -= atom
		if (atom.ProcessAtomTemperature() == PROCESS_KILL)
			processing -= atom
		if (no_mc_tick)
			if (i % 5)
				continue
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, i + 1)
			return
	LIST_RESIZE(queue, 0)
