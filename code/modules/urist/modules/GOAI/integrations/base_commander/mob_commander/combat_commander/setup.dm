
/datum/goai/mob_commander/combat_commander/InitStates()
	states = ..()

	var/atom/movable/pawn = src.GetPawn()

	/* Controls autonomy; if FALSE, agent has specific overriding orders,
	// otherwise can 'smart idle' (i.e. wander about, but stil tacticool,
	// as opposed to just sitting in place).
	//
	// Can be used as a precondition to/signal of running more micromanaged behaviours.
	//
	// With Sim-style needs, TRUE can be also used to let the NPC take care
	// of any non-urgent motives; partying ANTAGs, why not?)
	*/
	states[STATE_DOWNTIME] = TRUE

	/* Simple item tracker. */
	states[STATE_HASGUN] = (pawn && locate(/obj/item/weapon/gun) in pawn.contents) ? 1 : 0

	/* Controls if the agent is *allowed & able* to engage using *anything*
	// Can be used to force 'hold fire' or simulate the hands being occupied
	// during special actions / while using items.
	*/
	states[STATE_CANFIRE] = 1

	states[STATE_PANIC] = FALSE
	states["BERSERK"] = FALSE

	/* A pseudo-need used to inject a step to movements
	*/
	states[STATE_DISORIENTED] = TRUE
	states["HasTakeCoverPath"] = FALSE
	states["HasPanicRunPath"] = FALSE
	states["HasChargePath"] = FALSE

	return states


/datum/goai/mob_commander/combat_commander/InitNeeds()
	needs = ..()
	/* COVER need encourages the AI to seek cover positions, duh
	// since we don't actually *set* that need to be satisfied (as of rn)
	// they will continuously try to get to cover.
	*/
	needs[NEED_COVER] = NEED_MINIMUM
	/* COMPOSURE serves a similar role as Morale in TW and other strategy games;
	// if it gets depleted, the NPC makes a run for their lives or whatever else
	// they think will save their bacon.
	//
	// Not called Morale because that's a less fine-grained concept - we'll model
	// it as a product of different states and needs, including COMPOSURE itself.
	*/
	needs[NEED_COMPOSURE] = NEED_SAFELEVEL
	//needs[NEED_ENEMIES] = 2
	return needs


/datum/goai/mob_commander/combat_commander/InitActionsList()
	/* TODO: add Time as a resource! */
	// Name, Req-ts, Effects, Handler, Priority, [Charges], [Is Instant], [Bound Args List], [Validator List], [Cost Updater]
	// Priority - higher is better; -INF would only be used if there's no other option.

	/*AddAction(
		"Idle",
		list("Idled" = FALSE),
		list("Idled" = TRUE),
		/datum/goai/mob_commander/combat_commander/proc/HandleIdling,
		-99999
	)*/

	AddAction(
		"Take Cover Pathfind",
		list(
			STATE_DOWNTIME = TRUE,
			STATE_PANIC = -TRUE,
			"HasTakeCoverPath" = -TRUE,
			"BERSERK" = -TRUE,
		),
		list(
			"HasTakeCoverPath" = TRUE,
		),
		/datum/goai/mob_commander/proc/HandleChooseDirectionalCoverLandmark,
		10,
		PLUS_INF,
		TRUE,
		null
	)

	AddAction(
		"Take Cover",
		list(
			STATE_DOWNTIME = TRUE,
			STATE_PANIC = -TRUE,
			"HasTakeCoverPath" = TRUE,
		),
		list(
			NEED_COVER = NEED_SATISFIED,
			STATE_INCOVER = TRUE,
			"HasTakeCoverPath" = FALSE,
		),
		/datum/goai/mob_commander/proc/HandleDirectionalCover,
		11,
		PLUS_INF,
		FALSE,
		null
	)

	AddAction(
		"CHARRRRRGE Pathfind",
		list(
			STATE_DOWNTIME = TRUE,
			STATE_PANIC = -TRUE,
			"HasChargePath" = -TRUE,
			"BERSERK" = TRUE,
		),
		list(
			"HasChargePath" = TRUE,
		),
		/datum/goai/mob_commander/proc/HandleChargeLandmark,
		10,
		PLUS_INF,
		TRUE
	)

	AddAction(
		"CHARRRRRGE",
		list(
			STATE_DOWNTIME = TRUE,
			STATE_PANIC = -TRUE,
			"BERSERK" = TRUE,
			"HasChargePath" = TRUE,
		),
		list(
			NEED_COVER = NEED_SATISFIED,
			STATE_INCOVER = TRUE,
			"HasChargePath" = FALSE,
		),
		/datum/goai/mob_commander/proc/HandleCharge,
		11
	)

	AddAction(
		"Plan Path",
		/* This is a bit convoluted: we need this step to insert new actions (Goto<Targ>/HandleObstacle<Obs>) at runtime.
		   We need to pretend this satisfies the Needs or the brain won't ever choose it.
		   The prereq on Oriented = FALSE means we won't re-do this unless we manually reset Oriented to FALSE,
		   which means the AI cannot just Plan Paths all days thinking it would make it happy - it's a one-off.
		   Now, we could use the Charges system, but that would likely be more painful (need to reinsert them back periodically).
		*/
		list(
			STATE_HASWAYPOINT = TRUE,
			STATE_PANIC = -TRUE,
			STATE_DISORIENTED = TRUE,
			"BERSERK" = -TRUE,
		),
		list(
			STATE_DISORIENTED = FALSE,
			NEED_COVER = NEED_SATISFIED,
			NEED_OBEDIENCE = NEED_SATISFIED,
			NEED_COMPOSURE = NEED_SATISFIED,
		),
		/datum/goai/mob_commander/proc/HandleWaypoint,
		100,
		PLUS_INF,
		TRUE,
		list("move_handler" = /datum/goai/mob_commander/proc/HandleDirectionalCoverLeapfrog),
	)

	AddAction(
		"Plan Path (Berserk)",
		/* This is a bit convoluted: we need this step to insert new actions (Goto<Targ>/HandleObstacle<Obs>) at runtime.
		   We need to pretend this satisfies the Needs or the brain won't ever choose it.
		   The prereq on Oriented = FALSE means we won't re-do this unless we manually reset Oriented to FALSE,
		   which means the AI cannot just Plan Paths all days thinking it would make it happy - it's a one-off.
		   Now, we could use the Charges system, but that would likely be more painful (need to reinsert them back periodically).
		*/
		list(
			STATE_HASWAYPOINT = TRUE,
			STATE_PANIC = -TRUE,
			STATE_DISORIENTED = TRUE,
			"BERSERK" = TRUE,
		),
		list(
			STATE_DISORIENTED = FALSE,
			NEED_COVER = NEED_SATISFIED,
			NEED_OBEDIENCE = NEED_SATISFIED,
			NEED_COMPOSURE = NEED_SATISFIED,
		),
		/datum/goai/mob_commander/proc/HandleWaypoint,
		100,
		PLUS_INF,
		TRUE,
		list("move_handler" = /datum/goai/mob_commander/proc/HandleCharge, "move_action_name" = "CHAERG")
	)

	return actionslist


/datum/goai/mob_commander/combat_commander/proc/Equip()
	. = ..()

	var/atom/pawn = src.GetPawn()
	if(pawn)
		new /obj/item/weapon/gun(pawn)

/datum/goai/mob_commander/combat_commander/InitRelations()
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


/datum/goai/mob_commander/combat_commander/PreSetupHook()
	. = ..()
	src.Equip()
	return


/datum/goai/mob_commander/combat_commander/CreateBrain(var/list/custom_actionslist = null, var/list/init_memories = null, var/list/init_action = null, var/datum/brain/with_hivemind = null, var/dict/custom_personality = null)
	var/list/new_actionslist = (custom_actionslist ? custom_actionslist : actionslist)
	var/dict/new_personality = (isnull(custom_personality) ? GeneratePersonality() : custom_personality)

	var/datum/brain/concrete/combatCommander/new_brain = new /datum/brain/concrete/combatCommander(new_actionslist, init_memories, src.initial_action, with_hivemind, new_personality, "brain of [src]")

	new_brain.needs = (isnull(src.needs) ? new_brain.needs : src.needs)
	new_brain.states = (isnull(src.states) ? new_brain.states : src.states)
	return new_brain
