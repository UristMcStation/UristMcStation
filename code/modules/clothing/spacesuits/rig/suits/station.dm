/obj/item/rig/light/internalaffairs
	name = "augmented tie"
	suit_type = "augmented suit"
	desc = "Prepare for paperwork."
	icon_state = "internalaffairs_rig"
	siemens_coefficient = 0.9
	online_slowdown = 0
	offline_slowdown = 0
	offline_vision_restriction = 0
	hides_uniform = 0

	req_access = list(access_lawyer)

	glove_type = null
	helm_type = null
	boot_type = null

	chest_type = /obj/item/clothing/suit/space/rig/industrial

/obj/item/clothing/suit/space/rig/industrial
	species_restricted = list(SPECIES_HUMAN,SPECIES_IPC)
	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/storage/briefcase,
		/obj/item/storage/secure/briefcase
	)

/obj/item/rig/light/internalaffairs/equipped
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/device/paperdispenser,
		/obj/item/rig_module/device/pen,
		/obj/item/rig_module/device/stamp,
		/obj/item/rig_module/cooling_unit
	)

/obj/item/rig/industrial
	name = "industrial suit control module"
	suit_type = "industrial hardsuit"
	desc = "An industrial hardsuit used by construction crews and mining corporations."
	icon_state = "engineering_rig"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
	)
	online_slowdown = 2
	offline_slowdown = 4
	vision_restriction = TINT_MODERATE
	offline_vision_restriction = TINT_BLIND
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0

	chest_type = /obj/item/clothing/suit/space/rig/industrial
	helm_type = /obj/item/clothing/head/helmet/space/rig/industrial
	boot_type = /obj/item/clothing/shoes/magboots/rig/industrial
	glove_type = /obj/item/clothing/gloves/rig/industrial

/obj/item/clothing/head/helmet/space/rig/industrial
	light_overlay = "helmet_light_wide"
	head_light_range = 5
	camera = /obj/machinery/camera/network/helmet
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC)

/obj/item/clothing/suit/space/rig/industrial
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC)
	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/stack/flag,
		/obj/item/storage/ore,
		/obj/item/device/t_scanner,
		/obj/item/pickaxe,
		/obj/item/rcd,
		/obj/item/rpd
	)

/obj/item/clothing/shoes/magboots/rig/industrial
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC)

/obj/item/clothing/gloves/rig/industrial
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC)
	siemens_coefficient = 0

/obj/item/rig/industrial/equipped

	initial_modules = list(
		/obj/item/rig_module/mounted/energy/plasmacutter,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/kinetic_module
	)

/obj/item/rig/eva
	name = "EVA hardsuit control module"
	suit_type = "EVA hardsuit"
	desc = "A light rig for repairs and maintenance to the outside of habitats and vessels."
	icon_state = "eva_rig"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_MINOR,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	online_slowdown = 0.75
	offline_vision_restriction = TINT_HEAVY

	chest_type = /obj/item/clothing/suit/space/rig/eva
	helm_type = /obj/item/clothing/head/helmet/space/rig/eva
	boot_type = /obj/item/clothing/shoes/magboots/rig/eva
	glove_type = /obj/item/clothing/gloves/rig/eva

	req_access = list(access_engine_equip)

	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_rig_back_unathi.dmi'
	)

/obj/item/clothing/head/helmet/space/rig/eva
	light_overlay = "helmet_light_alt"
	head_light_range = 5
	camera = /obj/machinery/camera/network/helmet
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC)
	sprite_sheets = list(
		SPECIES_SKRELL = 'icons/mob/species/skrell/onmob_head_skrell.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_head_unathi.dmi'
	)

/obj/item/clothing/suit/space/rig/eva
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_suit_unathi.dmi'
		)
	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/storage/toolbox,
		/obj/item/storage/briefcase/inflatable,
		/obj/item/inflatable_dispenser,
		/obj/item/device/t_scanner,
		/obj/item/rcd,
		/obj/item/rpd
	)

/obj/item/clothing/shoes/magboots/rig/eva
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_feet_unathi.dmi'
	)

/obj/item/clothing/gloves/rig/eva
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC)
	siemens_coefficient = 0
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_hands_unathi.dmi'
	)

/obj/item/rig/eva/equipped

	initial_modules = list(
		/obj/item/rig_module/mounted/energy/plasmacutter,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/cooling_unit
	)

/obj/item/rig/ce
	name = "advanced engineering hardsuit control module"
	suit_type = "engineering hardsuit"
	desc = "An advanced hardsuit that protects against hazardous, low pressure environments. Shines with a high polish. Appears compatible with the physiology of most species."
	icon_state = "ce_rig"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	online_slowdown = 0.75
	offline_vision_restriction = TINT_HEAVY
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE // this is passed to the rig suit components when deployed, including the helmet.

	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/back.dmi')

	chest_type = /obj/item/clothing/suit/space/rig/ce
	helm_type = /obj/item/clothing/head/helmet/space/rig/ce
	glove_type = /obj/item/clothing/gloves/rig/ce

	req_access = list(access_ce)
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0

/obj/item/rig/ce/equipped

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/mounted/energy/plasmacutter,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/grenade_launcher/mfoam,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/kinetic_module
	)

/obj/item/clothing/head/helmet/space/rig/ce
	light_overlay = "helmet_light_alt"
	head_light_range = 5
	camera = /obj/machinery/camera/network/helmet
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC,SPECIES_RESOMI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_head_unathi.dmi',
		SPECIES_SKRELL = 'icons/mob/species/skrell/onmob_head_skrell.dmi',
		SPECIES_RESOMI = 'icons/mob/species/resomi/helmet.dmi'
	)
/obj/item/clothing/suit/space/rig/ce
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC,SPECIES_RESOMI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_suit_unathi.dmi',
		SPECIES_RESOMI = 'icons/mob/species/resomi/suit.dmi'
	)
	allowed = list(
		/obj/item/gun,
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/storage/ore,
		/obj/item/storage/toolbox,
		/obj/item/storage/briefcase/inflatable,
		/obj/item/inflatable_dispenser,
		/obj/item/device/t_scanner,
		/obj/item/pickaxe,
		/obj/item/rcd,
		/obj/item/rpd
	)
/obj/item/clothing/shoes/magboots/rig/ce
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_feet_unathi.dmi'
	)
/obj/item/clothing/gloves/rig/ce
	siemens_coefficient = 0

/obj/item/rig/hazmat
	name = "\improper AMI control module"
	suit_type = "hazmat hardsuit"
	desc = "An Anomalous Material Interaction hardsuit, a cutting-edge NanoTrasen design, protects the wearer against the strangest energies the universe can throw at it."
	icon_state = "science_rig"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_STRONG,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	offline_vision_restriction = TINT_HEAVY

	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/back.dmi')

	chest_type = /obj/item/clothing/suit/space/rig/hazmat
	helm_type = /obj/item/clothing/head/helmet/space/rig/hazmat
	boot_type = /obj/item/clothing/shoes/magboots/rig/hazmat
	glove_type = /obj/item/clothing/gloves/rig/hazmat

	allowed = list(/obj/item/storage/backpack,/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/storage/excavation,/obj/item/pickaxe,/obj/item/device/scanner/health,/obj/item/device/measuring_tape,/obj/item/device/ano_scanner,/obj/item/device/depth_scanner,/obj/item/device/core_sampler,/obj/item/device/gps,/obj/item/pinpointer/radio,/obj/item/pickaxe/xeno,/obj/item/storage/bag/fossils)
	req_access = list(access_tox)

/obj/item/clothing/head/helmet/space/rig/hazmat
	light_overlay = "helmet_light_dual"
	camera = /obj/machinery/camera/network/helmet
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_RESOMI,SPECIES_IPC)
	sprite_sheets = list(
		SPECIES_RESOMI = 'icons/mob/species/resomi/helmet.dmi'
		)

/obj/item/clothing/suit/space/rig/hazmat
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC)
	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/stack/flag,
		/obj/item/storage/excavation,
		/obj/item/pickaxe,
		/obj/item/device/scanner/health,
		/obj/item/device/measuring_tape,
		/obj/item/device/ano_scanner,
		/obj/item/device/depth_scanner,
		/obj/item/device/core_sampler,
		/obj/item/device/gps,
		/obj/item/pinpointer/radio,
		/obj/item/pickaxe/xeno,
		/obj/item/storage/bag/fossils
	)
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_RESOMI,SPECIES_IPC)
	sprite_sheets = list(
		SPECIES_RESOMI = 'icons/mob/species/resomi/suit.dmi'
		)

/obj/item/clothing/shoes/magboots/rig/hazmat
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_RESOMI,SPECIES_IPC)
	sprite_sheets = list(
		SPECIES_RESOMI = 'icons/mob/species/resomi/shoes.dmi'
		)

/obj/item/clothing/gloves/rig/hazmat
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_RESOMI,SPECIES_IPC)
	sprite_sheets = list(
		SPECIES_RESOMI = 'icons/mob/species/resomi/gloves.dmi'
		)

/obj/item/rig/hazmat/equipped

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/anomaly_scanner,
		/obj/item/rig_module/cooling_unit,
	)

/obj/item/rig/medical
	name = "rescue suit control module"
	suit_type = "rescue hardsuit"
	desc = "A durable suit designed for medical rescue in high risk areas."
	icon_state = "medical_rig"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	online_slowdown = 0.5
	offline_vision_restriction = TINT_HEAVY

	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/back.dmi')

	chest_type = /obj/item/clothing/suit/space/rig/medical
	helm_type = /obj/item/clothing/head/helmet/space/rig/medical
	boot_type = /obj/item/clothing/shoes/magboots/rig/medical
	glove_type = /obj/item/clothing/gloves/rig/medical

	req_access = list(access_medical_equip)

/obj/item/clothing/head/helmet/space/rig/medical
	light_overlay = "helmet_light_wide"
	camera = /obj/machinery/camera/network/helmet
	species_restricted = list(SPECIES_HUMAN,SPECIES_UNATHI,SPECIES_SKRELL,SPECIES_RESOMI,SPECIES_IPC)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_head_helmet_unathi.dmi',
		SPECIES_SKRELL = 'icons/mob/species/skrell/onmob_head_skrell.dmi',
		SPECIES_RESOMI = 'icons/mob/species/resomi/helmet.dmi'
		)

/obj/item/clothing/suit/space/rig/medical
	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/storage/firstaid,
		/obj/item/device/scanner/health,
		/obj/item/stack/medical,
		/obj/item/roller_bed,
		/obj/item/auto_cpr,
		/obj/item/inflatable_dispenser
	)
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_RESOMI,SPECIES_IPC)
	sprite_sheets = list(
		SPECIES_RESOMI = 'icons/mob/species/resomi/suit.dmi',
		)
/obj/item/clothing/shoes/magboots/rig/medical
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_RESOMI,SPECIES_IPC)
	sprite_sheets = list(
		SPECIES_RESOMI = 'icons/mob/species/resomi/shoes.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_feet_unathi.dmi',
		)

/obj/item/clothing/gloves/rig/medical
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_RESOMI,SPECIES_IPC)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_hands_unathi.dmi',
		SPECIES_RESOMI = 'icons/mob/species/resomi/gloves.dmi',
	)

/obj/item/rig/medical/equipped

	initial_modules = list(
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/vision/medhud,
		/obj/item/rig_module/device/defib,
		/obj/item/rig_module/cooling_unit
	)

/obj/item/rig/hazard
	name = "hazard hardsuit control module"
	suit_type = "hazard hardsuit"
	desc = "A security hardsuit designed for prolonged EVA in dangerous environments."
	icon_state = "hazard_rig"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
	)
	offline_vision_restriction = TINT_BLIND

	chest_type = /obj/item/clothing/suit/space/rig/hazard
	helm_type = /obj/item/clothing/head/helmet/space/rig/hazard
	boot_type = /obj/item/clothing/shoes/magboots/rig/hazard
	glove_type = /obj/item/clothing/gloves/rig/hazard

/obj/item/clothing/head/helmet/space/rig/hazard
	light_overlay = "helmet_light_dual"
	camera = /obj/machinery/camera/network/helmet
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI, SPECIES_IPC)

/obj/item/clothing/suit/space/rig/hazard
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI, SPECIES_IPC)
	allowed = list(
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/handcuffs,
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/melee/baton
	)

/obj/item/clothing/shoes/magboots/rig/hazard
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI, SPECIES_IPC)

/obj/item/clothing/gloves/rig/hazard
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI, SPECIES_IPC)

/obj/item/rig/hazard/equipped

	initial_modules = list(
		/obj/item/rig_module/vision/sechud,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/energy/taser,
		/obj/item/rig_module/cooling_unit
	)

/obj/item/rig/zero
	name = "null suit control module"
	suit_type = "null hardsuit"
	desc = "A very lightweight suit designed to allow use inside mechs and starfighters. It feels like you're wearing nothing at all."
	icon_state = "null_rig"
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
	)
	online_slowdown = 0
	offline_slowdown = 1
	offline_vision_restriction = TINT_HEAVY //You're wearing a flash protective space suit without light compensation, think it makes sense

	//Bans the most common combat items, idea is that this isn't a mass built shouldergun rig.
	banned_modules = list(
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted,
		/obj/item/rig_module/fabricator
	)

	chest_type = /obj/item/clothing/suit/space/rig/zero
	helm_type = /obj/item/clothing/head/helmet/space/rig/zero
	boot_type = null
	glove_type = null
	max_pressure_protection = null
	min_pressure_protection = 0

	req_access = list()

/obj/item/clothing/head/helmet/space/rig/zero
	camera = null
	species_restricted = list(SPECIES_HUMAN, SPECIES_UNATHI, SPECIES_SKRELL, SPECIES_IPC)
	light_overlay = "null_light"
	desc = "A bubble helmet that maximizes the field of view. A state of the art holographic display provides a stream of information."

//All in one suit
/obj/item/clothing/suit/space/rig/zero
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_IPC)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_suit_unathi.dmi'
	)
	breach_threshold = 18
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit
	)
	max_w_class = null
	slots = null

/obj/item/rig/zero/on_update_icon(update_mob_icon)
	..()
	//Append the f for female states
	if(!ishuman(loc))
		return
	var/mob/living/carbon/human/user = loc
	if(!chest) return
	//If there's a better way to do this with current rig setup tell me
	//Do not further append if current state already indicates gender
	if(user.gender == FEMALE && !findtext(chest.icon_state,"_f", -2))
		chest.icon_state = "[chest.icon_state]_f"
