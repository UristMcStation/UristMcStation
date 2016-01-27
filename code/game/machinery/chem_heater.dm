/obj/machinery/chem_heater
	name = "chemical heater"
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0b" //GET IN THE ICON
	use_power = 1
	idle_power_usage = 300
	var/obj/item/weapon/reagent_containers/beaker = null
	var/desired_temp = 300
	var/heater_coefficient = 0.10
	var/on = 0

/obj/machinery/chem_heater/process()
	..()
	if(stat & NOPOWER)
		return
	if(on)
		if(beaker)
			if(beaker.reagents.chem_temp > desired_temp)
				beaker.reagents.chem_temp += min(-1, (desired_temp - beaker.reagents.chem_temp) * heater_coefficient)
			if(beaker.reagents.chem_temp < desired_temp)
				beaker.reagents.chem_temp += max(1, (desired_temp - beaker.reagents.chem_temp) * heater_coefficient)
			beaker.reagents.chem_temp = round(beaker.reagents.chem_temp)

			beaker.reagents.handle_reactions()

/obj/machinery/chem_heater/power_change()
	if(powered())
		stat &= ~NOPOWER
	else
		spawn(rand(0, 15))
			stat |= NOPOWER

/obj/machinery/chem_heater/attackby(obj/item/I, mob/user, params)
	if(isrobot(user))
		return

	if(istype(I, /obj/item/weapon/reagent_containers/glass))
		if(beaker)
			user << "<span class='warning'>A beaker is already loaded into the machine!</span>"
			return

		if(user.drop_item())
			beaker = I
			I.loc = src
			user << "<span class='notice'>You add the beaker to the machine.</span>"
			icon_state = "mixer1b"

/obj/machinery/chem_heater/attack_hand(mob/user)
	if (!user)
		return
	interact(user)

//Artifact from /tg/
/*/obj/machinery/chem_heater/ui_act(action, params)
	if(..())
		return

	switch(action)
		if("power")
			on = !on
		if("temperature")
			desired_temp = Clamp(input("Please input the target temperature", name) as num, 0, 1000)
		if("eject")
			on = FALSE
			eject_beaker()
	return 1*/

/obj/machinery/chem_heater/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	data["targetTemp"] = desired_temp
	data["isActive"] = on
	data["isBeakerLoaded"] = beaker ? 1 : 0

	data["currentTemp"] = beaker ? beaker.reagents.chem_temp : null
	data["beakerCurrentVolume"] = beaker ? beaker.reagents.total_volume : null
	data["beakerMaxVolume"] = beaker ? beaker.volume : null

	var beakerContents[0]
	if(beaker)
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			beakerContents.Add(list(list("name" = R.name, "volume" = R.volume)))
	data["beakerContents"] = beakerContents
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open = 1)
	if (!ui)
		ui = new(user, src, ui_key, "chem_heater.tmpl", "Chemical Heater", 390, 655)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/chem_heater/proc/eject_beaker()
	if(beaker)
		beaker.loc = get_turf(src)
		beaker.reagents.handle_reactions()
		beaker = null
		icon_state = "mixer0b"
/obj/machinery/chem_heater/verb/eject()
	set name = "Eject beaker"
	set category = "Object"
	set src in oview(1)
	eject_beaker()
/obj/machinery/chem_heater/verb/set_temp(/var/temp)
	set name = "Change Temperature"
	set category = "Object"
	set src in oview(1)
	if(temp<10) temp = 10
	if(temp>10000) temp = 10000
	desired_temp = temp
/obj/machinery/chem_heater/verb/toggle_power()
	set name = "Turn on/off"
	set category = "Object"
	set src in oview(1)
	on = !on