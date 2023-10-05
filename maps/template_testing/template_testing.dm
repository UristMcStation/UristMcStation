#if !defined(using_map_DATUM)
	#include "template_testing_lobby.dm"
	#include "../standard_cultures.dm"

	#include "blank.dmm"
	#include "../away/empty.dmm"

	#include "template_testing_unit_testing.dm"
	#include "../away/mining/mining_areas.dm"
	#include "../away/smugglers/smugglers_items.dm"

	#define using_map_DATUM /datum/map/template_testing

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Away Sites Testing

#endif
