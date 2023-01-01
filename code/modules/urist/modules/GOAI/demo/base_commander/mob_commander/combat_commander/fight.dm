/datum/goai/mob_commander/combat_commander/proc/FightTick()
	var/atom/pawn = src.GetPawn()
	if(!pawn)
		to_world_log("[src] does not have an owned mob!")
		return

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
		var/list/curr_view = brain?.perceptions?.Get(SENSE_SIGHT)

		if(target in curr_view)
			var/distance = ChebyshevDistance(pawn, target)

			if(distance > 1)
				//to_world_log("[src] - (pawn [pawn]) running Shoot!")
				src.Shoot(null, target)

			else
				src.Melee(target)

	return

