/obj/machinery/power/generator
	name = "thermoelectric generator"
	desc = "It's a high efficiency thermoelectric generator."
	icon = 'icons/obj/machines/power/teg.dmi'
	icon_state = "teg-unassembled"
	density = TRUE
	anchored = FALSE
	obj_flags = OBJ_FLAG_ANCHORABLE

	use_power = POWER_USE_IDLE
	idle_power_usage = 100 //Watts, I hope.  Just enough to do the computer and display things.
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	construct_state = /singleton/machine_construction/default/panel_closed
	maximum_component_parts = list(/obj/item/stock_parts = 16)

	var/max_power = 1500000
	var/thermal_efficiency = 0.65

	var/obj/machinery/atmospherics/binary/circulator/circ1
	var/obj/machinery/atmospherics/binary/circulator/circ2

	var/last_circ1_gen = 0
	var/last_circ2_gen = 0
	var/last_thermal_gen = 0
	var/stored_energy = 0
	var/lastgen1 = 0
	var/lastgen2 = 0
	var/effective_gen = 0
	var/lastgenlev = 0
	var/lubricated = 0

	var/datum/effect_system/sparks/spark_system

	var/list/soundverb = list("shudders violently", "rumbles brutally", "vibrates disturbingly", "shakes with a deep rumble", "bangs and thumps")
	var/list/soundlist = list('sound/ambience/ambigen9.ogg','sound/effects/meteorimpact.ogg','sound/effects/caution.ogg')

/obj/machinery/power/generator/New()
	create_reagents(120)
	..()
	desc = initial(desc) + " Rated for [round(max_power/1000)] kW."
	spawn(1)
		reconnect()

/obj/machinery/power/generator/examine(mob/user)
	. = ..()
	to_chat(user, "Auxilary tank shows [reagents.total_volume]u of liquid in it.")
	if(!lubricated)
		to_chat(user, "It seems to be in need of oiling.")

//generators connect in dir and reverse_dir(dir) directions
//mnemonic to determine circulator/generator directions: the cirulators orbit clockwise around the generator
//so a circulator to the NORTH of the generator connects first to the EAST, then to the WEST
//and a circulator to the WEST of the generator connects first to the NORTH, then to the SOUTH
//note that the circulator's outlet dir is it's always facing dir, and it's inlet is always the reverse
/obj/machinery/power/generator/proc/reconnect()
	if(circ1)
		circ1.temperature_overlay = null
	if(circ2)
		circ2.temperature_overlay = null
	circ1 = null
	circ2 = null
	if(src.loc && anchored)
		if(src.dir & (EAST|WEST))
			circ1 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,WEST)
			circ2 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,EAST)

			if(circ1 && circ2)
				if(circ1.dir != NORTH || circ2.dir != SOUTH)
					circ1 = null
					circ2 = null

		else if(src.dir & (NORTH|SOUTH))
			circ1 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,NORTH)
			circ2 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,SOUTH)

			if(circ1 && circ2 && (circ1.dir != EAST || circ2.dir != WEST))
				circ1 = null
				circ2 = null
	update_icon()

/obj/machinery/power/generator/on_update_icon()
	icon_state = anchored ? "teg-assembled" : "teg-unassembled"
	ClearOverlays()
	if (circ1)
		circ1.temperature_overlay = null
	if (circ2)
		circ2.temperature_overlay = null
	if (inoperable())
		return 1
	else
		if (lastgenlev != 0)
			AddOverlays(emissive_appearance(icon, "teg-op[lastgenlev]"))
			AddOverlays(image(icon, "teg-op[lastgenlev]"))
			if (circ1 && circ2)
				var/extreme = (lastgenlev > 9) ? "ex" : ""
				if (circ1.last_temperature < circ2.last_temperature)
					circ1.temperature_overlay = "circ-[extreme]cold"
					circ2.temperature_overlay = "circ-[extreme]hot"
				else
					circ1.temperature_overlay = "circ-[extreme]cold"
					circ2.temperature_overlay = "circ-[extreme]hot"
		return 1

/obj/machinery/power/generator/Process()
	if(!circ1 || !circ2 || !anchored || inoperable())
		stored_energy = 0
		return

	updateDialog()
	var/datum/gas_mixture/air1 = circ1.return_transfer_air()
	var/datum/gas_mixture/air2 = circ2.return_transfer_air()

	lastgen2 = lastgen1
	lastgen1 = 0
	last_thermal_gen = 0
	last_circ1_gen = 0
	last_circ2_gen = 0

	if(air1 && air2)
		var/air1_heat_capacity = air1.heat_capacity()
		var/air2_heat_capacity = air2.heat_capacity()
		var/delta_temperature = abs(air2.temperature - air1.temperature)

		if(delta_temperature > 0 && air1_heat_capacity > 0 && air2_heat_capacity > 0)
			var/energy_transfer = delta_temperature*air2_heat_capacity*air1_heat_capacity/(air2_heat_capacity+air1_heat_capacity)
			var/heat = energy_transfer*(1-thermal_efficiency)
			last_thermal_gen = energy_transfer*thermal_efficiency

			if(air2.temperature > air1.temperature)
				air2.temperature = air2.temperature - energy_transfer/air2_heat_capacity
				air1.temperature = air1.temperature + heat/air1_heat_capacity
			else
				air2.temperature = air2.temperature + heat/air2_heat_capacity
				air1.temperature = air1.temperature - energy_transfer/air1_heat_capacity
		playsound(src.loc, 'sound/effects/beam.ogg', 25, 0, 10,  is_ambiance = 1)

	//Transfer the air
	if (air1)
		circ1.air2.merge(air1)
	if (air2)
		circ2.air2.merge(air2)

	//Update the gas networks
	if(circ1.network2)
		circ1.network2.update = 1
	if(circ2.network2)
		circ2.network2.update = 1

	//Exceeding maximum power leads to some power loss
	if(effective_gen > max_power && prob(5))
		var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
		s.set_up(3, 1, src)
		s.start()
		stored_energy *= 0.5
		if (powernet)
			powernet.apcs_overload(0, 2, 5)

	//Power
	last_circ1_gen = circ1.return_stored_energy()
	last_circ2_gen = circ2.return_stored_energy()
	stored_energy += last_thermal_gen + last_circ1_gen + last_circ2_gen
	lastgen1 = stored_energy*0.4 //smoothened power generation to prevent slingshotting as pressure is equalized, then restored by pumps
	stored_energy -= lastgen1
	effective_gen = (lastgen1 + lastgen2) / 2

	// update icon overlays and power usage only when necessary
	var/genlev = max(0, min( round(11*effective_gen / max_power), 11))
	if(effective_gen > 100 && genlev == 0)
		genlev = 1
	if(genlev != lastgenlev)
		lastgenlev = genlev
		update_icon()
	add_avail(effective_gen)
	lubricated = 0
	thermal_efficiency = 0.65
	if(reagents.has_reagent(/datum/reagent/oil))
		reagents.remove_reagent(/datum/reagent/oil, 0.01)
		thermal_efficiency = 0.80
		lubricated = 1
	else
		reagents.remove_any(1)

/obj/machinery/power/generator/post_anchor_change()
	reconnect()
	..()

/obj/machinery/power/generator/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(isWrench(W))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		anchored = !anchored
		user.visible_message("[user.name] [anchored ? "secures" : "unsecures"] the bolts holding [src.name] to the floor.", \
					"You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor.", \
					"You hear a ratchet")
		update_use_power(anchored)
		if(anchored) // Powernet connection stuff.
			connect_to_network()
		else
			disconnect_from_network()
		reconnect()
	if(istype(W, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/R = W
		R.standard_pour_into(user, src)
		to_chat(user, "<span class='notice'>You pour the fluid into [src].</span>")
	else
		..()

/obj/machinery/power/generator/CanUseTopic(mob/user)
	if(!anchored)
		return STATUS_CLOSE
	return ..()

/obj/machinery/power/generator/interface_interact(mob/user)
	if(!circ1 || !circ2) //Just incase the middle part of the TEG was not wrenched last.
		reconnect()
	ui_interact(user)
	return TRUE

/obj/machinery/power/generator/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	// this is the data which will be sent to the ui
	var/vertical = 0
	if (dir == NORTH || dir == SOUTH)
		vertical = 1

	var/data[0]
	data["totalOutput"] = effective_gen/1000
	data["maxTotalOutput"] = max_power/1000
	data["thermalOutput"] = last_thermal_gen/1000
	data["circConnected"] = 0

	if(circ1)
		//The one on the left (or top)
		data["primaryDir"] = vertical ? "top" : "left"
		data["primaryOutput"] = last_circ1_gen/1000
		data["primaryFlowCapacity"] = circ1.volume_capacity_used*100
		data["primaryInletPressure"] = circ1.air1.return_pressure()
		data["primaryInletTemperature"] = circ1.air1.temperature
		data["primaryOutletPressure"] = circ1.air2.return_pressure()
		data["primaryOutletTemperature"] = circ1.air2.temperature

	if(circ2)
		//Now for the one on the right (or bottom)
		data["secondaryDir"] = vertical ? "bottom" : "right"
		data["secondaryOutput"] = last_circ2_gen/1000
		data["secondaryFlowCapacity"] = circ2.volume_capacity_used*100
		data["secondaryInletPressure"] = circ2.air1.return_pressure()
		data["secondaryInletTemperature"] = circ2.air1.temperature
		data["secondaryOutletPressure"] = circ2.air2.return_pressure()
		data["secondaryOutletTemperature"] = circ2.air2.temperature

	if(circ1 && circ2)
		data["circConnected"] = 1
	else
		data["circConnected"] = 0


	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "generator.tmpl", "Thermoelectric Generator", 450, 500)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/power/generator/verb/rotate_clock()
	set category = "Object"
	set name = "Rotate Generator (Clockwise)"
	set src in view(1)

	if (usr.stat || usr.restrained()  || anchored)
		return

	src.set_dir(turn(src.dir, 90))

/obj/machinery/power/generator/verb/rotate_anticlock()
	set category = "Object"
	set name = "Rotate Generator (Counterclockwise)"
	set src in view(1)

	if (usr.stat || usr.restrained()  || anchored)
		return

	src.set_dir(turn(src.dir, -90))
