#if !defined(USING_MAP_DATUM)

	#include "asteroid_areas.dm"
	#include "asteroid_shuttles.dm"
	#include "asteroid_jobs.dm"
	#include "asteroid_shuttles.dm"
	#include "asteroid_station/asteroid_station.dm"

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


	#include "../../code/datums/music_tracks/chasing_time.dm"
	#include "../../code/datums/music_tracks/absconditus.dm"
	#include "../../code/datums/music_tracks/clouds_of_fire.dm"
	#include "../../code/datums/music_tracks/endless_space.dm"
	#include "../../code/datums/music_tracks/dilbert.dm"
	#include "../../code/datums/music_tracks/space_oddity.dm"
	#include "../../code/datums/music_tracks/human.dm"
	#include "../../code/datums/music_tracks/marhaba.dm"
	#include "../../code/datums/music_tracks/treacherous_voyage.dm"
	#include "../../code/datums/music_tracks/comet_haley.dm"
	#include "../../code/datums/music_tracks/lysendraa.dm"


	#define USING_MAP_DATUM /datum/map/asteroid
	#define URISTCODE 1

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Asteroid

#endif
