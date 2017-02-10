//NT STATION CLOTHING. HAHAHA, WE'RE TAKING YOUR ONLY UNIQUE CONTENT

/obj/item/clothing/suit/coat
	name = "winter coat"
	desc = "A coat that protects against the bitter cold."
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'
	icon_override = 'icons/uristmob/clothes.dmi'
	icon_state = "coatwinter"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	var/has_hood = 1
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	min_cold_protection_temperature = 243.15
	allowed = list(/obj/item/device/analyzer,/obj/item/stack/medical,/obj/item/weapon/dnainjector,/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,/obj/item/weapon/reagent_containers/hypospray,/obj/item/device/healthanalyzer,/obj/item/device/flashlight/pen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/storage/pill_bottle,/obj/item/weapon/paper,/obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/device/flashlight/seclite)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	var/can_toggle = 1

/*	verb/togglecoat()
		set name = "Toggle Coat"
		set category = "Object"
		set src in usr
		if(!usr.canmove || usr.stat || usr.restrained())
			return
		if(!can_toggle)
			usr << "This suit cannot be toggled!"
			return
		if(src.is_toggled == 2)
			src.icon_state = initial(icon_state)
			usr << "You button up your coat."
			src.is_toggled = 1
		else
			src.icon_state += "_open"
			usr << "You unbutton your coat."
			src.is_toggled = 2
		usr.update_inv_wear_suit()*/

/obj/item/clothing/suit/coat/jacket
	name = "bomber jacket"
	desc = "Aviators not included."
	icon_state = "jacket"
	can_toggle = null
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = 263.15

/obj/item/clothing/suit/coat/jacket/leather
	name = "leather jacket"
	desc = "Pompadour not included."
	icon_state = "leatherjacket"
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = 263.15

/obj/item/clothing/suit/coat/captain
	name = "captain's winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatcaptain"

/obj/item/clothing/suit/coat/cargo
	name = "cargo winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatcargo"

/obj/item/clothing/suit/coat/engineer
	name = "engineering winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatengineer"

/obj/item/clothing/suit/coat/atmos
	name = "atmos winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatatmos"

/obj/item/clothing/suit/coat/hydro
	name = "hydroponics winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coathydro"

/obj/item/clothing/suit/coat/medical
	name = "medical winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatmedical"

/obj/item/clothing/suit/coat/miner
	name = "mining winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatminer"

/obj/item/clothing/suit/coat/science
	name = "science winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatscience"

/obj/item/clothing/suit/coat/security
	name = "security winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatsecurity"

/obj/item/clothing/suit/armor/vest/jacket
	name = "military jacket"
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'
	icon_override = 'icons/uristmob/clothes.dmi'
	desc = "An old military jacket, it has armoring."
	icon_state = "militaryjacket"
	item_state = "militaryjacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

//Syndicate Stealth Rig
/obj/item/clothing/head/helmet/space/void/syndistealth
	name = "night-black hardsuit helmet"
	desc = "A sleek, armored space helmet designed for work in covert operations. Property of MI13."
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'
	icon_override = 'icons/uristmob/head.dmi'
	icon_state = "rig0-stealth"
	//item_color = "stealth"
	armor = list(melee = 65, bullet = 45, laser = 30,energy = 20, bomb = 30, bio = 100, rad = 50)

/obj/item/clothing/suit/space/void/syndistealth
	icon_state = "stealth"
	name = "night-black hardsuit"
	desc = "A sleek, armored space suit that protects the wearer against injuries during covert operations. Unique syndicate technology allows it to be carried in a backpack when not in use. Property of MI13."
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'
	icon_override = 'icons/uristmob/clothes.dmi'
	w_class = 3
	armor = list(melee = 65, bullet = 45, laser = 30, energy = 20, bomb = 30, bio = 100, rad = 50)
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency)

/obj/item/clothing/suit/space/void/syndistealth/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1

// COLD RIGZ

	//Security
/obj/item/clothing/head/helmet/space/void/security/cold
	name = "security cryo hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, cold, low pressure environment. Has an additional layer of armor."
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'
	icon_override = 'icons/uristmob/head.dmi'
	icon_state = "rig0-seccold"
	//item_color = "seccold"
	urist_only = 1

/obj/item/clothing/suit/space/void/security/cold
	icon_state = "cryo-security"
	name = "security cryo hardsuit"
	desc = "A special suit that protects against hazardous, cold, low pressure environments. Has an additional layer of armor."
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'
	icon_override = 'icons/uristmob/clothes.dmi'
	urist_only = 1

//Engineering
/obj/item/clothing/head/helmet/space/void/engineering/cold
	name = "engineering cryo hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, cold, low-pressure environment. Has radiation shielding."
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'
	icon_override = 'icons/uristmob/head.dmi'
	icon_state = "rig0-engicold"
	//item_color = "engicold"
	urist_only = 1

/obj/item/clothing/suit/space/void/engineering/cold
	name = "engineering cryo hardsuit"
	desc = "A special suit that protects against hazardous, cold, low pressure environments. Has radiation shielding."
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'
	icon_override = 'icons/uristmob/clothes.dmi'
	icon_state = "cryo-engineering"
	urist_only = 1

//Atmospherics
/obj/item/clothing/head/helmet/space/void/atmos/cold
	name = "atmospherics cryo hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, cold, low-pressure environment. Has thermal shielding."
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'
	icon_override = 'icons/uristmob/head.dmi'
	icon_state = "rig0-atmocold"
	item_state = "atmo_cold"
	//item_color = "atmocold"
	urist_only = 1

/obj/item/clothing/suit/space/void/atmos/cold
	name = "atmospherics cryo hardsuit"
	desc = "A special suit that protects against hazardous, cold, low pressure environments. Has thermal shielding."
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'
	icon_override = 'icons/uristmob/clothes.dmi'
	icon_state = "cryo-atmos"
	item_state = "atmo_coldsuit"
	urist_only = 1

//Mining
/obj/item/clothing/head/helmet/space/void/mining/cold
	name = "mining cryo hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, cold, low pressure environment. Has reinforced plating."
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'
	icon_override = 'icons/uristmob/head.dmi'
	icon_state = "rig0-minecold"
	//item_color = "minecold"
	urist_only = 1

/obj/item/clothing/suit/space/void/mining/cold
	icon_state = "cryo-mining"
	name = "mining cryo hardsuit"
	desc = "A special suit that protects against hazardous, cold, low pressure environments. Has reinforced plating."
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'
	icon_override = 'icons/uristmob/clothes.dmi'
	urist_only = 1

//pants

/*/obj/item/clothing/under/pants
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'
	icon_override = 'icons/uristmob/clothes.dmi'
	gender = PLURAL
	body_parts_covered = LOWER_TORSO|LEGS*/

/obj/item/clothing/under/pants/urist/bluepants
	name = "blue pants"
	desc = "A pair of blue pants."
	icon_state = "bluepants"
	item_state = "bluepants"
	//item_color = "jeans"

/obj/item/clothing/under/pants/urist/trackpants
	name = "track pants"
	desc = "A pair of track pants, for the athletic."
	icon_state = "trackpants"
	item_state = "trackpants"
	//item_color = "trackpants"

/obj/item/clothing/under/pants/urist/khaki
	name = "khaki pants"
	desc = "A pair of dust beige khaki pants."
	icon_state = "khaki"
	item_state = "khaki"
	//item_color = "khaki"

/obj/item/clothing/under/pants/urist/camo
	name = "camouflage pants"
	desc = "A pair of woodland camouflage pants, not good for camouflage in this environment."
	icon_state = "camopants"
	item_state = "camopants"
	//item_color = "camopants"

//random

/obj/item/clothing/suit/nerdshirt
	name = "gamer shirt"
	desc = "A baggy shirt with vintage game character Phanic the Weasel. Why would someone wear this?"
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'
	icon_override = 'icons/uristmob/clothes.dmi'
	icon_state = "nerdshirt"
	item_state = "nerdshirt"

//beanie

/obj/item/clothing/head/beanie
	name = "beanie"
	desc = "A dirty looking beanie."
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'
	icon_override = 'icons/uristmob/head.dmi'
	icon_state = "beanie"
	cold_protection = HEAD
	min_cold_protection_temperature = 243.15

//cap carapace

/obj/item/clothing/suit/armor/vest/capcarapace
	name = "captain's carapace"
	desc = "An armored vest reinforced with ceramic plates and pauldrons to provide additional protection whilst still offering maximum mobility and flexibility. Issued only to the station's finest, although it does chafe your nipples."
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'
	icon_override = 'icons/uristmob/clothes.dmi'
	icon_state = "capcarapace"
	item_state = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 50, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

//billydonka

/obj/item/clothing/suit/urist/billydonka
	name = "candyman vest"
	desc = "The candy man can 'cause he mixes it with love and makes the world taste good."
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'
	icon_state = "billydonkaoutfit"
	item_state = "billydonkaoutfit"

/obj/item/clothing/under/urist/billydonka
	name = "candyman outfit"
	desc = "Who can take a rainbow and wrap it in a sigh?"
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'
	icon_state = "billydonka"
	item_state = "billydonka"
	//item_color = "billydonka"

/obj/item/clothing/head/urist/billydonka
	name = "candyman's hat"
	desc = "And the world tastes good 'cause the candyman thinks it should.."
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'
	icon_state = "billydonkahat"
	item_state = "billydonkahat"