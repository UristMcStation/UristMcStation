/* Diffrent misc types of tiles
 * Contains:
 *		Prototype
 *		Grass
 *		Wood
 *		Linoleum
 *		Carpet
 */

/obj/item/stack/tile
	name = "tile"
	singular_name = "tile"
	desc = "A non-descript floor tile."
	randpixel = 7
	w_class = ITEM_SIZE_NORMAL
	max_amount = 100
	icon = 'icons/obj/tiles.dmi'

	force = 1
	throwforce = 1
	throw_speed = 5
	throw_range = 20
	item_flags = 0
	obj_flags = 0

/obj/item/stack/tile/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(is_sharp(I) && throwforce < 20)
		to_chat(user, "<span class = 'notice'>You begin to sharpen \the [src] with \the [I].</span>")
		if(do_after(user, 30, src))
			to_chat(user, "<span class = 'notice'>You sharpen \the [src]'s edges to a sharp point.</span>")
			throwforce = 20
			return
	..()

/*
 * Grass
 */
/obj/item/stack/tile/grass
	name = "grass tile"
	singular_name = "grass floor tile"
	desc = "A patch of grass like they often use on golf courses."
	icon_state = "tile_grass"
	origin_tech = list(TECH_BIO = 1)
	build_type = /decl/flooring/grass

/*
 * Wood
 */
/obj/item/stack/tile/wood
	name = "wood floor tile"
	singular_name = "wood floor tile"
	desc = "An easy to fit wooden floor tile."
	icon_state = "tile-wood"
	build_type = /decl/flooring/wood

/obj/item/stack/tile/wood/cyborg
	name = "wood floor tile synthesizer"
	desc = "A device that makes wood floor tiles."
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/wood
	build_type = /decl/flooring/wood

/obj/item/stack/tile/floor
	name = "steel floor tile"
	singular_name = "steel floor tile"
	desc = "Those could work as a pretty decent throwing weapon." //why?
	icon_state = "tile"
	force = 6
	matter = list(DEFAULT_WALL_MATERIAL = 937.5)
	throwforce = 15
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	build_type = /decl/flooring/tiling

/obj/item/stack/tile/mono
	name = "steel mono tile"
	singular_name = "steel mono tile"
	icon_state = "tile"
	matter = list(DEFAULT_WALL_MATERIAL = 937.5)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/mono/dark
	name = "dark mono tile"
	singular_name = "dark mono tile"
	icon_state = "tile"
	matter = list(DEFAULT_WALL_MATERIAL = 937.5)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/mono/white
	name = "white mono tile"
	singular_name = "white mono tile"
	icon_state = "tile"
	matter = list(DEFAULT_WALL_MATERIAL = 937.5)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	build_type = /decl/flooring/tiling/mono

/obj/item/stack/tile/grid
	name = "grey grid tile"
	singular_name = "grey grid tile"
	icon_state = "tile_grid"
	matter = list(DEFAULT_WALL_MATERIAL = 937.5)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	build_type = /decl/flooring/tiling/new_tile/steel_grid

/obj/item/stack/tile/ridge
	name = "grey ridge tile"
	singular_name = "grey ridge tile"
	icon_state = "tile_ridged"
	matter = list(DEFAULT_WALL_MATERIAL = 937.5)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	build_type = /decl/flooring/tiling/new_tile/steel_ridged

/obj/item/stack/tile/techgrey
	name = "grey techfloor tile"
	singular_name = "grey techfloor tile"
	icon_state = "techtile_grey"
	matter = list(DEFAULT_WALL_MATERIAL = 937.5)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	build_type = /decl/flooring/tiling/new_tile/techmaint

/obj/item/stack/tile/techgrid
	name = "grid techfloor tile"
	singular_name = "grid techfloor tile"
	icon_state = "techtile_grid"
	matter = list(DEFAULT_WALL_MATERIAL = 937.5)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	build_type = /decl/flooring/tiling/tech/grid

/obj/item/stack/tile/techmaint
	name = "dark techfloor tile"
	singular_name = "dark techfloor tile"
	icon_state = "techtile_maint"
	matter = list(DEFAULT_WALL_MATERIAL = 937.5)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	build_type = /decl/flooring/tiling/tech

/obj/item/stack/tile/floor_white
	name = "white floor tile"
	singular_name = "white floor tile"
	icon_state = "tile_white"
	matter = list("plastic" = 937.5)
	build_type = /decl/flooring/tiling/white

/obj/item/stack/tile/floor_white/fifty
	amount = 50

/obj/item/stack/tile/floor_dark
	name = "dark floor tile"
	singular_name = "dark floor tile"
	icon_state = "fr_tile"
	matter = list("plasteel" = 937.5)
	build_type = /decl/flooring/tiling/dark

/obj/item/stack/tile/floor_dark/fifty
	amount = 50

/obj/item/stack/tile/floor_freezer
	name = "freezer floor tile"
	singular_name = "freezer floor tile"
	icon_state = "tile_freezer"
	matter = list("plastic" = 937.5)
	build_type = /decl/flooring/tiling/freezer

/obj/item/stack/tile/floor_freezer/fifty
	amount = 50

/obj/item/stack/tile/floor/cyborg
	name = "floor tile synthesizer"
	desc = "A device that makes floor tiles."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/floor
	build_type = /decl/flooring/tiling

/obj/item/stack/tile/linoleum
	name = "linoleum"
	singular_name = "linoleum"
	desc = "A piece of linoleum. It is the same size as a normal floor tile!"
	icon_state = "tile-linoleum"
	build_type = /decl/flooring/linoleum

/obj/item/stack/tile/linoleum/fifty
	amount = 50

/*
 * Carpets
 */
/obj/item/stack/tile/carpet
	name = "brown carpet"
	singular_name = "brown carpet"
	desc = "A piece of brown carpet."
	icon_state = "tile_carpetbrown"
	build_type = /decl/flooring/carpet

/obj/item/stack/tile/carpet/fifty
	amount = 50

/obj/item/stack/tile/carpetblue
	name = "blue carpet"
	desc = "A piece of blue and gold carpet."
	singular_name = "blue carpet"
	icon_state = "tile_carpetblue"
	build_type = /decl/flooring/carpet/blue

/obj/item/stack/tile/carpetblue/fifty
	amount = 50

/obj/item/stack/tile/carpetblue2
	name = "pale blue carpet"
	desc = "A piece of blue and silver carpet."
	singular_name = "pale blue carpet"
	icon_state = "tile_carpetblue2"
	build_type = /decl/flooring/carpet/blue2

/obj/item/stack/tile/carpetblue2/fifty
	amount = 50

/obj/item/stack/tile/carpetpurple
	name = "purple carpet"
	desc = "A piece of purple carpet."
	singular_name = "purple carpet"
	icon_state = "tile_carpetpurple"
	build_type = /decl/flooring/carpet/purple

/obj/item/stack/tile/carpetpurple/fifty
	amount = 50

/obj/item/stack/tile/carpetorange
	name = "orange carpet"
	desc = "A piece of orange carpet."
	singular_name = "orange carpet"
	icon_state = "tile_carpetorange"
	build_type = /decl/flooring/carpet/orange

/obj/item/stack/tile/carpetorange/fifty
	amount = 50

/obj/item/stack/tile/carpetgreen
	name = "green carpet"
	desc = "A piece of green carpet."
	singular_name = "green carpet"
	icon_state = "tile_carpetgreen"
	build_type = /decl/flooring/carpet/green

/obj/item/stack/tile/carpetgreen/fifty
	amount = 50

/obj/item/stack/tile/carpetred
	name = "red carpet"
	desc = "A piece of red carpet."
	singular_name = "red carpet"
	icon_state = "tile_carpetred"
	build_type = /decl/flooring/carpet/red

/obj/item/stack/tile/carpetred/fifty
	amount = 50