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
		COMBAT_AI_DEBUG_LOG("[src] attempted to get loc, but couldn't find one!")
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

/datum/utility_ai/mob_commander/proc/Shoot(var/obj/item/gun/cached_gun = null, var/atom/cached_target = null)
	. = FALSE

	var/atom/pawn = src.GetPawn()
	if(!pawn)
		COMBAT_AI_DEBUG_LOG("No mob not found for the [src.name] AI to shoot D;")
		return FALSE

	var/obj/item/gun/my_gun = cached_gun

	var/obj/item/gun/gun_pawn = pawn

	var/atom/target = (isnull(cached_target) ? GetTarget() : cached_target)

	var/mob/living/targetLM = target

	# ifdef GOAI_SS13_SUPPORT

	var/mob/living/carbon/human/H = pawn
	var/mob/living/simple_animal/SAH = pawn

	if(istype(SAH) && target && SAH.stat == CONSCIOUS && (targetLM?.stat != DEAD))
		// SimpleAnimals are simple (duh), *they* handle if they can shoot so we don't have to.
		//SAH.RangedAttack(target)
		SAH.ICheckRangedAttack(target) && SAH.IRangedAttack(target)
		return TRUE

	if(istype(H))
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
		COMBAT_AI_DEBUG_LOG("[src] - Gun not found for [pawn] to shoot D;")
		return FALSE

	if(!isnull(target) && (targetLM?.stat != DEAD))
		if(my_gun)
			my_gun.Fire(target, pawn)
			return TRUE

		else if(gun_pawn)
			gun_pawn.Fire(target, gun_pawn)
			return TRUE

		else
			COMBAT_AI_DEBUG_LOG("[src] - target [target] is null or no gun found!")

	return .


/datum/utility_ai/mob_commander/proc/Melee(var/atom/cached_target = null)
	. = FALSE

	var/atom/pawn = src.GetPawn()
	if(!pawn)
		COMBAT_AI_DEBUG_LOG("No mob not found for the [src.name] AI to attack with D;")
		return FALSE

	# ifndef GOAI_SS13_SUPPORT
	// Dev only faked implementation
	var/atom/target = (isnull(cached_target) ? GetTarget() : cached_target)
	if(isnull(target))
		return FALSE

	target.MeleeHitBy(pawn)
	var/atom/movable/movPawn = pawn
	if(istype(movPawn))
		movPawn.do_attack_animation(target)
	# endif

	# ifdef GOAI_SS13_SUPPORT
	// proper SS13 implementation
	var/atom/target = (isnull(cached_target) ? GetTarget() : cached_target)
	var/distance = ChebyshevDistance(pawn, target)
	var/mob/living/targetLM = target

	if(!isnull(target) && distance <= 1 && (targetLM?.stat != DEAD))
		var/mob/living/L = pawn

		if(istype(L) && L.stat == CONSCIOUS)
			var/attacked = L.IAttack(target)
			if(attacked == ATTACK_SUCCESSFUL)
				// Might have to be removed later - should likely be handled by the harm logic itself
				target.MeleeHitBy(L)
				. = TRUE
	# endif

	return .


/datum/utility_ai/mob_commander/proc/GetThreatDistance(var/atom/relative_to = null, var/atom/curr_threat = null, var/default = 0) // -> num
	var/atom/pawn = src.GetPawn()
	if(!pawn)
		return default

	if(isnull(curr_threat))
		return default

	var/atom/rel_source = isnull(relative_to) ? pawn : relative_to
	var/threat_dist = default

	var/threat_pos_x = curr_threat.x
	var/threat_pos_y = curr_threat.y

	if(! (isnull(threat_pos_x) || isnull(threat_pos_y)) )
		threat_dist = ManhattanDistanceNumeric(rel_source.x, rel_source.y, threat_pos_x, threat_pos_y)

	return threat_dist


/datum/utility_ai/mob_commander/proc/GetThreatChunk(var/atom/curr_threat) // -> turfchunk
	if(!istype(curr_threat))
		return

	var/atom/pawn = src.GetPawn()

	if(!istype(pawn))
		return

	var/threat_pos_x = curr_threat.x
	var/threat_pos_y = curr_threat.y

	var/datum/chunk/threat_chunk = null

	if(! (isnull(threat_pos_x) || isnull(threat_pos_y)) )
		var/datum/chunkserver/chunkserver = GetOrSetChunkserver()
		threat_chunk = chunkserver.ChunkForTile(threat_pos_x, threat_pos_y, pawn.z)

	return threat_chunk


/datum/utility_ai/mob_commander/proc/GetThreatAngle(var/atom/relative_to = null, var/atom/curr_threat = null, var/default = null)
	if(!istype(curr_threat))
		return

	var/atom/pawn = src.GetPawn()

	if(!istype(pawn))
		return

	var/atom/rel_source = isnull(relative_to) ? pawn : relative_to
	var/threat_angle = default

	var/threat_pos_x = curr_threat.x
	var/threat_pos_y = curr_threat.y

	if(! (isnull(threat_pos_x) || isnull(threat_pos_y)) )
		var/dx = (threat_pos_x - rel_source.x)
		var/dy = (threat_pos_y - rel_source.y)
		threat_angle = arctan(dx, dy)

	return threat_angle

/datum/utility_ai/proc/HarmedBy(var/atom/whomst, var/by_whom)
	// pure interface
	// what to do about being harmed by another entity
	// mob commanders will handle it as their pawn being hit,
	// squad/faction commanders - as one of their own being hurt
	// broadly - decrement morale and/or relations as needed

	if(isnull(by_whom))
		return

	var/datum/brain/utility/needybrain = src.brain
	if(istype(needybrain))
		var/steadfastness = needybrain.personality?[PERSONALITY_TRAIT_STEADFAST]
		if(isnull(steadfastness))
			steadfastness = 0

		// At DR=1 (== STEADFAST=0), we get full base composure loss
		// At DR=0 (== STEADFAST=1), we get no loss
		// At negative values (== STEADFAST>1), being hit actually makes the AI more comfy.
		// Theoretically, we could have psycho AIs that ENJOY being hit, so not limiting this.
		// Similarly, this is base rate, so negative STEADFAST means taking MORE morale hit per, uh, hit.
		var/composure_dr = 1 - steadfastness
		var/composure_loss = composure_dr * MAGICNUM_COMPOSURE_LOSS_ONHIT_BASE
		needybrain.AddMotive(NEED_COMPOSURE, -composure_loss)

	src.brain.SetMemory("mainthreat", by_whom, 100)
	return


/datum/utility_ai/proc/HitMelee(var/atom/whomst, var/hitby = null)
	// pure interface
	// mob commanders will handle it as their pawn being hit,
	// squad/faction commanders - as one of their own being hurt

	if(!isnull(hitby))
		// if there's a culprit, handle that
		src.HarmedBy(whomst, hitby)
	return


/datum/utility_ai/proc/HitRanged(var/atom/whomst, var/angle, var/shotby = null)
	// pure interface
	// mob commanders will handle it as their pawn being hit,
	// squad/faction commanders - as one of their own being hurt

	if(!isnull(shotby))
		// if there's a culprit, handle that
		src.HarmedBy(whomst, shotby)
	return


/datum/utility_ai/mob_commander/HitRanged(var/atom/whomst, var/angle, var/shotby = null)
	. = ..(whomst, angle, shotby)

	//var/impact_angle = IMPACT_ANGLE(angle)
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

	// Generally the hit thing is our Pawn here, or we wouldn't have gotten a ping
	var/atom/pawn = isnull(whomst) ? src.GetPawn() : whomst
	if(!pawn)
		return

	/*
	if(src.brain)
		// Store where we got shot from to investigate/avoid exposed cover
		var/list/shot_memory_data = list(
			KEY_GHOST_X = pawn.x,
			KEY_GHOST_Y = pawn.y,
			KEY_GHOST_Z = pawn.z,
			KEY_GHOST_POS_TUPLE = pawn.CurrentPositionAsTuple(),
			KEY_GHOST_ANGLE = impact_angle,
		)
		var/dict/shot_memory_ghost = new(shot_memory_data)

		src.brain.SetMemory(MEM_SHOTAT, shot_memory_ghost, src.ai_tick_delay*10)
	*/
