/* This is the minimal Brain datum interface.
//
// Think of this as a template for writing an actual Brain class.
// If you're looking for an implementation, look for `/datum/brain/concrete`
// in: ./concrete_brains/_concrete.dm
*/


/datum/brain
	var/name = "brain"
	var/life = 1

	/* Optional 'parent' brain ref.
	//
	// Can be used to simulate literal hiveminds, but also
	// various lower-granularity planners, e.g. squads or
	// organisations or a mob's 'strategic' planner that
	// informs the 'tactical'/'operational' planners' goals.
	//
	// IMPORTANT: this hierarchy should form a (Directed) Acyclic Graph!
	*/
	var/datum/brain/hivemind

	/* Dict containing sensory data indexed by sense key. */
	var/dict/perceptions

	#ifndef GOAI_USE_GENERIC_DATUM_ATTACHMENTS_SYSTEM
	/* Dynamically attached junk */
	var/dict/attachments
	#endif


/datum/brain/proc/GetAiController()
	FetchAiControllerForObjIntoVar(src, var/datum/commander)
	return commander
