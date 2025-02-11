//Presets for the pirate server room. Couldn't think of anywhere else to put this, I'll probably put more stuff here at some point to make up for it -Glloyd

/obj/machinery/telecomms/server/presets/pirate
	desc = "It hums with the power of a thousand suns."
	id = "server-T"
	freq_listening = list(1441)
	autolinkers = list("server-T")

//--PRESET PIRATE--//

/obj/machinery/telecomms/broadcaster/preset_pirate
	id = "Broadcaster-T"
	network = "donkco"
	autolinkers = list("broadcasterT")

//--PRESET PIRATE--//

/obj/machinery/telecomms/receiver/preset_pirate
	desc = "A banged up, dusty receiver."
	id = "Receiver-T"
	network = "donkco"
	autolinkers = list("receiver-T") // link to relay
	freq_listening = list(1441) //only logical way to play this~

/obj/machinery/telecomms/bus/preset_pirate
	desc = "A bus mainframe! Has a plaque 'Property of DonkCo Industries' welded onto the side."
	id = "Bus-T"
	network = "donkco"
	freq_listening = list(1441)
	autolinkers = list("processor-T", "server-T")

/obj/machinery/telecomms/processor/preset_pirate
	desc = "A few bulbs on this processor have burnt out, but otherwise it's perfectly fine."
	id = "Processor-T"
	network = "donkco"
	autolinkers = list("processor-T")

//And that's that for presets... I really need more stuff here.

/obj/machinery/telecomms/relay/long_range_planetary
	name = "Planetary Signal Relay"
	desc = "A massive tower used to send signals an extreme range."
	icon = 'icons/urist/structures&machinery/radio_tower.dmi'
	icon_state = "tower"
	bounds = "96;96"
	id = "Relay-PSR"
	construct_state = null
	circuitboard = null
	anchored = TRUE
