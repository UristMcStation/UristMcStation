/client/proc/load_event_map()

	set name = "Load Event Map"
	set category = "Fun"
	set desc = "Loads the map for the event."
	if(!check_rights(R_SERVER))
		to_chat(src, "<span class='danger'> You do not have the required admin rights.</span>")
		return

	var/list/potentialEventMap = list()
	report_progress("Searching for Event Map...")
	var/list/Lines = file2list("maps/EventMaps/fileList.txt")
	if(!length(Lines))	return
	for (var/t in Lines)
		if (!t)
			continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null

		if (pos)
			// No, don't do lowertext here, that breaks paths on linux
			name = copytext(t, 1, pos)
		else
			// No, don't do lowertext here, that breaks paths on linux
			name = t

		if (!name)
			continue

		potentialEventMap.Add(name)


	if(length(potentialEventMap))
		report_progress("Loading EventMap...")

		var/eventmap = input(src,"Which event map to load?") as null|anything in potentialEventMap
		var/file = file(eventmap)
//		var/file = file(mappath) //leaving it in as the basis to a future port to a .dm file-based map loading, instead of the other way round

		if(eventmap == null)
			report_progress("Event Map loading aborted")
			return

		if(isfile(file))
			GLOB.maploader.load_map(file)
			report_progress("Event Map loaded.")

		else
			report_progress("Event Map couldn't be loaded properly. Yell at the coders.")

	else
		report_progress("Event Map not found.")
		return
