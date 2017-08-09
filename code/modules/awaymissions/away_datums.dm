
/datum/away_mission
	var/map_path              // String form of the actual .dmm
	var/value                 // A value that represents the amount of content and/or loot1
	var/random_start = FALSE  // Determines if it's a possible mission at roundstart
	var/list/init_areas       // Areas that need Initialize() called

/datum/away_mission/proc/perform_setup() //Anything you want to happen right after it's loaded
/* //This did /NOT/ end well
	if(init_areas)
		for(var/area/init_area in init_areas)
			var/area/located = locate(init_area) in world
			for(var/atom/thing in located)
				if(!thing.initialized)
					thing.Initialize()
*/
//Actual away missions go down here

/datum/away_mission/tradership
	map_path = "maps/wyrm/templates/tradership.dmm"
	value = 20
	random_start = TRUE
	init_areas = list(/area/away/forgotten, /area/away/shipremains)

/datum/away_mission/crystalcaves
	map_path = "maps/wyrm/templates/crystalmines.dmm"
	value = 20
	random_start = TRUE
	init_areas = list(/area/away/abandoned)

/datum/away_mission/hell
	map_path = "maps/RandomZLevels/negastation.dmm"
	value = 20
	random_start = TRUE