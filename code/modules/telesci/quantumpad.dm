
/obj/machinery/power/quantumpad
	name = "quantum pad"
	desc = "A bluespace quantum-linked telepad used for teleporting objects to other quantum pads."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "qpad-idle"
	anchored = TRUE
	use_power = 1
	idle_power_usage = 200
	active_power_usage = 5000
	var/teleport_cooldown = 400 //30 seconds base due to base parts
	var/teleport_speed = 50
	var/last_teleport //to handle the cooldown
	var/teleporting = 0 //if it's in the process of teleporting
	var/power_efficiency = 1
	var/obj/machinery/power/quantumpad/linked_pad

	//mapping
	var/static/list/mapped_quantum_pads = list()
	var/map_pad_id = "" as text //what's my name
	var/map_pad_link_id = "" as text //who's my friend

/obj/item/stock_parts/circuitboard/telepad
	name = "circuit board (telepad)"
	build_path = /obj/machinery/power/quantumpad
	board_type = "machine"
	origin_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 4, TECH_BLUESPACE = 4)
	req_components = list(
							/obj/item/stock_parts/subspace/crystal = 1,
							/obj/item/stock_parts/capacitor = 2,
							/obj/item/stack/cable_coil = 5,
							/obj/item/stock_parts/console_screen = 1)

/obj/machinery/power/quantumpad/New()
	..()
	connect_to_network()
	if(map_pad_id)
		mapped_quantum_pads[map_pad_id] = src

/obj/machinery/power/quantumpad/Destroy()
	mapped_quantum_pads -= map_pad_id
	return ..()

/obj/machinery/power/quantumpad/RefreshParts()
	var/E = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		E += M.rating
	power_efficiency = E

	E = 0
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		E += C.rating

	teleport_speed = initial(teleport_speed)
	teleport_speed -= (E*10)
	teleport_cooldown = initial(teleport_cooldown)
	teleport_cooldown -= (E * 100)

/obj/machinery/power/quantumpad/use_tool(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/device/multitool))
		if(panel_open)
			var/obj/item/device/multitool/M = I
			M.buffer_name = src
			to_chat(user, "<span class='notice'>You save the data in [I]'s buffer.</span>")
			return 1
		else
			var/obj/item/device/multitool/M = I
			if(istype(M.buffer_name, /obj/machinery/power/quantumpad))
				linked_pad = M.buffer_name
				to_chat(user, "<span class='notice'>You link [src] to the one in [I]'s buffer.</span>")
				return 1
		return

	return ..()

/obj/machinery/power/quantumpad/on_update_icon()
	. = ..()

	if(inoperable() || panel_open)
		icon_state = "pad-idle-o"
	else
		icon_state = initial(icon_state)

/obj/machinery/power/quantumpad/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(panel_open)
		to_chat(user, "<span class='warning'>The panel must be closed before operating this machine!</span>")
		return

	if(istype(get_area(src), /area/shuttle))
		to_chat(user, "<span class='warning'>This is too unstable a platform for \the [src] to operate on!</span>")
		return

	if(!powernet)
		to_chat(user, "<span class='warning'>[src] is not attached to a powernet!</span>")
		return

	if(!linked_pad || QDELETED(linked_pad))
		if(!map_pad_link_id || !initMappedLink())
			to_chat(user, "<span class='warning'>There is no linked pad!</span>")
			return

	if(world.time < last_teleport + teleport_cooldown)
		to_chat(user, "<span class='warning'>[src] is recharging power. Please wait [round((last_teleport + teleport_cooldown - world.time)/10)] seconds.</span>")
		return

	if(teleporting)
		to_chat(user, "<span class='warning'>[src] is charging up. Please wait.</span>")
		return

	if(linked_pad.teleporting)
		to_chat(user, "<span class='warning'>Linked pad is busy. Please wait.</span>")
		return

	if(linked_pad.inoperable())
		to_chat(user, "<span class='warning'>Linked pad is not responding to ping.</span>")
		return
	src.add_fingerprint(user)
	doteleport(user)

/obj/machinery/power/quantumpad/proc/sparks()
	var/datum/effect/spark_spread/sparks = new /datum/effect/spark_spread()
	sparks.set_up(5, 1, get_turf(src))
	sparks.start()

/obj/machinery/power/quantumpad/proc/doteleport(mob/user)
	if(!linked_pad)
		return
	playsound(get_turf(src), 'sound/weapons/flash.ogg', 25, 1)
	teleporting = 1

	spawn(teleport_speed)
		if(!src || QDELETED(src))
			teleporting = 0
			return
		if(inoperable())
			to_chat(user, "<span class='warning'>[src] is nonfunctional!</span>")
			teleporting = 0
			return
		if(!linked_pad || QDELETED(linked_pad) || linked_pad.inoperable())
			to_chat(user, "<span class='warning'>Linked pad is not responding to ping. Teleport aborted.</span>")
			teleporting = 0
			return

		teleporting = 0
		last_teleport = world.time

		// use a lot of power
		var/power_to_use = 10000 / power_efficiency
		if(draw_power(power_to_use) != power_to_use)
			to_chat(user, "<span class='warning'>Power is not sufficient to complete a teleport. Teleport aborted.</span>")
			return
		sparks()
		linked_pad.sparks()

		flick("qpad-beam", src)
		playsound(get_turf(src), 'sound/weapons/emitter2.ogg', 25, 1, extrarange = 3, falloff = 5)
		flick("qpad-beam", linked_pad)
		playsound(get_turf(linked_pad), 'sound/weapons/emitter2.ogg', 25, 1, extrarange = 3, falloff = 5)
		for(var/atom/movable/ROI in get_turf(src))
			// if is anchored, don't let through
			if(ROI.anchored)
				if(isliving(ROI))
					var/mob/living/L = ROI
					if(L.buckled)
						// TP people on office chairs
						if(L.buckled.anchored)
							continue
					else
						continue
				else if(!isobserver(ROI))
					continue
			do_teleport(ROI, get_turf(linked_pad))

/obj/machinery/power/quantumpad/proc/initMappedLink()
	. = FALSE
	var/obj/machinery/power/quantumpad/link = mapped_quantum_pads[map_pad_link_id]
	if(link)
		linked_pad = link
		. = TRUE
