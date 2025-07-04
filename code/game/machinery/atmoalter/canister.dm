/obj/machinery/portable_atmospherics/canister
	name = "\improper Canister: \[CAUTION\]"
	icon = 'icons/obj/atmospherics/atmos.dmi'
	icon_state = "yellow"
	density = TRUE
	health_max = 100
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_GARGANTUAN
	construct_state = null
	health_resistances = DAMAGE_RESIST_PHYSICAL

	var/valve_open = 0
	var/release_pressure = ONE_ATMOSPHERE
	var/release_flow_rate = ATMOS_DEFAULT_VOLUME_PUMP //in L/s

	var/canister_color = "yellow"
	var/can_label = 1
	start_pressure = 45 * ONE_ATMOSPHERE
	var/temperature_resistance = 1000 + T0C
	volume = 1000
	interact_offline = 1 // Allows this to be used when not in powered area.

	var/const/CANISTER_PRESSURE_EMPTY = ONE_ATMOSPHERE
	var/const/CANISTER_PRESSURE_LOW = 5 * ONE_ATMOSPHERE
	var/const/CANISTER_PRESSURE_MID = 15 * ONE_ATMOSPHERE
	var/const/CANISTER_PRESSURE_HIGH = 30 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/canister/drain_power()
	return -1

/obj/machinery/portable_atmospherics/canister/sleeping_agent
	name = "\improper Canister: \[N2O\]"
	icon_state = "redws"
	canister_color = "redws"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/nitrogen
	name = "\improper Canister: \[N2\]"
	icon_state = "red"
	canister_color = "red"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/nitrogen/prechilled
	name = "\improper Canister: \[N2 (Cooling)\]"

/obj/machinery/portable_atmospherics/canister/oxygen
	name = "\improper Canister: \[O2\]"
	icon_state = "blue"
	canister_color = "blue"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/oxygen/prechilled
	name = "\improper Canister: \[O2 (Cryo)\]"
	start_pressure = 20 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/canister/hydrogen
	name = "\improper Canister: \[Hydrogen\]"
	icon_state = "purple"
	canister_color = "purple"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/boron
	name = "\improper Canister: \[Boron\]"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/phoron
	name = "\improper Canister \[Phoron\]"
	icon_state = "orange"
	canister_color = "orange"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/carbon_dioxide
	name = "\improper Canister \[CO2\]"
	icon_state = "black"
	canister_color = "black"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/air
	name = "\improper Canister \[Air\]"
	icon_state = "grey"
	canister_color = "grey"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/boron
	name = "\improper Canister \[Boron\]"
	icon_state = "lightblue"
	canister_color = "lightblue"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/air/airlock
	start_pressure = 3 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/canister/empty
	start_pressure = 0
	can_label = 1
	var/obj/machinery/portable_atmospherics/canister/canister_type = /obj/machinery/portable_atmospherics/canister

/obj/machinery/portable_atmospherics/canister/empty/New()
	..()
	name = 	initial(canister_type.name)
	icon_state = 	initial(canister_type.icon_state)
	canister_color = 	initial(canister_type.canister_color)

/obj/machinery/portable_atmospherics/canister/empty/air
	icon_state = "grey"
	canister_type = /obj/machinery/portable_atmospherics/canister/air
/obj/machinery/portable_atmospherics/canister/empty/oxygen
	icon_state = "blue"
	canister_type = /obj/machinery/portable_atmospherics/canister/oxygen
/obj/machinery/portable_atmospherics/canister/empty/phoron
	icon_state = "orange"
	canister_type = /obj/machinery/portable_atmospherics/canister/phoron
/obj/machinery/portable_atmospherics/canister/empty/nitrogen
	icon_state = "red"
	canister_type = /obj/machinery/portable_atmospherics/canister/nitrogen
/obj/machinery/portable_atmospherics/canister/empty/carbon_dioxide
	icon_state = "black"
	canister_type = /obj/machinery/portable_atmospherics/canister/carbon_dioxide
/obj/machinery/portable_atmospherics/canister/empty/sleeping_agent
	icon_state = "redws"
	canister_type = /obj/machinery/portable_atmospherics/canister/sleeping_agent
/obj/machinery/portable_atmospherics/canister/empty/hydrogen
	icon_state = "purple"
	canister_type = /obj/machinery/portable_atmospherics/canister/hydrogen


/obj/machinery/portable_atmospherics/canister/on_update_icon()
	if (destroyed)
		ClearOverlays()
		icon_state = "[canister_color]-1"
		return

	if (icon_state != "[canister_color]")
		icon_state = "[canister_color]"

	ClearOverlays()

	if (holding)
		AddOverlays("can-open")
	if (connected_port)
		AddOverlays("can-connector")

	var/tank_pressure = return_pressure()
	if (tank_pressure <= CANISTER_PRESSURE_EMPTY)
		AddOverlays("can-o0")
	else if (tank_pressure <= CANISTER_PRESSURE_LOW)
		AddOverlays("can-o1")
	else if (tank_pressure <= CANISTER_PRESSURE_MID)
		AddOverlays("can-o2")
	else
		AddOverlays("can-o3")

/obj/machinery/portable_atmospherics/canister/get_material_melting_point()
	return temperature_resistance

/obj/machinery/portable_atmospherics/canister/on_death()
	var/atom/location = loc
	location.assume_air(air_contents)
	destroyed = TRUE
	playsound(src, 'sound/effects/spray.ogg', 10, TRUE, -3)
	set_density(FALSE)
	if (holding)
		holding.dropInto(loc)
		holding = null
	..()

/obj/machinery/portable_atmospherics/canister/Process()
	if (destroyed)
		return

	..()

	if(valve_open)
		var/datum/gas_mixture/environment
		if(holding)
			environment = holding.air_contents
		else
			environment = loc.return_air()

		var/env_pressure = environment.return_pressure()
		var/pressure_delta = release_pressure - env_pressure

		if((air_contents.temperature > 0) && (pressure_delta > 0))
			var/transfer_moles = calculate_transfer_moles(air_contents, environment, pressure_delta)
			transfer_moles = min(transfer_moles, (release_flow_rate/air_contents.volume)*air_contents.total_moles) //flow rate limit

			var/returnval = pump_gas_passive(src, air_contents, environment, transfer_moles)
			if(returnval >= 0)
				src.update_icon()
				if(holding)
					holding.queue_icon_update()

	if(air_contents.return_pressure() < 1)
		can_label = 1
	else
		can_label = 0

	air_contents.react() //cooking up air cans - add phoron and oxygen, then heat above PHORON_MINIMUM_BURN_TEMPERATURE

/obj/machinery/portable_atmospherics/canister/proc/return_temperature()
	var/datum/gas_mixture/GM = src.return_air()
	if(GM && GM.volume>0)
		return GM.temperature
	return 0

/obj/machinery/portable_atmospherics/canister/proc/return_pressure()
	var/datum/gas_mixture/GM = src.return_air()
	if(GM && GM.volume>0)
		return GM.return_pressure()
	return 0

/obj/machinery/portable_atmospherics/canister/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(user, /mob/living/silicon/robot) && istype(W, /obj/item/tank/jetpack))
		var/datum/gas_mixture/thejetpack = W:air_contents
		var/env_pressure = thejetpack.return_pressure()
		var/pressure_delta = min(10*ONE_ATMOSPHERE - env_pressure, (air_contents.return_pressure() - env_pressure)/2)
		//Can not have a pressure delta that would cause environment pressure > tank pressure
		var/transfer_moles = 0
		if((air_contents.temperature > 0) && (pressure_delta > 0))
			transfer_moles = pressure_delta*thejetpack.volume/(air_contents.temperature * R_IDEAL_GAS_EQUATION)//Actually transfer the gas
			var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)
			thejetpack.merge(removed)
			to_chat(user, "You pulse-pressurize your jetpack from the tank.")
		return TRUE

	. = ..()

	SSnano.update_uis(src) // Update all NanoUIs attached to src

/obj/machinery/portable_atmospherics/canister/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/portable_atmospherics/canister/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	// this is the data which will be sent to the ui
	var/data[0]
	data["name"] = name
	data["canLabel"] = can_label ? 1 : 0
	data["portConnected"] = connected_port ? 1 : 0
	data["tankPressure"] = round(air_contents.return_pressure() ? air_contents.return_pressure() : 0)
	data["releasePressure"] = round(release_pressure ? release_pressure : 0)
	data["minReleasePressure"] = round(ONE_ATMOSPHERE/10)
	data["maxReleasePressure"] = round(10*ONE_ATMOSPHERE)
	data["valveOpen"] = valve_open ? 1 : 0

	data["hasHoldingTank"] = holding ? 1 : 0
	if (holding)
		data["holdingTank"] = list("name" = holding.name, "tankPressure" = round(holding.air_contents.return_pressure()))

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "canister.tmpl", "Canister", 480, 400)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/portable_atmospherics/canister/OnTopic(mob/user, href_list, state)
	if(href_list["toggle"])
		if (!valve_open)
			if(!holding)
				log_open(user)
		valve_open = !valve_open
		. = TOPIC_REFRESH

	else if (href_list["remove_tank"])
		if(!holding)
			return TOPIC_HANDLED
		if (valve_open)
			valve_open = 0
		if(istype(holding, /obj/item/tank))
			holding.manipulated_by = user.real_name
		holding.dropInto(loc)
		holding = null
		update_icon()
		. = TOPIC_REFRESH

	else if (href_list["pressure_adj"])
		var/diff = text2num(href_list["pressure_adj"])
		if(diff > 0)
			release_pressure = min(10*ONE_ATMOSPHERE, release_pressure+diff)
		else
			release_pressure = max(ONE_ATMOSPHERE/10, release_pressure+diff)
		. = TOPIC_REFRESH

	else if (href_list["relabel"])
		if (!can_label)
			return 0
		var/list/colors = list(\
			"\[N2O\]" = "redws", \
			"\[N2\]" = "red", \
			"\[O2\]" = "blue", \
			"\[Phoron\]" = "orange", \
			"\[CO2\]" = "black", \
			"\[H2\]" = "purple", \
			"\[Air\]" = "grey", \
			"\[CAUTION\]" = "yellow", \
		)
		var/label = input(user, "Choose canister label", "Gas canister") as null|anything in colors
		if (label && CanUseTopic(user, state))
			canister_color = colors[label]
			icon_state = colors[label]
			SetName("\improper Canister: [label]")
		update_icon()
		. = TOPIC_REFRESH

/obj/machinery/portable_atmospherics/canister/CanUseTopic()
	if(destroyed)
		return STATUS_CLOSE
	return ..()

/obj/machinery/portable_atmospherics/canister/phoron/New()
	..()

	src.air_contents.adjust_gas(GAS_PHORON, MolesForPressure())
	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/oxygen/New()
	..()

	src.air_contents.adjust_gas(GAS_OXYGEN, MolesForPressure())
	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/hydrogen/New()
	..()
	src.air_contents.adjust_gas(GAS_HYDROGEN, MolesForPressure())
	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/oxygen/prechilled/New()
	..()
	src.air_contents.temperature = 80
	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/sleeping_agent/New()
	..()

	air_contents.adjust_gas(GAS_N2O, MolesForPressure())
	src.update_icon()
	return 1

//Dirty way to fill room with gas. However it is a bit easier to do than creating some floor/engine/n2o -rastaf0
/obj/machinery/portable_atmospherics/canister/sleeping_agent/roomfiller/New()
	..()
	air_contents.gas[GAS_N2O] = 9*4000
	spawn(10)
		var/turf/simulated/location = src.loc
		if (istype(src.loc))
			while (!location.air)
				sleep(10)
			location.assume_air(air_contents)
			air_contents = new
	return 1

/obj/machinery/portable_atmospherics/canister/nitrogen/New()
	..()
	src.air_contents.adjust_gas(GAS_NITROGEN, MolesForPressure())
	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/nitrogen/prechilled/New()
	..()
	src.air_contents.temperature = 80
	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/carbon_dioxide/New()
	..()
	src.air_contents.adjust_gas(GAS_CO2, MolesForPressure())
	src.update_icon()
	return 1


/obj/machinery/portable_atmospherics/canister/air/New()
	..()
	var/list/air_mix = StandardAirMix()
	src.air_contents.adjust_multi(GAS_OXYGEN, air_mix[GAS_OXYGEN], GAS_NITROGEN, air_mix[GAS_NITROGEN])

	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/boron/New()
	..()
	src.air_contents.adjust_gas(GAS_BORON, MolesForPressure())
	src.update_icon()
	return 1

// Special types used for engine setup admin verb, they contain double amount of that of normal canister.
/obj/machinery/portable_atmospherics/canister/nitrogen/engine_setup/New()
	..()
	src.air_contents.adjust_gas(GAS_NITROGEN, MolesForPressure())
	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/carbon_dioxide/engine_setup/New()
	..()
	src.air_contents.adjust_gas(GAS_CO2, MolesForPressure())
	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/phoron/engine_setup/New()
	..()
	src.air_contents.adjust_gas(GAS_PHORON, MolesForPressure())
	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/hydrogen/engine_setup/New()
	..()
	src.air_contents.adjust_gas(GAS_HYDROGEN, MolesForPressure())
	src.update_icon()

// Spawn debug tanks.
/obj/machinery/portable_atmospherics/canister/helium
	name = "\improper Canister \[He\]"
	icon_state = "black"
	canister_color = "black"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/helium/New()
	..()
	air_contents.adjust_gas(GAS_HELIUM, MolesForPressure())
	update_icon()

/obj/machinery/portable_atmospherics/canister/methyl_bromide
	name = "\improper Canister \[CH3Br\]"
	icon_state = "black"
	canister_color = "black"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/methyl_bromide/New()
	..()
	air_contents.adjust_gas(GAS_METHYL_BROMIDE, MolesForPressure())
	update_icon()

/obj/machinery/portable_atmospherics/canister/chlorine
	name = "\improper Canister \[Cl\]"
	icon_state = "lightyellow"
	canister_color = "lightyellow"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/chlorine/New()
	..()
	air_contents.adjust_gas(GAS_CHLORINE, MolesForPressure())
	update_icon()
// End debug tanks.
