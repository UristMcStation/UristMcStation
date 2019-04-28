/obj/machinery/shipweapons
	name = "shipweapon"
	idle_power_usage = 10
	active_power_usage = 1000
	use_power = 1
	anchored = 1
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

/obj/machinery/shipweapons/Initialize()
	.=..()

	for(var/obj/machinery/computer/combatcomputer/CC in SSmachines.machinery)
		if(src.shipid == CC.shipid)
			CC.linkedweapons += src


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


//missiles

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
		user << "<span class='warning'>The [src.name] isn't loaded!</span>"
		return


//torpedo

/obj/structure/shipammo/torpedo //TODO: Make this generic
	name = "torpedo casing"
	density = 0
	anchored = 0
	icon = 'icons/urist/items/ship_projectiles48x48.dmi'
	icon_state = "bigtorpedo-unloaded"
	var/loaded = 0
	matter = list(DEFAULT_WALL_MATERIAL = 2500)
	dir = 4

/obj/structure/shipammo/torpedo/New()
	..()
	pixel_y = rand(-20,2)

/obj/structure/shipammo/torpedo/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/shipweapons/torpedo_warhead))
		if(!src.loaded)

			icon_state = "bigtorpedo"
			loaded = 1

			user.remove_from_mob(I)
			qdel(I)

			user << "<span class='notice'>You insert the torpedo warhead into the torpedo casing, arming the torpedo.</span>" //torpedo

		else
			user << "<span class='notice'>This torpedo already has a warhead in it!</span>" //torpedo

	else
		..()

/obj/structure/shipammo/torpedo/loaded
	name = "loaded torpedo"
	loaded = 1
	icon = 'icons/urist/items/ship_projectiles48x48.dmi'
	icon_state = "bigtorpedo"

/obj/item/shipweapons/torpedo_warhead
	name = "torpedo warhead"
	desc = "It's a big warhead for a big torpedo. Shove it in a torpedo casing and you've got yourself a torpedo." //torpedo
	icon = 'icons/urist/items/ship_projectiles.dmi'
	icon_state = "torpedowarhead"
	var/safety = 1 //Integrated safeties are functioning as intended. This thing's inert.
	var/is_rigged = 0 //Has this thing been jerry-rigged?
	var/riggedstate = 0 //What stage of rigging are we in?
	var/obj/item/device/attached_device //Whatever is attached that'll detonate us.

/obj/item/shipweapons/torpedo_warhead/examine(mob/user)
	..(user)
	switch(riggedstate)
		if(1) to_chat(user, "<span class='notice'>It's control circuitry is exposed.</span>")
		if(2) to_chat(user, "<span class='notice'>It's control circuitry is exposed, and the internal wiring appears to have been modified.</span>")
		if(3) to_chat(user, "<span class='notice'>It's control circuitry is exposed, the internal wiring appears to have been modified, and a wire has been rigged to the detonator circuit.</span>")
	switch(safety)
		if(0) to_chat(user, "<span class='warning'>The safeties have been disabled.</span>")
		if(1) to_chat(user, "<span class='notice'>The safeties are enabled.</span>")
	if(is_rigged)
		to_chat(user, "<span class='warning'>There is a [attached_device] attached to the warhaed.</span>")

/obj/item/shipweapons/torpedo_warhead/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/weapon/crowbar))
		if(riggedstate == 1 && !attached_device) // can't close it if it's got something it's not supposed to have.
			to_chat(user, "<span class='notice'>You carefully close the warhead's circuitry panel.</span>")
			riggedstate = 0
			playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
		else if(!riggedstate)
			to_chat(user, "<span class='notice'>You carefully lever open the warhead's circuitry panel.</span>")
			riggedstate++
			playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
		else
			to_chat(user, "<span class='notice'>You can't close the panel. Remove the [attached_device] first.</span>")

	else if(istype(I, /obj/item/weapon/wirecutters))
		if(is_rigged && attached_device)
			to_chat(user, "<span class='notice'>You carefully begin to remove [attached_device] from the warhead's internals.</span>")
			if(do_after(user,40))
				to_chat(user, "<span class='notice'>You carefully remove [attached_device] from the warhead's internals.</span>")
				var/obj/item/device/assembly/A = attached_device
				A.forceMove(get_turf(user))
				A.holder = null
				attached_device = null
				is_rigged = 0
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
		else if(riggedstate == 3)
			to_chat(user, "<span class='notice'>You snip the wire attached to the warhead's detonation circuit.</span>")
			riggedstate = 2
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
		else if(riggedstate == 2)
			to_chat(user, "<span class='notice'>You carefully undo the modifications to the warhead's circuitry.</span>")
			riggedstate = 1
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
		else if(riggedstate == 1)
			to_chat(user, "<span class='notice'>You begin to carefully modify the circuitry of the warhead.</span>")
			if(do_after(user,40))
				to_chat(user, "<span class='notice'>You have modified the torpedo warhead's internal circuitry. It can now be wired up and attached to something.</span>")
				riggedstate++
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
		return
	else if(istype(I, /obj/item/device/multitool))
		if(!riggedstate)
			return
		if(!safety)
			to_chat(user, "<span class='notice'>You begin to re-engage the built-in safeties.</span>")
			if(do_after(user,40))
				to_chat(user, "<span class='notice'>The warhead beeps softly, indicating you have re-enabled it's safeties!</span>")
				safety = 1
				playsound(src.loc, 'sound/machines/buttonbeep.ogg', 25, 0, 10)
		if(safety)
			to_chat(user, "<span class='notice'>You begin to disable the built-in safeties...</span>")
			if(do_after(user,40))
				to_chat(user, "<span class='danger'>The warhead beeps stridently as you disable the built-in safeties.</span>")
				safety = 0
				playsound(src.loc, 'sound/machines/buttonbeep.ogg', 25, 0, 10)
	else if(istype(I, /obj/item/stack/cable_coil) && riggedstate == 2)
		to_chat(user, "<span class='notice'>You rig a wire from the torpedo warhead's detonator circuit. You can now attach something to it to detonate it remotely.</span>")
		riggedstate++
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
	else if(istype(I, /obj/item/device/assembly))
		if(riggedstate == 3)
			var/obj/item/device/assembly/A = I
			if(A.secured)
				to_chat(user, "<span class='notice'>The [A] is secured, and you can not attach it.</span>")
				return
			to_chat(user, "<span class='warning'>You rig the [A] to the torpedo warhead's detonator circuit!</span>")
			is_rigged = 1
			if(!user.unEquip(A, src))
				return
			A.forceMove(src)
			attached_device = I
			A.holder = src
			log_and_message_admins("[user] has rigged a torpedo IED.")
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
	return

/obj/item/shipweapons/torpedo_warhead/proc/process_activation() // uh oh, time to boom
	playsound(src.loc, 'sound/machines/buttonbeep.ogg', 25, 0, 10)
	if(safety)
		visible_message("<span class='danger'>[src] beeps stubbornly, refusing to detonate!</span>")
		playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 25, 0, 10)
	if(!safety)
		if(prob(15)) // Small chance for the warhead's safeties to engage briefly.
			visible_message("<span class='danger'>[src] beeps stubbornly, refusing to detonate!</span>")
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 25, 0, 10)
			return
		visible_message("<span class='danger'>[src] pings, begining a short countdown!</span>")
		playsound(src.loc, 'sound/machines/ping.ogg', 25, 0, 10)
		spawn(40) // 4 seconds to run away.
		explosion(src, 4, 5, 6)

/obj/machinery/shipweapons/missile/torpedo
	name = "torpedo launcher"
	icon_state = "torpedo"
	hulldamage = 350 //maybe
//	active_power_usage = 1000
	component_hit = 25
	rechargerate = 15 SECONDS
	projectile_type = /obj/item/projectile/bullet/ship/bigtorpedo
	fire_sound = 'sound/weapons/railgun.ogg'

/obj/machinery/shipweapons/missile/torpedo/Bumped(atom/movable/M as mob|obj)
	..()
	if(istype(M, /obj/structure/shipammo/torpedo))
		var/obj/structure/shipammo/torpedo/L = M
		if(L.loaded && !src.loaded) //no need for maxload here, because fuck it
			qdel(L)
			src.loaded += 1

/obj/machinery/shipweapons/missile/torpedo/Crossed(O as obj)
	..()
	if(istype(O, /obj/structure/shipammo/torpedo))
		var/obj/structure/shipammo/torpedo/L = O
		if(L.loaded && !src.loaded) //no need for maxload here, because fuck it
			qdel(L)
			src.loaded += 1

/obj/machinery/shipweapons/missile/torpedo/update_icon()
	..()

	if(charged && loaded)
		icon_state = "[initial(icon_state)]-loaded"

//beams

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
	projectile_type = /obj/item/projectile/beam/ship/lightlaser
	fire_anim = 5
	fire_sound = 'sound/weapons/marauder.ogg'

/obj/machinery/shipweapons/beam/ion
	name = "ion cannon"
	icon_state = "ioncannon"
	shielddamage = 400
	active_power_usage = 2000
	component_hit = 35
	rechargerate = 12 SECONDS
	fire_sound = 'sound/weapons/marauder.ogg'
	projectile_type = /obj/item/projectile/ion/ship

/obj/machinery/shipweapons/beam/ion/HitComponents(var/targetship)
	var/mob/living/simple_animal/hostile/overmapship/OM = targetship

//	for(var/datum/shipcomponents/SC in OM.components)
//		health -= 1

	var/datum/shipcomponents/targetcomponent = pick(OM.components)
	if(!targetcomponent.broken)
		targetcomponent.broken = TRUE
		spawn(45 SECONDS)
			targetcomponent.broken = FALSE