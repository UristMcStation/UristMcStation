/*
// This module provides the integration that lets a Unit Brain have an assigned Squad.
// Not to be confused with the concept of a *Squad Brain*, which goes the other way
// (lets a Squad have its own Brain instance that can be looked up by Units *in addition*
// to their own individual Brains, hivemind-style)
 */

/datum/brain
	// Ref (array index) to the Squads registry
	// This is effectively a weakref that is nicer to work with
	var/squad_idx = null


/datum/brain/proc/GetSquad(var/squad_id = null) // Maybe[int (squad id)] -> Maybe[/datum/squad]
	// Given a valid squad ID (squad_idx attribute by default, but overridable), returns a proper Squad object.
	// This is kind of like weakref.resolve() but specialized so we don't need to do a locate() in the whole world.
	var/target_squad_idx = DEFAULT_IF_NULL(squad_id, src.squad_idx)

	if(isnull(target_squad_idx))
		return null

	if(!(GLOBAL_ARRAY_LOOKUP_BOUNDS_CHECK(target_squad_idx, global_squad_registry)))
		return null

	var/datum/squad/found_squad = (GOAI_LIBBED_GLOB_ATTR(global_squad_registry))[target_squad_idx]
	return found_squad


/datum/brain/proc/SetSquad(var/datum/squad/new_squad = null) // /datum/squad -> int (squad id)
	// Dual of GetSquad - given a Squad object, sets an ID reference to it as the brain's assigned squad.
	if(isnull(new_squad))
		return null

	if(!(GOAI_LIBBED_GLOB_ATTR(global_squad_registry)))
		GOAI_LIBBED_GLOB_ATTR(global_squad_registry) = list()

	var/squad_id = new_squad.registry_index

	if(isnull(squad_id))
		squad_id = new_squad.RegisterSquad()

	src.squad_idx = squad_id
	return src.squad_idx
