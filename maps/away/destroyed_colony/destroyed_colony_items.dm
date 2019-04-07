//items for the destroyed colony map, possibly will find use elsewhere. Terran defence forces shit mostly.

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
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/device/radio,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/gun/magnetic,/obj/item/weapon/tank/emergency,/obj/item/device/flashlight)

/obj/item/clothing/suit/space/void/tdfrangerarmor
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/clothes.dmi'
	allowed = list(/obj/item/device/suit_cooling_unit,/obj/item/weapon/gun/energy,/obj/item/device/radio,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/gun/magnetic,/obj/item/weapon/tank,/obj/item/device/flashlight)
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
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/device/radio,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/gun/magnetic,/obj/item/weapon/tank/emergency,/obj/item/device/flashlight)

/obj/item/clothing/suit/urist/terran/tdfreinfarmor
	name = "Defence Force reinforced armour vest"
	desc = "A reinforced armoured vest, typically used by the Terran Defence Force. Still not the strongest thing, but it gets the job done."
	icon_state = "ncr_mantle"
	item_state = "ncr_mantle"
	armor = list(melee = 50, bullet = 20, laser = 50, energy = 15, bomb = 25, bio = 0, rad = 0)
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/device/radio,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/gun/magnetic,/obj/item/weapon/tank/emergency,/obj/item/device/flashlight)

/obj/item/clothing/suit/urist/terran/tdfrangerpatrol
	name = "ranger patrol armor"
	desc = "A set of standard issue Terran Defence Force Ranger patrol armor that provides a decent amount of defence.."
	icon_state = "ncr_patrol"
	item_state = "ncr_patrol"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	armor = list(melee = 50, bullet = 25, laser = 40, energy = 15, bomb = 25, bio = 0, rad = 0)
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/device/radio,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/gun/magnetic,/obj/item/weapon/tank/emergency,/obj/item/device/flashlight)

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

/obj/item/clothing/head/helmet/urist/terran/tdfhelmet
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
	name = "TD-10 SMG magazine (10mm)"
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "smg10mm"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "10mm"
	matter = list(DEFAULT_WALL_MATERIAL = 1500)
	ammo_type = /obj/item/ammo_casing/a10mm
	max_ammo = 24
	multiple_sprites = 1

/obj/item/ammo_magazine/c10mm/TD10
	name = "TD-10 Pistol magazine (10mm)"
	icon_state = "10mmadv"
	max_ammo = 12
	multiple_sprites = 1

/obj/item/ammo_magazine/c10mm/empty
	initial_ammo = 0

/obj/item/weapon/gun/projectile/td10_pistol
	name = "\improper TD-10 Pistol"
	desc = "The standard 10mm service pistol of the Terran Defence Force. It shares a number of parts with the SMG version of the TD-10 series. Rugged and durable, the TD-10 pistol is the best choice for frontier rangers."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "pistol10mm"
	item_state = "gun"
	w_class = 2
	caliber = "10mm"
	fire_sound = 'sound/weapons/gunshot/Gunshot_pistol.ogg'
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c10mm/TD10
	allowed_magazines = list(/obj/item/ammo_magazine/c10mm/TD10)

/obj/item/weapon/gun/projectile/td10_pistol/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "pistol10mm"
	else
		icon_state = "pistol10mm-empty"
	return

/obj/item/weapon/gun/projectile/automatic/td10_smg
	item_icons = DEF_URIST_INHANDS
	name = "\improper TD-10 SMG"
	desc = "The standard 10mm submachine gun of the Terran Defence Force. It shares many parts with the pistol version of the TD-10, and even accepts TD-10 pistol magazines. This is handy for far flung frontier worlds where parts may be scarce."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "smg10mm-fo"
	item_state = "smg10mm-fo"
	w_class = 3
	force = 10
	caliber = "10mm"
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

/obj/item/weapon/gun/projectile/automatic/td10_smg/update_icon()
	if(ammo_magazine)
		icon_state = "smg10mm-fo"
	else
		icon_state = "smg10mm-fo-empty"