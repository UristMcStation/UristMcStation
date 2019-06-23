//Gas nozzle engine
/datum/ship_engine/plasma_thruster
	name = "plasma thruster"
	var/obj/machinery/atmospherics/unary/engine/plasma/nozzle

//Actual thermal nozzle engine object

/obj/machinery/atmospherics/unary/engine/plasma
	name = "plasma nozzle"
	desc = "Somewhat complicated electrically boosted thruster nozzle. Uses power and gas to produce thrust."
	icon = 'icons/obj/ship_engine.dmi'
	icon_state = "nozzle"
	use_power = 1
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 80000			//7500 W ~ 10 HP
	opacity = 1
	density = 1
	moles_per_burn = 1.5

/obj/machinery/atmospherics/unary/engine/plasma/Initialize()
	. = ..()
	controller = new(src)

/obj/machinery/atmospherics/unary/engine/plasma/Destroy()
	QDEL_NULL(controller)
	. = ..()

/obj/machinery/atmospherics/unary/engine/plasma/get_status()
	. = list()
	.+= "Location: [get_area(src)]."
	if(!powered())
		.+= "Insufficient power to operate."
	if(!check_fuel())
		.+= "Insufficient fuel for a burn."

	.+= "Propellant total mass: [round(air_contents.get_mass(),0.01)] kg."
	.+= "Propellant used per burn: [round(air_contents.specific_mass() * moles_per_burn * thrust_limit,0.01)] kg."
	.+= "Propellant pressure: [round(air_contents.return_pressure()/1000,0.1)] MPa."
	. = jointext(.,"<br>")

/obj/machinery/atmospherics/unary/engine/plasma/is_on()
	return on && powered()

/obj/machinery/atmospherics/unary/engine/plasma/check_fuel()
	return air_contents.total_moles > moles_per_burn * thrust_limit

/obj/machinery/atmospherics/unary/engine/plasma/get_thrust()
	if(!is_on() || !check_fuel())
		return 0
	var/used_part = moles_per_burn/air_contents.get_total_moles() * thrust_limit
	. = calculate_thrust(air_contents, power_rating, used_part)
	return

/obj/machinery/atmospherics/unary/engine/plasma/burn()
	if (!is_on())
		return 0
	if(!check_fuel())
		audible_message(src,"<span class='warning'>[src] coughs once and goes silent!</span>")
		on = !on
		return 0
	use_power(power_rating,power_channel, 1)
	var/exhaust_dir = reverse_direction(dir)
	var/datum/gas_mixture/removed = air_contents.remove(moles_per_burn * thrust_limit)
	. = calculate_thrust(removed, power_rating)
	playsound(loc, 'sound/machines/thruster.ogg', 100 * thrust_limit, 0, world.view * 4, 0.1)
	var/turf/T = get_step(src,exhaust_dir)
	if(T)
		T.assume_air(removed)
		new/obj/effect/engine_exhaust(T, exhaust_dir, air_contents.check_combustability() && air_contents.temperature >= PHORON_MINIMUM_BURN_TEMPERATURE)

/obj/machinery/atmospherics/unary/engine/plasma/calculate_thrust(datum/gas_mixture/propellant, var/power, used_part = 1)
	return (round(sqrt(propellant.get_mass() * used_part * air_contents.return_pressure()/100),0.1) * (power / 3500)) * thrust_limit