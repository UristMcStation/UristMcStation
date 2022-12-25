/mob/verb/FindChunkyPath(var/trg as mob in world.contents)
	set category = "ChunkyAStar"

	var/list/result = ChunkyAStar(
		start=src,
		end=trg,
	)

	if(!result)
		usr << "Path not found!"
		return

	var/idx = 0
	var/datum/chunk/oldelem = null

	for(var/datum/chunk/pathelem in result)
		usr << "Path: [idx++] = [pathelem] @ ([pathelem.centerX], [pathelem.centerY])"

		if(oldelem)
			var/turf/oldT = locate(floor(oldelem.centerX), floor(oldelem.centerY), floor(oldelem.centerZ))
			var/turf/newT = locate(floor(pathelem.centerX), floor(pathelem.centerY), floor(pathelem.centerZ))
			world.log << "[oldT] => [newT]"
			newT.pDrawVectorbeam(oldT)

		oldelem = pathelem

	usr << ""
	return result