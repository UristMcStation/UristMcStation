#include "abandoned_colony_jobs.dm"
#include "abandoned_colony_shuttle.dm"

/obj/submap_landmark/joinable_submap/abandoned_colony
	name = "ICS Morning Light"
	archetype = /singleton/submap_archetype/abandoned_colony

/singleton/submap_archetype/abandoned_colony
	descriptor = "abandoned colony"
	map = "abandoned colony"
	crew_jobs = list(
		/datum/job/submap/colony_scavenger
	)

/area/planet/abandoned_colony
	name = "\improper Abandoned Colony"
	base_turf = /turf/simulated/floor/planet/dirt/city/clear
	luminosity = 0
	lightswitch = 1

/obj/overmap/visitable/sector/planetoid/abandoned_colony
	name = "abandoned colony"
	desc = "A former Terran Confederation colony, evacuated during the Galactic Crisis. It is now a 'Graveworld', one of the many broken monuments to the billions of dead and displaced across the galaxy. However, sensors are detecting signs of life on the surface."
	icon_state = "globe"
	color = "#7f8274"
	assigned_contracts = list(/datum/contract/shiphunt/graveworld_alien)
	initial_generic_waypoints = list(
		"nav_abandoned_colony_1",
		"nav_abandoned_colony_2"
		)
	initial_restricted_waypoints = list(
		"ICS Morning Light" = list("nav_morninglight")
		)

/obj/overmap/visitable/abandoned_colony/Initialize() //make it spawn a lactera ship
	.=..()
//	name = "[generate_planet_name()], \a [name]"
	new /mob/living/simple_animal/hostile/overmapship/alien/small(get_turf(src))

/obj/shuttle_landmark/nav_abandoned_colony/nav1
	name = "Abandoned Hangar"
	landmark_tag = "nav_abandoned_colony_1"
	base_area = /area/planet/abandoned_colony
	base_turf = /turf/simulated/floor/planet/dirt/city/clear

/obj/shuttle_landmark/nav_abandoned_colony/nav2
	name = "Parking Lot"
	landmark_tag = "nav_abandoned_colony_2"
	base_area = /area/planet/abandoned_colony
	base_turf = /turf/simulated/floor/planet/ariddirt/clear

/datum/map_template/ruin/away_site/abandoned_colony
	name = "Abandoned Colony"
	id = "awaysite_abandoned_colony"
	description = "A former Terran Confederation colony, evacuated during the Galactic Crisis. It is now an empty Graveworld, a broken monument to the billions displaced across the galaxy. However, sensors are detecting unknown signs of life from a city on the surface."
	suffixes = list("abandoned_colony/abandoned_colony.dmm")
	accessibility_weight = 10
//	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED //temporary
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/morninglight)
	spawn_cost = 1

/obj/machinery/power/smes/buildable/preset/morning_light/Initialize()
	. = ..()
	uncreated_component_parts = list(
	/obj/item/stock_parts/smes_coil/super_io = 1,
	/obj/item/stock_parts/smes_coil/super_capacity = 1,
	)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

/datum/contract/shiphunt/graveworld_alien
	name = "Lactera Ship Hunt Contract"
	desc = "A lactera ship has been spotted in the local sector near a Graveworld. It's been harrassing local shipping traffic and needs to be eliminated. There's a good reward in it for you if you can get it done."
	neg_faction = /datum/factions/alien
	rep_points = 7
	amount = 1
	money = 8500
