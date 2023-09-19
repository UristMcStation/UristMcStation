#include "smugglers_areas.dm"
#include "smugglers_items.dm"
#include "../mining/mining_areas.dm"

/obj/effect/overmap/visitable/sector/smugglers
	name = "asteroid station"
	desc = "A small station built into an asteroid. No radio traffic detected."
	icon_state = "object"
	known = FALSE

	initial_generic_waypoints = list(
		"nav_smugglers",
		"nav_smugglers_antag"
	)

/datum/map_template/ruin/away_site/smugglers
	name = "Smugglers' Base"
	id = "awaysite_smugglers"
	description = "Yarr."
	suffixes = list("smugglers/smugglers.dmm")
	spawn_cost = 1
	generate_mining_by_z = 1
	area_usage_test_exempted_root_areas = list(/area/smugglers)
	apc_test_exempt_areas = list(
		/area/smugglers/base = NO_SCRUBBER,
		/area/smugglers/dorms = NO_SCRUBBER|NO_VENT,
		/area/smugglers/office = NO_SCRUBBER|NO_VENT
	)

/obj/effect/shuttle_landmark/nav_asteroid_base/nav1
	name = "Abandoned Asteroid Base Navpoint #1"
	landmark_tag = "nav_smugglers"

/obj/effect/shuttle_landmark/nav_asteroid_base/nav2
	name = "Abandoned Asteroid Base Navpoint #2"
	landmark_tag = "nav_smugglers_antag"
	flags = SLANDMARK_FLAG_AUTOSET
