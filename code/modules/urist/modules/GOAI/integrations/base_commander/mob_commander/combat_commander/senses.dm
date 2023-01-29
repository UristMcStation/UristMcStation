// SAFESPACE FINDER
/sense/combatant_commander_safespace_finder
	/* Sense component. Runs periodically and updates the mob's safe spaces.
	//
	// This can be used to help agents run away from threats back to prior
	// locations beyond their *current* visual range.
	*/


/sense/combatant_commander_safespace_finder/proc/UpdateSafespace(var/datum/goai/mob_commander/combat_commander/owner)
	if(!owner)
		// useless in a vacuum
		return

	var/atom/pawn = owner.GetPawn()
	if(!pawn)
		return

	if(!(owner.brain))
		// whole point is to set a memory, so no-go
		return

	var/turf/safespace = get_turf(src)
	if(safespace)
		owner.brain.SetMemory(MEM_SAFESPACE, safespace, src.GetOwnerAiTickrate(owner) * 100)

	return


/sense/combatant_commander_safespace_finder/ProcessTick(var/owner)
	..(owner)

	if(processing)
		return

	processing = TRUE

	UpdateSafespace(owner)

	spawn(src.GetOwnerAiTickrate(owner) * 40)
		// Sense-side delay to avoid spamming view() scans too much
		processing = FALSE
	return


/datum/goai/mob_commander/combat_commander/InitSenses()
	/* Parent stuff */
	. = ..()

	/* Initialize sense objects: */
	var/sense/combatant_commander_eyes/eyes = new()
	//var/sense/combatant_commander_panic_pathfinder/panicpath_handler = new()
	//var/sense/combatant_commander_safespace_finder/safety_finder = new()
	var/sense/combatant_commander_coverleap_wayfinder/coverleap_wayfinder = new()

	/* Register each Sense: */
	senses.Add(eyes)
	//senses.Add(panicpath_handler)
	//senses.Add(safety_finder)
	senses.Add(coverleap_wayfinder)

	if(isnull(src.senses_index))
		src.senses_index = list()

	src.senses_index["ClWayfinder"] = coverleap_wayfinder

	return
