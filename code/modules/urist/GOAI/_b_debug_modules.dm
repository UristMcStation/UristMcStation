// Uncomment defines as needed to enable various loggers.


# ifdef ENABLE_DEBUG_LOG_MACROS
	# define DEBUG_LOGGING_SEPARATORS 0
	//# define DEBUG_LOGGING 0
	# define DEMOGOAP_DEBUG_LOGGING 0
	// # define RAYTRACE_DEBUG_LOGGING 0
	// # define ADD_ACTION_DEBUG_LOGGING 0
	# define COMBAT_AI_DEBUG_LOGGING 0
	# define RUN_ACTION_DEBUG_LOGGING 0
	# define MOVEMENT_DEBUG_LOGGING 0
	// # define OBSTACLEHUNT_DEBUG_LOGGING 0
	// # define VALIDATE_ACTION_DEBUG_LOGGING 0
	# define ACTION_RUNTIME_DEBUG_LOGGING 0
	//# define ACTIONTRACKER_DEBUG_LOGGING 0
	//# define PLANNING_DEBUG_LOGGING 0
	# define MOTIVES_DEBUG_LOGGING 0
	//# define COVERDATA_DEBUG_LOGGING 0
	//# define DIRBLOCKER_DEBUG_LOGGING 0
	//# define GOAP_INSPECTION_LOGGING 0
	# define UTILITYBRAIN_DEBUG_LOGGING 0
	//# define UTILITYBRAIN_LOG_UTILITIES 0
	//# define UTILITYBRAIN_LOG_CONTEXTS 0
	//# define UTILITYBRAIN_LOG_CONTROLLER_LOOKUP 0
	//# define UTILITYBRAIN_LOG_ACTIONCOUNT 0
	//# define UTILITYBRAIN_LOG_CONSIDERATION_INPUTS 0
	//# define UTILITYBRAIN_LOG_AXIS_SCORES 0
	//# define UTILITYBRAIN_LOG_AXIS_TOTALS 0
	//# define UTILITYBRAIN_LOG_AXIS_CUTOFFS 0
	//# define UTILITYBRAIN_LOG_CURVE_INPUTS 0
	//# define DEBUG_UTILITY_MEMORY_QUERIES 0
	//# define DEBUG_UTILITY_INPUT_FETCHERS 0
	//# define PLANNING_CONSIDERATIONS_DEBUG_LOGGING 0
	# define MARKETWATCH_DEBUG_LOGGING 0
	# define TRADE_DEBUG_LOGGING 0

	// Undefine to remove warnings for noncritical WIP code stuff
	//# define SHOW_GOAI_WIP_WARNINGS 1

	# define ENABLE_GOAI_DEVEL_LOGGING 1
	# define ENABLE_GOAI_ERROR_LOGGING 1

#endif

// Undefine to disable drawing icons used to debug pathfinding
//#define ENABLE_GOAI_DEBUG_GIZMOS 1

// Undefine to disable drawing debug lines pointing at assorted Stuff. Older and more expensive than other gizmos, for Reasons(TM) (allocs/deallocs)
//#define ENABLE_GOAI_DEBUG_BEAM_GIZMOS 1

#ifndef to_world
	#define to_world(message) world << (message)
#endif

#ifndef to_world_log
	#define to_world_log(message) world.log << (message)
#endif
/* ============================================= */

// Meta-definitions for compile-time-conditional logging

# ifdef DEBUG_LOGGING
	#define MAYBE_LOG(X) to_world_log(X)
	#define MAYBE_LOG_TOSTR(X) to_world_log(#X + ": [X]")
# else
	#define MAYBE_LOG(X)
	#define MAYBE_LOG_TOSTR(X)
# endif

// If defined-in, adds a blank line to logs for better readability
// Note this is per-AI, so interleaved AIs will make things messy!
// This is mainly intended for testing single AI instances at a time.
# ifdef DEBUG_LOGGING_SEPARATORS
	#define ADD_DEBUG_LOG_SEPARATOR to_world_log("")
# else
	#define ADD_DEBUG_LOG_SEPARATOR
# endif

#ifdef ENABLE_GOAI_DEVEL_LOGGING
	#define GOAI_LOG_DEBUG(Msg) to_world_log(Msg)
	#define GOAI_LOG_DEBUG_WORLD(Msg) to_world(Msg)
#else
	#define GOAI_LOG_DEBUG(Msg)
	#define GOAI_LOG_DEBUG_WORLD(Msg)
#endif

#ifdef ENABLE_GOAI_ERROR_LOGGING
	#define GOAI_LOG_ERROR(Msg) to_world_log(Msg)
#else
	#define GOAI_LOG_ERROR(Msg)
#endif

# ifdef UTILITYBRAIN_DEBUG_LOGGING
	# define UTILITYBRAIN_DEBUG_LOG(X) to_world_log(X)
# else
	# define UTILITYBRAIN_DEBUG_LOG(X)
# endif

# ifdef COMBAT_AI_DEBUG_LOGGING
	# define COMBAT_AI_DEBUG_LOG(X) to_world_log(X)
# else
	# define COMBAT_AI_DEBUG_LOG(X)
# endif

# ifdef ACTION_RUNTIME_DEBUG_LOGGING
	# define ACTION_RUNTIME_DEBUG_LOG(X) to_world_log(X)
# else
	# define ACTION_RUNTIME_DEBUG_LOG(X)
# endif

# ifdef DEBUG_UTILITY_MEMORY_QUERIES

	# define DEBUGLOG_UTILITY_MEMORY_FETCH(X) to_world_log(X)
	// Those were distinct because I dun goofed
	# define DEBUGLOG_MEMORY_FETCH(X) to_world_log(X)
	# define DEBUGLOG_MEMORY_ERRTRY(X) try { X }
	# define DEBUGLOG_MEMORY_ERRCATCH(X, Y) catch(X) { Y }

	# else

	# define DEBUGLOG_UTILITY_MEMORY_FETCH(X)
	# define DEBUGLOG_MEMORY_FETCH(X)
	# define DEBUGLOG_MEMORY_ERRTRY(X) X
	# define DEBUGLOG_MEMORY_ERRCATCH(X, Y)

# endif

# ifdef MOTIVES_DEBUG_LOGGING
	# define MOTIVES_DEBUG_LOG(X) to_world_log(X)
# else
	# define MOTIVES_DEBUG_LOG(X)
# endif

# ifdef RAYTRACE_DEBUG_LOGGING
	# define RAYTRACE_DEBUG_LOG(X) to_world_log(X)
# else
	# define RAYTRACE_DEBUG_LOG(X)
# endif

# ifdef ADD_ACTION_DEBUG_LOGGING
# define ADD_ACTION_DEBUG_LOG(X) to_world_log(X)
# else
# define ADD_ACTION_DEBUG_LOG(X)
# endif

# ifdef RUN_ACTION_DEBUG_LOGGING
# define RUN_ACTION_DEBUG_LOG(X) to_world(X); to_world_log(X)
# else
# define RUN_ACTION_DEBUG_LOG(X)
# endif

# ifdef MOVEMENT_DEBUG_LOGGING
# define MOVEMENT_DEBUG_LOG(X) to_world(X); to_world_log(X)
# else
# define MOVEMENT_DEBUG_LOG(X)
# endif

# ifdef VALIDATE_ACTION_DEBUG_LOGGING
# define VALIDATE_ACTION_DEBUG_LOG(X) to_world(X)
# else
# define VALIDATE_ACTION_DEBUG_LOG(X)
# endif

# ifdef PLANNING_DEBUG_LOGGING
# define PLANNING_DEBUG_LOG(X) to_world_log(X)
# else
# define PLANNING_DEBUG_LOG(X)
# endif

# ifdef DEBUG_UTILITY_INPUT_FETCHERS
# define DEBUGLOG_UTILITY_INPUT_FETCHERS(X) to_world_log(X)
# define DEBUGLOG_UTILITY_INPUT_CATCH(X) catch(X)
# else
# define DEBUGLOG_UTILITY_INPUT_FETCHERS(X)
# define DEBUGLOG_UTILITY_INPUT_CATCH(X) catch()
# endif

# ifdef COVERDATA_DEBUG_LOGGING
# define COVERDATA_DEBUG_LOG(X) to_world_log(X)
# else
# define COVERDATA_DEBUG_LOG(X)
# endif

# ifdef DIRBLOCKER_DEBUG_LOGGING
# define DIRBLOCKER_DEBUG_LOG(X) to_world_log(X)
# else
# define DIRBLOCKER_DEBUG_LOG(X)
# endif

# ifdef GOAP_INSPECTION_LOGGING
# define GOAP_INSPECTION_LOG(TXT) to_world_log(TXT)
# else
# define GOAP_INSPECTION_LOG(TXT)
# endif

# ifdef DEBUG_LOGGING
# define GOAP_DEBUG_LOG(TXT) MAYBE_LOG(TXT)
# else
# define GOAP_DEBUG_LOG(TXT)
# endif

# ifdef PLANNING_CONSIDERATIONS_DEBUG_LOGGING
# define PLANNING_CONSIDERATIONS_LOG(TXT)  to_world(TXT); to_world_log(TXT)
# else
# define PLANNING_CONSIDERATIONS_LOG(TXT)
# endif

# ifdef ACTIONTRACKER_DEBUG_LOGGING
# define ACTIONTRACKER_DEBUG_LOG(X) to_world_log(X)
# else
# define ACTIONTRACKER_DEBUG_LOG(X)
# endif

# ifdef DEMOGOAP_DEBUG_LOGGING
# define DEMOGOAP_DEBUG_LOG(X) to_world_log(X)
# else
# define DEMOGOAP_DEBUG_LOG(X)
# endif

# ifdef MARKETWATCH_DEBUG_LOGGING
# define MARKETWATCH_DEBUG_LOG(X) to_world_log(X)
# else
# define MARKETWATCH_DEBUG_LOG(X)
# endif

# ifdef TRADE_DEBUG_LOGGING
# define TRADE_DEBUG_LOG(X) to_world_log(X)
# define TRADE_DEBUG_LOG_IF(Pred, X) if(##Pred) { to_world_log(X) };
# else
# define TRADE_DEBUG_LOG(X)
# define TRADE_DEBUG_LOG_IF(Pred, X)
# endif
