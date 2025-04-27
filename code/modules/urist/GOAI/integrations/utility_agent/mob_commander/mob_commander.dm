/*
//                        MOB COMMANDER AI
//
// This is an AI subclass specialized to handle a specific game entity (a Pawn).
//
// This is probably the most 'classic' game AI type and what a layperson would think
// of when they hear about a game having an AI - a single autonomous NPC.
//
// This stands in contrast to more abstract AIs, such as squad, faction or event AIs,
// which can also direct NPCs (or other AIs for that matter).
*/

/datum/utility_ai/mob_commander
	name = "utility AI commander"

	// We only ever attach to an existing pawn
	initialize_pawn = FALSE

	// sensible default, override if needed
	dynamic_lod_check = /proc/goai_pawn_is_conscious_and_present

	// Moving stuff:
	var/datum/ActivePathTracker/active_path
	var/is_repathing = 0
	var/is_moving = 0

	// How slow stuff is getting moved (higher is slower):
	var/move_tick_delay = COMBATAI_MOVE_TICK_DELAY

	// Senses, if applicable:
	#ifdef UTILITY_SMARTOBJECT_SENSES
	// Semicolon-separated string (to imitate the PATH envvar);
	// Will be split and parsed to a list at runtime.
	// We're doing it this weird way to avoid dealing with list defaults
	var/sense_filepaths = DEFAULT_UTILITY_AI_SENSES
	#endif


/datum/utility_ai/mob_commander/RegisterLifeSystems()
	// Adds any number of subsystems.
	// Subclasses should ..() this.
	// Each subsystem should be spawn(0)'d off to fork/background them.

	..()

	// Movement updates
	spawn(0)
		while(src.life)
			src.MovementSystem()
			sleep(src.move_tick_delay)

	return


/datum/utility_ai/mob_commander/InitRelations()
	// NOTE: this is a near-override, practically speaking!

	if(!(src.brain))
		return

	var/atom/movable/pawn = src.GetPawn()

	if(isnull(GOAI_LIBBED_GLOB_ATTR(relationships_db)))
		InitRelationshipsDb()

	var/datum/relationships/relations = ..()

	if(isnull(relations) || !istype(relations))
		relations = new()

	// Same faction should not be attacked by default, same as vanilla
	var/mob/L = pawn
	if(istype(L))
		var/my_faction = L.faction

		if(my_faction)
			var/list/our_db_values = (GOAI_LIBBED_GLOB_ATTR(relationships_db))?[my_faction]
			for(var/faction_key in our_db_values)
				var/db_value = our_db_values[faction_key]
				var/new_relation_val = DEFAULT_IF_NULL(db_value, RELATIONS_DEFAULT_SELF_FACTION_RELATION_VAL) // slightly positive
				var/datum/relation_data/my_faction_rel = new(new_relation_val, RELATIONS_DEFAULT_SELF_FACTION_RELATION_WEIGHT)
				relations.Insert(faction_key, my_faction_rel)

	# ifdef GOAI_SS13_SUPPORT

	// For hostile SAs, consider hidden faction too
	var/mob/living/simple_animal/hostile/SAH = pawn
	if(SAH && istype(SAH))
		var/my_hiddenfaction = SAH.hiddenfaction?.factionid

		if(my_hiddenfaction)
			// NOTE: This means that Hostiles will have *very slightly* higher threshold
			//       for getting mad at other Hostiles in the same faction & hiddenfaction.
			//       as opposed to the ones in the same faction but DIFFERENT hiddenfaction.
			var/db_value = (GOAI_LIBBED_GLOB_ATTR(relationships_db))?[my_hiddenfaction]
			var/new_relation_val = DEFAULT_IF_NULL(db_value, RELATIONS_DEFAULT_SELF_HIDDENFACTION_RELATION_VAL) // slightly positive

			var/datum/relation_data/my_hiddenfaction_rel = new(new_relation_val, RELATIONS_DEFAULT_SELF_HIDDENFACTION_RELATION_WEIGHT) // minimally positive
			relations.Insert(my_hiddenfaction, my_hiddenfaction_rel)

	# endif

	src.brain.relations = relations
	return relations


/datum/utility_ai/mob_commander/InitSenses()
	/* Parent stuff */
	. = ..()

	if(isnull(src.senses))
		src.senses = list()

	if(isnull(src.senses_index))
		src.senses_index = list()

	// Basic init done; actual senses go below:
	// NOTE: ORDER MATTERS!!!
	//       Senses are processed in the order of insertion!
	//
	//       If two Senses have a dependency relationship and you put the dependent
	//       before the dependee, there will be a 1-tick lag in the dependent Sense!
	//       Now, this *might* be desirable for some things, but keep it in mind.

	// The logic below is similar, but we need to loop over filepaths.

	var/sense/combatant_commander_eyes/eyes = new()
	var/sense/combatant_commander_utility_wayfinder_smartobjectey/wayfinder = new()

	/* Register each Sense: */
	src.senses.Add(eyes)
	src.senses.Add(wayfinder)

	/* Register lookup by key for quick access (optional) */
	src.senses_index[SENSE_SIGHT] = eyes
	src.senses_index["sense_wayfinder"] = wayfinder

	if(src.sense_filepaths)
		// Initialize SmartObject senses from files

		var/list/filepaths = splittext(src.sense_filepaths, ";")
		ASSERT(!isnull(filepaths))

		for(var/fp in filepaths)
			if(!fexists(fp))
				GOAI_LOG_ERROR("ERROR: Sense filepath [fp] does not exist - skipping!")
				continue

			var/sense/utility_smartobject_fetcher/new_fetcher = UtilitySmartobjectFetcherFromJsonFile(fp)

			if(isnull(new_fetcher))
				continue

			ASSERT(!isnull(new_fetcher.sense_idx_key))

			src.senses.Add(new_fetcher)
			src.senses_index[new_fetcher.sense_idx_key] = new_fetcher

	return src.senses


/datum/utility_ai/mob_commander/UpdateBrain()
	. = ..()
	src.brain.needs[NEED_COMPOSURE] = NEED_SAFELEVEL

