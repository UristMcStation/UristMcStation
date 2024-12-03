/*
// Stores the 'reference' Utilities for Needs.
//
// Various factions may value things higher or lower than these reference points.
// If it's lower, then they need to be able to use this reference point to price sale goods correctly,
// otherwise they will undercut themselves. This is particularly pertinent to produced goods.
//
// This is a bit of a hack, but you can handwave it as actors knowing the market more or less.
// It helps design-wise to provide a somewhat sane stable standard.
//
// You may wonder why can't we simply standardize default utilities to '1' or something.
// The answer is - not all goods have positive marginal Utility, so this is more flexible.
*/

# ifdef GOAI_LIBRARY_FEATURES
var/global/list/reference_market_utilities
# endif
# ifdef GOAI_SS13_SUPPORT
GLOBAL_LIST_EMPTY(reference_market_utilities)
# endif


#define DEFAULT_MARKET_UTILITY_DB_FP GOAI_DATA_PATH("reference_utilities.json")


/proc/InitReferenceUtilitiesDb(var/filepath_override = null, var/force = FALSE)
	if(!(isnull(GOAI_LIBBED_GLOB_ATTR(reference_market_utilities)) || force))
		return TRUE

	var/db_filepath = isnull(filepath_override) ? DEFAULT_MARKET_UTILITY_DB_FP : filepath_override
	READ_JSON_FILE_CACHED(db_filepath, GOAI_LIBBED_GLOB_ATTR(reference_market_utilities))
	to_world_log("New ReferenceUtilitiesDB is [GOAI_LIBBED_GLOB_ATTR(reference_market_utilities) ? json_encode(GOAI_LIBBED_GLOB_ATTR(reference_market_utilities)) : "uninitialized"] from [db_filepath]")

	if(!GOAI_LIBBED_GLOB_ATTR(reference_market_utilities))
		GOAI_LIBBED_GLOB_ATTR(reference_market_utilities) = null

	return TRUE


#define MARKET_UTILITIES_TABLE_LAZY_INIT(_Unused) if(isnull(GOAI_LIBBED_GLOB_ATTR(reference_market_utilities)) || !islist(GOAI_LIBBED_GLOB_ATTR(reference_market_utilities))) { InitReferenceUtilitiesDb() }
