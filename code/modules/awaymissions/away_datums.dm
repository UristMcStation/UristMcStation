//TODO: datum to decl

/datum/away_mission
	var/map_path              // String form of the actual .dmm
	var/value                 // A value that represents the amount of content and/or loot to determine how many aways should be loaded
	var/random_start = FALSE  // Determines if it's a possible mission at roundstart

/datum/away_mission/proc/perform_setup()
	return

//Actual away missions go down here

//Also, attempts to load stuff like the jungle planet will be met with death and runtimes

/datum/away_mission/tradership
	map_path = "maps/wyrm/templates/tradership.dmm"
	value = 10
	random_start = TRUE

/datum/away_mission/crystalcaves
	map_path = "maps/wyrm/templates/crystalmines.dmm"
	value = 15
	random_start = TRUE
/*
/datum/away_mission/hell
	map_path = "maps/RandomZLevels/negastation.dmm"
	value = 25
	random_start = TRUE

/datum/away_mission/snowcult
	map_path = "maps/wyrm/templates/snowcult.dmm"
	value = 20
	random_start = TRUE

/datum/away_mission/dionaland
	map_path = "maps/wyrm/templates/dionaland.dmm"
	value = 25
	random_start = TRUE

/datum/away_mission/refueling
	map_path = "maps/wyrm/templates/refuelingstation.dmm"
	value = 10
	random_start = TRUE
*/