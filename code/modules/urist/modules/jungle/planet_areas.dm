//AREAS FOR THE JUNGLE

//regular jungle

/area/planet
	name = "planet"
	luminosity = 1
	icon = 'icons/jungle.dmi'
	icon_state = "area"
	has_gravity = 1

/area/planet/jungle
	name = "jungle"
	base_turf = /turf/simulated/floor/planet/jungle/clear/grass1
	forced_ambience = list('sound/ambience/jungle.ogg')

/area/planet/jungle/away

//Unused code
/*
/area/planet/jungle/explored
	icon_state = "area2"

//temple area

/area/planet/jungle/temple_one
	name = "temple"
	icon = 'icons/jungle.dmi'
	icon_state = "temple1"
*/

/area/jungleoutpost
	name = "\improper Jungle Outpost"
	icon_state = "away"
	base_turf = /turf/simulated/floor/planet/jungle/clear/grass1
	forced_ambience = list('sound/ambience/jungle.ogg')
