// use Astar with Turfchunks to implement HAA*/HPA*

//proc/AStar(var/start, var/end, var/proc/adjacent, var/proc/dist, var/max_nodes, var/max_node_depth = 30, var/min_target_dist = 0, var/proc/min_node_dist, var/list/adj_args = null, var/exclude)

// Start/End - straightforward
// Adjacent - chunk for (curr + chunksize) in cardinal dirs
// Dist - probably simple dist
// REST: default/customizeable


/datum/chunk/proc/ChunkAdjacent(var/ignore_openness = FALSE)
	var/datum/chunkserver/chunkServer = GetOrSetChunkserver(width)

	if(!chunkServer)
		to_world_log("Failed to retrieve a ChunkServer for ChunkAdjacent()")
		return

	var/list/adjacents = list()

	if(ignore_openness || DirOpen(NORTH))
		var/newpos_y = centerY + (width - 1)
		var/datum/chunk/north_chunk = chunkServer.ChunkForTile(centerX, newpos_y, centerZ)
		adjacents.Add(north_chunk)

	if(ignore_openness || DirOpen(SOUTH))
		var/newpos_y = centerY - (width - 1)
		var/datum/chunk/south_chunk = chunkServer.ChunkForTile(centerX, newpos_y, centerZ)
		adjacents.Add(south_chunk)

	if(ignore_openness || DirOpen(EAST))
		var/newpos_x = centerX + (width - 1)
		var/datum/chunk/east_chunk = chunkServer.ChunkForTile(newpos_x, centerY, centerZ)
		adjacents.Add(east_chunk)

	if(ignore_openness || DirOpen(WEST))
		var/newpos_x = centerX - (width - 1)
		var/datum/chunk/east_chunk = chunkServer.ChunkForTile(newpos_x, centerY, centerZ)
		adjacents.Add(east_chunk)

	return adjacents


/proc/fChunkAdjacent(var/datum/chunk/source, var/ignore_openness = FALSE)
	if(!source)
		return

	var/datum/chunkserver/chunkServer = GetOrSetChunkserver(source.width)

	if(!chunkServer)
		to_world_log("Failed to retrieve a ChunkServer for ChunkAdjacent()")
		return

	var/list/adjacents = list()

	if(ignore_openness || source.DirOpen(NORTH))
		var/newpos_y = source.centerY + (source.width - 1)
		var/datum/chunk/north_chunk = chunkServer.ChunkForTile(source.centerX, newpos_y, source.centerZ)
		adjacents.Add(north_chunk)

	if(ignore_openness || source.DirOpen(SOUTH))
		var/newpos_y = source.centerY - (source.width - 1)
		var/datum/chunk/south_chunk = chunkServer.ChunkForTile(source.centerX, newpos_y, source.centerZ)
		adjacents.Add(south_chunk)

	if(ignore_openness || source.DirOpen(EAST))
		var/newpos_x = source.centerX + (source.width - 1)
		var/datum/chunk/east_chunk = chunkServer.ChunkForTile(newpos_x, source.centerY, source.centerZ)
		adjacents.Add(east_chunk)

	if(ignore_openness || source.DirOpen(WEST))
		var/newpos_x = source.centerX - (source.width - 1)
		var/datum/chunk/east_chunk = chunkServer.ChunkForTile(newpos_x, source.centerY, source.centerZ)
		adjacents.Add(east_chunk)

	return adjacents


/datum/chunk/proc/ChunkDistance(var/datum/chunk/C)
	if(!C)
		return

	// We're returning cardinal adjacents, so we need Manhattan distance to reflect it.
	var/dist = ManhattanDistanceNumeric(src.centerX, src.centerY, C.centerX, C.centerY)
	return dist


/proc/fChunkDistance(var/datum/chunk/source, var/datum/chunk/C)
	if(!source)
		return

	if(!C)
		return

	// We're returning cardinal adjacents, so we need Manhattan distance to reflect it.
	var/dist = ManhattanDistanceNumeric(source.centerX, source.centerY, C.centerX, C.centerY)
	return dist


/proc/ChunkyAStar(var/start, var/end, var/proc/adjacent, var/proc/dist, var/max_nodes = 0, var/max_node_depth = 30, var/min_target_dist = 0, var/proc/min_node_dist, var/list/adj_args = null, var/exclude)
	/* Finds a 'high-level' path between turfchunks.
	//
	// This path can then be 'refined' to produce a turf-by-turf path for actual atoms
	// to follow by doing a small, 'classic' AStar confined to the turfchunk volumes.
	//
	// This is the general pattern of all Hierarchical AStar variant algorithms (HPAStar.
	// HAAStar, PRAStar) and, as a rule, both accelerates the algorithm massively and conserves
	// memory for Very Very Long paths (can deal with 10k+ long paths!).
	*/

	// IMPORTANT: max depth etc. have slightly different semantics here!
	// Since our nodes are 5x5 chunks (e.g.), min_dist=1 here is effectively min_dist=5 in normal AStar!
	var/turf/startturf = get_turf(start)

	if(!startturf)
		return

	var/turf/endturf = get_turf(end)

	if(!endturf)
		return

	var/datum/chunkserver/chunkServer = GetOrSetChunkserver()

	if(!chunkServer)
		to_world_log("Failed to retrieve a ChunkServer for ChunkyAStar()")
		return

	var/proc/true_adjproc = (isnull(adjacent) ? /proc/fChunkAdjacent : adjacent)
	var/proc/true_distproc = (isnull(dist) ? /proc/fChunkDistance : dist)

	var/datum/chunk/startchunk = chunkServer.ChunkForAtom(startturf)
	var/datum/chunk/endchunk = chunkServer.ChunkForAtom(endturf)

	var/list/path = GoaiAStar(
		start = startchunk,
		end = endchunk,
		adjacent = true_adjproc,
		dist = true_distproc,
		max_nodes = max_nodes,
		max_node_depth = max_node_depth,
		min_target_dist = min_target_dist,
		min_node_dist = min_node_dist,
		adj_args = adj_args,
		exclude = exclude
	)

	return path

