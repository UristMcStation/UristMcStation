/*
//                            FACTION AI
//
// This is an AI subclass specialized to handle abstract NPC factions.
//
// Unlike classic mob AI, factions operate 'abstractly' on mostly pure data and decisions.
//
// That is, we rarely need to worry about atoms and mobs, unless they are somehow 'owned'
// by this or another faction AI.
//
// Instead, factions worry about purely numerical resource- and relationship-management.
//
// Some of this may be implemented by spawning a hit squad of mobs or reflected by spawning
// a crate of shinies somewhere in the gameworld, but that's the output, not the input.
*/

/datum/utility_ai/faction_commander
	name = "unknown faction"

	base_ai_tick_delay = FACTION_AI_TICK_DELAY
	ai_tick_delay = FACTION_AI_TICK_DELAY
	senses_tick_delay = FACTION_AI_TICK_DELAY

	var/factionspec_source = null // path to JSON


/datum/utility_ai/faction_commander/InitPawn()
	. = ..()
	src.InitializeFactionData()
	return


/datum/utility_ai/faction_commander/PostSetupHook()
	. = ..()
	// Register ourselves as a faction AI.
	src.RegisterFaction()
	return


/datum/utility_ai/faction_commander/proc/InitializeFactionData(var/filespec = null)
	/*
	// Might be needed; currently disabled to allow for clean reinits.
	if(!isnull(src.faction))
		return
	*/

	var/spec_file = (filespec || src.factionspec_source)

	var/list/factionspec = null // assoc list
	if(src.factionspec_source)
		factionspec = READ_JSON_FILE(spec_file)

	var/faction_name = null
	if(factionspec)
		faction_name = factionspec["name"]

	if(isnull(faction_name))
		faction_name = src.name

	var/list/faction_tags = null
	if(factionspec)
		faction_tags = factionspec["tags"]

	var/list/faction_rels = null
	if(factionspec)
		faction_rels = factionspec["relationships"]

	var/datum/faction_data/new_faction = new(faction_name, faction_rels, faction_tags)

	// Note: the pawn may be a weakref, so
	// if for whatever reason the faction gets de-registered from a global list,
	// this would result in the pawn getting nulled out.
	src.pawn = REFERENCE_PAWN(new_faction)

	return src
