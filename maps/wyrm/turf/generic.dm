//General tiles, they need to be separate types to survive shuttle use
/obj/item/stack/tile/new_tile
	icon_state = "tile"
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/datum/stack_recipe/tile/metal/hallway
	title = "old hallway tile"
	result_type = /obj/item/stack/tile/new_tile/hallway

/datum/stack_recipe/tile/metal/hallway/mono
	title = "old hallway mono tile"
	result_type = /obj/item/stack/tile/new_tile/hallway/mono

/datum/stack_recipe/tile/metal/dblue
	title = "old dark blue tile"
	result_type = /obj/item/stack/tile/new_tile/dblue

/datum/stack_recipe/tile/metal/dblue/mono
	title = "old dark blue mono tile"
	result_type = /obj/item/stack/tile/new_tile/dblue/mono

/datum/stack_recipe/tile/metal/med
	title = "old sterile tile"
	result_type = /obj/item/stack/tile/new_tile/med

/datum/stack_recipe/tile/metal/med/mono
	title = "old sterile mono tile"
	result_type = /obj/item/stack/tile/new_tile/med/mono

/datum/stack_recipe/tile/metal/dgrey
	title = "old dark grey tile"
	result_type = /obj/item/stack/tile/new_tile/dgrey

/datum/stack_recipe/tile/metal/dgrey/mono
	title = "old dark grey mono tile"
	result_type = /obj/item/stack/tile/new_tile/dgrey/mono

//Hallway
/singleton/flooring/tiling/new_tile/hallway
	color = "#8b9497"
	build_type = /obj/item/stack/tile/new_tile/hallway

/turf/simulated/floor/tiled/old_tile/hallway
	color = "#8b9497"
	initial_flooring = /singleton/flooring/tiling/new_tile/hallway

/obj/item/stack/tile/new_tile/hallway
	name = "old hallway tile"
	singular_name = "old hallway tile"

/singleton/flooring/tiling/new_tile/cargo_one/hallway
	color = "#8b9497"
	build_type = /obj/item/stack/tile/new_tile/hallway/mono

/turf/simulated/floor/tiled/old_cargo/hallway
	color = "#8b9497"
	initial_flooring = /singleton/flooring/tiling/new_tile/cargo_one/hallway

/obj/item/stack/tile/new_tile/hallway/mono
	name = "old hallway mono tile"
	singular_name = "old hallway mono tile"


//Dark Blue
/singleton/flooring/tiling/new_tile/dblue
	color = "#565d61"
	build_type = /obj/item/stack/tile/new_tile/dblue

/turf/simulated/floor/tiled/old_tile/dblue
	color = "#565d61"
	initial_flooring = /singleton/flooring/tiling/new_tile/dblue

/obj/item/stack/tile/new_tile/dblue
	name = "old dark blue tile"
	singular_name = "old dark blue tile"

/singleton/flooring/tiling/new_tile/cargo_one/dblue
	color = "#565d61"
	build_type = /obj/item/stack/tile/new_tile/dblue/mono

/turf/simulated/floor/tiled/old_cargo/dblue
	color = "#565d61"
	initial_flooring = /singleton/flooring/tiling/new_tile/cargo_one/dblue

/obj/item/stack/tile/new_tile/dblue/mono
	name = "old dark blue mono tile"
	singular_name = "old dark blue mono tile"


//Medical/Research
/singleton/flooring/tiling/new_tile/med
	color = "#cccccc"
	build_type = /obj/item/stack/tile/new_tile/med

/turf/simulated/floor/tiled/old_tile/med
	color = "#cccccc"
	initial_flooring = /singleton/flooring/tiling/new_tile/med

/obj/item/stack/tile/new_tile/med
	name = "old sterile tile"
	singular_name = "old sterile tile"

/singleton/flooring/tiling/new_tile/cargo_one/med
	color = "#cccccc"
	build_type = /obj/item/stack/tile/new_tile/med/mono

/turf/simulated/floor/tiled/old_cargo/med
	color = "#cccccc"
	initial_flooring = /singleton/flooring/tiling/new_tile/cargo_one/med

/obj/item/stack/tile/new_tile/med/mono
	name = "old sterile mono tile"
	singular_name = "old sterile mono tile"


//Dark Grey
/singleton/flooring/tiling/new_tile/dgrey
	color = "#666666"
	build_type = /obj/item/stack/tile/new_tile/dgrey

/turf/simulated/floor/tiled/old_tile/dgrey
	color = "#666666"
	initial_flooring = /singleton/flooring/tiling/new_tile/dgrey

/obj/item/stack/tile/new_tile/dgrey
	name = "old dark grey tile"
	singular_name = "old sterile tile"

/singleton/flooring/tiling/new_tile/cargo_one/dgrey
	color = "#666666"
	build_type = /obj/item/stack/tile/new_tile/dgrey/mono

/turf/simulated/floor/tiled/old_cargo/dgrey
	color = "#666666"
	initial_flooring = /singleton/flooring/tiling/new_tile/cargo_one/dgrey

/obj/item/stack/tile/new_tile/dgrey/mono
	name = "old dark grey mono tile"
	singular_name = "old sterile mono tile"


//Engineering

/obj/effect/paint/biege
	color = COLOR_BEIGE

/obj/effect/floor_decal/borderfloorbiege
	name = "border floor"
	icon_state = "borderfloor_white"
	color = COLOR_BEIGE

/obj/effect/floor_decal/borderfloorbiege/corner
	icon_state = "borderfloorcorner_white"

/obj/effect/floor_decal/borderfloorbiege/corner2
	icon_state = "borderfloorcorner2_white"

/obj/effect/floor_decal/borderfloorbiege/full
	icon_state = "borderfloorfull_white"

/obj/effect/floor_decal/borderfloorbiege/cee
	icon_state = "borderfloorcee_white"

/obj/structure/window/reinforced/full/antique
	paint_color = "#ffffff"

/obj/structure/wall_frame/antique
	paint_color = COLOR_BEIGE

/obj/effect/wallframe_spawn/reinforced/antique
	name = "antique wall frame window spawner"
	win_path = /obj/structure/window/reinforced/full/antique
	frame_path = /obj/structure/wall_frame/antique
