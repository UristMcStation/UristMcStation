/*
// Constructors for assorted Utility AI classes from serialization formats (JSON, mainly)
// We can use these to make the AI design data-driven, with the code just providing the plumbing.
*/

//# define DEBUG_SERDE_LOADS 1


// Unfortunately DM is suffering, so these have to be 'plain' procs and not classmethods.


/proc/UtilityConsiderationFromData(var/list/json_data) // list -> ActionTemplate
	ASSERT(json_data)

	var/raw_inp_proc = json_data[JSON_KEY_CONSIDERATION_INPPROC]
	var/raw_curve_proc = json_data[JSON_KEY_CONSIDERATION_CURVEPROC]
	var/bookmark_low = json_data[JSON_KEY_CONSIDERATION_LOMARK]
	var/bookmark_high = json_data[JSON_KEY_CONSIDERATION_HIMARK]
	var/noise_scale = json_data[JSON_KEY_CONSIDERATION_NOISESCALE]
	var/name = json_data[JSON_KEY_CONSIDERATION_NAME]
	var/description = json_data[JSON_KEY_CONSIDERATION_DESC]
	var/active = json_data[JSON_KEY_CONSIDERATION_ACTIVE]
	var/list/consideration_args = json_data[JSON_KEY_CONSIDERATION_ARGS]

	// Yeah, I know, for data-driven stuff you just gotta bite your tongue and take it
	var/inp_proc = STR_TO_PROC(raw_inp_proc)
	var/curve_proc = STR_TO_PROC(raw_curve_proc)

	var/datum/consideration/new_consideration = new(
		input_val_proc=inp_proc,
		curve_proc=curve_proc,
		loMark=bookmark_low,
		hiMark=bookmark_high,
		noiseScale=noise_scale,
		id=null,
		name=name,
		description=description,
		active=active,
		consideration_args=consideration_args
	)

	return new_consideration


/proc/UtilityConsiderationArrayFromData(var/list/json_data) // list -> ActionTemplate
	ASSERT(json_data)

	var/list/considerations = list()

	# ifdef DEBUG_SERDE_LOADS
	var/idx = 0
	# endif

	for(var/list/consideration_json_data in json_data)
		# ifdef DEBUG_SERDE_LOADS
		idx++
		# endif

		var/datum/consideration/new_consideration = UtilityConsiderationFromData(consideration_json_data)

		if(isnull(new_consideration))
			# ifdef DEBUG_SERDE_LOADS
			UTILITYBRAIN_DEBUG_LOG("Failed to load Consideration at idx [idx]")
			# endif
			continue

		# ifdef DEBUG_SERDE_LOADS
		UTILITYBRAIN_DEBUG_LOG("   ")
		UTILITYBRAIN_DEBUG_LOG("Loaded new Consideration: ")
		for(var/varkey in new_consideration.vars)
			UTILITYBRAIN_DEBUG_LOG("o [varkey] => [new_consideration.vars[varkey]]")
		# endif

		considerations.Add(new_consideration)

	return considerations


/proc/ActionTemplateFromData(var/list/json_data) // list -> ActionTemplate
	ASSERT(json_data)

	var/list/considerations_data = json_data[JSON_KEY_CONSIDERATIONS]

	var/list/raw_ctxprocs = json_data[JSON_KEY_ACT_CTXPROC] || list()
	var/list/true_ctxprocs = list()

	for(var/ctxproc_path in raw_ctxprocs)
		var/resolved_context_proc = STR_TO_PROC(ctxproc_path)
		true_ctxprocs.Add(resolved_context_proc)

	var/context_args = json_data[JSON_KEY_ACT_CTXARGS]

	var/raw_handler = json_data[JSON_KEY_ACT_HANDLER]
	var/handler = STR_TO_PROC(raw_handler)

	var/handlertype = json_data[JSON_KEY_ACT_HANDLERTYPE]

	var/list/hard_args = json_data[JSON_KEY_ACT_HARDARGS]

	var/priority = json_data[JSON_KEY_ACT_PRIORITY]
	var/charges = json_data[JSON_KEY_ACT_CHARGES]
	var/instant = json_data[JSON_KEY_ACT_ISINSTANT]
	var/act_name = json_data[JSON_KEY_ACT_NAME]
	var/act_description = json_data[JSON_KEY_ACT_DESCRIPTION]
	var/active = json_data[JSON_KEY_ACT_ACTIVE]
	// GOAP stuff
	var/list/preconds = json_data[JSON_KEY_ACT_PRECONDS]
	var/list/effects = json_data[JSON_KEY_ACT_EFFECTS]

	var/list/considerations = UtilityConsiderationArrayFromData(considerations_data)

	var/datum/utility_action_template/new_action_template = new(
		considerations,
		handler,
		handlertype,
		true_ctxprocs,
		context_args,
		priority,
		charges,
		instant,
		hard_args,
		act_name,
		act_description,
		active,
		// GOAP stuff
		preconds,
		effects
	)

	# ifdef DEBUG_SERDE_LOADS
	if(new_action_template)
		UTILITYBRAIN_DEBUG_LOG("Loaded new ActionTemplate: ")
		for(var/varkey in new_action_template.vars)
			UTILITYBRAIN_DEBUG_LOG("o [varkey] => [new_action_template.vars[varkey]]")
	# endif

	return new_action_template


/proc/ActionTemplateFromJsonFile(var/json_filepath) // str -> ActionTemplate
	ASSERT(json_filepath)

	var/list/json_data = null; READ_JSON_FILE_CACHED(json_filepath, json_data)
	ASSERT(json_data)

	var/datum/utility_action_template/new_template = ActionTemplateFromData(json_data)
	return new_template



/proc/ActionSetFromData(var/list/json_data) // list -> ActionTemplate
	ASSERT(json_data)

	var/name = json_data[JSON_KEY_ACTSET_NAME]
	var/active = json_data[JSON_KEY_ACTSET_ACTIVE]
	var/list/action_data = json_data[JSON_KEY_ACTSET_ACTIONS]

	var/ttl_remove = json_data[JSON_KEY_ACTSET_TTL_REMOVE]
	var/ttl_deactivate = json_data[JSON_KEY_ACTSET_TTL_DEACTIVATE]
	var/time_retrieved = json_data[JSON_KEY_ACTSET_TIME_RETRIEVED] || world.time

	var/raw_freshness_proc = json_data[JSON_KEY_ACTSET_FRESHNESS_PROC]
	var/true_freshness_proc = STR_TO_PROC(raw_freshness_proc)

	var/list/freshness_proc_args = json_data[JSON_KEY_ACTSET_FRESHNESS_PROC_ARGS]

	var/list/actions = list()

	// Origin left null, to be set by the caller.
	// Actions ALSO null, we sadly need to set their origin to this object AFTER we create it
	//   and it's cleaner to iterate just once (right here) than to add a second loop in New().
	var/datum/action_set/new_actionset = new(name, null, active, ttl_remove, ttl_deactivate, time_retrieved, null, true_freshness_proc, freshness_proc_args)

	for(var/action_definition in action_data)
		if(isnull(action_definition))
			continue

		var/datum/utility_action_template/new_action_template = ActionTemplateFromData(action_definition)
		if(isnull(new_action_template))
			continue

		# ifdef DEBUG_SERDE_LOADS
		UTILITYBRAIN_DEBUG_LOG("Loaded ActionSet item [new_action_template]")
		for(var/nav in new_action_template.vars)
			UTILITYBRAIN_DEBUG_LOG("[nav] => [new_action_template.vars[nav]]")
		# endif

		actions.Add(new_action_template)

		// I don't exactly love this, but we do need to track origin somehow
		new_action_template.origin = new_actionset

	new_actionset.actions = actions
	return new_actionset


/proc/ActionSetFromJsonFile(var/json_filepath) // str -> ActionSet
	ASSERT(json_filepath)

	var/list/json_data = null; READ_JSON_FILE_CACHED(json_filepath, json_data)
	ASSERT(json_data)

	var/datum/action_set/new_actionset = ActionSetFromData(json_data)
	return new_actionset


#ifdef UTILITY_SMARTOBJECT_SENSES
// Only compile if the senses are included too...

/*
// UtilitySmartobjectFetcher SerDe
*/

# define JSON_KEY_SO_FETCHER_IDX_KEY "sense_index_key"
# define JSON_KEY_SO_FETCHER_ENABLED "enabled"
# define JSON_KEY_SO_FETCHER_INP_MEM_KEY "in_memory_key"
# define JSON_KEY_SO_FETCHER_OUT_MEM_KEY "out_memory_key"
# define JSON_KEY_SO_FETCHER_RETENTION_TIME "retention_time_dseconds"

/proc/UtilitySmartobjectFetcherFromJsonFile(var/json_filepath) // str -> ActionTemplate
	to_world_log("Creating a utility_sense_fetcher from [json_filepath]")
	ASSERT(json_filepath)

	var/list/json_data = null; READ_JSON_FILE_CACHED(json_filepath, json_data)
	ASSERT(json_data)

	var/sense/utility_smartobject_fetcher/new_sense = UtilitySmartobjectFetcherFromData(json_data)
	return new_sense


/proc/UtilitySmartobjectFetcherFromData(var/list/json_data) // list -> ActionTemplate
	ASSERT(json_data)

	var/key = json_data[JSON_KEY_SO_FETCHER_IDX_KEY]
	var/enabled = json_data[JSON_KEY_SO_FETCHER_ENABLED]
	var/in_memory_key = json_data[JSON_KEY_SO_FETCHER_INP_MEM_KEY]
	var/out_memory_key = json_data[JSON_KEY_SO_FETCHER_OUT_MEM_KEY]
	var/retention_time_dseconds = json_data[JSON_KEY_SO_FETCHER_RETENTION_TIME]

	var/sense/utility_smartobject_fetcher/new_sense = new(key, enabled, in_memory_key, out_memory_key, retention_time_dseconds)
	return new_sense

# endif


// Like Utility actions, but just fetch GOAP details
// The GOAP spec is a subset of the Utility one, so you can use Utility data for this
/proc/GoapActionFromData(var/list/json_data) // list -> GoaiAction
	ASSERT(json_data)

	var/list/raw_preconds = json_data[JSON_KEY_ACT_PRECONDS]
	var/list/raw_effects = json_data[JSON_KEY_ACT_EFFECTS]

	var/list/preconds = list()
	for(var/typekey in raw_preconds)
		var/list/typekey_preconds = raw_preconds[typekey]

		if(isnull(typekey_preconds))
			continue

		var/fixed_preconds[typekey_preconds.len]

		for(var/raw_precond_key in typekey_preconds)
			var/precond_val = typekey_preconds[raw_precond_key]

			var/out_precond_key = raw_precond_key
			if(length(raw_precond_key) && (raw_precond_key[1] == "?"))
				// dynamic query, extract the output key from the raw query
				var/not_matched = TRUE

				# ifdef USE_REGEX_CACHE
				if(not_matched)
					// lazy init in case it didn't happen/got nulled out
					REGEX_CACHE_LAZY_INIT(0)

					var/list/uncached_match = GOAI_LIBBED_GLOB_ATTR(regex_cache)[raw_precond_key]

					if(istype(uncached_match) && length(uncached_match) == 4)
						out_precond_key = uncached_match[4]
						// we don't need the first three items here
						not_matched = FALSE

					else
						to_world_log("DEBUG: Regex Cache miss for [raw_precond_key]: [uncached_match] ([length(uncached_match)])")
				# endif

				if(not_matched)
					var/regex/ws_query_regex = regex(DYNAMIC_WS_QUERY_REGEX)

					ASSERT(ws_query_regex.Find(raw_precond_key))
					out_precond_key = ws_query_regex.group[4]

					not_matched = FALSE

					# ifdef USE_REGEX_CACHE
					// update the cache
					GOAI_LIBBED_GLOB_ATTR(regex_cache)[raw_precond_key] = list(ws_query_regex.group[1], ws_query_regex.group[2], ws_query_regex.group[3], out_precond_key)
					# endif

			fixed_preconds[out_precond_key] = precond_val

		preconds.Add(fixed_preconds)

	var/list/effects = list()
	for(var/typekey in raw_effects)
		var/list/typekey_fxs = raw_effects[typekey]

		if(isnull(typekey_fxs))
			continue

		var/fixed_effects[typekey_fxs.len]

		for(var/raw_effect_key in typekey_fxs)
			var/effect_val = typekey_fxs[raw_effect_key]

			var/out_effect_key = raw_effect_key
			if(length(raw_effect_key) && (raw_effect_key[1] == "?"))
				// dynamic query, extract the output key from the raw query
				var/regex/ws_query_regex = regex(DYNAMIC_WS_QUERY_REGEX)
				ASSERT(ws_query_regex.Find(raw_effect_key))
				out_effect_key = ws_query_regex.group[4]

			fixed_effects[out_effect_key] = effect_val

		effects.Add(fixed_effects)

	var/cost = json_data[JSON_KEY_ACT_PRIORITY]
	if(isnull(cost))
		cost = 50

	var/act_name = json_data[JSON_KEY_ACT_NAME]
	var/is_instant = json_data[JSON_KEY_ACT_ISINSTANT]
	var/list/action_args = json_data[JSON_KEY_ACT_HARDARGS]

	var/datum/goai_action/new_goap_action = new(
		preconds,
		effects,
		cost,
		act_name,
		is_instant,
		action_args
	)

	return new_goap_action


/proc/GoapActionFromJsonFile(var/json_filepath) // str -> GoaiAction
	ASSERT(json_filepath)

	var/list/json_data = null; READ_JSON_FILE_CACHED(json_filepath, json_data)
	ASSERT(json_data)

	var/datum/goai_action/new_goap_action = GoapActionFromData(json_data)
	return new_goap_action


/proc/GoapActionSetFromJsonFile(var/json_filepath) // str -> {str: GoaiAction}
	ASSERT(json_filepath)

	var/list/json_data = null
	READ_JSON_FILE_CACHED(json_filepath, json_data)
	ASSERT(json_data)

	var/list/actionset = list()

	for(var/action_data_key in json_data)
		var/list/action_data_list = json_data[action_data_key]
		action_data_list[JSON_KEY_ACT_NAME] = action_data_key
		var/datum/goai_action/new_goap_action = GoapActionFromData(action_data_list)
		actionset[action_data_key] = new_goap_action

	return actionset

