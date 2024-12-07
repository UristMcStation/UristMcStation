/*
// This global list is a big assoc of all 'live' trade offers
// (i.e. those that are still up for grabs, not taken or expired).
//
// This provides a single point of access to offers for all AIs and/or
// player-facing system integrations (for deals that players can take from AIs).
//
// This has the key benefit of us not having to chase each individual integration
// and give/take TradeOffer objects away from them.
//
// The downstream code is expected to handle checking if the integration CAN actually
// use the offer (e.g. not too far, not from an enemy faction, whatever) on their end.
//
// This is an *assoc* rather than an array as the number of items can be relatively large
// and dynamic (i.e. items can and will be deleted) unlike with most of the other registries.
//
// As such, we need to be able to periodically compact this list, removing keys with null values,
// by copying the whole thing to a newer, smaller list.
//
// This kind of reindexing operation would absolutely wreck havoc on an array using positional
// indices as IDs (as these would all shift around if we eliminated the 'holes') and might require
// bounds checks even if we were happy with that.
//
// The assoc API plays much nicer with such cases by design; even if getting
// the string indices and hashing is a bit slower than a direct offset by integer,
// it saves us a lot of bookkeeping to make integer IDs *actually safe to use*.
*/

# ifdef GOAI_LIBRARY_FEATURES
var/global/list/global_marketplace
# endif

# ifdef GOAI_SS13_SUPPORT
GLOBAL_LIST_EMPTY(global_marketplace)
# endif

# ifdef GOAI_LIBRARY_FEATURES
var/global/global_marketwatch_running
# endif
# ifdef GOAI_SS13_SUPPORT
GLOBAL_VAR(global_marketwatch_running)
# endif


// Inlined functions, because BYOND's too dumb to do it itself and this code is kinda hot.
// 1) Add an offer (/datum/trade_offer) to the registry
#define REGISTER_OFFER_TO_MARKETPLACE(offer) if(offer) { \
	INITIALIZE_GLOBAL_MARKETPLACE_INLINE_IF_NEEDED(null); \
	if(!(offer.id)) { offer.id = ref(offer) }; \
	GOAI_LIBBED_GLOB_ATTR(global_marketplace)[offer.id] = offer; \
}

// 2) Remove an offer BY ID (/datum/trade_offer's 'id' attribute) from the registry
//    This is not using the object in case the offer got del'd but we still have the ID somewhere.
#define DEREGISTER_OFFER_FROM_MARKETPLACE(offer_id) if(offer_id) { \
	INITIALIZE_GLOBAL_MARKETPLACE_INLINE_IF_NEEDED(null); \
	GOAI_LIBBED_GLOB_ATTR(global_marketplace)[offer_id] = null; \
}

// 3) Get a SPECIFIC offer BY ID (/datum/trade_offer's 'id' attribute) from the registry
//    This is used to refer back to an actual offer from keys stored in other systems, e.g. Brains.
#define GET_OFFER_FROM_MARKETPLACE(offer_id, VarName) if(offer_id) { \
	INITIALIZE_GLOBAL_MARKETPLACE_INLINE_IF_NEEDED(null); \
	##VarName = GOAI_LIBBED_GLOB_ATTR(global_marketplace)[offer_id]; \
}

// Format-string to use to construct a unique hash for the Marketwatch system
// Currently uses a random number AND a world.time to ensure collisions are extremely unlikely
#define MARKETWATCH_TICKER_ID_HASH(MaxRand) "[rand(1, MaxRand)]-[world.time]"


/mob/verb/CheckMarketWatch()
	to_chat(usr, "Running MarketWatch ID is: [NULL_TO_TEXT(GOAI_LIBBED_GLOB_ATTR(global_marketwatch_running))]")

/proc/StartGlobalMarketwatch(var/tickrate = null, var/my_id = null)
	/* Starts a backgrounded Marketwatch system, which maintains the global_marketplace.
	//
	// As we can have a lot of offer churn, whether due to expiries or being claimed,
	// and potentially a lot of offer *creation*, the global list might have a lot of
	// null entries
	*/
	set waitfor = FALSE

	// Our ID; should be a unique string
	var/ticker_id = isnull(my_id) ? MARKETWATCH_TICKER_ID_HASH(1000) : my_id
	var/tick_rate = max(1, DEFAULT_IF_NULL(tickrate, DEFAULT_MARKETWATCH_TICKRATE))
	GOAI_LIBBED_GLOB_ATTR(global_marketwatch_running) = ticker_id

	// Waitfor is false, so we use this sleep to detach the 'thread'
	sleep(0)

	// This is a ticker; it will continue to run while the global holds its ID
	// If we start a new Marketwatch, it will take over the value in the global
	// thereby terminating any old instances.
	while(ticker_id == GOAI_LIBBED_GLOB_ATTR(global_marketwatch_running))
		// Wait for the next iteration
		sleep(tick_rate)

		// NOTE: We need to do this all in one tick to maintain consistency.
		//       Otherwise, someone could register a new offer to the OLD dirty market and we'd skip over it and miss it.
		//       This is basically a babby's first stop-the-world garbage collector honk
		var/list/cleaned_market = list()
		var/now = world.time

		if(!GOAI_LIBBED_GLOB_ATTR(global_marketplace))
			continue

		// Scan all offers and remove invalid ones
		MARKETWATCH_DEBUG_LOG("Marketwatch initiating cleanup...")
		for(var/market_key in GOAI_LIBBED_GLOB_ATTR(global_marketplace))
			// Usual assoc key-to-value dance:
			var/datum/trade_offer/offer = GOAI_LIBBED_GLOB_ATTR(global_marketplace)[market_key]

			if(!istype(offer))
				// Null or other junk, remove
				MARKETWATCH_DEBUG_LOG("Marketwatch cleaning up [market_key] - garbage")
				continue

			if(!(offer.is_open))
				// Bound as contract instead
				MARKETWATCH_DEBUG_LOG("Marketwatch cleaning up [market_key] - bound")
				continue

			if(offer.expiry_time && (offer.expiry_time <= now))
				// Expired, remove
				MARKETWATCH_DEBUG_LOG("Marketwatch cleaning up [market_key] - expired at [offer.expiry_time], current: [now]")
				continue

			// Valid, in you go:
			cleaned_market[market_key] = offer

		// Replace the market with a cleaned version
		GOAI_LIBBED_GLOB_ATTR(global_marketplace) = cleaned_market
		MARKETWATCH_DEBUG_LOG("Marketwatch cleanup complete, going to sleep for [tick_rate] ds...")

	return


/* PROCS TO SET UP THE MARKETPLACE */

// Inline version; generally preferable unless you REALLY need a proc
#define INITIALIZE_GLOBAL_MARKETPLACE_INLINE(Tickrate) \
	GOAI_LIBBED_GLOB_ATTR(global_marketplace) = list(); \
	StartGlobalMarketwatch(Tickrate); \
	MARKETWATCH_DEBUG_LOG("Initialized a global marketplace with tickrate [DEFAULT_IF_NULL(Tickrate, DEFAULT_MARKETWATCH_TICKRATE)]"); \
;

// Variant - does the same, but only if it's not already initialized
#define INITIALIZE_GLOBAL_MARKETPLACE_INLINE_IF_NEEDED(Tickrate) \
	if(isnull(GOAI_LIBBED_GLOB_ATTR(global_marketplace))) {\
		INITIALIZE_GLOBAL_MARKETPLACE_INLINE(Tickrate); \
	};\
	if(isnull(GOAI_LIBBED_GLOB_ATTR(global_marketwatch_running))) { StartGlobalMarketwatch(Tickrate) };\
;


/proc/InitializeGlobalMarketplace()
	// Kills any running marketwatch by resetting the sentinel
	// Initializes the marketplace proper as an empty assoc list
	// Initializes a new marketwatch loop
	// Just a proc wrapper around the inline code
	INITIALIZE_GLOBAL_MARKETPLACE_INLINE(null)
	return
