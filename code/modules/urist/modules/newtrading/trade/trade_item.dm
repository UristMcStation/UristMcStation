/datum/trade_item
	var/name
	var/item_type
	var/category
	var/quantity = 0
	var/value = 0
	var/trader_weight = 1
	var/list/bonus_items = list()
	var/is_template = 1
	var/sellable = 1 //can we sell this item to the trader. THIS DEFAULTS EVERYTHING TO YES. I spent way too long trying to figure out why nothing else was using this- cara.
	var/is_bulky = 0
	var/req_access = null
