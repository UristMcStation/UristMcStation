// A persistent service that stores and fetches Chunk data


var/global/datum/chunkserver/chunkserver_singleton = null


/datum/chunkserver
	/* NOTE RE: chunk size
	//
	// For Geometry(TM) reasons, not all sizes are equally nice.
	//
	// Odd-sized chunks are easier to reason about, since they have
	//   a non-abstract centre tile, the smallest unit being 3x3.
	//
	// Then we might want to decompose things hierarchically.
	//
	// The general series formula is that for a valid size S,
	//   the next smallest aggregate of 4xS units is (2S-1),
	//   followed by (4S-3) and ((2n)S - (2n-1)) in general,
	//   assuming the default overlap of 1 tile.
	//
	// As a shortcut, here's the first couple good options:
	// => 3,
	// => 5 (= 4x3),
	// => 9 (= 4x5 = 16x3),
	// => 17 (= 4x9 = 16x5 = 64x3)
	//
	// 13 is decomposable, but to 7x7 units which are themselves not nice.
	//
	// 17 is *huge* - basically a screen's worth of tiles - so it's not very
	//    fine-grained; probably on overkill and better handled by a bunch of
	//    smaller moves and replanning after the move, unless you use PRA* or
	//    something similar.
	//
	//    Probably the upper useful bound for SS13, since the next candidate
	//    that is decomposable quite as nicely is *thirty-honking-three*.
	*/

	var/chunksize = CHUNK_SIZE_DEFAULT
	var/overlap = CHUNK_OVERLAP_DEFAULT

	// might change this to a list indexed by offset later
	var/dict/chunks = null


/datum/chunkserver/New(var/chunk_size = CHUNK_SIZE_DEFAULT, var/chunk_overlap = CHUNK_OVERLAP_DEFAULT)
	. = ..()

	chunksize = (chunk_size || chunksize || CHUNK_SIZE_DEFAULT)
	overlap = (chunk_overlap || overlap || CHUNK_OVERLAP_DEFAULT)
	chunks = new()


/datum/chunkserver/proc/ChunkForTile(var/posX, var/posY, var/posZ)
	if(isnull(posX) || isnull(posY) || isnull(posZ))
		return

	if(isnull(chunks))
		chunks = new()

	// We need to transform the position by -1 to account for DM's 1-based indexing =_=
	// Resolve shared chunks to the *right* - easier to deal with infinite positive coords this way
	// --X-=-X-=-X-=-X-=-X-- pattern with size=5, overlap=1 (= -> shared tile, X -> centre)
	var/chunkX = FLOOR((posX - 1) / (chunksize - overlap))
	//var/chunkX_offset = posX % chunksize

	var/chunkY = FLOOR((posY - 1) / (chunksize - overlap))

	// if modulo(s) are <= overlap, we're on the overlapping turfs
	var/chunk_key = "([chunkX],[chunkY])"

	var/datum/chunk/retrieved_chunk = chunks.Get(chunk_key)

	if(isnull(retrieved_chunk))
		// If not in the cache, build, cache and return a new chunk
		var/centreX = (chunksize - 1) * (chunkX + 1) - (chunksize % 2)
		var/centreY = (chunksize - 1) * (chunkY + 1) - (chunksize % 2)

		retrieved_chunk = new(centreX, centreY, posZ, chunksize)
		chunks[chunk_key] = retrieved_chunk

	return retrieved_chunk


/datum/chunkserver/proc/ChunkForAtom(var/atom/A)
	if(!A)
		return

	var/posX = A.x
	var/posY = A.y
	var/posZ = A.z

	var/result = ChunkForTile(posX, posY, posZ)

	return result


/proc/GetOrSetChunkserver(var/chunk_size = CHUNK_SIZE_DEFAULT, var/chunk_overlap = CHUNK_OVERLAP_DEFAULT)
	var/datum/chunkserver/local_chunkserver = chunkserver_singleton

	if (isnull(local_chunkserver))
		local_chunkserver = new(chunk_size, chunk_overlap)
		chunkserver_singleton = local_chunkserver

	return local_chunkserver



