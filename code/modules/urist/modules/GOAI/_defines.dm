# define MATH_PI 3.14159265
# define LOG2(x) log(2, x)

# define GOAI_AI_ENABLED 1
# define AI_TICK_DELAY 5
# define ACTION_TICK_DELAY 5
# define CHUNK_SIZE_DEFAULT 5
# define CHUNK_OVERLAP_DEFAULT 1

# define NEED_MINIMUM 0
# define NEED_THRESHOLD 50
# define NEED_SAFELEVEL 75
# define NEED_SATISFIED 95
# define NEED_MAXIMUM 100

# define MOTIVE_SLEEP "Energy"
# define MOTIVE_FOOD "Calories"
# define MOTIVE_FUN "Entertainment"

# define RESOURCE_FOOD "FoodItems"
# define RESOURCE_MONEY "Money"
# define RESOURCE_TIME "Time"

# define PLUS_INF 1.#INF
# define GOAP_KEY_SRC "source"

# define LOAD_TEXT(fp) file2text(fp)
# define SAVE_TEXT(txt, fp) text2file(txt, fp)

# define LOAD_JSON(fp) json_decode(LOAD_TEXT)
# define SAVE_JSON(data, fp) SAVE_TEXT(json_encode(data), fp)
# define SAVE_JSON_OVERWRITE(data, fp) fdel(fp); SAVE_TEXT(json_encode(data), fp)

# ifdef DEBUG_LOGGING
# define MAYBE_LOG(X) to_world_log(X)
# define MAYBE_LOG_TOSTR(X) to_world_log(#X + ": [X]")
# else
# define MAYBE_LOG(X)
# define MAYBE_LOG_TOSTR(X)
# endif

# define COORDS_TUPLE_2D(A) "([A?.x], [A?.y])"
# define COORDS_TUPLE_3D(A) "([A?.x], [A?.y], [A?.z])"
// defaulting:
# define COORDS_TUPLE COORDS_TUPLE_2D
# define LOCATION_WITH_COORDS(At) "[get_turf(At)] @ [COORDS_TUPLE(At)]"


# ifdef GOAI_LIBRARY_FEATURES

# define get_turf(A) get_step(A,0)
// 1 (SOUTH) + 2 (NORTH) + 4 (EAST) + 8 (WEST) == 15
# define ALL_CARDINAL_DIRS 15

# endif

# define GUN_DISPERSION 5

# define DEFAULT_ORPHAN_CLEANUP_THRESHOLD 3
# define SENSE_SIGHT "Sight"
# define SENSE_SIGHT_CURR "SightCurr"
# define SENSE_SIGHT_PREV "SightPrev"

// 1 (SOUTH) + 2 (NORTH) + 4 (EAST) + 8 (WEST) == 15
# define ALL_CARDINAL_DIRS 15

// Attachments
# define ATTACHMENT_CONTROLLER "AiController"
# define ATTACHMENT_CONTROLLER_BACKREF "AiControllerId"
# define ATTACHMENT_EVTQUEUE_HIT "HitEventQueue"

// Helpers
# define IS_VALID_NON_NULL(X) (!(isnull(X)) && istype(X))
# define PUT_EMPTY_LIST_IN(X) if(IS_VALID_NON_NULL(X)) { X.Cut() } else { X = list() }

# define DEFAULT_GOAI_DISTANCE_PROC /proc/fDistanceUnified

# define DEBUG_LOG_LIST_ARRAY(L) for(var/_li_ in L) { to_world_log("[_li_]") }
# define DEBUG_LOG_LIST_ASSOC(L) for(var/_li_ in L) { to_world_log("[_li_]: [L[_li_]]") }

