#if !defined(USING_MAP_DATUM)

	#include "glloydstation_areas.dm"
	#include "glloydstation_shuttles.dm"
	#include "glloydstation_unit_testing.dm"
	#include "glloydstation_holodecks.dm"
	#include "glloydstation_jobs.dm"
	#include "glloydstation_presets.dm"
	#include "arrivals.dm"
	#include "simple_shuttles.dm"

	#include "loadout/loadout_accessories.dm"
	#include "loadout/loadout_eyes.dm"
	#include "loadout/loadout_head.dm"
	#include "loadout/loadout_shoes.dm"
	#include "loadout/loadout_suit.dm"
	#include "loadout/loadout_uniform.dm"
	#include "loadout/loadout_xeno.dm"

	#include "Glloydstation2-1.dmm"
	#include "Glloydstation2-2.dmm"
	#include "Glloydstation2-3.dmm"
	#include "Glloydstation2-4.dmm"
	#include "Glloydstation2-5.dmm"
	#include "Glloydstation2-6.dmm"
	#include "Glloydstation2-7.dmm"

	#include "../../code/modules/lobby_music/chasing_time.dm"
	#include "../../code/modules/lobby_music/absconditus.dm"
	#include "../../code/modules/lobby_music/clouds_of_fire.dm"
	#include "../../code/modules/lobby_music/endless_space.dm"
	#include "../../code/modules/lobby_music/dilbert.dm"
	#include "../../code/modules/lobby_music/space_oddity.dm"

	#define USING_MAP_DATUM /datum/map/glloydstation
	#define URISTCODE 1 //hacky override that tells the compiler that yes, the map is Uristcrap-compatible
	#define SCOM_ZLEVEL 2 //in case we ever have more maps

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Glloydstation

#endif
