#if !defined(using_map_DATUM) || defined(DEBUG_GENERATE_WORTHS)
	#include "example_areas.dm"
	#include "example_shuttles.dm"
	#include "example_radio.dm"
	#include "example_unit_testing.dm"

	#ifndef DEBUG_GENERATE_WORTHS
	#include "example-1.dmm"
	#include "example-2.dmm"
	#include "example-3.dmm"

	#include "../standard_cultures.dm"

	#define using_map_DATUM /datum/map/example
	#endif

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Example

#endif
