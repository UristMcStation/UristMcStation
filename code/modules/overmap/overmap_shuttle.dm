#define waypoint_sector(waypoint) map_sectors["[waypoint.z]"]

/datum/shuttle/autodock/overmap
	warmup_time = 10

	var/range = 0	//how many overmap tiles can shuttle go, for picking destinations and returning.
	var/fuel_consumption = 0 //Amount of moles of gas consumed per trip; If zero, then shuttle is magic and does not need fuel
	var/list/obj/structure/fuel_port/fuel_ports //the fuel ports of the shuttle (but usually just one)

	category = /datum/shuttle/autodock/overmap

/datum/shuttle/autodock/overmap/New(_name, obj/shuttle_landmark/start_waypoint)
	..(_name, start_waypoint)
	refresh_fuel_ports_list()

/datum/shuttle/autodock/overmap/proc/refresh_fuel_ports_list() //loop through all
	fuel_ports = list()
	for(var/area/A in shuttle_area)
		for(var/obj/structure/fuel_port/fuel_port_in_area in A)
			fuel_port_in_area.parent_shuttle = src
			fuel_ports += fuel_port_in_area

/datum/shuttle/autodock/overmap/fuel_check()
	if(!src.try_consume_fuel()) //insufficient fuel
		for(var/area/A in shuttle_area)
			for(var/mob/living/M in A)
				M.show_message("<span class='warning'>You hear the shuttle engines sputter... perhaps it doesn't have enough fuel?</span>", AUDIBLE_MESSAGE,
				"<span class='warning'>The shuttle shakes but fails to take off.</span>", VISIBLE_MESSAGE)
				return 0 //failure!
	return 1 //success, continue with launch

/datum/shuttle/autodock/overmap/proc/can_go()
	if(!next_location)
		return FALSE
	if(moving_status == SHUTTLE_INTRANSIT)
		return FALSE //already going somewhere, current_location may be an intransit location instead of in a sector
	return get_dist(waypoint_sector(current_location), waypoint_sector(next_location)) <= range

/datum/shuttle/autodock/overmap/can_launch()
	return ..() && can_go()

/datum/shuttle/autodock/overmap/can_force()
	return ..() && can_go()

/datum/shuttle/autodock/overmap/get_travel_time()
	var/distance_mod = get_dist(waypoint_sector(current_location),waypoint_sector(next_location))
	return move_time * (1 + distance_mod)

/datum/shuttle/autodock/overmap/proc/set_destination(obj/shuttle_landmark/A)
	if(A != current_location)
		next_location = A
		move_time = initial(move_time) * (1 + get_dist(waypoint_sector(current_location),waypoint_sector(next_location)))

/datum/shuttle/autodock/overmap/proc/get_possible_destinations()
	var/list/res = list()
	for (var/obj/overmap/visitable/S in range(get_turf(waypoint_sector(current_location)), range))
		var/list/waypoints = S.get_waypoints(name)
		for(var/obj/shuttle_landmark/LZ in waypoints)
			if(LZ.is_valid(src))
				res["[waypoints[LZ]] - [LZ.name]"] = LZ
	return res

/datum/shuttle/autodock/overmap/get_location_name()
	if(moving_status == SHUTTLE_INTRANSIT)
		return "In transit"
	return "[waypoint_sector(current_location)] - [current_location]"

/datum/shuttle/autodock/overmap/get_destination_name()
	if(!next_location)
		return "None"
	return "[waypoint_sector(next_location)] - [next_location]"

/datum/shuttle/autodock/overmap/proc/try_consume_fuel() //returns 1 if successful, returns 0 if error (like insufficient fuel)
	if(!fuel_consumption)
		return 1 //shuttles with zero fuel consumption are magic and can always launch
	if(!length(fuel_ports))
		return 0 //Nowhere to get fuel from
	var/list/obj/item/tank/fuel_tanks = list()
	for(var/obj/structure/FP in fuel_ports) //loop through fuel ports and assemble list of all fuel tanks
		var/obj/item/tank/FT = locate() in FP
		if(FT)
			fuel_tanks += FT
	if(!length(fuel_tanks))
		return 0 //can't launch if you have no fuel TANKS in the ports
	var/total_flammable_gas_moles = 0
	for(var/obj/item/tank/FT in fuel_tanks)
		total_flammable_gas_moles += FT.air_contents.get_by_flag(XGM_GAS_FUEL)
	if(total_flammable_gas_moles < fuel_consumption) //not enough fuel
		return 0
	// We are going to succeed if we got to here, so start consuming that fuel
	var/fuel_to_consume = fuel_consumption
	for(var/obj/item/tank/FT in fuel_tanks) //loop through tanks, consume their fuel one by one
		var/fuel_available = FT.air_contents.get_by_flag(XGM_GAS_FUEL)
		if(!fuel_available) // Didn't even have fuel.
			continue
		if(fuel_available >= fuel_to_consume)
			FT.remove_air_by_flag(XGM_GAS_FUEL, fuel_to_consume)
			return 1 //ALL REQUIRED FUEL HAS BEEN CONSUMED, GO FOR LAUNCH!
		else //this tank doesn't have enough to launch shuttle by itself, so remove all its fuel, then continue loop
			fuel_to_consume -= fuel_available
			FT.remove_air_by_flag(XGM_GAS_FUEL, fuel_available)

/obj/structure/fuel_port
	name = "fuel port"
	desc = "The fuel input port of the shuttle. Holds one fuel tank. Use a crowbar to open and close it."
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "fuel_port"
	density = FALSE
	anchored = TRUE
	var/icon_closed = "fuel_port"
	var/icon_empty = "fuel_port_empty"
	var/icon_full = "fuel_port_full"
	var/opened = 0
	var/parent_shuttle

/obj/structure/fuel_port/Initialize()
	. = ..()
	new /obj/item/tank/hydrogen(src)

/obj/structure/fuel_port/attack_hand(mob/user as mob)
	if(!opened)
		to_chat(user, "<span class='notice'>The door is secured tightly. You'll need a crowbar to open it.</span>")
		return
	else if(length(contents) > 0)
		user.put_in_hands(contents[1])
	update_icon()

/obj/structure/fuel_port/on_update_icon()
	if(opened)
		if(length(contents) > 0)
			icon_state = icon_full
		else
			icon_state = icon_empty
	else
		icon_state = icon_closed


/obj/structure/fuel_port/use_tool(obj/item/tool, mob/user, list/click_params)
	// Crowbar - Toggle open
	if (isCrowbar(tool))
		opened = !opened
		playsound(src, opened ? 'sound/effects/locker_open.ogg' : 'sound/effects/locker_close.ogg', 50, TRUE)
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] [opened ? "opens" : "closes"] \the [src] with \a [tool]."),
			SPAN_NOTICE("You [opened ? "open" : "close"] \the [src] with \the [tool].")
		)
		return TRUE

	// Tank - Insert tank
	if (istype(tool, /obj/item/tank))
		if (!opened)
			USE_FEEDBACK_FAILURE("\The [src] needs to be opened before you can insert \the [tool].")
			return TRUE
		var/obj/item/tank/tank = locate() in src
		if (tank)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [tank] installed.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] inserts \a [tool] in \the [src]."),
			SPAN_NOTICE("You insert \the [tool] in \the [src].")
		)
		return TRUE

	return ..()


/obj/structure/fuel_port/attack_robot(mob/user)
	if (Adjacent(user))
		attack_hand(user)

// Walls hide stuff inside them, but we want to be visible.
/obj/structure/fuel_port/hide()
	return
