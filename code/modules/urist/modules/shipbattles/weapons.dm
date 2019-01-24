/obj/machinery/shipweapons
	name = "shipweapon"
	idle_power_usage = 10
	active_power_usage = 1000
	use_power = 1
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
	var/component_hit = 0 //chance to hit components

/obj/machinery/shipweapons/Initialize()
	for(var/obj/machinery/computer/combatcomputer/CC in SSmachines.machinery)
		CC.linkedweapons += src
	.=..()

/obj/machinery/shipweapons/Process()
	if(!charged && !recharging)
		Charging()

	..()

/obj/machinery/shipweapons/proc/Charging() //maybe do this with powercells
	if(stat & (BROKEN|NOPOWER))
		return
	else
		update_use_power(2)
		recharging = 1
		update_icon()
		spawn(rechargerate)
			charged = 1
			canfire = 1
			update_use_power(1)
			recharging = 0
			update_icon()

/obj/machinery/shipweapons/power_change()
	if(!charged && !recharging) //if we're not charged, we'll try charging when the power changes. that way, if the power is off, and we didn't charge, we'll try again when it comes on
		Charging()

	else
		..()

/obj/machinery/shipweapons/attack_hand(mob/user as mob) //we can fire it by hand in a pinch
	if(charged && target) //even if we don't have power, as long as we have a charge, we can do this
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
	else if(!charged)
		user << "<span class='warning'>The [src] needs to charge!</span>"

	else if(!target)
		user << "<span class='warning'>There is nothing to shoot at...</span>"

/obj/machinery/shipweapons/proc/Fire()
	if(!target) //maybe make it fire and recharge if people are dumb?
		return

	else
		//do the firing stuff
		var/mob/living/simple_animal/hostile/overmapship/OM = target

		for(var/datum/shipcomponents/engines/E in OM.components)
			if(!E.broken && prob(E.evasion_chance))
				GLOB.global_announcer.autosay("<b>The [src] has missed the [OM.ship_category].</b>", "[OM.target_ship.name] Automated Defence Computer", "Command")

			else
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
						if(prob(component_hit))
							HitComponents(OM)

				else if(passshield) //do we pass through the shield? let's do our damage
					OM.health -= hulldamage
					HitComponents(OM)

				GLOB.global_announcer.autosay("<b>The [src.name] has hit the [OM.ship_category].</b>", "[OM.target_ship.name] Automated Defence Computer", "Command")

		//insert firing animations here
		charged = 0
		Charging() //time to recharge

/obj/machinery/shipweapons/proc/HitComponents(var/targetship)
	var/mob/living/simple_animal/hostile/overmapship/OM = targetship

//	for(var/datum/shipcomponents/SC in OM.components)
//		health -= 1

	var/datum/shipcomponents/targetcomponent = pick(OM.components)
	if(!targetcomponent.broken)
		targetcomponent.health -= (hulldamage *= 0.1)

		if(targetcomponent.health <= 0)
			targetcomponent.BlowUp()


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
	component_hit = 25
	rechargerate = 15 SECONDS

/obj/machinery/shipweapons/beam
	icon = 'icons/urist/structures&machinery/64x64machinery.dmi'

/obj/machinery/shipweapons/beam/lightlaser
	name = "light laser cannon"
	shielddamage = 200
	hulldamage = 100
	icon_state = "lasercannon"
	idle_power_usage = 10
	active_power_usage = 2000
	component_hit = 20
	rechargerate = 15 SECONDS

/obj/machinery/shipweapons/beam/ion
	name = "ion cannon"
	icon_state = "ioncannon"
	shielddamage = 400
	active_power_usage = 2000
	component_hit = 30
	rechargerate = 12 SECONDS

/obj/machinery/shipweapons/beam/ion/HitComponents(var/targetship)
	var/mob/living/simple_animal/hostile/overmapship/OM = targetship

//	for(var/datum/shipcomponents/SC in OM.components)
//		health -= 1

	var/datum/shipcomponents/targetcomponent = pick(OM.components)
	if(!targetcomponent.broken)
		targetcomponent.broken = TRUE
		spawn(45 SECONDS)
			targetcomponent.broken = FALSE