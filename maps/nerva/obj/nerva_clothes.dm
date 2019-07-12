//Nerva specific clothing. I might move this into the urist folder, but for now, it's here.

/obj/item/clothing/under/urist/nerva/capformal
	name = "captain's formal outfit"
	desc = "A formal outfit for classy captains. This outfit gives off an aura of command."
	icon_state = "nervacapformal"
	item_state = "nervacapformal"
	worn_state = "nervacapformal"

/obj/item/clothing/under/urist/nerva/capregular
	name = "captain's casual outfit"
	desc = "A casual outfit worn by the captain of the ICS Nerva. Comprising of a very comfortable looking sweater and pants, this outfit is both stylish and practical."
	icon_state = "nervacapregular" //make the pants longer
	item_state = "nervacapregular"
	worn_state = "nervacapregular"

/obj/item/clothing/under/urist/nerva/foregular
	name = "first officer's uniform"
	desc = "The assigned uniform for the ICS Nerva's First Officer. More practical than stylish."
	icon_state = "nervafooutfit"
	item_state = "nervafooutfit"
	worn_state = "nervafooutfit"

/obj/item/clothing/under/urist/nerva/soregular
	name = "second officer's uniform"
	desc = "The assigned uniform for the ICS Nerva's Second Officer. More practical than stylish."
	icon_state = "nervasooutfit"
	item_state = "nervasooutfit"
	worn_state = "nervasooutfit"

/obj/item/clothing/under/urist/nerva/cosregular
	name = "chief of security's uniform"
	desc = "An intimidating black and red outfit that is the assigned uniform for the ICS Nerva's Chief of Security."
	icon_state = "nervacosregular"
	item_state = "nervacosregular"
	worn_state = "nervacosregular"

/obj/item/clothing/under/urist/nerva/secregular
	name = "security officer's uniform"
	desc = "An intimidating black and red outfit that is the assigned uniform for the ICS Nerva's security officers."
	icon_state = "nervasecregular"
	item_state = "nervasecregular"
	worn_state = "nervasecregular"

/obj/item/clothing/under/urist/nerva/secfield
	name = "security field uniform"
	desc = "A lighter unifrom for the ICS Nerva's security officers meant for excursions to habitable planets or stations, this outfit provides greater freedom of movement and comfort."
	icon_state = "nervasecfield"
	item_state = "nervasecfield"
	worn_state = "nervasecfield"

/obj/item/clothing/under/urist/nerva/qm
	name = "quartermaster's uniform"
	desc = "A stylish uniform worn by the ICS Nerva's quartermaster."
	icon_state = "qm"
	item_state = "qm"
	worn_state = "qm"

/obj/item/clothing/under/urist/nerva/cargo
	name = "supply technician's uniform"
	desc = "A stylish uniform worn by the ICS Nerva's supply technicians."
	icon_state = "cargo"
	item_state = "cargo"
	worn_state = "cargo"

/obj/item/clothing/under/bodyguard
	name = "Bodyguard's Uniform"
	desc = "A black uniform made from a durable, slightly laser-resistant, fabric."
	icon_state = "combat"
	item_state = "combat"
	worn_state = "combat"
	armor = list(melee = 10, bullet = 0, laser = 10,energy = 0, bomb = 0, bio = 0, rad = 0)

//jackets

/obj/item/clothing/suit/storage/toggle/urist/hosjacket
	name = "chief of security's jacket"
	desc = "A hardy jacket worn by the ICS Nerva's Chief of Security."
	icon_state = "service_hos_open"
	icon_open = "service_hos_open"
	icon_closed = "service_hos_closed"
	item_state = "service_hos"
	blood_overlay_type = "coatblood"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = 253.15
	armor = list(melee = 15, bullet = 5, laser = 10, energy = 10, bomb = 5, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/toggle/urist/qmjacket
	name = "quartermaster's jacket"
	desc = "A light jacket worn by the ICS Nerva's Quartermaster."
	icon_state = "service_qm_open"
	icon_open = "service_qm_open"
	icon_closed = "service_qm_closed"
	item_state = "service_qm"
	blood_overlay_type = "coatblood"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = 253.15

/obj/item/clothing/suit/storage/toggle/urist/cargojacket
	name = "supply technician's jacket"
	desc = "A light jacket worn by the ICS Nerva's supply technicians."
	icon_state = "service_cargo_open"
	icon_open = "service_cargo_open"
	icon_closed = "service_cargo_closed"
	item_state = "service_cargo"
	blood_overlay_type = "coatblood"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = 253.15

/obj/item/clothing/suit/storage/toggle/urist/nervacapjacket
	name = "captain's jacket"
	desc = "A hardy synthleather flight jacket worn by the captain of the ICS Nerva. Stylsh, practical and lightly armoured, this outfit exudes an aura of command."
	icon_state = "nervacapcoat_open"
	icon_open = "nervacapcoat_open"
	icon_closed = "nervacapcoat_closed"
	item_state = "nervacapcoat"
	blood_overlay_type = "coatblood"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = 253.15
	armor = list(melee = 30, bullet = 10, laser = 15, energy = 10, bomb = 10, bio = 0, rad = 0)


//armor

/obj/item/clothing/suit/urist/armor/nerva/sec
	name = "armour vest"
	desc = "A bulky armoured vest assigned to the ICS Nerva's security officers. Has space to attach additional pouches for storage."
	icon_state = "nervasecarmour"
	item_state = "nervasecarmour"
	blood_overlay_type = "armorblood"
	armor = list(melee = 50, bullet = 45, laser = 40, energy = 25, bomb = 30, bio = 0, rad = 0)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S)
	starting_accessories = list(/obj/item/clothing/accessory/storage/pouches/large)

/obj/item/clothing/suit/urist/armor/nerva/sec_cos
	name = "chief of security's armour vest"
	desc = "A bulky armoured vest assigned to the ICS Nerva's Chief of Security."
	icon_state = "nervacosarmour" //need to edit the existing icon
	item_state = "nervacosarmour"
	blood_overlay_type = "armorblood"
	armor = list(melee = 60, bullet = 50, laser = 45, energy = 30, bomb = 35, bio = 0, rad = 0)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S)
	starting_accessories = list(/obj/item/clothing/accessory/armguards/merc, /obj/item/clothing/accessory/legguards/merc, /obj/item/clothing/accessory/storage/pouches/large, /obj/item/clothing/accessory/armor/tag/nerva)

/obj/item/clothing/suit/armor/pcarrier/medium/nerva
	starting_accessories = list(/obj/item/clothing/accessory/armorplate/medium, /obj/item/clothing/accessory/storage/pouches, /obj/item/clothing/accessory/armor/tag/nerva)

/obj/item/clothing/suit/armor/pcarrier/merc/cos
	starting_accessories = list(/obj/item/clothing/accessory/armorplate/merc, /obj/item/clothing/accessory/armguards/merc, /obj/item/clothing/accessory/legguards/merc, /obj/item/clothing/accessory/storage/pouches/large, /obj/item/clothing/accessory/armor/tag/nerva)

//tag

/obj/item/clothing/accessory/armor/tag/nerva
	name = "\improper ICS Nerva tag"
	desc = "An armor tag with an 'N' emblazoned on it to denote the ICS Nerva."
	icon_state = "nervatag"
	item_icons = URIST_ALL_ONMOBS
	icon_override = 'icons/uristmob/ties.dmi'
	icon = 'icons/urist/items/clothes/ties.dmi'
//	accessory_icons = list(slot_tie_str = 'icons/uristmob/modular_armor.dmi', slot_wear_suit_str = 'icons/uristmob/modular_armor.dmi')

//cloak

/obj/item/clothing/suit/storage/hooded/seccloak
	action_button_name = "Toggle Hood"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = T0C - 20
	armor = list(melee = 12, bullet = 5, laser = 10, energy = 5, bomb = 0, bio = 0, rad = 0)
	hoodtype = /obj/item/clothing/head/urist/seccloakhood
	icon = 'icons/urist/items/clothes/clothes.dmi'
	item_icons = URIST_ALL_ONMOBS
	icon_state = "seccloak1"
	item_state = "seccloak1"
	name = "security cloak"
	desc = "A large thick cloak with a number of handy pockets worn by the ICS Nerva's security team. Doesn't offer much in the way of protection, but is better than nothing."
	var/state = 1

/obj/item/clothing/suit/storage/hooded/seccloak/verb/toggle_state()
	set name = "Shift Cloak"
	set category = "Object"

	set src in usr
	if(!CanPhysicallyInteract(usr))
		return 0

	else
		state += 1

		if(state >= 5)
			state = 1

		update_icon()

		to_chat(usr, "You shift the cloak around.")
		update_clothing_icon()

/obj/item/clothing/suit/storage/hooded/seccloak/update_icon()
	icon_state = "seccloak[state]"

/obj/item/clothing/head/urist/seccloakhood
	name = "cloak hood"
	desc = "A hood attached to a warm cloak."
	icon_state = "seccloakhood"
	body_parts_covered = HEAD
	min_cold_protection_temperature = T0C - 20
	cold_protection = HEAD
	flags_inv = HIDEEARS | BLOCKHAIR
	armor = list(melee = 12, bullet = 5, laser = 10, energy = 5, bomb = 0, bio = 0, rad = 0)

//gloves

/obj/item/clothing/gloves/color/grey
	color = COLOR_GRAY40

//boots

/obj/item/clothing/shoes/urist/capboots
	name = "captain's boots"
	desc = "Classy synthleather boots worn by the captain of the ICS Nerva. Stylish, practical and lightly armoured, these boots are as good as it gets."
	icon_state = "nervacapboots"
	item_state = "nervacapboots"
	force = 3
	armor = list(melee = 30, bullet = 10, laser = 10, energy = 15, bomb = 20, bio = 0, rad = 0)
	siemens_coefficient = 0.7
	can_hold_knife = 1
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE

//berets

/obj/item/clothing/head/urist/beret
	name = "beret"
	body_parts_covered = 0

/obj/item/clothing/head/urist/beret/nervafo
	name = "first officer's beret"
	desc = "A crisp white beret worn by the ISC Nerva's First Officer."
	icon_state = "nervafoberet"
	item_state = "nervafoberet"

/obj/item/clothing/head/urist/beret/nervaso
	name = "second officer's beret"
	desc = "A crisp white beret worn by the ISC Nerva's Second Officer."
	icon_state = "nervafoberet"
	item_state = "nervafoberet"

/obj/item/clothing/head/urist/beret/nervacap
	name = "captain's beret"
	desc = "A crisp white beret worn by the ISC Nerva's Captain."
	icon_state = "nervacapberet"
	item_state = "nervacapberet"

/obj/item/clothing/head/beret/sec/nervacos //reusing the corpsec icons
	name = "chief of security's beret"
	desc = "A striking black beret with an emblem denoting the ICS Nerva's chief of security."
	icon_state = "beret_corporate_hos"

//rigs

/obj/item/weapon/rig/command/exploration
	name = "exploration command HCM"
	suit_type = "exploration command hardsuit"
	desc = "A specialized hardsuit rig control module issued to the quartermaster of the ICS Nerva."
//	icon = 'maps/torch/icons/obj/uniques.dmi'
	icon_state = "command_exp_rig"
	armor = list(melee = 35, bullet = 25, laser = 20, energy = 35, bomb = 40, bio = 100, rad = 100)

	online_slowdown = 0.25
	offline_slowdown = 2
	offline_vision_restriction = TINT_HEAVY

	chest_type = /obj/item/clothing/suit/space/rig/command/exploration
	helm_type = /obj/item/clothing/head/helmet/space/rig/command/exploration
	boot_type = /obj/item/clothing/shoes/magboots/rig/command/exploration
	glove_type = /obj/item/clothing/gloves/rig/command/exploration

	allowed = list(/obj/item/weapon/gun, /obj/item/device/flashlight, /obj/item/device/radio, /obj/item/weapon/tank, /obj/item/device/suit_cooling_unit)
	req_access = list(access_qm)

/obj/item/clothing/head/helmet/space/rig/command/exploration
	light_overlay = "helmet_light_dual"
	icon = 'maps/torch/icons/obj/solgov-head.dmi'
	item_icons = list(slot_head_str = 'maps/torch/icons/mob/solgov-head.dmi')
	species_restricted = list(SPECIES_HUMAN) //no available icons for aliens

/obj/item/clothing/suit/space/rig/command/exploration
	icon = 'maps/torch/icons/obj/solgov-suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/solgov-suit.dmi')
	species_restricted = list(SPECIES_HUMAN)

/obj/item/clothing/shoes/magboots/rig/command/exploration
	icon = 'maps/torch/icons/obj/solgov-feet.dmi'
	item_icons = list(slot_shoes_str = 'maps/torch/icons/mob/solgov-feet.dmi')
	species_restricted = list(SPECIES_HUMAN)

/obj/item/clothing/gloves/rig/command/exploration
	icon = 'maps/torch/icons/obj/solgov-hands.dmi'
	item_icons = list(slot_gloves_str = 'maps/torch/icons/mob/solgov-hands.dmi')
	species_restricted = list(SPECIES_HUMAN)

/obj/item/weapon/rig/command/exploration/equipped

	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/cooling_unit
		)


//nerva captain
/*
/obj/item/weapon/rig/command/nervacap
	name = "Captain's command HCM"
	suit_type = "captain's command hardsuit"
	desc = "A high-tech powered suit adorned with ceremonial frills of crimson and gold. Cost more to produce and manufacture than the ship you're on right now."
//	icon = 'maps/torch/icons/obj/uniques.dmi'
	icon_state = "command_exp_rig"
	armor = list(melee = 65, bullet = 50, laser = 50, energy = 25, bomb = 50, bio = 100, rad = 100) //same as cappy's regular armour

	online_slowdown = 0.25
	offline_slowdown = 2
	offline_vision_restriction = TINT_HEAVY

	chest_type = /obj/item/clothing/suit/space/rig/command/nervacap
	helm_type = /obj/item/clothing/head/helmet/space/rig/command/nervacap
	boot_type = /obj/item/clothing/shoes/magboots/rig/command/nervacap
	glove_type = /obj/item/clothing/gloves/rig/command/nervacap

	allowed = list(/obj/item/weapon/gun, /obj/item/device/flashlight, /obj/item/device/radio, /obj/item/weapon/tank, /obj/item/device/suit_cooling_unit)
	req_access = list(access_captain)

/obj/item/clothing/head/helmet/space/rig/command/nervacap
	light_overlay = "helmet_light_dual"
	icon = 'icons/urist/items/clothes/head'
	item_icons = list(slot_head_str = 'icons/uristmob/head.dmi')
	camera = /obj/machinery/camera/network/command
	species_restricted = list(SPECIES_HUMAN) //no available icons for aliens

/obj/item/clothing/suit/space/rig/command/nervacap
	icon = 'icons/urist/items/clothes/clothes.dmi'
	item_icons = list(slot_wear_suit_str = 'icons/uristmob/clothes.dmi')
	species_restricted = list(SPECIES_HUMAN)

/obj/item/clothing/shoes/magboots/rig/command/nervacap
	icon = 'icons/urist/items/clothes/shoes.dmi'
	item_icons = list(slot_shoes_str = 'icons/uristmob/shoes.dmi')
	species_restricted = list(SPECIES_HUMAN)

/obj/item/clothing/gloves/rig/command/nervacap
	icon = 'icons/urist/items/clothes/gloves.dmi'
	item_icons = list(slot_gloves_str = 'icons/uristmob/gloves.dmi')
	species_restricted = list(SPECIES_HUMAN)

/obj/item/weapon/rig/command/nervacap/equipped

	initial_modules = list(
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/cooling_unit
		)
*/