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
				take_damage(rand(150, 250))
			else
				dismantle_wall(1,1)
		if(3.0)
			take_damage(rand(0, 250))
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

/obj/effect/urist/planet/rycliesii
	name = "Ryclies II"
	desc = "Such a beautiful planet... You wish you would've come here before it was torn apart by the Galactic Crisis."
	icon = 'icons/urist/events/planets.dmi'
	icon_state = "rycliesii"
//	bound_width = 720
//	bound_height = 720
	layer = 2.0
//	level = 1

/obj/effect/urist/planet/ex_act(severity)
	return

/obj/effect/landmark/scom/target
	invisibility = 101
	var/artillery = 0
	var/fire = 0

/turf/unsimulated/wall/urist/other/ex_act(severity)
	if(ticker.mode == "event")
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
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	density = 1
	anchored = 1
	var/artillery = 0
	var/fire = 0

/obj/machinery/scom/artillerycontrol/process()
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
				for(var/obj/effect/landmark/scom/target/T in world)
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
			world << "<FONT size = 3><span class='danger'> Mothership self-destruct sequence activated.</span></FONT>"
			for(var/obj/effect/landmark/scom/bomb/B in world)
				B.incomprehensibleprocname()
				sploded = 0
				spawn(300)
					B.incomprehensibleprocname()


/obj/effect/urist/fakebomb
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

/obj/item/weapon/gun/projectile/automatic/kh50
	item_icons = DEF_URIST_INHANDS
	name = "KH50"
	desc = "A compact rifle chambered in 12.7x54mm Caseless. Heavy and inaccurate, but hard-hitting and reliable. The stamped text on the side reads, 'Kayman-Hale KH-50'"
	icon_state = "KH50"
	item_state = "gun"
	icon = 'icons/urist/items/guns.dmi'
	force = 12
	caliber = "12.7x54mm"
	magazine_type = /obj/item/ammo_magazine/a127x54mm
	load_method = MAGAZINE
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'


/obj/item/weapon/gun/projectile/automatic/kh50/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "KH50"
	else
		icon_state = "KH50-empty"
	return

/obj/item/ammo_magazine/a127x54mm
	name = "magazine (12.7x54mm)"
	icon_state = "12.7x54mm"
	desc = "A magazine for the KH-50 rifle. Holds up to twenty 12.7x54mm Caseless rounds. This magazine is loaded with regular ball ammo."
	icon = 'icons/urist/items/guns.dmi'
	origin_tech = "combat=2"
	ammo_type = /obj/item/ammo_casing/a127x54mm
	max_ammo = 31
	multiple_sprites = 0
	mag_type = MAGAZINE
	caliber = "12.7x54mm"

/obj/item/ammo_magazine/a127x54mm/empty //not sure if this is even necessary anymore
	name = "magazine (12.7x54mm)"
	icon_state = "12.7x54mm-empty"
	icon = 'icons/urist/items/guns.dmi'
	initial_ammo = 0

/obj/item/ammo_casing/a127x54mm
	desc = "A 12.7x54mm bullet casing."
	caliber = "12.7x54mm"
	projectile_type = /obj/item/projectile/bullet/rifle/a127

/obj/item/projectile/bullet/rifle/a127
	damage = 25 //low-ish for 12.7, equal with 7.62, but it's what it used to inflict pre-0.1.19 - balance this

/obj/item/weapon/storage/box/kh50ammo
	name = "box of KH-50 ammo"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."

	New()
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
	anchored = 1
	layer = 4.1		//just above mobs
	density = 1

/obj/structure/scom/shieldwall/shieldwall1/Bumped(var/obj/mecha/working/hoverpod/fighter/small/alien/M)
	M.x = src.x
	M.y = src.y

/obj/structure/scom/shieldwall/shieldwall2
	name = "energy field"
	desc = "Impenetrable field of energy, capable of blocking anything as long as it's active."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "shieldsparkles"
	anchored = 1
	layer = 4.1		//just above mobs
	density = 1

/obj/structure/scom/shieldwall/shieldwall2/Bumped(var/obj/mecha/working/hoverpod/fighter/M)
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
	density = 1
	anchored = 1