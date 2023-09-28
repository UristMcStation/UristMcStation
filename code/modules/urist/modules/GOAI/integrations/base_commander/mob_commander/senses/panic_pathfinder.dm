// PANIC PATHFINDER SERVICE
/sense/combatant_commander_panic_pathfinder
	/* Sense component.
	// Runs periodically and finds a path to run away to if the Owner panics.
	//
	// As this is a pathfinding service, it should be run on a fairly sparse schedule.
	*/

/sense/combatant_commander_panic_pathfinder/ProcessTick(var/owner)
	..(owner)

	if(processing)
		return

	processing = TRUE

	// This is the Sense's proc, not the mob's; name's the same:
	src.SpotObstacles(owner)

	spawn(PANIC_SENSE_THROTTLE*2)
		// Sense-side delay to avoid spamming Astars too much
		processing = FALSE
	return


/sense/combatant_commander_panic_pathfinder/proc/SpotObstacles(var/datum/goai/mob_commander/combat_commander/owner)
	if(!(owner))
		// No mob - no point.
		return

	var/atom/pawn = owner?.GetPawn()
	if(!pawn)
		return

	var/owner_z = pawn.z

	var/datum/brain/owner_brain = owner?.brain
	if(isnull(owner_brain))
		// No point processing this if there's no memories to use
		// Might not be a precondition later.
		return

	var/list/threats = list()
	var/min_safe_dist = owner_brain.GetPersonalityTrait(KEY_PERS_MINSAFEDIST, 2)

	// Main threat:
	var/dict/primary_threat_ghost = owner.GetActiveThreatDict()
	var/datum/Tuple/primary_threat_pos_tuple = owner.GetThreatPosTuple(primary_threat_ghost)
	var/atom/primary_threat = null
	if(!(isnull(primary_threat_pos_tuple?.left) || isnull(primary_threat_pos_tuple?.right)))
		primary_threat = locate(primary_threat_pos_tuple.left, primary_threat_pos_tuple.right, owner_z)

	if(primary_threat_ghost)
		threats[primary_threat_ghost] = primary_threat

	// Secondary threat:
	var/dict/secondary_threat_ghost = owner.GetActiveSecondaryThreatDict()
	var/datum/Tuple/secondary_threat_pos_tuple = owner.GetThreatPosTuple(secondary_threat_ghost)
	var/atom/secondary_threat = null
	if(!(isnull(secondary_threat_pos_tuple?.left) || isnull(secondary_threat_pos_tuple?.right)))
		secondary_threat = locate(secondary_threat_pos_tuple.left, secondary_threat_pos_tuple.right, owner_z)

	if(secondary_threat_ghost)
		threats[secondary_threat_ghost] = secondary_threat

	var/atom/waypoint = owner.ChoosePanicRunLandmark(
		primary_threat = primary_threat,
		threats = threats,
		min_safe_dist = min_safe_dist
	)

	if(isnull(waypoint))
		// Nothing to spot.
		return

	owner.SpotObstacles(
		owner = owner,
		target = waypoint,
		obstruction_tag = "PANIC"
	)

	// Obstacles:
	var/atom/obstruction = owner_brain.GetMemoryValue(MEM_OBSTRUCTION("PANIC"))
	var/handled = isnull(obstruction) // if obs is null, counts as handled

	var/list/shared_preconds = list(
		STATE_PANIC = TRUE,
	)

	var/list/movement_preconds = list(
		STATE_PANIC = TRUE,
	)

	handled = owner.HandleWaypointObstruction(
		obstruction = obstruction,
		waypoint = waypoint,
		shared_preconds = shared_preconds,
		target_preconds = movement_preconds,
		move_action_name = "PanicRun",
		move_handler = /datum/goai/mob_commander/proc/HandlePanickedRun,
		unique = FALSE,
		allow_failed = TRUE
	)

	if(handled)
		owner_brain?.SetMemory(MEM_BESTPOS_PANIC, waypoint, PANIC_SENSE_THROTTLE*3)

	return handled
