/*
// A Faction is a fairly obvious instance of an Abstract Commander.
//
// Generally speaking, it's probably a bad idea to use these for 'tactical' AI
// (i.e. directly ordering pawns around); this is intended to be a fairly lazy
// system with a high-level, abstract view of the world that decides on strategic
// goals and whose actions are nudging tactical AIs towards achieving them however
// they see fit.
//
// An important distinction between this an Director AIs is that Faction AIs are
// almost always going to be concerned with *relationships* to other Factions.
*/

/datum/goai/goai_commander/faction_ai
	var/datum/faction_data/owned_faction


/datum/goai/goai_commander/faction_ai/proc/BuildFactionData()
	// Initialize faction data...
	var/datum/faction_data/myfaction = new()
	// potentially do some var-editing here
	return myfaction


/datum/goai/goai_commander/faction_ai/PreSetupHook()
	. = ..()
	// do not overwrite faction data if somehow set already
	src.owned_faction = (src.owned_faction || src.BuildFactionData())
	return

