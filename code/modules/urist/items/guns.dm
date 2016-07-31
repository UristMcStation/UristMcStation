//Energy pistol, Energy gun with less shots. Can be put in player's pockets.

/obj/item/weapon/gun/energy/gun/small
	urist_only = 1
	name = "energy pistol"
	desc = "An energy pistol with a wooden handle."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "senergy"
	item_state = "gun"
	fire_sound = 'sound/weapons/Taser.ogg'
	w_class = 1
	charge_cost = 150 //How much energy is needed to fire.
	projectile_type = /obj/item/projectile/energy/electrode
	origin_tech = "combat=2;magnets=2"
	modifystate = "senergystun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="senergystun", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="senergykill", fire_sound='sound/weapons/Laser.ogg'),
		)

	/*suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is unloading the [src.name] into their head!</b>"
		return(BRUTELOSS)*/

//umbrella gun

/obj/item/weapon/gun/projectile/umbrellagun
	urist_only = 1
	name = "Umbrella"
	desc = "An umbrella with a small hole at the end, doesn't seem to open."
	icon = 'icons/urist/items/guns.dmi'
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
	icon_override = 'icons/urist/items/guns.dmi'
	icon = 'icons/urist/items/guns.dmi'
	name = "BANG gun"
	desc = "Shoots out a BANG"
	icon_state = "gun"
	item_state = "gun"
	var/on = 0
	w_class = 2

/obj/item/weapon/gag/BANG/attack_self(mob/user as mob)
	urist_only = 1
	icon_override = 'icons/urist/items/guns.dmi'
	icon = 'icons/urist/items/guns.dmi'
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
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "plasmapistol"
	item_state = "gun"
	fire_sound = 'sound/weapons/Genhit.ogg'
	w_class = 1
	charge_cost = 150 //How much energy is needed to fire.
	projectile_type = /obj/item/projectile/energy/plasma2
	origin_tech = "combat=3;magnets=2"
	modifystate = "plasmapistol"
	cell_type = "/obj/item/weapon/cell/crap"

/*	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is unloading the [src.name] into their head! Their skin turns purple and starts to melt!</b>"
		return(BRUTELOSS)*/

/obj/item/projectile/energy/plasma2
	name = "ionized phoron"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "plasma"
	damage = 20
	damage_type = TOX
	irradiate = 20

//Knight .45 - suppressed PDW

/obj/item/weapon/gun/projectile/silenced/knight
	name = "Knight .45"
	desc = "A lightweight, suppressed weapon. Uses .45 rounds and is intended for operations where subtlety is preferred, if only for a little while."
	icon = 'icons/urist/items/guns.dmi'
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
	//what do you know, it was restored-ish in revolver.dm
	icon_state = "deckard-empty"

/obj/item/weapon/gun/projectile/revolver/detective/deckard/update_icon()
	..()
	if(loaded.len)
		icon_state = "deckard-loaded"
	else
		icon_state = "deckard-empty"

/obj/item/weapon/gun/projectile/revolver/detective/deckard/load_ammo(var/obj/item/A, mob/user)
	if(istype(A, /obj/item/ammo_magazine))
		flick("deckard-reloading",src)
	..()

//NamERT

/obj/item/weapon/gun/projectile/automatic/l6_saw/m60
	name = "M60 Machinegun"
	desc = "The general-purpose machinegun and the main firearm for the Machinegunner. Chambered in 7.62mm , it is fed through a 75-round belt. Fires in short and long bursts, perfect for support and suppresive fire."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "M60closed75"
	item_state = "l6closedmag"
	max_shells = 75
	magazine_type = /obj/item/ammo_magazine/a762/m60

/obj/item/weapon/gun/projectile/automatic/l6_saw/m60/update_icon()
	icon_state = "M60[cover_open ? "open" : "closed"][ammo_magazine ? round(ammo_magazine.stored_ammo.len, 15) : "-empty"]"

/obj/item/ammo_magazine/a762/m60
	name = "M60 magazine box (7.62mm)"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "M60MAG"
	max_ammo = 75
	multiple_sprites = 0

/obj/item/ammo_magazine/a762/m60/empty
	initial_ammo = 0

/obj/item/weapon/gun/projectile/automatic/m14
	name = "\improper M14 Rifle"
	desc = "A selective-fire rifle for when you need more stopping power. Has a 15-round magazine of 7.62mm. Unlike the M16s that have the ability to fire in bursts or semi-auto, the M14 can only fire in either long bursts or semi-auto."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "M14"
	item_state = "arifle"
	w_class = 4
	force = 10
	caliber = "a762"
	origin_tech = "combat=6;materials=1;syndicate=2"
	slot_flags = SLOT_BACK
	ammo_type = "/obj/item/ammo_casing/a762"
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a762/m14

/obj/item/weapon/gun/projectile/automatic/m14/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "M14"
	else
		icon_state = "M14-empty"
	return

/obj/item/ammo_magazine/a762/m14
	name = "M14 magazine box (7.62mm)"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "M14MAG"
	max_ammo = 15

/obj/item/ammo_magazine/a762/m14/empty
	initial_ammo = 0

/obj/item/weapon/gun/projectile/automatic/m16
	name = "\improper M16 Assault Rifle"
	desc = "25 rounds of 5.56mm. Staple rifle for the Nanotrasen Servicemen. A 2557AD spin on the classic rifle."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "M16"
	item_state = "arifle"
	w_class = 4
	force = 10
	caliber = "a556"
	origin_tech = "combat=6;materials=1;syndicate=4"
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a556/m16

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0),
		list(mode_name="3-round bursts", burst=3, move_delay=6, accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.0, 0.6, 0.6)),
		list(mode_name="short bursts", 	burst=5, move_delay=6, accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/projectile/automatic/m16/update_icon()
	..()
	if(icon_state == "M16-GL")
		icon_state = (ammo_magazine)? "M16-GL" : "M16-GL-empty"
	else
		icon_state = (ammo_magazine)? "M16" : "M16-empty"
	update_held_icon()

/obj/item/weapon/gun/projectile/automatic/m16/gl
	name = "\improper M16-GL Assault Rifle"
	desc = "25 rounds of 5.56mm. Staple rifle for the Nanotrasen Servicemen. A 2557AD spin on the classic rifle, complete with underslung grenade launcher."
	icon_state = "M16-GL"

	firemode_type = /datum/firemode/z8
	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0),
		list(mode_name="3-round bursts", burst=3, move_delay=6, accuracy = list(0,-1,-1), dispersion = list(0.0, 0.6, 0.6)),
		list(mode_name="fire grenades", use_launcher=1)
		)

	var/obj/item/weapon/gun/launcher/grenade/underslung/launcher

/obj/item/weapon/gun/projectile/automatic/m16/gl/New()
	..()
	launcher = new(src)

/obj/item/weapon/gun/projectile/automatic/m16/gl/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/weapon/grenade)))
		launcher.load(I, user)
	else
		..()

/obj/item/weapon/gun/projectile/automatic/m16/gl/attack_hand(mob/user)
	var/datum/firemode/z8/current_mode = firemodes[sel_mode]
	if(user.get_inactive_hand() == src && current_mode.use_launcher)
		launcher.unload(user)
	else
		..()

/obj/item/weapon/gun/projectile/automatic/m16/gl/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0)
	var/datum/firemode/z8/current_mode = firemodes[sel_mode]
	if(current_mode.use_launcher)
		launcher.Fire(target, user, params, pointblank, reflex)
		if(!launcher.chambered)
			switch_firemodes() //switch back automatically
	else
		..()

/obj/item/weapon/gun/projectile/automatic/m16/gl/examine(mob/user)
	..()
	if(launcher.chambered)
		user << "\The [launcher] has \a [launcher.chambered] loaded."
	else
		user << "\The [launcher] is empty."

/obj/item/ammo_magazine/a556/m16
	name = "M16 magazine (5.56mm)"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "M16MAG"
	max_ammo = 25

/obj/item/ammo_magazine/a556/m16/empty
	initial_ammo = 0

/obj/item/weapon/gun/projectile/shotgun/pump/combat/ithaca
	name = "Ithaca 37 combat shotgun"
	desc = "A standard Nanotrasen combat shotgun. Holds 7 rounds (8 with one in the chamber). Pump-action, it's perfect for CQB and tight hallway clearing."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "ithaca"

/obj/item/weapon/gun/projectile/automatic/m3
	name = "M3 Grease Gun"
	desc = "The submachine gun for medical personnel and infantrymen. Only fires in short and long bursts. Takes magazines of 32 .45 rounds."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "M3"
	item_state = "arifle"
	w_class = 3
	force = 10
	caliber = ".45"
	origin_tech = "combat=6;materials=1;syndicate=4"
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c45m/m3
	firemodes = list(
		list(mode_name="short bursts",	burst=4, move_delay=6, accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	burst=8, move_delay=8, accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/projectile/automatic/m3/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "M3"
	else
		icon_state = "M3-empty"
	return

/obj/item/ammo_magazine/c45m/m3
	name = "M3 magazine (.45)"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "M3MAG"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c45
	matter = list(DEFAULT_WALL_MATERIAL = 525) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = ".45"
	max_ammo = 32

/obj/item/ammo_magazine/c45m/m3/empty
	initial_ammo = 0

/obj/item/weapon/gun/projectile/bhp9mm
	name = "\improper Browning HP pistol"
	desc = "The NCO's sidearm. 15 rounds of 9mm. Less power than a .45, but almost double the capacity. May be issued to medical units as well."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "brownhp"
	item_state = "gun"
	w_class = 2
	caliber = "9mm"
	origin_tech = "combat=2;materials=2;syndicate=2"
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mc9mm/bhp

/obj/item/weapon/gun/projectile/bhp9mm/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "brownhp"
	else
		icon_state = "brownhp-empty"
	return

/obj/item/ammo_magazine/mc9mm/bhp
	icon = 'icons/urist/items/guns.dmi'
	name = "Browning HP magazine (9mm)"
	icon_state = "BROWNHPMAG"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 15

/obj/item/ammo_magazine/mc9mm/bhp/empty
	initial_ammo = 0