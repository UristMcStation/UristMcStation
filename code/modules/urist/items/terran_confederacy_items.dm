//formerly terran_defence_force_items.dm. Now it is home to all the Terran Confederacy gear, for convenience. Terran marine gear has been moved here from the urist clothes folder.
//non-TDF Terran weapons are still in the ANFOR weapons file


//terran defence forces gear

//suits and under

/obj/item/clothing/under/urist/terran/tdftrooper
	name = "Defence Force trooper fatigues"
	desc = "A standard set of Terran Defence Force trooper's fatigues, in desert colours. Wearing these makes you feel ready to defend the colonies. However, wearing these out in the desert heat would almost make a person wish for a nuclear winter..."
	icon_state = "ncr_uniform"
	item_state = "ncr_uniform"

/obj/item/clothing/under/urist/terran/tdfofficer
	name = "Defence Force officer fatigues"
	desc = "A standard set of Terran Defence Force officer's fatigues, in desert colours. Wearing these makes you feel ready to lead a defence of the colonies. However, wearing these out in the desert heat would almost make a person wish for a nuclear winter..."
	icon_state = "ncr_officer"
	item_state = "ncr_officer"

/obj/item/clothing/suit/urist/terran/tdfrangerarmor
	name = "Defence Force ranger armour"
	desc = "An armoured vest underneath the classic ranger duster, this is the typical set of armour worn by the Terran Defence Force Rangers. The Rangers are an elite branch of the Terran Defence Forces that are stationed in colonies on the edge of colonized space. Although they mainly defend against local wildlife and the occasional pirate attack, they are well armed and well equipped."
	icon_state = "ranger2"
	item_state = "ranger2"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	armor = list(melee = 55, bullet = 40, laser = 30, energy = 10, bomb = 25, bio = 0, rad = 0)
	allowed = list(/obj/item/gun/energy,/obj/item/device/radio,/obj/item/reagent_containers/spray/pepper,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/gun/magnetic,/obj/item/tank/oxygen_emergency,/obj/item/device/flashlight)

/obj/item/clothing/suit/space/void/tdfrangerarmor
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/clothes.dmi'
	allowed = list(/obj/item/device/suit_cooling_unit,/obj/item/gun/energy,/obj/item/device/radio,/obj/item/reagent_containers/spray/pepper,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/gun/magnetic,/obj/item/tank,/obj/item/device/flashlight)
	armor = list(melee = 65, bullet = 50, laser = 40,energy = 15, bomb = 35, bio = 100, rad = 30)
	name = "Defence Force ranger voidsuit"
	desc = "A heavily reinforced voidsuit used by the Terran Defence Force Rangers in extenuating circumstances, such as chasing down pirate vessels. The Rangers are an elite branch of the Terran Defence Forces that are stationed in colonies on the edge of colonized space. Although they mainly defend against local wildlife and the occasional pirate attack, they are well armed and well equipped."
	icon_state = "elite_riot"
	item_state = "elite_riot"

/obj/item/clothing/suit/urist/terran/tdfarmor
	name = "Defence Force armour vest"
	desc = "An armoured vest, typically used by the Terran Defence Force. Not the strongest thing, but it gets the job done."
	icon_state = "ncr_vest"
	item_state = "ncr_vest"
	armor = list(melee = 45, bullet = 15, laser = 40, energy = 10, bomb = 25, bio = 0, rad = 0)
	allowed = list(/obj/item/gun/energy,/obj/item/device/radio,/obj/item/reagent_containers/spray/pepper,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/gun/magnetic,/obj/item/tank/oxygen_emergency,/obj/item/device/flashlight)

/obj/item/clothing/suit/urist/terran/tdfreinfarmor
	name = "Defence Force reinforced armour vest"
	desc = "A reinforced armoured vest, typically used by the Terran Defence Force. Still not the strongest thing, but it gets the job done."
	icon_state = "ncr_mantle"
	item_state = "ncr_mantle"
	armor = list(melee = 50, bullet = 20, laser = 50, energy = 15, bomb = 25, bio = 0, rad = 0)
	allowed = list(/obj/item/gun/energy,/obj/item/device/radio,/obj/item/reagent_containers/spray/pepper,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/gun/magnetic,/obj/item/tank/oxygen_emergency,/obj/item/device/flashlight)

/obj/item/clothing/suit/urist/terran/tdfrangerpatrol
	name = "ranger patrol armor"
	desc = "A set of standard issue Terran Defence Force Ranger patrol armor that provides a decent amount of defence. Capable enough to handle most day-to-day threats in the outer colonies of the Terran Confederacy."
	icon_state = "ncr_patrol"
	item_state = "ncr_patrol"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	armor = list(melee = 50, bullet = 25, laser = 40, energy = 15, bomb = 25, bio = 0, rad = 0)
	allowed = list(/obj/item/gun/energy,/obj/item/device/radio,/obj/item/reagent_containers/spray/pepper,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/gun/magnetic,/obj/item/tank/oxygen_emergency,/obj/item/device/flashlight)

//head

/obj/item/clothing/head/helmet/urist/terran/tdfhelmet
	name = "Defence Force Helmet"
	desc = "A standard issue Terran Defence Force combat helmet."
	icon_state = "ncr_helmet"
	item_state = "ncr_helmet"
	armor = list(melee = 50, bullet = 35, laser = 40,energy = 25, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/urist/terran/tdfberet
	name = "Defence Force Officer's Beret"
	desc = "A green beret, standard issue for all commissioned Terran Defence Force officers."
	icon_state = "ncr_beret"
	item_state = "ncr_beret"
	armor = list(melee = 15, bullet = 0, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/urist/terran/tdfranger
	name = "Ranger Hat"
	desc = "A Terran Defence Force Ranger hat, standard issue amongst all patrol rangers."
	icon_state = "drill_hat"
	item_state = "drill_hat"
	armor = list(melee = 15, bullet = 5, laser = 15, energy = 10, bomb = 5, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/urist/terran/tdfrangerhelmet
	name = "Defence Force Ranger helmet"
	desc = "A standard issue Terran Defence Force Ranger combat helmet. It's relatively strong, and covers the whole face."
	icon_state = "ranger"
	item_state = "ranger"
	armor = list(melee = 55, bullet = 40, laser = 30,energy = 25, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/space/void/tdfhelmet
	name = "Defence Force Ranger voidsuit helmet"
	desc = "A heavily reinforced voidsuit helmet used by the Terran Defence Force Rangers."
	icon_state = "elite_riot"
	item_state = "elite_riot"
	light_overlay = "helmet_light_dual"
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/head.dmi'
	armor = list(melee = 65, bullet = 50, laser = 40,energy = 15, bomb = 35, bio = 100, rad = 30)

/obj/item/ammo_magazine/c10mm
	name = "TD-10 SMG magazine"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "smg10mm"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL
	matter = list(DEFAULT_WALL_MATERIAL = 1500)
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 24
	multiple_sprites = 1

/obj/item/ammo_magazine/c10mm/TD10
	name = "TD-10 Pistol magazine"
	icon_state = "10mmadv"
	max_ammo = 12
	multiple_sprites = 1

/obj/item/ammo_magazine/c10mm/empty
	initial_ammo = 0

/obj/item/gun/projectile/td10_pistol
	name = "\improper TD-10 Pistol"
	desc = "The standard 10mm service pistol of the Terran Defence Force. It shares a number of parts with the SMG version of the TD-10 series. Rugged and durable, the TD-10 pistol is the best choice for frontier rangers."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "pistol10mm"
	item_state = "gun"
	w_class = 2
	caliber = CALIBER_PISTOL
	fire_sound = 'sound/weapons/gunshot/Gunshot_pistol.ogg'
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c10mm/TD10
	allowed_magazines = list(/obj/item/ammo_magazine/c10mm/TD10)

/obj/item/gun/projectile/td10_pistol/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "pistol10mm"
	else
		icon_state = "pistol10mm-empty"
	return

/obj/item/gun/projectile/automatic/td10_smg
	item_icons = DEF_URIST_INHANDS
	name = "\improper TD-10 SMG"
	desc = "The standard 10mm submachine gun of the Terran Defence Force. It shares many parts with the pistol version of the TD-10, and even accepts TD-10 pistol magazines. This is handy for far flung frontier worlds where parts may be scarce."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "smg10mm-fo"
	item_state = "smg10mm-fo"
	w_class = 3
	force = 10
	caliber = CALIBER_PISTOL
	origin_tech = "combat=4;materials=1;syndicate=1"
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c10mm
	allowed_magazines = list(/obj/item/ammo_magazine/c10mm, /obj/item/ammo_magazine/c10mm/TD10)
	one_hand_penalty = 1
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, one_hand_penalty = 1, move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, move_delay=6, fire_delay=null, one_hand_penalty = 2, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.0, 0.6, 0.6)),
		list(mode_name="short bursts", 	burst=5, move_delay=6, fire_delay=null, one_hand_penalty = 3, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/automatic/td10_smg/on_update_icon()
	if(ammo_magazine)
		icon_state = "smg10mm-fo"
	else
		icon_state = "smg10mm-fo-empty"

/obj/item/card/id/terran
	color = COLOR_GRAY40
	detail_color = COLOR_VIOLET

/obj/item/card/id/terran/tdf
	name = "\improper Terran Defence Force ID"
	desc = "An ID worn by someone in the Terran Defence Force"
	registered_name = "Terran Defence Force"
	assignment = "Ranger"
	extra_details = list("goldstripe")

//terran marine stuff, now delineated into space vs ground.

/obj/item/clothing/suit/space/void/terran_marine
	item_icons = URIST_ALL_ONMOBS
	name = "Terran Confederacy Marine voidsuit"
	desc = "A heavily armored suit that protects against moderate damage and the rigours of space. Worn by Terran Marines during boarding operations. It reeks of oppression and corruption."
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "terran_void_marine"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	allowed = list(/obj/item/gun,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/tank/oxygen_emergency,/obj/item/melee/energy/sword)
	armor = list(melee = 65, bullet = 65, laser = 40,energy = 20, bomb = 40, bio = 100, rad = 30)
	can_breach = 0

/obj/item/clothing/suit/space/void/commando/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1

/obj/item/clothing/suit/storage/urist/terran_marine
	name = "Terran Confederacy Marine armour"
	desc = "A heavy armour vest worn by Terran Confederacy Marines serving aboard Terran Naval vessels."
	icon_state = "terran_armour"
	item_state = "terran_armour"
	armor = list(melee = 60, bullet = 55, laser = 40, energy = 10, bomb = 25, bio = 0, rad = 0)

	allowed = list(/obj/item/gun/energy,/obj/item/device/radio,/obj/item/reagent_containers/spray/pepper,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/gun/magnetic,/obj/item/tank)

	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	item_flags = ITEM_FLAG_THICKMATERIAL
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.6

/obj/item/clothing/suit/storage/urist/terran_officer
	name = "Terran Confederacy Marine Officer armour"
	desc = "A light armour vest worn by officers in the Terran Confederacy Marine Corps serving aboard Terran Naval vessels.."
	icon_state = "terran_armour_officer"
	item_state = "terran_armour_officer"
	armor = list(melee = 55, bullet = 40, laser = 35, energy = 10, bomb = 15, bio = 0, rad = 0)

	allowed = list(/obj/item/gun/energy,/obj/item/device/radio,/obj/item/reagent_containers/spray/pepper,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/gun/magnetic,/obj/item/tank)

	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	item_flags = ITEM_FLAG_THICKMATERIAL
	cold_protection = UPPER_TORSO|LOWER_TORSO
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.6

/obj/item/clothing/under/urist/terran/marine
	name = "Terran Confederacy Marine uniform"
	desc = "A grey uniform worn by the Terran Confederacy Marines serving aboard Naval vessels."
	icon_state = "terran_uniform"
	item_state = "terran_uniform"

/obj/item/clothing/head/urist/terran/officercap
	name = "Terran Confederacy Marine officer cap"
	desc = "A grey cap bearing the crest of the Terran Confederacy Marines, the land service branch of the powerful Terran Navy, and the primary land service branch of the Terran Confederacy Armed Forces."
	icon_state = "greyutility"

/obj/item/clothing/head/helmet/space/void/terran_marine
	item_icons = URIST_ALL_ONMOBS
	name = "Terran Confederacy Marine voidsuit"
	desc = "A grey reinforced helmet worn by Terran Confederacy Marines, serving aboard Naval vessels."
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_state = "terran_void_helm"
	armor = list(melee = 65, bullet = 65, laser = 35,energy = 20, bomb = 40, bio = 100, rad = 30)

/obj/item/clothing/head/helmet/urist/terran_marine
	name = "Terram Confederacy Marine helmet"
	desc = "A grey protective helmet, standard issue for all Terran Confederacy Marines serving aboard Naval vessels."
	icon_state = "terran_helm"
	armor = list(melee = 50, bullet = 55, laser = 30, energy = 25, bomb = 30, bio = 0, rad = 0)
	var/obj/item/storage/fancy/smokable/cigs

/obj/item/card/id/terran/marine
	name = "\improper Terran Marine ID"
	desc = "An ID worn by someone in the Terran Confederacy Marines, the land service branch of the powerful Terran Navy, and the primary land service branch of the Terran Confederacy Armed Forces."
	registered_name = "Terran Confederacy Marine Corps."
	assignment = "Marine"

//slight resprites, renames, and tweaks of anfor stuff

/obj/item/clothing/suit/storage/urist/armor/anfor/terran/nco
	name = "Terran Marine NCO armour"
	desc = "The M3 PPA, standard issue armour for Terran Marines serving in ground assault forces, and ANFOR marines during the Galactic Crisis. This one has the markings of a Non-Commissioned Officer."
	icon_state = "ANFOR-cmdsuit-terran"

/obj/item/clothing/suit/storage/urist/armor/anfor/terran
	name = "Terran Marine armour"
	desc = "The M3 PPA, standard issue armour for Terran Marines serving in ground assault forces, and ANFOR marines during the Galactic Crisis. This one has the markings of a standard marine."
	icon_state = "ANFOR-suit"

/obj/item/clothing/under/urist/anfor/terran
	name = "Terran Marine BDU"
	desc = "An olive drab Battle Dress Uniform, standard issue for Terran Marines serving in ground assault forces."

/obj/item/clothing/head/helmet/urist/anfor/terran
	name = "Terran Marine helmet"
	desc = "An olive drab M10 protective helmet, standard issue for all Terran Marines serving in ground assault forces. This one has the markings of a standard marine."

/obj/item/clothing/head/urist/anfor/terran
	item_icons = URIST_ALL_ONMOBS
	name = "Terran Marine NCO cap"
	desc = "A cap worn by Terran Marine NCOs in ground assault forces. Doesn't offer much protection, but it bears the crest of the Terran Confederacy Marines, the land service branch of the powerful Terran Navy, and the primary land service branch of the Terran Confederacy Armed Forces."

/obj/item/clothing/suit/space/void/anfor/terran
	name = "\improper Terran Marine voidsuit"
	desc = "A heavily armored suit that protects against moderate damage. Used by Terran Marines serving in ground assault forces when exposure to the cold dark void of space is likely."
	icon_state = "ANFOR-evasuit-terran"

/obj/item/clothing/head/helmet/space/void/anfor/terran
	name = "Terran Marine voidsuit helmet"
	desc = "A comfortable voidsuit helmet used by Terran Marines serving in ground assault forces. Features cranial armor and eight-channel surround sound."
