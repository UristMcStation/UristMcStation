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


# ifdef ACTION_RUNTIME_DEBUG_LOGGING
# define ACTION_RUNTIME_DEBUG_LOG(X) to_world_log(X)
# else
# define ACTION_RUNTIME_DEBUG_LOG(X)
# endif
