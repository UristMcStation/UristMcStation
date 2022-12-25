/mob/goai/sim/proc/FindPathTo(var/trg, var/min_dist = 0, var/avoid = null)
	var/list/path = AStar(get_turf(loc), trg, /proc/fCardinalTurfs, /proc/fDistance, 0, pathing_dist_cutoff, min_target_dist = min_dist, exclude = avoid)
	return path


/mob/goai/sim/proc/BuildPathTrackerTo(var/trg, var/min_dist = 0, var/avoid = null, var/inh_frustration = 0)
	var/datum/ActivePathTracker/pathtracker = null
	var/list/path = FindPathTo(trg,  min_dist, avoid)

	if(path)
		pathtracker = new /datum/ActivePathTracker(trg, path, min_dist, inh_frustration)

	return pathtracker


/mob/goai/sim/proc/StartNavigateTo(var/trg, var/min_dist = 0, var/avoid = null, var/inh_frustration = 0)
	is_repathing = 1

	var/datum/ActivePathTracker/pathtracker = BuildPathTrackerTo(trg, min_dist, inh_frustration)

	if(pathtracker)
		active_path = pathtracker

	is_repathing = 0
	return active_path
