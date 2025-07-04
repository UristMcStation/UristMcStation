#define DOCK_ATTEMPT_TIMEOUT 200	//how long in ticks we wait before assuming the docking controller is broken or blown up.

/datum/shuttle/autodock
	var/in_use = null	//tells the controller whether this shuttle needs processing, also attempts to prevent double-use
	var/last_dock_attempt_time = 0
	var/current_dock_target
	//ID of the controller on the shuttle
	var/dock_target = null
	var/datum/computer/file/embedded_program/docking/shuttle_docking_controller
	var/docking_codes

	var/obj/shuttle_landmark/next_location  //This is only used internally.
	var/datum/computer/file/embedded_program/docking/active_docking_controller

	var/obj/shuttle_landmark/landmark_transition  //This variable is type-abused initially: specify the landmark_tag, not the actual landmark.
	var/move_time = 120		//the time spent in the transition area

	category = /datum/shuttle/autodock
	flags = SHUTTLE_FLAGS_PROCESS | SHUTTLE_FLAGS_ZERO_G

/datum/shuttle/autodock/New(_name, obj/shuttle_landmark/start_waypoint)
	..(_name, start_waypoint)

	//Initial dock
	active_docking_controller = current_location.docking_controller
	update_docking_target(current_location)
	if(active_docking_controller)
		set_docking_codes(active_docking_controller.docking_codes)
	else if(GLOB.using_map.use_overmap)
		var/obj/overmap/visitable/location = map_sectors["[current_location.z]"]
		if(location && location.docking_codes)
			set_docking_codes(location.docking_codes)
	dock()

	//Optional transition area
	if(landmark_transition)
		landmark_transition = SSshuttle.get_landmark(landmark_transition)

/datum/shuttle/autodock/Destroy()
	next_location = null
	active_docking_controller = null
	landmark_transition = null

	return ..()

/datum/shuttle/autodock/proc/set_docking_codes(code)
	docking_codes = code
	if(shuttle_docking_controller)
		shuttle_docking_controller.docking_codes = code

/datum/shuttle/autodock/shuttle_moved()
	force_undock() //bye!
	..()

/datum/shuttle/autodock/proc/update_docking_target(obj/shuttle_landmark/location)
	if(location && location.special_dock_targets && location.special_dock_targets[name])
		current_dock_target = location.special_dock_targets[name]
	else
		current_dock_target = dock_target
	shuttle_docking_controller = SSshuttle.docking_registry[current_dock_target]
/*
	Docking stuff
*/
/datum/shuttle/autodock/proc/dock()
	if(active_docking_controller && shuttle_docking_controller)
		shuttle_docking_controller.initiate_docking(active_docking_controller.id_tag)
		last_dock_attempt_time = world.time

/datum/shuttle/autodock/proc/undock()
	if(shuttle_docking_controller)
		shuttle_docking_controller.initiate_undocking()

/datum/shuttle/autodock/proc/force_undock()
	if(shuttle_docking_controller)
		shuttle_docking_controller.force_undock()

/datum/shuttle/autodock/proc/check_docked()
	if(shuttle_docking_controller)
		return shuttle_docking_controller.docked()
	return TRUE

/datum/shuttle/autodock/proc/check_undocked()
	if(shuttle_docking_controller)
		return shuttle_docking_controller.can_launch()
	return TRUE

/*
	Please ensure that long_jump() and short_jump() are only called from here. This applies to subtypes as well.
	Doing so will ensure that multiple jumps cannot be initiated in parallel.
*/
/datum/shuttle/autodock/Process()
	switch(process_state)
		if (WAIT_LAUNCH)
			if(check_undocked())
				//*** ready to go
				process_launch()

		if (FORCE_LAUNCH)
			process_launch()

		if (WAIT_ARRIVE)
			if (moving_status == SHUTTLE_IDLE)
				//*** we made it to the destination, update stuff
				process_arrived()
				process_state = WAIT_FINISH

		if (WAIT_FINISH)
			if (world.time > last_dock_attempt_time + DOCK_ATTEMPT_TIMEOUT || check_docked())
				//*** all done here
				process_state = IDLE_STATE
				arrived()

//not to be confused with the arrived() proc
/datum/shuttle/autodock/proc/process_arrived()
	active_docking_controller = next_location.docking_controller
	update_docking_target(next_location)
	dock()

	next_location = null
	in_use = null	//release lock

/datum/shuttle/autodock/proc/get_travel_time()
	return move_time

/datum/shuttle/autodock/proc/process_launch()
	if(!next_location.is_valid(src) || current_location.cannot_depart(src))
		process_state = IDLE_STATE
		in_use = null
		return
	if (move_time && landmark_transition)
		. = long_jump(next_location, landmark_transition, move_time)
	else
		. = short_jump(next_location)
	process_state = WAIT_ARRIVE

/*
	Guards
*/
/datum/shuttle/autodock/proc/can_launch()
	return (next_location && next_location.is_valid(src) && !current_location.cannot_depart(src) && moving_status == SHUTTLE_IDLE && !in_use)

/datum/shuttle/autodock/proc/can_force()
	return (next_location && next_location.is_valid(src) && !current_location.cannot_depart(src) && moving_status == SHUTTLE_IDLE && process_state == WAIT_LAUNCH)

/datum/shuttle/autodock/proc/can_cancel()
	return (moving_status == SHUTTLE_WARMUP || process_state == WAIT_LAUNCH || process_state == FORCE_LAUNCH)

/*
	"Public" procs
*/
/datum/shuttle/autodock/proc/launch(user)
	if (!can_launch()) return

	in_use = user	//obtain an exclusive lock on the shuttle

	process_state = WAIT_LAUNCH
	undock()

/datum/shuttle/autodock/proc/force_launch(user)
	if (!can_force()) return

	in_use = user	//obtain an exclusive lock on the shuttle

	process_state = FORCE_LAUNCH

/datum/shuttle/autodock/proc/cancel_launch(user)
	if (!can_cancel()) return

	moving_status = SHUTTLE_IDLE
	process_state = WAIT_FINISH
	in_use = null

	//whatever we were doing with docking: stop it, then redock
	force_undock()
	spawn(1 SECOND)
		dock()

//returns 1 if the shuttle is getting ready to move, but is not in transit yet
/datum/shuttle/autodock/proc/is_launching()
	return (moving_status == SHUTTLE_WARMUP || process_state == WAIT_LAUNCH || process_state == FORCE_LAUNCH)

//This gets called when the shuttle finishes arriving at it's destination
//This can be used by subtypes to do things when the shuttle arrives.
//Note that this is called when the shuttle leaves the WAIT_FINISHED state, the proc name is a little misleading
/datum/shuttle/autodock/proc/arrived()
	return	//do nothing for now

/obj/shuttle_landmark/transit
	flags = SLANDMARK_FLAG_ZERO_G
