/client/proc/load_event_map()

	set name = "Load Event Map"
	set category = "Fun"
	set desc = "Loads the map for the event."
	if(!check_rights(R_SERVER))
		src <<"<span class='danger'> You do not have the required admin rights.</span>"
		return

	var/list/potentialEventMap = list()
	world << "<span class='danger'> Searching for Event Map...</span>"
	var/list/Lines = file2list("maps/EventMaps/fileList.txt")
	if(!Lines.len)	return
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


	if(potentialEventMap.len)
		world << "<span class='danger'> Loading EventMap...</span>"

		var/eventmap = input(src,"Which event map to load?") as null|anything in potentialEventMap
		var/file = file(eventmap)
//		var/file = file(mappath) //leaving it in as the basis to a future port to a .dm file-based map loading, instead of the other way round

		if(eventmap == null)
			world << "<span class='danger'> Event Map loading aborted</span>"
			return

		if(isfile(file))
			maploader.load_map(file)
			world << "<span class='danger'> Event Map loaded.</span>"

		else
			src << "<span class='warning'> Event Map couldn't be loaded properly. Yell at the coders.</span>"

	else
		world << "<span class='danger'> Event Map not found.</span>"
		return