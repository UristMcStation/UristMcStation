/* Urist - Russian Faction - World War 2 /////
Contents:
	Firearms
	Firearm Magazines
	Explosives
	Clothing
*/

// Russia - Firearms

// Firearms - Rifles & Semi-Automatic

/obj/item/gun/projectile/manualcycle/mosinnagant
	item_icons = DEF_URIST_INHANDS
	name = "Mosin-Nagant"
	icon = 'icons/urist/guns/ww2_rus.dmi'
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
	max_shells = 5
	ammo_type = /obj/item/ammo_casing/rifle/military
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'

/obj/item/gun/projectile/svt40
	item_icons = DEF_URIST_INHANDS
	name = "\improper SVT-40"
	desc = "The standard semi-automatic rifle of the Red Army, chambered in 7.62. Holds 10 rounds."
	icon = 'icons/urist/guns/ww2_rus.dmi'
	icon_state = "svt40"
	item_state = "rifle2"
	w_class = ITEM_SIZE_LARGE
	force = 10
	caliber = CALIBER_RIFLE_MILITARY
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/rifle/military/svt40mag
	allowed_magazines = /obj/item/ammo_magazine/rifle/military/svt40mag
	ammo_type = /obj/item/ammo_casing/rifle/military
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

// Firearms - Machine Guns

/obj/item/gun/projectile/automatic/dp27
	name = "DP-27" // It's more recognisable as this than the other name, personally - Y
	desc = "The standard infantry light machinegun of the Red Army. Capable of firing in short & long bursts and full-auto. Takes pan magazines of 60 7.62mm rounds."
	item_icons = DEF_URIST_INHANDS
	icon = 'icons/urist/guns/ww2_rus.dmi'
	icon_state = "DT"
	item_state = "genericLMG-wielded" // fixes weird sprite changes for now.
	wielded_item_state = "genericLMG-wielded"
	w_class = ITEM_SIZE_LARGE
	caliber = CALIBER_RIFLE_MILITARY
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/rifle/military/dp27
	allowed_magazines = /obj/item/ammo_magazine/rifle/military/dp27
	ammo_type = /obj/item/ammo_casing/rifle/military
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	one_hand_penalty = 6
	max_shells = 60
	force = 8
	firemodes = list(
		list(mode_name="short bursts",	burst=5, move_delay=12, one_hand_penalty=8, burst_accuracy = list(0,-1,-1,-2,-2),          dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	burst=8, move_delay=15, one_hand_penalty=9, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="full auto",		can_autofire=1, burst=1, fire_delay=0.3, one_hand_penalty=7, burst_accuracy = list(0,-1,-2,-3,-4,-4,-4,-4,-4), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/automatic/dp27/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "DT"
	else
		icon_state = "DT-empty"
	return

// Firearms - SMGs

/obj/item/gun/projectile/automatic/ppsh
	item_icons = DEF_URIST_INHANDS
	name = "PPSh-41"
	desc = "The standard sub-machinegun of the Red Army. Only fires in short and long bursts. Takes drum magazines of 71 7.62x25mm rounds."
	icon = 'icons/urist/guns/ww2_rus.dmi'
	icon_state = "ppsh41"
	item_state = "ppsh"
	wielded_item_state = "ppsh" // fixes fallback to mp7 sprite
	w_class = ITEM_SIZE_NORMAL
	caliber = CALIBER_PISTOL_SMALL
	slot_flags = SLOT_BELT | SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/pistol/ppsh
	allowed_magazines = /obj/item/ammo_magazine/pistol/ppsh
	ammo_type = /obj/item/ammo_casing/pistol/small
	one_hand_penalty = 1
	force = 8
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	firemodes = list(
		list(mode_name="semi auto",       burst=1, fire_delay=null,    move_delay=null, one_hand_penalty=0, burst_accuracy=null, dispersion=null),
		list(mode_name="full auto",		can_autofire=1, burst=1, fire_delay=0.2, one_hand_penalty=4, burst_accuracy = list(0,-1,-2,-3,-4,-4,-4,-4,-4), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/automatic/ppsh/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "ppsh41"
	else
		icon_state = "ppsh41-empty"
	return

// Firearms - Pistols & Revolvers

/obj/item/gun/projectile/pistol/tt33
	name = "\improper TT-33"
	desc = "The standard service pistol of the Red Army. Chambered in 7.62x25mm, the magazine holds 8 rounds."
	icon = 'icons/urist/guns/ww2_rus.dmi'
	icon_state = "tt33"
	item_state = "gun"
	w_class = ITEM_SIZE_SMALL
	caliber = CALIBER_PISTOL_SMALL
	slot_flags = SLOT_BELT | SLOT_POCKET | SLOT_HOLSTER
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/pistol/tt33
	allowed_magazines = /obj/item/ammo_magazine/pistol/tt33
	ammo_type = /obj/item/ammo_casing/pistol/small
	fire_sound = 'sound/weapons/gunshot/Gunshot_pistol.ogg'

/obj/item/gun/projectile/pistol/tt33/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "tt33"
	else
		icon_state = "tt33-empty"
	return

/obj/item/gun/projectile/revolver/nagantm1895
	name = "Nagant M1895"
	desc = "The standard sidearm for officers in the Red Army. Chambered in 7.62mm"
	icon_state = "nagant"
	icon = 'icons/urist/guns/ww2_rus.dmi'
	item_state = "revolver"
	caliber = CALIBER_RIFLE_MILITARY
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT | SLOT_POCKET | SLOT_HOLSTER
	handle_casings = CYCLE_CASINGS
	load_method = SPEEDLOADER
	max_shells = 7
	ammo_type = /obj/item/ammo_casing/rifle/military
	allowed_magazines = /obj/item/ammo_magazine/speedloader/nagant
	magazine_type = /obj/item/ammo_magazine/speedloader/nagant



// Russia - Firearm Magazines

// Rifles & Semi-Automatic - Ammo & Magazines

/obj/item/ammo_magazine/rifle/military/stripper
	name = "stripper clip"
	icon = 'icons/urist/guns/ammo_ww2.dmi'
	desc = "A stripper clip capable of holding 5.56 rounds."
	icon_state = "stripper"
	max_ammo = 5
	multiple_sprites = 1
	mag_type = SPEEDLOADER
	matter = list(DEFAULT_WALL_MATERIAL = 1500)

/obj/item/ammo_magazine/rifle/military/svt40mag
	name = "SVT-40 magazine"
	desc = "A box magazine for the SVT-40. Chambered in 5.56mm." // It isn't 5.56, but we ball.
	icon = 'icons/urist/guns/ammo_ww2.dmi'
	icon_state = "svtmag"
	max_ammo = 10

/obj/item/ammo_magazine/rifle/military/svt40mag/empty
	initial_ammo = 0

// Machine Guns - Ammo & Magazines

/obj/item/ammo_magazine/rifle/military/dp27
	name = "DP-27 pan magazine"
	desc = "A pan magazined for the DP-27, capable of holding 60 rounds of 5.56mm."
	icon_state = "DTmag"
	icon = 'icons/urist/guns/ammo_ww2.dmi'
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE_MILITARY
	ammo_type = /obj/item/ammo_casing/rifle/military
	max_ammo = 60 //only the vehicle mounted version had 60 round mags, but fuck it.

/obj/item/ammo_magazine/rifle/military/dp27/empty
	initial_ammo = 0

// SMG - Ammo & Magazines

/obj/item/ammo_magazine/pistol/ppsh
	name = "PPSh-41 drum magazine" //7.62x25 is close enough to 9mm actually, so fuck it
	desc = "A drum magazine for the PPSh-41, capable of holding 71 rounds of 9mm."
	icon_state = "ppsh_drum"
	icon = 'icons/urist/guns/ammo_ww2.dmi'
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 71

/obj/item/ammo_magazine/pistol/ppsh/empty
	initial_ammo = 0

// Pistols & Revolvers - Ammo & Magazines

/obj/item/ammo_magazine/pistol/tt33
	icon = 'icons/urist/guns/ammo_ww2.dmi'
	name = "TT-33 pistol magazine"
	desc = "A TT-33 pistol magazine, chambered in 9mm."
	icon_state = "tt33mag"
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 8

/obj/item/ammo_magazine/pistol/tt33/empty
	initial_ammo = 0

/obj/item/ammo_magazine/speedloader/nagant
	name = "nagant revolver speed loader"
	desc = "A 7.62mm speedloader for the Nagant Revolver."
	icon_state = "T38"
	caliber = CALIBER_RIFLE_MILITARY
	ammo_type = /obj/item/ammo_casing/rifle/military
	max_ammo = 7
	multiple_sprites = 1



// Russia - Explosives

/obj/item/grenade/frag/sovietgrenade
	desc = "A small fragmenting grenade meant for anti-personnel use."
	name = "F1 fragmentation grenade"
	icon = 'icons/urist/weapons/grenades.dmi'
	icon_state = "rusk_nade"
	arm_sound = 'sound/effects/flare.ogg' // Closest thing to old fuse sounds.



// Russia - Clothing

// Under / Uniforms

/obj/item/clothing/under/urist/ww2/sovietrifleman
	name = "Red Army rifleman's uniform"
	desc = "A uniform commonly worn by Red Army riflemen."
	icon_state = "ru_rifleman"
	item_state = "ru_rifleman"
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		bullet = ARMOR_BALLISTIC_MINOR) // Better than nothing.

/obj/item/clothing/under/urist/ww2/sovietofficer
	name = "Red Army officer's uniform"
	desc = "A uniform commonly worn by Red Army officers."
	icon_state = "ru_officer"
	item_state = "ru_officer"
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_SMALL) // Better than nothing.

// Suits

/obj/item/clothing/suit/urist/ww2/soviet
	name = "Red Army overcoat"
	desc = "An overcoat worn by Soviet soldiers."
	icon_state = "ru_rmcoat"
	item_state = "ru_rmcoat"
	blood_overlay_type = "coatblood"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list(/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/grenade)
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_MINOR)

// Head

/obj/item/clothing/head/helmet/urist/ww2/soviethelm
	name = "Red Army helmet"
	desc = "The standard helmet of the Red Army."
	icon_state = "ru_helmet"
	item_state = "ru_helmet"
	armor = list(melee = 50, bullet = 15, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/head/urist/ww2/sovietofficer
	name = "Red Army officer's cap"
	desc = "A cap commonly worn by Red Army officers."
	icon_state = "ru_officap"
	item_state = "ru_officap"

// Shoes

/obj/item/clothing/shoes/urist/ww2/sovietboots
	name = "Red Army jackboots"
	desc = "A pair of boots, typically found on dead people named Ivan."
	icon_state = "ru_boots"
	item_state = "ru_boots"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 5, bio = 0, rad = 0)

// Storage

/obj/item/storage/backpack/urist/ww2/soviet
	name = "Red Army rucksack"
	desc = "A rucksack typically worn by Red Army riflemen."
	icon_state = "ru_rucksack"
	item_state = "ru_rucksack"

/obj/item/clothing/accessory/storage/ww2/webbing_soviet
	name = "Red Army webbing"
	desc = "A large collection of pockets and pouches worn by Red Army riflemen."
	icon = 'icons/urist/items/clothes/ties.dmi'
	icon_override = 'icons/uristmob/ties.dmi'
	accessory_icons = list(slot_w_uniform_str = 'icons/uristmob/ties.dmi')
	icon_state = "ru_webbing"
	slots = 4 STORAGE_SLOTS
	body_location = UPPER_TORSO
