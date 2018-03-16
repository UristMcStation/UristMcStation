#if !defined(USING_MAP_DATUM)

	#include "asteroid_areas.dm"
	#include "asteroid_shuttles.dm"
	#include "asteroid_jobs.dm"
	#include "asteroid_shuttles.dm"

	#include "loadout/loadout_accessories.dm"
	#include "loadout/loadout_eyes.dm"
	#include "loadout/loadout_head.dm"
	#include "loadout/loadout_shoes.dm"
	#include "loadout/loadout_suit.dm"
	#include "loadout/loadout_uniform.dm"
	#include "loadout/loadout_xeno.dm"


	#include "asteroid-1.dmm"
	#include "asteroid-2.dmm"
	#include "asteroid-3.dmm"
	#include "asteroid-4.dmm"
	#include "asteroid-5.dmm"


	#include "../../code/modules/lobby_music/chasing_time.dm"
	#include "../../code/modules/lobby_music/absconditus.dm"
	#include "../../code/modules/lobby_music/clouds_of_fire.dm"
	#include "../../code/modules/lobby_music/endless_space.dm"
	#include "../../code/modules/lobby_music/dilbert.dm"
	#include "../../code/modules/lobby_music/space_oddity.dm"
	#include "../../code/modules/lobby_music/human.dm"
	#include "../../code/modules/lobby_music/marhaba.dm"
	#include "../../code/modules/lobby_music/treacherous_voyage.dm"
	#include "../../code/modules/lobby_music/comet_haley.dm"
	#include "../../code/modules/lobby_music/lysendraa.dm"


	#define USING_MAP_DATUM /datum/map/asteroid
	#define URISTCODE 1

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Asteroid

#endif
