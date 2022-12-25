/mob/verb/FetchChunkServer()
	set category = "ChunkServer"

	var/datum/chunkserver/chunkserver = GetOrSetChunkserver()

	usr << "ChunkServer: [chunkserver] ([ref(chunkserver)])"
	usr << ""

	return chunkserver


/mob/verb/ChunkForTile()
	set category = "ChunkServer"

	var/datum/chunkserver/chunkserver = FetchChunkServer()
	//usr << "ChunkServer: [chunkserver] ([ref(chunkserver)])"

	var/raw_result = chunkserver.ChunkForTile(usr.x, usr.y, usr.z)
	var/datum/chunk/retrieved_chunk = raw_result

	usr << "POS: [usr.x], [usr.y], [usr.z]"
	usr << "retrieved_chunk: [retrieved_chunk] - [retrieved_chunk.centerX], [retrieved_chunk.centerY], [retrieved_chunk.centerZ], W=[retrieved_chunk.width]"
	usr << ""

	return retrieved_chunk


/mob/verb/DirIsOpen(var/dir as null|anything in list(NORTH, SOUTH, EAST, WEST))
	set category = "ChunkServer"

	if(isnull(dir))
		return

	var/datum/chunkserver/chunkserver = FetchChunkServer()
	//usr << "ChunkServer: [chunkserver] ([ref(chunkserver)])"

	var/raw_chunk = chunkserver.ChunkForTile(usr.x, usr.y, usr.z)
	var/datum/chunk/retrieved_chunk = raw_chunk

	if(isnull(retrieved_chunk))
		usr << "Could not retrieve a chunk for current tile!"
		usr << ""
		return

	var/result = retrieved_chunk.DirOpen(dir)

	usr << "[usr]: DirIsOpen Result for [dir] is [result]"
	usr << ""

	return result

