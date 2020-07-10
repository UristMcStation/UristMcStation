/area/spacestations/pirate
	name = "Pirate Hideout

/area/spacestations/pirate/asteroid
	name = "Pirate Hideout

/area/spacestations/pirate/station
	name = "Pirate Asteroid

/var/const/access_away_pirate_station = "ACCESS_AWAY_PIRATE_STATION"
/datum/access/away_pirate_station
	id = access_away_pirate_station
	desc = "Pirate Station"
	region = ACCESS_TYPE_NONE

/obj/effect/overmap/sector/station/hostile/pirate
	name = "large asteroid"
	desc = "Sensor array detects a large asteroid."
	in_space = 1
	icon_state = "meteor4"
	known = 0
	faction = /datum/factions/pirate
	spawn_ships = FALSE
	spawn_types = list(/mob/living/simple_animal/hostile/overmapship/pirate/small, /mob/living/simple_animal/hostile/overmapship/pirate/med)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	initial_generic_waypoints = list(
		"nav_nanotrading_1",
		"nav_nanotrading_2",
		"nav_nanotrading_3"
		)