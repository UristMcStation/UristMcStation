/datum/ActivePathTracker
	var/list/path
	var/target
	var/min_dist = 0
	var/frustration = 0
	var/done = 0

	var/creation_time


/datum/ActivePathTracker/New(var/new_trg, var/new_path, var/new_min_dist=0, var/inh_frustration = 0)
	path = new_path
	target = new_trg
	min_dist = new_min_dist
	frustration = inh_frustration

	creation_time = world.time


/datum/ActivePathTracker/proc/SetDone()
	done = 1


/datum/ActivePathTracker/proc/IsDone()
	return done
