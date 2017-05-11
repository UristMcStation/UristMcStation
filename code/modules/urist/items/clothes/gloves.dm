/*										*****New space to put all UristMcStation Gloves!*****

Please keep it tidy, by which I mean put comments describing the item before the entry. Icons go to 'icons/urist/items/clothes/gloves.dmi' and on- mob
icon_override sprites go to 'icons/uristmob/gloves.dmi' Items should go to clothing/gloves/urist to avoid worrying about the sprites.-Glloyd*/

//generic define

/obj/item/clothing/gloves/urist
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/gloves.dmi'

//cunts. fucking alien cunts.

/obj/item/clothing/gloves/attackby(obj/item/weapon/W, mob/user)

	if(istype(W, /obj/item/weapon/wirecutters) || istype(W, /obj/item/weapon/scalpel))
		//clipping fingertips
		if(!clipped)
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
			user.visible_message("<span class='warning'> [user] cuts the fingertips off of the [src].</span>","<span class='warning'> You cut the fingertips off of the [src].</span>")

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

/obj/item/clothing/gloves/urist/leather //these are actually the best gloves in the game. //invalidating my comment 5 minutes after I write it. I win life.
	desc = "A pair of leather gloves worn by engineers. These gloves protect against hurting one's hands while working, and have the added benefits of being insulated against electric shock, as well as being heat resistant. A cloth liner inside also provides cold resistance."
	name = "leather work gloves" //not OP. Corai said so ;)
	icon_state = "leather" //although, they're second only to swat gloves and combat gloves, although only combat are insulated as well.
	item_state = "leather"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 15, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)