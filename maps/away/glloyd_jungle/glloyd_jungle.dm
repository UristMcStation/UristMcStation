/area/planet/jungle/away

/area/jungleoutpost/comms
	name = "\improper Jungle Outpost Comms"

/area/jungleoutpost/medbay
	name = "\improper Jungle Outpost Medbay"

/area/jungleoutpost/main
	name = "\improper Jungle Outpost"

/area/jungleoutpost/engi
	name = "\improper Jungle Outpost Engineering"

/obj/effect/overmap/sector/glloyd_jungle
	name = "Jungle planetoid"
	desc = "Geneseeded world detected, possible intelligent life detected."
	icon_state = "globe"
	known = 0
	in_space = 0
	color = "#538224"
	initial_generic_waypoints = list(
		"nav_glloyd_jungle_1",
		"nav_glloyd_jungle_2"
		)

/obj/effect/overmap/sector/glloyd_jungle/New(nloc, max_x, max_y)
	name = "[generate_planet_name()], \a [name]"
	..()

/obj/effect/shuttle_landmark/nav_glloyd_jungle/nav1
	name = "Planetary Navpoint #1"
	landmark_tag = "nav_glloyd_jungle_1"
	base_area = /area/planet/jungle/away
	base_turf = /turf/simulated/floor/planet/jungle/clear/grass1

/obj/effect/shuttle_landmark/nav_glloyd_jungle/nav2
	name = "Planetary Navpoint #2"
	landmark_tag = "nav_glloyd_jungle_2"
	base_area = /area/planet/jungle/away
	base_turf = /turf/simulated/floor/planet/jungle/clear/grass1

/datum/map_template/ruin/away_site/glloyd_jungle
	name = "Jungle planetoid"
	id = "awaysite_glloyd_jungle"
	description = "Geneseeded world detected, possible intelligent life detected."
	suffixes = list("glloyd_jungle/glloyd_jungle.dmm")
	accessibility_weight = 11
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED