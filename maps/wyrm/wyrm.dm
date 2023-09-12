#if !defined(using_map_DATUM)

	#include "wyrm_areas.dm"
	#include "wyrm_shuttles.dm"
	#include "wyrm_jobs.dm"
	#include "wyrm_overmap.dm"
	#include "wyrm_shuttles.dm"
	#include "wyrm_presets.dm"
	#include "wyrm_holodecks.dm"
	#include "wyrm_datum_access.dm"
	#include "wyrm_unit_testing.dm"

	#include "loadout/loadout_accessories.dm"
	#include "loadout/loadout_eyes.dm"
	#include "loadout/loadout_head.dm"
	#include "loadout/loadout_suit.dm"
	#include "loadout/loadout_uniform.dm"
	#include "loadout/loadout_xeno.dm"


	#include "wyrm-1.dmm"
	#include "wyrm-2.dmm"
	#include "wyrm-3.dmm"
	#include "wyrm-4.dmm"

	#include "../away/mining/mining.dm"
	#include "../away/derelict/derelict.dm"
	#include "../away/bearcat/bearcat.dm"
	#include "../away/lost_supply_base/lost_supply_base.dm"
	#include "../away/smugglers/smugglers.dm"
	#include "../away/magshield/magshield.dm"
	#include "../away/casino/casino.dm"
	#include "../away/yacht/yacht.dm"
	#include "../away/blueriver/blueriver.dm"
	#include "../away/slavers_base/slavers_base.dm"
	#include "../away/mobius_rift/mobius_rift.dm"
	#include "../away/icarus/icarus.dm"
	#include "../away/errant_pisces/errant_pisces.dm"
	#include "../away/lar_maria/lar_maria.dm"
	#include "../away/contact_light/contact_light.dm"

	#include "items\smcult.dm"
	#include "items\clothing\corporate.dm"
	#include "obj\alien.dm"
	#include "turf\generic.dm"

	#include "../../code/datums/music_tracks/chasing_time.dm"
	#include "../../code/datums/music_tracks/absconditus.dm"
	#include "../../code/datums/music_tracks/clouds_of_fire.dm"
	#include "../../code/datums/music_tracks/endless_space.dm"
	#include "../../code/datums/music_tracks/dilbert.dm"
	#include "../../code/datums/music_tracks/space_oddity.dm"

	#define using_map_DATUM /datum/map/wyrm
	#define URISTCODE 1

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Wyrm

#endif
