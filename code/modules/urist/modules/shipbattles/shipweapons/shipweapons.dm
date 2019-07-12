
/obj/machinery/shipweapons
	name = "shipweapon"
	idle_power_usage = 10
	active_power_usage = 1000
	use_power = 1
	anchored = 1
	density = 1
	var/passshield = 0
	var/shielddamage = 0
	var/hulldamage = 0
	var/shipid = "nerva"
	var/canfire = 0
	var/recharging = 0
	var/charged = 0
	var/rechargerate = 100
	var/chargingicon = null
	var/chargedicon = null
	var/target = null
	var/component_hit = 0 //chance to hit components
	var/obj/item/projectile/projectile_type
	var/fire_anim = 0
	var/fire_sound = null
	var/dam_announced = 0
	var/obj/effect/overmap/ship/combat/homeship = null
	var/firing = FALSE
	var/obj/machinery/computer/combatcomputer/linkedcomputer = null

/obj/machinery/shipweapons/Initialize()
	.=..()

	ConnectWeapons()

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
	..()

	if(charged && target) //even if we don't have power, as long as we have a charge, we can do this
		if(homeship.incombat)
			var/want = input("Fire the [src]?") in list ("Yes", "Cancel")
			switch(want)
				if("Yes")
					if(charged) //just in case, we check again
						if(!firing)
							user << "<span class='warning'>You fire the [src.name].</span>"
							firing = TRUE
							Fire()
					else
						user << "<span class='warning'>The [src.name] needs to charge!</span>"


				if("Cancel")
					return
			return

		else
			user << "<span class='warning'>There is nothing to shoot at...</span>"

	else if(!charged)
		user << "<span class='warning'>The [src.name] needs to charge!</span>"

	else if(!target)
		user << "<span class='warning'>There is nothing to shoot at...</span>"


/obj/machinery/shipweapons/proc/Fire() //this proc is a mess
	if(!target) //maybe make it fire and recharge if people are dumb?
		firing = FALSE
		return

	if(shipid && !linkedcomputer)
		ConnectWeapons()

	else
		var/mob/living/simple_animal/hostile/overmapship/OM = target
		//do the firing stuff

		for(var/datum/shipcomponents/engines/E in OM.components)
			if(!E.broken && prob(E.evasion_chance))
				GLOB.global_announcer.autosay("<b>The [src.name] has missed the [OM.ship_category].</b>", "[OM.target_ship.name] Automated Defence Computer", "Command")

			else
				if(!passshield)
					if(OM.shields)
						var/shieldbuffer = OM.shields
						OM.shields -= shielddamage //take the hit
						if(OM.shields <= 0) //if we're left with less than 0 shields
							OM.shields = 0 //we reset the shields to zero to avoid any weirdness
							//we also apply damage to the actual shield component //come back to this
							if(!OM.boarding && OM.can_board)
								if(homeship.can_board)
									OM.boarding = 1
									OM.boarded()

							if(hulldamage)

								shieldbuffer = (hulldamage-shieldbuffer) //hulldamage is slightly mitigated by the existing shield
								if(shieldbuffer <=0) //but if the shield was really strong, we don't do anything
									return

								else
									OM.health -= shieldbuffer
									for(var/datum/shipcomponents/shield/S in OM.components)
										if(!S.broken)
											var/component_damage = hulldamage * 0.1
											S.health -= component_damage

											if(S.health <= 0)
												S.BlowUp()

					else if(!OM.shields) //no shields? easy

						if(!OM.boarding && OM.can_board)
							if(homeship.can_board)
								OM.boarding = 1
								OM.boarded()

						OM.health -= hulldamage

						if(prob(component_hit))
							HitComponents(OM)
							MapFire()

				else if(passshield) //do we pass through the shield? let's do our damage
					if(OM.shields)
						var/muted_damage = (hulldamage * 0.5)
						OM.health -= muted_damage
					else if(!OM.shields)
						OM.health -= hulldamage

					if(prob(component_hit))
						HitComponents(OM)
						MapFire()

				if(OM.health <= (OM.maxHealth * 0.5))

					if(OM.health <= (OM.maxHealth * 0.25) && dam_announced == 1)
						GLOB.global_announcer.autosay("<b>The attacking [OM.ship_category]'s hull integrity is below 25%.</b>", "[OM.target_ship.name] Automated Defence Computer", "Command")
						dam_announced = 2

					if(OM.health <= 0)
						OM.shipdeath()
						dam_announced = 0

					if(!dam_announced)
						GLOB.global_announcer.autosay("<b>The attacking [OM.ship_category]'s hull integrity is below 50%.</b>", "[OM.target_ship.name] Automated Defence Computer", "Command")
						dam_announced = 1

				GLOB.global_announcer.autosay("<b>The [src.name] has hit the [OM.ship_category].</b>", "[OM.target_ship.name] Automated Defence Computer", "Command")

		//insert firing animations here
		playsound(src, fire_sound, 40, 1)

		if(fire_anim)
			icon_state = "[initial(icon_state)]-firing"
			spawn(fire_anim)
				charged = 0
				Charging() //time to recharge

		else
			charged = 0
			update_icon()
			Charging() //time to recharge

		firing = FALSE

/obj/machinery/shipweapons/proc/HitComponents(var/targetship)
	var/mob/living/simple_animal/hostile/overmapship/OM = targetship

//	for(var/datum/shipcomponents/SC in OM.components)
//		health -= 1

	var/datum/shipcomponents/targetcomponent = pick(OM.components)
	if(!targetcomponent.broken)
		targetcomponent.health -= (hulldamage * 0.2)

		if(targetcomponent.health <= 0)
			targetcomponent.BlowUp()

/obj/machinery/shipweapons/update_icon()
	..()
	if(charged)
		icon_state = "[initial(icon_state)]-charged"

	if(recharging)
		icon_state = "[initial(icon_state)]-charging"

	if(!charged && !recharging)
		icon_state = "[initial(icon_state)]-empty"

/obj/machinery/shipweapons/proc/MapFire()
	var/obj/effect/urist/projectile_landmark/target/P = pick(GLOB.target_projectile_landmarks)
	P.Fire(projectile_type)

/obj/machinery/shipweapons/proc/ConnectWeapons()
	for(var/obj/machinery/computer/combatcomputer/CC in SSmachines.machinery)
		if(src.shipid == CC.shipid)
			CC.linkedweapons += src
			linkedcomputer = CC

/obj/machinery/shipweapons/attackby(obj/item/W as obj, mob/living/user as mob)
	var/turf/T = get_turf(src)
	if(isScrewdriver(W) && locate(/obj/structure/shipweapons/hardpoint) in T)
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		to_chat(user, "<span class='warning'>You unsecure the wires and unscrew the external hatches: the weapon is no longer ready to fire.</span>")
		var/obj/structure/shipweapons/incomplete_weapon/S = new /obj/structure/shipweapons/incomplete_weapon(get_turf(src))
		S.state = 4
		S.update_icon()
		S.weapon_type = src.type
		S.name = "[src.name] assembly"
		S.shipid = src.shipid
		S.anchored = 1
		linkedcomputer.linkedweapons -= src
		qdel(src)

	else
		..()