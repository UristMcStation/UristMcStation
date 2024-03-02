#define MATH_PI 3.14159265
#define LOG2(x) log(2, x)

#define GOAI_AI_ENABLED 1
#define AI_TICK_DELAY 5
#define ACTION_TICK_DELAY 5
#define CHUNK_SIZE_DEFAULT 5
#define CHUNK_OVERLAP_DEFAULT 1

#define NEED_MINIMUM 0
#define NEED_THRESHOLD 50
#define NEED_SAFELEVEL 75
#define NEED_SATISFIED 95
#define NEED_MAXIMUM 100

#define MOTIVE_SLEEP "Energy"
#define MOTIVE_FOOD "Calories"
#define MOTIVE_FUN "Entertainment"

#define RESOURCE_FOOD "FoodItems"
#define RESOURCE_MONEY "Money"
#define RESOURCE_TIME "Time"

#define PLUS_INF 1.#INF
#define GOAP_KEY_SRC "source"

#define LOAD_TEXT(fp) file2text(fp)
#define SAVE_TEXT(txt, fp) text2file(txt, fp)

#define READ_JSON_FILE(FP) (fexists(FP) && json_decode(file2text(FP)))
#define READ_JSON_FILE_CACHED(FP, TO_VAR) FILE_CACHE_LAZY_INIT(1); ##TO_VAR = filedata_cache[FP]; if(isnull(##TO_VAR)) { ##TO_VAR = READ_JSON_FILE(FP); filedata_cache[FP] = ##TO_VAR }

#define UNCACHE_JSON_FILE(FP) FILE_CACHE_LAZY_INIT(1); filedata_cache[FP] = null

#define SAVE_JSON_FILE(data, fp) SAVE_TEXT(json_encode(data), fp)
#define SAVE_JSON_FILE_OVERWRITE(data, fp) fdel(fp); SAVE_TEXT(json_encode(data), fp)

#define COORDS_TUPLE_2D(A) "([A?.x], [A?.y])"
#define COORDS_TUPLE_3D(A) "([A?.x], [A?.y], [A?.z])"
// defaulting:
#define COORDS_TUPLE COORDS_TUPLE_2D
#define LOCATION_WITH_COORDS(At) "[get_turf(At)] @ [COORDS_TUPLE(At)]"


# ifdef GOAI_LIBRARY_FEATURES

#define get_turf(A) get_step(A,0)
// 1 (SOUTH) + 2 (NORTH) + 4 (EAST) + 8 (WEST) == 15
#define ALL_CARDINAL_DIRS 15

# endif

#define GUN_DISPERSION 5
#define DEFAULT_ORPHAN_CLEANUP_THRESHOLD 3

#define SENSE_SIGHT "SenseSight"
#define SENSE_SIGHT_CURR "SightCurr"
#define SENSE_SIGHT_PREV "SightPrev" // NOTE: currently disabled!

// 1 (SOUTH) + 2 (NORTH) + 4 (EAST) + 8 (WEST) == 15
#define ALL_CARDINAL_DIRS 15

// Attachments
#define ATTACHMENT_CONTROLLER "AiController"
#define ATTACHMENT_CONTROLLER_BACKREF "AiControllerId"
#define ATTACHMENT_EVTQUEUE_HIT "HitEventQueue"



// Helpers
#define IS_VALID_NON_NULL(X) (!(isnull(X)) && istype(X))
#define PUT_EMPTY_LIST_IN(X) if(IS_VALID_NON_NULL(X)) { X.Cut() } else { X = list() }

#define DEFAULT_GOAI_DISTANCE_PROC /proc/fTestObstacleDistFuzzed

#define DEBUG_LOG_LIST_ARRAY(L, LOGGER) for(var/_li_ in L) { LOGGER("[_li_]") }
#define DEBUG_LOG_LIST_ASSOC(L, LOGGER) for(var/_li_ in L) { LOGGER("[_li_]: [L[_li_]]") }

#define SET_IF_NOT_NULL(Nullable, Var) if(!(isnull(Nullable))) { ##Var = Nullable }
#define DEFAULT_IF_NULL(Nullable, Default) (isnull(Nullable) ? Default : Nullable)

// Kinda black magic; looks up an AI reference and puts it into the variable PATH specified in the second argument.
#define FetchAiControllerForObjIntoVar(gameobj, VarPath) var/__commander_backref = gameobj?.attachments?.Get(ATTACHMENT_CONTROLLER_BACKREF); VarPath = IS_REGISTERED_AI(__commander_backref) && GOAI_LIBBED_GLOB_ATTR(global_goai_registry[__commander_backref])

#define DEFAULT_UTILITY_AI_SENSES "dev_sense.json"
#define DEFAULT_FACTION_AI_SENSES "faction_senses.json"

// Size of the GOAI plan buffer; if we would exceed it, eject a plan.
#define MAX_STORED_PLANS 1

#define MEM_ACTION_MINUS_ONE "action-1"
#define MEM_ACTION_MINUS_TWO "action-2"

// GOAP is NP-time, so we cut it off and give up to prevent game lockup
// This determines the default planning iteration when we give up
// Usually this can be overridden at runtime in the thing requesting a plan.
#define DEFAULT_GOAP_PLANNING_BUDGET 50


/* ===   CHEAT_SEE_WAYPOINT_TURF:   ===
//
// To avoid getting stuck in rooms we may cheat
// and give the AI a direct view to the target for a tick.
*/

/* This is the per-action-tick odds of that happening */
# define GOAI_CHEAT_SEE_WAYPOINT_TURF_ODDS 10

/* This is the max waypoint distance to agent for the cheat.
//
// Normally, we only give the AI access to stuff within the vision range.
// This means the path won't be longer than world.view*2 at most.
//
// With the cheat vision tile though, this could be MUCH higher and potentially
// make the pathfinding waaaay too heavy. So, we limit the range
// we allow the cheat to work for by this much:
*/
# define GOAI_CHEAT_SEE_WAYPOINT_TURF_MAXDIST_CUTOFF (world.view * 3)


/* ===   Relationships:  === */

// Very Big Numbers - should be much bigger than normal relationship val/wgt
// These should effectively force other tags to be ignored entirely.
# define GOAI_REL_LUDICROUS_WEIGHT 10000
# define GOAI_REL_LUDICROUS_VALUE 10000
