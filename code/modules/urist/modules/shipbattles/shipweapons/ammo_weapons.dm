//shipweapons that use ammo - formerly missile_weapons.dm

/obj/machinery/shipweapons/ammo //changed from /obj/machinery/shipweapons/missile to reflect that other weapons use ammo as well.
	var/loaded = 0 //how much ammo is loaded
	var/maxload = 1 //in case we have missile arrays
	var/ammo_type //what is the type of ammo we can use
	var/obj/structure/shipammo/loaded_ammo //the ammo we have loaded right now
	var/fire_amount = 1 //how much ammo are we using
	status = NO_AMMO|CHARGED
	var/load_sound = 'sound/urist/shipweapons/shipweapons_mac_load.ogg'
	var/load_delay = 0

/obj/machinery/shipweapons/ammo/Fire()
	if(..())	//Fire proc now returns TRUE or FALSE depending on if it actually fired. This way we don't lose ammo if the weapon actually can't fire (powerloss, etc)
		loaded = max(loaded - fire_amount, 0)
		if(!loaded)
			status |= NO_AMMO
			update_icon()
			QDEL_NULL(loaded_ammo) //bye bye ammo
			UpdateStats(FALSE)

/obj/machinery/shipweapons/ammo/attack_hand(mob/user as mob)
	if(loaded)
		..()

	else
		to_chat(user, "<span class='warning'>The [src.name] isn't loaded!</span>")
		return

/obj/machinery/shipweapons/ammo/Charging()
	if(!loaded) //if we're not loaded, we can't recharge
		return

	..()

/obj/machinery/shipweapons/ammo/proc/DoLoading(obj/structure/shipammo/ammo)
	if(istype(ammo, ammo_type)) //checking this again, just to be sure
		if(ammo.load_amount && !src.loaded && !src.loaded_ammo) //are we out of ammo, and does the ammo have ammo?
			ammo.forceMove(src)
			src.loaded_ammo = ammo //set our loaded ammo type. this prevents further loading while the rest of the loading process finishes
			playsound(src, load_sound, 40, 1)
			status &= ~NO_AMMO
			status |= LOADING
			spawn(load_delay)
				src.loaded += ammo.load_amount //load the gun
				status &= ~LOADING
				update_icon()
				UpdateStats(TRUE) //get the damage stats from our loaded ammo
				Charging()//now we charge

/obj/machinery/shipweapons/ammo/proc/UpdateStats(loading)
	if(loading && loaded_ammo)
		name = "[initial(name)] ([loaded_ammo.short_name])"
		shield_damage = loaded_ammo.shield_damage * src.fire_amount //here we pass the damage values along
		hull_damage = loaded_ammo.hull_damage * src.fire_amount //damage values are multiplied by the fire amount so we can have weapons that use the same ammo but simulate different fire rates
		pass_shield = loaded_ammo.pass_shield
		component_modifier_low = loaded_ammo.component_modifier_low
		component_modifier_high = loaded_ammo.component_modifier_high
		if(loaded_ammo.component_hit)
			component_hit = loaded_ammo.component_hit

	else
		name = initial(name)
		shield_damage = initial(shield_damage) //here we reset the damage values
		hull_damage = initial(hull_damage)
		pass_shield = initial(pass_shield)
		component_hit = initial(component_hit)
		component_modifier_low = initial(component_modifier_low)
		component_modifier_high = initial(component_modifier_high)

/obj/machinery/shipweapons/ammo/on_update_icon()
	..()

	if(status & LOADING)
		icon_state = "[initial(icon_state)]-charging"

/obj/machinery/shipweapons/ammo/Bumped(atom/movable/AM as mob|obj)
	..()
	if(istype(AM, ammo_type))
		var/obj/structure/shipammo/ammo = AM
		DoLoading(ammo)

/obj/machinery/shipweapons/ammo/Crossed(atom/movable/AM)
	..()
	if(istype(AM, ammo_type))
		var/obj/structure/shipammo/ammo = AM
		DoLoading(ammo)

/obj/machinery/shipweapons/ammo/use_tool(obj/item/W as obj, mob/living/user as mob, click_params)
	if(isCrowbar(W) && loaded_ammo)
		to_chat(user, "<span class='warning'>You pry the [loaded_ammo] out of the [src]. It will need to be reloaded before firing again.</span>")
		playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
		loaded_ammo.dropInto(user.loc) //drop the ammo
		loaded_ammo = null //null it out
		loaded = 0 //then update all the relevant stats
		status |= NO_AMMO
		update_icon()
		UpdateStats(FALSE)

	else
		..()

//torpedo launcher

/obj/machinery/shipweapons/ammo/torpedo
	name = "torpedo launcher"
	icon_state = "torpedo"
//	hull_damage = 350 //maybe
	active_power_usage = 3000
	component_hit = 25
	rechargerate = 16 SECONDS
	ammo_type = /obj/structure/shipammo/torpedo
	projectile_type = /obj/meteor/shipmissile/bigtorpedo
	fire_sound = 'sound/weapons/railgun.ogg'
	fire_amount = 1
	can_intercept = TRUE
	icon = 'icons/urist/96x96.dmi'

/obj/machinery/shipweapons/ammo/autocannon
	icon = 'icons/urist/structures&machinery/64x32machinery.dmi'
	external = TRUE

/obj/machinery/shipweapons/ammo/autocannon/light
	name = "light autocannon"
	active_power_usage = 800
	component_hit = 5
	icon_state = "cannon"
	rechargerate = 4 SECONDS //pewpewpew
	ammo_type = /obj/structure/shipammo/light_autocannon
	fire_sound = 'sound/urist/shipweapons/shipweapons_cannon.ogg'
	load_delay = 12 SECONDS
	fire_amount = 4

/obj/machinery/shipweapons/ammo/autocannon/light/rapid
	name = "rapid light autocannon"
	icon_state = "dualcannon"
	load_delay = 16 SECONDS
	rechargerate = 3 SECONDS //pewpewpew
	fire_amount = 6

/obj/machinery/shipweapons/ammo/autocannon/heavy
	name = "heavy autocannon"
	icon_state = "artillery"
	fire_sound = 'sound/urist/shipweapons/shipweapons_cannon.ogg'
	load_delay = 22 SECONDS
	rechargerate = 4 SECONDS //pewpewpew
	fire_amount = 2
	ammo_type = /obj/structure/shipammo/heavy_autocannon

/obj/machinery/shipweapons/ammo/cannon //come back to this
	name = "heavy cannon"
	icon_state = "howitzer"
	fire_sound = 'sound/urist/shipweapons/shipweapons_railgun_fire.ogg'
	load_delay = 16 SECONDS
	rechargerate = 6 SECONDS
	fire_amount = 1
