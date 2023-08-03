/*										*****New space to put all UristMcStation Shoes and Boots!*****

Please keep it tidy, by which I mean put comments describing the item before the entry. Icons go to 'icons/urist/items/clothes/shoes.dmi' and on- mob
icon_override sprites go to 'icons/uristmob/shoes.dmi' Items should go to clothing/shoes/urist to avoid worrying about the sprites -Glloyd*/

//generic define

/obj/item/clothing/shoes/urist
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/shoes.dmi'

//obviously the guy who made the equipment for engineers never worked a blue collar job in his life. The engineers
//ingame wouldn't even be allowed on a modern constuction site without steel toed boots, let alone allowed to work on one.

/obj/item/clothing/shoes/urist/leather //not OP. Corai said so ;)
	desc = "A pair of steel toed leather work boots. They are quite heavy, but protect your feet from most brute damage and have a thin metal strip in the sole to protect against nails. The rubber bottoms protect against slipping."
	name = "leather boots"
	icon_state = "leather"
	permeability_coefficient = 0.05
	item_flags = ITEM_FLAG_NOSLIP
	species_restricted = null
	siemens_coefficient = 0.6
	armor = list(melee = 50, bullet = 0, laser = 5,energy = 0, bomb = 5, bio = 10, rad = 0)

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE



/obj/item/clothing/shoes/urist/leather/New()
	..()
	slowdown_per_slot[slot_shoes] = 0

//winter boots, for the shoevend

/obj/item/clothing/shoes/urist/winter
	desc = "A pair of cozy winter boots. Those will surely keep your toes from falling off!"
	name = "winter boots"
	icon_state = "winterboots"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE

//kneesocks, for the shoevend

/obj/item/clothing/shoes/urist/kneesock/white
	desc = "A pair of cute white kneesocks."
	name = "white kneesocks"
	icon_state = "kneesock"
	item_state = "kneesock"

/obj/item/clothing/shoes/urist/kneesock/purplestriped
	desc = "A pair of cute purple and black striped kneesocks."
	name = "purple striped kneesocks"
	icon_state = "bgkneesock"
	item_state = "bgkneesock"

/obj/item/clothing/shoes/urist/kneesock/striped
	desc = "A pair of cute white and black striped kneesocks."
	name = "black striped kneesocks"
	icon_state = "stripedkneesock"
	item_state = "stripedkneesock"

/obj/item/clothing/shoes/urist/kneesock/black
	desc = "A pair of cute black kneesocks."
	name = "black kneesocks"
	icon_state = "blackkneesock"
	item_state = "blackkneesock"

/obj/item/clothing/shoes/urist/footwraps
	name = "cloth footwraps"
	desc = "A roll of treated canvas used for wrapping claws or paws"
	icon_state = "clothwrap"
	item_state = "clothwrap"
	force = 0
	w_class = ITEM_SIZE_SMALL
	species_restricted = null
