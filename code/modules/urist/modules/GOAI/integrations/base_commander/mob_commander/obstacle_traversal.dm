
/datum/goai/mob_commander/proc/HandleWaypointObstruction(var/atom/obstruction, var/atom/waypoint, var/list/shared_preconds = null, var/list/target_preconds = null, var/list/base_target_effects = null, var/move_action_name = "MoveTowards", var/move_handler = null, var/unique = TRUE, var/allow_failed = TRUE, var/list/base_obshandle_effects = null)
	/* Removed - null move_handlers are used to disable adding a movement after handling the obstacle rn
	if(!waypoint || !move_action_name || !move_handler)
		to_world_log("HandleWaypointObstruction failed - no handler! FOUND: <[move_handler]>")
		return FALSE*/

	if(!waypoint)
		to_world_log("HandleWaypointObstruction failed! <[obstruction], [waypoint], [move_action_name]>")
		return FALSE

	var/handled = isnull(obstruction)

	var/list/common_preconds = (isnull(shared_preconds) ? list() : shared_preconds)
	var/list/goto_preconds = (isnull(target_preconds) ? list() : target_preconds)

	var/list/obs_handled_common_effects = (isnull(base_obshandle_effects) ? list() : base_obshandle_effects.Copy())

	var/obj/cover/door/D = obstruction
	var/obj/cover/autodoor/AD = obstruction

	# ifdef GOAI_SS13_SUPPORT
	var/obj/machinery/door/airlock/A = obstruction
	var/obj/machinery/door/window/WD = obstruction
	# endif

	var/action_key = null

	var/atom/pawn = src.GetPawn()

	if(pawn && (obstruction == pawn))
		// Embarassing case...
		handled = TRUE

	else if(D && istype(D) && !(D.open))
		if(D.open)
			handled = TRUE
		else
			var/obs_need_key = NEED_OBSTACLE_OPEN(obstruction)
			action_key = "Open [obstruction] for [waypoint]"

			var/list/open_door_preconds = common_preconds.Copy()
			open_door_preconds[obs_need_key] = FALSE
			open_door_preconds["UsedUpAction [action_key]"] = FALSE

			var/list/open_door_effects = obs_handled_common_effects.Copy()
			open_door_effects["UsedUpAction [action_key]"] = TRUE
			open_door_effects[obs_need_key] = TRUE

			var/list/action_args = list()
			action_args["obstruction"] = D

			AddAction(
				name = action_key,
				preconds = open_door_preconds,
				effects = open_door_effects,
				handler = /datum/goai/mob_commander/proc/HandleOpenDoor,
				cost = (20 + (pawn ? get_dist(D, pawn) : 0)),
				charges = 1,
				instant = FALSE,
				action_args = action_args
			)

			goto_preconds[obs_need_key] = TRUE
			handled = TRUE


	else if(AD && istype(AD))
		if(AD.open)
			handled = TRUE
		else
			var/obs_need_key = NEED_OBSTACLE_OPEN(obstruction)
			action_key = "Open [obstruction] for [waypoint]"

			/* TRIGGER WARNING: DM being cancer.
			//
			// Would be cool to use variable assoc list keys, right?
			// WRONG. This A) does NOT work & B) *fails silently*.
			// So, instead we construct an empty list and enter keys
			// one by one, because this approach DOES work. Consistency!
			*/
			var/list/open_autodoor_preconds = common_preconds.Copy()
			open_autodoor_preconds[obs_need_key] = FALSE
			open_autodoor_preconds["UsedUpAction [action_key]"] = FALSE

			var/list/open_autodoor_effects = obs_handled_common_effects.Copy()
			open_autodoor_effects["UsedUpAction [action_key]"] = TRUE
			open_autodoor_effects[obs_need_key] = TRUE

			var/list/action_args = list()
			action_args["obstruction"] = AD

			AddAction(
				action_key,
				open_autodoor_preconds,
				open_autodoor_effects,
				/datum/goai/mob_commander/proc/HandleOpenAutodoor,
				20 + (pawn ? get_dist(AD, pawn) : 0),
				1,
				FALSE,
				action_args
			)

			goto_preconds[obs_need_key] = TRUE
			handled = TRUE

		//SS13
	# ifdef GOAI_SS13_SUPPORT

	//AIRLOCKS
	else if(A && istype(A))
		action_key = src.HandleAirlockObstruction(A, common_preconds, waypoint, pawn, obs_handled_common_effects)
		if(action_key)
			goto_preconds[action_key] = TRUE
			handled = TRUE

	//WINDOORS
	else if(WD && istype(WD))
		action_key = src.HandleWindoorObstruction(WD, common_preconds, waypoint, pawn)
		if(action_key)
			goto_preconds[action_key] = TRUE
			handled = TRUE

	# endif

	if(move_handler && (handled || allow_failed))
		var/action_name = "[move_action_name]"
		if(unique)
			/* Non-Unique (Generic) Actions are fungible, so (ironically)
			// we only have one of each, e.g. OpenDoor<>.
			//
			// Unique actions are identified by their name AND params,
			// e.g. OpenDoor<doorA>, so we can have as many
			// as we have different param combinations.
			//
			// == DESIGN NOTE: ==
			// Keep in mind that unique != parametrized.
			// We can easily add Generic Actions that take parameters
			// from another system, e.g. Brain's Memory system.
			//
			// The difference is that Unique actions can have preconds and effects
			// that are SPECIFIC to their param, e.g. Go<3> may require At<2>,
			// while a Generic Move<> would have to pick any valid move from the
			// current location non-specifically, e.g. Move<>@3 could go to 2 or 4.
			//
			// Dynamically added Unique actions can stuff up memory quickly,
			// so use them only where absolutely necessary.
			*/
			action_name = "[action_name] [waypoint] - [obstruction] @ [ref(obstruction)]"

		//to_world("Adding new move action '[action_name]'")
		goto_preconds["UsedUpAction [action_name]"] = FALSE

		var/list/goto_effects = (isnull(base_target_effects) ? list() : base_target_effects)

		goto_effects[NEED_COVER] = NEED_SATISFIED
		goto_effects[NEED_OBEDIENCE] = NEED_SATISFIED
		goto_effects[NEED_COMPOSURE] = NEED_SATISFIED
		goto_effects[STATE_INCOVER] = TRUE
		goto_effects[STATE_DISORIENTED] = TRUE
		goto_effects["UsedUpAction [action_name]"] = TRUE

		AddAction(
			name = action_name,
			preconds = goto_preconds,
			effects = goto_effects,
			handler = move_handler,
			cost = 4,
			charges = (unique ? 1 : PLUS_INF),
		)

	return handled
