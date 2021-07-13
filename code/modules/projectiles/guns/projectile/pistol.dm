/obj/item/weapon/gun/projectile/colt
	name = "vintage .45 pistol"
	desc = "A cheap Martian knock-off of a Colt M1911. Uses .45 rounds."
	item_icons = URIST_ALL_ONMOBS
	magazine_type = /obj/item/ammo_magazine/c45m
	allowed_magazines = /obj/item/ammo_magazine/c45m
	icon = 'icons/urist/items/pistols.dmi'
	item_state = "colt"
	icon_state = "colt"
	wielded_item_state = "colt"
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	load_method = MAGAZINE
	accuracy_power = 7
	var/empty_icon = TRUE  //If it should change icon when empty

/obj/item/weapon/gun/projectile/colt/on_update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-e"

/obj/item/weapon/gun/projectile/military
	name = "military .45 pistol"
	desc = "The WT45 - a mass produced kinetic sidearm in widespread service with the SCGDF. Uses .45 rounds."
	magazine_type = /obj/item/ammo_magazine/c45mds/flash
	allowed_magazines = /obj/item/ammo_magazine/c45mds
	icon = 'icons/obj/guns/military_pistol.dmi'
	icon_state = "military"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	load_method = MAGAZINE
	accuracy = 0.35
	fire_delay = 6.5

/obj/item/weapon/gun/projectile/pistol/military/alt
	desc = "The HelTek Optimus, best known as the standard-issue sidearm for the ICCG Navy."
	icon = 'icons/obj/guns/military_pistol2.dmi'
	icon_state = "military-alt"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	fire_delay = 8
/obj/item/weapon/gun/projectile/military/on_update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "usp"
	else
		icon_state = "usp-e"

/obj/item/weapon/gun/projectile/sec
	name = ".45 pistol"
	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, produced by a NanoTrasen subsidiary. Found pretty much everywhere humans are. Uses .45 rounds."
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/pistols.dmi'
	icon_state = "secguncomp"
	item_state = "secguncomp"
	wielded_item_state = "secguncomp"
	magazine_type = /obj/item/ammo_magazine/c45m/flash
	allowed_magazines = /obj/item/ammo_magazine/c45m
	caliber = ".45"
	accuracy = -1
	fire_delay = 5
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	load_method = MAGAZINE

/obj/item/weapon/gun/projectile/sec/on_update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "secguncomp"
	else
		icon_state = "secguncomp-e"

/obj/item/weapon/gun/projectile/sec/flash
	name = ".45 signal pistol"

/obj/item/weapon/gun/projectile/sec/wood
	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, produced by a NanoTrasen subsidiary. This one has a sweet wooden grip, among other modifications. Uses .45 rounds."
	name = "custom .45 Pistol"
	icon = 'icons/urist/items/pistols.dmi'
	icon_state = "secgundark"
	item_state = "secgundark"
	wielded_item_state = "secgundark"
	accuracy = 0

/obj/item/weapon/gun/projectile/sec/wood/on_update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "secgundark"
	else
		icon_state = "secgundark-e"

/obj/item/weapon/gun/projectile/sec/wood/lethal
	magazine_type = /obj/item/ammo_magazine/c45m

/obj/item/weapon/gun/projectile/silenced
	name = "silenced pistol"
	desc = "A handgun with an integral silencer. Uses .45 rounds."
	icon = 'icons/urist/items/pistols.dmi'
	icon_state = "silenced_pistol"
	item_icons = URIST_ALL_ONMOBS
	item_state = "pistol-silencer"
	wielded_item_state = "pistol-silencer"
	w_class = ITEM_SIZE_NORMAL
	caliber = ".45"
	silenced = 1
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c45m
	allowed_magazines = /obj/item/ammo_magazine/c45m

/obj/item/weapon/gun/projectile/sigsauer
	name = "10mm pistol"
	desc = "The HelTek Optimus, best known as the standard-issue sidearm for the ICCG Navy. Uses 10mm rounds."
	magazine_type = /obj/item/ammo_magazine/p10mm
	allowed_magazines = /obj/item/ammo_magazine/p10mm
	icon_state = "p220"
	caliber = "10mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	load_method = MAGAZINE
	accuracy = 0.40
	fire_delay = 7.5

/obj/item/weapon/gun/projectile/sigsauer/on_update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "p220"
	else
		icon_state = "p220-e"

/obj/item/weapon/gun/projectile/magnum_pistol
	name = ".50 magnum pistol"
	desc = "The HelTek Magnus, a robust Terran handgun that uses .50 AE ammo."
	icon = 'icons/urist/items/pistols.dmi'
	icon_state = "magnum"
	item_state = "magnum"
	item_icons = URIST_ALL_ONMOBS
	wielded_item_state = "magnum"
	force = 9
	caliber = ".50"
	fire_delay = 12
	screen_shake = 2
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a50
	allowed_magazines = /obj/item/ammo_magazine/a50
	mag_insert_sound = 'sound/weapons/guns/interaction/hpistol_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/hpistol_magout.ogg'
	accuracy = 2
	one_hand_penalty = 2
	bulk = 3

/obj/item/weapon/gun/projectile/magnum_pistol/on_update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "magnum"
	else
		icon_state = "magnum-e"

/obj/item/weapon/gun/projectile/gyropistol
	name = "gyrojet pistol"
	desc = "A bulky pistol designed to fire self propelled rounds."
	icon = 'icons/urist/items/gyropistol.dmi'
	icon_state = "gyropistol"
	item_icons = URIST_ALL_ONMOBS
	wielded_item_state = "gyropistol"
	max_shells = 8
	caliber = "75"
	origin_tech = list(TECH_COMBAT = 3)
	ammo_type = /obj/item/ammo_casing/a75
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a75
	fire_delay = 25
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	mag_insert_sound = 'sound/weapons/guns/interaction/hpistol_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/hpistol_magout.ogg'

/obj/item/weapon/gun/projectile/gyropistol/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "gyropistolloaded"
	else
		icon_state = "gyropistol"

/obj/item/weapon/gun/projectile/beretta
	name = "9mm combat pistol"
	desc = "The Lumoco Arms P9 Brigadier. A robust sidearm designed for military duty. Uses 9mm rounds."
	magazine_type = /obj/item/ammo_magazine/mc9mmds
	allowed_magazines = /obj/item/ammo_magazine/mc9mmds
	icon_state = "92fs"
	item_icons = URIST_ALL_ONMOBS
	item_state = "92fs"
	wielded_item_state = "92fs"
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	load_method = MAGAZINE
	accuracy = 0.35

/obj/item/weapon/gun/projectile/beretta/on_update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "92fs"
	else
		icon_state = "92fs-e"

/obj/item/weapon/gun/projectile/pistol
	name = "holdout pistol"
	desc = "The Lumoco Arms P3 Whisper. A small, easily concealable gun. Uses 9mm rounds."
	icon = 'icons/urist/items/pistols.dmi'
	item_icons = URIST_ALL_ONMOBS
	icon_state = "pistol"
	item_state = "pistol"
	wielded_item_state = "pistol"
	w_class = ITEM_SIZE_SMALL
	caliber = "9mm"
	silenced = 0
	fire_delay = 1
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mc9mm
	allowed_magazines = /obj/item/ammo_magazine/mc9mm

/obj/item/weapon/gun/projectile/pistol/flash
	name = "holdout signal pistol"
	magazine_type = /obj/item/ammo_magazine/mc9mm/flash

/obj/item/weapon/gun/projectile/pistol/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(silenced)
			if(user.l_hand != src && user.r_hand != src)
				..()
				return
			to_chat(user, "<span class='notice'>You unscrew [silenced] from [src].</span>")
			user.put_in_hands(silenced)
			silenced = initial(silenced)
			w_class = initial(w_class)
			update_icon()
			return
	..()

/obj/item/weapon/gun/projectile/pistol/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/silencer))
		if(user.l_hand != src && user.r_hand != src)	//if we're not in his hands
			to_chat(user, "<span class='notice'>You'll need [src] in your hands to do that.</span>")
			return
		if(!user.unEquip(I, src))
			return//put the silencer into the gun
		to_chat(user, "<span class='notice'>You screw [I] onto [src].</span>")
		silenced = I	//dodgy?
		w_class = ITEM_SIZE_NORMAL
		update_icon()
		return
	..()

/obj/item/weapon/gun/projectile/pistol/on_update_icon()
	..()
	if(silenced)
		icon_state = "silenced_pistol"
		wielded_item_state = "pistol-silencer"
	else
		icon_state = "pistol"
	if(!(ammo_magazine && ammo_magazine.stored_ammo.len))
		icon_state = "[icon_state]-e"

/obj/item/weapon/silencer
	name = "silencer"
	desc = "A silencer."
	icon = 'icons/obj/guns/holdout_pistol.dmi'
	icon_state = "silencer"
	w_class = ITEM_SIZE_SMALL