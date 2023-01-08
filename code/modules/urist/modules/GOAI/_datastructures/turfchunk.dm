/* A region spanning multiple map tiles. */

/datum/chunk
	var/centerX
	var/centerY
	var/centerZ
	var/width

	// 'private' variables; don't use these directly (or do, it's your funeral)
	var/_open_edges = 0  // lazily populated bitfield!
	var/_blocked_edges = 0  // lazily populated bitfield!
	// TODO: consider using a list to assoc dir + clearances


/datum/chunk/New(var/x, var/y, var/z, var/chunk_size = CHUNK_SIZE_DEFAULT)
	width = chunk_size || CHUNK_SIZE_DEFAULT

	centerX = x
	centerY = y
	centerZ = z


/datum/chunk/proc/Radius()
	var/radius = FLOOR(width / 2)
	return radius


/datum/chunk/proc/MinX()
	var/minX = centerX - Radius() + (width % 2)
	return minX


/datum/chunk/proc/MaxX()
	var/minX = centerX + Radius() - (width % 2)
	return minX


/datum/chunk/proc/MinY()
	var/minY = centerY - Radius() + (width % 2)
	return minY


/datum/chunk/proc/MaxY()
	var/maxY = centerY + Radius() - (width % 2)
	return maxY


/datum/chunk/proc/Perimeter(var/dirs = ALL_CARDINAL_DIRS)
	var/result = tperimeter(
		radius = src.Radius(),
		centreX = src.centerX,
		centreY = src.centerY,
		centreZ = src.centerZ,
		dirs = dirs,
		exclude_centre_tile = (!(width % 2))
	)
	return result


/datum/chunk/proc/AllTurfs()
	var/turf/BL = locate(MinX(), MinY(), centerZ)
	var/turf/TR = locate(MaxX(), MaxY(), centerZ)

	var/result = block(BL, TR)
	return result


/datum/chunk/proc/DirOpen(var/dir = NORTH)
	// TODO: compact dirs to an enum and use a list[4] here for metadata
	if(!(dir))
		return

	if(isnull(_open_edges))
		_open_edges = 0

	if(isnull(_blocked_edges))
		_blocked_edges = 0

	var/is_open = ((_open_edges & dir) > 0)
	var/is_closed = ((_blocked_edges & dir) > 0)

	/* Read-through cache, effectively */

	// CACHE HITS - reuse:
	if(is_open && !is_closed)
		// 100% sure it's open
		return TRUE

	if(is_closed && !is_open)
		// 100% sure it's blocked
		return FALSE

	// CACHE MISS - recalculate:
	var/result = FALSE
	var/list/edge_turfs = Perimeter(dir)

	for(var/turf/perim_turf in edge_turfs)
		if(perim_turf.IsBlocked())
			_blocked_edges |= dir
			_open_edges &= ~dir
			continue

		if(GoaiDirBlocked(perim_turf, dir))
			_blocked_edges |= dir
			_open_edges &= ~dir
			continue

		if(GoaiDirBlocked(perim_turf, dir2opposite(dir)))
			_blocked_edges |= dir
			_open_edges &= ~dir
			continue

		result = TRUE
		_open_edges |= dir
		_blocked_edges &= ~dir
		break

	return result
