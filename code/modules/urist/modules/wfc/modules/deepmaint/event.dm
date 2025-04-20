/datum/event/backrooms_deepmaint
	announceWhen = 10
	endWhen = 1000
	var/entrypoints = 100
	var/list/spawned_teleporters


/datum/event/backrooms_deepmaint/setup()
	endWhen = rand(600, 6000)

/datum/event/backrooms_deepmaint/proc/create_outbound_teleporters()
	set waitfor = FALSE

	sleep(-1) // detach immediately and background
	var/list/predicates = list(/proc/is_station_turf, /proc/not_turf_contains_dense_objects)

	if(isnull(src.spawned_teleporters))
		src.spawned_teleporters = list()

	var/tries = src.entrypoints + 3 // small padding; keep the addition here, even if with zero, to ensure a clone...

	// ...because I'm pretty sure the `--x` op here is inplace
	while(tries --> 0)
		if(length(src.spawned_teleporters) >= src.entrypoints)
			break

		var/area/location = pick_area(list(/proc/is_not_space_area, /proc/is_station_area, /proc/is_maint_area))

		if(isnull(location))
			continue

		var/turf/T = pick_area_turf(location, predicates)

		if(isnull(T))
			continue

		var/obj/wfc_step_trigger/deepmaint_entrance/deepmaint_teleporter = new(T)
		src.spawned_teleporters.Add(deepmaint_teleporter)

		if(!(tries % 5))
			// Try to do blocks of 5 between each sleep
			sleep(0)

	if(!(length(src.spawned_teleporters)))
		log_debug("Failed to spawn any teleporters for the Deepmaint event. Aborting.")
		kill(TRUE)

	return


/datum/event/backrooms_deepmaint/proc/generate_deepmaint()
	set waitfor = FALSE

	sleep(0)

	if(!(length(GLOB.wfc_deepmaint_zlevels_by_instance)))
		// This if could check template.loaded, but if the Z-level map is busted,
		// we'd need to rebuild it anyway as the generation code usually relies on that.
		var/datum/map_template/template = SSmapping.map_templates["Maintrooms"]

		if(isnull(template))
			log_debug("Failed to find a Deepmaint template.")
			kill(TRUE)
			return

		var/new_z_centre = template.load_new_z(FALSE)

		if (new_z_centre)
			log_debug("Successfully placed a Deepmaint template.")
		else
			log_debug("Failed to place a Deepmaint template.")
			kill(TRUE)
			return

	var/success = FALSE

	for(var/area/map_template/deepmaint_wfc/deepmaint_area in GLOB.wfc_deepmaint_zlevels_by_instance)
		success = deepmaint_area.generate_deepmaint("deepmaint.json", "genmap.json")
		if(success)
			log_debug("Generated a DeepmaintRooms map.")
			break

	if(!success)
		log_debug("Failed to generate a DeepmaintRooms map.")
		kill(TRUE)
		return

	sleep(0)

	src.create_outbound_teleporters()
	return


/datum/event/backrooms_deepmaint/start()
	. = ..()
	src.generate_deepmaint()
	return


/datum/event/backrooms_deepmaint/end()
	for (var/obj/wfc_step_trigger/deepmaint_entrance/deepmaint_teleporter in src.spawned_teleporters)
		qdel(deepmaint_teleporter)

	command_announcement.Announce("All subspace distortions have ceased. All personnel and/or assets not present onboard should be considered lost.")


/datum/event/deepmaint/announce()
	command_announcement.Announce("Extreme subspace anomalies detected. Ensure all persons and assets are accounted for.", "[location_name()] Spooky Sensor Network", zlevels = affecting_z)
