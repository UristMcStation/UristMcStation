/obj/machinery/chemical_vent
	name = "chemical vent"
	desc = "A vent that produces smoke infused with chemicals."
	icon = 'icons/atmos/vent_pump.dmi'
	icon_state = "off"

	var/datum/radio_frequency/radio_connection
	var/mapped = TRUE
	var/list/chemicals = null

/obj/machinery/chemical_vent/polyacid
	chemicals = list(/datum/reagent/acid/polyacid = 120)

/obj/machinery/chemical_vent/decontamination
	name = "decontamination vent"
	chemicals = list(/datum/reagent/sterilizine = 120)

/obj/machinery/chemical_vent/Initialize()
	. = ..()
	create_reagents(120)
	for(var/chem in chemicals)
		reagents.add_reagent(chem, chemicals[chem])
	var/image/I = image('icons/atmos/vent_pump.dmi',"overlay")
	I.color = reagents.get_color()
	overlays += I

	radio_controller.add_object(src, 1707, RADIO_CHEM_VENT)

/obj/machinery/chemical_vent/receive_signal(datum/signal/signal, receive_method, receive_param)
	if(!(signal.data["id_tag"] == id_tag))
		return
	if(signal.data["activate"])
		activate()

/obj/machinery/chemical_vent/proc/activate()
	playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
	var/datum/effect/smoke_spread/chem/smoke_system = new()
	smoke_system.set_up(reagents, 10, 0, get_turf(src))
	smoke_system.start()
	if(!mapped)
		reagents.clear_reagents()
