#include "abandoned_factory_items.dm"

/obj/effect/overmap/sector/abandoned_factory
	name = "automated distress signal"
	desc = "A distress signal originating from what appears to be a factory."
	icon_state = "object"

/datum/map_template/ruin/away_site/abandoned_factory
	name = "automated distress signal"
	id = "awaysite_hololab"
	description = "An abandoned factory."
	suffixes = list("abandoned_factory/abandoned_factory.dmm")
	cost = 1
