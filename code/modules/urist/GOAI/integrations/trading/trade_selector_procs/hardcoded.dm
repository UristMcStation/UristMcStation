/*
// This is primarily an example implementation of a proc that can be used in
//  /datum/utility_ai's attributes best_purchase_for_need_proc & best_sale_for_need_proc
//
// This example proc follows the standard interface for all such procs - three-arg signature:
// - need_key - the string key of the need the AI is trying to satisfy
// - kwargs - an assoc list of arbitrary extra parameters to pass in (we're not using them here)
// - caller - a reference to the calling AI (not used here either)
//
// The proc should return a string Commodity key (should match the key in the CommodityDB).
// The AI code will take it from here for you.
//
// To use for trading, simply instantiate a /datum/brain/utility or subclass with: ```
best_purchase_for_need_proc = GLOBAL_PROC_REF(utility_best_trade_item_selector_hardcoded)
best_sale_for_need_proc = GLOBAL_PROC_REF(utility_best_trade_item_selector_hardcoded)
```
// (ignore backticks for copying, this is just to show this is the code to copy *verbatim*)
*/

/proc/utility_best_trade_item_selector_hardcoded(var/need_key, var/list/kwargs, var/datum/utility_ai/caller)
	/* Simplistic implementation of choosing a preferred Commodity for our outgoing trade offers.
	// Simply uses a hardcoded Commodity decision for each possible Need.
	*/
	var/best_choice = null

	switch(need_key)
		if(NEED_WEALTH) best_choice = "/obj/decor"
		if(NEED_FOOD_GENERIC) best_choice = "/obj/food"

	return best_choice
