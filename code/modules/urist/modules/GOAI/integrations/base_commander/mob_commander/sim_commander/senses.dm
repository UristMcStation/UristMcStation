
/sense/sim_commander_eyes


/sense/sim_commander_eyes/proc/UpdatePerceptions(var/datum/goai/mob_commander/sim_commander/owner)
	var/datum/brain/owner_brain = owner.brain

	if(isnull(owner_brain))
		// No point processing this if there's no memories to set
		return

	var/atom/pawn = owner.pawn

	if(isnull(pawn))
		// We grab the view range from the owned mob, so we need it here
		return

	var/list/old_visual_range = owner_brain?.perceptions?[SENSE_SIGHT_CURR]
	var/list/visual_range = view(pawn)

	if(old_visual_range)
		owner_brain?.perceptions[SENSE_SIGHT_PREV] = old_visual_range

	if(visual_range)
		owner_brain?.perceptions[SENSE_SIGHT_CURR] = visual_range

	owner_brain?.perceptions[SENSE_SIGHT] = (visual_range || list()) | (old_visual_range || list())
	return



/sense/sim_commander_eyes/proc/SpotWaypoint(var/datum/goai/mob_commander/sim_commander/owner)
	if(isnull(owner))
		return

	var/datum/brain/owner_brain = owner?.brain
	if(isnull(owner_brain))
		// No point processing this if there's no memories to use
		return

	var/atom/waypoint = owner.brain.GetMemoryValue(MEM_WAYPOINT_IDENTITY, null, FALSE, TRUE)

	if(isnull(waypoint))
		return

	if(owner_brain.GetMemory(MEM_WAYPOINT_LKP, FALSE, FALSE))
		return

	var/list/true_searchspace = owner_brain?.perceptions?.Get(SENSE_SIGHT)
	if(!(true_searchspace))
		return

	if(waypoint in true_searchspace)
		var/list/waypoint_memory_data = list(
			KEY_GHOST_X = waypoint.x,
			KEY_GHOST_Y = waypoint.y,
			KEY_GHOST_Z = waypoint.z,
			KEY_GHOST_POS_TUPLE = waypoint.CurrentPositionAsTuple(),
		)
		var/dict/waypoint_memory_ghost = new(waypoint_memory_data)
		owner_brain.SetMemory(MEM_WAYPOINT_LKP, waypoint_memory_ghost, owner.ai_tick_delay*20)

	return TRUE


/sense/sim_commander_eyes/ProcessTick(var/owner)
	..(owner)

	if(processing)
		return

	processing = TRUE

	UpdatePerceptions(owner)
	SpotWaypoint(owner)

	spawn(src.GetOwnerAiTickrate(owner) * 3)
		// Sense-side delay to avoid spamming view() scans too much
		processing = FALSE
	return


/sense/sim_commander_obstruction_handler
	/* Spots obstacles that can be overcome with an Action,
	// such as doors (Open/Break), tables (Climb), etc.
	// and updates the Owner with actions to handle that action.

	// WARNING: not currently used, kept to make sure the code doesn't go stale
	*/


/sense/sim_commander_obstruction_handler/proc/SpotObstacles(var/datum/goai/mob_commander/sim_commander/owner)
	if(!owner)
		// No mob - no point.
		return

	if(!(owner.pawn))
		// No mob - no point.
		return

	var/datum/brain/owner_brain = owner?.brain
	if(isnull(owner_brain))
		// No point processing this if there's no memories to use
		// Might not be a precondition later.
		return

	var/atom/waypoint = owner.brain.GetMemoryValue(MEM_WAYPOINT_IDENTITY, null, FALSE, TRUE)
	if(isnull(waypoint))
		// Nothing to spot.
		return

	owner.SpotObstacles(
		owner = owner,
		target = waypoint,
	)

	// Obstacles:
	var/atom/obstruction = owner_brain.GetMemoryValue(MEM_OBSTRUCTION)
	var/handled = isnull(obstruction) // if obs is null, counts as handled

	if(obstruction)
		var/list/goto_preconds = list(
			STATE_HASWAYPOINT = TRUE,
			STATE_PANIC = -TRUE,
			//STATE_DISORIENTED = -TRUE,
		)

		var/list/common_preconds = list(
			STATE_PANIC = -TRUE,
			//STATE_DISORIENTED = -TRUE,
		)

		handled = owner.HandleWaypointObstruction(
			obstruction = obstruction,
			waypoint = waypoint,
			shared_preconds = common_preconds,
			target_preconds = goto_preconds,
			move_action_name = "Move towards",
			move_handler = /datum/goai/mob_commander/proc/HandleDirectionalCoverLeapfrog,
			unique = FALSE,
			allow_failed = TRUE
		)

	return handled


/sense/sim_commander_obstruction_handler/ProcessTick(var/owner)
	..(owner)

	if(processing)
		return

	processing = TRUE

	// This is the Sense's proc, not the mob's; name's the same:
	src.SpotObstacles(owner)

	spawn(src.GetOwnerAiTickrate(owner) * 20)
		// Sense-side delay to avoid spamming view() scans too much
		processing = FALSE
	return



// PANIC PATHFINDER SERVICE
/sense/sim_commander_panic_pathfinder
	/* Sense component.
	// Runs periodically and finds a path to run away to if the Owner panics.
	//
	// As this is a pathfinding service, it should be run on a fairly sparse schedule.
	*/

/sense/sim_commander_panic_pathfinder/ProcessTick(var/owner)
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


/sense/sim_commander_panic_pathfinder/proc/SpotObstacles(var/datum/goai/mob_commander/sim_commander/owner)
	if(!(owner))
		// No mob - no point.
		return

	var/datum/brain/owner_brain = owner?.brain
	if(isnull(owner_brain))
		// No point processing this if there's no memories to use
		// Might not be a precondition later.
		return

	var/min_safe_dist = owner_brain.GetPersonalityTrait(KEY_PERS_MINSAFEDIST, 2)

	var/atom/waypoint = owner.ChoosePanicRunLandmark(
		primary_threat = null,
		threats = null,
		min_safe_dist = min_safe_dist
	)

	if(isnull(waypoint))
		// Nothing to spot.
		return

	owner.SpotObstacles(
		owner = owner,
		target = waypoint,
	)

	// Obstacles:
	var/atom/obstruction = owner_brain.GetMemoryValue(MEM_OBSTRUCTION)
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


// SAFESPACE FINDER
/sense/sim_commander_safespace_finder
	/* Sense component. Runs periodically and updates the mob's safe spaces.
	//
	// This can be used to help agents run away from threats back to prior
	// locations beyond their *current* visual range.
	*/


/sense/sim_commander_safespace_finder/proc/UpdateSafespace(var/datum/goai/mob_commander/sim_commander/owner)
	if(!owner)
		// useless in a vacuum
		return

	if(!owner.pawn)
		// useless in a vacuum
		return

	if(!(owner.brain))
		// whole point is to set a memory, so no-go
		return

	var/turf/safespace = get_turf(src)
	if(safespace)
		owner.brain.SetMemory(MEM_SAFESPACE, safespace, src.GetOwnerAiTickrate(owner) * 100)

	return


/sense/sim_commander_safespace_finder/ProcessTick(var/owner)
	..(owner)

	if(processing)
		return

	processing = TRUE

	UpdateSafespace(owner)

	spawn(src.GetOwnerAiTickrate(owner) * 40)
		// Sense-side delay to avoid spamming view() scans too much
		processing = FALSE
	return


/datum/goai/mob_commander/sim_commander/InitSenses()
	/* Parent stuff */
	. = ..()

	/* Initialize sense objects: */
	var/sense/sim_commander_eyes/eyes = new()
	//var/sense/sim_commander_obstruction_handler/obstacle_handler = new()
	//var/sense/sim_commander_panic_pathfinder/panicpath_handler = new()
	//var/sense/sim_commander_safespace_finder/safety_finder = new()

	/* Register each Sense: */
	senses.Add(eyes)
	//senses.Add(obstacle_handler)
	//senses.Add(panicpath_handler)
	//senses.Add(safety_finder)

	return
