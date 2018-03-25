/datum/shuttle/autodock/ferry/lift
	name = "Cargo Lift"
	shuttle_area = /area/station/shuttle/lift
	warmup_time = 3
	move_time = 1 SECOND
	waypoint_station = "nav_asteroid_lift_bottom"
	landmark_transition = "nav_asteroid_lift_middle"
	waypoint_offsite = "nav_asteroid_lift_top"
	sound_takeoff = 'sound/effects/lift_heavy_start.ogg'
	sound_landing = 'sound/effects/lift_heavy_stop.ogg'
	ceiling_type = null
	knockdown = 0

/obj/machinery/computer/shuttle_control/lift
	name = "cargo lift controls"
	shuttle_tag = "Cargo Lift"
	ui_template = "shuttle_control_console_lift.tmpl"
	icon_state = "tiny"
	icon_keyboard = "tiny_keyboard"
	icon_screen = "lift"
	density = 0

/obj/effect/shuttle_landmark/lift/top
	name = "Supply Level"
	landmark_tag = "nav_asteroid_lift_top"
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/lift/mid
	landmark_tag = "nav_asteroid_lift_top"
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/lift/bottom
	name = "Department Level"
	landmark_tag = "nav_asteroid_lift_bottom"
	base_turf = /turf/simulated/floor/plating