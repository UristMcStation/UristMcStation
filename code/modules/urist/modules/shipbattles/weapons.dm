
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
	var/obj/item/shipweapons/torpedo_warhead/warhead = null
	matter = list(DEFAULT_WALL_MATERIAL = 2500)
	dir = 4

/obj/structure/shipammo/torpedo/New()
	..()
	pixel_y = rand(-20,2)
	if(ispath(warhead))
		warhead = new warhead(src)

/obj/structure/shipammo/torpedo/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/shipweapons/torpedo_warhead))
		if(!src.loaded && user.unEquip(I, src))

			icon_state = "bigtorpedo"
			loaded = 1

			warhead = I

			user << "<span class='notice'>You insert the torpedo warhead into the torpedo casing, arming the torpedo.</span>" //torpedo

		else
			user << "<span class='notice'>This torpedo already has a warhead in it!</span>" //torpedo
	else if(isCrowbar(I))
		if(warhead)
			warhead.dropInto(loc)
			to_chat(user, "<span class='notice'>You remove the torpedo warhead.</span>")
			warhead = null
			loaded = 0
			icon_state = "bigtorpedo-unloaded"
	else
		..()

/obj/structure/shipammo/torpedo/loaded
	name = "loaded torpedo"
	loaded = 1
	icon = 'icons/urist/items/ship_projectiles48x48.dmi'
	icon_state = "bigtorpedo"
	warhead = /obj/item/shipweapons/torpedo_warhead

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

