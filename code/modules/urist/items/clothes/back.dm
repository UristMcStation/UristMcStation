/*										*****New space to put all UristMcStation On-Back Clothing ('cept duffel bags*****

Please keep it tidy, by which I mean put comments describing the item before the entry. Icons go to 'icons/urist/items/clothes/back.dmi' and on- mob
icon_override sprites go to 'icons/uristmob/back.dmi' -Glloyd*/

//The Roboticist Satchel and Backpack - TGameCo

/obj/item/storage/backpack/urist
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/back.dmi'
	item_icons = null
	item_state_slots = null

/obj/item/storage/backpack/urist/satchel_robo
	urist_only = 0
	name = "Robotics Satchel"
	desc = "A Satchel with roboticist markings on it"
	icon_state = "satchel-robo"

/obj/item/storage/backpack/urist/robo
	urist_only = 0
	name = "Robotics Backpack"
	desc = "A Backpack with roboticist markings on it"
	icon_state = "backpack-robo"

//The stereotypical opera cape. Intended for vamps, but I guess you could use it to play ZE ANZHEL OF MUZIK or cause some toil and trouble or something.
//Acts as a backpack, so the antag doesn't have to sacrifice storage for  - scrdest

/obj/item/storage/backpack/urist/cape
	name = "opera cape"
	desc = "A large piece of velvet, originally designed to keep rain out and warmth in. A number of pockets in the lining  allow for storage."
	icon_state = "vcape"

//explorer backpack

/obj/item/storage/backpack/urist/explorerpack
	name = "rugged backpack"
	desc = "A large rugged backpack with a number of pockets. Very practical, and commonly used out in the frontier of human space."
	icon_state = "explorerpack"

/obj/item/storage/backpack/urist/explorersatchel
	name = "rugged satchel"
	desc = "A large rugged satchel with a number of pockets. Very practical, and commonly used out in the frontier of human space."
	icon_state = "satchel-explorer"
