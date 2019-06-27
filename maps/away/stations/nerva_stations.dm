#include "station_areas.dm"

/obj/effect/overmap/sector/station/nanotrasentrading
	name = "Nanotrasen trading station"
	desc = "A Nanotrasen trading station, dock here to trade with its many merchants."
	faction = "nanotrasen"
	nospawn = 0
	start_x = 6
	start_y = 7
	spawn_type = /mob/living/simple_animal/hostile/overmapship/nanotrasen/ntmerchant

	initial_generic_waypoints = list(
		"nav_nanotrading_1",
		"nav_nanotrading_2",
		"nav_nanotrading_3"
		)

/obj/effect/shuttle_landmark/nav_nanotrasentrading/nav1
	name = "Visitor's Bay"
	landmark_tag = "nav_nanotrading_1"
	base_area = /area/spacestations/nanotrasenspace
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/nav_nanotrasentrading/nav2
	name = "Loading Bay"
	landmark_tag = "nav_nanotrading_2"
	base_area = /area/spacestations/nanotrasenspace
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/nav_nanotrasentrading/nav3
	name = "Auxiliary Docking Bay"
	landmark_tag = "nav_nanotrading_3"
	base_area = /area/spacestations/nanotrasenspace
	base_turf = /turf/simulated/floor/plating

/datum/map_template/ruin/away_site/nanotrasentrading
	name = "Nanotrasen trading station"
	id = "awaysite_nanotrasentrading"
	description = "A Nanotrasen trading station, dock here to trade with its many merchants."
	suffixes = list("stations/nanotrasentrading.dmm")
	cost = 0
	accessibility_weight = 10
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

//nt mining outpost
/*
/obj/effect/overmap/sector/station/nanotrasenmining
	name = "Nanotrasen mining outpost"
	desc = "A Nanotrasen mining outpost on a largely uninhabited planet, dock here to engage in trading."
	faction = "nanotrasen"
	nospawn = 0
	spawn_type = list(
	/mob/living/simple_animal/hostile/overmapship/nanotrasen/ntmerchant
	)

	initial_generic_waypoints = list(
		"nav_nanomining_1",
		"nav_nanomining_1"
		)

/obj/effect/shuttle_landmark/nav_nanotrasenmining/nav1
	name = "Docking Navpoint #1"
	landmark_tag = "nav_nanomining_1"

/obj/effect/shuttle_landmark/nav_nanotrasenmining/nav1
	name = "Docking Navpoint #2"
	landmark_tag = "nav_nanomining_2"

/datum/map_template/ruin/away_site/nanotrasenmining
	name = "Nanotrasen mining outpost"
	id = "awaysite_nanotrasenmining"
	description = "A Nanotrasen mining outpost on a mineral rich asteroid, dock here to engage in trading."
	suffixes = list("stations/nanotrasenmining.dmm")
	cost = 0
//	accessibility_weight = 10
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

//tc

/obj/effect/overmap/sector/station/tccolony
	name = "Terran Confederacy colony"
	desc = "A small Terran Confederacy colony on a largely uninhabited planet, dock here to engage in trading."
	faction = "nanotrasen"
	nospawn = 0
	spawn_type = list(
	/mob/living/simple_animal/hostile/overmapship/nanotrasen/ntmerchant
	)

	initial_generic_waypoints = list(
		"nav_tccolony_1",
		"nav_tccolony_2"
		)

/obj/effect/shuttle_landmark/nav_nanotrasenmining/nav1
	name = "Docking Navpoint #1"
	landmark_tag = "nav_tccolony_1"

/obj/effect/shuttle_landmark/nav_nanotrasenmining/nav1
	name = "Docking Navpoint #2"
	landmark_tag = "nav_tccolony_2"

/datum/map_template/ruin/away_site/nanotrasenmining
	name = "Nanotrasen mining outpost"
	id = "awaysite_nanotrasenmining"
	description = "A Nanotrasen mining outpost on a largely uninhabited planet, dock here to engage in trading."
	suffixes = list("stations/terrancolony.dmm")
	cost = 0
//	accessibility_weight = 10
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED



*/