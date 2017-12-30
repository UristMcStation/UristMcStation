#include "lost_supply_base_areas.dm"
#include "../mining/mining_areas.dm"

/datum/away_mission/lost_supply_base
	map_path = "maps/RandomZlevels/lost_supply_base/lost_supply_base.dmm"
	value = 20
	random_start = TRUE

/datum/away_mission/lost_supply_base/perform_setup()
	new /datum/random_map/automata/cave_system(null, 1, 1, world.maxz, 100, 100)
	new /datum/random_map/noise/ore(null, 1, 1, world.maxz, 100, 100)

/obj/effect/overmap/sector/lost_supply_base
	name = "Abandoned supply base"
	desc = "This looks like abandoned and heavy damaged supply station."
	icon_state = "object"
	known = 0

	generic_waypoints = list(
		"nav_lost_supply_base_1",
		"nav_lost_supply_base_2",
		"nav_lost_supply_base_3",
		"nav_lost_supply_base_antag"
	)

/obj/effect/shuttle_landmark/nav_lost_supply_base/nav1
	name = "Abandoned Supply Base Navpoint #1"
	landmark_tag = "nav_lost_supply_base_1"

/obj/effect/shuttle_landmark/nav_lost_supply_base/nav2
	name = "Abandoned Supply Base Navpoint #2"
	landmark_tag = "nav_lost_supply_base_2"

/obj/effect/shuttle_landmark/nav_lost_supply_base/nav3
	name = "Abandoned Supply Base Navpoint #3"
	landmark_tag = "nav_lost_supply_base_3"

/obj/effect/shuttle_landmark/nav_lost_supply_base/navantag
	name = "Abandoned Supply Base Navpoint #4"
	landmark_tag = "nav_lost_supply_base_antag"