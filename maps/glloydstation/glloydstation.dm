#if !defined(USING_MAP_DATUM)

	#include "glloydstation_areas.dm"
	#include "glloydstation_shuttles.dm"
	#include "glloydstation_unit_testing.dm"
	#include "glloydstation_holodecks.dm"

	#include "Glloydstation2-1.dmm"
	#include "Glloydstation2-2.dmm"
	#include "Glloydstation2-3.dmm"
	#include "Glloydstation2-4.dmm"
	#include "Glloydstation2-5.dmm"
	#include "Glloydstation2-6.dmm"
	#include "Glloydstation2-7.dmm"

	#define USING_MAP_DATUM /datum/map/glloydstation

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Glloydstation

#endif
