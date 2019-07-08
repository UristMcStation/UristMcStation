
/datum/autolathe/printjob
	var/datum/autolathe/recipe/target
	var/obj/machinery/autolathe/master

	var/list/reserved_materials = list()

	var/started = 0
	var/finished = 0
	var/paused = 0
	var/progress

/datum/autolathe/printjob/New(var/obj/machinery/autolathe/master ,var/datum/autolathe/recipe/target)
	src.master = master
	src.target = target

/datum/autolathe/printjob/Destroy()
	reserved_materials.Cut()
	target = null
	master = null

/datum/autolathe/printjob/proc/can_make()
	if (target.hidden && !master.hacked)
		return 0
	if (target.resources && target.resources.len)
		for (var/material in target.resources)
			if (!master.stored_material.Find(material))
				continue
			if (master.stored_material[material] < target.resources[material])
				return 0
	return 1

/datum/autolathe/printjob/proc/reserve_materials()
	for (var/material in target.resources)
		// Some recipes have the improbable material "Waste" and other
		// shit the autolathe can't do, skip checking 'em
		if (isnull(master.stored_material[material]))
			continue

		var/amount = target.resources[material] * master.mat_efficiency

		// Check if a required material is available in required amount
		if (master.stored_material[material] >= amount)
			reserved_materials[material] = amount
		// Not available? Abort mission!
		else
			reserved_materials.Cut()
			return 0

	// When successful, remove the materials from the autolathe
	for (var/material in reserved_materials)
		master.stored_material[material] -= reserved_materials[material]
	return 1

/datum/autolathe/printjob/proc/start()
	if (!master || QDELING(master))
		return

	if (reserve_materials())
		force_start()

/datum/autolathe/printjob/proc/force_start()
	progress = 0
	started = 1

/datum/autolathe/printjob/proc/tick(var/delta)
	if (!master || QDELING(master))
		return
	if (finished || paused)
		return

	progress += delta
	if (progress >= target.print_time)
		on_finish()

/datum/autolathe/printjob/proc/on_finish()
	var/product = new target.path()
	reserved_materials.Cut()
	finished = 1
	master.on_job_finished(product)

/datum/autolathe/printjob/proc/pause()
	paused = !paused

/datum/autolathe/printjob/proc/abort()
	if (!QDELETED(master) && reserved_materials.len)
		for (var/material in reserved_materials)
			master.stored_material[material] += reserved_materials[material]
	qdel(src)

/datum/autolathe/printjob/proc/get_ui_data()
	. = list(
		"name" = target.name,
		"target" = target.print_time,
		"progress" = progress,
		"percent" = (progress/target.print_time)*100
		)