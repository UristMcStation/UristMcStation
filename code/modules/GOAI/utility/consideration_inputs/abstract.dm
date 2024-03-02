/*
// Consideration procs that deal with more abstract, mathematical properties and hacks
// such as random numbers, NULLs, etc.
*/

CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_always)
	// A dumb Consideration input that always returns 100% activation
	return ACTIVATION_FULL


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_never)
	// A dumb Consideration input that always returns 0% activation
	return ACTIVATION_NONE


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_constant)
	// A dumb Consideration input that always returns a specified activation

	var/raw_value = consideration_args["value"]
	var/value = clamp(raw_value, ACTIVATION_NONE, ACTIVATION_FULL)

	return value


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_urand)
	// A Consideration input that returns an activation that is uniform random between 0% and 100%
	return rand() * 100


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_arg_not_null)
	// Simple binary Consideration - is the input arg value for a given key null or not?

	var/from_ctx = consideration_args["from_context"]
	if(isnull(from_ctx))
		from_ctx = TRUE

	var/inp_key = consideration_args["input_key"] || "input"

	var/candidate = null
	try
		candidate = (from_ctx ? context[inp_key] : consideration_args[inp_key])
	DEBUGLOG_UTILITY_INPUT_CATCH(var/exception/e)
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: [e] on [e.file]:[e.line]. <inp_key='[inp_key]'>")

	if(isnull(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_arg_not_null Candidate is null @ L[__LINE__] in [__FILE__]")
		return FALSE

	return TRUE


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_input_read_var)
	// Retrieves an arbitrary variable from the target object.

	var/from_ctx = consideration_args["from_context"]
	if(isnull(from_ctx))
		from_ctx = TRUE

	var/inp_key = consideration_args["input_key"] || "input"

	var/datum/candidate = null
	try
		candidate = (from_ctx ? context[inp_key] : consideration_args[inp_key])
	DEBUGLOG_UTILITY_INPUT_CATCH(var/exception/e)
		DEBUGLOG_UTILITY_INPUT_FETCHERS("ERROR: [e] on [e.file]:[e.line]. <inp_key='[inp_key]'>")

	if(isnull(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_read_var Candidate is null @ L[__LINE__] in [__FILE__]")
		return null

	var/var_key = consideration_args?["variable"]

	if(isnull(var_key))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_input_read_var VarKey is null @ L[__LINE__] in [__FILE__]")
		return null

	var/result = candidate.vars[var_key]
	DEBUGLOG_UTILITY_INPUT_FETCHERS("Value for var [var_key] in [candidate] is [result] @ L[__LINE__] in [__FILE__]")
	return result


CONSIDERATION_CALL_SIGNATURE(/proc/consideration_actiontemplate_read_var)
	// Retrieves an arbitrary variable from the candidate ActionTemplate object.
	// In other words, read our own metadata.
	var/datum/utility_action_template/candidate = action_template

	if(isnull(candidate))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_read_var Candidate is not an ActionTemplate! @ L[__LINE__] in [__FILE__]")
		return null

	var/var_key = consideration_args?["variable"]

	if(isnull(var_key))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("consideration_actiontemplate_read_var VarKey is null @ L[__LINE__] in [__FILE__]")
		return null

	var/result = candidate.vars[var_key]
	DEBUGLOG_UTILITY_INPUT_FETCHERS("Value for var [var_key] in [candidate] is [result] @ L[__LINE__] in [__FILE__]")
	return result

