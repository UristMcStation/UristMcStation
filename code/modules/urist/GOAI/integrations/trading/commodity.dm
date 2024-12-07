/*
// ---------------------------
// $$$    COMMODITY API    $$$
// ---------------------------
//
// The point of trading goods is to satisfy needs.
// It is pretty rare for any need to rely on a single, *specific* item.
// For example, for value-storage purposes, a pile of coins, a gold bar or two silver bars might do equally well.
// In a pure survival situation, oak, pine and coal might work equally well for keeping us warm.
//
// For AI purposes, there must be a way to encode these abstract equivalencies into cold hard data.
// While we could capture them using inheritance and typechecks, this gets messy and rigid FAST.
//
// Instead, this module defines an interface that lets objects expose their 'valuability'
// across different dimensions in a flexible fashion.
//
// This is the 'other side of the coin' of SmartObjects in The Sims.
// SOs there bundle this behaviour (advertising need-satisfaction) and managing their own usage logic.
// In this project, the former is the Commodity API, and the latter is the SmartObject API.
//
//
// ---   THE DESIGN   ---
//
// Only /atom/movable subtypes (i.e. /obj, /mob, and their subclasses) can be commoditized.
//
// Turfs and areas, even if we COULD sell them, would be real estate with differing logic.
// Datums *in general* are too broad to talk about; abstract Things can be traded directly
// as custom Commodities.
//
// To make things maximally flexible, the interface is proc-based.
// This leaves the low-level implementation unspecified; static, dynamic, hardcoded, SQLite, in-memory database, inherited, whatever.
//
// An item can be queried to check IF it has a value as a certain type of Commodity,
// and equally HOW MUCH value does it have for it.
//
// These are both handled by the same proc:
//
//
// =>  GetCommodityNeedValue(var/key)
//
//
// The 'key' variable defines which 'type of value' we are asking about. This is usually a need of some sort.
//
// For instance, a loaf of bread may have 5 value in cash, 40 value in Food(Human) and 0 value in Food(Alien).
//
// As such, a alien baker would consider selling his bread to a hungry human and buying alien snacks with the money
// a better deal than hoarding the indigestible carbs for himself.
//
// If the result is null, we assume the object has no value with regards to that key.
//
// If you need to query for a *bundle* of keys (e.g. all the needs for an AI type),
// there is a separate, convenience proc available:
//
//
// =>   GetCommodityNeedValueSet(var/list/keyset)
//
//
// This is effectively a variant of GetCommodityNeedValue that returns an assoc list for each input key.
//
//
//
// ---   SUMMARY   ---
//
// 1) GetCommodityNeedValue(var/need_key [str]) - for checking one need, returns plain float
// 2) GetCommodityNeedValueSet(var/list/need_keyset [list[str]]) - for checking multiple at once, returns list[float]
//
// No guarantees/requirements how those values have to be checked.
// Null values are 'does not apply'. So are zeroes.
// Keys are defined as macros.
*/

/atom/movable/proc/GetCommodityNeedValue(var/need_key) // str -> float
	/*
	// The core Commodity query.
	// For an object to *properly* implement the interface, it should take in the key,
	// look it up *somewhere* and spit out an appropriate value for it, or null if not applicable.
	*/
	var/needval = GetCommodityNeedValueAbstract("[src.type]", need_key)
	return needval


/atom/movable/proc/GetCommodityNeedValueSet(var/list/need_keyset) // array[str] -> assoc[str, float]
	/*
	// The 'batch' version of GetCommodityNeedValue().
	// For cases where you know you need N different keys checked and CBA to write a loop over them.
	// Almost certainly slower than GetCommodityNeedValue() on single item inputs, so don't abuse it.
	*/
	if(!need_keyset || !istype(need_keyset))
		// Cheap fast return...
		return null

	// ...because normally we have to alloc a list.
	var/list/valueset = list()

	// Default handling defers to GetCommodityNeedValue; if you need performance,
	// override it with inlined code for a specific use-case in the subclass.
	for(var/key in need_keyset)
		var/subresult = src.GetCommodityNeedValue(key)
		valueset[key] = subresult

	return valueset


#define DEFAULT_COMMODITY_DB_FP GOAI_DATA_PATH("commodity_db.json")

# ifdef GOAI_LIBRARY_FEATURES
var/global/list/commodity_db
# endif
# ifdef GOAI_SS13_SUPPORT
GLOBAL_LIST_EMPTY(commodity_db)
# endif


/proc/InitCommodityDb(var/filepath_override = null, var/force = FALSE)
	if(!(isnull(GOAI_LIBBED_GLOB_ATTR(commodity_db)) || force))
		return TRUE

	var/db_filepath = isnull(filepath_override) ? DEFAULT_COMMODITY_DB_FP : filepath_override
	READ_JSON_FILE_CACHED(db_filepath, GOAI_LIBBED_GLOB_ATTR(commodity_db))
	to_world_log("New CommodityDB is [GOAI_LIBBED_GLOB_ATTR(commodity_db) ? json_encode(GOAI_LIBBED_GLOB_ATTR(commodity_db)) : "uninitialized"] from [db_filepath]")

	if(!GOAI_LIBBED_GLOB_ATTR(commodity_db))
		GOAI_LIBBED_GLOB_ATTR(commodity_db) = null

	return TRUE


/proc/GetCommodityNeedAllValuesAbstract(var/typename)
	if(isnull(GOAI_LIBBED_GLOB_ATTR(commodity_db)))
		var/inited = InitCommodityDb()
		if(!inited)
			return

	var/list/type_data = GOAI_LIBBED_GLOB_ATTR(commodity_db)[typename]
	return type_data


/proc/GetCommodityNeedValueAbstract(var/typename, var/need_key)
	if(isnull(GOAI_LIBBED_GLOB_ATTR(commodity_db)))
		var/inited = InitCommodityDb()
		if(!inited)
			return

	var/list/type_data = GOAI_LIBBED_GLOB_ATTR(commodity_db)[typename]

	if(!istype(type_data))
		return null

	var/val = type_data[need_key]
	return val

