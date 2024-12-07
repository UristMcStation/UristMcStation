/*
// A Consideration is a Utility scorer that takes in Inputs and produces Activations.
//
// The API is very simple - an Input is a plain-old proc. It takes in an assoc list (or null) and optionally any type representing the logical 'owner' of the decision
// and outputs a float representing the value to use for scoring.
// The float will be normalized downstream by the Consideration's parameters, so you don't need to worry about that.
//
// Most of the logic here was extracted to the consideration_inputs/<FOO>.dm files as their number grew.
// This file is currently just provides top-level shared bits, it MAY get deleted later on.
*/

// Macro-ized callsig to make it easy/mandatory to use the proper API conventions
// For those less familiar with macros, pretend this is a normal proc definition with context/requester/consideration_args as params.
#define CONSIDERATION_CALL_SIGNATURE(procpath) ##procpath(var/datum/utility_action_template/action_template, var/list/context = null, var/requester = null, var/list/consideration_args = null)

/*
// Inlined function. Fetches a Brain, type-checked, into the Output variable, or null with error logs on failure.
// This means that you don't have to worry about type-checking it yourself.
// Uses aggressive, ugly prefixing to ensure the odds of a varname clash are minimal.
*/
#define CIHELPER_GET_REQUESTER_BRAIN_INLINED(Requester, Output) \
\
var/_cihelper_get_requester_brain_okay = TRUE; \
var/datum/brain/_cihelper_get_requester_brain_output_brain = null; \
var/datum/utility_ai/_cihelper_get_requester_brain_controller = Requester; \
if(_cihelper_get_requester_brain_okay && !istype(_cihelper_get_requester_brain_controller)) {\
	to_world_log("GET_REQUESTER_BRAIN_INLINED Controller is not an AI ([_cihelper_get_requester_brain_controller]) @ L[__LINE__] in [__FILE__] in CIHELPER_GET_REQUESTER_BRAIN_INLINED"); \
	_cihelper_get_requester_brain_okay = FALSE; \
}; \
if(_cihelper_get_requester_brain_okay) {\
	var/datum/brain/_cihelper_get_requester_brain_requesting_brain = _cihelper_get_requester_brain_controller.brain; \
	if(!istype(_cihelper_get_requester_brain_requesting_brain)) {\
		to_world_log("GET_REQUESTER_BRAIN_INLINED _cihelper_get_requester_brain_requesting_brain is not a Brain ([_cihelper_get_requester_brain_requesting_brain]) @ L[__LINE__] in [__FILE__] in CIHELPER_GET_REQUESTER_BRAIN_INLINED"); \
		_cihelper_get_requester_brain_okay = FALSE; \
	}; \
	_cihelper_get_requester_brain_output_brain = _cihelper_get_requester_brain_requesting_brain; \
}; \
##Output = _cihelper_get_requester_brain_output_brain;

#define CONSIDERATION_INPUTKEY_KEY "input_key"
#define CONSIDERATION_INPUTKEY_DEFAULT "input"

#define CONSIDERATION_GET_INPUT_KEY(Varname) ##Varname = DEFAULT_IF_NULL(consideration_args?[CONSIDERATION_INPUTKEY_KEY], CONSIDERATION_INPUTKEY_DEFAULT)

// These are technically ContextFetcher stuff, but their outputs naturally wire into inputs in Considerations so this helps with chaining
#define CONTEXT_OUTPUTKEY_KEY "output_context_key"
#define CONTEXT_GET_OUTPUT_KEY(Varname) ##Varname = context_args?[CONTEXT_OUTPUTKEY_KEY] || CONSIDERATION_INPUTKEY_DEFAULT

#define CONTEXT_ADD_SINGLE_KEYED_CONTEXT(Item, ContextKeyVar, ContextsListVar) \
    var/list/__macro_ctx = list(); \
    __macro_ctx[##ContextKeyVar] = ##Item; \
    ARRAY_APPEND(##ContextsListVar, __macro_ctx) \
;


/proc/_cihelper_get_requester_brain(var/requester, var/caller = null)
	var/datum/utility_ai/controller = requester

	if(!istype(controller))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("[caller] Controller is not an AI ([controller || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	var/datum/brain/requesting_brain = controller.brain

	if(!istype(requesting_brain))
		DEBUGLOG_UTILITY_INPUT_FETCHERS("[caller] requesting_brain is not a Brain ([requesting_brain || "null"]) @ L[__LINE__] in [__FILE__]")
		return null

	return requesting_brain
