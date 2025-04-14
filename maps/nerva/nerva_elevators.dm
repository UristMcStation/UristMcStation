/area/turbolift
	name = "\improper Turbolift"
	icon_state = "shuttle"
	requires_power = 0
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED

/*/area/turbolift/freightmain
	name = "Upper Cargo Bay"
	base_turf = /turf/simulated/open

/area/turbolift/freightsub
	name = "Lower Cargo Bay"
	base_turf = /turf/simulated/floor/plating

/obj/freight_elevator_map_holder/nerva
	icon = 'icons/turf/areas.dmi'
	icon_state = "bleh" //i dunno
	dir = NORTH
	areas_to_use = list(/area/turbolift/freightsub,/area/turbolift/freightmain)
	depth = 2*/

/area/cargo_lift/lift
  name = "Cargo Lift"
  icon_state = "shuttle3"
  base_turf = /turf/simulated/open

/datum/shuttle/autodock/ferry/liftnerva
	name = "Cargo Freight Elevator"
	shuttle_area = /area/cargo_lift/lift
	warmup_time = 3	//give those below some time to get out of the way
	waypoint_station = "nav_nerva_lift_bottom"
	waypoint_offsite = "nav_nerva_lift_top"
	sound_takeoff = 'sound/effects/lift_heavy_start.ogg'
	sound_landing = 'sound/effects/lift_heavy_stop.ogg'
	ceiling_type = null
	knockdown = 0

/obj/machinery/computer/shuttle_control/liftnerva
	name = "cargo freight elevator controls"
	shuttle_tag = "Cargo Freight Elevator"
	ui_template = "shuttle_control_console_lift.tmpl"
	icon_state = "tiny"
	icon_keyboard = "tiny_keyboard"
	icon_screen = "lift"
	density = FALSE

/obj/shuttle_landmark/liftnerva/top
	name = "Top Deck"
	landmark_tag = "nav_nerva_lift_top"
	base_area = /area/logistics/uppercargo
	base_turf = /turf/simulated/open

/obj/shuttle_landmark/liftnerva/bottom
	name = "Lower Deck"
	landmark_tag = "nav_nerva_lift_bottom"
	base_area = /area/logistics/lowercargo
	base_turf = /turf/simulated/floor/plating

//i fucking hate myself

/area/turbolift/main_fourth_deck		//These are backwards somehow, and it really hurts my head - Shippy //Ships are backwards. First deck is the top floor.
	name = "Fourth Deck"
	base_turf = /turf/simulated/floor/plating
	lift_announce_str = "Arriving at Fourth Deck: Expedition Hangar. AI Upload. Science. Virology. Emergency Escape Pods."

/area/turbolift/main_third_deck
	name = "Third Deck"
	base_turf = /turf/simulated/open
	lift_announce_str = "Arriving at Third Deck: Bridge. Medbay. Security. Cargo. Lower Engineering. Kitchen. Bar."

/area/turbolift/main_second_deck
	name = "Second Deck"
	base_turf = /turf/simulated/open
	lift_announce_str = "Arriving at Second Deck: Upper Engineering. Atmospherics. Emergency Escape Pods. Tool Storage. Chapel. Library."

/area/turbolift/main_first_deck
	name = "First Deck"
	base_turf = /turf/simulated/open
	lift_announce_str = "Arriving at First Deck: AI Core. Docking Port. Security Checkpoint. Bluspace Drive."

/obj/nerva_lift_map_holder
	name = "turbolift map placeholder"
//	icon = 'icons/obj/turbolift_preview_3x3.dmi'
	icon_state = "bleh"
	dir = EAST         // Direction of the holder determines the placement of the lift control panel and doors.
	var/depth = 4       // Number of floors to generate, including the initial floor.
	var/lift_size_x = 2 // Number of turfs on each axis to generate in addition to the first
	var/lift_size_y = 2 // ie. a 3x3 lift would have a value of 2 in each of these variables.

	// Various turf and door types used when generating the turbolift floors.
	var/wall_type =  /turf/simulated/wall/elevator
	var/floor_type = /turf/simulated/floor/tiled/dark
	var/door_type =  /obj/machinery/door/airlock/lift

	var/list/areas_to_use = list(/area/turbolift/main_fourth_deck,/area/turbolift/main_third_deck,/area/turbolift/main_second_deck, /area/turbolift/main_first_deck)

/obj/nerva_lift_map_holder/Destroy()
	turbolifts -= src
	return ..()

/obj/nerva_lift_map_holder/New()
	turbolifts += src
	..()

/obj/nerva_lift_map_holder/Initialize()
	. = ..()
	// Create our system controller.
	var/datum/turbolift/lift = new()

	// Holder values since we're moving this object to null ASAP.
	var/ux = x
	var/uy = y
	var/uz = z
	var/udir = dir
	forceMove(null)

	// These modifiers are used in relation to the origin
	// to place the system control panels and doors.
	var/int_panel_x
	var/int_panel_y
	var/ext_panel_x
	var/ext_panel_y
	var/door_x1
	var/door_y1
	var/door_x2
	var/door_y2
	var/door_x3
//	var/door_x4
	var/light_x1
	var/light_x2
	var/light_y1
	var/light_y2

	var/az = 1
	var/ex = (ux+lift_size_x)
	var/ey = (uy+lift_size_y)
	var/ez = (uz+(depth-1))

	switch(dir)

		if(EAST)

			int_panel_x = ux + floor(lift_size_x/2)
			int_panel_y = ey
			ext_panel_x = ex+2
			ext_panel_y = ey + 1

			door_x1 = ex
			door_y1 = uy + 1
			door_x2 = ex + 1
			door_y2 = ey - 1
			door_x3 = door_x1 - 3
//			door_x4 = door_x3 -1

			light_x1 = ux + 1
			light_x2 = ux + 1
			light_y2 = uy + 2
			light_y1 = light_y2 -2

	// Generate each floor and store it in the controller datum.
	for(var/cz = uz;cz<=ez;cz++)

		var/datum/turbolift_floor/cfloor = new()
		lift.floors += cfloor

		var/list/floor_turfs = list()
		// Update the appropriate turfs.
		for(var/tx = ux to ex)
			for(var/ty = uy to ey)

				var/turf/checking = locate(tx,ty,cz)

				if(!istype(checking))
					log_debug("[name] cannot find a component turf at [tx],[ty] on floor [cz]. Aborting.")
					qdel(src)
					return

				// Update path appropriately if needed.
				var/swap_to = /turf/simulated/open
				if(cz == uz)                                                                       // Elevator.
					if((tx == ux || ty == uy || tx == ex || ty == ey) && !(tx >= door_x1 && tx <= door_x2 && ty >= door_y1 && ty <= door_y2))
						swap_to = floor_type //let's try this
					else
						swap_to = floor_type

				if(checking.type != swap_to)
					checking.ChangeTurf(swap_to)
					// Let's make absolutely sure that we have the right turf.
					checking = locate(tx,ty,cz)

				// Clear out contents.
				for(var/atom/movable/thing in checking.contents)
					if(thing.simulated)
						qdel(thing)

				if(tx >= ux && tx <= ex && ty >= uy && ty <= ey)
					floor_turfs += checking

		// Place exterior doors.
		for(var/tx = door_x1 to door_x2)
			for(var/ty = door_y1 to door_y2)
				var/turf/checking = locate(tx,ty,cz)
				var/internal = 1
				if(!(checking in floor_turfs))
					internal = 0
					if(checking.type != floor_type)
						checking.ChangeTurf(floor_type)
						checking = locate(tx,ty,cz)
					for(var/atom/movable/thing in checking.contents)
						if(thing.simulated)
							qdel(thing)
				if(checking.type == floor_type) // Don't build over empty space on lower levels.
					var/obj/machinery/door/airlock/lift/newdoor = new door_type(checking)
					if(internal)
						qdel(newdoor)
//						lift.doors += newdoor
//						newdoor.lift = cfloor
					else
						cfloor.doors += newdoor
						newdoor.floor = cfloor


		for(var/dy = door_y1 to door_y2)
			var/dx = door_x3
			var/turf/checking = locate(dx,dy,cz)
			var/internal = 1
			if(!(checking in floor_turfs))
				internal = 0
				if(checking.type != floor_type)
					checking.ChangeTurf(floor_type)
					checking = locate(dx,dy,cz)
				for(var/atom/movable/thing in checking.contents)
					if(thing.simulated)
						qdel(thing)
			if(checking.type == floor_type) // Don't build over empty space on lower levels.
				var/obj/machinery/door/airlock/lift/newdoor = new door_type(checking)
				if(internal)
					qdel(newdoor)
//						lift.doors += newdoor
//						newdoor.lift = cfloor
				else
					cfloor.doors += newdoor
					newdoor.floor = cfloor

		// Place exterior control panel.
		var/turf/placing = locate(ext_panel_x, ext_panel_y, cz)
		var/obj/structure/lift/button/panel_ext = new(placing, lift)
		panel_ext.floor = cfloor
		panel_ext.set_dir(udir)
		cfloor.ext_panel = panel_ext
		var/otherpanel_x = ext_panel_x - 6
		var/turf/placing0 = locate(otherpanel_x, ext_panel_y, cz)
		var/obj/structure/lift/button/panel_ext2 = new(placing0, lift)
		panel_ext2.floor = cfloor
		panel_ext2.set_dir(WEST)

		// Place lights
		var/turf/placing1 = locate(light_x1, light_y1, cz)
		var/turf/placing2 = locate(light_x2, light_y2, cz)
		var/obj/machinery/light/light1 = new(placing1, light)
		var/obj/machinery/light/light2 = new(placing2, light)
		light1.set_dir(SOUTH)
		light2.set_dir(NORTH)

		// Update area.
		if(az > length(areas_to_use))
			log_debug("Insufficient defined areas in turbolift datum, aborting.")
			qdel(src)
			return

		var/area_path = areas_to_use[az]
		for(var/thing in floor_turfs)
			new area_path(thing)
		var/area/A = locate(area_path)
		cfloor.set_area_ref("\ref[A]")
		az++

	// Place lift panel.
	var/turf/T = locate(int_panel_x, int_panel_y, uz)
	lift.control_panel_interior = new(T, lift)
	lift.control_panel_interior.set_dir(SOUTH)
	lift.current_floor = lift.floors[1]

	lift.open_doors()

	qdel(src) // We're done.
