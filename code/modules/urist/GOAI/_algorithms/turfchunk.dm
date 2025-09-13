/* This is a yak-shaving expedition designed to improve AStar-ing through the map.
//
// It builds on a fairly classic trick: instead of finding an exact path, we search
// a 'macro' version of the graph for a rough draft, then zoom in to a 'micro' level
// to find the best connection between the macro-level elements.
//
// Imagine you're visiting a friend abroad: it would be less effort to figure out how to
// get to their hometown then just figure out how to get to their street from the station
// than to plan a route through every single street and highway.
//
// Depending on the size of Chunks (the abstract, macro-scale zones), this can result
// in a *HUGE* reduction in tiles to consider; e.g. with Chunks of width=7, we eliminate
// 49 bad candidates per chunk in one fell swoop when we reject the whole chunk.
//
// Unlike the built-in concept of Areas, Chunks are not rendered, aren't necessarily
// even *datums*, and can be dynamically manipulated, stacked and/or overlapped.
//
// Indeed, overlapping Chunks are a trick we can leverage to speed things up even more:
// by finding a set intersection of two Chunks' edges, we can find their points of contact
// and filter out pairs where the whole shared edge is a wall (or otherwise blocked).
//
// It may be tempting to build up taller trees, i.e. Chunks of Chunks. However, bear in mind
// this may be a net *loss* of performance due to extra overhead of de-abstracting stuff.
//
// Likewise, there is a sweet spot for Chunk size: very small ones are barely better, or even
// potentially _worse_ than raw tiles performance-wise, and too big ones lose too much detail
// and can degenerate to a Big Basic AStar if both start & end are within one Chunk.
//
// TL;DR engineer gud and profile things.
*/

/proc/trangeGeneric(rad = 0, var/centreX = null, var/centreY = null, var/centreZ = null) //alternative to range (ONLY processes turfs and thus less intensive)
	if(isnull(centreX) || isnull(centreY) || isnull(centreZ))
		return

	var/x_leftup = centreX - rad
	var/y_leftup = centreY - rad

	var/x_rightlo = centreX + rad
	var/y_rightlo = centreY + rad

	var/turf/x1y1 = locate(max(1, x_leftup), max(1, y_leftup), centreZ)
	var/turf/x2y2 = locate(min(x_rightlo, world.maxx), min(y_rightlo, world.maxy), centreZ)
	return block(x1y1,x2y2)


/proc/Chunks2Span(var/chunksize, var/overlap = 0, var/repeats = 1)
	/* Math helper for figuring out how many tiles a Chunk-ed map would cover.

	- chunksize: Width/height of a chunk, in tiles. Must be positive.

	- overlap: Chunks may share (alias) the same tiles.
	           If 1 - they share perimeter tiles, if 0 - purely adjacent, etc.

	- repeats: Number of chunks used.
	           e.g. chunksize=3, overlap=0, repeats=4 will cover 12 tiles (4*3)
	           in both directions.
	*/
	if(!chunksize || chunksize < 0)
		return

	if(!repeats || repeats < 0)
		return 0

	/* General logic: we 'shave' the overlapped part on one side from each chunk,
	//   so we just get R repeats of the smaller shaved chunk.
	//
	// Then we add the shaved part back just for the last chunk, because it won't
	//   be accounted for in the next one (since there *is* no next one).
	*/
	var/per_chunk_span = (chunksize - overlap)

	/* Need to check the formula - '+ overlap' generalizes o=(0, 1, 2)
	// but I didn't check higher values or negatives (although what would
	// these even be? This is not a ConvNet, we shouldn't have gaps here...):
	*/
	var/tilespan = (repeats * per_chunk_span) + overlap

	return tilespan


/proc/Chunks2Repeats(var/chunksize, var/overlap = 0, var/tilespan)
	/* Math helper for figuring out how many chunks a Chunk-ed map
	//   would require to cover a specified tilespan.
	//
	// Effectively, the *inverse* of Chunks2Span (like division to multiplication)
	//
	// For one dimension only! For 2D, you need to take the square of the result if
	//   the map is square, otherwise the product of results for the two tilespans.

	- chunksize: Width/height of a chunk, in tiles. Must be positive.

	- overlap: Chunks may share (alias) the same tiles.
	           If 1 - they share perimeter tiles, if 0 - purely adjacent, etc.

	- tilespan: Length of the map to cover.
	            e.g. chunksize=3, overlap=0, tilespan=12
	            will require 4 chunks (12 / 3)
	*/
	if(!chunksize || chunksize < 0)
		return

	if(!tilespan || tilespan < 0)
		return 0

	var/numerator = (tilespan - overlap)
	var/denominator = (chunksize - overlap)
	var/result = numerator / denominator

	return result


/proc/Compression2Chunksize(var/trg_compression_rate, var/overlap = 0, var/tilespan)
	/* Math helper for figuring out how big of a chunksize to set to achieve a desired
	// compression rate (i.e. CR=4 means that we have 4 chunks abstracting 16 turfs).
	//
	// This is the precise formula, which requires TileSpan.
	//
	// Realistically, we only care about integer solutions, which a quirk
	// of this formula lets us generalize this to infinite tilespans past
	// a certain point [if tilespan > (overlap * (tilespan - target CR))]
	// to a simpler Rule of Thumb:
	//
	// target_chunksize = (target_CR + overlap).
	//
	// So, for example, to compress an area 4-fold with overlap 2,
	// we need chunksize = (4+2) = 6.

	- trg_compression_rate: Expected compression rate. Must be positive.

	- overlap: Chunks may share (alias) the same tiles.
	           If 1 - they share perimeter tiles, if 0 - purely adjacent, etc.

	- tilespan: Length of the map to cover.
	            e.g. chunksize=3, overlap=0, tilespan=12
	            will require 4 chunks (12 / 3)
	*/
	if(!trg_compression_rate || trg_compression_rate < 0)
		return

	if(!tilespan || tilespan < 0)
		return 0

	var/result = (
		trg_compression_rate + (
			(overlap * (tilespan - trg_compression_rate)) / tilespan
		)
	)

	/* Since we can only use integer chunksizes, if Denominator > Numerator
	// all remaining solutions collapse to a single point (limit of the series,
	// which is just: `trg_compression_rate + overlap`)
	*/

	return result


/proc/tperimeter(var/radius = 1, var/centreX = null, var/centreY = null, var/centreZ = null, var/dirs = ALL_CARDINAL_DIRS, var/exclude_centre_tile = FALSE)
	/* Similar-ish to trange() and block(), but only locates and returns turfs on the PERIMETER of a square.
	// (with default dirchecker; can be replaced with a different filter for directional tiles or full block)
	// Intended for building abstract 'chunks' of turfs and checking connections for efficient pathfinding.
	//
	// This function assumes the centroid is placed
	// This will ONLY generate odd-sized chunks. Even-sized chunks require a different approach,
	// where the centroid is placed at a corner where four vertices meet.
	//
	// NOTE: OOB positions will not be truncated to mapsize, they will be *thrown out of the results*!
	//
	// - radius: Half-width of the chunk, e.g. radius=2 produces chunks 4-/5-tiles wide
	//             (depending on the exclude_center_tile argument)
	//           Despite the name, this is a Chebyshev measure on a square, not Euclidian on a circle.
	//
	// - centreX, centreY, centreZ - X/Y/Z coordinates of the centre of the chunk, duh.
	//                               If exclude_center_tile=TRUE, the 'true' centre is
	//                               effectively *in the Bottom-Left corner* of the turf
	//
	// - dirs - Bitflags of directions in which turfs will be returned; e.g. ALL_CARDINAL_DIRS returns
	//            the whole perimeter on one Z-level, EAST|WEST would generate a '| |' pattern, SOUTH|NORTH
	//            would return a '=' pattern and SOUTH|NORTH|EAST would be a ']' shape.
	//          With overlapping turfs, this can be used to efficiently iterate over shared vertices.
	//
	// - exclude_center_tile - If FALSE generates odd-sized chunks, if TRUE - even.
	//
	//                         The exact semantics of this are a bit trickier:
	//
	//                         o FALSE implies the chunk centroid is placed on the centre of
	//                           an *actual turf/tile* at position <centreX, centreY, centreZ>.
	//                           The effective chunk width is (2 * radius) + 1.
	//
	//                         o TRUE implies the centroid is placed at a corner where four tile vertices meet
	//                           (specifically, the *bottom-left corner* of the tile at position <centreX, centreY, centreZ>)
	//                           The effective chunk width is (2 * radius).
	//
	//                         In other words, with FALSE you can stand in the center of a chunk, with TRUE you cannot.
	*/
	if(isnull(centreX) || isnull(centreY) || isnull(centreZ) || isnull(dirs))
		return

	if(centreZ > world.maxz)
		// Z is not affected by width, so if it's bad
		// the results will always be empty anyway.
		return

	if(!radius || radius <= 0)
		return

	var/safe_radius = FLOOR(radius)
	var/centre_adjustment = (exclude_centre_tile ? 0.5 : 0)

	var/safeCentreX = centreX - centre_adjustment
	var/safeCentreY = centreY - centre_adjustment

	var/minX = safeCentreX - (safe_radius - centre_adjustment)
	var/maxX = safeCentreX + (safe_radius - centre_adjustment)

	var/minY = safeCentreY - (safe_radius - centre_adjustment)
	var/maxY = safeCentreY + (safe_radius - centre_adjustment)

	var/list/perimeter_turfs = list()

	for(var/Off = -safe_radius, Off <= safe_radius, Off++)
		/* Too clever by half O(N) solution
		// We exploit the fact that we always want a square.
		// Squares are symmetrical - if (X, Y) is valid, (Y, X) is valid.
		// Effectively, imagine spinning a wheel with 4 spokes such that
		//   we add the turfs where they touch an edge of the square.
		*/

		// r 2 c (3,3)
		// off -2 // -1 // 0 // 1

		if(exclude_centre_tile && !Off)
			// If the center is on a vertex, there are no zero offsets
			// e.g. for radius 1, perimeter offsets are (+/- 1, +/- 1)
			continue

		var/adjustment = 0

		if(exclude_centre_tile)
			adjustment = (Off < 0) ? 0.5 : -0.5

		var/PosX = safeCentreX + Off + adjustment
		var/PosY = safeCentreY + Off + adjustment

		/* Naively, this algorithm duplicates (aliases) shared corners,
		//   e.g. the Top-Left corner turf when generating Top & Left edges.
		//
		// As a semi-arbitrary design decision, each direction has been
		//   assigned a single corner to potentially deduplicate; this makes
		//   it a bit easier to reason about, since all 4 dirs
		//   follow the same pattern.
		*/
		if(dirs & WEST)
			if((PosY != maxY) || (!(dirs & NORTH))) // de-aliasing with Top row TL corner @ (minX, maxY)
				var/turf/cellLeft = locate(minX, PosY, centreZ) // (1, 1) // (1, 2) // (1, 3) // (1, 4) // (1, 5) SKIP
				if(cellLeft)
					perimeter_turfs.Add(cellLeft)

		if(dirs & EAST)
			if((PosY != minY) || (!(dirs & SOUTH))) // de-aliasing with Bottom row BR corner @ (maxX, minY)
				var/turf/cellRight = locate(maxX, PosY, centreZ) // (5, 1) SKIP // (5, 2) // (5, 3) // (5, 4) // (5, 5)
				if(cellRight)
					perimeter_turfs.Add(cellRight)

		if(dirs & SOUTH)
			if((PosX != minX) || (!(dirs & WEST))) // de-aliasing with Left row BL corner @ (minX, minY)
				var/turf/cellBottom = locate(PosX, minY, centreZ) // (1, 1) SKIP // (2, 1) // (3, 1) // (4, 1) // (5, 1)
				if(cellBottom)
					perimeter_turfs.Add(cellBottom)

		if(dirs & NORTH)
			if((PosX != maxX) || (!(dirs & EAST))) // de-aliasing with Right row TR corner @ (maxX, maxY)
				var/turf/cellTop = locate(PosX, maxY, centreZ) // (1, 5) // (2, 5) // (3, 5) // (4, 5) // (5, 5) SKIP
				if(cellTop)
					perimeter_turfs.Add(cellTop)


	return perimeter_turfs


/proc/chunkwidth2radius(var/width)
	if(!width || width < 0)
		return

	var/target_radius = FLOOR(width / 2)
	return target_radius


/proc/tperimeter_from_width(var/width = 3, var/centreX = null, var/centreY = null, var/centreZ = null, var/dirs = ALL_CARDINAL_DIRS)
	if(isnull(centreX) || isnull(centreY) || isnull(centreZ) || isnull(dirs))
		return

	var/is_odd = width % 2
	var/exclude_centre = !is_odd

	var/target_radius = chunkwidth2radius(width)

	var/result = tperimeter(
		radius = target_radius,
		centreX = centreX,
		centreY = centreY,
		centreZ = centreZ,
		dirs = dirs,
		exclude_centre_tile = exclude_centre
	)

	return result
