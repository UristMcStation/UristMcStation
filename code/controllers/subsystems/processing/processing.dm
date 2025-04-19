SUBSYSTEM_DEF(processing)
	name = "Processing"
	priority = SS_PRIORITY_PROCESSING
	flags = SS_BACKGROUND | SS_POST_FIRE_TIMING | SS_NO_INIT
	wait = 1 SECOND
	var/list/processing = list()
	var/list/queue = list()


/datum/controller/subsystem/processing/VV_static()
	return ..() + list("processing", "queue")


/datum/controller/subsystem/processing/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("Processing: [length(processing)]")


/datum/controller/subsystem/processing/fire(resume, no_mc_tick)
	if (!resume)
		queue = processing.Copy()
	var/queue_length = length(queue)
	if (!queue_length)
		return
	var/datum/datum
	for (var/i = 1 to queue_length)
		datum = queue[i]
		if (QDELETED(datum) || !datum.is_processing)
			processing -= datum
		else if (datum.Process(wait, times_fired, src) == PROCESS_KILL)
			datum?.is_processing = null
			processing -= datum
		if (no_mc_tick)
			if (i % 5)
				continue
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, i + 1)
			return
	LIST_RESIZE(queue, 0)
