//the only things worthwhile from urist's turf file

/turf/simulated/wall/false
	can_open = 1

/turf/simulated/wall/r_wall/false
	can_open = 1

/turf/simulated/wall/wood
	icon = 'icons/urist/turf/walls.dmi'
	icon_state = "wood0"

/turf/simulated/wall/wood/New(var/newloc)
	..(newloc,"wood")

/turf/simulated/floor/plating/airless
	initial_gas = null

/turf/unsimulated/floor/plating
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"

/decl/flooring/tiling/new_tile/hallway
	color = "#8b9497"

/decl/flooring/tiling/new_tile/cargo_one/hallway
	color = "#8b9497"

/decl/flooring/tiling/new_tile/dblue
	color = "#565D61"

/decl/flooring/tiling/new_tile/cargo_one/dblue
	color = "#565D61"

/decl/flooring/tiling/new_tile/med
	color = "#CCCCCC"

/decl/flooring/tiling/new_tile/cargo_one/med
	color = "#CCCCCC"

/decl/flooring/tiling/new_tile/dgrey
	color = "#666666"

/decl/flooring/tiling/new_tile/cargo_one/dgrey
	color = "#666666"
