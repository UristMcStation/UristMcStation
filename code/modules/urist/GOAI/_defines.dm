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

// Paths:
#define DEFAULT_UTILITY_AI_SENSES "goai_data/dev_sense.json"
#define DEFAULT_FACTION_AI_SENSES "goai_data/faction_senses.json"
#define GOAPPLAN_METADATA_PATH "goai_data/goai_actions.json"
#define DEFAULT_MOBCOMMANDER_PERSONALITY_TEMPLATE "goai_data/personality_templates/combat.json"

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


// Size of the GOAI plan buffer; if we would exceed it, eject a plan.
#define MAX_STORED_PLANS 1

#define DEFAULT_MAX_ENEMIES 6

#define MEM_ACTION_MINUS_ONE "action-1"
#define MEM_ACTION_MINUS_TWO "action-2"

// GOAP is NP-time, so we cut it off and give up to prevent game lockup
// This determines the default planning iteration when we give up
// Usually this can be overridden at runtime in the thing requesting a plan.
#define DEFAULT_GOAP_PLANNING_BUDGET 50

// worst-case granularity of sleep ticks
// this is so if someone sets the GOAI interval to 1e9 ds and then back to 1 ds
// it won't be stuck trying to run the eternal sleep
#define MAX_AI_SLEEPTIME 100

#define WITH_UTILITY_SLEEPTIME_STAGGER(X) ((##X) + rand(-1, 1))


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


/* Raycast blocking */
# define RAYCAST_BLOCK_ALL 1
# define RAYCAST_BLOCK_NONE -1
# define RAYCAST_BLOCK_CALLPROC 0

// bitflag-encoding:

// stopped by dense turfs, e.g. walls
// 00000001
# define RAYFLAG_TURFBLOCK 1

// stopped by non-transparent dense objects, e.g. doors but not windoors (unless the RAYFLAGE_TRANSPARENTBLOCK flag is set)
// 00000010
# define RAYFLAG_OPAQUEBLOCK 2

// stopped by transparent dense objects, e.g. windoors but not doors (unless the RAYFLAG_OPAQUEBLOCK flag is set)
// 00000100
# define RAYFLAG_TRANSPARENTBLOCK 4

// stopped by stochastic coverage checks on partial cover, e.g. tables
// this is additive with RAYFLAG_OPAQUEBLOCK / RAYFLAGE_TRANSPARENTBLOCK,
// so if both of those are unset, this won't do much
// 00001000
# define RAYFLAG_RANDCOVERBLOCK 8

// WILL hit the target if it's on the line
// 00000000
# define RAYTYPE_UNSTOPPABLE 0

// Line-of-Sight, for checking if it's even worth aiming
// (RAYFLAG_TURFBLOCK | RAYFLAG_OPAQUEBLOCK)
// 00000011
# define RAYTYPE_LOS 3

// Similar to LoS, but for actual shooting - check if we hit covers too. Good for lasers etc.
// (RAYFLAGE_RANDCOVERBLOCK | RAYFLAG_OPAQUEBLOCK | RAYFLAG_TURFBLOCK)
// 00001011
# define RAYTYPE_BEAM 11

// Blocked by anything dense. As the name indicates, meant for boolets etc.
// (RAYFLAGE_RANDCOVERBLOCK | RAYFLAG_TRANSPARENTBLOCK | RAYFLAG_OPAQUEBLOCK | RAYFLAG_TURFBLOCK)
// 00001111
# define RAYTYPE_PROJECTILE 15

// Like RAYTYPE_PROJECTILE, but ignores cover checks - use for checking if it's worth aiming at the target or armor-piercing projectiles
// (RAYFLAG_TRANSPARENTBLOCK | RAYFLAG_OPAQUEBLOCK | RAYFLAG_TURFBLOCK)
// 00000111
# define RAYTYPE_PROJECTILE_NOCOVER 7

# define DEFAULT_RAYTYPE RAYTYPE_UNSTOPPABLE

/* AStar defines */

// Default min-distance to search for if not otherwise specified
// (e.g. 0 to path DIRECTLY to a target turf, 1 to path to be adjacent, etc.)
#define DEFAULT_MIN_ASTAR_DIST 1

// Enables 3d pathfinding for default adjacency/distance procs
#define GOAI_MULTIZ_ASTAR 1

// Base cost of moving across Z-levels
// Paths look ridiculous if you keep the cost the same as for vertical motion
// (you get the nuCOM absurd athleticism of jumping up and down freely).
// Custom costprocs can just Not Use This to support free-flying agents.
#define ASTAR_ZMOVE_BASE_PENALTY 5
