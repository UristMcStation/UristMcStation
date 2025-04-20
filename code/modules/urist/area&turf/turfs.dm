/*Urist McStation turfs! Includes the entryscreen because yes, that's a turf.

Basically, if you need to add turfs for UMcS, use this file -Glloyd */


/*TURFS
********I SWEAR, IF ANYONE FUCKS WITH THIS, I WILL KILL YOU. -Glloyd******** //oh man, i don't even know why I was pissed anymore

Icons for uristturfs from Nienhaus, Glloyd and Lord Slowpoke*/

/turf/simulated/floor/fixed/uristturf
	name = "floor"
	icon = 'icons/urist/turf/uristturf.dmi'
	icon_state = "yellowdiag02"

//unsimulated version

/turf/unsimulated/floor/uristturf
	name = "floor"
	icon = 'icons/urist/turf/uristturf.dmi'
	icon_state = "yellowdiag02"

//rails

/turf/unsimulated/floor/uristturf/rail
	name = "rail"
	icon = 'icons/urist/turf/uristturf.dmi'
	icon_state = "rail1"

//Holy fuck. Anyways, this is pool turf, so we don't fuck up /tg/ .dmi's. ALSO, if there ARE turfs to add, add them above this.

/turf/simulated/floor/beach/pool
	name = "Pool"
	icon = 'icons/urist/turf/uristturf.dmi'
	icon_state = "water4"

/turf/simulated/floor/beach/pool/New()
	..()
	AddOverlays(image("icon"='icons/urist/turf/uristturf.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1))

/turf/simulated/floor/plating/airless
	initial_gas = null

/*//Space! Because fuck /tg/!
transit/east is the same thing now AFAIK
/turf/space/transit/west // moving to the west
	icon = 'icons/urist/turf/uristturf.dmi'
	pushdirection = EAST

	shuttlespace_ew1
		icon_state = "speedspace_ew_1"
	shuttlespace_ew2
		icon_state = "speedspace_ew_2"
	shuttlespace_ew3
		icon_state = "speedspace_ew_3"
	shuttlespace_ew4
		icon_state = "speedspace_ew_4"
	shuttlespace_ew5
		icon_state = "speedspace_ew_5"
	shuttlespace_ew6
		icon_state = "speedspace_ew_6"
	shuttlespace_ew7
		icon_state = "speedspace_ew_7"
	shuttlespace_ew8
		icon_state = "speedspace_ew_8"
	shuttlespace_ew9
		icon_state = "speedspace_ew_9"
	shuttlespace_ew10
		icon_state = "speedspace_ew_10"
	shuttlespace_ew11
		icon_state = "speedspace_ew_11"
	shuttlespace_ew12
		icon_state = "speedspace_ew_12"
	shuttlespace_ew13
		icon_state = "speedspace_ew_13"
	shuttlespace_ew14
		icon_state = "speedspace_ew_14"
	shuttlespace_ew15
		icon_state = "speedspace_ew_15"*/

//entryscreen for UMcS, done by Glloyd.

/turf/unsimulated/wall/uristscreen
	name = "Space Station 13"
	icon = 'icons/urist/entryscreen.dmi'
	icon_state = "title"
	layer = FLY_LAYER

//snow trail for the snow awaymap I'm making

/turf/simulated/floor/plating/snow/trail
	name = "snow covered trail"
	icon = 'icons/urist/turf/uristturf.dmi'
	icon_state = "snowpath"

// VOX SHUTTLE SHIT
/turf/simulated/shuttle/floor/vox
	//icon = 'icons/turf/shuttle-debug.dmi'

/turf/simulated/shuttle/plating/vox
	//icon = 'icons/turf/shuttle-debug.dmi'


// CATWALKS
// Space and plating, all in one buggy fucking turf!

/turf/proc/is_catwalk()
	return 0

/turf/simulated/floor/plating/airless/catwalk
	icon = 'icons/urist/turf/catwalks.dmi'
	icon_state = "catwalk0"
	name = "catwalk"
	desc = "Cats really don't like these things."

	temperature = TCMB
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 700000

	//lighting_lumcount = 4		//starlight
	layer = 2

/turf/simulated/floor/plating/airless/catwalk/New()
	..()
	// Fucking cockshit dickfuck shitslut
	name = "catwalk"
	update_icon(1)

/turf/simulated/floor/plating/airless/catwalk/on_update_icon()
	var/propogate = 0
	underlays.Cut()
	underlays += new /icon('icons/turf/space.dmi',"[((x + y) ^ ~(x * y) + z) % 25]")

	var/dirs = 0
	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src,direction)
		if(T.is_catwalk())
			var/turf/simulated/floor/plating/airless/catwalk/C=T
			dirs |= direction
			if(propogate)
				C.update_icon(0)
	icon_state="catwalk[dirs]"


/turf/simulated/floor/plating/airless/catwalk/use_tool(obj/item/C, mob/living/user, list/click_params)
	if(!C || !user)
		return TRUE

	if(isScrewdriver(C))
		ReplaceWithLattice()
		playsound(src, 'sound/items/Screwdriver.ogg', 80, 1)
		return TRUE

	if(isCoil(C))
		var/obj/item/stack/cable_coil/coil = C
		coil.PlaceCableOnTurf(src, user)
		return TRUE

	return ..()

/turf/simulated/floor/plating/airless/catwalk/is_catwalk()
	return TRUE

//moon turfs for nien

/turf/simulated/floor/plating/airless/moon //floor piece
	name = "Moon"
	icon = 'icons/urist/turf/uristturf.dmi'
	icon_state = "moon"
	temperature = T0C


/turf/simulated/floor/plating/airless/moon/New()
	var/proper_name = name
	..()
	name = proper_name
	if(prob(20))
		icon_state = "moon[rand(0,12)]"


/turf/simulated/floor/airless/uristturf
	name = "floor"
	icon = 'icons/urist/turf/uristturf.dmi'
	icon_state = "moon_floor"

/turf/simulated/floor/plating/airless/uristturf
	name = "plating"
	icon = 'icons/urist/turf/uristturf.dmi'
	icon_state = "moon_plating"



//unsimulated walls

/turf/unsimulated/wall/wood
	name = "wood wall"
	icon = 'icons/urist/turf/walls.dmi'
	icon_state = "wood0"

/turf/unsimulated/wall/stone
	name = "stone wall"
	icon = 'icons/urist/turf/walls.dmi'
	icon_state = "stone0"

//for mappers

/turf/simulated/wall/false
	can_open = 1
	paint_color = COLOR_WALL_GUNMETAL

/turf/simulated/wall/r_wall/false
	can_open = 1
	paint_color = COLOR_WALL_GUNMETAL

/turf/simulated/wall/r_wall/hull/false
	can_open = 1

/turf/simulated/wall/wood
	icon = 'icons/urist/turf/walls.dmi'
	icon_state = "wood0"

/turf/simulated/wall/wood/New(newloc)
	..(newloc,"wood")

//unsimulated floor w/ plating icon, for base-turf in hangars and such
/turf/unsimulated/floor/plating
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"

/turf/unsimulated/floor/fakestairs
	name = "stairs"
	icon = 'icons/urist/turf/uristturf.dmi'
	icon_state = "fakestairs"

//more baseturf
/turf/unsimulated/floor/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

/turf/simulated/floor/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"
	has_snow = TRUE

/turf/simulated/floor/plating/flaps //this is hacky, but it'll prevent the airtight flaps from resetting every time the ship takes off
	blocks_air = 1

//alium space ships

/turf/simulated/wall/alium/ship
	icon = 'icons/urist/turf/scomturfs.dmi'

/turf/simulated/wall/alium/ship/see
	opacity = 0

/turf/simulated/floor/fixed/alium/ship
	name = "alien flooring"
	desc = "This obviously wasn't made for your feet."
	icon = 'icons/urist/turf/scomturfs.dmi'

//holofloors

/turf/simulated/floor/holofloor/ice
	name = "ice"
	base_name = "ice"
	icon = 'icons/turf/snow.dmi'
	base_icon = 'icons/turf/snow.dmi'
	icon_state = "ice"
	base_icon_state = "ice"

//reinf floors

/turf/simulated/floor/shuttle_ceiling
	name = "hull plating"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "reinforced_light"
	initial_gas = null

//moved from the destroyed colony awaymap files

/turf/simulated/floor/fixed/destroyedroad
	name = "road"
	desc = "It's a road. It's seen better days."
	icon = 'icons/urist/turf/floorsplus.dmi'
	icon_state = "innermiddle"

/turf/simulated/floor/fixed/destroyedroad/use_tool(obj/item/C, mob/user, click_params)
	SHOULD_CALL_PARENT(FALSE)
	if(isCrowbar(C))
		to_chat(user, "<span class='notice'>There aren't any openings big enough to pry it away...</span>")
		return TRUE

/turf/simulated/floor/fixed/destroyedroad/ex_act(severity)
	return
//	if(severity == 1)
//		ChangeTurf(get_base_turf_by_area(src))

/turf/simulated/floor/fixed/destroyedroad/planet
	light_power = 0.4
	light_range = 1.5

/turf/simulated/floor/fixed/destroyedroad/planet/Initialize()
	light_color = SSskybox.background_color

	. = ..()

//lighter ship walls

/turf/simulated/wall/r_wall/hull/white
	name = "hull"
	color = "#e3e3e3"

/turf/simulated/wall/r_wall/hull/dark
	color = "#3b494d"

//restoring airless turfs purged from bay

/turf/simulated/floor/greengrid/airless
	map_airless = TRUE

/turf/simulated/floor/bluegrid/airless
	map_airless = TRUE

/turf/simulated/floor/tiled/airless
	map_airless = TRUE

/turf/simulated/floor/tiled/dark/airless
	map_airless = TRUE

/turf/simulated/floor/tiled/white/airless
	map_airless = TRUE
