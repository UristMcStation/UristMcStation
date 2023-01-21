/datum/goai/mob_commander/combat_commander/proc/FightTick()
	var/atom/pawn = src.GetPawn()
	if(!pawn)
		ACTION_RUNTIME_DEBUG_LOG("[src] does not have an owned mob!")
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
		var/distance = ChebyshevDistance(pawn, target)

		if(distance > 1)
			var/forecasted_impactee = AtomDensityRaytrace(pawn, target, list(pawn))

			if(forecasted_impactee == target)
				src.Shoot(null, target)

		else
			src.Melee(target)

	return

