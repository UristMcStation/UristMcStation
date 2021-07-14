//shipweapons that use ammo - formerly missile_weapons.dm

/obj/machinery/shipweapons/ammo //changed from /obj/machinery/shipweapons/missile to reflect that other weapons use ammo as well.
	icon = 'icons/urist/96x96.dmi'
	var/loaded = 0 //how much ammo is loaded
	var/maxload = 1 //in case we have missile arrays
	var/ammo_type //what is the type of ammo we can use
	var/obj/structure/shipammo/loaded_ammo //the ammo we have loaded right now
	var/fire_amount = 1 //how much ammo are we using
	status = NO_AMMO|CHARGED
	var/load_sound = 'sound/urist/shipweapons/shipweapons_mac_load.ogg'

/obj/machinery/shipweapons/ammo/Fire()
	if(..())	//Fire proc now returns TRUE or FALSE depending on if it actually fired. This way we don't lose ammo if the weapon actually can't fire (powerloss, etc)
		loaded -= fire_amount
		if(!loaded)
			status |= NO_AMMO
			update_icon()
			qdel(loaded_ammo) //bye bye ammo
			UpdateStats(FALSE)

/obj/machinery/shipweapons/ammo/attack_hand(mob/user as mob)
	if(loaded)
		..()

	else
		user << "<span class='warning'>The [src.name] isn't loaded!</span>"
		return

/obj/machinery/shipweapons/ammo/proc/DoLoading(var/obj/structure/shipammo/ammo)
	if(istype(ammo, ammo_type)) //checking this again, just to be sure
		if(ammo.load_amount && !src.loaded && !src.loaded_ammo) //come back to this with maxload if it becomes necessary for missiles. i guess it could work for half-loading some of the new stuff, but it's not really necessary atm.
			src.loaded += ammo.load_amount
			src.status &= ~NO_AMMO
			src.update_icon()
			ammo.forceMove(src)
			loaded_ammo = ammo
			UpdateStats(TRUE)
			playsound(src, load_sound, 40, 1)

/obj/machinery/shipweapons/ammo/proc/UpdateStats(var/loading)
	if(loading)
		shield_damage = loaded_ammo.shield_damage //here we pass the damage values along
		hull_damage = loaded_ammo.hull_damage
		pass_shield = loaded_ammo.pass_shield
		if(loaded_ammo.component_hit)
			component_hit = loaded_ammo.component_hit

	else
		shield_damage = initial(shield_damage) //here we reset the damage values
		hull_damage = initial(hull_damage)
		pass_shield = initial(pass_shield)
		component_hit = initial(component_hit)

/obj/machinery/shipweapons/ammo/update_icon()
	..()

	if(status == CHARGED)
		icon_state = "[initial(icon_state)]-loaded"

/obj/machinery/shipweapons/ammo/Bumped(atom/movable/AM as mob|obj)
	..()
	if(istype(AM, ammo_type))
		var/obj/structure/shipammo/ammo = AM
		DoLoading(ammo)

/obj/machinery/shipweapons/ammo/Crossed(var/atom/movable/AM)
	..()
	if(istype(AM, ammo_type))
		var/obj/structure/shipammo/ammo = AM
		DoLoading(ammo)

/obj/machinery/shipweapons/ammo/attackby(obj/item/W as obj, mob/living/user as mob)
	if(isCrowbar(W) && loaded_ammo)
		to_chat(user, "<span class='warning'>You pry the [loaded_ammo] out of the [src]. It will need to be reloaded before firing again.</span>")
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
	active_power_usage = 2500
	component_hit = 25
	rechargerate = 16 SECONDS
	ammo_type = /obj/structure/shipammo/torpedo
	projectile_type = /obj/item/projectile/bullet/ship/missile/bigtorpedo
	fire_sound = 'sound/weapons/railgun.ogg'
	fire_amount = 1
	pass_shield = TRUE