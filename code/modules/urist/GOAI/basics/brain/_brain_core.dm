/* This is the minimal Brain datum interface.
//
// Think of this as a template for writing an actual Brain class.
// If you're looking for an implementation, look for `/datum/brain/concrete`
// in: ./concrete_brains/_concrete.dm
*/


/datum/brain
	var/name = "brain"
	var/life = 1

	/* Dict containing sensory data indexed by sense key. */
	var/dict/perceptions

	#ifndef GOAI_USE_GENERIC_DATUM_ATTACHMENTS_SYSTEM
	/* Dynamically attached junk */
	var/dict/attachments
	#endif


/datum/brain/proc/GetAiController()
	FetchAiControllerForObjIntoVar(src, var/datum/commander)
	return commander
