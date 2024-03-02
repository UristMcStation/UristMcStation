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
	name = "utility AI commander"

	ai_tick_delay = FACTION_AI_TICK_DELAY
	senses_tick_delay = FACTION_AI_TICK_DELAY

	#ifdef UTILITY_SMARTOBJECT_SENSES
	// Semicolon-separated string (to imitate the PATH envvar);
	// Will be split and parsed to a list at runtime.#
	// We're doing it this weird way to avoid dealing with list defaults
	var/sense_filepaths = DEFAULT_FACTION_AI_SENSES
	#endif


/datum/utility_ai/faction_commander/Life()
	. = ..()

	#ifdef UTILITY_SMARTOBJECT_SENSES
	// Perception updates
	spawn(0)
		while(src.life)
			src.SensesSystem()
			sleep(src.senses_tick_delay)
	#endif

	// AI
	spawn(0)
		while(src.life)
			var/cleaned_up = src.CheckForCleanup()
			if(cleaned_up)
				return

			// Run the Life update function.
			src.LifeTick()

			// Fix the tickrate to prevent runaway loops in case something messes with it.
			// Doing it here is nice, because it saves us from sanitizing it all over the place.
			src.ai_tick_delay = max((src?.ai_tick_delay || 0), 1)

			// Wait until the next update tick.
			sleep(src.ai_tick_delay)



/datum/utility_ai/faction_commander/LifeTick()
	if(paused)
		return

	if(brain)
		brain.LifeTick()

		for(var/datum/ActionTracker/instant_action_tracker in brain.pending_instant_actions)
			var/tracked_instant_action = instant_action_tracker?.tracked_action
			if(tracked_instant_action)
				src.HandleInstantAction(tracked_instant_action, instant_action_tracker)

		PUT_EMPTY_LIST_IN(brain.pending_instant_actions)

		if(brain.running_action_tracker)
			var/tracked_action = brain.running_action_tracker.tracked_action

			if(tracked_action)
				src.HandleAction(tracked_action, brain.running_action_tracker)

	return


/datum/utility_ai/faction_commander/InitRelations()
	// NOTE: this is a near-override, practically speaking!

	if(!(src.brain))
		return

	var/datum/relationships/relations = ..()

	if(isnull(relations) || !istype(relations))
		relations = new()

	src.brain.relations = relations
	return relations
