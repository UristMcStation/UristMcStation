//AREAS FOR THE JUNGLE

//shuttle

/area/shuttle/outpost/jungle
	name = "\improper Outpost Shuttle Jungle"
	icon_state = "shuttle"

/area/shuttle/outpost/station
	name = "\improper Outpost Shuttle"
	icon_state = "shuttle"

//regular jungle

/area/jungle
	name = "jungle"
	icon = 'icons/jungle.dmi'
	icon_state = "area"
	lighting_use_dynamic = 0
	luminosity = 1
	base_turf = /turf/simulated/jungle/clear/grass1

/area/jungle/explored
	icon_state = "area2"

//temple area

/area/jungle/temple_one
	name = "temple"
	lighting_use_dynamic = 1
	icon = 'icons/jungle.dmi'
	icon_state = "temple1"

/area/jungleoutpost
	name = "\improper Jungle Outpost"
	icon_state = "away"
	base_turf = /turf/simulated/jungle/clear/grass1