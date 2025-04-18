#if !defined(using_map_DATUM) || defined(DEBUG_GENERATE_WORTHS)

	#include "nerva_announcements.dm"
	#include "nerva_areas.dm"
	#include "nerva_elevators.dm"
	#include "nerva_holodecks.dm"
	#include "nerva_presets.dm"
	#include "nerva_procs.dm"
	#include "nerva_overmap.dm"
	#include "nerva_setup.dm"
	#include "nerva_shuttles.dm"
	#include "nerva_unit_testing.dm"
	#include "datums/nerva_jobs.dm"
	#include "datums/nerva_access_datums.dm"
	#include "datums/nerva_antagonism.dm"
	#include "datums/nerva_outfits.dm"
	#include "datums/nerva_supplypacks.dm"
	#include "datums/nerva_objectives.dm"
	#include "datums/nerva_reports.dm"

	#include "../event/placeholders/placeholders.dm"

	#include "obj/nerva_ids.dm"
	#include "obj/nerva_closets.dm"
	#include "obj/nerva_machinery.dm"
	#include "obj/nerva_computers.dm"
	#include "obj/nerva_clothes.dm"
	#include "obj/nerva_items.dm"
	#include "fluff/_fluff.dm"
	#include "fluff/culture.dm"
	#include "fluff/factions.dm"
	#include "fluff/locations_human.dm"
	#include "fluff/species_overrides.dm"
	#include "fluff/alien_fluff.dm"

	#include "loadout/_defines.dm"
	#include "loadout/loadout_accessories.dm"
	#include "loadout/loadout_clothing.dm"
	#include "loadout/loadout_eyes.dm"
	#include "loadout/loadout_hands.dm"
	#include "loadout/loadout_head.dm"
	#include "loadout/loadout_general.dm"
	#include "loadout/loadout_suit.dm"
	#include "loadout/loadout_uniform.dm"
	#include "loadout/loadout_utility.dm"
	#include "loadout/loadout_xeno.dm"
	#include "loadout/~defines.dm"

	#ifndef DEBUG_GENERATE_WORTHS
	#include "nerva-1.dmm"
	#include "nerva-2.dmm"
	#include "nerva-3.dmm"
	#include "nerva-4.dmm"
	#include "nerva-5.dmm"
	#include "nerva-6.dmm"
	#endif

//	#include "../away/mining/mining.dm"
//	#include "../away/derelict/derelict.dm"
	#include "../away/bearcat/bearcat.dm"
	#include "../away/lost_supply_base/lost_supply_base.dm"
	#include "../away/crystalized_drugs/crystalized_drugs.dm"
	#include "../away/magshield/magshield.dm"
	#include "../away/casino/casino.dm"
	#include "../away/yacht/yacht.dm"
	#include "../away/blueriver/blueriver.dm"
	#include "../away/slavers_base/slavers_base.dm"
	#include "../away/mobius_rift/mobius_rift.dm"
	#include "../away/icarus/icarus.dm"
	#include "../away/errant_pisces/errant_pisces.dm"
	#include "../away/lar_maria/lar_maria.dm"
	#include "../away/stations/nerva_stations.dm"
	#include "../away/stations/pirate/pirate_station.dm"
	#include "../away/voxship/voxship.dm"
	#include "../away/glloyd_jungle/glloyd_jungle.dm"
	#include "../away/forest/forest.dm"
	#include "../away/russianderelict/russianderelict.dm"
	#include "../away/destroyed_colony/destroyed_colony.dm"
	#include "../away/noctis/noctis.dm"
	#include "../away/abandoned_colony/abandoned_colony.dm"
	#include "../away/meatstation/meatstation.dm"
	#include "../away/scavver_gantry/scavver_gantry.dm"
	#include "../away/abandoned_hotel/abandoned_hotel.dm"
	#include "../bluespace_interlude/bluespace_interlude.dm"
	#include "../bluespace_interlude/bluespace_interlude.dmm"
	#include "../skrellscoutship/skrellscoutship.dm

	//keep your clothing hacks to yourself
	// #include "../torch/items/clothing/solgov-accessory.dm"	These don't seem to actually be used, but are causing issues with double-importing
	#include "../torch/items/clothing/solgov-armor.dm"
	#include "../torch/items/clothing/solgov-feet.dm"
	// #include "../torch/items/clothing/solgov-head.dm"
	#include "../torch/items/clothing/solgov-suit.dm"
	#include "../torch/items/clothing/solgov-under.dm"

	#ifndef DEBUG_GENERATE_WORTHS
	#define using_map_DATUM /datum/map/nerva
	#endif

	#define URISTCODE 1

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Nerva

#endif
