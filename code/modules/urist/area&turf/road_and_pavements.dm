/turf/simulated/floor/road
	name = "Road"
	desc = "It's a road"
	icon = 'icons/urist/citymap_icons/roads.dmi'
	icon_state = "road"

/turf/simulated/floor/road/empty
	icon_state = "road_empty"

/turf/simulated/floor/road/corner
	icon_state = "road_corner"

/turf/simulated/floor/road/markings
	icon_state = "road_marking"

/turf/simulated/floor/pavement
	name = "Pavement"
	desc = "It's a pavement"
	icon = 'icons/urist/citymap_icons/pavement.dmi'
	icon_state = "pavement"

/turf/simulated/floor/pavement/empty
	icon_state = "pave_empty"
	dir = 2

/turf/simulated/floor/pavement/corner
	icon_state = "pave_corner"

/turf/simulated/floor/pavement/corner_invert
	icon_state = "pave_invert_corner"

/turf/simulated/floor/pavement/lighting
	light_power = 0.4
	light_range = 1.5

/turf/simulated/floor/pavement/lighting/Initialize()
	light_color = SSskybox.background_color

	. = ..()

/turf/simulated/floor/pavement/lighting/empty
	icon_state = "pave_empty"
	dir = 2

/turf/simulated/floor/pavement/lighting/corner
	icon_state = "pave_corner"

/turf/simulated/floor/fixed/uristturf/geminus
	name = "floor"
	icon = 'icons/urist/citymap_icons/floors.dmi'

/turf/simulated/floor/tiled/uristturf/geminus
	icon = 'icons/urist/citymap_icons/floors.dmi'
