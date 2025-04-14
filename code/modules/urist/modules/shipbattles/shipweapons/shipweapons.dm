
/obj/machinery/shipweapons
	name = "shipweapon"
	idle_power_usage = 10
	active_power_usage = 1000
	use_power = 1
	anchored = TRUE
	density = TRUE
	var/pass_shield = FALSE
	var/shield_damage = 0
	var/hull_damage = 0
	var/shipid = null
	var/rechargerate = 100
	var/recharge_init_time = 0
	var/chargingicon = null
	var/chargedicon = null
	var/target = null
	var/component_hit = 0 //chance to hit components
	var/component_modifier_low = 0.2 //component damage modifier for untargeted shots
	var/component_modifier_high = 0.5 //component damage modifier for targeted shots
	var/atom/movable/projectile_type
	var/fire_anim = 0
	var/fire_sound = null
	var/obj/overmap/visitable/ship/combat/homeship = null
	var/obj/machinery/computer/combatcomputer/linkedcomputer = null
	var/status = CHARGED
	var/datum/shipcomponents/targeted_component
	var/can_intercept = FALSE //can we be intercepted??? added to account for future weapons that may pass through the shields and not be intercepted, and vice versa.
	var/external = FALSE //only used for deconstructing weapons atm, but might be used for firing actual projectiles in the future, idk.
	var/construction_type //again, only used for deconstructing weapons so we can force incomplete weapons to have non-generic icons
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/machinery/shipweapons/Initialize()
	.=..()

	ConnectWeapons()
	update_icon()

/obj/machinery/shipweapons/Process()
	if(!status && (CHARGED|RECHARGING))
		Charging()

	..()

/obj/machinery/shipweapons/proc/Charging() //maybe do this with powercells
	if(stat & (inoperable()))
		return
	if(status & FIRING)	//If we're firing, we shouldn't recharge until it's done.
		return

	status |= RECHARGING
	recharge_init_time = world.time
	update_use_power(2)
//	for(var/obj/machinery/light/L in range(4, target))
//		L.flicker(rand(1,3))
	update_icon()
	spawn(rechargerate)
		status |= CHARGED
		update_use_power(1)
		status &= ~RECHARGING
		recharge_init_time = 0
		update_icon()

/obj/machinery/shipweapons/power_change()
	..() //Let's put the parent call here so the weapon can actually recharge once power changes.

	status &= ~FIRING	//If power was lost mid-fire, let's reset the flag so status updates correctly

	if(!status && (CHARGED|RECHARGING)) //if we're not charged, we'll try charging when the power changes. that way, if the power is off, and we didn't charge, we'll try again when it comes on
		Charging()

/obj/machinery/shipweapons/attack_hand(mob/user as mob) //we can fire it by hand in a pinch
	..()

	if((status == CHARGED) && target) //even if we don't have power, as long as we have a charge, we can do this
		if(homeship.incombat)
			var/want = input("Fire the [src]?") in list ("Yes", "Cancel")
			switch(want)
				if("Yes")
					if(status == CHARGED) //just in case, we check again
						to_chat(user, "<span class='warning'>You fire the [src.name].</span>")
						Fire()
					else if(!status && CHARGED)
						to_chat(user, "<span class='warning'>The [src.name] needs to charge!</span>")


				if("Cancel")
					return
			return

		else
			to_chat(user, "<span class='warning'>There is nothing to shoot at...</span>")

	else if(!status && CHARGED)
		to_chat(user, "<span class='warning'>The [src.name] needs to charge!</span>")

	else if(!target)
		to_chat(user, "<span class='warning'>There is nothing to shoot at...</span>")


/obj/machinery/shipweapons/proc/Fire() //this proc is a mess //next task is refactor this proc
	if(!target) //maybe make it fire and recharge if people are dumb?
		return FALSE

	if(shipid && !linkedcomputer)
		ConnectWeapons()
		return FALSE

	if(status == CHARGED && !(stat & inoperable()))		//If any flags other than CHARGED is set, we shouldn't be able to fire.
		status |= FIRING

		playsound(src, fire_sound, 40, 1)
		status &= ~CHARGED	//Set it here, else there's a slim moment the status is "ready" due to spawn() behaviour

		if(fire_anim)
			icon_state = "[initial(icon_state)]-firing"
			spawn(fire_anim)
				status &= ~FIRING
				update_icon()
				Charging() //time to recharge

		else
			status &= ~FIRING
			update_icon()
			Charging() //time to recharge

		if(istype(target, /obj/overmap/visitable/ship/combat))
			MapFire()	//PVP combat just lobs projectiles at the other ship, no need for further calculations.
			return TRUE

		var/mob/living/simple_animal/hostile/overmapship/OM = target

		//do the firing stuff
		var/evaded = FALSE
		for(var/datum/shipcomponents/engines/E in OM.components)
			if(!E.broken && prob(E.evasion_chance))
				homeship.autoannounce("<b>The [src.name] has missed the [OM.ship_category].</b>", "combat")
				evaded = TRUE
				break

		if(!evaded)
			if(!pass_shield)
				var/intercepted = FALSE
				if(can_intercept)
					for(var/datum/shipcomponents/point_defence/PD in OM.components)	//Roll through each PD unit. Only one needs to hit to stop the projectile.
						if(!PD.broken && prob(PD.intercept_chance))
							intercepted = TRUE
							homeship.autoannounce("<b>The [src.name] was intercepted by the [OM.ship_category]'s [PD.name].</b>", "combat")	//Let the firing ship know PD is annoying.
							break

				if(!intercepted)
					if(OM.shields)
						var/shieldbuffer = OM.shields
						OM.shields = max(OM.shields - shield_damage, 0) //take the hit
						if(!OM.shields)
							for(var/datum/shipcomponents/shield/S in OM.components)
								S.recovery_debt = S.recovery_threashold
							if(hull_damage) //if we're left with less than 0 shields
								shieldbuffer = hull_damage-shieldbuffer //hull_damage is slightly mitigated by the existing shield
								if(shieldbuffer > 0) //but if the shield was really strong, we don't do anything
									OM.health = max(OM.health - shieldbuffer, 0)
									for(var/datum/shipcomponents/shield/S in OM.components)
										if(!S.broken)
											var/component_damage = hull_damage * 0.1
											S.health -= component_damage

											if(S.health <= 0)
												S.BlowUp()

					else	//no shields? easy
						if(targeted_component)
							TargetedHit(OM, hull_damage)

						else
							OM.health = max(OM.health - hull_damage, 0)

							if(prob(component_hit))
								HitComponents(OM)
								MapFire()

					homeship.autoannounce("<b>The [src.name] has hit the [OM.ship_category].</b>", "combat")

			else //do we pass through the shield? let's do our damage
						//not so fast, we've got point defence now
						//hold on there buster. now only weapons that can be intercepted are affected by PD, not just ones that pass through the shield
				var/intercepted = FALSE
				if(can_intercept) //can we be intercepted?
					for(var/datum/shipcomponents/point_defence/PD in OM.components)	//Roll through each PD unit. Only one needs to hit to stop the projectile.
						if(!PD.broken && prob(PD.intercept_chance))
							intercepted = TRUE
							homeship.autoannounce("<b>The [src.name] was intercepted by the [OM.ship_category]'s [PD.name].</b>", "combat")	//Let the firing ship know PD is annoying.
							break

				if(!intercepted)	//Let's take the damage outside the for loop to stop dupe damages if multiple PD's failed
					if(OM.shields)
						var/muted_damage = (hull_damage * 0.5) //genuinely forgot this was in, might make this a specific feature of shields
						var/oc = FALSE
						for(var/datum/shipcomponents/shield/S in OM.components)
							if(S.overcharged)
								oc = TRUE
								break

						if(targeted_component)
							TargetedHit(OM, muted_damage, oc)

						else if(!targeted_component && !oc)
							OM.health = max(OM.health - muted_damage, 0)

					else
						if(targeted_component)
							TargetedHit(OM, hull_damage)

						else
							OM.health = max(OM.health - hull_damage, 0)

					if(!targeted_component && prob(component_hit))
						HitComponents(OM)
						MapFire()

					homeship.autoannounce("<b>The [src.name] has hit the [OM.ship_category].</b>", "combat")

			if(OM.health <= (OM.maxHealth * 0.5))

				if(OM.health <= (OM.maxHealth * 0.25) && homeship.dam_announced == 1)
					homeship.dam_announced = 2
					homeship.autoannounce("<b>The attacking [OM.ship_category]'s hull integrity is below 25%.</b>", "private")

				if(OM.health <= 0)
					homeship.dam_announced = 0
					OM.shipdeath()

				if(!homeship.dam_announced && !OM.dying)
					homeship.dam_announced = 1
					homeship.autoannounce("<b>The attacking [OM.ship_category]'s hull integrity is below 50%.</b>", "private")

		return TRUE
	else
		return FALSE

/obj/machinery/shipweapons/proc/HitComponents(targetship)
	var/mob/living/simple_animal/hostile/overmapship/OM = targetship

//	for(var/datum/shipcomponents/SC in OM.components)
//		health -= 1

	var/datum/shipcomponents/targetcomponent = pick(OM.components)
	if(!targetcomponent.broken)
		targetcomponent.health -= (hull_damage * component_modifier_low)

		if(targetcomponent.health <= 0)
			targetcomponent.BlowUp()

/obj/machinery/shipweapons/proc/TargetedHit(targetship, hull_damage, oc = FALSE)
	var/mob/living/simple_animal/hostile/overmapship/OM = targetship
	if(!targeted_component.broken)
		targeted_component.health -= (hull_damage * component_modifier_high) //we do more damage for aimed shots

		if(targeted_component.health <= 0)
			targeted_component.BlowUp()

	if(!oc)	//Overcharged shields allow no hull damage
		OM.health = max(OM.health - (hull_damage * 0.5), 0) //but we also do less damage to the hull in general if we're aiming at systems

/obj/machinery/shipweapons/on_update_icon()
	..()
	if(status & CHARGED)
		icon_state = "[initial(icon_state)]-charged"

	if(status & RECHARGING)
		icon_state = "[initial(icon_state)]-charging"

	if(!status && (CHARGED|RECHARGING))
		icon_state = "[initial(icon_state)]-empty"

/obj/machinery/shipweapons/proc/MapFire()
	if(!projectile_type)
		return

	if(istype(target, /obj/overmap/visitable/ship/combat))
		HandlePvpFire()

	else if(istype(target, /mob/living/simple_animal/hostile/overmapship))
		var/mob/living/simple_animal/hostile/overmapship/target_ship = target
		if(target_ship.boarding && target_ship.map_spawned)
			homeship.pve_mapfire(projectile_type)

/obj/machinery/shipweapons/proc/HandlePvpFire() //come back to this to add handling for burst fire
	var/obj/overmap/visitable/ship/combat/target_ship = target
	if(!target_ship)
		return

	var/target_x = rand(target_ship.target_x_bounds[1],target_ship.target_x_bounds[2])
	var/target_y = rand(target_ship.target_y_bounds[1],target_ship.target_y_bounds[2])
	var/target_z = pick(target_ship.target_zs)
	var/target_edge = pick(target_ship.target_dirs) || pick(GLOB.cardinal)

	var/turf/start_turf = spaceDebrisStartLoc(target_edge, target_z)
	var/turf/target_turf = locate(target_x, target_y, target_z)

	launch_atom(projectile_type, start_turf, target_turf)

/obj/machinery/shipweapons/proc/ConnectWeapons()
	if(!linkedcomputer)
		for(var/obj/machinery/computer/combatcomputer/CC in SSmachines.machinery)
			if(src.shipid == CC.shipid)
				CC.linkedweapons += src
				linkedcomputer = CC
				target = CC.target

	if(linkedcomputer && !target)
		target = linkedcomputer.target

	if(!homeship)
		for(var/obj/overmap/visitable/ship/combat/C in GLOB.overmap_ships)
			if(C.shipid == src.shipid)
				homeship = C

/obj/machinery/shipweapons/proc/getStatusString()
	if(status & FIRING)
		return "Firing"
	if(stat & inoperable())
		return "Destroyed"
	if(status & RECHARGING)
		return "Recharging"
	if(!status && (CHARGED|RECHARGING))
		return "Unable to Fire"
	if(status & LOADING) //no need to yell at cargo yet, we're reloading
		return "Reloading"
	if(status & NO_AMMO)	//Let the crew know when we're running dry so we can yell at cargo
		return "Out of Ammo"
	return "Ready to Fire"

/obj/machinery/shipweapons/use_tool(obj/item/W as obj, mob/living/user as mob, click_params)
	var/turf/T = get_turf(src)
	if(isScrewdriver(W) && locate(/obj/structure/shipweapons/hardpoint) in T)
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		to_chat(user, "<span class='warning'>You unsecure the wires and unscrew the external hatches: the weapon is no longer ready to fire.</span>")
		DeconstructWeapon() //moving this to a proc lets us change how things deconstruct for certain weapons. this is done to allow something like the torpedo launcher to just be sawn out of it's place or w/e
		return TRUE
	return ..()

/obj/machinery/shipweapons/proc/DeconstructWeapon()
	if(linkedcomputer)
		linkedcomputer.linkedweapons -= src

	var/obj/structure/shipweapons/incomplete_weapon/S

	if(construction_type) //if we have a special deconstructed piece, we'll place that
		S = new construction_type(get_turf(src)) //we're special, so we don't need to set the name or the weapon_type. that should already be handled in the construction_type object.

	else //otherwise we just use the generic one
		S = new /obj/structure/shipweapons/incomplete_weapon(get_turf(src))
		S.weapon_type = src.type
		S.name = "[src.name] assembly"

	if(S)
		S.update_icon()
		S.state = 4
		S.shipid = src.shipid
		S.anchored = TRUE
		S.external = src.external
		S.pixel_x = src.pixel_x
		S.pixel_y = src.pixel_y


	qdel(src)

//the below is a temporary fix for emp bugs

/obj/machinery/shipweapons/ex_act()
	return

/obj/machinery/shipweapons/emp_act()
	SHOULD_CALL_PARENT(FALSE)
	return

#undef RECHARGING
#undef CHARGED
#undef FIRING
#undef NO_AMMO
#undef LOADING
