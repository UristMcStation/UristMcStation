//rylcies stuff

//datum/game_mode/event/proc/RycliesTime()

/turf/simulated/wall/planet

/turf/simulated/wall/planet/ex_act(severity)
	switch(severity)
		if(1.0)
			src.ChangeTurf(/turf/unsimulated/floor)
			return
		if(2.0)
			if(prob(75))
				src.ChangeTurf(/turf/unsimulated/floor)
			else
				dismantle_wall(1,1)
		if(3.0)
			if(prob(10))
				src.ChangeTurf(/turf/unsimulated/floor)
		else
	return

/turf/simulated/wall/planet/dismantle_wall()
	..()
	ChangeTurf(/turf/unsimulated/floor)

/turf/unsimulated/floor/planet

/turf/unsimulated/floor/planet/ex_act(severity)
	switch(severity)
		if(1.0)
			src.ChangeTurf(/turf/unsimulated/floor)
			icon_state = "Floor3"
			return
		if(2.0)
			if(prob(75))

				src.ChangeTurf(/turf/unsimulated/floor)
				icon_state = "Floor3"


		if(3.0)
			if(prob(25))

				src.ChangeTurf(/turf/unsimulated/floor)
				icon_state = "Floor3"

		else
	return

/obj/urist_intangible/planet/rycliesii
	name = "Ryclies II"
	desc = "Such a beautiful planet... You wish you would've come here before it was torn apart by the Galactic Crisis."
	icon = 'icons/urist/events/planets.dmi'
	icon_state = "rycliesii"
//	bound_width = 720
//	bound_height = 720
	layer = 2.0
//	level = 1

/obj/urist_intangible/planet/ex_act(severity)
	return

/obj/landmark/scom/target
	invisibility = 101
	var/artillery = 0
	var/fire = 0

/turf/unsimulated/wall/urist/other/ex_act(severity)
	if(SSticker.mode == "event")
		switch(severity)
			if(1.0)
				src.ChangeTurf(get_base_turf_by_area(src))
				return
			if(2.0)
				if(prob(75))

					src.ChangeTurf(get_base_turf_by_area(src))
			if(3.0)
				if(prob(25))

					src.ChangeTurf(get_base_turf_by_area(src))

			else
		return
	else
		..()

/turf/unsimulated/wall/urist/other/destructable/ex_act(severity)
	switch(severity)
		if(1.0)
			src.ChangeTurf(get_base_turf_by_area(src))
			return
		if(2.0)
			if(prob(75))

				src.ChangeTurf(get_base_turf_by_area(src))
		if(3.0)
			if(prob(25))

				src.ChangeTurf(get_base_turf_by_area(src))

		else
	return

/turf/unsimulated/wall/urist/other/see/destructable/ex_act(severity)
	switch(severity)
		if(1.0)
			src.ChangeTurf(get_base_turf_by_area(src))
			return
		if(2.0)
			if(prob(75))

				src.ChangeTurf(get_base_turf_by_area(src))
		if(3.0)
			if(prob(25))

				src.ChangeTurf(get_base_turf_by_area(src))

		else
	return

/obj/machinery/scom/artillerycontrol
	var/ready = 0
	var/reload = 180
	name = "bluespace artillery control"
	icon_state = "control_boxp1"
	icon = 'icons/obj/machines/power/particle_accelerator2.dmi'
	density = TRUE
	anchored = TRUE
	var/artillery = 0
	var/fire = 0

/obj/machinery/scom/artillerycontrol/Process()
	if(src.reload<120)
		src.reload++

/turf/unsimulated/floor/uristturf/other/scom/destructable/ex_act(severity)
	switch(severity)
		if(1.0)
			src.ChangeTurf(get_base_turf_by_area(src))
			return
		if(2.0)
			if(prob(75))

				src.ChangeTurf(get_base_turf_by_area(src))
		if(3.0)
			if(prob(25))

				src.ChangeTurf(get_base_turf_by_area(src))

		else
	return



/obj/machinery/scom/artillerycontrol/attack_hand(mob/user as mob)
	if(!ready)
		return
	else
		var/want = input("Fire the bluespace artillery?", "Your Choice", "Cancel") in list ("Cancel", "Yes")
		switch(want)
			if("Cancel")
				return
			if("Yes")
				for(var/obj/landmark/scom/target/T in landmarks_list)
					if(T.artillery == artillery && T.fire == fire)
						explosion(T.loc, 1, 2, 5)
						reload = 0
						T.fire++
						fire++
						if(fire == 10)
							ready = 0

/obj/structure/scom/fuckitall/event/attack_hand(mob/user as mob)
	var/want = input("Start the self destruct countdown? You will have 3 minutes to escape.", "Your Choice", "Cancel") in list ("Cancel", "Yes")
	switch(want)
		if("Cancel")
			return
		if("Yes")
			to_world(FONT_LARGE(SPAN_DANGER("Mothership self-destruct sequence activated.")))
			for(var/obj/landmark/scom/bomb/B in landmarks_list)
				B.incomprehensibleprocname()
				sploded = 0
				spawn(300)
					B.incomprehensibleprocname()


/obj/urist_intangible/fakebomb
	name = "explosion"
	icon = 'icons/urist/96x96.dmi'
	icon_state = "explosion"

/turf/simulated/shuttle/wall/destructable/ex_act(severity)
	switch(severity)
		if(1.0)
			src.ChangeTurf(get_base_turf_by_area(src))
			return
		if(2.0)
			if(prob(75))

				src.ChangeTurf(get_base_turf_by_area(src))
			else
				src.ChangeTurf(/turf/simulated/floor/plating)
		if(3.0)
			if(prob(90))

				src.ChangeTurf(/turf/simulated/floor/plating)

		else
	return

/obj/item/clothing/suit/urist/armor/ryclies
	name = "Ryclies Defence Force armor"
	desc = "An armored vest and pauldrons worn by members of the Ryclies Defence Force. Though scuffed around the edges, the hardened vest is still in good condition."
	icon_state = "rycliesarmour"
	item_state = "armor"
	armor = list(melee = 60, bullet = 80, laser = 40, energy = 40, bomb = 20, bio = 0, rad = 0)

/obj/item/clothing/under/urist/ryclies/uniform
	name = "Ryclies Defence Force outfit"
	desc = "A set of fatigues colored in the Ryclian Splinter camouflage pattern and insulated for warmth worn by members of the Ryclies Defence Force. The name tape is missing."
	icon_state = "rycliesuni"
	item_state = "rycliesuni"

/obj/item/clothing/head/urist/ryclies/helmet
	name = "Ryclies Defence Force helmet"
	desc = "An armored helmet worn by members of the Ryclies Defence Force, complete with a HUD panel and a boom microphone. They don't seem to be working properly, though. At least the plating is still in one piece."
	icon_state = "ryclieshelm"
	item_state = "ryclieshelm"
	armor = list(melee = 60, bullet = 80, laser = 40,energy = 35, bomb = 10, bio = 2, rad = 0)

/obj/item/gun/projectile/automatic/kh50
	name = "KH50"
	desc = "A compact rifle chambered in 12.7x54mm Caseless. Heavy and inaccurate, but hard-hitting and reliable. The stamped text on the side reads, 'Kayman-Hale KH-50'"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "KH50"
	item_state = "knight45" // close enough to the look
	wielded_item_state = "knight45"
	item_icons = DEF_URIST_INHANDS
	w_class = ITEM_SIZE_NORMAL
	caliber = CALIBER_RIFLE_CASELESS
	origin_tech = list(TECH_COMBAT = 2)
	slot_flags = SLOT_BELT
	magazine_type = /obj/item/ammo_magazine/a127x54mm
	allowed_magazines = /obj/item/ammo_magazine/a127x54mm
	ammo_type = /obj/item/ammo_casing/a127x54mm
	load_method = MAGAZINE
	fire_sound = 'sound/weapons/gunshot/gunshot_smg.ogg'
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	firemodes = list(
		list(mode_name="semi auto",       burst=1, fire_delay=null,    move_delay=null, one_hand_penalty=0, burst_accuracy=null, dispersion=null),
		list(mode_name="4-round bursts", burst=4, fire_delay=null, move_delay=4,    one_hand_penalty=1, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="full auto",		can_autofire=1, burst=1, fire_delay=0.5, one_hand_penalty=3, burst_accuracy = list(0,-1,-2,-3,-4,-4,-4,-4,-4), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/automatic/kh50/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "KH50"
	else
		icon_state = "KH50-empty"
	return

/obj/item/ammo_magazine/a127x54mm
	name = "rifle magazine"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "12.7x54mm"
	desc = "A magazine for the KH-50 rifle. Holds up to twenty 12.7x54mm Caseless rounds. This magazine is loaded with regular ball ammo."
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE_CASELESS
	ammo_type = /obj/item/ammo_casing/a127x54mm
	matter = list(MATERIAL_STEEL = 1000)
	max_ammo = 31
	multiple_sprites = 0

/obj/item/ammo_magazine/a127x54mm/empty //not sure if this is even necessary anymore
	name = "rifle magazine"
	icon_state = "12.7x54mm-empty"
	icon = 'icons/urist/items/guns.dmi'
	initial_ammo = 0

/obj/item/ammo_casing/a127x54mm
	desc = "A 12.7x54mm bullet casing."
	caliber = CALIBER_RIFLE_CASELESS
	projectile_type = /obj/item/projectile/bullet/rifle/a127

/obj/item/projectile/bullet/rifle/a127
	damage = 25 //low-ish for 12.7, equal with 7.62, but it's what it used to inflict pre-0.1.19 - balance this
	armor_penetration = 20
	distance_falloff = 1

/obj/item/storage/box/kh50ammo
	name = "box of KH-50 ammo"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."

/obj/item/storage/box/kh50ammo/New()
	..()
	new /obj/item/ammo_magazine/a127x54mm(src)
	new /obj/item/ammo_magazine/a127x54mm(src)
	new /obj/item/ammo_magazine/a127x54mm(src)

/obj/structure/scom/shieldgen
	name = "shield generator"
	desc = "The shield generator for the alien mothership"
	icon = 'icons/urist/structures&machinery/scomscience.dmi'
	icon_state = "norm2"

/obj/structure/scom/shieldgen/ex_act(severity)
	switch(severity)
		if(1.0)
			explosion(src.loc, 1, 2, 4)
			qdel(src)
			return
		if(2.0)
			explosion(src.loc, 1, 2, 4)
			qdel(src)
		if(3.0)
			if(prob(75))
				explosion(src.loc, 1, 2, 4)
				qdel(src)

	return

/obj/structure/scom/shieldwall/shieldwall1
	name = "energy field"
	desc = "Impenetrable field of energy, capable of blocking anything as long as it's active."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "shieldsparkles"
	anchored = TRUE
	layer = 4.1		//just above mobs
	density = TRUE

/obj/structure/scom/shieldwall/shieldwall1/Bumped(mob/living/exosuit/premade/hoverpod/fighter/M)
	M.x = src.x
	M.y = src.y

/obj/structure/scom/shieldwall/shieldwall2
	name = "energy field"
	desc = "Impenetrable field of energy, capable of blocking anything as long as it's active."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "shieldsparkles"
	anchored = TRUE
	layer = 4.1		//just above mobs
	density = TRUE

/obj/structure/scom/shieldwall/shieldwall2/Bumped(mob/living/exosuit/premade/hoverpod/fighter/M)
	M.x = src.x
	M.y = src.y

/obj/structure/scom/shieldwall/ex_act(severity)
	switch(severity)
		if(1.0)
			return
		if(2.0)
			return
		if(3.0)
			return



		else
	return

/obj/structure/scom/tanktrap
	name = "tank trap"
	desc = "A twisted X of steel designed to stop a tank in its tracks."
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "tanktrap"
	density = TRUE
	anchored = TRUE
