#define DEFAULT_PRIORITY_QUEUE_IMPL /PriorityQueue/BinHeap

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

// Ensures all flags F are set in a variable V
#define CHECK_ALL_FLAGS(FlagVar, Flags) ((FlagVar & Flags) == Flags)

#define LOAD_TEXT(fp) file2text(fp)
#define SAVE_TEXT(txt, fp) text2file(txt, fp)

#define READ_JSON_FILE(FP) (fexists(FP) && json_decode(file2text(FP)))

#define SAVE_JSON_FILE(data, fp) SAVE_TEXT(json_encode(data), fp)
#define SAVE_JSON_FILE_OVERWRITE(data, fp) fdel(fp); SAVE_TEXT(json_encode(data), fp)

#define COORDS_TUPLE_2D(A) "([A?.x], [A?.y])"
#define COORDS_TUPLE_3D(A) "([A?.x], [A?.y], [A?.z])"
// YOLO variants if you know the target has coords
#define COORDS_TUPLE_2D_UNSAFE(A) "([A?:x], [A?:y])"
#define COORDS_TUPLE_3D_UNSAFE(A) "([A?:x], [A?:y], [A?:z])"
// defaulting:
#define COORDS_TUPLE COORDS_TUPLE_3D
#define COORDS_TUPLE_UNSAFE COORDS_TUPLE_3D_UNSAFE
#define LOCATION_WITH_COORDS(At) "[get_turf(At)] @ [COORDS_TUPLE(At)]"

// 1 (SOUTH) + 2 (NORTH) + 4 (EAST) + 8 (WEST) == 15
#define ALL_CARDINAL_DIRS 15

#define GUN_DISPERSION 5
#define DEFAULT_ORPHAN_CLEANUP_THRESHOLD 3

#define SENSE_SIGHT "SenseSight"
#define SENSE_SIGHT_CURR "SightCurr"
#define SENSE_SIGHT_PREV "SightPrev" // NOTE: currently disabled!

// Attachments
#define ATTACHMENT_CONTROLLER "AiController"
#define ATTACHMENT_CONTROLLER_BACKREF "AiControllerId"
#define ATTACHMENT_EVTQUEUE_HIT "HitEventQueue"

// Helpers
#define IS_VALID_NON_NULL(X) (!(isnull(X)) && istype(X))
#define PUT_EMPTY_LIST_IN(X) if(IS_VALID_NON_NULL(X)) { X.Cut() } else { X = list() }

#define DEFAULT_GOAI_DISTANCE_PROC /proc/fTestObstacleDistManhattan

#define DEBUG_LOG_LIST_ARRAY(L, LOGGER) for(var/_li_ in L) { LOGGER("[_li_]") }
#define DEBUG_LOG_LIST_ASSOC(L, LOGGER) for(var/_li_ in L) { LOGGER("[_li_]: [L[_li_]]") }

#define SET_IF_NOT_NULL(Nullable, Var) if(!(isnull(Nullable))) { ##Var = Nullable }
#define DEFAULT_IF_NULL(Nullable, Default) (isnull(Nullable) ? Default : Nullable)

// A variant of DEFAULT_IF_NULL for logging, as this is an extremely common pattern in messages in DM.
#define NULL_TO_TEXT(Nullable) DEFAULT_IF_NULL(Nullable, "null")

// Kinda black magic; looks up an AI reference and puts it into the variable PATH specified in the second argument.
#define FetchAiControllerForObjIntoVar(GameObj, VarPath) var/__commander_backref = GameObj?.attachments?.Get(ATTACHMENT_CONTROLLER_BACKREF); VarPath = IS_REGISTERED_AI(__commander_backref) && GOAI_LIBBED_GLOB_ATTR(global_goai_registry[__commander_backref])

// Size of the GOAI plan buffer; if we would exceed it, eject a plan.
#define MAX_STORED_PLANS 1

#define DEFAULT_MAX_ENEMIES 6

#define MEM_ACTION_MINUS_ONE "action-1"
#define MEM_ACTION_MINUS_TWO "action-2"

// GOAP is NP-time, so we cut it off and give up to prevent game lockup
// This determines the default planning iteration when we give up
// Usually this can be overridden at runtime in the thing requesting a plan.
#define DEFAULT_GOAP_PLANNING_BUDGET 50

// best-case granularity of sleep ticks
// this is to prevent someone setting delay to 0 and crashing the server
#define MIN_AI_SLEEPTIME 0.05

// worst-case granularity of sleep ticks
// this is so if someone sets the GOAI interval to 1e9 ds and then back to 1 ds
// it won't be stuck trying to run the eternal sleep
#define MAX_AI_SLEEPTIME 100

#define WITH_UTILITY_SLEEPTIME_STAGGER(X) ((##X) + (2 * (rand() - 0.4)))


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
#define ASTAR_ZMOVE_BASE_PENALTY 3

/*
// GOAI 'visibility' flags.
//
// SS13 has a jillion objects around, including many things that are not terribly interesting for AI purposes
// (for example - most areas, cables and pipes most of the time, ghosts).
// Ideally we want to avoid storing and processing what we will never, ever use (at least, for a specific system).
// That's the idea here - if something doesn't have these flags on, GOAI will skip it for a corresponding purpose.
//
// NOTE: Do NOT try to over-optimize and set something as e.g. not VIEWABLE because it's not LONGLIVED - the whole
//       reason those flags are separate is because there might be cases where you do want to allow one without the
//       other. It's on the API user to check both are set if they need both.
*/

// Exists in the 'normal plane', as opposed to ghosts, AI-eyes, spawners, etc.
#define GOAI_VISFLAG_MATERIAL 1

// Non-abstract, an actual material-ish Thing in the world (as opposed to e.g. AI-eyes which abstract cameras/focus)
#define GOAI_VISFLAG_TANGIBLE 2

// Can POTENTIALLY be seen if set (may have to check invisibility, alpha, etc. to establish)
#define GOAI_VISFLAG_VIEWABLE 4

// Has a non-negligible lifespan (unlike e.g. a laser beam flash or a sparks effect)
#define GOAI_VISFLAG_LONGLIVED 8

// Can POTENTIALLY be hit by a raytrace ray (even the most permissive)
#define GOAI_VISFLAG_RAYTRACE_HITTABLE 16

// If unset, this object, even if material, is just not that useful for AI purposes most of the time. E.g. pipes under floors, decorative items.
#define GOAI_VISFLAG_SIGNIFICANT 32

// Significant on steroids. This flag indicates the object is almost certainly worth considering. E.g. cover objects, tool items.
#define GOAI_VISFLAG_INTERESTING 64

// The semi-flipside of REAL. Indicates this object exists on the supernatural plane in some sense. E.g. ghosts, cult monsters and structures. Intended for any AI dealing with spoopy.
// Note that something can be both REAL and ETHEREAL - for example, a manifested ghost and most Cult stuff could count.
#define GOAI_VISFLAG_ETHEREAL 128

// Archetypes - bundles of flags

// Abstract map objects, spawners, etc.olp
// Use this if you categorically *never* want to look at this object in the AI, ever
#define GOAI_VISTYPE_ABSTRACT 0

// GOAI_VISFLAG_INTERESTING | GOAI_VISFLAG_SIGNIFICANT | GOAI_VISFLAG_RAYTRACE_HITTABLE | GOAI_VISFLAG_LONGLIVED | GOAI_VISFLAG_VIEWABLE | GOAI_VISFLAG_TANGIBLE | GOAI_VISFLAG_MATERIAL
// 64+32+16+8+4+2+1 == 12
// Material object, highly relevant (e.g. tools, important SmartObjects)
#define GOAI_VISTYPE_ELEVATED 127

// GOAI_VISFLAG_SIGNIFICANT | GOAI_VISFLAG_RAYTRACE_HITTABLE | GOAI_VISFLAG_LONGLIVED | GOAI_VISFLAG_VIEWABLE | GOAI_VISFLAG_TANGIBLE | GOAI_VISFLAG_MATERIAL
// 32+16+8+4+2+1 == 63
// Default flagset for atoms unless specified otherwise
#define GOAI_VISTYPE_STANDARD 63

// GOAI_VISFLAG_SIGNIFICANT | GOAI_VISFLAG_VIEWABLE | GOAI_VISFLAG_TANGIBLE | GOAI_VISFLAG_MATERIAL
// 32+4+2+1 == 103
// Default flagset for e.g. projectiles or effects like sparks - real, but too evanescent to bother with much
#define GOAI_VISTYPE_TEMPORARY 39

// GOAI_VISFLAG_RAYTRACE_HITTABLE | GOAI_VISFLAG_LONGLIVED | GOAI_VISFLAG_VIEWABLE | GOAI_VISFLAG_TANGIBLE | GOAI_VISFLAG_MATERIAL
// 16+8+4+2+1 == 31
// Material, but uninteresting junk; blocks at least some raycasts
#define GOAI_VISTYPE_WORLDJUNK_BLOCKING 31

// GOAI_VISFLAG_LONGLIVED | GOAI_VISFLAG_VIEWABLE | GOAI_VISFLAG_TANGIBLE | GOAI_VISFLAG_MATERIAL
// 8+4+2+1 == 15
// Material, but uninteresting junk, cannot ever be hit
#define GOAI_VISTYPE_WORLDJUNK_NONBLOCKING 15

// GOAI_VISFLAG_ETHEREAL | GOAI_VISFLAG_SIGNIFICANT | GOAI_VISFLAG_LONGLIVED | GOAI_VISFLAG_VIEWABLE | GOAI_VISFLAG_TANGIBLE
// 128+32+8+4+2 == 174
// Ghost-type things (un-manifested)
#define GOAI_VISTYPE_ETHEREAL 174

// GOAI_VISFLAG_ETHEREAL | GOAI_VISFLAG_SIGNIFICANT | GOAI_VISFLAG_LONGLIVED | GOAI_VISFLAG_VIEWABLE | GOAI_VISFLAG_TANGIBLE | GOAI_VISFLAG_MATERIAL
// 128+32+8+4+2+1 == 175
// Manifested ghosts, haunter effects and such; materialized, but still not hittable
#define GOAI_VISTYPE_HAUNTING 175

// GOAI_VISFLAG_ETHEREAL | GOAI_VISFLAG_SIGNIFICANT | GOAI_VISFLAG_RAYTRACE_HITTABLE | GOAI_VISFLAG_LONGLIVED | GOAI_VISFLAG_VIEWABLE | GOAI_VISFLAG_TANGIBLE | GOAI_VISFLAG_MATERIAL
// 128+32+16+8+4+2+1 == 191
// Cult mobs, and other things that are basically normal objects but also visible on the supernatural layer
#define GOAI_VISTYPE_SUPERNATURAL 191


/* ===   Relationships:  === */

// Very Big Numbers - should be much bigger than normal relationship val/wgt
// These should effectively force other tags to be ignored entirely.
# define GOAI_REL_LUDICROUS_WEIGHT 10000
# define GOAI_REL_LUDICROUS_VALUE 10000

#define RELATIONS_DEFAULT_RELATIONSHIP_VAL 0
#define RELATIONS_DEFAULT_RELATIONSHIP_WEIGHT 1

#define RELATIONS_DEFAULT_HOSTILITY_THRESHOLD 0
#define RELATIONS_DEFAULT_ALLIANCE_THRESHOLD 75

#define RELATIONS_DEFAULT_SELF_FACTION_RELATION_VAL 100
#define RELATIONS_DEFAULT_SELF_FACTION_RELATION_WEIGHT 1
#define RELATIONS_DEFAULT_SELF_HIDDENFACTION_RELATION_VAL 50
#define RELATIONS_DEFAULT_SELF_HIDDENFACTION_RELATION_WEIGHT 1
