/*
// Various entities will need to have their assets (money, commodities) tracked for economy purposes.
//
// We COULD do it OOP-style and do it on each datum, but that would be painfully heterogenous and not
// really take any advantage of OOP features anyway, as this logic is abstract and uniform.
//
// It would also mean allocating memory for a ton of entities which will NEVER use it in any way.
// Instead, we'll do it ECS/database style, any entity that needs to have an 'account' here will
// just need to register its (stable) ID into a list here.
//
// A positive side-effect is that if suddenly your sandwich needs to track its $$$, we COULD do it
// without extending the class API in any way - just calling to register it and to update as needed.
*/

# ifdef GOAI_LIBRARY_FEATURES
var/global/list/global_asset_registry
var/global/list/faction_asset_deltas_registry
# endif

# ifdef GOAI_SS13_SUPPORT
GLOBAL_LIST_EMPTY(global_asset_registry)
GLOBAL_LIST_EMPTY(faction_asset_deltas_registry)
# endif

#define ASSETS_TABLE_LAZY_INIT(_Unused) if(isnull(GOAI_LIBBED_GLOB_ATTR(global_asset_registry)) || !islist(GOAI_LIBBED_GLOB_ATTR(global_asset_registry))) { GOAI_LIBBED_GLOB_ATTR(global_asset_registry) = list() }
#define ASSETDELTAS_TABLE_LAZY_INIT(_Unused) if(isnull(GOAI_LIBBED_GLOB_ATTR(faction_asset_deltas_registry)) || !islist(GOAI_LIBBED_GLOB_ATTR(faction_asset_deltas_registry))) { GOAI_LIBBED_GLOB_ATTR(faction_asset_deltas_registry) = list() }

#define HAS_REGISTERED_ASSETS(AssetId) (AssetId && GOAI_LIBBED_GLOB_ATTR(global_asset_registry) && (AssetId in GOAI_LIBBED_GLOB_ATTR(global_asset_registry)))
#define CREATE_ASSETS_TRACKER(AssetId) (GOAI_LIBBED_GLOB_ATTR(global_asset_registry)[AssetId] = list())
#define CREATE_ASSETS_TRACKER_IF_NEEDED(AssetId) if(!(AssetId && HAS_REGISTERED_ASSETS(AssetId))) { ASSETS_TABLE_LAZY_INIT(TRUE); CREATE_ASSETS_TRACKER(AssetId) };
#define GET_ASSETS_TRACKER(AssetId) (GOAI_LIBBED_GLOB_ATTR(global_asset_registry)[AssetId])
#define UPDATE_ASSETS_TRACKER(AssetId, NewData) (GOAI_LIBBED_GLOB_ATTR(global_asset_registry)[AssetId] = NewData)

#define CREATE_ASSET_DELTAS_TABLE(FactionId) (GOAI_LIBBED_GLOB_ATTR(faction_asset_deltas_registry)[FactionId] = list())
#define CREATE_ASSET_DELTAS_TABLE_IF_NEEDED(FactionId) if(!( GOAI_LIBBED_GLOB_ATTR(faction_asset_deltas_registry) )) { ASSETDELTAS_TABLE_LAZY_INIT(TRUE); CREATE_ASSET_DELTAS_TABLE(FactionId) }; if (!(FactionId in GOAI_LIBBED_GLOB_ATTR(faction_asset_deltas_registry) )) { CREATE_ASSET_DELTAS_TABLE(FactionId) };
#define GET_ASSETS_DELTAS_FOR_FACTION(FactionId) (GOAI_LIBBED_GLOB_ATTR(faction_asset_deltas_registry)[FactionId])
#define SET_ASSETS_DELTAS_FOR_FACTION(FactionId, Deltas) (GOAI_LIBBED_GLOB_ATTR(faction_asset_deltas_registry)[FactionId] = Deltas)

// tracks the running subsystem, by ticker ID hash, to prevent duplication
# ifdef GOAI_LIBRARY_FEATURES
var/global/production_subsystem_running
# endif
# ifdef GOAI_SS13_SUPPORT
GLOBAL_VAR(production_subsystem_running)
# endif


// Format-string to use to construct a unique hash for the Production/Consumption subsystem
// Currently uses a random number AND a world.time to ensure collisions are extremely unlikely
#define PRODUCTIONSYSTEM_TICKER_ID_HASH(MaxRand) "[rand(1, MaxRand)]-[world.time]"

// tracks the time delta for integrating the values
# ifdef GOAI_LIBRARY_FEATURES
var/global/production_subsystem_last_update_time
# endif
# ifdef GOAI_SS13_SUPPORT
GLOBAL_VAR(production_subsystem_last_update_time)
# endif

// Inline version; generally preferable unless you REALLY need a proc
#define INITIALIZE_PRODUCTION_SYSTEM_INLINE(Tickrate) \
	StartProductionConsumptionSystem(Tickrate); \
	MARKETWATCH_DEBUG_LOG("Initialized a production/consumption subsystem with tickrate [DEFAULT_IF_NULL(Tickrate, DEFAULT_PRODUCTION_SYSTEM_TICKRATE)]"); \
;

// Variant - does the same, but only if it's not already initialized
#define INITIALIZE_PRODUCTION_SYSTEM_INLINE_IF_NEEDED(Tickrate) if(isnull(GOAI_LIBBED_GLOB_ATTR(production_subsystem_running))) {\
	INITIALIZE_PRODUCTION_SYSTEM_INLINE(Tickrate); \
};

#define INITIALIZE_PRODUCTION_SYSTEM_INLINE_IF_NEEDED_AT_DEFAULT_RATE INITIALIZE_PRODUCTION_SYSTEM_INLINE_IF_NEEDED(null)

#define ECONOMY_ASSET_TRANSFORMS_DATA_FP GOAI_DATA_PATH("economy_asset_transforms.json")

/proc/StartProductionConsumptionSystem(var/tickrate = null, var/my_id = null)
	/* Starts a backgrounded Production/Consumption system.
	//
	// This is something like the old-style SS13 Chemistry (simpler than 2020s-chem),
	// except for living economy - modeling how capital transforms goods.
	*/
	set waitfor = FALSE

	// Our ID; should be a unique string
	var/ticker_id = my_id || PRODUCTIONSYSTEM_TICKER_ID_HASH(1000)
	var/tick_rate = max(1, DEFAULT_IF_NULL(tickrate, DEFAULT_PRODUCTION_SYSTEM_TICKRATE))
	GOAI_LIBBED_GLOB_ATTR(production_subsystem_running) = ticker_id

	// Waitfor is false, so we use this sleep to detach the 'thread'
	sleep(0)

	// Initialize last update time if needed
	if(isnull(GOAI_LIBBED_GLOB_ATTR(production_subsystem_last_update_time)))
		GOAI_LIBBED_GLOB_ATTR(production_subsystem_last_update_time) = world.time

	// We might want to try reloading this later in the loop, for now this is kinda useless
	//var/db_initialized = TRUE

	// Load 'recipes' (what asset consumes and/or produces other assets) into an in-memory DB
	var/list/prodconsume_db = READ_JSON_FILE(ECONOMY_ASSET_TRANSFORMS_DATA_FP)
	if(!istype(prodconsume_db))
		GOAI_LOG_ERROR("WARNING: Failed to load ECONOMY_ASSET_TRANSFORMS_DATA file at [ECONOMY_ASSET_TRANSFORMS_DATA_FP] - DB not initialized!")
		//db_initialized = FALSE
		prodconsume_db = list()

	// This is a ticker; it will continue to run while the global holds its ID
	// If we start a new instance, it will take over the value in the global
	// thereby terminating any old instances.
	while(ticker_id == GOAI_LIBBED_GLOB_ATTR(production_subsystem_running))
		// Wait for the next iteration
		sleep(tick_rate)
		GOAI_LOG_ERROR("= PRODUCTION/CONSUMPTION SYSTEM: STARTED TICK! =")

		// Fix time to the start time of the tick
		var/now = world.time

		if((1 + now - GOAI_LIBBED_GLOB_ATTR(production_subsystem_last_update_time)) < PRODUCTIONSYSTEM_TICKSIZE_DSECONDS)
			GOAI_LOG_ERROR("= PRODUCTION/CONSUMPTION SYSTEM: TICK ENDED EARLY - below quant =")
			continue

		if(!istype(GOAI_LIBBED_GLOB_ATTR(global_faction_registry)))
			GOAI_LIBBED_GLOB_ATTR(global_faction_registry) = list()

		for(var/raw_faction in GOAI_LIBBED_GLOB_ATTR(global_faction_registry))
			// can yield between factions, assuming they have separate resource pools
			sleep(0)

			// might be a weakref, so we cannot typecast in the loop directly
			#ifdef GOAI_LIBRARY_FEATURES
			var/faction_ref = raw_faction
			#endif

			#ifdef GOAI_SS13_SUPPORT
			var/weakref/faction_ref = raw_faction
			#endif

			var/datum/faction_data/faction = RESOLVE_PAWN(faction_ref)

			if(!istype(faction))
				GOAI_LOG_DEBUG("= PRODUCTION/CONSUMPTION SYSTEM: SKIPPING FACTION for ref [NULL_TO_TEXT(faction_ref)] - wrong type! =")
				continue

			var/faction_id = GET_GLOBAL_ID_LAZY(faction)
			var/list/actual_assets = GET_ASSETS_TRACKER(faction_id)
			var/list/faction_assets = actual_assets?.Copy()

			if(!faction_assets)
				GOAI_LOG_DEBUG("= PRODUCTION/CONSUMPTION SYSTEM: SKIPPING [faction.name]|ID=[faction_id] - no assets =")
				continue

			GOAI_LOG_DEBUG("= PRODUCTION/CONSUMPTION SYSTEM: PROCESSING [faction.name]|ID=[faction_id] with assets: [json_encode(faction_assets)] @TIME:[world.time] =")
			var/list/deltas_for_faction = list()

			// How far back we are in the simulation
			// We have already checked this is at least one quantum of production-tick in the past
			// (IOW, we always have at least one whole simulation-tick to do if we got here at all)
			var/curr_simulation_time = GOAI_LIBBED_GLOB_ATTR(production_subsystem_last_update_time)

			while(curr_simulation_time < now)
				// Simulate ticks iteratively - ensures everything has a chance to get produced evenly.
				// We could integrate in one big chunk, and it would theoretically be faster, but would
				// require untangling a horrible mess of conflicts if multiple sinks use the same inputs.

				// NOTE: We need to do this all in one 'system' tick to maintain consistency
				//       otherwise assets might have a race condition issue.

				// We'll go through all 'transforming' assets (e.g. foundry eats ore, produces steel) and apply the deltas.
				// Overall schema is: {asset: {"consumes": {other_asset: delta}, "produces": {other_asset: delta}}}
				// Consumed amounts are checked first; if any item would go into negatives, the whole transform is aborted.
				curr_simulation_time += PRODUCTIONSYSTEM_TICKSIZE_DSECONDS

				//GOAI_LOG_DEBUG("= PRODUCTION/CONSUMPTION SYSTEM: PROCESSING [faction.name] - simulation tick... =")
				var/recipe_idx = 0

				for(var/list/recipe_asset_deltas in prodconsume_db)
					// Go through all Resource 'recipes' and check how much they use/produce stuff...
					recipe_idx++

					if(!recipe_asset_deltas)
						// junk entry somehow
						GOAI_LOG_ERROR("ERROR: Recipe [recipe_idx] in prodconsume_db has no asset deltas - SKIPPING")
						continue

					var/recipe_name = recipe_asset_deltas["recipe_name"]
					//GOAI_LOG_DEBUG("= PRODUCTION/CONSUMPTION SYSTEM: PROCESSING RECIPE [recipe_idx] ([NULL_TO_TEXT(recipe_name)]) for ref [NULL_TO_TEXT(faction_ref)]... =")

					// What asset gives rise to this recipe?
					var/productive_asset_key = recipe_asset_deltas["source_asset"]

					if(isnull(productive_asset_key))
						// Required field
						GOAI_LOG_ERROR("ERROR: Recipe [recipe_idx] ([NULL_TO_TEXT(recipe_name)]) in prodconsume_db has no required key 'source_asset' - SKIPPING")
						continue

					var/owned_amt = faction_assets[productive_asset_key]

					if(isnull(owned_amt) || (owned_amt <= 0))
						// We don't have it, no point processing
						//GOAI_LOG_DEBUG("= PRODUCTION/CONSUMPTION SYSTEM: SKIPPING RECIPE [recipe_idx] ([NULL_TO_TEXT(recipe_name)]) for ref [NULL_TO_TEXT(faction_ref)] - owned amount insufficient/null! =")
						continue

					// ...making sure all inputs are THERE...
					var/consume_valid = TRUE
					var/consumed_mult = PLUS_INF

					// ...starting with requirements...
					// (assets that need to BE there, but are not used up)
					var/list/requirements = recipe_asset_deltas["requires"]

					if(requirements)
						for(var/checked_required_asset in requirements)
							// We default consume_valid to TRUE, so if nothing is a prerequisite,
							// it just succeeds automatically.
							if(consumed_mult <= 0)
								consume_valid = FALSE
								break

							if(isnull(checked_required_asset))
								continue

							var/required_amt = (requirements[checked_required_asset] || 0)

							if(required_amt <= 0)
								continue

							var/assets_amt = (faction_assets[checked_required_asset] || 0)

							if(assets_amt < required_amt)
								consume_valid = FALSE
								break

							// Clamp allowed repeats to the rate-limiting amount of the least abundant prereq.
							//
							// Note: This is an approximation that might get buggy, but is super cheap.
							//       The more accurate method would be to do this in a loop over owned_amt,
							//       but that would be significantly slower at large scales.
							//       This is a fairly hot loop, so we can't afford that probably.
							var/multiples = FLOOR(assets_amt / required_amt)
							consumed_mult = min(multiples, consumed_mult, owned_amt)

					if((!consume_valid) || (consumed_mult <= 0))
						// requirements not met - skip to next
						//GOAI_LOG_DEBUG("= PRODUCTION/CONSUMPTION SYSTEM: SKIPPING [recipe_idx] ([NULL_TO_TEXT(recipe_name)]) for ref [NULL_TO_TEXT(faction_ref)] - requirements not met! =")
						continue

					// ...then with inputs...
					var/list/consumed_deltas = recipe_asset_deltas["consumes"]

					if(consumed_deltas)
						for(var/checked_consumed_asset in consumed_deltas)
							if(consumed_mult <= 0)
								consume_valid = FALSE
								break

							if(isnull(checked_consumed_asset))
								continue

							var/raw_checked_delta = (consumed_deltas[checked_consumed_asset] || 0)

							if(raw_checked_delta <= 0)
								continue

							var/assets_amt = (faction_assets[checked_consumed_asset] || 0)

							if(assets_amt < raw_checked_delta)
								consume_valid = FALSE
								consumed_mult = 0
								break

							// Note: as above, approximation & rate-limiting
							var/multiples = FLOOR(assets_amt / raw_checked_delta)
							consumed_mult = min(multiples, consumed_mult, owned_amt)

					if(!consume_valid)
						// if something is missing, this specific process is skipped/aborted
						//GOAI_LOG_DEBUG("= PRODUCTION/CONSUMPTION SYSTEM: SKIPPING [recipe_idx] ([NULL_TO_TEXT(recipe_name)]) for ref [NULL_TO_TEXT(faction_ref)] - insufficient resources! =")
						continue

					var/list/produced_deltas = recipe_asset_deltas["produces"]

					var/list/faction_assets_backup = faction_assets.Copy()
					var/valid_transaction = TRUE

					// Subtract everything consumed
					for(var/consumed_asset in consumed_deltas)
						var/current_amt = faction_assets[consumed_asset]
						var/consumed_amt = consumed_deltas[consumed_asset] * consumed_mult
						var/new_amt = (current_amt - consumed_amt)

						if(new_amt < 0)
							GOAI_LOG_DEBUG("= PRODUCTION/CONSUMPTION SYSTEM: RECIPE [recipe_idx] ([NULL_TO_TEXT(recipe_name)]) for ref [NULL_TO_TEXT(faction_ref)] - invalidating, [consumed_asset] [current_amt]-[consumed_amt] = [new_amt] < 0 =")
							valid_transaction = FALSE
							break

						faction_assets[consumed_asset] = new_amt

						var/old_delta_for_asset = (deltas_for_faction[consumed_asset] || 0)
						var/new_delta_for_asset = old_delta_for_asset - consumed_amt
						deltas_for_faction[consumed_asset] = new_delta_for_asset

					if(!valid_transaction)
						// rollback
						faction_assets = faction_assets_backup.Copy()
						GOAI_LOG_DEBUG("= PRODUCTION/CONSUMPTION SYSTEM: ROLLED BACK [recipe_idx] ([NULL_TO_TEXT(recipe_name)]) for ref [NULL_TO_TEXT(faction_ref)] - invalid transaction! =")
						continue

					// Add everything produced
					if(produced_deltas)
						for(var/produced_asset in produced_deltas)
							var/produced_amt = produced_deltas[produced_asset] * consumed_mult
							var/current_amt = (faction_assets[produced_asset] || 0)

							faction_assets[produced_asset] = (current_amt + produced_amt)

							var/old_delta_for_asset = (deltas_for_faction[produced_asset] || 0)
							var/new_delta_for_asset = old_delta_for_asset + produced_amt
							deltas_for_faction[produced_asset] = new_delta_for_asset

					// NOTE: if we rolled back, this won't update so we'll be using old data
					//       if this causes headaches later, I can't say I didn't warn myself.
					//
					// NOTE: we do this *per simulation tick*, unlike assets total!
					//       we only want per-tick deltas, not aggregates
					//       (not for *this* table, at least)
					CREATE_ASSET_DELTAS_TABLE_IF_NEEDED(faction_id)
					SET_ASSETS_DELTAS_FOR_FACTION(faction_id, deltas_for_faction)

					//GOAI_LOG_DEBUG("= PRODUCTION/CONSUMPTION SYSTEM: APPLIED RECIPE [recipe_idx] ([NULL_TO_TEXT(recipe_name)]) for ref [NULL_TO_TEXT(faction_ref)]... =")


				// After all recipes are applied, but before next simulation tick stuff goes here.
				// debugging
				GOAI_LOG_DEBUG("= PRODUCTION/CONSUMPTION SYSTEM: Asset deltas table for [faction.name] is: [json_encode(deltas_for_faction)] =")

			UPDATE_ASSETS_TRACKER(faction_id, faction_assets)

		// update the last check time to now
		GOAI_LIBBED_GLOB_ATTR(production_subsystem_last_update_time) = now

	return

