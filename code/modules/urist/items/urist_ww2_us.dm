/* Urist - United States Faction - World War 2 /////
Contents:
	Firearms
	Firearm Magazines
	Explosives
	Clothing
*/



// United States - Firearms

// Automatic Rifles:

/obj/item/gun/projectile/automatic/bar

	name = "\improper M1918 BAR"
	desc = "The M1918 Browning Automatic Rifle, a US Army support LMG. Chambered in 30-06, it holds 20 rounds."
	icon = 'icons/urist/guns/ww2_us.dmi'
	icon_state = "bar"
	item_state = "sexyrifle"
	wielded_item_state = "rifle2"
	item_icons = DEF_URIST_INHANDS
	w_class = ITEM_SIZE_LARGE
	caliber = CALIBER_RIFLE_MILITARY //i mean... 30-06 is 7.62, so fuck it.
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/rifle/military/barmag
	allowed_magazines = /obj/item/ammo_magazine/rifle/military/barmag
	ammo_type = /obj/item/projectile/bullet/rifle/military
	one_hand_penalty = 4
	fire_sound = 'sound/weapons/gunshot/gunshot2.ogg'
	force = 10

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, one_hand_penalty = 4, move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="short bursts", 	burst=5, move_delay=6, fire_delay=null, one_hand_penalty = 6, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	burst=8, fire_delay=null, move_delay=8, one_hand_penalty = 3, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/automatic/bar/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "bar"
	else
		icon_state = "bar-empty"
	return

// Firearms - SMG

/obj/item/gun/projectile/automatic/m3
	name = "M3 Grease Gun"
	desc = "The submachine gun for medical personnel and infantrymen. Only fires in short and long bursts. Takes magazines of 32 rounds."
	icon = 'icons/urist/guns/ww2_us.dmi'
	icon_state = "M3"
	item_state = "secguncomp"
	wielded_item_state = "secguncomp"
	item_icons = DEF_URIST_INHANDS
	w_class = ITEM_SIZE_NORMAL
	caliber = CALIBER_PISTOL
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ESOTERIC = 4) // spess men are blown away by sheet metal
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/pistol/m3
	allowed_magazines = /obj/item/ammo_magazine/pistol/m3
	ammo_type = /obj/item/ammo_casing/pistol
	one_hand_penalty = 1
	force = 10
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	firemodes = list(
		list(mode_name="short bursts",	burst=4, fire_delay=null, move_delay=6, one_hand_penalty = 2, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	burst=8, fire_delay=null, move_delay=8, one_hand_penalty = 3, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/automatic/m3/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "M3"
	else
		icon_state = "M3-empty"
	return

/obj/item/ammo_magazine/pistol/m3
	name = "M3 magazine"
	desc = "A M3 Grease Gun stick magazine, chambered in 10mm."
	icon = 'icons/urist/guns/ammo_ww2.dmi'
	icon_state = "M3MAG"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol
	matter = list(DEFAULT_WALL_MATERIAL = 525) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = CALIBER_PISTOL
	max_ammo = 32

/obj/item/ammo_magazine/pistol/m3/empty
	initial_ammo = 0


// Firearms - Pistols & Revolvers

/obj/item/gun/projectile/bhp9mm
	name = "\improper Browning HP pistol"
	desc = "The NCO's sidearm. 15 rounds, almost double the usual capacity. May be issued to medical units as well."
	icon = 'icons/urist/guns/ww2_us.dmi'
	icon_state = "brownhp"
	item_state = "pistol"
	w_class = ITEM_SIZE_SMALL
	caliber = CALIBER_PISTOL_SMALL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIALS = 2, TECH_ESOTERIC = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	slot_flags = SLOT_BELT | SLOT_HOLSTER | SLOT_POCKET
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/pistol/bhp
	allowed_magazines = /obj/item/ammo_magazine/pistol/bhp
	ammo_type = /obj/item/ammo_casing/pistol/small

/obj/item/gun/projectile/bhp9mm/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "brownhp"
	else
		icon_state = "brownhp-empty"
	return

/obj/item/ammo_magazine/pistol/bhp
	icon = 'icons/urist/guns/ammo_ww2.dmi'
	name = "Browning HP pistol magazine, chambered in 9mm."
	icon_state = "BROWNHPMAG"
	caliber = CALIBER_PISTOL_SMALL
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 15

/obj/item/ammo_magazine/pistol/bhp/empty
	initial_ammo = 0

// United States - Firearm Magazines

// Automatic Rifles - Ammo & Magazines

/obj/item/ammo_magazine/rifle/military/barmag
	name = "BAR magazine" //shhhh
	desc = "A BAR box magazine, chambered in .30-06."
	icon = 'icons/urist/guns/ammo_ww2.dmi'
	icon_state = "bar_mag"
	ammo_type = /obj/item/ammo_casing/rifle/military
	max_ammo = 20

/obj/item/ammo_magazine/rifle/military/barmag/empty
	initial_ammo = 0

// SMG - Ammo & Magazines

// Pistol & Revolver - Ammo & Magazines
