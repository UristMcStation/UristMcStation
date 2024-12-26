/*
// This module lets a Squad have its own associated Brain data.
// This is optional, even if the module is included.
//
// This feature can be used either directly or, if the Hivemind Brains feature is available,
// the Squad brain can be wired up as a hivemind for each squaddie's private Brain.
//
// Broadly speaking the latter is preferable from a fidelity point of view, otherwise
// there is a risk of squaddie Pawns becoming a bit too omniscient.
//
// Not to be confused with the brain_squad.dm module, though they are complementary.
//
// That module extends Unit Brains to have associated Squads (with or without a Brain).
// *THIS* module extends Squads to have a Squad Brain (whether or not it has Units in it).
*/

/datum/squad
	var/datum/brain/squad_brain = null


/datum/squad/proc/SetBrain(var/datum/brain/new_brain, var/fluent_api = TRUE)
	if(!istype(new_brain))
		return

	src.squad_brain = new_brain

	// If fluent_api is requested, return src so we can chain proc-calls nicely
	//   e.g. squad?.SetBrain(somebrain)?.DoStuff()
	return (fluent_api ? src : src.squad_brain)
