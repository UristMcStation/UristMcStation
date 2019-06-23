//These just use power.
/datum/ship_engine/reactionless_drive
	name = "ion drive"
	var/obj/machinery/power/reactionless_drive/nozzle

/datum/ship_engine/reactionless_drive/New(var/obj/machinery/_holder)
	..()
	nozzle = _holder

/datum/ship_engine/reactionless_drive/Destroy()
	nozzle = null
	. = ..()

/datum/ship_engine/reactionless_drive/get_status()
	return nozzle.get_status()

/datum/ship_engine/reactionless_drive/get_thrust()
	return nozzle.get_thrust()

/datum/ship_engine/reactionless_drive/burn()
	return nozzle.burn()

/datum/ship_engine/reactionless_drive/set_thrust_limit(var/new_limit)
	nozzle.thrust_limit = new_limit

/datum/ship_engine/reactionless_drive/get_thrust_limit()
	return nozzle.thrust_limit

/datum/ship_engine/reactionless_drive/is_on()
	return nozzle.is_on()

/datum/ship_engine/reactionless_drive/toggle()
	nozzle.on = !nozzle.on

/datum/ship_engine/reactionless_drive/can_burn()
	return nozzle.is_on()

//Actual ion engine object.

/obj/machinery/power/reactionless_drive
	name = "reactionless drive"
	desc = "An incredibly complicated movement device that uses purely electricity to move a vessel through space."
	icon = 'icons/obj/ship_engine.dmi'
	icon_state = "nozzle"
	use_power = 0
	idle_power_usage = 15 KILOWATTS		//internal circuitry, friction losses and stuff
	active_power_usage = 100 KILOWATTS
	opacity = 1
	density = 1
	var/on = 1
	var/datum/ship_engine/reactionless_drive/controller
	var/thrust_limit = 1	//Value between 1 and 0 to limit the resulting thrust
	var/efficency = 0.3

//DESTROY-INITIALIZATION

/obj/machinery/power/reactionless_drive/Initialize()
	. = ..()
	controller = new(src)
	connect_to_network()

/obj/machinery/power/reactionless_drive/Destroy()
	QDEL_NULL(controller)
	. = ..()

//STATUS PROCS

/obj/machinery/power/reactionless_drive/proc/get_status()
	. = list()
	.+= "Location: [get_area(src)]."
	if(!powernet)
		.+= "Disconnected from power network."
	if(avail() < active_power_usage)
		.+= "Insufficient power to operate."
	. = jointext(.,"<br>")

/obj/machinery/power/reactionless_drive/proc/is_on()
	if(avail() < active_power_usage)
		on = 0
	else
		on = 1
	return on

/obj/machinery/power/reactionless_drive/proc/get_thrust()
	if(!is_on() || !powered())
		return 0
	. = calculate_thrust(active_power_usage, thrust_limit)

/obj/machinery/power/reactionless_drive/proc/calculate_thrust(var/power, thrust_limit)
	return ((power * efficency) / 2500) * thrust_limit

//BURN PROC

/obj/machinery/power/reactionless_drive/proc/burn()
	if (!is_on())
		return 0
	var/actual_load = draw_power(active_power_usage)
	. = calculate_thrust(actual_load, thrust_limit)
	playsound(loc, 'sound/machines/thruster.ogg', 100 * thrust_limit, 0, world.view * 4, 0.1)