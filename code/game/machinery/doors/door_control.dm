/obj/machinery/button/remote
	name = "remote object control"
	desc = "It controls objects, remotely."
	icon = 'icons/obj/structures/buttons.dmi'
	icon_state = "doorctrl"
	power_channel = ENVIRON
	var/desiredstate = 0
	var/exposedwires = 0
	/*
	Bitflag,	1=checkID
				2=Network Access
	*/

	anchored = TRUE
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/button/remote/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	if(wires & 2)
		return src.attack_hand(user)
	else
		to_chat(user, "Error, no route to host.")


/obj/machinery/button/remote/emag_act(remaining_charges, var/mob/user)
	if(length(req_access))
		req_access.Cut()
		playsound(src.loc, "sparks", 100, 1)
		return 1

/obj/machinery/button/remote/attack_hand(mob/user as mob)
	if(..())
		return

	if(stat & (MACHINE_STAT_NOPOWER|MACHINE_STAT_EMPED))
		return

	if(!allowed(user) && (wires & 1))
		to_chat(user, "<span class='warning'>Access Denied</span>")
		flick("[initial(icon_state)]-denied",src)
		return

	use_power_oneoff(5)
	icon_state = "[initial(icon_state)]1"
	desiredstate = !desiredstate
	trigger(user)
	spawn(15)
		update_icon()

/obj/machinery/button/remote/proc/trigger()
	return

/obj/machinery/button/remote/on_update_icon()
	if(stat & MACHINE_STAT_NOPOWER)
		icon_state = "[initial(icon_state)]-p"
	else
		icon_state = "[initial(icon_state)]"

/*
	Airlock remote control
*/

// Bitmasks for door switches.
#define OPEN   0x1
#define IDSCAN 0x2
#define BOLTS  0x4
#define SHOCK  0x8
#define SAFE   0x10

/obj/machinery/button/remote/airlock
	name = "remote door-control"
	desc = "It controls doors, remotely."

	var/specialfunctions = 1
	/*
	Bitflag, 	1= open
				2= idscan,
				4= bolts
				8= shock
				16= door safties
	*/

/obj/machinery/button/remote/airlock/trigger()
	for(var/obj/machinery/door/airlock/D in world)
		if(D.id_tag == src.id_tag)
			if(specialfunctions & OPEN)
				if (D.density)
					spawn(0)
						D.open()
						return
				else
					spawn(0)
						D.close()
						return
			if(desiredstate == 1)
				if(specialfunctions & IDSCAN)
					D.set_idscan(0)
				if(specialfunctions & BOLTS)
					D.lock()
				if(specialfunctions & SHOCK)
					D.electrify(-1)
				if(specialfunctions & SAFE)
					D.set_safeties(0)
			else
				if(specialfunctions & IDSCAN)
					D.set_idscan(1)
				if(specialfunctions & BOLTS)
					D.unlock()
				if(specialfunctions & SHOCK)
					D.electrify(0)
				if(specialfunctions & SAFE)
					D.set_safeties(1)

#undef OPEN
#undef IDSCAN
#undef BOLTS
#undef SHOCK
#undef SAFE

/*
	Blast door remote control
*/
/obj/machinery/button/remote/blast_door
	name = "remote blast door-control"
	desc = "It controls blast doors, remotely."
	icon_state = "blastctrl"

/obj/machinery/button/remote/blast_door/trigger()
	for(var/obj/machinery/door/blast/M in world)
		if(M.id_tag == src.id_tag)
			if(M.density)
				spawn(0)
					M.open()
					return
			else
				spawn(0)
					M.close()
					return

/*
	Emitter remote control
*/
/obj/machinery/button/remote/emitter
	name = "remote emitter control"
	desc = "It controls emitters, remotely."

/obj/machinery/button/remote/emitter/trigger(mob/user as mob)
	for(var/obj/machinery/power/emitter/E in world)
		if(E.id_tag == src.id_tag)
			spawn(0)
				E.activate(user)
				return

/*
	Mass driver remote control
*/
/obj/machinery/button/remote/driver
	name = "mass driver button"
	desc = "A remote control switch for a mass driver."
	icon = 'icons/obj/structures/buttons.dmi'
	icon_state = "launcherbtt"

/obj/machinery/button/remote/driver/trigger(mob/user as mob)
	set waitfor = 0
	active = 1
	update_icon()

	for(var/obj/machinery/door/blast/M in SSmachines.machinery)
		if (M.id_tag == src.id_tag)
			spawn( 0 )
				M.open()
				return

	sleep(20)

	for(var/obj/machinery/mass_driver/M in SSmachines.machinery)
		if(M.id_tag == src.id_tag)
			M.drive()

	sleep(50)

	for(var/obj/machinery/door/blast/M in SSmachines.machinery)
		if (M.id_tag == src.id_tag)
			spawn(0)
				M.close()
				return

	icon_state = "launcherbtt"
	update_icon()

	return

/obj/machinery/button/remote/driver/on_update_icon()
	if(!active || (stat & MACHINE_STAT_NOPOWER))
		icon_state = "launcherbtt"
	else
		icon_state = "launcheract"

/*
	Generic radio control for just about anything
*/

/obj/machinery/button/remote/generic
	var/list/radio_data
	var/filter
	var/freq
	var/datum/radio_frequency/radio_connection

/obj/machinery/button/remote/generic/Initialize()
	. = ..()
	if(freq && filter)
		radio_connection = radio_controller.add_object(src, freq, filter)

/obj/machinery/button/remote/generic/trigger()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = 1
	signal.source = src

	for(var/new_data in radio_data)
		signal.data[new_data] = radio_data[new_data]

	radio_connection.post_signal(src, signal, filter)

/obj/machinery/button/remote/generic/regulator
	radio_data = list("sigtype" = "command", "tag" = "changeme", "power_toggle")
	filter = RADIO_ATMOSIA

/*
	Chromatic lighting
*/

/obj/machinery/button/remote/chromatic
	name = "chromatic light control"
	var/freq = 1343
	var/datum/radio_frequency/radio_connection

/obj/machinery/button/remote/chromatic/Initialize()
	. = ..()
	radio_connection = radio_controller.add_object(src, freq, RADIO_CHROMATIC)

/obj/machinery/button/remote/chromatic/trigger(mob/user)
	if(!radio_connection)
		return 0

	var/color = input(user, "Choose a new light color:", "Chromatic Light", rgb(255,255,255)) as color|null

	if(!color)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = 1
	signal.source = src

	signal.data["color"] = color
	signal.data["tag"] = id_tag

	radio_connection.post_signal(src, signal, RADIO_CHROMATIC)
