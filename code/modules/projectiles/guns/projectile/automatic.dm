/obj/item/weapon/gun/projectile/automatic
	name = "prototype SMG"
	desc = "A protoype lightweight, fast firing submachine gun. Uses 4mm rounds."
	icon = 'icons/urist/items/machine_pistol.dmi'
	icon_state = "prototype"
	item_icons = URIST_ALL_ONMOBS
	wielded_item_state = "saber"
	w_class = ITEM_SIZE_NORMAL
	bulk = -1
	load_method = MAGAZINE
	caliber = "4mm"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 3)
	slot_flags = SLOT_BELT
	ammo_type = /obj/item/ammo_casing/c4mm
	multi_aim = 1
	burst_delay = 2
	mag_insert_sound = 'sound/weapons/guns/interaction/smg_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/smg_magout.ogg'

	//machine pistol, easier to one-hand with
	firemodes = list(
		list(mode_name="semi auto",       burst=1, fire_delay=0,    move_delay=null, one_hand_penalty=0, burst_accuracy=null, dispersion=null),
		list(mode_name="4-round bursts", burst=4, fire_delay=null, move_delay=4,    one_hand_penalty=1, burst_accuracy=list(0,0,-1,-1),       dispersion=list(0.0, 0.0, 0.5, 0.6)),
		list(mode_name="long bursts",   burst=8, fire_delay=null, move_delay=4,    one_hand_penalty=2, burst_accuracy=list(0,0,-1,-1,-1,-1,-2,-2), dispersion=list(0.0, 0.0, 0.5, 0.6, 0.8, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/projectile/automatic/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "prototype"
	else
		icon_state = "prototype-empty"

/obj/item/weapon/gun/projectile/automatic/machine_pistol
	name = ".45 machine pistol"
	desc = "The Lumoco Arms MP6 Vesper, A fairly common machine pistol. Sometimes refered to as an 'uzi' by the backwater spacers it is often associated with. Uses .45 rounds."
	icon = 'icons/urist/items/machine_pistol.dmi'
	icon_state = "mpistolen"
	item_state = "mpistolen"
	item_icons = URIST_ALL_ONMOBS
	wielded_item_state = "mpistolen"
	w_class = ITEM_SIZE_NORMAL
	load_method = MAGAZINE
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	slot_flags = SLOT_BELT
	ammo_type = /obj/item/ammo_casing/c45
	magazine_type = /obj/item/ammo_magazine/c45uzi
	allowed_magazines = /obj/item/ammo_magazine/c45uzi //more damage compared to the wt550, smaller mag size
	one_hand_penalty = 2

	firemodes = list(
		list(mode_name="semi auto",       burst=1, fire_delay=0,    move_delay=null, one_hand_penalty=0, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    one_hand_penalty=1, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=4,    one_hand_penalty=2, burst_accuracy=list(0,-1,-1,-1,-2), dispersion=list(0.6, 0.6, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/projectile/automatic/machine_pistol/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "mpistolen"
	else
		icon_state = "mpistolen-empty"

/obj/item/weapon/gun/projectile/automatic/c20r
	name = "10mm submachine gun"
	desc = "The C-20r is a lightweight and rapid firing SMG, for when you REALLY need someone dead. Uses 10mm rounds. Has a 'Scarborough Arms - Per falcis, per pravitas' buttstamp."
	icon = 'icons/urist/items/c20r.dmi'
	icon_state = "c20r"
	item_state = "c20r"
	item_icons = URIST_ALL_ONMOBS
	wielded_item_state = "c20r"
	w_class = ITEM_SIZE_LARGE
	force = 10
	caliber = "10mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	slot_flags = SLOT_BELT|SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a10mm
	allowed_magazines = /obj/item/ammo_magazine/a10mm
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	bulk = -1
	accuracy = 1
	one_hand_penalty = 4

	//SMG
	firemodes = list(
		list(mode_name="semi auto",       burst=1, fire_delay=0,    move_delay=null, one_hand_penalty=2, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    one_hand_penalty=3, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=4,    one_hand_penalty=4, burst_accuracy=list(0,-1,-1,-1,-2), dispersion=list(0.6, 0.6, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/projectile/automatic/c20r/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "c20r-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "c20r"

/obj/item/weapon/gun/projectile/automatic/sts35
	name = "assault rifle"
	desc = "The rugged STS-35 is a durable automatic weapon of a make popular on the frontier worlds. The serial number has been scratched off. Uses 5.56mm rounds."
	icon = 'icons/urist/items/assault_rifle.dmi'
	icon_state = "arifle"
	item_state = "arifle"
	wielded_item_state = "arifle-wielded"
	item_icons = URIST_ALL_ONMOBS
	w_class = ITEM_SIZE_HUGE
	force = 10
	caliber = "a556"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 5)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c556
	allowed_magazines = /obj/item/ammo_magazine/c556
	one_hand_penalty = 3
	accuracy_power = 4
	accuracy = 2
	bulk = GUN_BULK_RIFLE + 1
	mag_insert_sound = 'sound/weapons/guns/interaction/ltrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/ltrifle_magout.ogg'

	//Assault rifle, burst fire degrades quicker than SMG, worse one-handing penalty, slightly increased move delay
	firemodes = list(
		list(mode_name="semi auto",       burst=1, fire_delay=0,    move_delay=null, one_hand_penalty=4, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    one_hand_penalty=5, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=6,    one_hand_penalty=6, burst_accuracy=list(0,-1,-2,-3,-3), dispersion=list(0.6, 1.0, 1.2, 1.2, 1.5)),
		)

/obj/item/weapon/gun/projectile/automatic/sts35/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "arifle"
		wielded_item_state = "arifle-wielded"
	else
		icon_state = "arifle-empty"
		wielded_item_state = "arifle-0-wielded"

/obj/item/weapon/gun/projectile/automatic/wt550
	name = "9mm submachine gun"
	desc = "The WT-550 Saber is a cheap self-defense weapon, mass-produced by Ward-Takahashi for paramilitary and private use. Uses 9mm rounds."
	icon = 'icons/urist/items/wt550.dmi'
	icon_state = "wt550"
	item_state = "wt550"
	item_icons = URIST_ALL_ONMOBS
	wielded_item_state = "wt550"
	w_class = ITEM_SIZE_NORMAL
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = /obj/item/ammo_casing/c9mm/rubber
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mc9mmt/rubber
	allowed_magazines = /obj/item/ammo_magazine/mc9mmt
	accuracy_power = 3
	one_hand_penalty = 3

	//machine pistol, like SMG but easier to one-hand with
	firemodes = list(
		list(mode_name="semi auto",       burst=1, fire_delay=0,    move_delay=null, one_hand_penalty=0, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    one_hand_penalty=1, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=4,    one_hand_penalty=2, burst_accuracy=list(0,-1,-1,-1,-2), dispersion=list(0.6, 0.6, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/projectile/automatic/wt550/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "wt550-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "wt550"

/obj/item/weapon/gun/projectile/automatic/z8
	name = "bullpup assault rifle"
	desc = "The Z8 Bulldog is an older model bullpup carbine, made by the now defunct Zendai Foundries. Uses armor piercing 7.62mm rounds. Makes you feel like a space marine when you hold it."
	icon = 'icons/urist/items/z8carbine.dmi'
	icon_state = "carbine"
	item_state = "z8carbine"
	item_icons = URIST_ALL_ONMOBS
	wielded_item_state = "z8carbine-wielded"
	w_class = ITEM_SIZE_HUGE
	force = 10
	caliber = "a762"
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 3)
	ammo_type = /obj/item/ammo_casing/a762
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a762
	allowed_magazines = /obj/item/ammo_magazine/a762
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	accuracy = 2
	accuracy_power = 4
	one_hand_penalty = 8
	bulk = GUN_BULK_RIFLE
	burst_delay = 4
	mag_insert_sound = 'sound/weapons/guns/interaction/batrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/batrifle_magout.ogg'
	firemodes = list(
		list(mode_name="semi auto",       burst=1,    fire_delay=0,    move_delay=null, use_launcher=null, one_hand_penalty=5, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3,    fire_delay=null, move_delay=6,    use_launcher=null, one_hand_penalty=6, burst_accuracy=list(0,-1,-1), dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="fire grenades",  burst=null, fire_delay=null, move_delay=null, use_launcher=1,    one_hand_penalty=5, burst_accuracy=null, dispersion=null)
		)

	var/use_launcher = 0
	var/obj/item/weapon/gun/launcher/grenade/underslung/launcher

/obj/item/weapon/gun/projectile/automatic/z8/Initialize()
	. = ..()
	launcher = new(src)

/obj/item/weapon/gun/projectile/automatic/z8/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/weapon/grenade)))
		launcher.load(I, user)
	else
		..()

/obj/item/weapon/gun/projectile/automatic/z8/attack_hand(mob/user)
	if(user.get_inactive_hand() == src && use_launcher)
		launcher.unload(user)
	else
		..()

/obj/item/weapon/gun/projectile/automatic/z8/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0)
	if(use_launcher)
		launcher.Fire(target, user, params, pointblank, reflex)
		if(!launcher.chambered)
			switch_firemodes() //switch back automatically
	else
		..()

/obj/item/weapon/gun/projectile/automatic/z8/on_update_icon()
	..()
	if(ammo_magazine)
		if(ammo_magazine.stored_ammo.len)
			icon_state = "carbine-loaded"
		else
			icon_state = "carbine-empty"
	else
		icon_state = "carbine"

/obj/item/weapon/gun/projectile/automatic/z8/examine(mob/user)
	. = ..()
	if(launcher.chambered)
		to_chat(user, "\The [launcher] has \a [launcher.chambered] loaded.")
	else
		to_chat(user, "\The [launcher] is empty.")

/obj/item/weapon/gun/projectile/automatic/l6_saw
	name = "light machine gun"
	desc = "A rather traditionally made L6 SAW with a pleasantly lacquered wooden pistol grip. Has 'Aussec Armoury- 2281' engraved on the reciever." //probably should refluff this
	icon = 'icons/obj/guns/saw.dmi'
	icon_state = "l6closed100"
	item_state = "l6closedmag"
	w_class = ITEM_SIZE_HUGE
	bulk = 10
	force = 10
	slot_flags = 0
	max_shells = 50
	caliber = "a556"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 2)
	slot_flags = 0 //need sprites for SLOT_BACK
	ammo_type = /obj/item/ammo_casing/a556
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/box/a556
	allowed_magazines = list(/obj/item/ammo_magazine/box/a556, /obj/item/ammo_magazine/c556)
	one_hand_penalty = 10
	wielded_item_state = "gun_wielded"
	mag_insert_sound = 'sound/weapons/guns/interaction/lmg_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/lmg_magout.ogg'

	//LMG, better sustained fire accuracy than assault rifles (comparable to SMG), higer move delay and one-handing penalty
	//No single-shot or 3-round-burst modes since using this weapon should come at a cost to flexibility.
	firemodes = list(
		list(mode_name="short bursts",	can_autofire=0, burst=5, fire_delay=5, move_delay=12, one_hand_penalty=8, burst_accuracy = list(0,-1,-1,-2,-2),          dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	can_autofire=0, burst=8, fire_delay=5, one_hand_penalty=9, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="full auto",		can_autofire=1, burst=1, fire_delay=1, one_hand_penalty=12, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

	var/cover_open = 0

/obj/item/weapon/gun/projectile/automatic/l6_saw/mag
	magazine_type = /obj/item/ammo_magazine/c556

/obj/item/weapon/gun/projectile/automatic/l6_saw/special_check(mob/user)
	if(cover_open)
		to_chat(user, "<span class='warning'>[src]'s cover is open! Close it before firing!</span>")
		return 0
	return ..()

/obj/item/weapon/gun/projectile/automatic/l6_saw/proc/toggle_cover(mob/user)
	cover_open = !cover_open
	to_chat(user, "<span class='notice'>You [cover_open ? "open" : "close"] [src]'s cover.</span>")
	update_icon()

/obj/item/weapon/gun/projectile/automatic/l6_saw/attack_self(mob/user as mob)
	if(cover_open)
		toggle_cover(user) //close the cover
	else
		return ..() //once closed, behave like normal

/obj/item/weapon/gun/projectile/automatic/l6_saw/attack_hand(mob/user as mob)
	if(!cover_open && user.get_inactive_hand() == src)
		toggle_cover(user) //open the cover
	else
		return ..() //once open, behave like normal

/obj/item/weapon/gun/projectile/automatic/l6_saw/on_update_icon()
	..()
	if(istype(ammo_magazine, /obj/item/ammo_magazine/box))
		icon_state = "l6[cover_open ? "open" : "closed"][round(ammo_magazine.stored_ammo.len, 25)]"
		item_state = "l6[cover_open ? "open" : "closed"]"
	else if(ammo_magazine)
		icon_state = "l6[cover_open ? "open" : "closed"]mag"
		item_state = "l6[cover_open ? "open" : "closed"]mag"
	else
		icon_state = "l6[cover_open ? "open" : "closed"]-empty"
		item_state = "l6[cover_open ? "open" : "closed"]-empty"

/obj/item/weapon/gun/projectile/automatic/l6_saw/load_ammo(var/obj/item/A, mob/user)
	if(!cover_open)
		to_chat(user, "<span class='warning'>You need to open the cover to load that into [src].</span>")
		return
	..()

/obj/item/weapon/gun/projectile/automatic/l6_saw/unload_ammo(mob/user, var/allow_dump=1)
	if(!cover_open)
		to_chat(user, "<span class='warning'>You need to open the cover to unload [src].</span>")
		return
	..()
