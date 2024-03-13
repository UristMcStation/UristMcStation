/mob/verb/FindChunkyPath(var/trg as mob in world.contents)
	set category = "ChunkyAStar"

	var/list/result = ChunkyAStar(
		start=src,
		end=trg,
	)

	if(!result)
		to_chat(usr, "Path not found!")
		return

	var/idx = 0
	var/datum/chunk/oldelem = null

	for(var/datum/chunk/pathelem in result)
		to_chat(usr, "Path: [idx++] = [pathelem] @ ([pathelem.centerX], [pathelem.centerY])")

		if(oldelem)
			var/turf/oldT = locate(floor(oldelem.centerX), floor(oldelem.centerY), floor(oldelem.centerZ))
			var/turf/newT = locate(floor(pathelem.centerX), floor(pathelem.centerY), floor(pathelem.centerZ))
			to_world_log(usr, "[oldT] => [newT]")
			newT.pDrawVectorbeam(oldT)

		oldelem = pathelem

	to_chat(usr, "")
	return result