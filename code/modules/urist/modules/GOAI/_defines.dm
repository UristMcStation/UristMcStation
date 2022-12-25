# define PI 3.14159265
# define LOG2(x) log(2, x)

# define GOAI_AI_ENABLED 1
# define AI_TICK_DELAY 5
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

# ifdef DEBUG_LOGGING
# define MAYBE_LOG(X) world.log << X
# define MAYBE_LOG_TOSTR(X) world.log << #X + ": [X]"
# else
# define MAYBE_LOG(X)
# define MAYBE_LOG_TOSTR(X)
# endif

# define get_turf(A) get_step(A,0)

# define GUN_DISPERSION 5

# define SENSE_SIGHT "Sight"
# define SENSE_SIGHT_CURR "SightCurr"
# define SENSE_SIGHT_PREV "SightPrev"

// 1 (SOUTH) + 2 (NORTH) + 4 (EAST) + 8 (WEST) == 15
# define ALL_CARDINAL_DIRS 15

// Attachments
# define ATTACHMENT_CONTROLLER "AiController"
# define ATTACHMENT_CONTROLLER_BACKREF "AiControllerId"
# define ATTACHMENT_EVTQUEUE_HIT "HitEventQueue"
