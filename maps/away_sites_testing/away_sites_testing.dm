#if !defined(using_map_DATUM) || defined(DEBUG_GENERATE_WORTHS)
	#include "away_sites_testing_lobby.dm"
	#include "../standard_cultures.dm"

	#ifndef DEBUG_GENERATE_WORTHS
	#include "blank.dmm"
	#include "../away/empty.dmm"
	#endif

	#include "away_sites_testing_unit_testing.dm"

	//Place all away maps here
	#include "../away/mining/mining.dm"
	#include "../away/abandoned_colony/abandoned_colony.dm"
	#include "../away/derelict/derelict.dm"
	#include "../away/bearcat/bearcat.dm"
	#include "../away/contact_light/contact_light.dm"
	#include "../away/destroyed_colony/destroyed_colony.dm"
	#include "../away/icarus/icarus.dm"
	#include "../away/lost_supply_base/lost_supply_base.dm"
	#include "../away/mininghome/mininghome.dm"
	#include "../away/noctis/noctis.dm"
	#include "../away/smugglers/smugglers.dm"
	#include "../away/crystalized_drugs/crystalized_drugs.dm"
	#include "../away/forest/forest.dm"
	#include "../away/russianderelict/russianderelict.dm"
	#include "../away/glloyd_jungle/glloyd_jungle.dm"
	#include "../away/casino/casino.dm"
	#include "../away/magshield/magshield.dm"
	#include "../away/slavers_base/slavers_base.dm"
	#include "../away/blueriver/blueriver.dm"
	#include "../away/mobius_rift/mobius_rift.dm"
	#include "../away/errant_pisces/errant_pisces.dm"
	#include "../away/lar_maria/lar_maria.dm"
	#include "../away/skrellscoutship/skrellscoutship.dm"
	#include "../away/meatstation/meatstation.dm"
	#include "../away/miningstation/miningstation.dm"
	#include "../away/scavver_gantry/scavver_gantry.dm"
	#include "../away/voxship/voxship.dm"
	#include "../away/yacht/yacht.dm"
	#include "../away/abandoned_hotel/abandoned_hotel.dm"

	#ifndef DEBUG_GENERATE_WORTHS
	#define using_map_DATUM /datum/map/away_sites_testing
	#endif

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Away Sites Testing

#endif
