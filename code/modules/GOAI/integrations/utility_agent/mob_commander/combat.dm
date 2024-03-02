/*
// Assorted procs for making mob AI handle combat
*/

/datum/utility_ai/mob_commander/proc/GetAimTime(var/atom/target)
	if(isnull(target))
		return

	var/atom/pawn = src.GetPawn()
	if(!pawn)
		return

	var/targ_distance = EuclidDistance(pawn, target)
	var/aim_time = rand(clamp(targ_distance*3, 1, 200)) + rand_gauss(7.5, 2.5)
	return aim_time


/datum/utility_ai/mob_commander/proc/GetTarget(var/list/searchspace = null, var/maxtries = 5)
	var/list/true_searchspace = (isnull(searchspace) ? brain?.perceptions?.Get(SENSE_SIGHT_CURR) : searchspace)

	if(!(true_searchspace))
		return

	var/atom/pawn = src.GetPawn()
	if(!pawn)
		return

	var/atom/my_loc = pawn?.loc
	if(!my_loc)
		to_world_log("[src] attempted to get loc, but couldn't find one!")
		return

	var/PriorityQueue/target_queue = new /PriorityQueue(/datum/Tuple/proc/FirstCompare)

	for(var/mob/enemy in true_searchspace)
		if(!(istype(enemy, /mob/living/carbon) || istype(enemy, /mob/living/simple_animal) || istype(enemy, /mob/living/bot)))
			continue

		if(enemy == pawn)
			continue

		if(!(src.IsEnemy(enemy)))
			continue

		var/enemy_dist = ManhattanDistance(my_loc, enemy)

		var/datum/Tuple/enemy_tup = new(-enemy_dist, enemy)
		target_queue.Enqueue(enemy_tup)

	var/tries = 0
	var/atom/target = null

	while (isnull(target) && target_queue.L.len && tries < maxtries)
		var/datum/Tuple/best_target_tup = target_queue.Dequeue()
		target = best_target_tup.right
		tries++

	return target


# ifdef GOAI_SS13_SUPPORT

/mob/living/carbon/human/proc/FindGunInHands(var/mob/living/carbon/human/trg_override = null)
	var/mob/living/carbon/human/H = trg_override
	if(isnull(H))
		H = src

	var/obj/item/gun/my_gun = null

	// either hand works
	if(isnull(my_gun))
		my_gun = H.get_equipped_item(slot_r_hand)

	if(isnull(my_gun))
		my_gun = H.get_equipped_item(slot_l_hand)

	return my_gun

# endif

/datum/utility_ai/mob_commander/proc/Shoot(var/obj/item/gun/cached_gun = null, var/atom/cached_target = null, var/datum/aim/cached_aim = null)
	. = FALSE

	var/atom/pawn = src.GetPawn()
	if(!pawn)
		to_world_log("No mob not found for the [src.name] AI to shoot D;")
		return FALSE

	var/obj/item/gun/my_gun = cached_gun

	var/obj/item/gun/gun_pawn = pawn

	var/atom/target = (isnull(cached_target) ? GetTarget() : cached_target)

	var/mob/living/targetLM = target

	# ifdef GOAI_SS13_SUPPORT

	var/mob/living/carbon/human/H = pawn
	var/mob/living/simple_animal/SAH = pawn

	if(SAH && istype(SAH) && target && SAH.stat == CONSCIOUS && (targetLM?.stat != DEAD))
		// SimpleAnimals are simple (duh), *they* handle if they can shoot so we don't have to.
		SAH.RangedAttack(target)
		return TRUE

	if(H && istype(H))
		if(!(H.zone_sel))
			// weird, but seemingly needed or stuff runtimes
			H.zone_sel = new /obj/screen/zone_sel()

		if(H.stat == CONSCIOUS)
			my_gun = (my_gun || H.FindGunInHands())

		else
			return FALSE

	# endif

	# ifdef GOAI_LIBRARY_FEATURES

	if(isnull(my_gun))
		my_gun = (locate(/obj/item/gun) in pawn.contents)

	# endif

	if(isnull(my_gun))
		to_world_log("[src] - Gun not found for [pawn] to shoot D;")
		return FALSE

	if(!isnull(target) && (targetLM?.stat != DEAD))
		if(my_gun)
			my_gun.Fire(target, pawn)
			return TRUE

		else if(gun_pawn)
			gun_pawn.Fire(target, gun_pawn)
			return TRUE

		else
			to_world_log("[src] - target [target] is null or no gun found!")

	return .


/datum/utility_ai/mob_commander/proc/Melee(var/atom/cached_target = null, var/datum/aim/cached_aim = null)
	. = FALSE

	var/atom/pawn = src.GetPawn()
	if(!pawn)
		to_world_log("No mob not found for the [src.name] AI to attack with D;")
		return FALSE

	# ifdef GOAI_SS13_SUPPORT

	var/atom/target = (isnull(cached_target) ? GetTarget() : cached_target)
	var/distance = ChebyshevDistance(pawn, target)
	var/mob/living/targetLM = target

	if(!isnull(target) && distance <= 1 && (targetLM?.stat != DEAD))
		var/mob/living/carbon/human/H = pawn
		var/mob/living/simple_animal/SAH = pawn

		if(istype(H) && H?.stat == CONSCIOUS)
			if(!(H.zone_sel))
				// weird, but seemingly needed or stuff runtimes
				H.zone_sel = new /obj/screen/zone_sel()

			var/old_intent = H.a_intent
			H.a_intent = I_HURT
			target.attack_hand(H)
			H.a_intent = old_intent

		else if(istype(SAH) && SAH.stat == CONSCIOUS)
			SAH.attack_target(target)

		. = TRUE

	# endif

	return .


/datum/utility_ai/mob_commander/proc/GetActiveThreatDict() // -> /dict
	var/dict/threat_ghost = brain?.GetMemoryValue(MEM_THREAT, null, FALSE)
	return threat_ghost


/datum/utility_ai/mob_commander/proc/GetActiveSecondaryThreatDict() // -> /dict
	var/dict/threat_ghost = brain?.GetMemoryValue(MEM_THREAT, null, FALSE)
	return threat_ghost


/datum/utility_ai/mob_commander/proc/GetThreatPosTuple(var/dict/curr_threat = null) // -> num
	var/dict/threat_ghost = isnull(curr_threat) ? GetActiveThreatDict() : curr_threat

	var/threat_pos_x = 0
	var/threat_pos_y = 0

	if(!isnull(threat_ghost))
		threat_pos_x = threat_ghost.Get(KEY_GHOST_X, null)
		threat_pos_y = threat_ghost.Get(KEY_GHOST_Y, null)

		var/datum/Tuple/ghost_pos_tuple = new(threat_pos_x, threat_pos_y)

		return ghost_pos_tuple

	return


/datum/utility_ai/mob_commander/proc/GetThreatDistance(var/atom/relative_to = null, var/dict/curr_threat = null, var/default = 0) // -> num
	var/datum/Tuple/ghost_pos_tuple = GetThreatPosTuple(curr_threat)

	var/atom/pawn = src.GetPawn()
	if(!pawn)
		return default

	if(isnull(ghost_pos_tuple))
		return default

	var/atom/rel_source = isnull(relative_to) ? pawn : relative_to
	var/threat_dist = default

	var/threat_pos_x = ghost_pos_tuple?.left
	var/threat_pos_y = ghost_pos_tuple?.right

	if(! (isnull(threat_pos_x) || isnull(threat_pos_y)) )
		threat_dist = ManhattanDistanceNumeric(rel_source.x, rel_source.y, threat_pos_x, threat_pos_y)

	return threat_dist


/datum/utility_ai/mob_commander/proc/GetThreatChunk(var/dict/curr_threat) // -> turfchunk
	var/datum/Tuple/ghost_pos_tuple = GetThreatPosTuple(curr_threat)

	if(isnull(ghost_pos_tuple))
		return

	var/atom/pawn = src.GetPawn()
	if(!pawn)
		return

	var/threat_pos_x = ghost_pos_tuple?.left
	var/threat_pos_y = ghost_pos_tuple?.right

	var/datum/chunk/threat_chunk = null

	if(! (isnull(threat_pos_x) || isnull(threat_pos_y)) )
		var/datum/chunkserver/chunkserver = GetOrSetChunkserver()
		threat_chunk = chunkserver.ChunkForTile(threat_pos_x, threat_pos_y, pawn.z)

	return threat_chunk


/datum/utility_ai/mob_commander/proc/GetThreatAngle(var/atom/relative_to = null, var/dict/curr_threat = null, var/default = null)
	var/datum/Tuple/ghost_pos_tuple = GetThreatPosTuple(curr_threat)

	if(isnull(ghost_pos_tuple))
		return default

	var/atom/pawn = src.GetPawn()
	if(!pawn)
		return default

	var/atom/rel_source = isnull(relative_to) ? pawn : relative_to
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

/datum/utility_ai/mob_commander/proc/GetActiveThreatDicts() // -> list(/dict)
	var/datum/memory/threat_mem_block = brain?.GetMemory(MEM_THREAT, null, FALSE)
	//to_world_log("[src.pawn] threat memory: [threat_mem]")
	var/list/threat_block = threat_mem_block?.val // list(memory)
	var/list/threats = list() // list(/dict)

	for(var/datum/memory/threat_mem in threat_block)
		if(isnull(threat_mem))
			continue

		var/dict/threat_ghost = threat_mem?.val
		to_world_log("THREAT GHOST: [threat_ghost]")
		if(istype(threat_ghost))
			threats.Add(threat_ghost)

	return threats


/datum/utility_ai/mob_commander/proc/GetThreatDistances(var/atom/relative_to = null, var/list/curr_threats = null, var/default = 0, var/check_max = null) // -> num
	var/atom/rel_source = isnull(relative_to) ? src.pawn : relative_to
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

		//to_world_log("[src.pawn] threat ghost: [threat_ghost]")

		threat_pos_x = threat_ghost.Get(KEY_GHOST_X, null)
		threat_pos_y = threat_ghost.Get(KEY_GHOST_Y, null)
		//to_world_log("[src.pawn] believes there's a threat at ([threat_pos_x], [threat_pos_y])")

		if(! (isnull(threat_pos_x) || isnull(threat_pos_y)) )
			threat_dist = ManhattanDistanceNumeric(rel_source.x, rel_source.y, threat_pos_x, threat_pos_y)

			// long-term, it might be nicer to index by obj/str here
			threat_distances.Add(threat_dist)

	//to_world_log("[src.pawn]: GetThreatDistances => [threat_distances] LEN [threat_distances.len]")
	return threat_distances


/datum/utility_ai/mob_commander/proc/GetThreatAngles(var/atom/relative_to = null, var/list/curr_threats = null, var/check_max = null)
	var/atom/rel_source = isnull(relative_to) ? src.pawn : relative_to
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

		//to_world_log("[src.pawn] threat ghost: [threat_ghost]")

		threat_pos_x = threat_ghost.Get(KEY_GHOST_X, null)
		threat_pos_y = threat_ghost.Get(KEY_GHOST_Y, null)
		//to_world_log("[src.pawn] believes there's a threat at ([threat_pos_x], [threat_pos_y])")

		if(! (isnull(threat_pos_x) || isnull(threat_pos_y)) )
			var/dx = (threat_pos_x - rel_source.x)
			var/dy = (threat_pos_y - rel_source.y)
			threat_angle = arctan(dx, dy)

			// long-term, it might be nicer to index by obj/str here
			threat_angles.Add(threat_angle)

	return threat_angles
*/


/datum/utility_ai/mob_commander/proc/Hit(var/angle, var/atom/shotby = null)
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

	var/atom/pawn = src.GetPawn()
	if(!pawn)
		return

	if(brain)
		var/list/shot_memory_data = list(
			KEY_GHOST_X = pawn.x,
			KEY_GHOST_Y = pawn.y,
			KEY_GHOST_Z = pawn.z,
			KEY_GHOST_POS_TUPLE = pawn.CurrentPositionAsTuple(),
			KEY_GHOST_ANGLE = impact_angle,
		)
		var/dict/shot_memory_ghost = new(shot_memory_data)

		brain.SetMemory(MEM_SHOTAT, shot_memory_ghost, src.ai_tick_delay*10)

		var/datum/brain/concrete/needybrain = brain
		if(needybrain)
			needybrain.AddMotive(NEED_COMPOSURE, -MAGICNUM_COMPOSURE_LOSS_ONHIT)

