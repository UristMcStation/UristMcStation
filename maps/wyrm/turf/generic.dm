//the only things worthwhile from urist's turf file

/turf/simulated/wall/false
	can_open = 1

/turf/simulated/wall/r_wall/false
	can_open = 1

/turf/simulated/wall/wood
	icon = 'icons/urist/turf/walls.dmi'
	icon_state = "wood0"

/turf/simulated/wall/wood/New(newloc)
	..(newloc,"wood")

/turf/simulated/floor/plating/airless
	initial_gas = null

/turf/unsimulated/floor/plating
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"
