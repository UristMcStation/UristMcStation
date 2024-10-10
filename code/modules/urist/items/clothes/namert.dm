//vietnam clothing

/obj/item/clothing/suit/urist/armor/nam
	name = "jungle camo flak jacket"
	desc = "A flak jacket styled with jungle camouflage."
	icon_state = "namflakjacket"
	item_state = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 20, bio = 0, rad = 0)

/obj/item/clothing/under/urist/nam
	name = "jungle camo BDU"
	desc = "A BDU styled with jungle camouflage."
	icon_state = "namjumpsuit"
	item_state = "namjumpsuit"

/obj/item/clothing/head/helmet/urist/nam
	name = "jungle camo helmet"
	desc = "A helmet styled with jungle camouflage."
	icon_state = "namhelm"
	item_state = "namhelm"

/obj/item/clothing/head/helmet/urist/nam/officer
	name = "jungle camo officer's helmet"
	desc = "An officer's helmet styled with jungle camouflage."
	icon_state = "officerhelm"
	item_state = "officerhelm"

/obj/item/clothing/gloves/urist/nam
	name = "jungle camo gloves"
	desc = "A pair of gloves styled with jungle camouflage."
	icon_state = "namgloves"
	item_state = "namgloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 15, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/shoes/urist/nam
	name = "jungle camo boots"
	desc = "A pair of boots styled with jungle camouflage."
	icon_state = "namboots"
	item_state = "namboots"
	permeability_coefficient = 0.05
	item_flags = ITEM_FLAG_NOSLIP
	species_restricted = null
	siemens_coefficient = 0.6
	armor = list(melee = 50, bullet = 0, laser = 5,energy = 0, bomb = 5, bio = 10, rad = 0)
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/storage/belt/urist/nam
	name = "jungle camo belt"
	desc = "A belt styled with jungle camouflage. Can hold security gear like handcuffs and flashes."
	icon_state = "nambelt"
	item_state = "nambelt"
	storage_slots = 7
	max_w_class = 3
	max_storage_space = 28
	can_hold = list(
		/obj/item/grenade,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/handcuffs,
		/obj/item/device/flash,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_magazine,
		/obj/item/reagent_containers/food/snacks/donut,
		/obj/item/melee/baton,
		/obj/item/gun/energy/taser,
		/obj/item/flame/lighter,
		/obj/item/clothing/glasses/hud/security,
		/obj/item/device/flashlight,
		/obj/item/modular_computer/pda,
		/obj/item/device/radio/headset,
		/obj/item/device/hailer,
		/obj/item/device/megaphone,
		/obj/item/melee,
		/obj/item/gun/projectile/bhp9mm,
		/obj/item/gun/projectile/pistol/sec,
		/obj/item/taperoll/police
		)

/obj/item/storage/backpack/urist/nam
	name = "jungle camo backpack"
	desc = "A backpack styled with jungle camouflage."
	icon_state = "nambackpack"
	item_state = "nambackpack"
