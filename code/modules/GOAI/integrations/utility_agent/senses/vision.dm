
/sense/combatant_commander_eyes


/sense/combatant_commander_eyes/proc/UpdatePerceptions(var/datum/utility_ai/mob_commander/owner)
	var/datum/brain/owner_brain = owner.brain

	if(isnull(owner_brain))
		// No point processing this if there's no memories to set
		return

	var/atom/pawn = owner.GetPawn()

	if(isnull(pawn))
		// We grab the view range from the owned mob, so we need it here
		return

	var/list/visual_range = view(pawn)

	if(visual_range)
		owner_brain?.perceptions[SENSE_SIGHT_CURR] = visual_range

	/*
	// Disabled because it takes a lot of memory for not a lot of obvious benefit
	var/list/old_visual_range = owner_brain?.perceptions?[SENSE_SIGHT_CURR]
	if(old_visual_range)
		owner_brain?.perceptions[SENSE_SIGHT_PREV] = old_visual_range

	owner_brain?.perceptions[SENSE_SIGHT_CURR] = (visual_range || list()) | (old_visual_range || list())
	*/

	return


/sense/combatant_commander_eyes/proc/SpotThreats(var/datum/utility_ai/mob_commander/owner)
	if(isnull(owner))
		return

	var/datum/brain/owner_brain = owner.brain
	if(isnull(owner_brain))
		// No point processing this if there's no memories to set
		return

	var/list/true_searchspace = owner_brain?.perceptions?.Get(SENSE_SIGHT_CURR)
	if(!(true_searchspace))
		return

	var/atom/pawn = owner?.GetPawn()
	var/my_loc = pawn?.loc
	if(isnull(my_loc))
		return

	var/PriorityQueue/target_queue = new /PriorityQueue(/datum/Tuple/proc/FirstCompare)
	var/list/enemies = list()

	// TODO: Refactor to accept objects/structures as threats (turrets, grenades...).
	for(var/mob/enemy in true_searchspace)
		if(!(istype(enemy, /mob/living/carbon) || istype(enemy, /mob/living/simple_animal) || istype(enemy, /mob/living/bot)))
			continue

		if(!(owner.IsEnemy(enemy)))
			continue

		var/enemy_dist = ManhattanDistance(my_loc, enemy)

		if (enemy_dist <= 0)
			continue

		enemies.Add(enemy)
		var/datum/Tuple/enemy_tup = new(enemy_dist, enemy)
		target_queue.Enqueue(enemy_tup)

	owner_brain.SetMemory("Enemies", enemies, owner.ai_tick_delay*20)

	var/tries = 0
	var/maxtries = 3
	var/atom/target = null

	while (isnull(target) && target_queue.L.len && tries < maxtries)
		var/datum/Tuple/best_target_tup = target_queue.Dequeue()
		target = best_target_tup.right
		tries++

	if(istype(target))
		var/list/threat_memory_data = list(
			KEY_GHOST_X = target.x,
			KEY_GHOST_Y = target.y,
			KEY_GHOST_Z = target.z,
			KEY_GHOST_POS_TUPLE = target.CurrentPositionAsTuple(),
		)
		var/dict/threat_memory_ghost = new(threat_memory_data)
		owner_brain.SetMemory(MEM_THREAT, threat_memory_ghost, owner.ai_tick_delay*20)

		// forecast-raycast goes here once I find it

	/* Secondary threat handling.
	// Sadly, using a list of threats was not performant, so
	// we're just allowing two 'slots' for threats.
	// Because of how a PQ works, secondary threat is guaranteed
	// to be of no greater priority than the primary threat.
	*/
	var/secondary_tries = 0
	var/secondary_maxtries = 3
	var/atom/secondary_threat = null

	while (isnull(secondary_threat) && target_queue.L.len && secondary_tries < secondary_maxtries)
		var/datum/Tuple/best_sec_target_tup = target_queue.Dequeue()
		target = best_sec_target_tup.right
		secondary_tries++

	if(istype(secondary_threat))
		var/list/secondary_threat_memory_data = list(
			KEY_GHOST_X = secondary_threat.x,
			KEY_GHOST_Y = secondary_threat.y,
			KEY_GHOST_Z = secondary_threat.z,
			KEY_GHOST_POS_TUPLE = secondary_threat.CurrentPositionAsTuple(),
		)
		var/dict/secondary_threat_memory_ghost = new(secondary_threat_memory_data)
		owner_brain.SetMemory(MEM_THREAT_SECONDARY, secondary_threat_memory_ghost, owner.ai_tick_delay*20)

	return TRUE


/sense/combatant_commander_eyes/proc/SpotWaypoint(var/datum/utility_ai/mob_commander/owner)
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

	var/list/true_searchspace = owner_brain?.perceptions?.Get(SENSE_SIGHT_CURR)
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


/sense/combatant_commander_eyes/ProcessTick(var/owner)
	..(owner)

	if(processing)
		return

	processing = TRUE

	UpdatePerceptions(owner)
	SpotThreats(owner)
	//SpotWaypoint(owner)

	spawn(src.GetOwnerAiTickrate(owner) * 3)
		// Sense-side delay to avoid spamming view() scans too much
		processing = FALSE
	return
