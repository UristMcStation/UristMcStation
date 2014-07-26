 /*										*****New space to put all UristMcStation Gloves!*****

Please keep it tidy, by which I mean put comments describing the item before the entry. Icons go to 'icons/urist/items/clothes/gloves.dmi' and on- mob
icon_override sprites go to 'icons/uristmob/gloves.dmi' Items should go to clothing/gloves/urist to avoid worrying about the sprites.-Glloyd*/

//generic define

/obj/item/clothing/gloves/urist
	urist_only = 1
	icon_override = 'icons/uristmob/gloves.dmi'
	icon = 'icons/urist/items/clothes/gloves.dmi'

//cunts. fucking alien cunts.

/obj/item/clothing/gloves/attackby(obj/item/weapon/W, mob/user)

	if(istype(W, /obj/item/weapon/wirecutters) || istype(W, /obj/item/weapon/scalpel))
		//clipping fingertips
		if(!clipped)
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
			user.visible_message("\red [user] cuts the fingertips off of the [src].","\red You cut the fingertips off of the [src].")

			clipped = 1
			name = "mangled [name]"
			desc = "[desc]<br>They have had the fingertips cut off of them."
			if("exclude" in species_restricted)
				species_restricted -= "Unathi"
				species_restricted -= "Tajaran"
			return
		else
			user << "<span class='notice'>The [src] have already been clipped!</span>"
			update_icon()
			return

		return
	..()

//Engineers need their PPE!

/obj/item/clothing/gloves/leather //these are actually the best gloves in the game.
	desc = "These tactical gloves are somewhat fire and impact resistant."
	name = "combat gloves"
	icon_state = "black"
	item_state = "swat_gl"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)