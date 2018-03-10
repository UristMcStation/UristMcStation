/datum/shuttle/autodock/ferry/lift
	name = "Cargo Lift"
	shuttle_area = /area/station/shuttle/lift
	warmup_time = 3	//give those below some time to get out of the way
	waypoint_station = "nav_bearcat_lift_bottom"
	waypoint_offsite = "nav_bearcat_lift_top"
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