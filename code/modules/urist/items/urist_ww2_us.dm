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



// United States - Firearm Magazines

// Automatic Rifles - Ammo & Magazines

/obj/item/ammo_magazine/rifle/military/barmag
	name = "BAR magazine" //shhhh
	icon_state = "bar_mag"
	ammo_type = /obj/item/ammo_casing/rifle/military
	max_ammo = 20

/obj/item/ammo_magazine/rifle/military/barmag/empty
	initial_ammo = 0
