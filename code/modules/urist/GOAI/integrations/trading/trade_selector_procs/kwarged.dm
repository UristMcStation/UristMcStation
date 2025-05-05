/*
// This is primarily an example implementation of a proc that can be used in
// /datum/utility_ai's attributes best_purchase_for_need_proc & best_sale_for_need_proc
//
// This example proc follows the standard interface for all such procs - three-arg signature:
// - need_key - the string key of the need the AI is trying to satisfy
// - kwargs - an assoc list of arbitrary extra parameters to pass in (our datasource here)
// - caller - a reference to the calling AI (not used here either)
//
// The proc should return a string Commodity key (should match the key in the CommodityDB).
// The AI code will take it from here for you.
//
// To use for trading, simply instantiate a /datum/brain/utility or subclass with: ```
best_purchase_for_need_proc = GLOBAL_PROC_REF(utility_best_trade_item_selector_kwargs)
best_purchase_for_need_proc_args = list("best_commodity_for_need" = list(...your choices...))
best_sale_for_need_proc = GLOBAL_PROC_REF(utility_best_trade_item_selector_kwargs)
best_sale_for_need_proc_args = list("best_commodity_for_need" = list(...your choices...))
```
// (ignore backticks for copying, this is just to show this is the code to copy *verbatim*)
*/

/proc/utility_best_trade_item_selector_kwargs(var/need_key, var/list/kwargs, var/datum/utility_ai/caller)
	/* Simplistic implementation of choosing a preferred Commodity for our outgoing trade offers.
	// Lets the caller provide his own hardcoded preferences in the kwargs - this function just
	// wraps looking up the variables in a uniform interface to do that easily.
	*/

	if(!kwargs)
		return null

	var/list/static_need_lookup = kwargs["best_purchase_commodity_for_need"]
	var/best_choice = static_need_lookup?[need_key]

	return best_choice

