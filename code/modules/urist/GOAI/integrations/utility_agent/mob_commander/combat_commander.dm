/*
// This subclass adds some combat logic, but might be deprecated in favor of something more modular as opposed to silly OOPness
// It's effectively a preset for regular mob_commander to be used for combatant-type mobs
*/

/datum/utility_ai/mob_commander/combat_commander


/datum/utility_ai/mob_commander/combat_commander/InitSenses()
	/* Parent stuff */
	. = ..()

	if(isnull(src.senses))
		src.senses = list()

	if(isnull(src.senses_index))
		src.senses_index = list()

	// Basic init done; actual senses go below:
	// NOTE: ORDER MATTERS!!!
	//       Senses are processed in the order of insertion!
	//
	//       If two Senses have a dependency relationship and you put the dependent
	//       before the dependee, there will be a 1-tick lag in the dependent Sense!
	//       Now, this *might* be desirable for some things, but keep it in mind.


	var/sense/combatant_commander_eyes/eyes = new()
	//var/sense/combatant_commander_utility_wayfinder/wayfinder = new()
	var/sense/combatant_commander_utility_wayfinder_smartobjectey/wayfinder = new()

	/* Register each Sense: */
	src.senses.Add(eyes)
	src.senses.Add(wayfinder)

	/* Register lookup by key for quick access (optional) */
	src.senses_index[SENSE_SIGHT] = eyes
	src.senses_index["sense_wayfinder"] = wayfinder

	return src.senses
