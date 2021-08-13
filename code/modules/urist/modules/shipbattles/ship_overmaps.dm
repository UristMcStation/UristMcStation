/obj/effect/overmap/ship/combat
	var/list/hostile_factions = list() //who hates us rn
	var/canfight = 0 //will this ship engage with the combat system? Why is this zero? well, if the ship moves, we're part of the combat system. this is to compensate for lowpop rounds where noone ever moves the ship, to avoid them getting fucked by chance
	var/incombat = 0 //are we fighting
	var/shipid = null
	var/crossed = 0 //have we crossed another ship
	var/docked = 0 //are we docked?
	var/mob/living/simple_animal/hostile/overmapship/target
	var/can_board = FALSE //can we board? non-nerva ships won't be able to board to avoid weirdness
	var/contacts = list()
	var/landmarks = list()
	var/target_x_bounds = list()
	var/target_y_bounds = list()
	var/list/announcement_channel = list("public" = null, "private" = null, "technical" = null)
	var/fleeing = FALSE
	var/flee_timer = 0
	var/can_escape = TRUE
	var/dam_announced = 0
	var/pvp_cooldown = 0

	var/evac_x = 0
	var/evac_y = 0
	var/evac_z = 0

/obj/effect/overmap/ship/combat/relaymove()
	if(!canfight)
		canfight = 1

	..()

/obj/effect/overmap/ship/combat/New()
	GLOB.overmap_ships += src	//Fallback connect uses this. Let's populate it
	..()

/obj/effect/overmap/ship/combat/Initialize()
	for(var/obj/machinery/computer/combatcomputer/CC in SSmachines.machinery)//now we assign ourself to the combat computer
		if(CC.shipid == src.shipid) //having things tied to shipid means that in the future we might be able to have pvp ship combat, if i change a couple things with attacking
			CC.homeship = src
	for(var/obj/machinery/shipweapons/SW in SSmachines.machinery)
		if(SW.shipid == src.shipid)
			SW.homeship = src
	for(var/obj/effect/urist/projectile_landmark/ship/L in GLOB.ship_projectile_landmarks)
		if(shipid == L.shipid)
			landmarks += L
			L.mothership = src
	.=..()

/obj/effect/overmap/ship/combat/proc/enter_combat()
	src.incombat = 1
	target.incombat = 1
	autoannounce("<b>A hostile [target.ship_category] has engaged the [ship_name]</b>", "public")	//Because it's weird to be told there's a ship -after- you've been shot at
	if(!target.map_spawned)
		target.spawnmap()

		for(var/datum/shipcomponents/M in target.components)
			if(M.broken)
				return
			else
				M.DoActivate()

	if(src == GLOB.using_map.overmap_ship)
		var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
		security_state.stored_security_level = security_state.current_security_level
		security_state.set_security_level(security_state.high_security_level)

/obj/effect/overmap/ship/combat/proc/set_targets(var/new_target = null)
	if(!target)

		for(var/obj/machinery/computer/combatcomputer/CC in SSmachines.machinery)//now we assign our targets to the combat computer (to show data)
			if(CC.shipid == src.shipid)
				CC.target = new_target
				if(!CC.homeship)
					CC.homeship = src

		for(var/obj/machinery/shipweapons/SW in SSmachines.machinery) //and to the weapons, so they do damage
			if(SW.shipid == src.shipid)
				SW.target = new_target
				if(!SW.homeship)
					SW.homeship = src

		src.target = new_target

	else

		for(var/obj/machinery/computer/combatcomputer/CC in SSmachines.machinery)//now we unassign our targets from the combat computer
			if(CC.shipid == src.shipid)
				CC.target = null

		for(var/obj/machinery/shipweapons/SW in SSmachines.machinery) //and the weapons
			if(SW.shipid == src.shipid)
				SW.target = null
				SW.targeted_component = null

		if(!istype(target, /obj/effect/overmap/ship/combat))	//Player ships individually call this proc so no need to unset that here
			target.target_ship = null
		src.target = null

/obj/effect/overmap/ship/combat/proc/leave_combat()
	if(target)
		target.incombat = 0
		target.stop_automated_movement = 0

		src.set_targets()

	incombat = 0
	crossed = 0
	src.unhalt()

	if(src == GLOB.using_map.overmap_ship)
		var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
		security_state.set_security_level(security_state.stored_security_level)

/obj/effect/overmap/ship/combat/Crossed(O as mob)
	..()
	if(istype(O, /obj/effect/overmap/ship/combat))	//canfight checks are done later. Means we could add things in the future to ship-to-ship
		var/obj/effect/overmap/ship/combat/OM = O
		contacts += OM
		OM.contacts += src
		autoannounce("<b>The [OM.ship_name], \a [OM.classification], has entered the [ship_name]'s defensive proximity</b>", "public")
		OM.autoannounce("<b>The [ship_name], \a [classification], has entered the [OM.ship_name]'s defensive proximity</b>", "public")

	else if(src.canfight)	//AI ships are still handled the same as before
		if(!src.incombat && !crossed)
			if(istype(O, /mob/living/simple_animal/hostile/overmapship))

				var/mob/living/simple_animal/hostile/overmapship/L = O
				if(!L.event)
					src.Contact(L)


/obj/effect/overmap/ship/combat/Uncrossed(O as mob)
	..()
	if(istype(O, /obj/effect/overmap/ship/combat))
		var/obj/effect/overmap/ship/combat/OM = O
		contacts -= OM
		OM.contacts -= src
		if(target == OM)	//This shouldn't be possible, but just in case
			set_targets()
		if(OM.target == src)
			OM.set_targets()

/obj/effect/overmap/ship/combat/proc/Contact(var/mob/living/simple_animal/hostile/overmapship/L)
	src.halt() //cancel our momentum
	crossed = 1 //we're in combat now, so let's cancel out momentum
	//now let's cancel the momentum of the mob
	L.stop_automated_movement = 1
//			L.combat
	L.target_ship = src

	src.set_targets(L)

	if(L.aggressive || L.hiddenfaction.hostile)
		enter_combat()
		return //here we set up the combat stuff if they're aggressive


	spawn(30 SECONDS)
		if(!src.incombat || !src.docked)
			src.set_targets()

			crossed = 0
			src.unhalt()

		else
			return

/obj/effect/overmap/ship/combat/proc/intercept(var/obj/effect/overmap/ship/combat/S)
	if(!S || !S.canfight || !canfight || S.pvp_cooldown || pvp_cooldown)	return	//If either ship can't fight, we don't

	halt()	//Stop both ships
	S.halt()
	crossed = 1
	S.crossed = 1
	S.can_escape = FALSE	//Attacking ship doesn't need to charge up to escape. Possible future weapon to disrupt engines and stop escape?

	set_targets(S)	//Target eachother
	S.set_targets(src)

	enter_pvp_combat(TRUE)	//Blow eachother up
	S.enter_pvp_combat()

/obj/effect/overmap/ship/combat/proc/restabilize_engines()
	if(!target || fleeing)	return
	var/obj/effect/overmap/ship/combat/OM = target
	fleeing = 1
	flee_timer = Clamp((600 + round(2*((vessel_mass - OM.vessel_mass)/100))), 300, 900)	//Temp formula for now. Smaller ships escape faster for balancing.
	autoannounce("<b>Restabilizing engines - ETA [flee_timer] seconds</b>", "private")
	OM.autoannounce("<b>[ship_name] engine restabilization in progress - ETA [flee_timer] seconds</b>", "private")

/obj/effect/overmap/ship/combat/proc/cancel_restabilize_engines(var/announce = FALSE)
	if(!fleeing)	return

	fleeing = 0
	flee_timer = 0

	if(announce)
		autoannounce("<b>Engine restabilization aborted</b>", "private")

/obj/effect/overmap/ship/combat/proc/flee()	//Let's give the other ship/any boarders a quick minute chance to act.
	if(!can_escape || fleeing == 2)	return
	var/obj/effect/overmap/ship/combat/OM = target
	if(!OM)	return
	fleeing = 2
	autoannounce("<b>Thrusters engaged - ETA 1 minute to disengage</b>", "private")
	OM.autoannounce("<b>[ship_name] thrusters engaged - ETA 1 minute until weapons range exceeded</b>", "private")
	spawn(60 SECONDS)
		leave_pvp_combat(TRUE)

/obj/effect/overmap/ship/combat/Process(var/wait)
	..()
	if(fleeing == 1)
		flee_timer = max(flee_timer - (wait / 10), 0)
		if(flee_timer == 0 && fleeing)
			var/obj/effect/overmap/ship/combat/OM = target
			if(!OM)	return
			fleeing = 0
			can_escape = TRUE
			autoannounce("<b>Engines restabilized - Escape is now possible</b>", "private")
			OM.autoannounce("<b>[ship_name] engines restabilized - Escape is now possible</b>", "private")

	if(pvp_cooldown)
		pvp_cooldown = max(pvp_cooldown - (wait / 10), 0)

/obj/effect/overmap/ship/combat/proc/enter_pvp_combat(var/attacker = FALSE)
	if(!target)	return
	var/obj/effect/overmap/ship/combat/OM = target
	incombat = 1

	if(attacker)
		autoannounce("<b>[OM.ship_name] intercepted - Entering combat</b>", "public")
	else
		autoannounce("<b>Engines destabilized - [OM.ship_name] weapon systems online</b>", "public")

	if(src == GLOB.using_map.overmap_ship)	//If the Nerva is involved, let's put it on Red Alert.
		var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
		security_state.stored_security_level = security_state.current_security_level
		security_state.set_security_level(security_state.high_security_level)

/obj/effect/overmap/ship/combat/proc/leave_pvp_combat(var/fled = FALSE)
	if(!can_escape && fled) return
	if(!target)	return
	var/obj/effect/overmap/ship/combat/T = target
	cancel_restabilize_engines()	//Reset any timers incase both ships were escaping
	can_escape = TRUE
	incombat = 0
	crossed = 0
	unhalt()
	set_targets()
	pvp_cooldown = 600	//10 minute cooldown after pvp combat to prevent spam to each ship

	if(fled)
		autoannounce("<b>[T.ship_name] weapons range exceeded - Escape successful.</b>", "public")
	else
		autoannounce("<b>[T.ship_name] has exceeded weapons range - Exiting combat.</b>", "public")

	if(src == GLOB.using_map.overmap_ship)	//If the Nerva is involved, put the alert level back where it was
		var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
		security_state.set_security_level(security_state.stored_security_level)

	T.leave_pvp_combat(!fled)	//Calls the other ship to leave. Won't loop back as target was cleared.

/obj/effect/overmap/ship/combat/proc/autoannounce(var/message, var/channel)	//Moved all combat announcements to call this proc instead. In future, other player ships might have their own frequencies
	if(!message || !channel)
		return
	if(announcement_channel[channel])	//Stops any player ships without their own freq using the Nerva's, which would be wierd.
		GLOB.global_announcer.autosay(message, "[ship_name] Automated Defence Computer", announcement_channel[channel]) //Current presets are "public" - Common on Nerva, "private" - Command on Nerva, and "technical" - Engineering on Nerva. Defined on overmap ship.