/obj/machinery/shipweapons
	name = "shipweapon"
	idle_power_usage = 10
	active_power_usage = 1000
	var/passshield = 0
	var/shielddamage = 0
	var/hulldamage = 0
	var/shipid = null
	var/canfire = 0
	var/recharging = 0
	var/charged = 0
	var/rechargerate = 100
	var/chargingicon = null
	var/chargedicon = null
	var/target = null

/obj/machinery/shipweapons/Initialize()
	for(var/obj/machinery/computer/combatcomputer/CC in SSmachines.machinery)
		CC.linkedweapons += src
	..()

/obj/machinery/shipweapons/Process()
	..()

/obj/machinery/shipweapons/proc/Charging()
	charged = 0
	update_use_power(2)
	recharging = 1
	update_icon()
	spawn(rechargerate)
		charged = 1
		update_icon()
		canfire = 1
		update_use_power(1)

/obj/machinery/shipweapons/attack_hand(mob/user as mob) //we can fire it by hand in a pinch
	if(charged)
		var/want = input("Fire the [src]?") in list ("Cancel", "Yes")
		switch(want)
			if("Cancel")
				return
			if("Yes")
				if(charged) //just in case, we check again
					user << "<span class='warning'>You fire the [src].</span>"
					Fire()
				else
					user << "<span class='warning'>The [src] needs to charge!</span>"

		return
	else
		user << "<span class='warning'>The [src] needs to charge!</span>"

/obj/machinery/shipweapons/proc/Fire()
	if(!target) //maybe make it fire and recharge if people are dumb?
		return

	else
		//do the firing stuff
		var/mob/living/simple_animal/hostile/overmapship/OM = target
		//insert firing animations here
		if(!passshield)
			if(OM.shields)
				var/shieldbuffer = OM.shields
				OM.shields -= shielddamage //take the hit
				if(OM.shields <= 0) //if we're left with less than 0 shields
					OM.shields = 0 //we reset the shields to zero to avoid any weirdness
					//we also apply damage to the actual shield component
					if(hulldamage)
						shieldbuffer = (hulldamage-shieldbuffer) //hulldamage is slightly mitigated by the existing shield
						if(shieldbuffer <=0) //but if the shield was really strong, we don't do anything
							return
						else
							OM.health -= shieldbuffer

			else if(!OM.shields) //no shields? easy
				OM.health -= hulldamage

		else if(passshield) //do we pass through the shield? let's do our damage
			OM.health -= hulldamage

		Charging() //time to recharge

/obj/machinery/shipweapons/update_icon()
	if(charged)
		icon_state = "[initial(icon_state)]-charged"
	if(recharging)
		icon_state = "[initial(icon_state)]-charging"

	else
		icon_state = initial(icon_state)

/obj/machinery/shipweapons/missile
	icon = 'icons/urist/96x96.dmi'
	passshield = 1
	var/loaded = 0
	var/maxload = 1 //in case we have missile arrays

/obj/machinery/shipweapons/missile/Fire()
	loaded -= 1
	..()

/obj/machinery/shipweapons/missile/attack_hand(mob/user as mob)
	if(loaded)
		..()

	else
		user << "<span class='warning'>The [src] isn't loaded!</span>"
		return


/obj/machinery/shipweapons/missile/torpedo
	name = "torpedo launcher"
	icon_state = "torpedo"
	hulldamage = 400 //maybe
//	active_power_usage = 1000

/obj/machinery/shipweapons/beam
	icon = 'icons/urist/structures&machinery/64x64machinery.dmi'

/obj/machinery/shipweapons/beam/lightlaser
	name = "light laser cannon"
	shielddamage = 200
	hulldamage = 200
	icon_state = "beamcannon"
	idle_power_usage = 10
	active_power_usage = 2000

/obj/machinery/shipweapons/beam/ion
	name = "ion cannon"
	shielddamage = 400
