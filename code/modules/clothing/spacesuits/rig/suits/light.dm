// Light rigs are not space-capable, but don't suffer excessive slowdown or sight issues when depowered.
/obj/item/rig/light
	name = "light suit control module"
	desc = "A lighter, less armoured rig suit."
	icon_state = "ninja_rig"
	suit_type = "light suit"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
		)
	siemens_coefficient = 0.4
	emp_protection = 10
	online_slowdown = 0.5
	offline_slowdown = 1
	item_flags = ITEM_FLAG_THICKMATERIAL
	offline_vision_restriction = TINT_NONE
	max_pressure_protection = LIGHT_RIG_MAX_PRESSURE
	min_pressure_protection = 0

	chest_type = /obj/item/clothing/suit/space/rig/light
	helm_type =  /obj/item/clothing/head/helmet/space/rig/light
	boot_type =  /obj/item/clothing/shoes/magboots/rig/light
	glove_type = /obj/item/clothing/gloves/rig/light

/obj/item/clothing/suit/space/rig/light
	name = "suit"
	breach_threshold = 18 //comparable to voidsuits
	species_restricted = list(SPECIES_HUMAN,SPECIES_IPC,SPECIES_RESOMI)
	allowed = list(
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/handcuffs,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/cell
	)
	max_w_class = ITEM_SIZE_SMALL
	slots = 3 STORAGE_FREEFORM

/obj/item/clothing/gloves/rig/light
	name = "gloves"
	species_restricted = list(SPECIES_HUMAN,SPECIES_IPC,SPECIES_RESOMI)

/obj/item/clothing/shoes/magboots/rig/light
	name = "boots"
	species_restricted = list(SPECIES_HUMAN,SPECIES_IPC,SPECIES_RESOMI)
	sprite_sheets = list(
		SPECIES_RESOMI = 'icons/mob/species/resomi/shoes.dmi'
	)

/obj/item/clothing/head/helmet/space/rig/light
	name = "helmet"
	species_restricted = list(SPECIES_HUMAN,SPECIES_IPC,SPECIES_RESOMI)
	sprite_sheets = list(
		SPECIES_RESOMI = 'icons/mob/species/resomi/helmet.dmi'
	)

/obj/item/rig/light/hacker
	name = "cybersuit control module"
	suit_type = "cyber"
	desc = "An advanced powered armour suit with many cyberwarfare enhancements. Comes with built-in insulated gloves for safely tampering with electronics."
	icon_state = "hacker_rig"

	req_access = list(access_syndicate)

	airtight = 0
	seal_delay = 5 //not being vaccum-proof has an upside I guess

	helm_type = /obj/item/clothing/head/lightrig/hacker
	chest_type = /obj/item/clothing/suit/lightrig/hacker
	glove_type = /obj/item/clothing/gloves/lightrig/hacker
	boot_type = /obj/item/clothing/shoes/lightrig/hacker

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/vision/nvg,
		/obj/item/rig_module/cooling_unit
		)

//The cybersuit is not space-proof. It does however, have good siemens_coefficient values
/obj/item/clothing/head/lightrig/hacker
	name = "HUD"
	item_flags = 0

/obj/item/clothing/suit/lightrig/hacker
	siemens_coefficient = 0.2

/obj/item/clothing/shoes/lightrig/hacker
	siemens_coefficient = 0.2
	item_flags = ITEM_FLAG_NOSLIP //All the other rigs have magboots anyways, hopefully gives the hacker suit something more going for it.

/obj/item/clothing/gloves/lightrig/hacker
	siemens_coefficient = 0
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_NOCUFFS


/obj/item/rig/light/ninja
	name = "ominous suit control module"
	desc = "A unique, vaccum-proof suit of nano-enhanced armor designed specifically for assassins."
	suit_type = "ominous"
	icon_state = "ninja_rig"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED
		)
	siemens_coefficient = 0.2 //heavy hardsuit level shock protection
	emp_protection = 30
	online_slowdown = 0
	aimove_power_usage = 50
	chest_type = /obj/item/clothing/suit/space/rig/light/ninja
	glove_type = /obj/item/clothing/gloves/rig/light/ninja
	cell_type =  /obj/item/cell/hyper

	req_access = list(access_syndicate)

	initial_modules = list(
		/obj/item/rig_module/teleporter,
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/mounted/energy/energy_blade,
		/obj/item/rig_module/vision,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/chem_dispenser/ninja,
		/obj/item/rig_module/grenade_launcher/ninja,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/self_destruct,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/maneuvering_jets
		)

	sprite_sheets = list(
		SPECIES_RESOMI = 'icons/mob/species/resomi/back.dmi'
	)

/obj/item/rig/light/ninja/verb/rename_suit()
	set name = "Name Operative Suit"
	set desc = "Rename your hardsuit."
	set category = "Object"
	var/mob/M = usr
	if(!M.mind) return 0
	if(M.incapacitated()) return 0
	var/input = sanitizeSafe(input("What do you want to name your suit?", "Rename suit"), MAX_NAME_LEN)
	if(src && input && !M.incapacitated() && in_range(M,src))
		if(!findtext(input, "the", 1, 4))
			input = "\improper [input]"
		SetName(input)
		to_chat(M, "Suit naming successful!")
		verbs -= /obj/item/rig/light/ninja/verb/rename_suit
		return 1


/obj/item/rig/light/ninja/verb/rewrite_suit_desc()
	set name = "Describe Operative suit"
	set desc = "Give your hardsuit a custom description."
	set category = "Object"
	var/mob/M = usr
	if(!M.mind) return 0
	if(M.incapacitated()) return 0
	var/input = sanitizeSafe(input("Please describe your voidsuit in 128 letters or less.", "write description"), MAX_DESC_LEN)
	if(src && input && !M.incapacitated() && in_range(M,src))
		desc = input
		to_chat(M, "Suit description successful!")
		verbs -= /obj/item/rig/light/ninja/verb/rename_suit
		return 1

/obj/item/clothing/gloves/rig/light/ninja
	name = "insulated gloves"
	siemens_coefficient = 0
	sprite_sheets = list(
		SPECIES_RESOMI = 'icons/mob/species/resomi/gloves.dmi'
	)
	species_restricted = list(SPECIES_HUMAN,SPECIES_IPC,SPECIES_RESOMI)
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_NOCUFFS

/obj/item/clothing/suit/space/rig/light/ninja
	breach_threshold = 38 //comparable to regular hardsuits
	sprite_sheets = list(
		SPECIES_RESOMI = 'icons/mob/species/resomi/suit.dmi'
	)
	species_restricted = list(SPECIES_HUMAN,SPECIES_IPC,SPECIES_RESOMI)

/obj/item/rig/light/ninja/sol
	name = "solar operative suit control module"
	desc = "A sleek, military hardsuit with no model number or identifying logos besides a small Solar crest on its control module. Get tactical, marine."
	suit_type = "operative"
	icon_state = "solop_rig"
	online_slowdown = 1
	offline_slowdown = 2
	initial_modules = list(
		/obj/item/rig_module/vision,
		/obj/item/rig_module/chem_dispenser/ninja,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/grenade_launcher/ninja,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/personal_shield,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/self_destruct,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/maneuvering_jets
		)

/obj/item/rig/light/ninja/gcc
	name = "gilgamesh heavy suit control module"
	desc = "A ridiculously bulky military hardsuit with no model number or identifying logos besides a small ICCG crest on its control module. This suit is built like a tank and weighs as much as one."
	suit_type = "heavy"
	icon_state = "gcc_rig"
	online_slowdown = 2 ///chunky
	offline_slowdown = 4
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED
		)
	initial_modules = list(
		/obj/item/rig_module/vision,
		/obj/item/rig_module/chem_dispenser/ninja,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/grenade_launcher/ninja,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/self_destruct,
		/obj/item/rig_module/mounted/ballistic/minigun,
		/obj/item/rig_module/mounted/power_fist,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/maneuvering_jets
		)

/obj/item/clothing/suit/space/rig/light/ninja/gcc
	breach_threshold = 50 ///chunky

/obj/item/rig/light/ninja/corpo
	name = "corporate mercenary suit control module"
	desc = "A light hardsuit with minimal armor plating. The control panel marks it as a Hephaestus X-11 Lightweight, a mobile combat suit commonly issued to corporate security teams."
	suit_type = "corporate"
	icon_state = "corpo_rig"
	online_slowdown = -1 ///speedster suit
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED
	)

	initial_modules = list(
		/obj/item/rig_module/actuators,
		/obj/item/rig_module/mounted/arm_blade,
		/obj/item/rig_module/mounted/energy/ion,
		/obj/item/rig_module/vision,
		/obj/item/rig_module/chem_dispenser/ninja,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/grenade_launcher/ninja,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/self_destruct,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/maneuvering_jets
		)

/obj/item/rig/light/stealth
	name = "stealth suit control module"
	suit_type = "stealth"
	desc = "A highly advanced and expensive suit designed for covert operations."
	icon_state = "stealth_rig"

	req_access = list(access_syndicate)

	initial_modules = list(
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/vision
		)
