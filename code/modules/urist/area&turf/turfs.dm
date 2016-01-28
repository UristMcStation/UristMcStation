/*Urist McStation turfs! Includes the entryscreen because yes, that's a turf.

Basically, if you need to add turfs for UMcS, use this file -Glloyd */


/*TURFS
********I SWEAR, IF ANYONE FUCKS WITH THIS, I WILL KILL YOU. -Glloyd******** //oh man, i don't even know why I was pissed anymore

Icons for uristturfs from Nienhaus, Glloyd and Lord Slowpoke*/

/turf/simulated/floor/uristturf
	name = "floor"
	icon = 'icons/urist/turf/uristturf.dmi'
	icon_state = "yellowdiag02"
	floor_type = new/obj/item/stack/tile/steel

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

turf/simulated/floor/beach/pool/New()
	..()
	overlays += image("icon"='icons/urist/turf/uristturf.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1)

//Space! Because fuck /tg/!

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
		icon_state = "speedspace_ew_15"

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
	oxygen=0 // BIRDS HATE OXYGEN FOR SOME REASON
	nitrogen = MOLES_O2STANDARD+MOLES_N2STANDARD // So it totals to the same pressure
	//icon = 'icons/turf/shuttle-debug.dmi'

/turf/simulated/shuttle/plating/vox
	oxygen=0 // BIRDS HATE OXYGEN FOR SOME REASON
	nitrogen = MOLES_O2STANDARD+MOLES_N2STANDARD // So it totals to the same pressure
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

	intact = 0

	New()
		..()
		// Fucking cockshit dickfuck shitslut
		name = "catwalk"
		update_icon(1)

	update_icon(var/propogate=1)
		underlays.Cut()
		underlays += new /icon('icons/turf/space.dmi',"[((x + y) ^ ~(x * y) + z) % 25]")

		var/dirs = 0
		for(var/direction in cardinal)
			var/turf/T = get_step(src,direction)
			if(T.is_catwalk())
				var/turf/simulated/floor/plating/airless/catwalk/C=T
				dirs |= direction
				if(propogate)
					C.update_icon(0)
		icon_state="catwalk[dirs]"


	attackby(obj/item/C as obj, mob/user as mob)
		if(!C || !user)
			return 0
		if(istype(C, /obj/item/weapon/screwdriver))
			ReplaceWithLattice()
			playsound(src, 'sound/items/Screwdriver.ogg', 80, 1)
			return

		if(istype(C, /obj/item/stack/cable_coil))
			var/obj/item/stack/cable_coil/coil = C
			coil.turf_place(src, user)

	is_catwalk()
		return 1

//moon turfs for nien

/turf/simulated/floor/plating/airless/moon //floor piece
	name = "Moon"
	icon = 'icons/urist/turf/uristturf.dmi'
	icon_state = "moon"
	oxygen = 0.01
	nitrogen = 0.01
	temperature = T0C
	icon_plating = "moon"


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
	floor_type = new/obj/item/stack/tile/steel

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

/turf/simulated/wall/r_wall/false
	can_open = 1