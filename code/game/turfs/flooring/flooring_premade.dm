// simulated/floor is currently plating by default, but there really should be an explicit plating type.
/turf/simulated/floor/plating
	name = "plating"
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating"
	layer = PLATING_LAYER

/turf/simulated/floor/bluegrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "bcircuit"
	initial_flooring = /singleton/flooring/reinforced/circuit
	light_range = 2
	light_power = 1
	light_color = COLOR_BLUE

/turf/simulated/floor/bluegrid/server
	initial_gas = list("nitrogen" = MOLES_N2STANDARD)
	temperature = 80

/turf/simulated/floor/greengrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "gcircuit"
	initial_flooring = /singleton/flooring/reinforced/circuit/green
	light_range = 2
	light_power = 3
	light_color = COLOR_GREEN

/turf/simulated/floor/redgrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "rcircuit"
	initial_flooring = /singleton/flooring/reinforced/circuit/red
	light_range = 2
	light_power = 2
	light_color = COLOR_RED

/turf/simulated/floor/selfestructgrid
	name = "self-destruct mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "rcircuit_off"
	initial_flooring = /singleton/flooring/reinforced/circuit/selfdestruct
	light_range = 2
	light_power = 2
	light_color = COLOR_BLACK

/turf/simulated/floor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "wood"
	color = WOOD_COLOR_GENERIC
	initial_flooring = /singleton/flooring/wood

/turf/simulated/floor/wood/mahogany
	color = WOOD_COLOR_RICH
	initial_flooring = /singleton/flooring/wood/mahogany

/turf/simulated/floor/wood/maple
	color = WOOD_COLOR_PALE
	initial_flooring = /singleton/flooring/wood/maple

/turf/simulated/floor/wood/ebony
	color = WOOD_COLOR_BLACK
	initial_flooring = /singleton/flooring/wood/ebony

/turf/simulated/floor/wood/walnut
	color = WOOD_COLOR_CHOCOLATE
	initial_flooring = /singleton/flooring/wood/walnut

/turf/simulated/floor/wood/bamboo
	color = WOOD_COLOR_PALE2
	initial_flooring = /singleton/flooring/wood/bamboo

/turf/simulated/floor/wood/yew
	color = WOOD_COLOR_YELLOW
	initial_flooring = /singleton/flooring/wood/yew

/turf/simulated/floor/grass
	name = "grass patch"
	icon = 'icons/urist/turf/uristturf.dmi'
	icon_state = "grass0"
	initial_flooring = /singleton/flooring/grass
	footstep_type = /singleton/footsteps/grass

/turf/simulated/floor/grass/use_tool(obj/item/I, mob/user)
	if(I.IsWirecutter())
		user.visible_message(SPAN_NOTICE("\The [user] trims \the [src] with \the [I]."), SPAN_NOTICE("You trim \the [src] with \the [I]."))
		ChangeTurf(/turf/simulated/floor/grass/cut)
		return TRUE
	return ..()

/turf/simulated/floor/grass/cut
	initial_flooring = /singleton/flooring/grass/cut

/turf/simulated/floor/carpet
	name = "brown carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "brown"
	initial_flooring = /singleton/flooring/carpet

/turf/simulated/floor/carpet/blue
	name = "blue carpet"
	icon_state = "blue1"
	initial_flooring = /singleton/flooring/carpet/blue

/turf/simulated/floor/carpet/blue2
	name = "pale blue carpet"
	icon_state = "blue2"
	initial_flooring = /singleton/flooring/carpet/blue2

/turf/simulated/floor/carpet/blue3
	name = "sea blue carpet"
	icon_state = "blue3"
	initial_flooring = /singleton/flooring/carpet/blue3

/turf/simulated/floor/carpet/magenta
	name = "magenta carpet"
	icon_state = "magenta"
	initial_flooring = /singleton/flooring/carpet/magenta

/turf/simulated/floor/carpet/purple
	name = "purple carpet"
	icon_state = "purple"
	initial_flooring = /singleton/flooring/carpet/purple

/turf/simulated/floor/carpet/orange
	name = "orange carpet"
	icon_state = "orange"
	initial_flooring = /singleton/flooring/carpet/orange

/turf/simulated/floor/carpet/green
	name = "green carpet"
	icon_state = "green"
	initial_flooring = /singleton/flooring/carpet/green

/turf/simulated/floor/carpet/red
	name = "red carpet"
	icon_state = "red"
	initial_flooring = /singleton/flooring/carpet/red

/turf/simulated/floor/carpet/black
	name = "black carpet"
	icon_state = "black"
	initial_flooring = /singleton/flooring/carpet/black

/turf/simulated/floor/reinforced
	name = "reinforced floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "reinforced"
	initial_flooring = /singleton/flooring/reinforced

/turf/simulated/floor/reinforced/airless
	initial_gas = list()

/turf/simulated/floor/reinforced/airmix
	initial_gas = list(GAS_OXYGEN = MOLES_O2ATMOS, GAS_NITROGEN = MOLES_N2ATMOS)

/turf/simulated/floor/reinforced/nitrogen
	initial_gas = list(GAS_NITROGEN = ATMOSTANK_NITROGEN)

/turf/simulated/floor/reinforced/hydrogen
	initial_gas = list(GAS_HYDROGEN = ATMOSTANK_HYDROGEN)

/turf/simulated/floor/reinforced/oxygen
	initial_gas = list(GAS_OXYGEN = ATMOSTANK_OXYGEN)

/turf/simulated/floor/reinforced/phoron
	initial_gas = list(GAS_PHORON = ATMOSTANK_PHORON)

/turf/simulated/floor/reinforced/nitrogen/engine
	name = "engine floor"
	initial_gas = list(GAS_NITROGEN = MOLES_N2STANDARD)

/turf/simulated/floor/reinforced/phoron/fuel
	initial_gas = list(GAS_PHORON = ATMOSTANK_PHORON_FUEL)

/turf/simulated/floor/reinforced/hydrogen/fuel
	initial_gas = list(GAS_HYDROGEN = ATMOSTANK_HYDROGEN_FUEL)

/turf/simulated/floor/reinforced/carbon_dioxide
	initial_gas = list(GAS_CO2 = ATMOSTANK_CO2)

/turf/simulated/floor/reinforced/n20
	initial_gas = list(GAS_N2O = ATMOSTANK_NITROUSOXIDE)


/turf/simulated/floor/cult
	name = "engraved floor"
	icon = 'icons/turf/flooring/cult.dmi'
	icon_state = "cult"
	initial_flooring = /singleton/flooring/reinforced/cult

/turf/simulated/floor/cult/cultify()
	return

//Tiled floor + sub-types

/turf/simulated/floor/tiled
	name = "steel floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "steel"
	initial_flooring = /singleton/flooring/tiling

/turf/simulated/floor/stone
	name = "stone tiles"
	icon = 'icons/turf/flooring/cult.dmi'
	icon_state = "greycult"

/turf/simulated/floor/tiled/dark
	name = "dark floor"
	icon_state = "tiled"
	color = COLOR_DARK_GRAY
	initial_flooring = /singleton/flooring/tiling/dark

/turf/simulated/floor/tiled/dark/monotile
	name = "floor"
	icon_state = "monotile"
	color = COLOR_DARK_GRAY
	initial_flooring = /singleton/flooring/tiling/mono/dark

/turf/simulated/floor/tiled/dark/monotile
	icon_state = "monotile"
	initial_flooring = /singleton/flooring/tiling/dark/mono

/turf/simulated/floor/tiled/white
	name = "white floor"
	icon_state = "tiled_light"
	color = COLOR_OFF_WHITE
	initial_flooring = /singleton/flooring/tiling/white

/turf/simulated/floor/tiled/white/monotile
	name = "floor"
	icon_state = "monotile_light"
	color = COLOR_OFF_WHITE
	initial_flooring = /singleton/flooring/tiling/mono/white

/turf/simulated/floor/tiled/monofloor
	name = "floor"
	icon_state = "steel_monofloor"
	initial_flooring = /singleton/flooring/tiling/mono

/turf/simulated/floor/tiled/white/server
	initial_gas = list("nitrogen" = MOLES_N2STANDARD)
	temperature = 80

/turf/simulated/floor/tiled/freezer
	name = "tiles"
	icon_state = "freezer"
	initial_flooring = /singleton/flooring/tiling/freezer

/turf/simulated/floor/tiled/techmaint
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "techmaint"
	initial_flooring = /singleton/flooring/tiling/new_tile/techmaint

/turf/simulated/floor/tiled/monofloor
	name = "floor"
	icon_state = "monofloor"
	initial_flooring = /singleton/flooring/tiling/new_tile/monofloor

/turf/simulated/floor/tiled/techfloor
	name = "floor"
	icon = 'icons/turf/flooring/techfloor.dmi'
	icon_state = "techfloor_gray"
	initial_flooring = /singleton/flooring/tiling/tech

/turf/simulated/floor/tiled/techfloor/airless
	initial_gas = null

/turf/simulated/floor/tiled/monotile
	name = "floor"
	icon_state = "monotile"
	color = COLOR_GUNMETAL
	initial_flooring = /singleton/flooring/tiling/mono

/turf/simulated/floor/tiled/steel_grid
	name = "floor"
	icon_state = "grid"
	color = COLOR_GUNMETAL
	initial_flooring = /singleton/flooring/tiling/new_tile/steel_grid

/turf/simulated/floor/tiled/steel_ridged
	name = "floor"
	icon_state = "ridged"
	color = COLOR_GUNMETAL
	initial_flooring = /singleton/flooring/tiling/new_tile/steel_ridged

/turf/simulated/floor/tiled/old_tile
	name = "floor"
	icon_state = "tile_full"
	initial_flooring = /singleton/flooring/tiling/new_tile

/turf/simulated/floor/tiled/old_cargo
	name = "floor"
	icon_state = "cargo_one_full"
	initial_flooring = /singleton/flooring/tiling/new_tile/cargo_one

/turf/simulated/floor/tiled/kafel_full
	name = "floor"
	icon_state = "kafel_full"
	initial_flooring = /singleton/flooring/tiling/new_tile/kafel

/turf/simulated/floor/tiled/stone
	name = "stone slab floor"
	icon_state = "stone_full"
	initial_flooring = /singleton/flooring/tiling/stone

/turf/simulated/floor/tiled/techfloor/grid
	name = "floor"
	icon_state = "techfloor_grid"
	initial_flooring = /singleton/flooring/tiling/tech/grid

/turf/simulated/floor/tiled/skrell
	icon = 'icons/turf/skrellturf.dmi'
	icon_state = "skrellblack"
	initial_flooring = /singleton/flooring/reinforced/shuttle/skrell

/turf/simulated/floor/tiled/skrell/white
	icon_state = "skrellwhite"
	initial_flooring = /singleton/flooring/reinforced/shuttle/skrell/white

/turf/simulated/floor/tiled/skrell/red
	icon_state = "skrellred"
	initial_flooring = /singleton/flooring/reinforced/shuttle/skrell/red

/turf/simulated/floor/tiled/skrell/blue
	icon_state = "skrellblue"
	initial_flooring = /singleton/flooring/reinforced/shuttle/skrell/blue

/turf/simulated/floor/tiled/skrell/orange
	icon_state = "skrellorange"
	initial_flooring = /singleton/flooring/reinforced/shuttle/skrell/orange

/turf/simulated/floor/tiled/skrell/green
	icon_state = "skrellgreen"
	initial_flooring = /singleton/flooring/reinforced/shuttle/skrell/green

/turf/simulated/floor/tiled/sand
	name = "sand covered tiles"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroidfloor"
	initial_flooring = /singleton/flooring/tiling/sand

/turf/simulated/floor/lino
	name = "lino"
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_state = "lino"
	initial_flooring = /singleton/flooring/linoleum

//ATMOS PREMADES
/turf/simulated/floor/greengrid/nitrogen
	initial_gas = list(GAS_NITROGEN = MOLES_N2STANDARD)

// Placeholders
/turf/simulated/floor/airless
	map_airless = TRUE

/turf/simulated/floor/airless/lava
	name = "lava"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "lava"

/turf/simulated/floor/ice
	name = "ice"
	icon = 'icons/turf/snow.dmi'
	icon_state = "ice"

/turf/simulated/floor/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

/turf/simulated/floor/snow/New()
	icon_state = pick("snow[rand(1,12)]","snow0")
	..()

/turf/simulated/floor/light
/turf/simulated/floor/ceiling

/turf/simulated/floor/beach
	name = "beach"
	icon = 'icons/misc/beach.dmi'

/turf/simulated/floor/beach/sand
	name = "sand"
	icon_state = "sand"

/turf/simulated/floor/beach/sand/desert
	icon_state = "desert"
	has_resources = 1

/turf/simulated/floor/beach/sand/desert/New()
	icon_state = "desert[rand(0,5)]"
	..()

/turf/simulated/floor/beach/coastline
	name = "coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"
	turf_flags = TURF_IS_WET

/turf/simulated/floor/beach/water
	name = "water"
	icon_state = "water"
	turf_flags = TURF_IS_WET

/turf/simulated/floor/beach/water/is_flooded(lying_mob, absolute)
	. = absolute ? ..() : lying_mob

/turf/simulated/floor/beach/water/update_dirt()
	return	// Water doesn't become dirty

/turf/simulated/floor/beach/water/ocean
	icon_state = "seadeep"

/turf/simulated/floor/beach/water/New()
	..()
	AddOverlays(image("icon"='icons/misc/beach.dmi',"icon_state"="water5","layer"=MOB_LAYER+0.1))

/turf/simulated/floor/crystal
	name = "crystal floor"
	icon = 'icons/turf/flooring/crystal.dmi'
	icon_state = ""
	initial_flooring = /singleton/flooring/crystal

/turf/simulated/floor/scales
	name = "scale floor"
	icon = 'icons/turf/flooring/flesh.dmi'
	icon_state = "scales0"
	initial_flooring = /singleton/flooring/flesh

//Water go splish
/turf/simulated/floor/pool
	name = "pool floor"
	icon = 'icons/turf/flooring/pool.dmi'
	icon_state = "pool"
	initial_flooring = /singleton/flooring/pool

/turf/simulated/floor/bluespace
	name = "bluespace"
	icon = 'icons/turf/space.dmi'
	icon_state = "bluespace"
	initial_flooring = /singleton/flooring/bluespace

/turf/simulated/floor/bluespace/Entered(mob/living/L)
	. = ..()

	if(istype(L) && prob(75))
		L.visible_message(
			SPAN_WARNING("\The [L] starts flickering in and out of existence as they step onto the bluespace!"),
			SPAN_WARNING("You feel your entire body tingle, and something pulling you away!")
		)
		addtimer(new Callback(GLOBAL_PROC, GLOBAL_PROC_REF(do_unstable_teleport_safe), L, GetConnectedZlevels(L.z)), rand(5, 15))

/turf/simulated/floor/forcefield
	name = "ship airshield"
	icon = 'icons/turf/flooring/forcefield.dmi'
	icon_state = "floor"
	initial_flooring = /singleton/flooring/forcefield

/turf/simulated/floor/glass
	icon = 'icons/turf/flooring/glassfloor.dmi'
	icon_state = "glassfloor"
	initial_flooring = /singleton/flooring/glass

/turf/simulated/floor/glass/boro
	initial_flooring = /singleton/flooring/glass/boro
