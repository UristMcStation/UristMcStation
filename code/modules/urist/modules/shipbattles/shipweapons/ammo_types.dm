//shipweapon ammo, moved from ammo_weapons.dm

/obj/structure/shipammo
	var/load_amount = 1 //how much ammo do we give
	var/shield_damage = 0 //we transfer these damage values to the weapon we're using
	var/hull_damage = 0
	var/pass_shield = FALSE
	var/component_hit = 0
	density = 0
	anchored = 0
	var/short_name //for the display

//torpedo ammo

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
	short_name = "bluespace"

/obj/structure/shipammo/torpedo/emp
	load_amount = 1
	warhead = /obj/item/shipweapons/torpedo_warhead/emp
	short_name = "EMP"

/obj/structure/shipammo/torpedo/ap
	load_amount = 1
	warhead = /obj/item/shipweapons/torpedo_warhead/ap
	short_name = "armour-piercing"

//non torpedo ammo

//autocannons

/obj/structure/shipammo/light_autocannon
	icon = 'icons/urist/items/ship_projectiles.dmi'
	icon_state = "ammo_box"
	load_amount = 24 //6 shots for the regular autocannon, 4 for the rapid one.

/obj/structure/shipammo/light_autocannon/ap
	name = "armour-piercing light autocannon ammunition"
	short_name = "armour-piercing"
	hull_damage = 20//20 * 4 = 80 per shot for the regular autocannon. 80 * 6 shots = 480 damage and reloaded in 36 seconds (13.3 dps). rapid = 480 damage and reloaded in 28 seconds (17.14 dps) not great,
					//but that's the point, because this is something that RnD can build. this will likely need to be adjusted though.
	matter = list(MATERIAL_STEEL = 2000, MATERIAL_ALUMINIUM = 200)

/obj/structure/shipammo/light_autocannon/he
	name = "high-explosive light autocannon ammunition"
	short_name = "high-explosive"
	hull_damage = 15//15 * 4 = 60 per shot for the regular autocannon. 60 * 6 shots = 360 damage and reloaded in 36 seconds (10 dps). rapid = 360 damage and reloaded in 28 seconds (12.86 dps)
	shield_damage = 8//8 * 4 = 32 per shot for the regular autocannon. 32 * 6 shots = 192 damage and reloaded in 36 seconds (5.33 dps). rapid = 192 damage and reloaded in 28 seconds (6.86)
	matter = list(MATERIAL_STEEL = 1500, MATERIAL_PLASTIC = 250, MATERIAL_ALUMINIUM = 400)

/obj/structure/shipammo/heavy_autocannon //maybe increase the load amount, and change values to compensate
	icon = 'icons/urist/items/ship_projectiles.dmi'
	icon_state = "ammo_box"
	load_amount = 12

/obj/structure/shipammo/heavy_autocannon/ap
	name = "armour-piercing heavy autocannon ammunition"
	short_name = "armour-piercing"
	hull_damage = 90	// 90 * 2 = 180 per shot. 180 * 6 shots = 1080 damage and reloaded in 46 seconds (23.48 dps)

/obj/structure/shipammo/heavy_autocannon/he
	name = "high-explosive heavy autocannon ammunition"
	short_name = "high-explosive"
	hull_damage = 70	// 70 * 2 = 140 per shot. 140 * 6 shots = 840 damage and reloaded in 46 seconds (18.26 dps)
	shield_damage = 30  // 30 * 2 = 60 per shot. 60 * 6 shots = 360 damage and reloaded in 46 seconds (7.83 dps)