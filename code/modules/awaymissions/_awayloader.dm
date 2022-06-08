#define AWAY_POINTS 45

/proc/createRandomZlevel()
	var/list/missions = getRandomAwayMissions()
	var/remaining = AWAY_POINTS
	admin_notice("<span class='danger'>Attempting to load away missions...</span>", R_DEBUG)
	while(remaining)
		var/randaway = pick(missions)
		var/datum/away_mission/possible_away = new randaway //TODO: datum to decl
		if(remaining - possible_away.value)
			remaining -= possible_away.value
			var/file = file(possible_away.map_path)
			if(isfile(file))
				maploader.load_map(file)
				possible_away.perform_setup()
				remaining -= possible_away.value
		missions -= randaway
		if(!missions.len)
			remaining = 0
	admin_notice("<span class='danger'>Away mission(s) loaded.</span>", R_DEBUG)

/proc/getRandomAwayMissions()
	var/list/possible_aways = subtypesof(/datum/away_mission)
	for(var/datum/away_mission/away in possible_aways)
		if(!away.random_start)
			possible_aways -= away
	return possible_aways

/*
	if(GLOB.awaydestinations.len)	//crude, but it saves another var!
		return

	if(!fexists("maps/RandomZLevels/fileList.txt"))
		return

	var/list/potentialRandomZlevels = list()
	admin_notice("<span class='danger'>Searching for away missions...</span>", R_DEBUG)
	var/list/Lines = file2list("maps/RandomZLevels/fileList.txt")
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

		potentialRandomZlevels.Add(name)


	if(potentialRandomZlevels.len)
		admin_notice("<span class='danger'>Loading away mission...</span>", R_DEBUG)

		var/map = pick(potentialRandomZlevels)
		var/file = file(map)
		if(isfile(file))
			maploader.load_map(file)
			log_debug("away mission loaded: [map]")

		for(var/obj/effect/landmark/L in landmarks_list)
			if (L.name != "awaystart")
				continue
			GLOB.awaydestinations.Add(L)

		admin_notice("<span class='danger'>Away mission loaded.</span>", R_DEBUG)

	else
		admin_notice("<span class='danger'>No away missions found.</span>", R_DEBUG)
		return
*/
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