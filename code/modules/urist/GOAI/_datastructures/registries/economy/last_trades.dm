/*
// Stores the latest traded unit prices for each Commodity
//
// This is used to stabilize the prices used by AIs.
// We cannot reasonably simulate a full-fat market here, the number of entities has to be relatively low.
// This means the price signals are sparse and two factions can have wildly different ideas as to what a sensible price is.
//
// Providing global access to (public) trades lets us smooth these values out;
// if Seller wants 50$ but knows a Buyer was happy with a 100$ price, it would be silly to ask for just 50$,
// or the whole 100$ (since the demand has now fallen)!
// The best deal is somewhere between those values - we can pick the midpoint, do rand(), or whatever.
//
// As a bonus, by making it data-driven we can easily seed reasonable prices, either for design purposes or to provide persistence.
// Keeping this global makes it easy to show this information to *players* too, to give them a sense of the markets.
*/

# ifdef GOAI_LIBRARY_FEATURES
var/global/list/global_pricepoint_registry
# endif
# ifdef GOAI_SS13_SUPPORT
GLOBAL_LIST_EMPTY(global_pricepoint_registry)
# endif


#define DEFAULT_PRICEPOINT_DB_FP GOAI_DATA_PATH("initial_prices.json")


/proc/InitPricepointsDb(var/filepath_override = null, var/force = FALSE)
	if(!(isnull(GOAI_LIBBED_GLOB_ATTR(global_pricepoint_registry)) || force))
		return TRUE

	var/db_filepath = isnull(filepath_override) ? DEFAULT_PRICEPOINT_DB_FP : filepath_override
	READ_JSON_FILE_CACHED(db_filepath, GOAI_LIBBED_GLOB_ATTR(global_pricepoint_registry))

	if(!GOAI_LIBBED_GLOB_ATTR(global_pricepoint_registry))
		GOAI_LIBBED_GLOB_ATTR(global_pricepoint_registry) = null

	return TRUE


#define PRICEPOINTS_TABLE_LAZY_INIT(_Unused) if(isnull(GOAI_LIBBED_GLOB_ATTR(global_pricepoint_registry)) || !islist(GOAI_LIBBED_GLOB_ATTR(global_pricepoint_registry))) { InitPricepointsDb() }

#define GET_PRICE_POINT(CommodityId) (GOAI_LIBBED_GLOB_ATTR(global_pricepoint_registry)[CommodityId])
#define SET_PRICE_POINT(CommodityId, Val) (GOAI_LIBBED_GLOB_ATTR(global_pricepoint_registry)[CommodityId] = Val)
