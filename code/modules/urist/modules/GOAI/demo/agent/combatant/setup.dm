
/mob/goai/combatant/InitStates()
	states = ..()

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
	states[STATE_HASGUN] = (locate(/obj/gun) in src.contents) ? 1 : 0

	/* Controls if the agent is *allowed & able* to engage using *anything*
	// Can be used to force 'hold fire' or simulate the hands being occupied
	// during special actions / while using items.
	*/
	states[STATE_CANFIRE] = 1

	states[STATE_PANIC] = FALSE

	/* A pseudo-need used to inject a step to movements
	*/
	states[STATE_DISORIENTED] = TRUE
	states["HasTakeCoverPath"] = FALSE
	states["HasPanicRunPath"] = FALSE

	return states


/mob/goai/combatant/InitNeeds()
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


/mob/goai/combatant/InitActionsList()
	/* TODO: add Time as a resource! */
	// Name, Req-ts, Effects, Priority, [Charges]
	// Priority - higher is better; -INF would only be used if there's no other option.

	/*AddAction(
		"Idle",
		list("Idled" = FALSE),
		list("Idled" = TRUE),
		/mob/goai/combatant/proc/HandleIdling,
		-99999
	)*/

	AddAction(
		"Take Cover Pathfind",
		list(
			STATE_DOWNTIME = TRUE,
			STATE_PANIC = -TRUE,
			"HasTakeCoverPath" = -TRUE,
		),
		list(
			"HasTakeCoverPath" = TRUE,
		),
		/mob/goai/combatant/proc/HandleChooseDirectionalCoverLandmark,
		10,
		PLUS_INF,
		TRUE
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
		/mob/goai/combatant/proc/HandleDirectionalCover,
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
			STATE_DISORIENTED = TRUE,
			STATE_PANIC = -TRUE,
		),
		list(
			STATE_DISORIENTED = FALSE,
			NEED_COVER = NEED_SATISFIED,
			NEED_OBEDIENCE = NEED_SATISFIED,
			NEED_COMPOSURE = NEED_SATISFIED,
		),
		/mob/goai/combatant/proc/HandleWaypoint,
		100,
		PLUS_INF,
		TRUE
	)

	return actionslist


/mob/goai/combatant/Equip()
	. = ..()
	GimmeGun()
	return


/mob/goai/combatant/CreateBrain(var/list/custom_actionslist = null, var/list/init_memories = null, var/list/init_action = null, var/datum/brain/with_hivemind = null, var/dict/custom_personality = null)
	var/list/new_actionslist = (custom_actionslist ? custom_actionslist : actionslist)
	var/dict/new_personality = (isnull(custom_personality) ? GeneratePersonality() : custom_personality)

	var/datum/brain/concrete/combat/new_brain = new /datum/brain/concrete/combat(new_actionslist, init_memories, src.initial_action, with_hivemind, new_personality, "brain of [src]")

	new_brain.needs = (isnull(src.needs) ? new_brain.needs : src.needs)
	new_brain.states = (isnull(src.states) ? new_brain.states : src.states)
	return new_brain
