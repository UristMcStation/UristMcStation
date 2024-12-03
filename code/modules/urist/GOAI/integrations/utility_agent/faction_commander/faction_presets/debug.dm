/*
// For testing AI only
*/

/datum/utility_ai/faction_commander/debug
	name = "Debug Faction"

	factionspec_source = GOAI_FACTIONSPEC_PATH("debug_faction.json")

	/*innate_actions_filepaths = list(
		GOAI_SMARTOBJECT_PATH("faction_base.json"),
	)*/


/datum/utility_ai/faction_commander/spawner
	name = "Spawned Faction"

	factionspec_source = GOAI_FACTIONSPEC_PATH("debug_faction.json")

	// Spawners can customize factionspec_source at runtime, so we need to
	// defer src.InitPawn(), customize the instance, then call it ourselves.
	initialize_pawn = FALSE

