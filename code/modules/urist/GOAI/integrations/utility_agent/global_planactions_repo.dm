
var/global/list/global_plan_actions_repo = null


/proc/InitializeGlobalPlanActionsRepo()
	var/list/actions_repo = list()

	GOAI_GLOBAL_LIST_PREFIX(global_plan_actions_repo) = actions_repo
	RegisterGlobalPlanActionsFromJson(GOAPPLAN_METADATA_PATH)

	return GOAI_GLOBAL_LIST_PREFIX(global_plan_actions_repo)


/proc/RegisterGlobalPlanAction(var/key, var/raw_handler_proc, var/handler_proc, var/list/preconditions, var/list/effects, var/target_key, var/loc_key, var/handler_is_func = FALSE, var/feature_move_to = FALSE, var/description = null, var/list/context_args = null, var/context_fetcher_override = null)
	var/list/action_data = list()

	action_data[JSON_KEY_PLANACTION_RAW_HANDLERPROC] = raw_handler_proc
	action_data[JSON_KEY_PLANACTION_HANDLERPROC] = handler_proc
	action_data[JSON_KEY_PLANACTION_PRECONDITIONS] = preconditions
	action_data[JSON_KEY_PLANACTION_EFFECTS] = effects
	action_data[JSON_KEY_PLANACTION_TARGET_KEY] = target_key
	action_data[JSON_KEY_PLANACTION_HANDLER_LOCARG] = loc_key
	action_data[JSON_KEY_PLANACTION_HANDLER_ISFUNC] = handler_is_func
	action_data[JSON_KEY_PLANACTION_HASMOVEMENT] = (isnull(feature_move_to) ? FALSE : feature_move_to)
	action_data[JSON_KEY_PLANACTION_DESCRIPTION] = description
	action_data[JSON_KEY_PLANACTION_CTXARGS] = context_args
	action_data[JSON_KEY_PLANACTION_CTXFETCHER_OVERRIDE] = context_fetcher_override

	GOAI_GLOBAL_LIST_PREFIX(global_plan_actions_repo)[key] = action_data
	return TRUE


/proc/PlanActionFromJson(var/list/json_data, var/key = null)
	if(isnull(key))
		key = json_data[JSON_KEY_PLANACTION_ACTIONKEY]

	var/raw_handler_proc = json_data[JSON_KEY_PLANACTION_HANDLERPROC]
	var/handler_proc = STR_TO_PROC(raw_handler_proc)
	var/preconditions = json_data[JSON_KEY_PLANACTION_PRECONDITIONS]
	var/effects = json_data[JSON_KEY_PLANACTION_EFFECTS]
	var/target_key = json_data[JSON_KEY_PLANACTION_TARGET_KEY]
	var/loc_key = json_data[JSON_KEY_PLANACTION_HANDLER_LOCARG]
	var/handler_is_func = json_data[JSON_KEY_PLANACTION_HANDLER_ISFUNC]
	var/feature_move_to = json_data[JSON_KEY_PLANACTION_HASMOVEMENT]
	var/description = json_data[JSON_KEY_PLANACTION_DESCRIPTION]
	var/list/context_args = json_data[JSON_KEY_PLANACTION_CTXARGS]
	var/context_fetcher_override = json_data[JSON_KEY_PLANACTION_CTXFETCHER_OVERRIDE]

	. = RegisterGlobalPlanAction(
		key=key,
		raw_handler_proc=raw_handler_proc,
		handler_proc=handler_proc,
		preconditions=preconditions,
		effects=effects,
		target_key=target_key,
		loc_key=loc_key,
		handler_is_func=handler_is_func,
		feature_move_to=feature_move_to,
		description=description,
		context_args=context_args,
		context_fetcher_override=context_fetcher_override
	)
	return


/proc/RegisterGlobalPlanActionsFromJson(var/json_file)
	var/list/json_data
	READ_JSON_FILE_CACHED(json_file, json_data)
	ASSERT(json_data)

	for(var/action_key in json_data)
		var/action_data = json_data[action_key]
		PlanActionFromJson(action_data, action_key)

	return
