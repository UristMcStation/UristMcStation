/*
// Old SS13 relations system was more or less binary - same faction is friend, another is foe.
// This is not good enough for GOAI's vision of a complex, messy web of interactions.
// There's a whole bunch of relationship scores we need to define for any faction.
// Rather than hardcoding it in, we'll make this data-driven as well.
//
// The schema is simply: Map<FactionKey: Map<Tag: RelationshipValue>>
//
// The top-level FactionKey is 'Us', the nested Tag key is 'Them'.
// i.e. {A: {B: 1, C: 2}, B: {A: 0, C: 2}} means that
// - faction A has +1 relationship score with B and +2 with C
// - faction B has +0 relationship score with B and +2 with C
// - faction C has default value (whatever that is) for everyone.
//
// NOTE: This is a simpler interface for dealing with oldschool mob AIs.
//       Full Faction AIs have a more full-fat document format available.
*/

#define DEFAULT_RELATIONSHIPS_DB_FP GOAI_DATA_PATH("relationships_db.json")

# ifdef GOAI_LIBRARY_FEATURES
var/global/list/relationships_db
# endif
# ifdef GOAI_SS13_SUPPORT
GLOBAL_LIST_EMPTY(relationships_db)
# endif


/proc/InitRelationshipsDb(var/filepath_override = null, var/force = FALSE)
	if(!(isnull(GOAI_LIBBED_GLOB_ATTR(relationships_db)) || force))
		return TRUE

	var/db_filepath = isnull(filepath_override) ? DEFAULT_RELATIONSHIPS_DB_FP : filepath_override
	READ_JSON_FILE_CACHED(db_filepath, GOAI_LIBBED_GLOB_ATTR(relationships_db))

	if(!GOAI_LIBBED_GLOB_ATTR(relationships_db))
		GOAI_LIBBED_GLOB_ATTR(relationships_db) = null

	return TRUE
