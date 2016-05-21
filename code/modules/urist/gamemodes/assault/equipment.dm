//alien

/obj/machinery/computer/shuttle_control/assault
	var/readytogo = 0

/obj/machinery/computer/shuttle_control/assault/attack_hand(mob/user)
	if(!readytogo)
		user << "<span class='warning'>The shuttles will be ready to launch shortly.</span>"
		return
	else
		..()

/obj/machinery/computer/shuttle_control/assault/alien1
	name = "alien shuttle console (Shuttle 1)"
	shuttle_tag = "Assault1"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cellconsole"

/obj/machinery/computer/shuttle_control/assault/alien2
	name = "alien shuttle console (Shuttle 2)"
	shuttle_tag = "Assault2"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cellconsole"

/obj/item/weapon/gun/energy/lactera
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
	var/inertstate = /obj/item/scom/aliengun

/obj/item/weapon/gun/energy/lactera/update_icon()
	..()
	item_state = initial(item_state)

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

/obj/item/weapon/gun/energy/lactera/a3
	name = "alien rifle"
	item_state = "alienrifle"
	icon_state = "alienrifle"
	projectile_type = /obj/item/projectile/beam/scom/alien1
	origin_tech = "combat=8;magnets=6;materials=5;engineering=3;powerstorage=5;"
	inertstate = /obj/item/scom/aliengun/a3


	firemodes = list(
		list(name="semiauto", burst=1, fire_delay=0),
		list(name="3-round bursts", burst=3, move_delay=6, accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.0, 0.6, 0.6)),
		list(name="short bursts", 	burst=5, move_delay=6, accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
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

/obj/item/weapon/grenade/aliengrenade/prime()
	explosion(src.loc, 0, 0, 3, 3)
	qdel(src)

/obj/item/weapon/plastique/alienexplosive
	name = "alien explosives"
	desc = "Used by Lactera soldiers to put holes in specific areas without too much extra hole."
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "plastic-explosive0"
	item_state = "device"


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

/obj/item/weapon/grenade/anforgrenade
	desc = "A small explosive meant for anti-personnel use."
	name = "ANFOR grenade"
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "large_grenade"
	item_state = "flashbang"
	origin_tech = "materials=3;magnets=3"

/obj/item/weapon/grenade/anforgrenade/prime()
	explosion(src.loc, 0, 0, 2, 2)
	qdel(src)

/obj/item/weapon/storage/box/anforgrenade
	name = "box of frag grenades (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause cause death within a short radius.</B>"
	icon_state = "flashbang"

/obj/item/weapon/storage/box/anforgrenade/New()
	..()
	new /obj/item/weapon/grenade/anforgrenade( src )
	new /obj/item/weapon/grenade/anforgrenade( src )
	new /obj/item/weapon/grenade/anforgrenade( src )
	new /obj/item/weapon/grenade/anforgrenade( src )
	new /obj/item/weapon/grenade/anforgrenade( src )

/obj/item/weapon/mine/frag
	name = "frag mine"
	desc = "A frag mine. Press the button to set it up and move the fuck away."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "uglymine" //should probably ask olly or nien for a better sprite

/obj/item/weapon/mine/attack_self(mob/user as mob)
	new /obj/effect/mine/frag(user.loc)
	user.visible_message("<span class='warning'>[user] arms the mine! Be careful not to step on it!</span>","<span_class='warning'>You arm the mine and lay it on the floor. Be careful not to step on it!</span>")
	qdel(src)
	user.regenerate_icons()

/obj/item/weapon/storage/box/mines
	name = "box of frag mines (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause death within a short radius.</B>"
	icon_state = "flashbang"

/obj/item/weapon/storage/box/mines/New()
	..()
	new /obj/item/weapon/mine/frag( src )
	new /obj/item/weapon/mine/frag( src )
	new /obj/item/weapon/mine/frag( src )
	new /obj/item/weapon/mine/frag( src )

/obj/effect/mine/proc/explode2(obj)
	explosion(loc, 0, 0, 2, 2)
	spawn(1)
		qdel(src)

/obj/effect/mine/frag
	name = "Frag Mine"
	triggerproc = "explode2"

/obj/effect/mine/frag/attack_hand(mob/user as mob)
	user.visible_message("<span class='warning'>[user] disarms the mine!</span>","<span_class='warning'>You disarm the mine. It's safe to pick up now!</span>")
	new /obj/item/weapon/mine/frag(src.loc)
	qdel(src)

/obj/structure/assaultshieldgen
	name = "shield generator"
	desc = "The shield generator for the station. Protect it with your life."
//	icon = 'icons/urist/structures&machinery/scomscience.dmi'
//	icon_state = "norm2"
	icon = 'icons/obj/power.dmi'
	icon_state = "bbox_on"
	var/remaininggens = 4
	var/health = 200
	var/maxhealth = 200
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
			qdel(src)
			return
		if(2.0)
			if(prob(75))
				kaboom()
				return
			else
				health -= 150
		if(3.0)
			if(prob(25))
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
	for(var/obj/structure/assaultshieldgen/S in world)
		remaininggens -= 1

	if(remaininggens == 0)
		gamemode_endstate = 3

	qdel(src)