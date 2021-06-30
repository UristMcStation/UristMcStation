/area/spacestations/pirate
	name = "Pirate Hideout"
	base_turf = /turf/simulated/floor/asteroid

/area/spacestations/pirate/asteroid
	name = "Pirate Asteroid"
	icon_state = "yellow"

/area/spacestations/pirate/station
	name = "Pirate Station"

/area/spacestations/pirate/exterior
	base_turf = /turf/simulated/open
	icon_state = "yellow"

/var/const/access_away_pirate_station = "ACCESS_AWAY_PIRATE_STATION"
/datum/access/away_pirate_station
	id = access_away_pirate_station
	desc = "Pirate Station"
	region = ACCESS_TYPE_NONE

/obj/effect/overmap/sector/station/hostile/pirate
	name = "large asteroid"
	desc = "Sensor array detects a large asteroid."
	icon = 'icons/obj/overmap.dmi'
	icon_state = "meteor4"
	faction = /datum/factions/pirate
	color = "#cc5474"
	station_holder = /mob/living/simple_animal/hostile/overmapship/station_holder/pirate
	total_ships = 2
	remaining_ships = 4
	hidden = TRUE
	spawn_ships = TRUE
	spawn_types = list(/mob/living/simple_animal/hostile/overmapship/pirate/small, /mob/living/simple_animal/hostile/overmapship/pirate/med)
	initial_generic_waypoints = list(
		"nav_piratestation_1",
		"nav_piratestation_2",
		"nav_piratestation_3"
		)

/datum/map_template/ruin/away_site/piratestation
	name = "Pirate Station"
	id = "awaysite_piratestation"
	description = "A hidden pirate station, tucked away on an asteroid."
	suffixes = list("stations/pirate/pirate_station-1.dmm", "stations/pirate/pirate_station-2.dmm")
	cost = 0
	accessibility_weight = 10
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/obj/effect/shuttle_landmark/nav_piratestation
	special = TRUE
	spawn_id = "pirate_station"

/obj/effect/shuttle_landmark/nav_piratestation/on_landing()
	for(var/obj/effect/urist/triggers/away_ai_landmark/A in GLOB.trigger_landmarks)
		if(A.spawn_id == src.spawn_id)
			A.spawn_mobs()

	special = FALSE

/obj/effect/shuttle_landmark/nav_piratestation/nav1
	name = "Station Exterior - East"
	landmark_tag = "nav_piratestation_1"
	base_area = /area/spacestations/pirate/asteroid
	base_turf = /turf/simulated/floor/asteroid

/obj/effect/shuttle_landmark/nav_piratestation/nav2
	name = "Station Exterior - North"
	landmark_tag = "nav_piratestation_2"
	base_area = /area/spacestations/pirate/asteroid
	base_turf = /turf/simulated/floor/asteroid

/obj/effect/shuttle_landmark/nav_piratestation/nav3
	name = "Station Exterior - Above"
	landmark_tag = "nav_piratestation_3"
	base_area = /area/spacestations/pirate/exterior
	base_turf = /turf/simulated/open

/obj/effect/overmap/sector/station/hostile/pirate/update_visible()
	if(!known)
		known = 1
		icon = 'icons/urist/misc/overmap.dmi'
		icon_state = "station_asteroid_0"
		color = "#660000"
		hidden = TRUE