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
	flags = CONDUCT
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

	firemodes = list(
		list(name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="energystun", fire_sound='sound/weapons/Taser.ogg'),
		list(name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="energykill", fire_sound='sound/weapons/Laser.ogg'),
		)

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is unloading the [src.name] into their head!</b>"
		return(BRUTELOSS)

//umbrella gun

/obj/item/weapon/gun/projectile/umbrellagun
	urist_only = 1
	name = "Umbrella"
	desc = "An umbrella with a small hole at the end, doesn't seem to open."
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "umbrellagun"
	item_state = "umbrellagun"
	w_class = 2
	max_shells = 2
	caliber = "9mm"
	silenced = 1
	origin_tech = "combat=2;materials=2"
	ammo_type = "/obj/item/ammo_casing/c9mm"
	load_method = 2

//BANG BANG BANG, BANG BANG

/obj/item/weapon/gag/BANG
	urist_only = 1
	icon_override = 'icons/urist/items/uristweapons.dmi'
	icon = 'icons/urist/items/uristweapons.dmi'
	name = "BANG gun"
	desc = "Shoots out a BANG"
	icon_state = "gun"
	item_state = "gun"
	var/on = 0
	w_class = 2

/obj/item/weapon/gag/BANG/attack_self(mob/user as mob)
	urist_only = 1
	icon_override = 'icons/urist/items/uristweapons.dmi'
	icon = 'icons/urist/items/uristweapons.dmi'
	on = !on
	if(on)
		user.visible_message("\red [user] fires the gun, BANG.",\
		"\red You fire the gun.",\
		"You hear a BANG.")
		icon_state = "gunbang"
		item_state = "gunbang"
		w_class = 2
		force = 3
		attack_verb = list("smacked", "struck", "slapped")
	else
		user.visible_message("\blue [user] pushes the BANG back into the barrel.",\
		"\blue You push the BANG back into the barrel.",\
		"You hear a click.")
		icon_state = "gun"
		item_state = "gun"
		w_class = 2
		force = 3
		attack_verb = list("smacked", "struck", "slapped")

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

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
			new /obj/item/weapon/material/twohanded/dualsaber(user.loc)
			user.remove_from_mob(W)
			user.remove_from_mob(src)
			del(W)
			del(src)

//Knight .45 - suppressed PDW

/obj/item/weapon/gun/projectile/silenced/knight
	name = "Knight .45"
	desc = "A lightweight, suppressed weapon. Uses .45 rounds and is intended for operations where subtlety is preferred, if only for a little while."
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "knight45"
	fire_sound = 'sound/urist/suppshot.ogg'
	w_class = 2
	max_shells = 7
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	caliber = ".45"
	ammo_type = /obj/item/ammo_casing/c45
	magazine_type = /obj/item/ammo_magazine/c45m
	auto_eject = 1

/obj/item/weapon/gun/projectile/silenced/knight/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "knight45"
	else
		icon_state = "knight45-empty"

///// Deckard .44 - old Bay custom item rip for UMcS Blueshields
/obj/item/weapon/gun/projectile/revolver/detective/deckard
	name = "Deckard .38" //changed from .44 for internal consistency - it takes .38 bullets
	desc = "A custom autorevolver chambered in .38 Special issued to high-ranking specialists, based on the obsoleted Detective Special forensics issue models. For some reason, the caliber feels like it should be bigger..."
	icon = 'icons/urist/items/old_bay_custom_items.dmi'
	icon_state = "leamas-empty"

/obj/item/weapon/gun/projectile/revolver/detective/deckard/update_icon()
	..()
	if(loaded.len)
		icon_state = "leamas-loaded"
	else
		icon_state = "leamas-empty"

/obj/item/weapon/gun/projectile/revolver/detective/deckard/load_ammo(var/obj/item/A, mob/user)
	if(istype(A, /obj/item/ammo_magazine))
		flick("leamas-reloading",src)
	..()