//shipweapon ammo, moved from ammo_weapons.dm

/obj/structure/shipammo
	var/load_amount = 1 //how much ammo do we give
	var/shield_damage = 0 //we transfer these damage values to the weapon we're using
	var/hull_damage = 0
	var/pass_shield = FALSE
	var/component_hit = 0
	var/component_modifier_low = 0.2
	var/component_modifier_high = 0.5
	density = FALSE
	anchored = FALSE
	var/short_name //for the display
	var/list/origin_tech = list()

//torpedo ammo

/obj/structure/shipammo/torpedo //torpedos are slightly different for now because of the building process. so the damage stats are stored in the warhead and transferred to the ammo once it's put together.
	name = "torpedo casing" //future ammo types will be more simple, thankfully
	icon = 'icons/urist/items/ship_projectiles48x48.dmi' //but for now torpedos are special little guys
	icon_state = "bigtorpedo-unloaded"
	load_amount = 0
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
		component_modifier_low = warhead.component_modifier_low
		component_modifier_high = warhead.component_modifier_high
		desc = "A large torpedo used in ship-to-ship weaponry. It is loaded with a [warhead.name]."
		icon_state = "bigtorpedo-[warhead.icon_state]"
		name = "[warhead.ammo_name] torpedo"
		load_amount = 1

/obj/structure/shipammo/torpedo/attackby(obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/shipweapons/torpedo_warhead))
		if(!src.load_amount && user.unEquip(I, src))
			load_amount = 1
			warhead = I
			icon_state = "bigtorpedo-[warhead.icon_state]" //come back to this
//			icon_state = "bigtorpedo"
			shield_damage = warhead.shield_damage
			hull_damage = warhead.hull_damage
			pass_shield = warhead.pass_shield
			component_modifier_low = warhead.component_modifier_low
			component_modifier_high = warhead.component_modifier_high
			name = "[warhead.ammo_name] torpedo"
			desc = "A large torpedo used in ship-to-ship weaponry. It is loaded with a [warhead.name]."

			to_chat(user, "<span class='notice'>You insert the torpedo warhead into the torpedo casing, arming the torpedo.</span>") //torpedo

		else
			to_chat(user, "<span class='notice'>This torpedo already has a warhead in it!</span>") //torpedo

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
			component_modifier_low = initial(component_modifier_low)
			component_modifier_high = initial(component_modifier_high)
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
	load_amount = 48 //12 shots for the regular autocannon, 8 for the rapid one.

/obj/structure/shipammo/light_autocannon/ap
	name = "armour-piercing light autocannon ammunition"
	short_name = "armour-piercing"
	hull_damage = 21//21 * 4 = 84 per shot for the regular autocannon. 84 * 12 shots = 1008 damage and reloaded in 60 seconds (16.8 dps). rapid = 1008 damage and reloaded in 40 seconds (25.2 dps)
					//let's see if this buff makes things more useful
	matter = list(MATERIAL_STEEL = 2000, MATERIAL_ALUMINIUM = 300)

/obj/structure/shipammo/light_autocannon/he
	name = "high-explosive light autocannon ammunition"
	short_name = "high-explosive"
	hull_damage = 14//14 * 4 = 56 per shot for the regular autocannon. 56 * 12 shots = 672 damage and reloaded in 60 seconds (11.2 dps). rapid = 672 damage and reloaded in 40 seconds (16.8 dps)
	shield_damage = 7//7 * 4 = 28 per shot for the regular autocannon. 28 * 12 shots = 336 damage and reloaded in 60 seconds (5.6 dps). rapid = 336 damage and reloaded in 40 seconds (8.4)
	matter = list(MATERIAL_STEEL = 1500, MATERIAL_PLASTIC = 300, MATERIAL_ALUMINIUM = 400) //not great damage values, but it's meant for blasting components, which have low health.
	component_hit = 50
	component_modifier_low = 0.25
	component_modifier_high = 0.55

/obj/structure/shipammo/heavy_autocannon //maybe increase the load amount, and change values to compensate
	icon = 'icons/urist/items/ship_projectiles.dmi'
	icon_state = "ammo_box"
	load_amount = 24

/obj/structure/shipammo/heavy_autocannon/ap
	name = "armour-piercing heavy autocannon ammunition"
	short_name = "armour-piercing"
	hull_damage = 90	// 90 * 2 = 180 per shot. 180 * 12 shots = 2160 damage and reloaded in 70 seconds (30.86 dps)

/obj/structure/shipammo/heavy_autocannon/he
	name = "high-explosive heavy autocannon ammunition"
	short_name = "high-explosive"
	hull_damage = 60	// 60 * 2 = 120 per shot. 120 * 12 shots = 1440 damage and reloaded in 70 seconds (18.26 dps)
	shield_damage = 25  // 25 * 2 = 50 per shot. 50 * 12 shots = 600 damage and reloaded in 70 seconds (8.57 dps)
	component_hit = 55
	component_modifier_low = 0.275
	component_modifier_high = 0.575
