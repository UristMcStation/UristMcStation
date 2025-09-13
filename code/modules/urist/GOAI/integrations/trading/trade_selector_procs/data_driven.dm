/*
// This is primarily an example implementation of a proc that can be used in
//  /datum/utility_ai's attributes best_purchase_for_need_proc & best_sale_for_need_proc
//
// This example proc follows the standard interface for all such procs - three-arg signature:
// - need_key - the string key of the need the AI is trying to satisfy
// - kwargs - an assoc list of arbitrary extra parameters to pass in (we're not using them here)
// - caller - a reference to the calling AI
//
// The proc should return a string Commodity key (should match the key in the CommodityDB).
// The AI code will take it from here for you.
*/


/*
// Simplistic implementation of choosing a preferred Commodity for our outgoing trade offers.
// Uses the calling Brain's data-driven variables to define the (otherwise dumb) lookup.
// Easy to tweak, but not sophisticated in terms of checking what we actually HAVE.
//
// The three procs are variants for looking up different keys in the personality spec.
*/
/proc/utility_best_trade_item_selector_personality_generic(var/need_key, var/list/kwargs, var/datum/utility_ai/caller)
	// This is a lazy dev's variant - chuck all items into one big list so buys and sells are symmetrical.
	if(!istype(caller))
		GOAI_LOG_ERROR("ERROR: utility_best_trade_item_selector_personality_generic() caller is not an AI!")
		return null

	var/datum/brain/ai_brain = caller.brain
	if(!istype(ai_brain))
		GOAI_LOG_ERROR("ERROR: utility_best_trade_item_selector_personality_generic()'s AI caller has no Brain!")
		return null

	var/list/lookup = ai_brain.preferred_trades

	var/best_choice = lookup?[need_key]
	return best_choice


/proc/utility_best_trade_item_selector_personality_buy(var/need_key, var/list/kwargs, var/datum/utility_ai/caller)
	if(!istype(caller))
		GOAI_LOG_ERROR("ERROR: utility_best_trade_item_selector_personality_generic() caller is not an AI!")
		return null

	var/datum/brain/ai_brain = caller.brain
	if(!istype(ai_brain))
		GOAI_LOG_ERROR("ERROR: utility_best_trade_item_selector_personality_generic()'s AI caller has no Brain!")
		return null

	var/list/lookup = ai_brain.preferred_trades?["buy"]
	var/best_choice = lookup?[need_key]
	return best_choice


/proc/utility_best_trade_item_selector_personality_sell(var/need_key, var/list/kwargs, var/datum/utility_ai/caller)
	if(!istype(caller))
		GOAI_LOG_ERROR("ERROR: utility_best_trade_item_selector_personality_generic() caller is not an AI!")
		return null

	var/datum/brain/ai_brain = caller.brain
	if(!istype(ai_brain))
		GOAI_LOG_ERROR("ERROR: utility_best_trade_item_selector_personality_generic()'s AI caller has no Brain!")
		return null

	var/list/lookup = ai_brain.preferred_trades?["sell"]
	var/best_choice = lookup?[need_key]
	return best_choice
