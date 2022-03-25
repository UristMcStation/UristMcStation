/mob/living/bot
	name = "Bot"
	health = 20
	maxHealth = 20
	icon = 'icons/mob/bot/placeholder.dmi'
	universal_speak = 1
	density = 0
	var/obj/item/weapon/card/id/botcard = null
	var/list/botcard_access = list()
	var/on = 1
	var/open = 0
	var/locked = 1
	var/emagged = 0
	var/light_strength = 3
	var/busy = 0

	var/obj/access_scanner = null
	var/list/req_access = list()

	var/atom/target = null
	var/list/ignore_list = list()
	var/list/patrol_path = list()
	var/list/target_path = list()
	var/turf/obstacle = null

	var/wait_if_pulled = 0 // Only applies to moving to the target
	var/will_patrol = 0 // If set to 1, will patrol, duh
	var/patrol_speed = 1 // How many times per tick we move when patrolling
	var/target_speed = 2 // Ditto for chasing the target
	var/min_target_dist = 1 // How close we try to get to the target
	var/max_target_dist = 50 // How far we are willing to go
	var/max_patrol_dist = 250
	var/RequiresAccessToToggle = 0 // If 1, will check access to be turned on/off

	var/target_patience = 5
	var/frustration = 0
	var/max_frustration = 0

	plane = HIDING_MOB_PLANE
	layer = HIDING_MOB_LAYER

/mob/living/bot/New()
	..()
	update_icons()

	botcard = new /obj/item/weapon/card/id(src)
	botcard.access = botcard_access.Copy()

	access_scanner = new /obj(src)
	access_scanner.req_access = req_access.Copy()

/mob/living/bot/Initialize()
	. = ..()
	if(on)
		turn_on() // Update lights and other stuff
	else
		turn_off()

/mob/living/bot/Life()
	..()
	if(health <= 0)
		death()
		return
	weakened = 0
	stunned = 0
	paralysis = 0

	if(on && !client && !busy)
		spawn(0)
			handleAI()

/mob/living/bot/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		set_stat(CONSCIOUS)
	else
		if(health <= 0)
			death()

/mob/living/bot/death()
	explode()

/mob/living/bot/attackby(var/obj/item/O, var/mob/user)
	if(O.GetIdCard())
		if(access_scanner.allowed(user) && !open)
			locked = !locked
			to_chat(user, "<span class='notice'>Controls are now [locked ? "locked." : "unlocked."]</span>")
			Interact(usr)
		else if(open)
			to_chat(user, "<span class='warning'>Please close the access panel before locking it.</span>")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
		return
	else if(isScrewdriver(O))
		if(!locked)
			open = !open
			to_chat(user, "<span class='notice'>Maintenance panel is now [open ? "opened" : "closed"].</span>")
			Interact(usr)
		else
			to_chat(user, "<span class='notice'>You need to unlock the controls first.</span>")
		return
	else if(isWelder(O))
		if(health < maxHealth)
			if(open)
				health = min(maxHealth, health + 10)
				user.visible_message("<span class='notice'>\The [user] repairs \the [src].</span>","<span class='notice'>You repair \the [src].</span>")
			else
				to_chat(user, "<span class='notice'>Unable to repair with the maintenance panel closed.</span>")
		else
			to_chat(user, "<span class='notice'>\The [src] does not need a repair.</span>")
		return
	else
		. = ..()

/mob/living/bot/bullet_act(var/obj/item/projectile/P, var/def_zone)
	if(!P || P.nodamage)
		return

	var/damage = P.damage
	if(P.damtype == STUN)
		damage = (P.damage / 8)

	adjustBruteLoss(damage)
	. = ..()

/mob/living/bot/hit_with_weapon(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	adjustBruteLoss(I.force)
	. = ..()

/mob/living/bot/attack_ai(var/mob/user)
	Interact(user)

/mob/living/bot/attack_hand(var/mob/user)
	Interact(user)

/mob/living/bot/proc/Interact(var/mob/user)
	add_fingerprint(user)
	var/dat

	var/curText = GetInteractTitle()
	if(curText)
		dat += curText
		dat += "<hr>"

	curText = GetInteractStatus()
	if(curText)
		dat += curText
		dat += "<hr>"

	curText = (CanAccessPanel(user)) ? GetInteractPanel() : "The access panel is locked."
	if(curText)
		dat += curText
		dat += "<hr>"

	curText = (CanAccessMaintenance(user)) ? GetInteractMaintenance() : "The maintenance panel is locked."
	if(curText)
		dat += curText

	var/datum/browser/popup = new(user, "botpanel", "[src] controls")
	popup.set_content(dat)
	popup.open()

/mob/living/bot/Topic(var/href, var/href_list)
	if(..())
		return 1

	if(!issilicon(usr) && !Adjacent(usr))
		return

	if(usr.incapacitated())
		return

	if(href_list["command"])
		ProcessCommand(usr, href_list["command"], href_list)

	Interact(usr)

/mob/living/bot/proc/GetInteractTitle()
	return

/mob/living/bot/proc/GetInteractStatus()
	. = "Status: <A href='?src=\ref[src];command=toggle'>[on ? "On" : "Off"]</A>"
	. += "<BR>Behaviour controls are [locked ? "locked" : "unlocked"]"
	. += "<BR>Maintenance panel is [open ? "opened" : "closed"]"

/mob/living/bot/proc/GetInteractPanel()
	return

/mob/living/bot/proc/GetInteractMaintenance()
	return

/mob/living/bot/proc/ProcessCommand(var/mob/user, var/command, var/href_list)
	if(command == "toggle" && CanToggle(user))
		if(on)
			turn_off()
		else
			turn_on()
	return

/mob/living/bot/proc/CanToggle(var/mob/user)
	return (!RequiresAccessToToggle || access_scanner.allowed(user) || issilicon(user))

/mob/living/bot/proc/CanAccessPanel(var/mob/user)
	return (!locked || issilicon(user))

/mob/living/bot/proc/CanAccessMaintenance(var/mob/user)
	return (open || issilicon(user))

/mob/living/bot/say(var/message)
	var/verb = "beeps"

	message = sanitize(message)

	..(message, null, verb)

/mob/living/bot/Bump(var/atom/A)
	if(on && botcard && istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		if(!istype(D, /obj/machinery/door/firedoor) && !istype(D, /obj/machinery/door/blast) && D.check_access(botcard))
			D.open()
	else
		..()

/mob/living/bot/emag_act(var/remaining_charges, var/mob/user)
	return 0

/mob/living/bot/proc/handleAI()
	if(ignore_list.len)
		for(var/atom/A in ignore_list)
			if(!A || !A.loc || prob(1))
				ignore_list -= A
	handleRegular()
	if(target && confirmTarget(target))
		if(Adjacent(target))
			handleAdjacentTarget()
		else
			handleRangedTarget()
		if(!wait_if_pulled || !pulledby)
			for(var/i = 1 to target_speed)
				sleep(20 / (target_speed + 1))
				stepToTarget()
		if(max_frustration && frustration > max_frustration * target_speed)
			handleFrustrated(1)
	else
		resetTarget()
		lookForTargets()
		if(will_patrol && !pulledby && !target)
			if(patrol_path && patrol_path.len)
				for(var/i = 1 to patrol_speed)
					sleep(20 / (patrol_speed + 1))
					handlePatrol()
				if(max_frustration && frustration > max_frustration * patrol_speed)
					handleFrustrated(0)
			else
				startPatrol()
		else
			handleIdle()

/mob/living/bot/proc/handleRegular()
	return

/mob/living/bot/proc/handleAdjacentTarget()
	return

/mob/living/bot/proc/handleRangedTarget()
	return

/mob/living/bot/proc/stepToTarget()
	if(!target || !target.loc)
		return
	if(get_dist(src, target) > min_target_dist)
		if(!target_path.len || get_turf(target) != target_path[target_path.len])
			calcTargetPath()
		if(makeStep(target_path))
			frustration = 0
		else if(max_frustration)
			++frustration
	return

/mob/living/bot/proc/handleFrustrated(var/targ)
	obstacle = targ ? target_path[1] : patrol_path[1]
	target_path = list()
	patrol_path = list()
	return

/mob/living/bot/proc/lookForTargets()
	return

/mob/living/bot/proc/confirmTarget(var/atom/A)
	if(A.invisibility >= INVISIBILITY_LEVEL_ONE)
		return 0
	if(A in ignore_list)
		return 0
	if(!A.loc)
		return 0
	return 1

/mob/living/bot/proc/handlePatrol()
	if(makeStep(patrol_path) && frustration)
		frustration = 0
	else if(max_frustration)
		++frustration
	return

/mob/living/bot/proc/startPatrol()
	var/turf/T = getPatrolTurf()
	if(T)
		patrol_path = AStar(get_turf(loc), T, /turf/proc/CardinalTurfsWithAccessWithZ, /turf/proc/Manhatten3dDistance, 0, max_patrol_dist, id = botcard, exclude = obstacle)
		if(!patrol_path)
			patrol_path = list()
		obstacle = null
	return

/mob/living/bot/proc/getPatrolTurf()
	var/minDist = INFINITY
	var/obj/machinery/navbeacon/targ = locate() in get_turf(src)

	if(!targ)
		for(var/obj/machinery/navbeacon/N in navbeacons)
			if(!N.codes["patrol"])
				continue
			if(get_dist(src, N) < minDist)
				minDist = get_dist(src, N)
				targ = N

	if(targ && targ.codes["next_patrol"])
		for(var/obj/machinery/navbeacon/N in navbeacons)
			if(N.location == targ.codes["next_patrol"])
				targ = N
				break

	if(targ)
		return get_turf(targ)
	return null

/mob/living/bot/proc/handleIdle()
	return

/mob/living/bot/proc/calcTargetPath()
	target_path = AStar(get_turf(loc), get_turf(target), /turf/proc/AllDirTurfsWithAccessWithZ, /turf/proc/Euclidean3dDistance, 0, max_target_dist, id = botcard, exclude = obstacle)
	if(!target_path)
		if(target && target.loc)
			ignore_list |= target
		resetTarget()
		obstacle = null
	return

/mob/living/bot/proc/makeStep(var/list/path)
	if(!path.len)
		return 0
	var/turf/T = path[1]
	if(get_turf(src) == T)
		path -= T
		return makeStep(path)

	return step_towards(src, T)

/mob/living/bot/proc/resetTarget()
	target = null
	target_path = list()
	//frustration = 0
	obstacle = null

/mob/living/bot/proc/turn_on()
	if(stat)
		return 0
	on = 1
	set_light(0.5, 0.1, light_strength)
	update_icons()
	resetTarget()
	patrol_path = list()
	ignore_list = list()
	return 1

/mob/living/bot/proc/turn_off()
	on = 0
	set_light(0)
	update_icons()

/mob/living/bot/proc/explode()
	qdel(src)

/******************************************************************/
// Navigation procs
// Used for A-star pathfinding


// Returns the surrounding cardinal turfs with open links
// Including through doors openable with the ID
/turf/proc/CardinalTurfsWithAccess(var/obj/item/weapon/card/id/ID)
	var/L[] = new()

	//	for(var/turf/simulated/t in oview(src,1))

	for(var/d in GLOB.cardinal)
		var/turf/simulated/T = get_step(src, d)
		if(istype(T) && !T.density)
			if(!LinkBlockedWithAccess(src, T, ID))
				L.Add(T)
	return L


// Returns true if a link between A and B is blocked
// Movement through doors allowed if ID has access
/proc/LinkBlockedWithAccess(turf/A, turf/B, obj/item/weapon/card/id/ID)

	if(A == null || B == null) return 1
	var/adir = get_dir(A,B)
	var/rdir = get_dir(B,A)
	if((adir & (NORTH|SOUTH)) && (adir & (EAST|WEST)))	//	diagonal
		if(DirBlockedWithAccess(A,adir, ID) || DirBlockedWithAccess(B,rdir, ID))	//Boarder blockers use bit values to check dirs, so it's safe to pass diagonal dirs here.
			return 1

		for(var/obj/O in B)
			if(O.density && !istype(O, /obj/machinery/door) && !(O.atom_flags & ATOM_FLAG_CHECKS_BORDER))
				return 1

		//This mess is mainly to combat getting stuck in glass windows due to weird diagonal step_towards behaviour. If you're going northeast for example: if there's a window facing east on the tile above, there MUST be another one facing south or the east facing window will block the move, regardless if the tile to the right of the starting point is completely clear.
		var/turf/iStep = get_step(A,adir&(NORTH|SOUTH))
		var/turf/pStep = get_step(A,adir&(EAST|WEST))

		if(DirBlockedWithAccess(iStep,rdir&(NORTH|SOUTH),ID))	//One 'path' is blocked. The other path MUST be completely free
			if(DirBlockedWithAccess(pStep,rdir&(EAST|WEST),ID) || DirBlockedWithAccess(pStep,adir&(NORTH|SOUTH),ID) || pStep.density)
				return 1
			else
				for(var/obj/O in pStep)	//Check for dense objects in the other path
					if(O.density && !istype(O, /obj/machinery/door) && !(O.atom_flags & ATOM_FLAG_CHECKS_BORDER))
						return 1
				return 0
		else if(DirBlockedWithAccess(iStep,adir&(EAST|WEST),ID))	//Adjacent tile exiting dir is blocked but entering isn't. Mobs will get stuck here, even if the other path is free!
			return 1
		if(DirBlockedWithAccess(pStep,rdir&(EAST|WEST),ID))	//Same checks, but for the other path
			if(DirBlockedWithAccess(iStep,rdir&(NORTH|SOUTH),ID) || DirBlockedWithAccess(iStep,adir&(EAST|WEST),ID) || iStep.density)
				return 1
			else
				for(var/obj/O in iStep)
					if(O.density && !istype(O, /obj/machinery/door) && !(O.atom_flags & ATOM_FLAG_CHECKS_BORDER))
						return 1
				return 0
		else if(DirBlockedWithAccess(pStep,adir&(NORTH|SOUTH),ID))
			return 1

		for(var/obj/O in iStep)	//Both paths free? Check them for objects. So long as one isn't blocked, we can move
			if(O.density && !istype(O, /obj/machinery/door) && !(O.atom_flags & ATOM_FLAG_CHECKS_BORDER))
				for(var/obj/OB in pStep)
					if(OB.density && !istype(OB, /obj/machinery/door) && !(OB.atom_flags & ATOM_FLAG_CHECKS_BORDER))
						return 1
				return 0
		return 0

	if(DirBlockedWithAccess(A,adir, ID))
		return 1

	if(DirBlockedWithAccess(B,rdir, ID))
		return 1

	for(var/obj/O in B)
		if(O.density && !istype(O, /obj/machinery/door) && !(O.atom_flags & ATOM_FLAG_CHECKS_BORDER))
			return 1

	return 0

// Returns true if direction is blocked from loc
// Checks doors against access with given ID
/proc/DirBlockedWithAccess(turf/loc,var/dir,var/obj/item/weapon/card/id/ID)
	for(var/obj/structure/window/D in loc)
		if(!D.density)			continue
		if(D.is_fulltile())		return 1
		if(D.dir & dir)			return 1

	for(var/obj/machinery/door/D in loc)
		if(!D.density)			continue
		if(istype(D, /obj/machinery/door/window))
			if( dir & D.dir )	return !D.check_access(ID)

			//if((dir & SOUTH) && (D.dir & (EAST|WEST)))		return !D.check_access(ID)
			//if((dir & EAST ) && (D.dir & (NORTH|SOUTH)))	return !D.check_access(ID)
		else 
			if(istype(D, /obj/machinery/door/airlock/lift))	//Stop bots committing suicide down the lift shaft, as amusing as it is
				return !D.check_access(ID) || D.density
			var/obj/machinery/door/airlock/A = D
			if(istype(A) && (A.locked || A.isAllPowerLoss() || A.welded))	//Avoid airlocks that are bolted, welded, or have no power
				return 1
			return (!D.check_access(ID))	// it's a real, air blocking door

	for(var/obj/structure/railing/D in loc)
		if(!D.density)			continue
		if(dir & D.dir)			return 1
	return 0


//Multi-Z AStar Procs

/turf/proc/Euclidean3dDistance(turf/t)
	var/euclid_dist = sqrt(Square(src.x - t.x) + Square(src.y - t.y) + Square(src.z - t.z))
	var/currentPathweight = ((locate(/obj/machinery/door) in src) && pathweight == 1) ? 2 : pathweight
	var/targetPathweight = ((locate(/obj/machinery/door) in t) && t.pathweight == 1) ? 2 : t.pathweight
	return euclid_dist * ((currentPathweight+targetPathweight)/2)

/turf/proc/Manhatten3dDistance(turf/t)
	var/manhatten_dist = abs(src.x - t.x) + abs(src.y - t.y) + abs(src.z - t.z)
	var/currentPathweight = ((locate(/obj/machinery/door) in src) && src.pathweight == 1) ? 2 : src.pathweight
	var/targetPathweight = ((locate(/obj/machinery/door) in t) && t.pathweight == 1) ? 2 : t.pathweight
	return manhatten_dist * ((currentPathweight+targetPathweight)/2)

//NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST + Traversal up and down stairs
/turf/proc/AllDirTurfsWithAccessWithZ(var/obj/item/weapon/card/id/ID)
	var/L[] = new()

	for(var/d in GLOB.alldirs)
		var/turf/simulated/T = get_step(src, d)
		if(istype(T) && !T.density)
			var/turf/simulated/open/OP = T
			if(istype(OP) && (!locate(/obj/structure/lattice) in OP) && !LinkBlockedWithAccess(src, OP, ID))
				if(!OP.below.density)
					L.Add(OP.below)
			else if(!LinkBlockedWithAccess(src, T, ID))
				L.Add(T)
		else
			var/obj/structure/stairs/S = locate(/obj/structure/stairs) in src
			if(S?.dir == d && !LinkBlockedAbove(src,GetAbove(S),d))
				L.Add(get_step(GetAbove(S), d))

	return L

//NORTH, SOUTH, EAST, WEST + Traversal up and down stairs
/turf/proc/CardinalTurfsWithAccessWithZ(var/obj/item/weapon/card/id/ID)
	var/L[] = new()

	for(var/d in GLOB.cardinal)
		var/turf/simulated/T = get_step(src, d)
		if(istype(T) && !T.density)
			var/turf/simulated/open/OP = T
			if(istype(OP) && (!locate(/obj/structure/lattice) in OP) && !LinkBlockedWithAccess(src, OP, ID))
				if(!OP.below.density)
					L.Add(OP.below)
			else if(!LinkBlockedWithAccess(src, T, ID))
				L.Add(T)
		else
			var/obj/structure/stairs/S = locate(/obj/structure/stairs) in src
			if(S?.dir == d && !LinkBlockedAbove(src,GetAbove(S),d))
				L.Add(get_step(GetAbove(S), d))

	return L

//Checks for directional blockages at the base of the stairs leading up, open space above, and that nothing is blocking the exit point. Returns 1 on fail
/proc/LinkBlockedAbove(var/turf/lower, var/turf/simulated/open/upper, var/dir)
	if(!istype(upper))		return 1
	for(var/obj/A in lower)
		if(!A.density)		continue
		if(istype(A,/obj/structure/window) || istype(A,/obj/structure/railing))
			return (A.dir == dir)
		else				return 1
	var/turf/exit = get_step(upper, dir)
	if(exit.density)		return 1
	for(var/obj/B in exit)
		if(B.density)		return 1
	return 0