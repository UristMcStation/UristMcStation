/*
 * Contains:
 *		Lasertag
 *		Costume
 *		Misc
 */

/*
 * Lasertag
 */
/obj/item/clothing/suit/bluetag
	name = "blue laser tag armour"
	desc = "Blue Pride, Galaxy Wide."
	icon_state = "bluetag"
	blood_overlay_type = "armorblood"
	item_flags = null
	body_parts_covered = UPPER_TORSO
	allowed = list (/obj/item/gun/energy/lasertag/blue)
	siemens_coefficient = 3.0

/obj/item/clothing/suit/redtag
	name = "red laser tag armour"
	desc = "Reputed to go faster."
	icon_state = "redtag"
	blood_overlay_type = "armorblood"
	item_flags = null
	body_parts_covered = UPPER_TORSO
	allowed = list (/obj/item/gun/energy/lasertag/red)
	siemens_coefficient = 3.0

/*
 * Costume
 */
/obj/item/clothing/suit/pirate
	name = "pirate coat"
	desc = "Yarr."
	icon_state = "pirate"
	w_class = ITEM_SIZE_NORMAL
	allowed = list(
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/handcuffs,
		/obj/item/tank/oxygen_emergency,
		/obj/item/tank/oxygen_emergency_extended,
		/obj/item/tank/nitrogen_emergency
	)
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SMALL,
		rad = ARMOR_RAD_MINOR
	)
	siemens_coefficient = 0.9
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS


/obj/item/clothing/suit/hgpirate
	name = "pirate captain coat"
	desc = "Yarr."
	icon_state = "hgpirate"
	flags_inv = HIDEJUMPSUIT
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS


/obj/item/clothing/suit/greatcoat
	name = "great coat"
	desc = "A heavy great coat."
	icon_state = "leathercoat"


/obj/item/clothing/suit/justice
	name = "justice suit"
	desc = "This pretty much looks ridiculous."
	icon_state = "justice"
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET


/obj/item/clothing/suit/judgerobe
	name = "judge's robe"
	desc = "This robe commands authority."
	icon_state = "judge"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/storage/fancy/smokable,/obj/item/spacecash)
	flags_inv = HIDEJUMPSUIT


/obj/item/clothing/suit/apron/overalls
	name = "coveralls"
	desc = "A set of denim overalls."
	icon_state = "overalls"
	item_state = "overalls"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	species_restricted = list("exclude",SPECIES_NABBER)


/obj/item/clothing/suit/syndicatefake
	name = "red space suit replica"
	icon_state = "syndicate"
	desc = "A plastic replica of the syndicate space suit, you'll look just like a real murderous syndicate agent in this! This is a toy, it is not made for use in space!"
	w_class = ITEM_SIZE_NORMAL
	item_flags = null
	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/tank/oxygen_emergency,
		/obj/item/tank/oxygen_emergency_extended,
		/obj/item/tank/nitrogen_emergency,
		/obj/item/toy
	)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET

/obj/item/clothing/suit/hastur
	name = "\improper Hastur's Robes"
	desc = "Robes not meant to be worn by man."
	icon_state = "hastur"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/imperium_monk
	name = "\improper Imperium monk robe"
	desc = "Have YOU killed a xenos today?"
	icon_state = "imperium_monk"
	body_parts_covered = HEAD|UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/chickensuit
	name = "chicken suit"
	desc = "A suit made long ago by the ancient empire KFC."
	icon_state = "chickensuit"
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS|FEET
	flags_inv = HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	siemens_coefficient = 2.0


/obj/item/clothing/suit/monkeysuit
	name = "monkey suit"
	desc = "A suit that looks like a primate."
	icon_state = "monkeysuit"
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS|FEET|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	siemens_coefficient = 2.0


/obj/item/clothing/suit/holidaypriest
	name = "holiday priest robe"
	desc = "This is a nice holiday my son."
	icon_state = "holidaypriest"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT


/obj/item/clothing/suit/cardborg
	name = "cardborg suit"
	desc = "An ordinary cardboard box with holes cut in the sides."
	icon_state = "cardborg"
	item_flags = null
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/cardborg/Initialize()
	. = ..()
	set_extension(src, /datum/extension/appearance/cardborg)

/*
 * Misc
 */

/obj/item/clothing/suit/straight_jacket
	name = "straitjacket"
	desc = "A suit that completely restrains the wearer."
	icon_state = "straight_jacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL

/obj/item/clothing/suit/straight_jacket/equipped(mob/user, slot)
	if(slot == slot_wear_suit)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.drop_from_inventory(C.handcuffed)
		user.drop_l_hand()
		user.drop_r_hand()

/obj/item/clothing/suit/ianshirt
	name = "worn shirt"
	desc = "A worn out, curiously comfortable t-shirt with a picture of Ian. You wouldn't go so far as to say it feels like being hugged when you wear it, but it's pretty close. Good for sleeping in."
	icon_state = "ianshirt"
	body_parts_covered = UPPER_TORSO|ARMS

//coats

/obj/item/clothing/suit/leathercoat
	name = "leather coat"
	desc = "A long, thick black leather coat."
	icon_state = "leathercoat"

//stripper
/obj/item/clothing/under/stripper
	body_parts_covered = 0

/obj/item/clothing/under/stripper/stripper_pink
	name = "pink swimsuit"
	desc = "A rather skimpy pink swimsuit."
	icon_state = "stripper_p"
	siemens_coefficient = 1

/obj/item/clothing/under/stripper/stripper_green
	name = "green swimsuit"
	desc = "A rather skimpy green swimsuit."
	icon_state = "stripper_g"
	siemens_coefficient = 1

/obj/item/clothing/suit/stripper/stripper_pink
	name = "pink skimpy dress"
	desc = "A rather skimpy pink dress."
	icon_state = "stripper_p_over"
	siemens_coefficient = 1

/obj/item/clothing/suit/stripper/stripper_green
	name = "green skimpy dress"
	desc = "A rather skimpy green dress."
	icon_state = "stripper_g_over"
	siemens_coefficient = 1

/obj/item/clothing/under/stripper/mankini
	name = "mankini"
	desc = "No honest man would wear this abomination."
	icon_state = "mankini"
	siemens_coefficient = 1

/obj/item/clothing/suit/xenos
	name = "xenos suit"
	desc = "A suit made out of chitinous alien hide."
	icon_state = "xenos"
	item_flags = null
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	siemens_coefficient = 2.0
//swimsuit
/obj/item/clothing/under/swimsuit
	siemens_coefficient = 1
	body_parts_covered = 0

/obj/item/clothing/under/swimsuit/black
	name = "black swimsuit"
	desc = "An oldfashioned black swimsuit."
	icon_state = "swim_black"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/blue
	name = "blue swimsuit"
	desc = "An oldfashioned blue swimsuit."
	icon_state = "swim_blue"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/purple
	name = "purple swimsuit"
	desc = "An oldfashioned purple swimsuit."
	icon_state = "swim_purp"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/green
	name = "green swimsuit"
	desc = "An oldfashioned green swimsuit."
	icon_state = "swim_green"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/red
	name = "red swimsuit"
	desc = "An oldfashioned red swimsuit."
	icon_state = "swim_red"
	siemens_coefficient = 1

/obj/item/clothing/suit/poncho
	name = "poncho"
	desc = "A simple, comfortable poncho."
	species_restricted = null
	icon_state = "classicponcho"

/obj/item/clothing/suit/poncho/green
	name = "green poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is green."
	icon_state = "greenponcho"

/obj/item/clothing/suit/poncho/red
	name = "red poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is red."
	icon_state = "redponcho"

/obj/item/clothing/suit/poncho/purple
	name = "purple poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is purple."
	icon_state = "purpleponcho"

/obj/item/clothing/suit/poncho/blue
	name = "blue poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is blue."
	icon_state = "blueponcho"

/obj/item/clothing/suit/storage/toggle/bomber
	name = "bomber jacket"
	desc = "A thick, well-worn WW2 leather bomber jacket."
	icon_state = "bomber"
	body_parts_covered = UPPER_TORSO|ARMS
	cold_protection = UPPER_TORSO|ARMS
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.7

/obj/item/clothing/suit/storage/leather_jacket
	name = "black leather jacket"
	desc = "A black leather coat."
	icon_state = "leather_jacket"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/leather_jacket/nanotrasen
	name = "\improper NanoTrasen black leather jacket"
	desc = "A black leather coat. The NanoTrasen logo is proudly displayed on the back."
	icon_state = "leather_jacket_nt"

//This one has buttons for some reason
/obj/item/clothing/suit/storage/toggle/brown_jacket
	name = "leather jacket"
	desc = "A brown leather coat."
	icon_state = "brown_jacket"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/leather_hoodie
	name = "leather hoodie jacket"
	desc = "A brown leather hoodie, coloured in a dark tone. It's fun to tug at the strings."
	icon_state = "leather_hoodie"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	name = "\improper NanoTrasen leather jacket"
	desc = "A brown leather coat. The NanoTrasen logo is proudly displayed on the back."
	icon_state = "brown_jacket_nt"

/obj/item/clothing/suit/storage/toggle/agent_jacket
	name = "\improper SFP jacket"
	desc = "A black leather jacket belonging to an agent of the Sol Federal Police."
	icon_state = "agent_jacket"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/agent_jacket/formal
	name = "formal SFP coat"
	desc = "A black suit jacket belonging to an agent of the Sol Federal Police. It is of exceptional quality."
	icon_state = "agent_formal"

/obj/item/clothing/suit/storage/toggle/hoodie
	name = "hoodie"
	desc = "A warm sweatshirt."
	icon_state = "hoodie"
	min_cold_protection_temperature = T0C - 20
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/hoodie/cti
	name = "\improper CTI hoodie"
	desc = "A warm, black sweatshirt.  It bears the letters 'CTI' on the back, a lettering to the prestigious university in Tau Ceti, Ceti Technical Institute.  There is a blue supernova embroidered on the front, the emblem of CTI."
	icon_state = "cti_hoodie"

/obj/item/clothing/suit/storage/toggle/hoodie/mu
	name = "\improper Mariner University hoodie"
	desc = "A warm, gray sweatshirt.  It bears the letters 'MU' on the front, a lettering to the well-known public college, Mariner University."
	icon_state = "mu_hoodie"

/obj/item/clothing/suit/storage/toggle/hoodie/nt
	name = "\improper NanoTrasen hoodie"
	desc = "A warm, blue sweatshirt. It proudly bears the NanoTrasen logo on the back. The edges are trimmed with silver."
	icon_state = "nt_hoodie"

/obj/item/clothing/suit/storage/toggle/hoodie/smw
	name = "\improper Space Mountain Wind hoodie"
	desc = "A warm, black sweatshirt.  It has the logo for the popular softdrink Space Mountain Wind on both the front and the back."
	icon_state = "smw_hoodie"

/obj/item/clothing/suit/storage/toggle/hoodie/black
	name = "black hoodie"
	desc = "A warm, black sweatshirt."
	color = COLOR_DARK_GRAY

/obj/item/clothing/suit/storage/agent_rain
	name = "\improper SFP patrol cloak"
	desc = "A black raincloak belonging to an agent of the Sol Federal Police. It is almost certainly wind and waterproof."
	icon_state = "agent_raincloak"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	blood_overlay_type = "coatblood"

/obj/item/clothing/suit/storage/mbill
	name = "shipping jacket"
	desc = "A green jacket bearing the logo of Major Bill's Shipping."
	icon_state = "mbill"

/obj/item/clothing/suit/poncho/security
	name = "security poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is black and red, which are standard Security colors."
	icon_state = "secponcho"

/obj/item/clothing/suit/poncho/medical
	name = "medical poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is white with a blue tint, which are standard Medical colors."
	icon_state = "medponcho"

/obj/item/clothing/suit/poncho/engineering
	name = "engineering poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is yellow and orange, which are standard Engineering colors."
	icon_state = "engiponcho"

/obj/item/clothing/suit/poncho/science
	name = "science poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is white with purple trim, standard NanoTrasen Science colors."
	icon = 'icons/urist/restored/suits.dmi'
	icon_state = "sciponcho"
	item_icons = URIST_ALL_ONMOBS
	item_state = "sciponcho"

/obj/item/clothing/suit/poncho/nanotrasen
	name = "\improper NanoTrasen poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is white with a few red stripes, colors of NanoTrasen. Go NanoTrasen!"
	icon = 'icons/obj/clothing/obj_suit.dmi'
	icon_state = "sciponcho_nt"

/obj/item/clothing/suit/poncho/cargo
	name = "cargo poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is tan and grey, which are standard Cargo colors."
	icon_state = "cargoponcho"

/*
 * Track Jackets
 */
/obj/item/clothing/suit/storage/toggle/track
	name = "track jacket"
	desc = "A track jacket, for the athletic."
	icon_state = "trackjacket"

/obj/item/clothing/suit/storage/toggle/track/blue
	name = "blue track jacket"
	desc = "A blue track jacket, for the athletic."
	icon_state = "trackjacketblue"

/obj/item/clothing/suit/storage/toggle/track/green
	name = "green track jacket"
	desc = "A green track jacket, for the athletic."
	icon_state = "trackjacketgreen"

/obj/item/clothing/suit/storage/toggle/track/red
	name = "red track jacket"
	desc = "A red track jacket, for the athletic."
	icon_state = "trackjacketred"

/obj/item/clothing/suit/storage/toggle/track/white
	name = "white track jacket"
	desc = "A white track jacket, for the athletic."
	icon_state = "trackjacketwhite"

/obj/item/clothing/suit/storage/toggle/track/gcc
	name = "\improper GCC track jacket"
	desc = "An Independent track jacket, for the truly cheeki breeki."
	icon_state = "trackjackettcc"

/obj/item/clothing/suit/rubber
	name = "human suit"
	desc = "A Human suit made out of rubber."
	icon_state = "mansuit"
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL

/obj/item/clothing/suit/rubber/cat
	name = "cat suit"
	desc = "A cat suit made out of rubber."
	icon_state = "catsuit"

/obj/item/clothing/suit/rubber/skrell
	name = "skrell suit"
	desc = "A Skrell suit made out of rubber."
	icon_state = "skrellsuit"

/obj/item/clothing/suit/rubber/unathi
	name = "unathi suit"
	desc = "A Unathi suit made out of rubber."
	icon_state = "lizsuit"

/obj/item/clothing/suit/hospital
	name = "hospital gown"
	desc = "A thin, long and loose robe-like garment worn by people undergoing active medical treatment."
	icon_state = "hospitalgown"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	allowed = null

/obj/item/clothing/suit/hospital/blue
	color = "#99ccff"

/obj/item/clothing/suit/hospital/green
	color = "#8dd7a3"

/obj/item/clothing/suit/hospital/pink
	color = "#ffb7db"


/obj/item/clothing/suit/storage/toggle/zipper
	name = "zip up sweater"
	desc = "A black sweater that zips up in the front."
	icon_state = "zipperjacket"


/obj/item/clothing/suit/storage/pullover
	name = "pullover sweater"
	desc = "A sweater made of a soft material with a short zipper on the collar."
	icon_state = "pullover"
