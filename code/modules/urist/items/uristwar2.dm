//germany
/obj/item/clothing/under/urist/wwii/germanrifleman
	name = "Wehrmacht rifleman's uniform"
	desc = "A uniform commonly worn by Wehrmacht riflemen."
	icon_state = "kr_rifleman"
	item_state = "kr_rifleman"

/obj/item/clothing/under/urist/wwii/germanofficer
	name = "Wehrmacht officer's uniform"
	desc = "A uniform commonly worn by Wehrmacht officers."
	icon_state = "kr_officer"
	item_state = "kr_officer"

/obj/item/clothing/head/helmet/urist/wwii/germanhelm
	name = "Wehrmacht Stahlhelm"
	desc = "The standard helmet of the Wehrmacht."
	icon_state = "kr_helm"
	item_state = "kr_helm"
	armor = list(melee = 50, bullet = 15, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/head/urist/wwii/germanofficer
	name = "Wehrmacht officer's cap"
	desc = "A cap commonly worn by Wehrmacht officers."
	icon_state = "kr_officap"
	item_state = "kr_officap"

/obj/item/clothing/shoes/urist/wwii/germanboots
	name = "Wehrmacht jackboots"
	desc = "Ah, good German jackboots. Thank you Heinrich."
	icon_state = "kr_boots"
	item_state = "kr_boots"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 5, bio = 0, rad = 0)

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

//gr guns

/obj/item/gun/projectile/manualcycle/kar98
	item_icons = DEF_URIST_INHANDS
	name = "Kar 98k"
	icon = 'icons/urist/items/guns.dmi'
	desc = "The standard bolt action rifle of the Wehrmacht. Chambered in 7.92�57mm."
	wielded_item_state = "rifle2" //maybe change this
	icon_state = "kar98"
	item_state = "rifle2"
	w_class = 5
	one_hand_penalty = 4
	force = 10
	slot_flags = SLOT_BACK
	caliber = "7.92x57mm"
	handle_casings = HOLD_CASINGS
//	load_method = SINGLE_CASING
	max_shells = 5
	ammo_type = /obj/item/ammo_casing/a792x57mm
//	accuracy = -1
//	jam_chance = 5
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'

/obj/item/ammo_magazine/a792x57mm
	caliber = "7.92x57mm"
	ammo_type = /obj/item/ammo_casing/a792x57mm
	icon = 'icons/urist/items/guns.dmi'
	mag_type = MAGAZINE

/obj/item/ammo_magazine/a792x57mm/stripper
	name = "stripper clip (7.92x57mm)"
	icon_state = "stripper" //change
	max_ammo = 5
	multiple_sprites = 1
	mag_type = SPEEDLOADER

/obj/item/ammo_magazine/a792x57mm/g43mag
	name = "Gewehr 43 magazine (7.92x57mm)"
	icon_state = "g43mag"
	max_ammo = 10

/obj/item/ammo_magazine/a792x57mm/g43mag/empty
	initial_ammo = 0

/obj/item/gun/projectile/g43
	item_icons = DEF_URIST_INHANDS
	name = "\improper Gewehr 43"
	desc = "The standard semi-automatic rifle of the Wehrmacht, chambered in 7.92x57mm. Holds 10 rounds."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "g43"
	item_state = "rifle2"
	w_class = 4
	force = 10
	caliber = "7.92x57mm"
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

/obj/item/ammo_casing/a792x57mm
	name = "shell casing"
	desc = "A 7.92x57mm shell."
	icon_state = "rifle-casing" //maybe change this
	spent_icon = "rifle-casing-spent"
	caliber = "7.92x57mm"
	projectile_type = /obj/item/projectile/bullet/rifle //no need to make a new projectile

/obj/item/gun/projectile/automatic/stg44
	item_icons = DEF_URIST_INHANDS
	name = "\improper StG 44"
	desc = "The standard assault rifle of the Wehrmacht. Holds 30 rounds of 7.92x33mm."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "stg44"
	item_state = "stg44"
	w_class = 4
	force = 10
	caliber = "7.92x33mm"
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a792x33mm
	allowed_magazines = list(/obj/item/ammo_magazine/a792x33mm)
	one_hand_penalty = 4
	fire_sound = 'sound/weapons/gunshot/gunshot2.ogg'
	wielded_item_state = "genericrifle-wielded"

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

/obj/item/ammo_magazine/a792x33mm
	name = "StG 44 magazine (7.92x33mm)"
	icon_state = "stg44mag"
	caliber = "7.92x33mm"
	ammo_type = /obj/item/ammo_casing/a792x33mm
	icon = 'icons/urist/items/guns.dmi'
	max_ammo = 30
	mag_type = MAGAZINE

/obj/item/ammo_magazine/a792x33mm/empty
	initial_ammo = 0

/obj/item/ammo_casing/a792x33mm
	name = "shell casing"
	desc = "A 7.92x33mm shell."
	icon_state = "rifle-casing"
	spent_icon = "rifle-casing-spent"
	caliber = "7.92x33mm"
	projectile_type = /obj/item/projectile/bullet/rifle //no need to make a new projectile

/obj/item/gun/projectile/automatic/mp40
	item_icons = DEF_URIST_INHANDS
	name = "MP 40"
	desc = "The standard sub-machinegun of the Wehrmacht. Only fires in short and long bursts. Takes magazines of 32 9mm rounds."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "mp40_stock"
	item_state = "ppsh"
	w_class = 3
	force = 8
	caliber = CALIBER_PISTOL_SMALL
	slot_flags = SLOT_BELT || SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/pistol/mp40
	allowed_magazines = list(/obj/item/ammo_magazine/pistol/mp40)
	one_hand_penalty = 1
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

/obj/item/ammo_magazine/pistol/mp40
	icon = 'icons/urist/items/guns.dmi'
	name = "MP 40"
	icon_state = "mpmag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 32

/obj/item/ammo_magazine/pistol/mp40/empty
	initial_ammo = 0

/obj/item/gun/projectile/p38
	name = "\improper Walther P38"
	desc = "The standard service pistol of the Wehrmacht. Chambered in 9mm, the magazine holds 8 rounds."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "p38"
	item_state = "gun"
	w_class = 2
	caliber = CALIBER_PISTOL_SMALL
	fire_sound = 'sound/weapons/gunshot/Gunshot_pistol.ogg'
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/pistol/p38
	allowed_magazines = list(/obj/item/ammo_magazine/pistol/p38)

/obj/item/gun/projectile/p38/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "p38"
	else
		icon_state = "p38-empty"
	return

/obj/item/ammo_magazine/pistol/p38
	icon = 'icons/urist/items/guns.dmi'
	name = "Walther P38 magazine"
	icon_state = "p38mag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 8

/obj/item/ammo_magazine/pistol/p38/empty
	initial_ammo = 0

/obj/item/gun/projectile/automatic/l6_saw/mg42
	item_icons = DEF_URIST_INHANDS
	name = "MG 42"
	desc = "The general-purpose machinegun of the Wehrmacht, perfect for support and suppresive fire. Holds 250 rounds of "
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "mg42closed"
	item_state = "l6closedmag"
	max_shells = 250
	magazine_type = /obj/item/ammo_magazine/a792x57mm/mg42
	allowed_magazines = list(/obj/item/ammo_magazine/a792x57mm/mg42)
	one_hand_penalty = 6
	wielded_item_state = "genericLMG-wielded"
	caliber = "7.92x57mm"
	load_method = MAGAZINE
	slot_flags = SLOT_BACK
	firemodes = list(
		list(mode_name="short bursts",	burst=4, fire_delay=null, move_delay=6, one_hand_penalty = 2, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	burst=8, fire_delay=null, move_delay=8, one_hand_penalty = 3, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/automatic/l6_saw/mg42/on_update_icon()
//	..()
	icon_state = "mg42[cover_open ? "open" : "closed"][ammo_magazine ? "" : "-empty"]"

/obj/item/ammo_magazine/a792x57mm/mg42
	name = "MG 42 belt (7.92x57mm)"
	icon_state = "mg42belt"
	max_ammo = 250
	mag_type = MAGAZINE

/obj/item/ammo_magazine/a792x57mm/mg42/empty
	initial_ammo = 0

/obj/item/grenade/stielhandgranate
	desc = "A high explosive grenade, intended to be used as a sort of 'concussion' grenade."
	name = "Model 21 Stielhandgranate"
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "kr_sticknade"
	item_state = "flashbang"

/obj/item/grenade/stielhandgranate/detonate()
	explosion(src.loc, 0, 0, 2, 6)
	qdel(src)

//russia

/obj/item/clothing/under/urist/wwii/sovietrifleman
	name = "Red Army rifleman's uniform"
	desc = "A uniform commonly worn by Red Army riflemen."
	icon_state = "ru_rifleman"
	item_state = "ru_rifleman"

/obj/item/clothing/under/urist/wwii/sovietofficer
	name = "Red Army officer's uniform"
	desc = "A uniform commonly worn by Red Army officers."
	icon_state = "ru_officer"
	item_state = "ru_officer"

/obj/item/clothing/head/helmet/urist/wwii/soviethelm
	name = "Red Army helmet"
	desc = "The standard helmet of the Red Army."
	icon_state = "ru_helmet"
	item_state = "ru_helmet"
	armor = list(melee = 50, bullet = 15, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/head/urist/wwii/sovietofficer
	name = "Red Army officer's cap"
	desc = "A cap commonly worn by Red Army officers."
	icon_state = "ru_officap"
	item_state = "ru_officap"

/obj/item/clothing/shoes/urist/wwii/sovietboots
	name = "Red Army jackboots"
	desc = "A pair of boots, typically found on dead people named Ivan."
	icon_state = "ru_boots"
	item_state = "ru_boots"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 5, bio = 0, rad = 0)

/obj/item/storage/backpack/urist/soviet
	name = "Red Army rucksack"
	desc = "A rucksack typically worn by Red Army riflemen."
	icon_state = "ru_rucksack"
	item_state = "ru_rucksack"

/obj/item/clothing/accessory/storage/webbing_soviet
	name = "Red Army webbing"
	desc = "A large collection of pockets and pouches worn by Red Army riflemen."
	icon = 'icons/urist/items/clothes/ties.dmi'
	icon_override = 'icons/uristmob/ties.dmi'
	icon_state = "ru_webbing"
	slots = 4

/obj/item/clothing/suit/urist/wwii/soviet
	name = "Red Army overcoat"
	desc = "An overcoat worn by Soviet soldiers."
	icon_state = "ru_rmcoat"
	item_state = "ru_rmcoat"
	blood_overlay_type = "coatblood"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list(/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/grenade)
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

//guns //making the different calibres for germany was stupid. I'm just going to collapse the 7.62�38mmR, 7.62�54mmR and 7.62�25mm Tokarev into just 7.62mm. They're all going to use the same projectile anyways, so fuck it

/obj/item/gun/projectile/manualcycle/mosinnagant
	item_icons = DEF_URIST_INHANDS
	name = "Mosin-Nagant"
	icon = 'icons/urist/items/guns.dmi'
	desc = "The standard bolt action rifle of the Red Army. The glorious Soviet Moist Nugget is chambered in 7.62 and holds 5 rounds, fed by a stripper clip."
	wielded_item_state = "rifle2"
	icon_state = "mosin"
	item_state = "rifle2" //maybe change this
	w_class = 5
	one_hand_penalty = 4
	force = 10
	slot_flags = SLOT_BACK
	caliber = CALIBER_RIFLE_MILITARY
	handle_casings = HOLD_CASINGS
//	load_method = SINGLE_CASING
	max_shells = 5
	ammo_type = /obj/item/ammo_casing/rifle/military
//	accuracy = -1
//	jam_chance = 5
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'

/obj/item/ammo_magazine/rifle/military/stripper
	name = "stripper clip"
	icon_state = "stripper"
	max_ammo = 5
	multiple_sprites = 1
	mag_type = SPEEDLOADER
	matter = list(DEFAULT_WALL_MATERIAL = 1500)

/obj/item/ammo_magazine/rifle/military/svt40mag
	name = "SVT-40 magazine"
	icon_state = "svtmag"
	max_ammo = 10

/obj/item/ammo_magazine/rifle/military/svt40mag/empty
	initial_ammo = 0

/obj/item/gun/projectile/svt40
	item_icons = DEF_URIST_INHANDS
	name = "\improper SVT-40"
	desc = "The standard semi-automatic rifle of the Red Army, chambered in 7.62. Holds 10 rounds."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "svt40"
	item_state = "rifle2"
	w_class = 4
	force = 10
	caliber = CALIBER_RIFLE_MILITARY
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/rifle/military/svt40mag
	allowed_magazines = list(/obj/item/ammo_magazine/rifle/military/svt40mag)
	one_hand_penalty = 4
	wielded_item_state = "woodarifle-wielded"
	max_shells = 10

/obj/item/gun/projectile/svt40/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "svt40"
	else
		icon_state = "svt40-empty"
	return

/obj/item/gun/projectile/automatic/bar
	item_icons = DEF_URIST_INHANDS
	name = "\improper M1918 BAR"
	desc = "The M1918 Browning Automatic Rifle, a US Army support LMG. Chambered in 30-06, it holds 20 rounds."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "bar"
	item_state = "bar"
	w_class = 4
	force = 10
	caliber = CALIBER_RIFLE_MILITARY //i mean... 30-06 is 7.62, so fuck it.
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/rifle/military/barmag
	allowed_magazines = list(/obj/item/ammo_magazine/rifle/military/barmag)
	one_hand_penalty = 4
	fire_sound = 'sound/weapons/gunshot/gunshot2.ogg'
	wielded_item_state = "genericrifle-wielded"

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

/obj/item/ammo_magazine/rifle/military/barmag
	name = "BAR magazine" //shhhh
	icon_state = "bar_mag"
	ammo_type = /obj/item/ammo_casing/rifle/military
	max_ammo = 20

/obj/item/ammo_magazine/rifle/military/barmag/empty
	initial_ammo = 0

/obj/item/gun/projectile/automatic/ppsh
	item_icons = DEF_URIST_INHANDS
	name = "PPSh-41"
	desc = "The standard sub-machinegun of the Red Army. Only fires in short and long bursts. Takes drum magazines of 71 7.62x25mm rounds."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "ppsh41"
	item_state = "ppsh"
	w_class = 3
	force = 8
	caliber = CALIBER_PISTOL_SMALL
	slot_flags = SLOT_BELT || SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/pistol/ppsh
	allowed_magazines = list(/obj/item/ammo_magazine/pistol/ppsh)
	one_hand_penalty = 1
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	firemodes = list(
		list(mode_name="short bursts",	burst=4, fire_delay=null, move_delay=6, one_hand_penalty = 2, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	burst=8, fire_delay=null, move_delay=8, one_hand_penalty = 3, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/automatic/ppsh/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "ppsh41"
	else
		icon_state = "ppsh41-empty"
	return

/obj/item/ammo_magazine/pistol/ppsh
	name = "PPSh-41 drum magazine" //7.62x25 is close enough to 9mm actually, so fuck it
	icon_state = "ppsh_drum"
	icon = 'icons/urist/items/guns.dmi'
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 71

/obj/item/ammo_magazine/pistol/ppsh/empty
	initial_ammo = 0

/obj/item/gun/projectile/tt33
	name = "\improper TT-33"
	desc = "The standard service pistol of the Red Army. Chambered in 7.62x25mm, the magazine holds 8 rounds."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "tt33"
	item_state = "gun"
	w_class = 2
	caliber = CALIBER_PISTOL_SMALL
	fire_sound = 'sound/weapons/gunshot/Gunshot_pistol.ogg'
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/pistol/tt33
	allowed_magazines = list(/obj/item/ammo_magazine/pistol/tt33)

/obj/item/gun/projectile/tt33/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "tt33"
	else
		icon_state = "tt33-empty"
	return

/obj/item/ammo_magazine/pistol/tt33
	icon = 'icons/urist/items/guns.dmi'
	name = "TT-33 magazine"
	icon_state = "tt33mag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 8

/obj/item/ammo_magazine/pistol/tt33/empty
	initial_ammo = 0

/obj/item/gun/projectile/revolver/nagantm1895
	name = "Nagant M1895"
	desc = "The standard sidearm for officers in the Red Army. Chambered in 7.62mm"
	icon_state = "nagant"
	icon = 'icons/urist/items/guns.dmi'
	item_state = "revolver"
	caliber = CALIBER_RIFLE_MILITARY
	w_class = 2
	handle_casings = CYCLE_CASINGS
	max_shells = 7
	ammo_type = /obj/item/ammo_casing/rifle/military

/obj/item/ammo_magazine/r762
	name = "speed loader"
	icon_state = "T38"
	caliber = CALIBER_RIFLE_MILITARY
	ammo_type = /obj/item/ammo_casing/rifle/military
	max_ammo = 7
	multiple_sprites = 1

/obj/item/gun/projectile/automatic/degtyaryov
	item_icons = DEF_URIST_INHANDS
	name = "Degtyaryov machine gun"
	desc = "The standard light machinegun of the Red Army. Only fires in short and long bursts. Takes pan magazines of 60 7.62mm rounds."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "DT"
	item_state = "l6closedmag"
	w_class = 5
	force = 8
	caliber = CALIBER_RIFLE_MILITARY
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/rifle/military/degtyaryov
	allowed_magazines = list(/obj/item/ammo_magazine/rifle/military/degtyaryov)
	wielded_item_state = "genericLMG-wielded"
	one_hand_penalty = 6
	max_shells = 60
	firemodes = list(
		list(mode_name="short bursts",	burst=5, move_delay=12, one_hand_penalty=8, burst_accuracy = list(0,-1,-1,-2,-2),          dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	burst=8, move_delay=15, one_hand_penalty=9, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/automatic/degtyaryov/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "DT"
	else
		icon_state = "DT-empty"
	return

/obj/item/ammo_magazine/rifle/military/degtyaryov
	name = "Degtyaryov pan magazine"
	icon_state = "DTmag"
	icon = 'icons/urist/items/guns.dmi'
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/rifle/military
	max_ammo = 60 //only the vehicle mounted version had 60 round mags, but fuck it.

/obj/item/ammo_magazine/rifle/military/degtyaryov/empty
	initial_ammo = 0

/obj/item/grenade/frag/sovietgrenade
	desc = "A small explosive meant for anti-personnel use."
	name = "F1 fragmentation grenade"
	icon = 'icons/urist/items/uristweapons.dmi'
	icon_state = "rusk_nade"
