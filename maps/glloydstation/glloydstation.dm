#if !defined(USING_MAP_DATUM)

	#include "glloydstation_areas.dm"
	#include "glloydstation_shuttles.dm"
	#include "glloydstation_unit_testing.dm"
	#include "glloydstation_holodecks.dm"

	#include "glloydstation-1.dmm"
	#include "glloydstation-2.dmm"
	#include "glloydstation-3.dmm"
	#include "glloydstation-4.dmm"
	#include "glloydstation-5.dmm"
	#include "glloydstation-6.dmm"

	#define USING_MAP_DATUM /datum/map/glloydstation

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Glloydstation

#endif
