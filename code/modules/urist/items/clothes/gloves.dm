/*										*****New space to put all UristMcStation Gloves!*****

Please keep it tidy, by which I mean put comments describing the item before the entry. Icons go to 'icons/urist/items/clothes/gloves.dmi' and on- mob
icon_override sprites go to 'icons/uristmob/gloves.dmi' Items should go to clothing/gloves/urist to avoid worrying about the sprites.-Glloyd*/

//generic define

/obj/item/clothing/gloves/urist
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/gloves.dmi'

//Engineers need their PPE!

/obj/item/clothing/gloves/urist/leather //these are actually the best gloves in the game. //invalidating my comment 5 minutes after I write it. I win life.
	desc = "A pair of leather gloves worn by engineers. These gloves protect against hurting one's hands while working, and have the added benefits of being insulated against electric shock, as well as being heat resistant. A cloth liner inside also provides cold resistance."
	name = "leather work gloves" //not OP. Corai said so ;)
	icon_state = "leather" //although, they're second only to swat gloves and combat gloves, although only combat are insulated as well.
	item_state = "lightbrowngloves"
	item_icons = null
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 15, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

// Biohazard Gloves.

/obj/item/clothing/gloves/biohazard
	desc = "These rubber gloves are made to assist in protecting the user from biological hazards."
	name = "biohazard rubber gloves"
	icon = 'icons/urist/items/clothes/gloves.dmi'
	icon_override = 'icons/uristmob/gloves.dmi'
	icon_state = "rubbergloves"
	item_state = "rubbergloves"
	body_parts_covered = HANDS|ARMS
