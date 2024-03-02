/*
// This file is a library of ContextFetchers that can be plugged into ActionTemplates.
//
//  => MOST OF THE USAGE OF THESE FUNCTIONS WILL BE IN ACTIONTEMPLATE.DM! <=
//
// A ContextFetcher is a simple proc that (optionally) takes the parent Template and
// (optionally) whoever requested the fetch as input and returns
// an array of assoc lists (i.e. a list of key-value maps,
// with each Map representing a set of possible parameters to consider).
//
// Practically, the API is designed to give you access to both the Action's details
// and the requesting entity (mob, for mob AI, or some datum for more abstract AIs).
//
// A Fetcher is bound to 0+ ActionTemplates as a variable.
// An Action is defined as an ActionTemplate + one of the Contexts a Fetcher can return bound together.
//
// The decision engine checks all combinations of ActionTemplates and available Contexts and scores them.
// As such, Make sure you constrain the number of Contexts in the array to just those that are relevant
// AND likely to have reasonable amounts of Utility (e.g. a FireShotgun()'s ContextFetcher probably shouldn't
// return a Context for enemies that are across the map, because it's not practically worth considering).
//
// Most of the logic here was extracted to the context_fetchers/<FOO>.dm files as their number grew.
// This file is currently just provides top-level shared bits, it MAY get deleted later on.
*/

// Macro-ized callsig to make it easy/mandatory to use the proper API conventions
// For those less familiar with macros, pretend this is a normal proc definition with parent/requester/context_args as params.
// (ActionTemplate, Optional<Any>, Optional<assoc>) -> [{Any: Any}]
# define CTXFETCHER_CALL_SIGNATURE(procpath) ##procpath(var/datum/utility_action_template/parent = null, var/requester = null, var/list/context_args = null)
# define CTXFETCHER_FORWARD_ARGS parent, requester, context_args



CTXFETCHER_CALL_SIGNATURE(/proc/ctxfetcher_get_tagged_target)
	// Returns a simple list of gameobjects with the specified tag
	//
	// To be clear, these are *DM tags* - this kills the Garbage Collector.
	// So, this is only a tool for testing ideas without building proper
	// Senses and HIGHLY NOT RECOMMENDED for production-level AIs.
	//
	// EXCEPTION: if you construct the input programmatically, you can use a text ref.
	// These SHOULD be GC-friendly, but then you cannot create 'em at compile-time.

	var/list/contexts = list()

	/*var/filter_type = null
	if(!isnull(context_args))
		var/raw_type = context_args[CTX_KEY_FILTERTYPE]
		filter_type = text2path(raw_type)*/

	var/tag_to_find = context_args["tag"]

	if(isnull(tag_to_find))
		UTILITYBRAIN_DEBUG_LOG("WARNING: tag for ctxfetcher_get_tagged_target is null @ L[__LINE__] in [__FILE__]!")
		to_world("WARNING: tag for ctxfetcher_get_tagged_target is null @ L[__LINE__] in [__FILE__]!")
		return null

	var/context_key = context_args["output_context_key"] || "position"
	var/target = locate(tag_to_find)
	to_world("Locating [tag_to_find], found [target] @ L[__LINE__] in [__FILE__]!")

	if(isnull(tag_to_find))
		UTILITYBRAIN_DEBUG_LOG("WARNING: could not locate tagged entity for ctxfetcher_get_tagged_target @ L[__LINE__] in [__FILE__]!")
		to_world("WARNING: could not locate tagged entity for ctxfetcher_get_tagged_target @ L[__LINE__] in [__FILE__]!")
		return null

	var/list/ctx = list()
	ctx[context_key] = target

	contexts[++(contexts.len)] = ctx
	return contexts

