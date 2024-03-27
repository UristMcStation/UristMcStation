
# ifdef GOAI_MULTIZ_ASTAR
	# define MANHATTAN_DISTANCE(from_atom, to_atom) ((isnull(from_atom) || isnull(to_atom)) ? PLUS_INF : (abs(to_atom.x - from_atom.x) + abs(to_atom.y - from_atom.y) + (abs(to_atom.z - from_atom.z) * ASTAR_ZMOVE_BASE_PENALTY) ))
# else
	# define MANHATTAN_DISTANCE(from_atom, to_atom) ((isnull(from_atom) || isnull(to_atom)) ? PLUS_INF : (abs(to_atom.x - from_atom.x) + abs(to_atom.y - from_atom.y)))
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
	if(isnull(from_pos) || isnull(to_pos))
		return PLUS_INF

	var/dist = max(abs(to_pos.x - from_pos.x), abs(to_pos.y - from_pos.y))
	return dist


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
