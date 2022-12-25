/mob/goai/combatant/proc/FightTick()
	var/can_fire = ((STATE_CANFIRE in states) ? states[STATE_CANFIRE] : FALSE)

	if(!can_fire)
		return

	var/atom/target = GetTarget()

	var/datum/aim/target_aim = brain?.GetMemoryValue(KEY_ACTION_AIM, null, FALSE)

	var/aim_time = GetAimTime(target)

	if(isnull(target_aim) || target_aim.target != target)
		if(brain)
			target_aim = new(target)
			brain?.SetMemory(KEY_ACTION_AIM, target_aim, aim_time*5)
			// we started aiming, no point in moving forwards
			// I guess unless/until I add melee...
			return

	spawn(aim_time)
		if(target in view(src))
			Shoot(null, target)

	return


/mob/goai/combatant/proc/GetAimTime(var/atom/target)
	if(isnull(target))
		return

	var/targ_distance = EuclidDistance(src, target)
	var/aim_time = rand(clamp(targ_distance*3, 1, 200)) + rand()*15
	return aim_time


/mob/goai/combatant/proc/GetTarget(var/list/searchspace = null, var/maxtries = 5)
	var/list/true_searchspace = (isnull(searchspace) ? brain?.perceptions?.Get(SENSE_SIGHT) : searchspace)
	if(!(true_searchspace))
		return

	var/PriorityQueue/target_queue = new /PriorityQueue(/datum/Tuple/proc/FirstCompare)

	for(var/mob/goai/combatant/enemy in true_searchspace)
		var/enemy_dist = ManhattanDistance(src.loc, enemy)

		if (enemy_dist <= 0)
			continue

		var/datum/Tuple/enemy_tup = new(-enemy_dist, enemy)
		target_queue.Enqueue(enemy_tup)

	var/tries = 0
	var/atom/target = null

	while (isnull(target) && target_queue.L.len && tries < maxtries)
		var/datum/Tuple/best_target_tup = target_queue.Dequeue()
		target = best_target_tup.right
		tries++

	return target


/mob/goai/combatant/proc/Shoot(var/obj/gun/cached_gun = null, var/atom/cached_target = null, var/datum/aim/cached_aim = null)
	. = FALSE

	var/obj/gun/my_gun = (isnull(cached_gun) ? (locate(/obj/gun) in src.contents) : cached_gun)

	if(isnull(my_gun))
		world.log << "Gun not found for [src] to shoot D;"
		return FALSE

	var/atom/target = (isnull(cached_target) ? GetTarget() : cached_target)

	if(!isnull(target))
		my_gun.shoot(target, src)
		. = TRUE

	return .


/mob/goai/combatant/proc/GetActiveThreatDict() // -> /dict
	var/dict/threat_ghost = brain?.GetMemoryValue(MEM_THREAT, null, FALSE)
	return threat_ghost


/mob/goai/combatant/proc/GetActiveSecondaryThreatDict() // -> /dict
	var/dict/threat_ghost = brain?.GetMemoryValue(MEM_THREAT, null, FALSE)
	return threat_ghost


/mob/goai/combatant/proc/GetThreatPosTuple(var/dict/curr_threat = null) // -> num
	var/dict/threat_ghost = isnull(curr_threat) ? GetActiveThreatDict() : curr_threat

	var/threat_pos_x = 0
	var/threat_pos_y = 0

	if(!isnull(threat_ghost))
		threat_pos_x = threat_ghost.Get(KEY_GHOST_X, null)
		threat_pos_y = threat_ghost.Get(KEY_GHOST_Y, null)

		var/datum/Tuple/ghost_pos_tuple = new(threat_pos_x, threat_pos_y)

		return ghost_pos_tuple

	return


/mob/goai/combatant/proc/GetThreatDistance(var/atom/relative_to = null, var/dict/curr_threat = null, var/default = 0) // -> num
	var/datum/Tuple/ghost_pos_tuple = GetThreatPosTuple(curr_threat)

	if(isnull(ghost_pos_tuple))
		return default

	var/atom/rel_source = isnull(relative_to) ? src : relative_to
	var/threat_dist = default

	var/threat_pos_x = ghost_pos_tuple?.left
	var/threat_pos_y = ghost_pos_tuple?.right

	if(! (isnull(threat_pos_x) || isnull(threat_pos_y)) )
		threat_dist = ManhattanDistanceNumeric(rel_source.x, rel_source.y, threat_pos_x, threat_pos_y)

	return threat_dist


/mob/goai/combatant/proc/GetThreatChunk(var/dict/curr_threat) // -> turfchunk
	var/datum/Tuple/ghost_pos_tuple = GetThreatPosTuple(curr_threat)

	if(isnull(ghost_pos_tuple))
		return

	var/threat_pos_x = ghost_pos_tuple?.left
	var/threat_pos_y = ghost_pos_tuple?.right

	var/datum/chunk/threat_chunk = null

	if(! (isnull(threat_pos_x) || isnull(threat_pos_y)) )
		var/datum/chunkserver/chunkserver = GetOrSetChunkserver()
		threat_chunk = chunkserver.ChunkForTile(threat_pos_x, threat_pos_y, src.z)

	return threat_chunk


/mob/goai/combatant/proc/GetThreatAngle(var/atom/relative_to = null, var/dict/curr_threat = null, var/default = null)
	var/datum/Tuple/ghost_pos_tuple = GetThreatPosTuple(curr_threat)

	if(isnull(ghost_pos_tuple))
		return default

	var/atom/rel_source = isnull(relative_to) ? src : relative_to
	var/threat_angle = default

	var/threat_pos_x = ghost_pos_tuple?.left
	var/threat_pos_y = ghost_pos_tuple?.right

	if(! (isnull(threat_pos_x) || isnull(threat_pos_y)) )
		var/dx = (threat_pos_x - rel_source.x)
		var/dy = (threat_pos_y - rel_source.y)
		threat_angle = arctan(dx, dy)

	return threat_angle


/*
// This is commented out to prevent confusion between the plural, array methods
// and the singular, 'scalar' Threat methods.
// These will probably get removed, unless I figure out why it's such a pain right now.

/mob/goai/combatant/proc/GetActiveThreatDicts() // -> list(/dict)
	var/datum/memory/threat_mem_block = brain?.GetMemory(MEM_THREAT, null, FALSE)
	//world.log << "[src] threat memory: [threat_mem]"
	var/list/threat_block = threat_mem_block?.val // list(memory)
	var/list/threats = list() // list(/dict)

	for(var/datum/memory/threat_mem in threat_block)
		if(isnull(threat_mem))
			continue

		var/dict/threat_ghost = threat_mem?.val
		world.log << "THREAT GHOST: [threat_ghost]"
		if(istype(threat_ghost))
			threats.Add(threat_ghost)

	return threats


/mob/goai/combatant/proc/GetThreatDistances(var/atom/relative_to = null, var/list/curr_threats = null, var/default = 0, var/check_max = null) // -> num
	var/atom/rel_source = isnull(relative_to) ? src : relative_to
	var/list/threat_distances = list()
	var/list/threat_ghosts = isnull(curr_threats) ? GetActiveThreatDicts() : curr_threats

	var/checked_count = 0

	for(var/dict/threat_ghost in threat_ghosts)
		if(isnull(threat_ghost))
			continue

		if(!(isnull(check_max)) && (checked_count++ >= check_max))
			break

		var/threat_dist = default

		var/threat_pos_x = 0
		var/threat_pos_y = 0

		//world.log << "[src] threat ghost: [threat_ghost]"

		threat_pos_x = threat_ghost.Get(KEY_GHOST_X, null)
		threat_pos_y = threat_ghost.Get(KEY_GHOST_Y, null)
		//world.log << "[src] believes there's a threat at ([threat_pos_x], [threat_pos_y])"

		if(! (isnull(threat_pos_x) || isnull(threat_pos_y)) )
			threat_dist = ManhattanDistanceNumeric(rel_source.x, rel_source.y, threat_pos_x, threat_pos_y)

			// long-term, it might be nicer to index by obj/str here
			threat_distances.Add(threat_dist)

	//world.log << "[src]: GetThreatDistances => [threat_distances] LEN [threat_distances.len]"
	return threat_distances


/mob/goai/combatant/proc/GetThreatAngles(var/atom/relative_to = null, var/list/curr_threats = null, var/check_max = null)
	var/atom/rel_source = isnull(relative_to) ? src : relative_to
	var/list/threat_angles = list()
	var/list/threat_ghosts = isnull(curr_threats) ? GetActiveThreatDicts() : curr_threats

	var/checked_count = 0

	for(var/dict/threat_ghost in threat_ghosts)
		if(isnull(threat_ghost))
			continue

		if(!(isnull(check_max)) && (checked_count++ >= check_max))
			break

		var/threat_angle = null

		var/threat_pos_x = 0
		var/threat_pos_y = 0

		//world.log << "[src] threat ghost: [threat_ghost]"

		threat_pos_x = threat_ghost.Get(KEY_GHOST_X, null)
		threat_pos_y = threat_ghost.Get(KEY_GHOST_Y, null)
		//world.log << "[src] believes there's a threat at ([threat_pos_x], [threat_pos_y])"

		if(! (isnull(threat_pos_x) || isnull(threat_pos_y)) )
			var/dx = (threat_pos_x - rel_source.x)
			var/dy = (threat_pos_y - rel_source.y)
			threat_angle = arctan(dx, dy)

			// long-term, it might be nicer to index by obj/str here
			threat_angles.Add(threat_angle)

	return threat_angles
*/

/mob/goai/combatant/Hit(var/angle, var/atom/shotby = null)
	. = ..(angle)

	var/impact_angle = IMPACT_ANGLE(angle)
	/* NOTE: impact_angle is in degrees from *positive X axis* towards Y, i.e.:
	//
	// impact_angle = +0   => hit from straight East
	// impact_angle = +180 => hit from straight West
	// impact_angle = -180 => hit from straight West
	// impact_angle = -90  => hit from straight North
	// impact_angle = +90  => hit from straight South
	// impact_angle = +45  => hit from North-East
	// impact_angle = -45  => hit from South-East
	//
	// Everything else - extrapolate from the above.
	*/
	//world.log << "Impact angle [impact_angle]"

	if(brain)
		var/list/shot_memory_data = list(
			KEY_GHOST_X = src.x,
			KEY_GHOST_Y = src.y,
			KEY_GHOST_Z = src.z,
			KEY_GHOST_POS_TUPLE = src.CurrentPositionAsTuple(),
			KEY_GHOST_ANGLE = impact_angle,
		)
		var/dict/shot_memory_ghost = new(shot_memory_data)

		brain.SetMemory(MEM_SHOTAT, shot_memory_ghost, src.ai_tick_delay*10)

		var/datum/brain/concrete/needybrain = brain
		if(needybrain)
			needybrain.AddMotive(NEED_COMPOSURE, -MAGICNUM_COMPOSURE_LOSS_ONHIT)

