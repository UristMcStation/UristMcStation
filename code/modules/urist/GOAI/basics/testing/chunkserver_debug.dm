/mob/verb/FetchChunkServer()
	set category = "ChunkServer"

	var/datum/chunkserver/chunkserver = GetOrSetChunkserver()

	to_chat(usr, "ChunkServer: [chunkserver] ([ref(chunkserver)])")
	to_chat(usr, "")

	return chunkserver


/mob/verb/ChunkForTile()
	set category = "ChunkServer"

	var/datum/chunkserver/chunkserver = FetchChunkServer()
	//to_chat(usr, "ChunkServer: [chunkserver] ([ref(chunkserver)])")

	var/raw_result = chunkserver.ChunkForTile(usr.x, usr.y, usr.z)
	var/datum/chunk/retrieved_chunk = raw_result

	to_chat(usr, "POS: [usr.x], [usr.y], [usr.z]")
	to_chat(usr, "retrieved_chunk: [retrieved_chunk] - [retrieved_chunk.centerX], [retrieved_chunk.centerY], [retrieved_chunk.centerZ], W=[retrieved_chunk.width]")
	to_chat(usr, "")

	return retrieved_chunk


/mob/verb/DirIsOpen(var/dir as null|anything in list(NORTH, SOUTH, EAST, WEST))
	set category = "ChunkServer"

	if(isnull(dir))
		return

	var/datum/chunkserver/chunkserver = FetchChunkServer()
	//to_chat(usr, "ChunkServer: [chunkserver] ([ref(chunkserver)])")

	var/raw_chunk = chunkserver.ChunkForTile(usr.x, usr.y, usr.z)
	var/datum/chunk/retrieved_chunk = raw_chunk

	if(isnull(retrieved_chunk))
		to_chat(usr, "Could not retrieve a chunk for current tile!")
		to_chat(usr, "")
		return

	var/result = retrieved_chunk.DirOpen(dir)

	to_chat(usr, "[usr]: DirIsOpen Result for [dir] is [result]")
	to_chat(usr, "")

	return result

