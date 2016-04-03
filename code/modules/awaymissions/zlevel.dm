var/global/list/potentialRandomZlevels = generateMapList(filename = "maps/RandomZLevels/fileList.txt")

/proc/createRandomZlevel()
	if(awaydestinations.len)	//crude, but it saves another var!
		return

	if(potentialRandomZlevels.len)
		admin_notice("\red \b Loading away mission...", R_DEBUG)

		var/map = pick(potentialRandomZlevels)
		var/file = file(map)
		if(isfile(file))
			maploader.load_map(file)
			world.log << "away mission loaded: [map]"

			for(var/x = 1 to world.maxx)
				for(var/y = 1 to world.maxy)
					turfs += locate(x,y,world.maxz)

			for(var/obj/effect/landmark/L in landmarks_list)
				if (L.name != "awaystart")
					continue
				awaydestinations.Add(L)

			admin_notice("\red \b Away mission loaded.", R_DEBUG)
			return
	else
		admin_notice("\red \b No away missions found.", R_DEBUG)
		return

/proc/generateMapList(filename)
	var/list/potentialMaps = list()
	var/list/Lines = file2list(filename)
	if(!Lines.len)
		return
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
			name = lowertext(copytext(t, 1, pos))

		else
			name = lowertext(t)

		if (!name)
			continue

		potentialMaps.Add(t)

	return potentialMaps