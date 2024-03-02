/mob/verb/EnableDebug()
	set category = "Debug"
	src.verbs.Add(/client/proc/debug_variables)
	to_chat(usr, "[src] now wields the ultimate powah!")
	return


/atom/verb/TestChunkyAstar()
	set src in oview()

	var/turf/usr_pos = get_turf(usr)
	if(isnull(usr_pos))
		to_chat(usr, "You seem to be disembodied, cannot find you a path, sorry!")
		return

	var/list/path = ChunkyAStar(usr_pos, src)

	var/path_idx = 0
	to_chat(usr, " ")

	for(var/pos in path)
		path_idx++
		to_chat(usr, "PATH STEP [path_idx]: [pos]")

	//proc/ChunkyAStar(var/start, var/end, var/proc/adjacent, var/proc/dist, var/max_nodes = 0, var/max_node_depth = 30, var/min_target_dist = 0, var/proc/min_node_dist, var/list/adj_args = null, var/exclude)
	return
