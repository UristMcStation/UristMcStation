#if !defined(using_map_DATUM)

	#include "glloydstation_areas.dm"
	#include "glloydstation_antagonism.dm"
	#include "glloydstation_shuttles.dm"
	#include "glloydstation_unit_testing.dm"
	#include "glloydstation_holodecks.dm"
	#include "glloydstation_jobs.dm"
	#include "glloydstation_presets.dm"
	#include "glloydstation_setup.dm"
	#include "arrivals.dm"
	#include "simple_shuttles.dm"

	#include "fluff/_fluff.dm"
	#include "fluff/culture.dm"
	#include "fluff/factions.dm"
	#include "fluff/locations_human.dm"
	#include "fluff/species_overrides.dm"

	#include "loadout/loadout_accessories.dm"
	#include "loadout/loadout_eyes.dm"
	#include "loadout/loadout_head.dm"
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

/*	#include "../../code/datums/music_tracks/chasing_time.dm"
	#include "../../code/datums/music_tracks/absconditus.dm"
	#include "../../code/datums/music_tracks/clouds_of_fire.dm"
	#include "../../code/datums/music_tracks/endless_space.dm"
	#include "../../code/datums/music_tracks/dilbert.dm"
	#include "../../code/datums/music_tracks/space_oddity.dm"*/

	#define using_map_DATUM /datum/map/glloydstation
	#define URISTCODE 1 //hacky override that tells the compiler that yes, the map is Uristcrap-compatible
//	#define SCOM_ZLEVEL 2 //in case we ever have more maps

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Glloydstation

#endif
