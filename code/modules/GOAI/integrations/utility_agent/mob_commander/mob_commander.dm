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

	// Tracking our pawn:
	# ifdef GOAI_LIBRARY_FEATURES
	var/atom/pawn
	# endif

	# ifdef GOAI_SS13_SUPPORT
	var/weakref/pawn_ref
	# endif

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


/datum/utility_ai/mob_commander/proc/GetPawn()
	var/atom/movable/mypawn = null

	# ifdef GOAI_LIBRARY_FEATURES
	mypawn = (mypawn || src.pawn)
	# endif

	# ifdef GOAI_SS13_SUPPORT
	mypawn = (mypawn || (pawn_ref?.resolve()))
	# endif

	return mypawn


/datum/utility_ai/mob_commander/Life()
	. = ..()

	#ifdef UTILITY_SMARTOBJECT_SENSES
	// Perception updates
	spawn(0)
		while(src.life)
			src.SensesSystem()
			sleep(src.senses_tick_delay)
	#endif


	// Movement updates
	spawn(0)
		while(src.life)
			src.MovementSystem()
			sleep(src.move_tick_delay)


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

	/*
	// Combat system; decoupled from generic planning/actions to make it run
	// *in parallel* to other behaviours - e.g. run-and-gun or fire from cover
	spawn(0)
		while(src.life)
			var/atom/movable/mypawn = src.GetPawn()
			if(mypawn)
				src.FightTick()

			sleep(COMBATAI_FIGHT_TICK_DELAY)
	*/


/datum/utility_ai/mob_commander/LifeTick()
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


/datum/utility_ai/mob_commander/InitRelations()
	// NOTE: this is a near-override, practically speaking!

	if(!(src.brain))
		return

	var/atom/movable/pawn = src.GetPawn()

	var/datum/relationships/relations = ..()

	if(isnull(relations) || !istype(relations))
		relations = new()

	// Same faction should not be attacked by default, same as vanilla
	var/mob/living/L = pawn
	if(L && istype(L))
		var/my_faction = L.faction

		if(my_faction)
			var/datum/relation_data/my_faction_rel = new(5, 1) // slightly positive
			relations.Insert(my_faction, my_faction_rel)

	# ifdef GOAI_SS13_SUPPORT

	// For hostile SAs, consider hidden faction too
	var/mob/living/simple_animal/hostile/SAH = pawn
	if(SAH && istype(SAH))
		var/my_hiddenfaction = SAH.hiddenfaction?.factionid

		if(my_hiddenfaction)
			// NOTE: This means that Hostiles will have *very slightly* higher threshold
			//       for getting mad at other Hostiles in the same faction & hiddenfaction.
			//       as opposed to the ones in the same faction but DIFFERENT hiddenfaction.

			var/datum/relation_data/my_hiddenfaction_rel = new(1, 1) // minimally positive
			relations.Insert(my_hiddenfaction, my_hiddenfaction_rel)

	# endif

	src.brain.relations = relations
	return relations
