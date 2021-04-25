/turf/simulated/floor/road
	name = "Road"
	desc = "It's a road"
	icon = 'maps/away/geminus_city/citymap_icons/roads.dmi'
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
	icon = 'maps/away/geminus_city/citymap_icons/pavement.dmi'
	icon_state = "pavement"

/turf/simulated/floor/pavement/empty
	icon_state = "pave_empty"
	dir = 2

/turf/simulated/floor/pavement/corner
	icon_state = "pave_corner"

/turf/simulated/floor/pavement/corner_invert
	icon_state = "pave_invert_corner"

/turf/simulated/floor/pavement/lighting
	light_max_bright = 0.4
	light_inner_range = 0.1
	light_outer_range = 1.5
	light_falloff_curve = 0.5

/turf/simulated/floor/pavement/lighting/Initialize()
	light_color = SSskybox.BGcolor

	. = ..()

/turf/simulated/floor/asteroid/planet
	initial_gas = list("oxygen" = MOLES_O2STANDARD, "nitrogen" = MOLES_N2STANDARD)
	temperature = 293.15

/turf/simulated/floor/fixed/uristturf/geminus
	name = "floor"
	icon = 'maps/away/geminus_city/citymap_icons/floors.dmi'

/turf/simulated/floor/tiled/uristturf/geminus
	icon = 'maps/away/geminus_city/citymap_icons/floors.dmi'