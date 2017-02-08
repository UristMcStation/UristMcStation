//alien

/obj/machinery/computer/shuttle_control/assault
	var/readytogo = 0
	density = 0

/obj/machinery/computer/shuttle_control/assault/attack_hand(mob/user)
	if(!readytogo)
		user << "<span class='warning'>The shuttles will be ready to launch shortly.</span>"
		return
	else
		..()

/obj/machinery/computer/shuttle_control/assault/alien1
	name = "alien shuttle console (Shuttle 1)"
	shuttle_tag = "Assault 1"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cellconsole"

/obj/machinery/computer/shuttle_control/assault/alien2
	name = "alien shuttle console (Shuttle 2)"
	shuttle_tag = "Assault 2"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cellconsole"

/obj/item/weapon/gun/energy/lactera
	urist_only = 1
	name = "alien gun"
	desc = "A weapon of unknown origin, carried by the Lactera soldiers."
	icon_state = "alienrifle"
	item_state = "alienrifle"
	fire_sound = 'sound/weapons/laser3.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 3
	icon = 'icons/urist/items/guns.dmi'
	force = 10
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	origin_tech = "combat=7;magnets=5;materials=4;engineering=2;powerstorage=4;"
	projectile_type = /obj/item/projectile/beam
	fire_delay = 1 //rapid fire
	max_shots = 8
	self_recharge = 1
	urist_only = 1
	var/inertstate = /obj/item/scom/aliengun

/obj/item/weapon/gun/energy/lactera/update_icon()
	..()
	item_state = initial(item_state)
	icon_state = initial(icon_state)

/obj/item/weapon/gun/energy/lactera/a1
	name = "alien pistol"
	icon_state = "alienpistol"
	item_state = "alienpistol"
	projectile_type = /obj/item/projectile/beam/scom/alien2
	max_shots = 4
	origin_tech = "combat=6;magnets=4;materials=3;engineering=1;powerstorage=3;"
	inertstate = /obj/item/scom/aliengun/a1

/obj/item/weapon/gun/energy/lactera/a2
	name = "alien carbine"
	icon_state = "lightalienrifle"
	item_state = "lightalienrifle"
	projectile_type = /obj/item/projectile/beam/scom/alien6
	inertstate = /obj/item/scom/aliengun/a2
	max_shots = 12
	requires_two_hands = 1

/obj/item/weapon/gun/energy/lactera/a3
	name = "alien rifle"
	item_state = "alienrifle"
	icon_state = "alienrifle"
	projectile_type = /obj/item/projectile/beam/scom/alien2
	origin_tech = "combat=8;magnets=6;materials=5;engineering=3;powerstorage=5;"
	inertstate = /obj/item/scom/aliengun/a3
	requires_two_hands = 2


	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, move_delay=null, burst_accuracy=null, dispersion=null, requires_two_hands = 2),
		list(mode_name="3-round bursts", burst=3, move_delay=6, fire_delay=null, requires_two_hands = 3, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.0, 0.6, 0.6)),
		list(mode_name="short bursts", 	burst=5, move_delay=6, fire_delay=null, requires_two_hands = 4, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/energy/lactera/a4
	name = "alien LMG"
	item_state = "alienrifle" //temporary
	icon_state = "alienlmg"
	projectile_type = /obj/item/projectile/beam/scom/alien1
	origin_tech = "combat=9;magnets=7;materials=6;engineering=4;powerstorage=6;"
	inertstate = /obj/item/scom/aliengun/a4
	max_shots = 16
	requires_two_hands = 6

	firemodes = list(
		list(mode_name="short bursts",	burst=8, fire_delay=null, move_delay=8, requires_two_hands = 8, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(0.6, 1.0, 1.2, 1.4, 1.4)),
		list(mode_name="long bursts",	burst=16, fire_delay=null, move_delay=10, requires_two_hands = 9, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.2, 1.2, 1.2, 1.4, 1.4)),
		)

/obj/item/weapon/gun/energy/lactera/attack_hand(mob/user)
	var/mob/living/carbon/human/M = user
	if(!istype(M, /mob/living/carbon/human/lactera))
//	if(M.species != "Xenomorph")
		M << "<span class='warning'>The alien gun turns inert when you touch it.</span>"
		new inertstate(src.loc)
		qdel(src)

	else
		..()

/obj/item/weapon/gun/energy/lactera/verb_pickup()
	var/mob/living/carbon/human/M = usr
	if(!istype(M, /mob/living/carbon/human/lactera))
//	if(M.species != /datum/species/xenos/lactera)
		M << "<span class='warning'>The alien gun turns inert when you touch it.</span>"
		new inertstate(src.loc)
		qdel(src)

	else
		..()

/obj/item/weapon/grenade/aliengrenade
	desc = "An explosive of unknown origin used by Lactera soldiers to sow destruction and chaos."
	name = "alien grenade"
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "aliengrenade"
	item_state = "flashbang"
	origin_tech = "materials=5;magnets=5"

/obj/item/weapon/grenade/aliengrenade/detonate()
	explosion(src.loc, 0, 0, 3, 3)
	qdel(src)

/obj/item/weapon/plastique/alienexplosive
	name = "alien explosives"
	desc = "Used by Lactera soldiers to put holes in specific areas without too much extra hole."
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "plastic-explosive0"
	item_state = "device"

/obj/item/weapon/plastique/alienexplosive/explode(var/location)
	if(!target)
		target = get_atom_on_turf(src)
	if(!target)
		target = src
	if(location)
		explosion(location, -1, -1, 2, 3)

	if(target)
		if (istype(target, /turf/simulated/wall))
			var/turf/simulated/wall/W = target
			W.dismantle_wall(1)
		else if (istype(target, /turf/simulated/floor))
			target.ex_act(3) //no destroying floors for the shitter aliums
		else if(istype(target, /mob/living))
			target.ex_act(2) // c4 can't gib mobs anymore.
		else
			target.ex_act(1)
	if(target)
		target.overlays -= image_overlay
	qdel(src)

/obj/item/weapon/plastique/alienexplosive/attackby(var/obj/item/I, var/mob/user)
	return

/obj/item/clothing/under/lactera
	name = "lactera hide"
	desc = "the hide of the lactera soldiers, genetically modified to be resistent to any threats."
	icon = 'icons/uristmob/scommobs.dmi'
	icon_state = "lactera_under"
	icon_override = 'icons/uristmob/scommobs.dmi'
	item_state = "lactera_under"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS
	armor = list(melee = 5, bullet = 0, laser = 0, energy = 0, bomb = 5, bio = 80, rad = 60)
	species_restricted = list("Xenomorph")

/obj/item/clothing/under/lactera/MouseDrop(obj/over_object as obj)
	return

/obj/item/clothing/shoes/magboots/lactera
	name = "lactera mag claws"
	desc = "the claws of the lactera soldiers, implanted with a mag traction locking system."
	icon = 'icons/uristmob/r_lactera.dmi'
	icon_state = "lactera_shoes"
	icon_override = 'icons/uristmob/scommobs.dmi'
	item_state = "lactera_shoes"
	armor = list(melee = 5, bullet = 0, laser = 0, energy = 0, bomb = 5, bio = 80, rad = 60)
	species_restricted = list("Xenomorph")

/obj/item/clothing/shoes/magboots/lactera/attack_hand(mob/user as mob)
	return

/obj/item/clothing/suit/lactera
	icon = 'icons/uristmob/scommobs.dmi'
	icon_override = 'icons/uristmob/r_lactera.dmi'
	species_restricted = list("Xenomorph")
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/grenade,/obj/item/weapon/plastique)

/obj/item/clothing/suit/lactera/regular
	name = "lactera armoured vest"
	desc = "An armoured vest worn by lactera soldiers made out of unknown materials. Fairly resistant, but doesn't give good coverage."
	icon_state = "bulletproof"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 25, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/suit/lactera/officer
	name = "lactera officer's armour"
	desc = "An armoured suit worn by lactera officers made out of unknown materials. Fairly resistant, and gives good coverage."
	icon_state = "officerarmour"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 60, bullet = 50, laser = 50, energy = 25, bomb = 30, bio = 0, rad = 0)

//human

/obj/item/weapon/grenade/frag/anforgrenade
	desc = "A small explosive meant for anti-personnel use."
	name = "ANFOR grenade"
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "large_grenade"
	item_state = "flashbang"
	origin_tech = "materials=3;magnets=3"

///obj/item/weapon/grenade/anforgrenade/detonate()
//	explosion(src.loc, 0, 0, 2, 2)
//	qdel(src)

/obj/item/weapon/storage/box/anforgrenade
	name = "box of frag grenades (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause cause death within a short radius.</B>"
	icon_state = "flashbang"
	startswith = list(/obj/item/weapon/grenade/frag/anforgrenade = 5)

/obj/item/weapon/mine/frag
	name = "frag mine"
	desc = "A frag mine. Press the button to set it up and move the fuck away."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "uglymine" //should probably ask olly or nien for a better sprite

/obj/item/weapon/mine/attack_self(mob/user as mob)
	var/obj/effect/mine/frag/M = new /obj/effect/mine/frag(user.loc)
	M.overlays += image('icons/urist/jungle/turfs.dmi', "exclamation", layer=3.1)
	user.visible_message("<span class='warning'>[user] arms the mine! Be careful not to step on it!</span>","<span_class='warning'>You arm the mine and lay it on the floor. Be careful not to step on it!</span>")
	qdel(src)
	user.regenerate_icons()
	spawn(35)
		M.overlays -= image('icons/urist/jungle/turfs.dmi', "exclamation", layer=3.1)

/obj/item/weapon/storage/box/mines
	name = "box of frag mines (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause death within a short radius.</B>"
	icon_state = "flashbang"
	startswith = list(/obj/item/weapon/mine/frag = 3)

/obj/item/weapon/storage/box/mines/New()
	..()
	make_exact_fit()

/obj/effect/mine/proc/explode2(obj)
	/* oldcode, pre-fragification -scr
	explosion(loc, 0, 0, 2, 2)
	spawn(1)
		qdel(src)*/
	//vars stolen for fragification
	var/fragment_type = /obj/item/projectile/bullet/pellet/fragment
	var/num_fragments = 72  //total number of fragments produced by the grenade
	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7 //leave as is, for some reason setting this higher makes the spread pattern have gaps close to the epicenter

	//blatant copypaste from frags, but those are a whole different type so vOv
	set waitfor = 0
	..()

	var/turf/O = get_turf(src)
	if(!O) return

	var/list/target_turfs = getcircle(O, spread_range)
	var/fragments_per_projectile = round(num_fragments/target_turfs.len)

	for(var/turf/T in target_turfs)
		sleep(0)
		var/obj/item/projectile/bullet/pellet/fragment/P = new fragment_type(O)

		P.pellets = fragments_per_projectile
		P.shot_from = src.name

		P.launch(T)

		//Make sure to hit any mobs in the source turf
		for(var/mob/living/M in O)
			//lying on a frag grenade while the grenade is on the ground causes you to absorb most of the shrapnel.
			//you will most likely be dead, but others nearby will be spared the fragments that hit you instead.
			if(M.lying && isturf(src.loc))
				P.attack_mob(M, 0, 0)
			else
				P.attack_mob(M, 0, 100) //otherwise, allow a decent amount of fragments to pass

	qdel(src)

/obj/effect/mine/frag
	name = "Frag Mine"
	triggerproc = "explode2"

/obj/effect/mine/frag/attack_hand(mob/user as mob)
	user.visible_message("<span class='warning'>[user] starts to disarm the mine!</span>","<span_class='warning'>You start to disarm the mine. Just stay very still.</span>")
	if (do_after(user, 30, src))
		user.visible_message("<span class='warning'>[user] disarms the mine!</span>","<span_class='warning'>You disarm the mine. It's safe to pick up now!</span>")
		new /obj/item/weapon/mine/frag(src.loc)
		qdel(src)

/obj/structure/assaultshieldgen
	name = "shield generator"
	desc = "The shield generator for the station. Protect it with your life. Repair it with a welding torch."
	icon = 'icons/obj/power.dmi'
	icon_state = "bbox_on"
	var/health = 300
	var/maxhealth = 300
	anchored = 1
	density = 1

/obj/structure/assaultshieldgen/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if (WT.remove_fuel(0,user))
			if(health >= maxhealth)
				user << "<span class='warning'>The shield generator is fully repaired alredy!</span>"
			else
				playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
				user.visible_message("[user.name] starts to patch some dents on the shield generator.", \
					"You start to patch some dents on the shield generator", \
					"You hear welding")
				if (do_after(user,20))
					if(!src || !WT.isOn()) return
					health += 10

		else
			user << "<span class='warning'>You need more welding fuel to complete this task.</span>"

	else
		switch(W.damtype)
			if("fire")
				src.health -= W.force * 1
			if("brute")
				src.health -= W.force * 0.50
			else
		if (src.health <= 0)
			visible_message("<span class='danger'>The shield generator is smashed apart!</span>")
			kaboom()
			return
		..()

/obj/structure/assaultshieldgen/ex_act(severity)
	switch(severity)
		if(1.0)
			kaboom()
			return
		if(2.0)
			if(prob(75))
				kaboom()
				return
			else
				health -= 150
		if(3.0)
			if(prob(5))
				kaboom()
				return
			else
				health -= 50

	if(src.health <=0)
		visible_message("<span class='danger'>The shield generator is smashed apart!</span>")
		qdel(src)

	return

/obj/structure/assaultshieldgen/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage

	if(health <= 0)
		kaboom()

	..()

/obj/structure/assaultshieldgen/proc/kaboom()
	remaininggens -= 1
	qdel(src)