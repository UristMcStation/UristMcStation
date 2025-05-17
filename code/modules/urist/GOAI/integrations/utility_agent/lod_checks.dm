/*
// This file contains procs for 'pre-flight checks' for the AIs.
// These procs are dynamic-dispatch, call() procs, stored in a var.
//
// They can be used to tailor the checks to a specific application,
// e.g. mob commander AIs would check a mob is alive.
//
// Because this is dynamic, we don't need to burden non-mob AIs
// with mob-specific checks (and vice versa) or create some horrid
// god-check with branches for every possible case.
//
// Just attach an appropriate proc from this module and call it a day!
*/

/proc/goai_pawn_is_conscious(var/datum/utility_ai/goai)
	// Disables AI for mobs that are dead, IF they can die at all.
	if(!istype(goai))
		return GOAI_LOD_DONTRUN

	var/mob/living/pawn = goai.GetPawn()

	if(!istype(pawn))
		return GOAI_LOD_STANDARD

	var/is_conscious = (pawn.stat == CONSCIOUS)

	if(!is_conscious)
		return GOAI_LOD_DONTRUN

	return GOAI_LOD_STANDARD


/proc/goai_pawn_is_conscious_and_present(var/datum/utility_ai/goai)
	// like goai_pawn_is_conscious(), but throttles despawned squaddie mobs to Squad level LOD
	if(!istype(goai))
		return GOAI_LOD_DONTRUN

	var/mob/living/pawn = goai.GetPawn()

	if(!istype(pawn))
		return GOAI_LOD_DONTRUN

	var/is_conscious = (pawn.stat == CONSCIOUS)

	if(!is_conscious)
		return GOAI_LOD_DONTRUN

	var/in_nullspace = isnull(pawn.loc)

	if(in_nullspace)
		return GOAI_LOD_SQUAD

	return GOAI_LOD_STANDARD
