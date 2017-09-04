/*
So I played around with AsciiDots and wanted to make this.
90% of the stuff here is handled by the /datum/data_program
*/

#define PACKET_RANGE_LIMIT 99

//base compuer machinery

/obj/machinery/data
	icon = 'maps/wyrm/icons/spc.dmi'
	density = TRUE
	anchored = TRUE

	var/has_matrix_presence

/obj/machinery/data/proc/transmit_data()
	flick("[icon_state]_transmit",src) //This is really just to test how fast this is

/*
/obj/machinery/data/Initialize()
	var/turf/T = locate(x, y, GLOB.matrix_z)
	if(T && has_matrix_presence)
		new
*/

//data machinery

/*
/obj/machinery/data/machine/Destroy()
	qdel_null(data_cables)
	..()
*/

/obj/machinery/data/machine
	var/data_cables = list() //connectors

/obj/machinery/data/machine/New()
	for(var/c_d in GLOB.cardinal)
		var/turf/T = get_step(src,c_d)
		for(var/obj/machinery/data/cable/C in T.contents)
			data_cables += C
	. = ..()

/obj/machinery/data/machine/transmitter
	name = "button"
	desc = "It does things when connected to data cables."
	icon_state = "button"

	var/transmit_data

/obj/machinery/data/machine/transmitter/button
	transmit_data = list("activate")

/obj/machinery/data/machine/transmitter/button/attackby()
	var/datum/packet = new/datum/packet(transmit_data)
	for(var/obj/machinery/data/cable/dc in data_cables)
		dc.transmit_data(packet)

/obj/machinery/data/machine/light
	name = "light bulb"
	icon_state = "lightbulb"

/obj/machinery/data/machine/light/transmit_data(var/datum/packet/P)
	if(P.data["activate"])
		light_power = 2
		light_range = 2
		update_light()

//data cables

/obj/machinery/data/cable
	name = "data cable"
	desc = "A cable for transmitting electrical signals at astounding speeds, don't blink or you'll miss it."
	icon_state = "data_cable"
	density = FALSE
	anchored = TRUE

/obj/machinery/data/cable/transmit_data(var/datum/packet/P)
	var/turf/T = get_step(src, dir)
	for(var/obj/machinery/data/D in T.contents)
		if(!P.fade())
			D.transmit_data(P)
			..()

/obj/machinery/data/cable/splitter
	name = "data splitter"
	desc = "A device to copy your packets to multiple places."

//packets

/datum/packet
	var/data
	var/fade = 0

/datum/packet/New(var/new_data)
	data = new_data
	world << "new packet created with [data]"

//no infinite loops
/datum/packet/proc/fade()
	fade++
	world << "fade is at [fade]"
	if(fade > PACKET_RANGE_LIMIT)
		return TRUE
	return FALSE

/obj/machinery/data/packet_holder
	name = "packet holder"
	var/datum/packet/packet

/obj/machinery/data/packet_holder/New()
	packet = new/datum/packet(list("activate"))
#undef PACKET_RANGE_LIMIT