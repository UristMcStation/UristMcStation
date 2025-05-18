
CTXFETCHER_CALL_SIGNATURE(/proc/ctxfetcher_all_faction_ais)
	if(isnull(context_args))
		UTILITYBRAIN_DEBUG_LOG("ERROR: context_args for ctxfetcher_all_factions is null @ L[__LINE__] in [__FILE__]!")
		return

	if(!GOAI_LIBBED_GLOB_ATTR(global_faction_ai_registry))
		UTILITYBRAIN_DEBUG_LOG("WARNING: ctxfetcher_all_factions found no items in the global faction registry @ L[__LINE__] in [__FILE__]!")
		return

	var/list/contexts = list()

	CONTEXT_GET_OUTPUT_KEY(var/context_key)

	for(var/faction_ai in GOAI_LIBBED_GLOB_ATTR(global_faction_ai_registry))
		if(requester && (faction_ai == requester))
			continue

		var/list/ctx = list()
		ctx[context_key] = faction_ai
		contexts[++(contexts.len)] = ctx

	return contexts
