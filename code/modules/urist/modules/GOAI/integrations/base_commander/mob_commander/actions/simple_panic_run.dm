
/datum/goai/mob_commander/proc/HandlePanickedRunSimple(var/datum/ActionTracker/tracker, var/turf/best_local_pos = null, var/sense_callback = FALSE, var/sense_throttle_time_ds = 10)
	var/atom/pawn = src.GetPawn()
	if(!pawn)
		ACTION_RUNTIME_DEBUG_LOG("[src] does not have an owned mob!")
		return

	var/tracker_frustration = tracker?.BBSetDefault("frustration", 0)

	var/turf/_best_local_pos = best_local_pos

	if(isnull(_best_local_pos))
		ACTION_RUNTIME_DEBUG_LOG("[src] does not have a target position for PanicRun!")
		return

	var/min_safe_dist = (brain?.GetPersonalityTrait(KEY_PERS_MINSAFEDIST) || 2)
	var/frustration_repath_maxthresh = brain.GetPersonalityTrait(KEY_PERS_FRUSTRATION_THRESH, null) || 3

	var/list/threats = new()

	// Main threat:
	var/dict/primary_threat_ghost = GetActiveThreatDict()
	var/datum/Tuple/primary_threat_pos_tuple = GetThreatPosTuple(primary_threat_ghost)
	var/atom/primary_threat = null
	if(!(isnull(primary_threat_pos_tuple?.left) || isnull(primary_threat_pos_tuple?.right)))
		primary_threat = locate(primary_threat_pos_tuple.left, primary_threat_pos_tuple.right, pawn.z)

	if(primary_threat_ghost)
		threats[primary_threat_ghost] = primary_threat

	// Secondary threat:
	var/dict/secondary_threat_ghost = GetActiveSecondaryThreatDict()
	var/datum/Tuple/secondary_threat_pos_tuple = GetThreatPosTuple(secondary_threat_ghost)
	var/atom/secondary_threat = null
	if(!(isnull(secondary_threat_pos_tuple?.left) || isnull(secondary_threat_pos_tuple?.right)))
		secondary_threat = locate(secondary_threat_pos_tuple.left, secondary_threat_pos_tuple.right, pawn.z)

	if(secondary_threat_ghost)
		threats[secondary_threat_ghost] = secondary_threat

	// Required for the following logic: next location on the path
	var/atom/next_step = ((src.active_path && src.active_path.path && src.active_path.path.len) ? src.active_path.path[1] : null)

	// Bookkeeping around threats
	for(var/dict/threat_ghost in threats)
		if(isnull(threat_ghost))
			continue

		var/atom/curr_threat = threats[threat_ghost]
		var/next_step_threat_distance = (next_step ? GetThreatDistance(next_step, threat_ghost, PLUS_INF) : PLUS_INF)
		var/curr_threat_distance = GetThreatDistance(pawn, threat_ghost, PLUS_INF)
		var/bestpos_threat_distance = GetThreatDistance(_best_local_pos, threat_ghost, PLUS_INF)

		var/atom/bestpos_threat_neighbor = (curr_threat ? get_step_towards(_best_local_pos, curr_threat) : null)

		// Reevaluating plans as new threats pop up
		var/bestpos_is_unsafe = (bestpos_threat_distance < min_safe_dist && !(bestpos_threat_neighbor?.IsCover(TRUE, get_dir(bestpos_threat_neighbor, curr_threat), FALSE)))
		var/currpos_is_unsafe = (
			(tracker_frustration < frustration_repath_maxthresh) && (curr_threat_distance <= min_safe_dist) && (next_step_threat_distance < curr_threat_distance)
		)

		if(bestpos_is_unsafe || currpos_is_unsafe)
			CancelNavigate()
			tracker.SetFailed()

	if(_best_local_pos && (!src.active_path || src.active_path.target != _best_local_pos))
		// CORE MOVEMENT TRIGGER - FOUND POSITION, START PATHING TO IT
		ACTION_RUNTIME_DEBUG_LOG("[src]: Navigating to [_best_local_pos]")
		var/turf/threat_turf = get_turf(primary_threat)
		var/new_path = StartNavigateTo(_best_local_pos, 0, threat_turf, 0, /datum/goai/mob_commander/proc/fPanicRunDistance)

		if(!new_path)
			src.WalkPawnAwayFrom(threat_turf)

	if(_best_local_pos)
		var/dist_to_pos = ManhattanDistance(get_turf(pawn), _best_local_pos)
		if(dist_to_pos < 1)
			tracker.SetTriggered()

	var/is_triggered = tracker.IsTriggered()
	var/datum/brain/concrete/needybrain = brain

	if(is_triggered)
		if(tracker.TriggeredMoreThan(src.ai_tick_delay))
			tracker.SetDone()

			if(needybrain)
				needybrain.ChangeMotive(NEED_COMPOSURE, NEED_SAFELEVEL)


	else if(src.active_path && tracker.IsOlderThan(COMBATAI_MOVE_TICK_DELAY * 20))
		tracker.SetFailed()


	else if(tracker.IsOlderThan(COMBATAI_MOVE_TICK_DELAY * 10))
		tracker.SetFailed()

	return
