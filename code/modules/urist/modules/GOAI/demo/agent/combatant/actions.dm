/* In this module:
===================

 - angle2dir helper (might be moved)
 - Misc. actions (not worth their own module yet)

*/

/*
/proc/angle2dir(var/angle)
	var/true_angle = round(CLOCKWISE_ANGLE(angle))
	var/direction = null

	switch (true_angle)
		if (0 to 44) direction = EAST
		if (45 to 89) direction = NORTHEAST
		if (90 to 134) direction = NORTH
		if (135 to 179) direction = NORTHWEST
		if (180 to 224) direction = WEST
		if (225 to 269) direction = SOUTHWEST
		if (270 to 314) direction = SOUTH
		if (315 to 360) direction = SOUTHEAST

	//to_world_log("TRUE ANGLE: [true_angle] => DIR: [direction]")
	return direction
*/


/mob/goai/combatant/proc/HandleIdling(var/datum/ActionTracker/tracker)
	active_path = null
	Idle()

	if(tracker.IsOlderThan(20))
		tracker.SetDone()

	return


/mob/goai/combatant/proc/HandleShoot(var/datum/ActionTracker/tracker)
	if (tracker.IsStopped())
		return

	if(tracker.IsOlderThan(src.ai_tick_delay * 2))
		tracker.SetFailed()
		return

	states[STATE_CANFIRE] = TRUE
	tracker.SetDone()

	return


/mob/goai/combatant/proc/HandleShootOld(var/datum/ActionTracker/tracker)
	if (tracker.IsStopped())
		return

	if(tracker.IsOlderThan(src.ai_tick_delay * 2))
		tracker.SetFailed()
		return

	var/obj/gun/my_gun = locate(/obj/gun) in src.contents

	if(isnull(my_gun))
		to_world_log("Gun not found for [src] to shoot D;")
		return

	var/atom/target = GetTarget()
	var/successful = Shoot(my_gun, target)

	if(successful)
		tracker.SetDone()

	return
