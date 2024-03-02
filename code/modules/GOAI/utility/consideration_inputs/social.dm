

CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_relationship_score)
	var/datum/utility_ai/mob_commander/requester_ai = requester

	if(isnull(requester_ai))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_relationship_score requester_ai is null ([requester_ai || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	var/from_ctx = DEFAULT_IF_NULL(consideration_args?["from_context"], TRUE)

	var/inp_key = consideration_args?["input_key"] || "target"
	var/candidate = null

	try
		candidate = (from_ctx ? context[inp_key] : consideration_args[inp_key])
	DEBUGLOG_MEMORY_ERRCATCH(var/exception/e)
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: [e] on [e.file]:[e.line]. <inp_key='[inp_key]'>")

	if(isnull(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_relationship_score Candidate is null ([candidate || "null"]) <from_ctx=[from_ctx] | inp_key=[inp_key]> @ L[__LINE__] in [__FILE__]")
		return null

	var/result = requester_ai.CheckRelationsTo(candidate)
	return result

