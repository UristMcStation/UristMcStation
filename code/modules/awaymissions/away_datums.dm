
/datum/away_mission
	var/map_path              // String form of the actual .dmm
	var/value                 // A value that represents the amount of content and/or loot1
	var/random_start = FALSE  // Determines if it's a possible mission at roundstart

/datum/away_mission/proc/perform_setup()
	for(var/x = 1 to 255)
		for(var/y = 1 to 255)
			for(var/atom/A in get_turf(locate(x,y,world.maxz)))
				if(!A.initialized)
					SSatoms.InitAtom(A)

//Actual away missions go down here

//Also, attempts to load stuff like the jungle planet will be met with death and runtimes

/datum/away_mission/tradership
	map_path = "maps/wyrm/templates/tradership.dmm"
	value = 20
	random_start = TRUE

/datum/away_mission/crystalcaves
	map_path = "maps/wyrm/templates/crystalmines.dmm"
	value = 20
	random_start = TRUE

/datum/away_mission/hell
	map_path = "maps/RandomZLevels/negastation.dmm"
	value = 20
	random_start = TRUE