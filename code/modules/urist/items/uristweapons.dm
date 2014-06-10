/*										*****New space to put all UristMcStation Weapons*****

Please keep it tidy, by which I mean put comments describing the item before the entry. Icons go to 'icons/urist/items/uristweapons.dmi' -Glloyd */


//Welder machete, icons by ShoesandHats, object by Cozarctan

/obj/item/weapon/machete
	urist_only = 1
	name = "machete"
	desc = "a large blade beloved by sugar farmers and mass murderers"
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "machete"
	item_state = "machete"
	sharp = 1
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	force = 20
	throwforce = 10
	w_class = 3
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("cleaved", "slashed", "sliced", "torn", "ripped", "diced", "cut")

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return(BRUTELOSS)

/obj/item/weapon/machete/IsShield()
		return 1

//Energy pistol, Energy gun with less shots. Can be put in player's pockets.

/obj/item/weapon/gun/energy/gun/small
	urist_only = 1
	name = "energy pistol"
	desc = "An energy pistol with a wooden handle."
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "senergystun100"
	item_state = "gun"
	fire_sound = 'sound/weapons/Taser.ogg'
	w_class = 1
	charge_cost = 150 //How much energy is needed to fire.
	projectile_type = "/obj/item/projectile/energy/electrode"
	origin_tech = "combat=2;magnets=2"
	modifystate = "senergystun"

	mode = 0 //0 = stun, 1 = kill


	attack_self(mob/living/user as mob)
		switch(mode)
			if(0)
				mode = 1
				charge_cost = 150
				fire_sound = 'sound/weapons/Laser.ogg'
				user << "\red [src.name] is now set to kill."
				projectile_type = "/obj/item/projectile/beam"
				modifystate = "senergykill"
			if(1)
				mode = 0
				charge_cost = 150
				fire_sound = 'sound/weapons/Taser.ogg'
				user << "\red [src.name] is now set to stun."
				projectile_type = "/obj/item/projectile/energy/electrode"
				modifystate = "senergystun"
		update_icon()

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is unloading the [src.name] into their head!</b>"
		return(BRUTELOSS)

//Space drugs pill. LET'S PARTY!

/obj/item/weapon/reagent_containers/pill/spacedrugs
	name = "happy pill"
	desc = "Ready to party?"
	icon_state = "pill20"
	New()
		..()
		reagents.add_reagent("space_drugs", 50)

/*plasma pistol. does toxic damage. I want to add this to research soonish. icons by Susan from BS12, editing and projectile by Glloyd
--Okay, they implemented this on BS12, and I dislike how they did it. The top is green, and shoots a green pulse. It also has different values then the one I coded.
The point is that theirs is closer to the X-COM plasma pistol, despite the fact that all depictions of plasma in SS13 are purple, thus my choice to edit
the sprite and make my own projectile -Glloyd*/

/obj/item/weapon/gun/energy/plasmapistol
	urist_only = 1
	name = "phoron pistol"
	desc = "An experimental weapon that works by ionizing phoron and firing it in a particular direction, poisoning someone."
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "plasmapistol"
	item_state = "gun"
	fire_sound = 'sound/weapons/Genhit.ogg'
	w_class = 1
	charge_cost = 150 //How much energy is needed to fire.
	projectile_type = "/obj/item/projectile/energy/plasma2"
	origin_tech = "combat=3;magnets=2"
	modifystate = "plasmapistol"
	cell_type = "/obj/item/weapon/cell/crap"

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is unloading the [src.name] into their head! Their skin turns purple and starts to melt!</b>"
		return(BRUTELOSS)

/obj/item/projectile/energy/plasma2
	name = "ionized phoron"
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "plasma"
	damage = 20
	damage_type = TOX
	irradiate = 20

//Sniper rifle, from BS12. Those guys used spaces instead of tabs. What the actual fuck.

/*/obj/item/weapon/gun/energy/sniperrifle
	urist_only = 1
	name = "L.W.A.P. Sniper Rifle"
	desc = "A rifle constructed of lightweight materials, fitted with a SMART aiming-system scope."
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "sniper"
	fire_sound = 'sound/weapons/marauder.ogg'
	origin_tech = "combat=6;materials=5;powerstorage=4"
	projectile_type = "/obj/item/projectile/beam/sniper"
	slot_flags = SLOT_BACK
	charge_cost = 250
	w_class = 4.0

	var/zoom = 0

/obj/item/weapon/gun/energy/sniperrifle/dropped(mob/user)
	user.client.view = world.view
	zoom = 0

/obj/item/weapon/gun/energy/sniperrifle/verb/zoom()
	set category = "Special Verbs"
	set name = "Zoom"
	set popup_menu = 0
	if(usr.stat || !(istype(usr,/mob/living/carbon/human)))
		usr << "No."
	return

	src.zoom = !src.zoom
	usr << ("<font color='[src.zoom?"blue":"red"]'>Zoom mode [zoom?"en":"dis"]abled.</font>")
	if(zoom)
		usr.client.view = 12
		usr << sound('sound/mecha/imag_enh.ogg',volume=50)
	else
		usr.client.view = world.view//world.view - default mob view size
	return

/obj/item/projectile/beam/sniper
	name = "sniper beam"
	icon_state = "xray"
	damage = 60
	stun = 5
	weaken = 5
	stutter = 5*/

//Syndie mini-bomb from /tg/

/obj/item/weapon/grenade/syndieminibomb
	desc = "A syndicate manufactured explosive used to sow destruction and chaos"
	name = "syndicate minibomb"
	icon = 'icons/urist/items/tgitems.dmi'
	icon_state = "syndicate"
	item_state = "flashbang"
	origin_tech = "materials=3;magnets=4;syndicate=4"

/obj/item/weapon/grenade/syndieminibomb/prime()
	explosion(src.loc, 1, 2, 4, 4)
	del(src)

//dual saber proc

/obj/item/weapon/melee/energy/sword/attackby(obj/item/weapon/W, mob/living/user)
	..()
	if(istype(W, /obj/item/weapon/melee/energy/sword))
		if(W == src)
			user << "<span class='notice'>You try to attach the end of the energy sword to... itself. You're not very smart, are you?</span>"
			if(ishuman(user))
				user.adjustBrainLoss(10)
		else
			user << "<span class='notice'>You attach the ends of the two energy swords, making a single double-bladed weapon! You're cool.</span>"
			new /obj/item/weapon/twohanded/dualsaber(user.loc)
			user.before_take_item(W)
			user.before_take_item(src)
			del(W)
			del(src)