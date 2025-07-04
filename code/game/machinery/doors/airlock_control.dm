#define AIRLOCK_CONTROL_RANGE 22

// This code allows for airlocks to be controlled externally by setting an id_tag and comm frequency (disables ID access)
/obj/machinery/door/airlock
	var/frequency
	var/shockedby = list()
	var/datum/radio_frequency/radio_connection
	var/cur_command = null	//the command the door is currently attempting to complete

/obj/machinery/door/airlock/Process()
	if (arePowerSystemsOn())
		execute_current_command()
	return ..()

/obj/machinery/door/airlock/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	if(id_tag != signal.data["tag"] || !signal.data["command"]) return

	command(signal.data["command"])

/obj/machinery/door/airlock/proc/command(new_command)
	cur_command = new_command

	//if there's no power, recieve the signal but just don't do anything. This allows airlocks to continue to work normally once power is restored
	if(arePowerSystemsOn())
		spawn()
			execute_current_command()

/obj/machinery/door/airlock/proc/execute_current_command()
	if(operating)
		return //emagged or busy doing something else

	if (!cur_command)
		return

	do_command(cur_command)
	if (command_completed(cur_command))
		cur_command = null

/obj/machinery/door/airlock/proc/do_command(command)
	switch(command)
		if("open")
			open()

		if("close")
			close()

		if("unlock")
			unlock()

		if("lock")
			lock()

		if("secure_open")
			unlock()

			sleep(2)
			open()

			lock()

		if("secure_close")
			unlock()
			close()

			lock()
			sleep(2)

	send_status()

/obj/machinery/door/airlock/proc/command_completed(command)
	switch(command)
		if("open")
			return (!density)

		if("close")
			return density

		if("unlock")
			return !locked

		if("lock")
			return locked

		if("secure_open")
			return (locked && !density)

		if("secure_close")
			return (locked && density)

	return 1	//Unknown command. Just assume it's completed.

/obj/machinery/door/airlock/proc/send_status(bumped = 0)
	if(radio_connection)
		var/datum/signal/signal = new
		signal.transmission_method = 1 //radio signal
		signal.data["tag"] = id_tag
		signal.data["timestamp"] = world.time

		signal.data["door_status"] = density?("closed"):("open")
		signal.data["lock_status"] = locked?("locked"):("unlocked")

		if (bumped)
			signal.data["bumped_with_access"] = 1

		radio_connection.post_signal(src, signal, RADIO_AIRLOCK, AIRLOCK_CONTROL_RANGE)


/obj/machinery/door/airlock/open(surpress_send)
	. = ..()
	if(!surpress_send) send_status()


/obj/machinery/door/airlock/close(surpress_send)
	. = ..()
	if(!surpress_send) send_status()

/obj/machinery/door/airlock/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	if(new_frequency)
		frequency = new_frequency
		radio_connection = radio_controller.add_object(src, frequency, RADIO_AIRLOCK)


/obj/machinery/door/airlock/Initialize()
	. = ..()
	if(frequency)
		set_frequency(frequency)

	update_icon()

/obj/machinery/door/airlock/New()
	..()

	if(radio_controller)
		set_frequency(frequency)

/obj/machinery/door/airlock/Destroy()
	if(frequency && radio_controller)
		radio_controller.remove_object(src,frequency)
	return ..()

/obj/machinery/airlock_sensor
	icon = 'icons/obj/doors/airlock_machines.dmi'
	icon_state = "airlock_sensor_off"
	name = "airlock sensor"
	layer = ABOVE_WINDOW_LAYER

	anchored = TRUE
	power_channel = ENVIRON

	var/master_tag
	var/frequency = 1379
	var/command = "cycle"

	var/datum/radio_frequency/radio_connection

	var/on = 1
	var/alert = 0
	var/previousPressure

/obj/machinery/airlock_sensor/on_update_icon()
	if(on)
		if(alert)
			icon_state = "airlock_sensor_alert"
		else
			icon_state = "airlock_sensor_standby"
	else
		icon_state = "airlock_sensor_off"

/obj/machinery/airlock_sensor/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.data["tag"] = master_tag
	signal.data["command"] = command

	radio_connection.post_signal(src, signal, RADIO_AIRLOCK, AIRLOCK_CONTROL_RANGE)
	flick("airlock_sensor_cycle", src)
	return TRUE

/obj/machinery/airlock_sensor/Process()
	if(on)
		var/datum/gas_mixture/air_sample = return_air()
		var/pressure = round(air_sample.return_pressure(),0.1)

		if(abs(pressure - previousPressure) > 0.001 || isnull(previousPressure))
			var/datum/signal/signal = new
			signal.transmission_method = 1 //radio signal
			signal.data["tag"] = id_tag
			signal.data["timestamp"] = world.time
			signal.data["pressure"] = num2text(pressure)

			radio_connection.post_signal(src, signal, RADIO_AIRLOCK, AIRLOCK_CONTROL_RANGE)

			previousPressure = pressure

			alert = (pressure < ONE_ATMOSPHERE*0.8)

			update_icon()

/obj/machinery/airlock_sensor/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_AIRLOCK)

/obj/machinery/airlock_sensor/Initialize()
	set_frequency(frequency)
	. = ..()

/obj/machinery/airlock_sensor/New()
	..()
	if(radio_controller)
		set_frequency(frequency)

/obj/machinery/airlock_sensor/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src,frequency)
	return ..()

/obj/machinery/airlock_sensor/airlock_interior
	command = "cycle_interior"

/obj/machinery/airlock_sensor/airlock_exterior
	command = "cycle_exterior"

/obj/machinery/access_button
	icon = 'icons/obj/doors/airlock_machines.dmi'
	icon_state = "access_button_standby"
	name = "access button"
	layer = ABOVE_WINDOW_LAYER

	anchored = TRUE
	power_channel = ENVIRON

	var/master_tag
	var/frequency = 1449
	var/command = "cycle"

	var/datum/radio_frequency/radio_connection

	var/on = 1
	interact_offline = TRUE


/obj/machinery/access_button/on_update_icon()
	if(on)
		icon_state = "access_button_standby"
	else
		icon_state = "access_button_off"

/obj/machinery/access_button/use_tool(obj/item/I, mob/living/user, list/click_params)
	if (istype(I, /obj/item/card/id) || istype(I, /obj/item/modular_computer))
		attack_hand(user)
		return TRUE
	return ..()

/obj/machinery/access_button/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	if(radio_connection)
		var/datum/signal/signal = new
		signal.transmission_method = 1 //radio signal
		signal.data["tag"] = master_tag
		signal.data["command"] = command

		radio_connection.post_signal(src, signal, RADIO_AIRLOCK, AIRLOCK_CONTROL_RANGE)
	flick("access_button_cycle", src)
	return TRUE

/obj/machinery/access_button/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_AIRLOCK)


/obj/machinery/access_button/Initialize()
	. = ..()
	set_frequency(frequency)


/obj/machinery/access_button/New()
	..()

	if(radio_controller)
		set_frequency(frequency)

/obj/machinery/access_button/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src, frequency)
	return ..()

/obj/machinery/access_button/airlock_interior
	frequency = 1379
	command = "cycle_interior"

/obj/machinery/access_button/airlock_exterior
	frequency = 1379
	command = "cycle_exterior"
