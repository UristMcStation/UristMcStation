/*
// This file contains utilities for testing dynamic procs for trading.
// Currently all the tests are in one place, because we don't have that many procs.
*/

#warn TESTS FILE STILL INCLUDED!

/mob/verb/test_utility_best_trade_item_selector_hardcoded(need_key as text)
	if(!need_key)
		return

	var/result = utility_best_trade_item_selector_hardcoded(need_key, null, null)
	var/message = "utility_best_trade_item_selector_hardcoded([need_key]) -> [DEFAULT_IF_NULL(result, "null")]"

	to_world_log(message)
	to_chat(usr, message)

	return


/mob/verb/test_utility_best_trade_item_selector_kwargs(need_key as text)
	if(!need_key)
		return

	var/list/hardcoded_prefs = list(
		NEED_WEALTH = "$$$",
		NEED_FOOD_GENERIC = ":(||)"
	)

	var/list/kwargs = list(
		"best_purchase_commodity_for_need" = hardcoded_prefs
	)

	var/result = utility_best_trade_item_selector_kwargs(need_key, kwargs, null)
	var/message = "utility_best_trade_item_selector_kwargs([need_key]) -> [DEFAULT_IF_NULL(result, "null")]"

	to_world_log(message)
	to_chat(usr, message)

	return
