/proc/EuclidDistance(var/atom/from_pos, var/atom/to_pos)
	if(isnull(from_pos) || isnull(to_pos))
		return PLUS_INF

	var/deltaX = to_pos.x - from_pos.x
	var/deltaY = to_pos.y - from_pos.y

	var/dist = sqrt(deltaX ** 2 + deltaY ** 2)
	return dist


/proc/ManhattanDistance(var/atom/from_pos, var/atom/to_pos)
	if(isnull(from_pos) || isnull(to_pos))
		return PLUS_INF

	var/dist = (abs(to_pos.x - from_pos.x) + abs(to_pos.y - from_pos.y))
	return dist


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
