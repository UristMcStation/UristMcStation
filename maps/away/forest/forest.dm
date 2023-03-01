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
	name = "\improper abanonded lab"
	icon_state = "lab"

/area/planet/forest/cave/engie
	name = "\improper abandoned maintainence office"
	icon_state = "engie"

/area/planet/forest/cave/hall
	name = "\improper abandoned corridor"
	icon_state = "forest"

/obj/effect/overmap/sector/caraway_forest //FOR THE LOVE OF ALL THAT IS GOOD IN THE WORLD PLACE THIS ON THE LOWEST Z LEVEL SO IT SPAWNS ON THE OVERMAP INSTEAD OF WONDERING WHY IT DOESNT WORK FOR A WEEK!!!
	name = "temperate planetoid"
	desc = "Scanner report shows a derelict comm bouy in orbit; recovered data shows little info beyond a breathable atmosphere. Sensors pick up a degraded signal from an area in the northern hemisphere."
	icon_state = "globe"
	known = 0
	in_space = 0
	color = "#035e15"
	initial_generic_waypoints = list(
		"nav_caraway_forest_1",
		"nav_caraway_forest_2"
		)

/obj/effect/overmap/sector/caraway_forest/New(nloc, max_x, max_y)
	name = "[generate_planet_name()], \a [name]"
	..()

/obj/effect/shuttle_landmark/automatic/nav_caraway_forest/nav1
	name = "Valley Landing Zone #1"
	landmark_tag = "nav_caraway_forest_1"

/obj/effect/shuttle_landmark/automatic/nav_caraway_forest/nav2
	name = "Valley Landing Zone #2"
	landmark_tag = "nav_caraway_forest_2"

/datum/map_template/ruin/away_site/caraway_forest
	name = "Temperate Planet"
	id = "awaysite_caraway_forest"
	description = "3z level planet with cave, forest surface, and 2 story buildings."
	suffixes = list("forest/forest1.dmm", "forest/forest2.dmm", "forest/forest3.dmm")
	accessibility_weight = 11
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/obj/effect/submap_landmark/joinable_submap/caraway_forest
	name = "Boreal Forest"
	archetype = /decl/submap_archetype/caraway_forest

/decl/submap_archetype/caraway_forest
	descriptor = "boreal forest"
	map = "boreal forest"
	crew_jobs = list(
		/datum/job/submap/forest_settler
	)
