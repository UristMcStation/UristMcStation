proc/LoadEventMap()

	var/list/potentialEventMap = list()
	world << "\red \b Searching for Event Map..."
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
	//	var/value = null

		if (pos)
            // No, don't do lowertext here, that breaks paths on linux
			name = copytext(t, 1, pos)
		//	value = copytext(t, pos + 1)
		else
            // No, don't do lowertext here, that breaks paths on linux
			name = t

		if (!name)
			continue

		potentialEventMap.Add(name)


	if(potentialEventMap.len)
		world << "\red \b Loading EventMap..."

		var/map = pick(potentialEventMap)
		var/file = file(map)
		if(isfile(file))
			maploader.load_map(file)

		world << "\red \b Event Map loaded."

	else
		world << "\red \b Event Map found."
		return

/client/proc/load_event_map()

	set name = "Load Event Map"
	set category = "Fun"
	set desc = "Loads the map for the event."
	if(!check_rights(R_SERVER))	return

	LoadEventMap()