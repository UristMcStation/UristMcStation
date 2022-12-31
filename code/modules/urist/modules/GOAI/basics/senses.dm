/* Contains basic definitions of the senses system.
//
// General design principles here:
//
// - Senses process some 'sensory' data on a tick-by-tick basis
// - Senses communicate with the AI by setting/updating Memories
// - Senses are invoked by the SenseSystem for scheduling, ECS-style
//   (SenseSystems reside in agent AI procs; not part of this spec)
*/

/sense
	// to keep typepaths compact...
	parent_type = /datum
	var/processing = FALSE


/sense/proc/ProcessTick(var/owner)
	// overall logic goes here;
	// gather some data & set memories.
	return


/sense/proc/GetOwnerAiTickrate(var/owner)
	/* convenience method; single-dispatch-ifies different owners to figure
	out what tick rate to use; uses a constant as a fallback option. */
	var/tickrate = AI_TICK_DELAY

	/*
	var/mob/goai/combatant/combatmob = owner

	if(combatmob)
		tickrate = combatmob.ai_tick_delay
		return tickrate
	*/

	var/datum/goai/goai_commander/commander = owner

	if(commander)
		tickrate = commander.ai_tick_delay
		return tickrate

	return tickrate


/*
/sense/proc/GetOwnerSenseTickrate(var/owner)
	/* convenience method; single-dispatch-ifies different owners to figure
	out what tick rate to use; uses a constant as a fallback option. */
	var/tickrate = AI_TICK_DELAY

	var/mob/goai/combatant/combatmob = owner
	if(combatmob)
		tickrate = combatmob.sense_tick_delay

	return tickrate
*/

