
/obj/var/trader_category = ""

/datum/trade_category
	var/name
	var/list/trade_items = list()
	var/list/trade_items_by_type = list()
	var/total_weighting = 0

/datum/trade_category/weapons
	name = "weapon"

/datum/trade_category/tools
	name = "tools"

/datum/trade_category/nanotrasen
	name = "nanotrasen"

/datum/trade_category/crops
	name = "crops"

/datum/trade_category/ore
	name = "ore"

/datum/trade_category/medical
	name = "medical"

/datum/trade_category/bulky //stuff that you can't hand to a person. One trader will cover this unless I have other ideas.
	name = "bulky"

/datum/trade_category/atmospherics //i had other ideas.
	name = "atmospherics"

/datum/trade_category/clothing
	name = "clothing"


