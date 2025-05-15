/* Urist - Germany - World War 2 /////
Contents:
	Firearms
	Firearm Magazines
	Explosives
	Clothing
*/

// Russia - Firearms

// Firearms - Rifles & Semi-Automatic

/obj/item/gun/projectile/manualcycle/kar98
	item_icons = DEF_URIST_INHANDS
	name = "Kar 98k"
	icon = 'icons/urist/guns/ww2_ger.dmi'
	desc = "The standard bolt action rifle of the Wehrmacht. Chambered in 7.92x57mm."
	wielded_item_state = "rifle2" //maybe change this
	icon_state = "kar98"
	item_state = "rifle2"
	w_class = 5
	one_hand_penalty = 4
	force = 10
	slot_flags = SLOT_BACK
	caliber = CALIBER_RIFLE_MAUSER
	handle_casings = HOLD_CASINGS
	max_shells = 5
	ammo_type = /obj/item/ammo_casing/a792x57mm
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'

/obj/item/gun/projectile/g43
	item_icons = DEF_URIST_INHANDS
	name = "\improper Gewehr 43"
	desc = "The standard semi-automatic rifle of the Wehrmacht, chambered in 7.92x57mm. Holds 10 rounds."
	icon = 'icons/urist/guns/ww2_ger.dmi'
	icon_state = "g43"
	item_state = "rifle2"
	w_class = 4
	force = 10
	caliber = CALIBER_RIFLE_MAUSER
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a792x57mm/g43mag
	allowed_magazines = list(/obj/item/ammo_magazine/a792x57mm/g43mag,/obj/item/ammo_magazine/a792x57mm/stripper)
	one_hand_penalty = 4
	wielded_item_state = "woodarifle-wielded"
	max_shells = 10

/obj/item/gun/projectile/g43/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "g43"
	else
		icon_state = "g43-empty"
	return

// Firearms - Machine Guns & Automatic Rifles

/obj/item/gun/projectile/automatic/l6_saw/mg42
	item_icons = DEF_URIST_INHANDS
	name = "MG 42"
	desc = "The general-purpose machinegun of the Wehrmacht, perfect for support and suppresive fire. Holds 250 rounds of 7.92x57mm"
	icon = 'icons/urist/guns/ww2_ger.dmi'
	icon_state = "mg42closed"
	item_state = "genericLMG-wielded" // override for no sprites.
	wielded_item_state = "genericLMG-wielded"
	max_shells = 250
	magazine_type = /obj/item/ammo_magazine/a792x57mm/mg42
	allowed_magazines = list(/obj/item/ammo_magazine/a792x57mm/mg42)
	one_hand_penalty = 6
	wielded_item_state = "genericLMG-wielded"
	caliber = CALIBER_RIFLE_MAUSER
	load_method = MAGAZINE
	slot_flags = SLOT_BACK
	firemodes = list(
		list(mode_name="short bursts",	burst=4, fire_delay=null, move_delay=6, one_hand_penalty = 2, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	burst=8, fire_delay=null, move_delay=8, one_hand_penalty = 3, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/automatic/l6_saw/mg42/on_update_icon()
//	..()
	icon_state = "mg42[cover_open ? "open" : "closed"][ammo_magazine ? "" : "-empty"]"

/obj/item/gun/projectile/automatic/stg44
	name = "\improper StG 44"
	desc = "The standard assault rifle of the Wehrmacht. Holds 30 rounds of 7.92x33mmk."
	icon = 'icons/urist/guns/ww2_ger.dmi'
	icon_state = "stg44"
	item_state = "stg44"
	item_icons = DEF_URIST_INHANDS
	wielded_item_state = "genericrifle-wielded"
	w_class = ITEM_SIZE_LARGE
	caliber = CALIBER_RIFLE_GER_AR
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a792x33mm
	allowed_magazines = list(/obj/item/ammo_magazine/a792x33mm)
	ammo_type = /obj/item/ammo_casing/a792x33mm
	one_hand_penalty = 4
	fire_sound = 'sound/weapons/gunshot/gunshot2.ogg'
	force = 10

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, one_hand_penalty = 4, move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, move_delay=6, fire_delay=null, one_hand_penalty = 5, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.0, 0.6, 0.6)),
		list(mode_name="short bursts", 	burst=5, move_delay=6, fire_delay=null, one_hand_penalty = 6, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/automatic/stg44/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "stg44"
	else
		icon_state = "stg44-empty"
	return

// Firearms - SMGs

/obj/item/gun/projectile/automatic/mp40

	name = "MP 40"
	desc = "The standard sub-machinegun of the Wehrmacht. Only fires in short and long bursts. Takes magazines of 32 9mm rounds."
	icon = 'icons/urist/guns/ww2_ger.dmi'
	icon_state = "mp40_stock"
	item_state = "ppsh"
	wielded_item_state = "ppsh"
	item_icons = DEF_URIST_INHANDS
	w_class = ITEM_SIZE_NORMAL
	caliber = CALIBER_PISTOL_SMALL
	slot_flags = SLOT_BELT || SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/pistol/mp40
	allowed_magazines = /obj/item/ammo_magazine/pistol/mp40
	ammo_type = /obj/item/ammo_casing/pistol/small
	one_hand_penalty = 1
	force = 8
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	firemodes = list(
		list(mode_name="short bursts",	burst=4, fire_delay=null, move_delay=6, one_hand_penalty = 2, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	burst=8, fire_delay=null, move_delay=8, one_hand_penalty = 3, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/automatic/mp40/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "mp40_stock"
	else
		icon_state = "mp40_stock-empty"
	return


// Firearms - Pistols & Revolvers

/obj/item/gun/projectile/p38
	name = "\improper Walther P38"
	desc = "The standard service pistol of the Wehrmacht. Chambered in 9mm, the magazine holds 8 rounds."
	icon = 'icons/urist/guns/ww2_ger.dmi'
	icon_state = "p38"
	item_state = "gun"
	w_class = ITEM_SIZE_SMALL
	caliber = CALIBER_PISTOL_SMALL
	fire_sound = 'sound/weapons/gunshot/Gunshot_pistol.ogg'
	slot_flags = SLOT_BELT | SLOT_POCKET | SLOT_HOLSTER
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/pistol/p38
	allowed_magazines = /obj/item/ammo_magazine/pistol/p38
	ammo_type = /obj/item/ammo_casing/pistol/small

/obj/item/gun/projectile/p38/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "p38"
	else
		icon_state = "p38-empty"
	return



// Germany - Firearm Magazines

// Rifles & Semi-Automatic - Ammo & Magazines

/obj/item/ammo_magazine/a792x57mm
	caliber = CALIBER_RIFLE_MAUSER
	ammo_type = /obj/item/ammo_casing/a792x57mm
	icon = 'icons/urist/guns/ammo.dmi'
	mag_type = MAGAZINE

/obj/item/ammo_magazine/a792x57mm/stripper
	name = "stripper clip"
	icon = 'icons/urist/guns/ammo_ww2.dmi'
	icon_state = "stripper" //change
	max_ammo = 5
	multiple_sprites = 1
	mag_type = SPEEDLOADER

/obj/item/ammo_magazine/a792x57mm/g43mag
	name = "Gewehr 43 magazine"
	icon_state = "g43mag"
	max_ammo = 10

/obj/item/ammo_magazine/a792x57mm/g43mag/empty
	initial_ammo = 0

/obj/item/ammo_casing/a792x57mm
	name = "shell casing"
	desc = "A 7.92x57mm shell."
	icon = 'icons/urist/guns/ammo.dmi'
	icon_state = "lcasing"
	spent_icon = "lcasing-spent"
	caliber = CALIBER_RIFLE_MAUSER
	projectile_type = /obj/item/projectile/bullet/rifle //no need to make a new projectile

/obj/item/ammo_casing/a792x33mm
	name = "shell casing"
	desc = "A 7.92x33mm shell."
	icon = 'icons/urist/guns/ammo.dmi'
	icon_state = "rifle-casing"
	spent_icon = "rifle-casing-spent"
	caliber = CALIBER_RIFLE_GER_AR
	projectile_type = /obj/item/projectile/bullet/rifle //no need to make a new projectile

// Machineguns & Automatic Rifles - Ammo & Magazines

/obj/item/ammo_magazine/a792x57mm/mg42
	name = "MG 42 belt"
	icon_state = "mg42belt"
	max_ammo = 250
	mag_type = MAGAZINE

/obj/item/ammo_magazine/a792x57mm/mg42/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a792x33mm
	name = "StG 44 magazine"
	icon_state = "stg44mag"
	caliber = CALIBER_RIFLE_GER_AR
	ammo_type = /obj/item/ammo_casing/a792x33mm
	icon = 'icons/urist/guns/ammo_ww2.dmi'
	max_ammo = 30
	mag_type = MAGAZINE

/obj/item/ammo_magazine/a792x33mm/empty
	initial_ammo = 0

// SMG - Ammo & Magazines

/obj/item/ammo_magazine/pistol/mp40
	icon = 'icons/urist/guns/ammo_ww2.dmi'
	name = "MP 40 stick magazine"
	icon_state = "mpmag"
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 32

/obj/item/ammo_magazine/pistol/mp40/empty
	initial_ammo = 0

// Firearms - Pistols & Revolvers - Ammo & Magazines

/obj/item/ammo_magazine/pistol/p38
	icon = 'icons/urist/guns/ammo_ww2.dmi'
	name = "Walther P38 magazine"
	icon_state = "p38mag"
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 8

/obj/item/ammo_magazine/pistol/p38/empty
	initial_ammo = 0



// Germany - Explosives

/obj/item/grenade/frag/stielhandgranate
	desc = "A high explosive grenade, intended to be used as a sort of 'concussion' grenade."
	name = "Model 21 Stielhandgranate"
	icon = 'icons/urist/weapons/grenades.dmi'
	icon_state = "kr_sticknade"
	item_state = "flashbang"
	arm_sound = 'sound/effects/flare.ogg' // Closest thing to old fuse sounds.

/obj/item/grenade/frag/stielhandgranate/detonate()
	explosion(src.loc, 3, EX_ACT_DEVASTATING)
	qdel(src)



//Germany - Clothing

// Under

/obj/item/clothing/under/urist/ww2/germanrifleman
	name = "Wehrmacht rifleman's uniform"
	desc = "A uniform commonly worn by Wehrmacht riflemen."
	icon_state = "kr_rifleman"
	item_state = "kr_rifleman"

/obj/item/clothing/under/urist/ww2/germanofficer
	name = "Wehrmacht officer's uniform"
	desc = "A uniform commonly worn by Wehrmacht officers."
	icon_state = "kr_officer"
	item_state = "kr_officer"

// Head

/obj/item/clothing/head/helmet/urist/ww2/germanhelm
	name = "Wehrmacht Stahlhelm"
	desc = "The standard helmet of the Wehrmacht."
	icon_state = "kr_helm"
	item_state = "kr_helm"
	armor = list(melee = 50, bullet = 15, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/head/urist/ww2/germanofficer
	name = "Wehrmacht officer's cap"
	desc = "A cap commonly worn by Wehrmacht officers."
	icon_state = "kr_officap"
	item_state = "kr_officap"

// Shoes

/obj/item/clothing/shoes/urist/ww2/germanboots
	name = "Wehrmacht jackboots"
	desc = "Ah, good German jackboots. Thank you Heinrich."
	icon_state = "kr_boots"
	item_state = "kr_boots"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 5, bio = 0, rad = 0)

// Storage

/obj/item/storage/backpack/urist/german
	name = "Wehrmacht rucksack"
	desc = "A rucksack typically worn by Wehrmacht riflemen."
	icon_state = "kr_rucksack"
	item_state = "kr_rucksack"

/obj/item/clothing/accessory/storage/webbing_german
	name = "Wehrmacht webbing"
	desc = "A large collection of pockets and pouches worn by Wehrmacht riflemen."
	icon = 'icons/urist/items/clothes/ties.dmi'
	icon_override = 'icons/uristmob/ties.dmi'
	icon_state = "kr_webbing"
	slots = 4
