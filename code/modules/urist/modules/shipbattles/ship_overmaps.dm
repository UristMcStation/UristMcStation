/obj/effect/overmap/ship/combat
	var/list/hostile_factions = list() //who hates us rn
	var/canfight = 0 //will this ship engage with the combat system? Why is this zero? well, if the ship moves, we're part of the combat system. this is to compensate for lowpop rounds where noone ever moves the ship, to avoid them getting fucked by chance
	var/incombat = 0 //are we fighting
	var/shipid = null
	var/crossed = 0 //have we crossed another ship
	var/docked = 0 //are we docked?
	var/mob/living/simple_animal/hostile/overmapship/target
	var/can_board = FALSE //can we board? non-nerva ships won't be able to board to avoid weirdness

	var/evac_x = 0
	var/evac_y = 0
	var/evac_z = 0

/obj/effect/overmap/ship/combat/relaymove()
	if(!canfight)
		canfight = 1

	..()

/obj/effect/overmap/ship/combat/Initialize()
	for(var/obj/machinery/computer/combatcomputer/CC in SSmachines.machinery)//now we assign ourself to the combat computer
		if(CC.shipid == src.shipid) //having things tied to shipid means that in the future we might be able to have pvp ship combat, if i change a couple things with attacking
			CC.homeship = src
	for(var/obj/machinery/shipweapons/SW in SSmachines.machinery)
		if(SW.shipid == src.shipid)
			SW.homeship = src

	.=..()

/obj/effect/overmap/ship/combat/proc/enter_combat()
	src.incombat = 1
	target.incombat = 1
	if(!target.map_spawned)
		target.spawnmap()
//	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
//	security_state.stored_security_level = security_state.current_security_level
//	security_state.set_security_level(security_state.high_security_level)


	GLOB.global_announcer.autosay("<b>A hostile [target.ship_category] has engaged the [GLOB.using_map.full_name]</b>", "[GLOB.using_map.full_name] Automated Defence Computer", "Common") //add name+designation if I get lists for that stuff

/obj/effect/overmap/ship/combat/proc/set_targets(var/mob/living/simple_animal/hostile/overmapship/new_target = null)
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

/obj/effect/overmap/ship/combat/Crossed(O as mob)
	..()
	if(src.canfight)
		if(!src.incombat && !crossed)
			if(istype(O, /mob/living/simple_animal/hostile/overmapship))

				var/mob/living/simple_animal/hostile/overmapship/L = O
				if(!L.event)
					src.Contact(L)

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