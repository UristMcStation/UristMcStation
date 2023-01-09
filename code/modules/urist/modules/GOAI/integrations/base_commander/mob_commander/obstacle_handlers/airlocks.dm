//Returns action_key if handled and adds the appropriate actions
/datum/goai/mob_commander/proc/HandleAirlockObstruction(var/obj/machinery/door/airlock/A ,var/list/common_preconds = list(), var/waypoint, var/atom/pawn)
	if(!A || !waypoint || !pawn || !istype(A))
		return null

	var/action_key = null

	var/list/open_door_preconds = common_preconds.Copy()	//Any extra preconds are added here, and then passed back to the final appropriate open action
	var/list/base_preconds = common_preconds.Copy()			//Preconditions that must be met for *all* future actions. ie, insulated gloves for shocked airlocks

	var/hack_handled = FALSE

	//Get various airlock states from the brain's memories
	var/no_power = src.brain.GetMemoryValue(MEM_OBJ_NOPOWER(A), null)
	var/is_bolted = src.brain.GetMemoryValue(MEM_OBJ_LOCKED(A), null)
	var/panel_open = src.brain.GetMemoryValue(MEM_OBJ_PANELOPEN(A), null)

	if(src.brain.GetMemoryValue(MEM_OBJ_NOACCESS(A), null))	//Todo: Handle gaining access (find ID?)
		return null

	//*All* future interactions with this airlock will require gloves
	if(src.brain.GetMemoryValue(MEM_OBJ_SHOCKED(A), null))
		base_preconds[STATE_HASINSULGLOVES] = TRUE
		open_door_preconds[STATE_HASINSULGLOVES] = TRUE


	//---- Prerequisite extra actions before attempting an open action ----//

	if(is_bolted)
		if(no_power)	//Bolted with no power. Just give up
			return null

		action_key = "[NEED_OBJ_UNLOCKED(A)] for [waypoint]"

		var/list/extra_preconds = base_preconds.Copy()

		open_door_preconds[action_key] = TRUE	//Extra action key added to base open action
		src.SetState(action_key, FALSE)	//Workaround

		extra_preconds[action_key] = -TRUE
		extra_preconds[STATE_HASCROWBAR] = TRUE
		extra_preconds[STATE_HASMULTITOOL] = TRUE

		if(!panel_open)
			extra_preconds[STATE_HASSCREWDRIVER] = TRUE

		var/list/effects = list()
		effects[action_key] = TRUE

		var/list/action_args = list()
		action_args["airlock"] = A
		action_args["wires"] = list(AIRLOCK_WIRE_DOOR_BOLTS)
		action_args["cut"] = FALSE

		AddAction(
			action_key,
			extra_preconds,
			effects,
			/datum/goai/mob_commander/proc/HandleAirlockHack,
			200,
			1,
			FALSE,
			action_args
		)

		hack_handled = TRUE

	else if(panel_open && !no_power)	//AttackHand/Bump doesn't not work if the panel is open. Close it first if we're not hacking the airlock and it has power
		action_key= "[NEED_OBJ_SCREW(A)] for [waypoint]"

		var/list/extra_preconds = base_preconds.Copy()

		open_door_preconds[action_key] = TRUE
		src.SetState(action_key, FALSE)	//Workaround

		extra_preconds[action_key] = -TRUE
		extra_preconds[STATE_HASSCREWDRIVER] = TRUE

		var/list/effects = list()

		effects[action_key] = TRUE

		var/list/action_args = list()
		action_args["target"] = A

		AddAction(
			action_key,
			extra_preconds,
			effects,
			/datum/goai/mob_commander/proc/HandleScrew,
			5,
			1,
			FALSE,
			action_args
		)

	//---- Opening methods: Pick one ----//

	if(no_power || hack_handled)
		action_key = "[NEED_OBJ_PRY(A)] for [waypoint]"

		open_door_preconds[action_key] = -TRUE
		open_door_preconds[STATE_HASCROWBAR] = TRUE
		src.SetState(action_key, FALSE)	//Workaround

		var/list/effects = list()
		effects[action_key] = TRUE

		var/list/action_args = list()
		action_args["target"] = A

		AddAction(
			action_key,
			open_door_preconds,
			effects,
			/datum/goai/mob_commander/proc/HandlePry,
			15 + rand() - (pawn ? get_dist(A, pawn) : 0),
			1,
			FALSE,
			action_args
		)
	//Prying unpowered airlocks is an /alternative/ way of opening them, not a prerequisite step. We need an else here
	else
		action_key = "[NEED_OBSTACLE_OPEN(A)] for [waypoint]"

		open_door_preconds[action_key] = -TRUE
		src.SetState(action_key, FALSE)	//Workaround

		var/list/open_door_effects = list()
		open_door_effects[action_key] = TRUE

		var/list/action_args = list()
		action_args["obstruction"] = A

		AddAction(
			action_key,
			open_door_preconds,
			open_door_effects,
			/datum/goai/mob_commander/proc/HandleAirlockOpen,
			10 + rand() - (pawn ? get_dist(A, pawn) : 0),
			1,
			FALSE,
			action_args
		)

	return action_key


/datum/goai/mob_commander/proc/HandleAirlockOpen(var/datum/ActionTracker/tracker, var/obj/machinery/door/airlock/obstruction)
	var/mob/pawn = src.GetPawn()
	if (!pawn || !istype(pawn))
		return

	if (!tracker)
		return

	var/walk_dist = (tracker?.BBSetDefault("StartDist", (ManhattanDistance(get_turf(pawn), obstruction) || 0)) || 0)

	if(tracker.IsOlderThan(src.ai_tick_delay * (10 + walk_dist)))
		if(src.brain.GetMemoryValue(MEM_OBSTRUCTION, null) == obstruction)
			src.brain.DropMemory(MEM_OBSTRUCTION)
		tracker.SetFailed()
		return

	//If the mob can see the airlock, check if its bolt lights are on
	if(obstruction in src.brain.perceptions[SENSE_SIGHT_CURR])
		if(obstruction.locked && obstruction.lights)
			tracker.SetFailed()
			src.brain.SetMemory(MEM_OBJ_LOCKED(obstruction), TRUE, 5 MINUTES)
			if(src.brain.GetMemoryValue(MEM_OBSTRUCTION, null) == obstruction)
				src.brain.DropMemory(MEM_OBSTRUCTION)
			return
		if(obstruction.p_open)
			tracker.SetFailed()
			src.brain.SetMemory(MEM_OBJ_PANELOPEN(obstruction), TRUE, 5 MINUTES)
			if(src.brain.GetMemoryValue(MEM_OBSTRUCTION, null) == obstruction)
				src.brain.DropMemory(MEM_OBSTRUCTION)
			return

	var/turf/obs_turf = get_turf(obstruction)
	var/dist_to_obs = ChebyshevDistance(get_turf(pawn), obs_turf)

	if(dist_to_obs < 2 && obstruction.density)
		//The mob is next to the airlock. Poke it and see what it learns
		if(obstruction.locked || !obstruction.arePowerSystemsOn())
			//Airlock won't open (bolted/unpowered). Add it to the memory and fail the tracker.
			obstruction.attack_hand(pawn)
			tracker.SetFailed()
			src.brain.SetMemory(obstruction.locked ? MEM_OBJ_LOCKED(obstruction) : MEM_OBJ_NOPOWER(obstruction), TRUE, 5 MINUTES)
			if(src.brain.GetMemoryValue(MEM_OBSTRUCTION, null) == obstruction)
				src.brain.DropMemory(MEM_OBSTRUCTION)
			return
		if(!obstruction.allowed(pawn))
			//No access to the airlock. Add it memory and fail the tracker. Still poke it though for that sweet sweet denied buzz
			obstruction.attack_hand(pawn)
			tracker.SetFailed()
			src.brain.SetMemory(MEM_OBJ_NOACCESS(obstruction), TRUE) //Come back to this and change the ttl if changing IDs/access becomes a thing
			if(src.brain.GetMemoryValue(MEM_OBSTRUCTION, null) == obstruction)
				src.brain.DropMemory(MEM_OBSTRUCTION)
			return
		if(obstruction.p_open)
			//The panel is open, but somehow our pawn didn't see it. Normal attack_hand()'s wouldn't work here. Fail
			tracker.SetFailed()
			src.brain.SetMemory(MEM_OBJ_PANELOPEN(obstruction), TRUE, 5 MINUTES)
			if(src.brain.GetMemoryValue(MEM_OBSTRUCTION, null) == obstruction)
				src.brain.DropMemory(MEM_OBSTRUCTION)
			return

		//This is hacky, but we'll call this manually so that we get the return from machinery/shock(),
		//There's a cooldown so calling it twice (once implicitly via attack_hand) shouldn't be an issue
		//Todo: Update the memory from the /mob/living/carbon/electrocute_act proc instead

		if(obstruction.isElectrified())
			if(obstruction.shock(pawn, 100))
				src.brain.SetMemory(MEM_OBJ_SHOCKED(obstruction), TRUE, MEM_TIME_LONGTERM)
		obstruction.attack_hand(pawn)


	if(!obstruction.density)
		if(dist_to_obs < 1)
			if(tracker.IsRunning())
				if(src.brain.GetMemoryValue(MEM_OBSTRUCTION, null) == obstruction)
					src.brain.DropMemory(MEM_OBSTRUCTION)
				tracker.SetDone()

		else
			if(!tracker.BBGet("entering_door", FALSE))
				StartNavigateTo(obs_turf, 0)
				tracker.BBSet("entering_door", TRUE)
	else
		var/list/path_to_door = tracker.BBGet("PathToDoor", null)
		if(isnull(path_to_door) || !src.active_path)
			path_to_door = StartNavigateTo(obs_turf, 1)
			tracker.BBSet("PathToDoor", path_to_door)


/datum/goai/mob_commander/proc/HandleAirlockHack(var/datum/ActionTracker/tracker, var/obj/machinery/door/airlock/airlock, var/list/wires, var/cut)
	log_debug("Hack Airlock task for [airlock] ([airlock.x],[airlock.y]) - Wires: [wires] - Cut: [cut]")
	//debug
	if(airlock.locked && AIRLOCK_WIRE_DOOR_BOLTS in wires)
		airlock.unlock()
		tracker.SetDone()
	return

	//VERY WIP. Fuck this AAA
	//Code is unreachable as wip.

	//Todo: Add cooldown here

	//var/list/tried_wires = tracker.BBGet("WireAttempts", list())	//TBI
	var/list/to_fix = tracker.BBGet("FixWires", list())
	var/list/known_wires = src.brain.GetMemoryValue(MEM_AIRLOCK_WIRES, list())
	//var/datum/wires/airlock_wires = airlock.wires		//TBI

	if(length(to_fix))
		//var/wire = pick_n_take(to_fix) //TBI
		tracker.BBSet("FixWires", to_fix)
		//fix wire stuff here
		return

	if(wires[1] in known_wires)
		var/target_wire = wires[1]
		wires.Remove(target_wire)
		if(cut)
			//Todo: cut stuff here
		else
			//Todo: pulse stuff here

	if(!length(wires))
		tracker.SetDone()
		return

	//var/list/wireColours = list("red", "blue", "green", "darkred", "orange", "brown", "gold", "gray", "cyan", "navy", "purple", "pink", "black", "yellow")
	/*
	var/const/AIRLOCK_WIRE_IDSCAN = 1
	var/const/AIRLOCK_WIRE_MAIN_POWER1 = 2
	var/const/AIRLOCK_WIRE_MAIN_POWER2 = 4
	var/const/AIRLOCK_WIRE_DOOR_BOLTS = 8
	var/const/AIRLOCK_WIRE_BACKUP_POWER1 = 16
	var/const/AIRLOCK_WIRE_BACKUP_POWER2 = 32
	var/const/AIRLOCK_WIRE_OPEN_DOOR = 64
	var/const/AIRLOCK_WIRE_AI_CONTROL = 128
	var/const/AIRLOCK_WIRE_ELECTRIFY = 256
	var/const/AIRLOCK_WIRE_SAFETY = 512
	var/const/AIRLOCK_WIRE_SPEED = 1024
	var/const/AIRLOCK_WIRE_LIGHT = 2048
	*/