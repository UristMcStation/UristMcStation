/datum/goai/mob_commander/proc/HandlePry(var/datum/ActionTracker/tracker, var/obj/target)
	log_debug("Pry task for [target]")
	if(src.brain.GetMemoryValue(MEM_OBSTRUCTION, null) == target)
		src.brain.DropMemory(MEM_OBSTRUCTION)
	tracker.SetDone()
	return
	//TODO

/datum/goai/mob_commander/proc/HandleScrew(var/datum/ActionTracker/tracker, var/obj/target)
	log_debug("Screw task for [target]")
	tracker.SetDone()
	return
	//TODO

/datum/goai/mob_commander/proc/HandleGenericBreak(var/datum/ActionTracker/tracker, var/obj/target, var/method)
	log_debug("Break task for [target]")
	var/mob/pawn = src.GetPawn()
	if(!pawn || !istype(pawn))
		return

	if(!tracker)
		return

	if(tracker.IsOlderThan(src.ai_tick_delay * 10))
		tracker.SetFailed()
		if(src.brain.GetMemoryValue(MEM_OBSTRUCTION, null) == target)	//This should really be its own proc...
			src.brain.DropMemory(MEM_OBSTRUCTION)
		return

	var/obj/machinery/M = target

	if(isnull(target) || (istype(M) && (M.stat & BROKEN)))
		if(!isnull(target))
			if(src.brain.GetMemoryValue(MEM_OBSTRUCTION, null) == target)
				src.brain.DropMemory(MEM_OBSTRUCTION)
		tracker.SetDone()
		return

	//Cooldown check
	var/last_action = tracker.BBGet("LastAttack", null)
	if(last_action && (world.time < last_action + DEFAULT_ATTACK_COOLDOWN))
		return

	//See what's in the mob's hands
	var/obj/item/AH = pawn.get_active_hand()
	var/obj/item/IH = pawn.get_inactive_hand()
	var/obj/item/W = null

	//Select whatever actually is a weapon, and attack with that
	if(AH && !istool(AH) && !(AH.item_flags & ITEM_FLAG_NO_BLUDGEON))
		W = AH
	else if(IH && !istool(IH) && !(IH.item_flags & ITEM_FLAG_NO_BLUDGEON))
		W = IH
	else
		tracker.SetFailed()
		if(src.brain.GetMemoryValue(MEM_OBSTRUCTION, null) == target)
			src.brain.DropMemory(MEM_OBSTRUCTION)

	target.attackby(W, pawn)
	tracker.BBSet("LastAttack", world.time)