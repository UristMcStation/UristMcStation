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

	var/list/factionspec = null // assoc list
	var/spec_file = (filespec || src.factionspec_source)

	if(spec_file)
		// If the spec does not have the canonical SO location, assume it's a relative path in the factionspec dir.
		var/basepath_idx = findtext(spec_file, GOAI_FACTIONSPEC_PATH(""))

		var/abs_spec_path = spec_file
		if(!basepath_idx)
			abs_spec_path = GOAI_FACTIONSPEC_PATH(spec_file)

		READ_JSON_FILE_CACHED(abs_spec_path, factionspec)
		to_world_log("Read factionspec [abs_spec_path] for [src] ([json_encode(factionspec)])")

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

	var/list/faction_needs = null
	if(factionspec)
		faction_needs = factionspec["needs"]

	if(!isnull(faction_needs))
		src.brain.needs = faction_needs

	var/list/faction_need_weights = null
	if(factionspec)
		faction_need_weights = factionspec["need_weights"]

	if(!isnull(faction_need_weights))
		src.brain.need_weights = faction_need_weights

	var/list/faction_preferred_trades = null
	if(factionspec)
		faction_preferred_trades = factionspec["preferred_trades"]

	if(!isnull(faction_preferred_trades))
		src.brain?.preferred_trades = faction_preferred_trades

	var/list/actionspecs = null

	if(factionspec)
		var/list/raw_actionspecs = factionspec["actionset_files"]

		if(raw_actionspecs)
			actionspecs = list()

			for(var/raw_spec_path in raw_actionspecs)
				// If the spec does not have the canonical SO location, assume it's a relative path in the SO dir.
				var/basepath_idx = findtext(raw_spec_path, GOAI_SMARTOBJECT_PATH(""))
				var/abs_spec_path = ((basepath_idx != 1) ? GOAI_SMARTOBJECT_PATH(raw_spec_path) : raw_spec_path)
				actionspecs.Add(abs_spec_path)

	var/datum/faction_data/new_faction = new(faction_name, faction_rels, faction_tags, actionspecs)

	// Note: the pawn may be a weakref, so
	// if for whatever reason the faction gets de-registered from a global list,
	// this would result in the pawn getting nulled out.
	src.pawn = REFERENCE_PAWN(new_faction)
	to_world_log("The pawn for Faction AI [src] is [src.pawn] ([faction_name])")

	// Initial Assets (things this faction 'owns')
	// Note this needs to happen AFTER the main datum init.
	if(factionspec)
		var/list/new_assets = factionspec["assets"]

		if(new_assets)
			// Create assets DB if not yet initialized
			ASSETS_TABLE_LAZY_INIT(TRUE)
			var/faction_id = GET_GLOBAL_ID_LAZY(new_faction)
			CREATE_ASSETS_TRACKER_IF_NEEDED(faction_id)
			UPDATE_ASSETS_TRACKER(faction_id, new_assets)

		// start the production system if needed
		INITIALIZE_PRODUCTION_SYSTEM_INLINE_IF_NEEDED_AT_DEFAULT_RATE
		INITIALIZE_ASSETNEEDS_SYSTEM_INLINE_IF_NEEDED_AT_DEFAULT_RATE

	return src
