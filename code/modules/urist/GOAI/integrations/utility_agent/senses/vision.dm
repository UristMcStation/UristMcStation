
/sense/combatant_commander_eyes
	// Only run if units are simulated properly and not abstracted
	min_lod = GOAI_LOD_UNIT_LOW

	// default is the same as for world.view
	var/viewrange = 6

	// max length of stored enemies
	var/max_enemies = DEFAULT_MAX_ENEMIES

	// max distance to count enemies
	var/enemy_dist_cutoff = 12

	// do raycasts from the enemies to us and sets a flag if enabled (nonzero)
	// negative values are treated as infinity, positive as limit of enemies checked
	var/check_threatened_max = DEFAULT_MAX_ENEMIES

	// max length of stored friends
	var/max_friends = DEFAULT_MAX_ENEMIES

	// max distance to count friendlies
	var/friend_dist_cutoff = 6

	// filter out dead mobs
	var/ignore_dead = TRUE

	var/sense_side_delay_mult = 5

	// Assoc list, MemKey => MemKey.
	// For things like tracking moving objects
	var/list/update_pos_into_memory = list(
		MEM_WAYPOINT_IDENTITY = MEM_AI_TARGET,
	)

	// Assoc list, MemKey => MemKey.
	// Similar, but for tracking last-known-positions.
	// Runs on TARGETS of update_pos_into_memory (i.e. RHS of the mapping)!
	// It's also a 'symmetric' mapping - if LKP fuzzing is enabled, the RHS will populate the LHS memory key.
	var/list/update_lkp_into_memory = list(
		MEM_AI_TARGET = MEM_WAYPOINT_LKP,
	)

	var/raytrace_to_target_enabled = TRUE
	var/raytrace_maxdist_limit = null

	// =====      Trackercheat      =====
	// This is a (provisional) name for an optional module that cheats in a bit of clairvoyance.
	// If enabled (value > 0), will give the AI perfect location to the update_pos_into_memory items
	//     with a given probability in 0-100 percent (independently per each assoc item).
	// This should be used sparingly, because it makes the AI superhuman in a potentially cheap-feeling way.
	// A sane use-case example is using this for friendly mobs that should follow the players.
	var/trackercheat_perc = 0

	// =====       Last Known Position (LKP) tracking      =====
	// Activates only if the target has NOT been handled by other means and so we lost them.
	// In this case, we instead update the update_pos_into_memory values to a random offset from LKP
	// to emulate searching around for the target.
	// This relies on the actual perceptions of the AI, so is much fairer than the Trackercheat.
	// The amount of randomness in LKP offsets - 0 means no randomness (disables the system), 1 means +/- 1 tile, etc.
	var/lkp_randoffset_scale = 3

	// Minimum (Chebyshev) distance from LKP.
	var/lkp_min_offset = 1


/sense/combatant_commander_eyes/proc/UpdatePerceptions(var/datum/utility_ai/mob_commander/owner)
	var/datum/brain/owner_brain = owner.brain

	if(isnull(owner_brain))
		// No point processing this if there's no memories to set
		return

	var/atom/pawn = owner.GetPawn()

	if(!istype(pawn))
		// We grab the view range from the owned mob, so we need it here
		return

	var/list/_raw_visual_range = view(src.viewrange, pawn)
	var/list/visual_range = list()

	for(var/atom/viewthing in _raw_visual_range)
		if(!(CHECK_ALL_FLAGS(viewthing.goai_processing_visibility, GOAI_VISTYPE_STANDARD)))
			//GOAI_LOG_DEBUG("Skipping [viewthing] from sight - goai_processing_visibility is [viewthing.goai_processing_visibility] vs [GOAI_VISTYPE_STANDARD] required.")
			continue

		visual_range.Add(viewthing)

	if(visual_range)
		owner_brain.perceptions[SENSE_SIGHT_CURR] = visual_range

	if(src.update_pos_into_memory)
		var/_lkp_randoffset_scale = DEFAULT_IF_NULL(src.lkp_randoffset_scale, 0)
		var/_lkp_min_offset = DEFAULT_IF_NULL(src.lkp_min_offset, 0)

		for(var/src_memkey in src.update_pos_into_memory)
			var/trg_memkey = src.update_pos_into_memory[src_memkey]

			if(isnull(trg_memkey))
				continue

			var/lkp_memkey_for_trg = src.update_lkp_into_memory[trg_memkey]
			var/has_lkp_memkey = (!isnull(lkp_memkey_for_trg)) // helper/cache var, as we use this result a bunch

			var/src_memval = owner_brain.GetMemoryValue(src_memkey)

			if(isnull(src_memval))
				continue

			if(src_memval in visual_range)
				var/turf/target_loc = get_turf(src_memval)
				owner_brain.SetMemory(trg_memkey, target_loc, owner.ai_tick_delay * MEM_AITICK_MULT_SHORTTERM)

				if(has_lkp_memkey)
					ADD_GOAI_TEMP_GIZMO_SAFEINIT(target_loc, "blueE")
					var/list/lkp_data = TO_GOAI_WAYPOINT_DATA(target_loc)
					owner_brain.SetMemory(lkp_memkey_for_trg, lkp_data, owner.ai_tick_delay * MEM_AITICK_MULT_MIDTERM)

				continue

			if(src.raytrace_to_target_enabled)
				// If we have a straight LOS to target, then we can treat them as visible.
				// Perhaps deceptively, a single raytrace is cheaper than widening the view() range.
				// We still need view() for things in proximity (pickups etc.) anyway though.
				var/_raytrace_maxdist_limit = DEFAULT_IF_NULL(src.raytrace_maxdist_limit, world.view)
				var/ray_maxdist = min(_raytrace_maxdist_limit, get_dist(pawn, src_memval))
				var/atom/rayhit = TurfDensityRaytrace(pawn, src_memval, null, RAYTYPE_LOS, null, TRUE, ray_maxdist)
				var/turf/target_loc = get_turf(src_memval)

				if(istype(rayhit) && get_dist(rayhit, target_loc) <= 1)
					ADD_GOAI_TEMP_GIZMO_SAFEINIT(get_turf(rayhit), "greyX")
					owner_brain.SetMemory(trg_memkey, target_loc, owner.ai_tick_delay * MEM_AITICK_MULT_SHORTTERM)

					if(has_lkp_memkey)
						ADD_GOAI_TEMP_GIZMO_SAFEINIT(target_loc, "greenE")
						var/list/lkp_data = TO_GOAI_WAYPOINT_DATA(target_loc)
						owner_brain.SetMemory(lkp_memkey_for_trg, lkp_data, owner.ai_tick_delay * MEM_AITICK_MULT_MIDTERM)

					continue

			if(src.trackercheat_perc)
				var/roll_val = rand() * 100

				if(roll_val < src.trackercheat_perc)
					var/turf/target_loc = get_turf(src_memval)
					owner_brain.SetMemory(trg_memkey, target_loc, owner.ai_tick_delay * MEM_AITICK_MULT_SHORTTERM)

					if(has_lkp_memkey)
						var/list/lkp_data = TO_GOAI_WAYPOINT_DATA(target_loc)
						owner_brain.SetMemory(lkp_memkey_for_trg, lkp_data, owner.ai_tick_delay * MEM_AITICK_MULT_MIDTERM)

					continue

			if(has_lkp_memkey && _lkp_randoffset_scale >= 0)
				var/existing_memory = owner_brain.GetMemoryValue(trg_memkey)
				if(!isnull(existing_memory))
					// do not overwrite if we have a better source
					continue

				var/list/lkp = owner_brain.GetMemoryValue(lkp_memkey_for_trg)

				if(istype(lkp))
					var/lkp_xpos = lkp[KEY_GHOST_X]
					if(isnull(lkp_xpos)) continue

					var/lkp_ypos = lkp[KEY_GHOST_Y]
					if(isnull(lkp_ypos)) continue

					var/lkp_zpos = lkp[KEY_GHOST_Z]
					if(isnull(lkp_zpos)) continue

					var/x_offset = (prob(50) ? -1 : 1) * (_lkp_min_offset + rand(0, _lkp_randoffset_scale))
					var/y_offset = (prob(50) ? -1 : 1) * (_lkp_min_offset + rand(0, _lkp_randoffset_scale))

					var/new_xpos = clamp(lkp_xpos + x_offset, 1, world.maxx)
					var/new_ypos = clamp(lkp_ypos + y_offset, 1, world.maxy)

					var/turf/searchloc = locate(new_xpos, new_ypos, lkp_zpos)
					if(istype(searchloc))
						// If we got here, we do not have a better memory for a target position
						owner_brain.SetMemory(trg_memkey, searchloc, owner.ai_tick_delay * MEM_AITICK_MULT_MIDTERM)
						ADD_GOAI_TEMP_GIZMO(searchloc, "greyE")

	/*
	// Disabled because it takes a lot of memory for not a lot of obvious benefit
	var/list/old_visual_range = owner_brain?.perceptions?[SENSE_SIGHT_CURR]
	if(old_visual_range)
		owner_brain?.perceptions[SENSE_SIGHT_PREV] = old_visual_range

	owner_brain?.perceptions[SENSE_SIGHT_CURR] = (visual_range || list()) | (old_visual_range || list())
	*/

	return


/sense/combatant_commander_eyes/proc/AssessThreats(var/datum/utility_ai/mob_commander/owner)
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

	if(!istype(pawn))
		return

	var/my_loc = pawn.loc

	if(isnull(my_loc))
		return

	var/PriorityQueue/target_queue = new DEFAULT_PRIORITY_QUEUE_IMPL(/datum/Tuple/proc/FirstCompare)

	var/list/occupied_turfs = list()

	var/list/friends = list()
	var/list/friend_positions = list()

	var/list/enemies = list()
	var/list/enemy_positions = list()

	// TODO: Refactor to accept objects/structures as threats (turrets, grenades...).
	for(var/mob/enemy in true_searchspace)
		if(!(istype(enemy, /mob/living/carbon) || istype(enemy, /mob/living/simple_animal) || istype(enemy, /mob/living/bot)))
			continue

		var/mob/living/L = enemy
		if(ignore_dead && istype(L) && L.stat == DEAD)
			continue

		var/turf/enemyTurf = get_turf(enemy)
		if(!isnull(enemyTurf) && !(enemyTurf in occupied_turfs))
			occupied_turfs.Add(enemyTurf)

		var/enemy_dist = ManhattanDistance(my_loc, enemy)

		if (enemy_dist <= 0 || enemy_dist > src.enemy_dist_cutoff)
			continue

		if(owner.IsFriend(enemy))
			if(length(friends) < src.max_friends && enemy_dist < friend_dist_cutoff)
				friends.Add(enemy)
				var/turf/friend_pos = get_turf(enemy)
				if(!isnull(friend_pos))
					friend_positions.Add(friend_pos)

			continue

		var/datum/Tuple/enemy_tup = new(enemy_dist, enemy)
		target_queue.Enqueue(enemy_tup)

	owner_brain.SetMemory(MEM_OCCUPIED_TURFS, occupied_turfs, owner.ai_tick_delay * MEM_AITICK_MULT_SHORTTERM)

	var/tries = 0
	var/maxtries = 3
	var/atom/target = null

	while (isnull(target) && target_queue.L.len && tries < maxtries)
		var/datum/Tuple/best_target_tup = target_queue.Dequeue()
		target = best_target_tup.right
		tries++

		if(istype(target) && length(enemies) < src.max_enemies)
			enemies.Add(target)
			var/turf/trgTurf = get_turf(target)
			if(istype(trgTurf))
				enemy_positions.Add(trgTurf)

	if(istype(target))
		var/turf/threat_pos = get_turf(target)
		if(istype(threat_pos))
			owner_brain.SetMemory(MEM_THREAT, threat_pos, owner.ai_tick_delay * MEM_AITICK_MULT_SHORTTERM)

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

		if(istype(target) && length(enemies) < src.max_enemies)
			enemies.Add(target)
			var/turf/trgTurf = get_turf(target)
			if(istype(trgTurf))
				enemy_positions.Add(trgTurf)

	if(istype(secondary_threat))
		var/turf/secondary_threat_pos = get_turf(target)
		if(istype(secondary_threat_pos))
			owner_brain.SetMemory(MEM_THREAT_SECONDARY, secondary_threat_pos, owner.ai_tick_delay * MEM_AITICK_MULT_SHORTTERM)

	while(length(target_queue.L) && length(enemies) < src.max_enemies)
		var/datum/Tuple/next_enemy_tuple = target_queue.Dequeue()
		var/atom/nme = next_enemy_tuple.right
		if(istype(nme))
			enemies.Add(nme)
			var/turf/nmeT = get_turf(nme)
			if(istype(nmeT))
				enemy_positions.Add(nmeT)

	// Just the currently visible mobs
	// Short-term - otherwise AI will be clairvoyant
	owner_brain.SetMemory(MEM_FRIENDS, friends, owner.ai_tick_delay * MEM_AITICK_MULT_SHORTTERM)
	owner_brain.SetMemory(MEM_ENEMIES, enemies, owner.ai_tick_delay * MEM_AITICK_MULT_SHORTTERM)

	var/midterm_enemies = owner_brain.GetMemoryValue("EnemiesMidterm")
	if(!midterm_enemies)
		owner_brain.SetMemory("EnemiesMidterm", enemies, owner.ai_tick_delay * MEM_AITICK_MULT_MIDTERM)

	if(length(friend_positions))
		owner_brain.SetMemory(MEM_FRIENDS_POSITIONS, friend_positions, owner.ai_tick_delay * MEM_AITICK_MULT_SHORTTERM)

	if(length(enemy_positions))
		// Copy the previous latest
		var/list/current_stored_enemy_positions = owner_brain.GetMemoryValue(MEM_ENEMIES_POSITIONS_LATEST) || list()

		// Update with new
		owner_brain.SetMemory(MEM_ENEMIES_POSITIONS_LATEST, enemy_positions.Copy(), owner.ai_tick_delay * MEM_AITICK_MULT_SHORTTERM)

		// shift previous tick's positions to another slot
		if(length(current_stored_enemy_positions))
			owner_brain.SetMemory(MEM_ENEMIES_POSITIONS_RETAINED, current_stored_enemy_positions, owner.ai_tick_delay * MEM_AITICK_MULT_MIDTERM)

			// merge in previous for a separate memory of both ticks
			enemy_positions.Add(current_stored_enemy_positions)

		// Store the two lists merged
		owner_brain.SetMemory(MEM_ENEMIES_POSITIONS, enemy_positions, owner.ai_tick_delay * MEM_AITICK_MULT_MIDTERM)

	var/threats_checked = 0

	if(src.check_threatened_max)
		var/list/ignorelist = enemies.Copy()

		for(var/atom/raytrace_enemy in enemies)
			if(src.check_threatened_max > 0 && threats_checked++ >= src.check_threatened_max)
				break

			var/atom/whosehit = AtomDensityRaytrace(raytrace_enemy, pawn, ignorelist, RAYTYPE_PROJECTILE, FALSE)
			if(isnull(whosehit))
				continue

			if(whosehit == pawn)
				owner_brain.SetMemory(MEM_POS_THREATENED, TRUE, owner.ai_tick_delay * MEM_AITICK_MULT_SHORTTERM)
				break


	return TRUE


/sense/combatant_commander_eyes/ProcessTick(var/owner)
	..(owner)

	if(processing)
		return

	processing = TRUE

	UpdatePerceptions(owner)
	AssessThreats(owner)

	spawn(src.GetOwnerAiTickrate(owner) * src.sense_side_delay_mult)
		// Sense-side delay to avoid spamming view() scans too much
		processing = FALSE
	return
