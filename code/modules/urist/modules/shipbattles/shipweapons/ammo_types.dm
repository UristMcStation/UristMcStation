//shipweapon ammo, moved from ammo_weapons.dm

/obj/structure/shipammo
	var/load_amount = 1 //how much ammo do we give
	var/shield_damage = 0 //we transfer these damage values to the weapon we're using
	var/hull_damage = 0
	var/pass_shield = FALSE
	var/component_hit = 0
	density = 0
	anchored = 0

.//torpedo ammo

/obj/structure/shipammo/torpedo //torpedos are slightly different for now because of the building process. so the damage stats are stored in the warhead and transferred to the ammo once it's put together.
	name = "torpedo casing" //future ammo types will be more simple, thankfully
	icon = 'icons/urist/items/ship_projectiles48x48.dmi' //but for now torpedos are special little guys
	icon_state = "bigtorpedo-unloaded"
	load_amount = 1
	var/obj/item/shipweapons/torpedo_warhead/warhead = null
	matter = list(DEFAULT_WALL_MATERIAL = 2500)
	dir = 4

/obj/structure/shipammo/torpedo/New()
	..()
	pixel_y = rand(-20,2)
	if(ispath(warhead))
		warhead = new warhead(src)
		shield_damage = warhead.shield_damage
		hull_damage = warhead.hull_damage
		pass_shield = warhead.pass_shield
		component_hit = warhead.component_hit
		desc = "A large torpedo used in ship-to-ship weaponry. It is loaded with a [warhead.name]."
		icon_state = "bigtorpedo-[warhead.icon_state]"
		name = "[warhead.ammo_name] torpedo"

/obj/structure/shipammo/torpedo/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/shipweapons/torpedo_warhead))
		if(!src.load_amount && user.unEquip(I, src))
			load_amount = 1
			warhead = I
			icon_state = "bigtorpedo-[warhead.icon_state]" //come back to this
//			icon_state = "bigtorpedo"
			shield_damage = warhead.shield_damage
			hull_damage = warhead.hull_damage
			pass_shield = warhead.pass_shield
			name = "[warhead.ammo_name] torpedo"
			desc = "A large torpedo used in ship-to-ship weaponry. It is loaded with a [warhead.name]."

			user << "<span class='notice'>You insert the torpedo warhead into the torpedo casing, arming the torpedo.</span>" //torpedo

		else
			user << "<span class='notice'>This torpedo already has a warhead in it!</span>" //torpedo

	else if(isCrowbar(I))
		if(warhead)
			warhead.dropInto(loc)
			to_chat(user, "<span class='notice'>You remove the torpedo warhead.</span>")
			name = initial(name)
			desc = initial(desc)
			warhead = null
			load_amount = 0
			icon_state = "bigtorpedo-unloaded"
			shield_damage = 0
			hull_damage = 0
			pass_shield = FALSE
			component_hit = 0

	else
		..()

/obj/structure/shipammo/torpedo/bluespace //names are set in New()
	load_amount = 1
	warhead = /obj/item/shipweapons/torpedo_warhead/bluespace

/obj/structure/shipammo/torpedo/emp
	load_amount = 1
	warhead = /obj/item/shipweapons/torpedo_warhead/emp

/obj/structure/shipammo/torpedo/ap
	load_amount = 1
	warhead = /obj/item/shipweapons/torpedo_warhead/ap