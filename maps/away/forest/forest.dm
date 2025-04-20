#include "forest_jobs.dm"

/area/planet/forest
	name = "\improper forest"
	icon = 'maps/away/forest/forest.dmi'
	icon_state = "forest"
	base_turf = /turf/simulated/floor/planet/dirt/temperate

/area/planet/forest/upper
	name = "\improper forest"
	base_turf = /turf/simulated/open

/area/planet/forest/cabin1
	name = "Cabin one"
	icon_state = "lobby"

/area/planet/forest/cabin1/attic
	name = "Cabin one attic"
	base_turf = /turf/simulated/open

/area/planet/forest/cabin2
	name = "Cabin two"
	icon_state = "lobby"

/area/planet/forest/cabin2/attic
	name = "Cabin two attic"
	icon_state = "lobby"
	base_turf = /turf/simulated/open

/area/planet/forest/cave
	name = "\improper caves"
	icon_state = "misc"
	base_turf = /turf/simulated/floor/planet/jungle/clear/underground

/area/planet/forest/cave/lobby
	name = "\improper abandoned lobby"
	icon_state = "lobby"

/area/planet/forest/cave/dorms
	name = "\improper abandoned dorms"
	icon_state = "bedroom"

/area/planet/forest/cave/med
	name = "\improper abandoned infrimary"
	icon_state = "med"

/area/planet/forest/cave/kitchen
	name = "\improper abandoned cafeteria"
	icon_state = "kitchen"

/area/planet/forest/cave/lab
	name = "\improper abandoned lab"
	icon_state = "lab"

/area/planet/forest/cave/engie
	name = "\improper abandoned maintainence office"
	icon_state = "engie"

/area/planet/forest/cave/hall
	name = "\improper abandoned corridor"
	icon_state = "forest"

/obj/overmap/visitable/sector/planetoid/caraway_forest //FOR THE LOVE OF ALL THAT IS GOOD IN THE WORLD PLACE THIS ON THE LOWEST Z LEVEL SO IT SPAWNS ON THE OVERMAP INSTEAD OF WONDERING WHY IT DOESNT WORK FOR A WEEK!!!
	name = "temperate planetoid"
	desc = "Scanner report shows a derelict comm bouy in orbit; recovered data shows little info beyond a breathable atmosphere. Sensors pick up a degraded signal from an area in the northern hemisphere."
	icon_state = "globe"
	color = "#035e15"
	initial_generic_waypoints = list(
		"nav_caraway_forest_1",
		"nav_caraway_forest_2"
		)

/obj/shuttle_landmark/automatic/nav_caraway_forest/nav1
	name = "Valley Landing Zone #1"
	landmark_tag = "nav_caraway_forest_1"

/obj/shuttle_landmark/automatic/nav_caraway_forest/nav2
	name = "Valley Landing Zone #2"
	landmark_tag = "nav_caraway_forest_2"

/datum/map_template/ruin/away_site/caraway_forest
	name = "Temperate Planet"
	id = "awaysite_caraway_forest"
	description = "3z level planet with cave, forest surface, and 2 story buildings."
	suffixes = list("forest/forest1.dmm", "forest/forest2.dmm", "forest/forest3.dmm")
	spawn_cost = 2
	generate_mining_by_z = list(1,2,3)

/datum/random_map/automata/cave_system/planet
	floor_type = /turf/simulated/floor/asteroid/planet

/datum/map_template/ruin/away_site/caraway_forest/after_load(z)
	for(var/i in generate_mining_by_z)
		var/current_z = z + i - 1
		new /datum/random_map/automata/cave_system/planet(null, 1, 1, current_z, world.maxx, world.maxy)
		new /datum/random_map/noise/ore(null, 1, 1, current_z, world.maxx, world.maxy)
		GLOB.using_map.refresh_mining_turfs(current_z)

/obj/submap_landmark/joinable_submap/caraway_forest
	name = "Boreal Forest"
	archetype = /singleton/submap_archetype/caraway_forest

/singleton/submap_archetype/caraway_forest
	descriptor = "Frontier Settlement"
	map = "Boreal Forest"
	crew_jobs = list(
		/datum/job/submap/forest_settler
		)
