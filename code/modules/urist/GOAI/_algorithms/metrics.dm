
#define MANHATTAN_DISTANCE_NUMERIC_THREED(Ax, Ay, Az, Bx, By, Bz, ZMULT) ( abs(Ax - Bx) + abs(Ay - By) + (abs(Az - Bz) * ZMULT) )
#define MANHATTAN_DISTANCE_NUMERIC_TWOD(Ax, Ay, Bx, By) ( abs(Ax - Bx) + abs(Ay - By) )

#define MANHATTAN_DISTANCE_TWOD(from_atom, to_atom, DEFAULT) ( (!istype(from_atom, /atom) || !istype(to_atom, /atom) || (from_atom.z != to_atom.z) ) ? DEFAULT : MANHATTAN_DISTANCE_NUMERIC_TWOD(from_atom.x, from_atom.y, to_atom.x, to_atom.y) )
#define MANHATTAN_DISTANCE_THREED(from_atom, to_atom, DEFAULT, ZMULT) ( (!istype(from_atom, /atom) || !istype(to_atom, /atom)) ? DEFAULT : MANHATTAN_DISTANCE_NUMERIC_THREED(from_atom.x, from_atom.y, from_atom.z, to_atom.x, to_atom.y, to_atom.z, ZMULT) )

#define CHEBYSHEV_DISTANCE_NUMERIC_TWOD(Ax, Ay, Bx, By) (max( abs(Ax - Bx), abs(Ay - By) ))

#define CHEBYSHEV_DISTANCE_TWOD(from_atom, to_atom, DEFAULT) ( (!istype(from_atom, /atom) || !istype(to_atom, /atom) || (from_atom.z != to_atom.z) ) ? DEFAULT : CHEBYSHEV_DISTANCE_NUMERIC_TWOD(from_atom.x, from_atom.y, to_atom.x, to_atom.y) )
#define CHEBYSHEV_DISTANCE_THREED(from_atom, to_atom, DEFAULT, ZMULT) ( (!istype(from_atom, /atom) || !istype(to_atom, /atom) ) ? DEFAULT : CHEBYSHEV_DISTANCE_NUMERIC_TWOD(from_atom.x, from_atom.y, to_atom.x, to_atom.y) + (ZMULT * abs(to_atom.z - from_atom.z)) )

#define EUCLIDSQ_DISTANCE_NUMERIC_THREED(Ax, Ay, Az, Bx, By, Bz, ZMULT) ( ((Ax - Bx) ** 2) + ((Ay - By) ** 2) + (abs(Az - Bz) * ZMULT) )
#define EUCLIDSQ_DISTANCE_NUMERIC_TWOD(Ax, Ay, Bx, By)  ( ((Ax - Bx) ** 2) + ((Ay - By) ** 2) )

#define EUCLIDSQ_DISTANCE_TWOD(from_atom, to_atom, DEFAULT) ( (!istype(from_atom, /atom) || !istype(to_atom, /atom) || (from_atom.z != to_atom.z) ) ? DEFAULT : EUCLIDSQ_DISTANCE_NUMERIC_TWOD(from_atom.x, from_atom.y, to_atom.x, to_atom.y) )
#define EUCLIDSQ_DISTANCE_THREED(from_atom, to_atom, DEFAULT, ZMULT) ( (!istype(from_atom, /atom) || !istype(to_atom, /atom) ) ? DEFAULT : EUCLIDSQ_DISTANCE_NUMERIC_TWOD(from_atom.x, from_atom.y, to_atom.x, to_atom.y) + (ZMULT * abs(to_atom.z - from_atom.z)) )


// aliasing - so there's a nice generic, swappable macro to use for common cases
// explicit 2d/3d macros only needed when you specifically need 2d/3d (or want to override e.g. penalty)

# ifdef GOAI_MULTIZ_ASTAR
	# define MANHATTAN_DISTANCE(from_atom, to_atom) ( MANHATTAN_DISTANCE_THREED(from_atom, to_atom, PLUS_INF, ASTAR_ZMOVE_BASE_PENALTY) )
	# define CHEBYSHEV_DISTANCE(from_atom, to_atom) ( CHEBYSHEV_DISTANCE_THREED(from_atom, to_atom, PLUS_INF, ASTAR_ZMOVE_BASE_PENALTY) )
# else
	# define MANHATTAN_DISTANCE(from_atom, to_atom) ( MANHATTAN_DISTANCE_TWOD(from_atom, to_atom, PLUS_INF) )
	# define CHEBYSHEV_DISTANCE(from_atom, to_atom) ( CHEBYSHEV_DISTANCE_TWOD(from_atom, to_atom, PLUS_INF) )
# endif


/proc/EuclidDistance(var/atom/from_pos, var/atom/to_pos)
	if(isnull(from_pos) || isnull(to_pos))
		return PLUS_INF

	var/deltaX = to_pos.x - from_pos.x
	var/deltaY = to_pos.y - from_pos.y

	var/dist = sqrt(deltaX ** 2 + deltaY ** 2)
	return dist


/proc/ManhattanDistance(var/atom/from_pos, var/atom/to_pos)
	return MANHATTAN_DISTANCE(from_pos, to_pos)


/proc/ChebyshevDistance(var/atom/from_pos, var/atom/to_pos)
	return CHEBYSHEV_DISTANCE(to_pos, from_pos)


/proc/ManhattanDistanceNumeric(var/srcX, var/srcY, var/trgX, var/trgY)
	if(isnull(srcX) || isnull(trgX) || isnull(srcY) || isnull(trgY))
		return PLUS_INF

	var/dist = (abs(trgX - srcX) + abs(trgY - srcY))
	return dist


/proc/ChebyshevDistanceNumeric(var/srcX, var/srcY, var/trgX, var/trgY)
	if(isnull(srcX) || isnull(srcY) || isnull(trgX) || isnull(trgY))
		return PLUS_INF

	var/dist = max(abs(trgX - srcX), abs(trgY - srcY))
	return dist
