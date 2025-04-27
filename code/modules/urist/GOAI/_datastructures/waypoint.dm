// A list containing numerical coordinates.
// Does not need a class definition - this module just provides utils to make working with em nicely.

#define TO_GOAI_WAYPOINT_DATA(Atom) (list(KEY_GHOST_X = Atom?.x, KEY_GHOST_Y = Atom?.y, KEY_GHOST_Z = Atom?.z, KEY_GHOST_POS_TUPLE = Atom?.CurrentPositionAsTuple()))
#define GOAI_WAYPOINT_TO_TURF(Waypoint) (locate(Waypoint[KEY_GHOST_X], Waypoint[KEY_GHOST_Y], Waypoint[KEY_GHOST_Z]))
