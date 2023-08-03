var/global/const/NETWORK_FIRST_DECK		= "First Deck" //new top
var/global/const/NETWORK_SECOND_DECK		= "Second Deck" //top central, old top
var/global/const/NETWORK_THIRD_DECK		= "Third Deck" //bottom central, old central
var/global/const/NETWORK_FOURTH_DECK		= "Fourth Deck" //bottom
var/global/const/NETWORK_COMMAND			= "Command"
var/global/const/NETWORK_CARGO				= "Cargo"
var/global/const/NETWORK_TRAJAN     		= "Trajan"
var/global/const/NETWORK_HADRIAN     		= "Hadrian"
var/global/const/NETWORK_ANTONINE     		= "Antonine"
var/global/const/NETWORK_PRISON            = "Prison"
var/global/const/NETWORK_EXPLO             = "Exploration"

/datum/map/nerva/get_network_access(network)
	if(network == NETWORK_COMMAND)
		return access_heads
	return ..()

/datum/map/nerva
	station_networks = list(
		NETWORK_FIRST_DECK,
		NETWORK_SECOND_DECK,
		NETWORK_THIRD_DECK,
		NETWORK_FOURTH_DECK,
		NETWORK_COMMAND,
		NETWORK_ENGINEERING,
		NETWORK_EXPLO,
		NETWORK_MEDICAL,
		NETWORK_RESEARCH,
		NETWORK_CARGO,
		NETWORK_TRAJAN,
		NETWORK_HADRIAN,
		NETWORK_ANTONINE,
		NETWORK_MINE,
		NETWORK_SECURITY,
		NETWORK_PRISON,
		NETWORK_ALARM_ATMOS,
		NETWORK_ALARM_CAMERA,
		NETWORK_ALARM_FIRE,
		NETWORK_ALARM_MOTION,
		NETWORK_ALARM_POWER,
		NETWORK_THUNDER
	)

//
// Cameras
//

// Networks

/obj/machinery/camera/network/command
	network = list(NETWORK_COMMAND)

/obj/machinery/camera/network/first_deck
	network = list(NETWORK_FIRST_DECK)

/obj/machinery/camera/network/second_deck
	network = list(NETWORK_SECOND_DECK)

/obj/machinery/camera/network/third_deck
	network = list(NETWORK_THIRD_DECK)

/obj/machinery/camera/network/fourth_deck
	network = list(NETWORK_FOURTH_DECK)

/obj/machinery/camera/network/research
	network = list(NETWORK_RESEARCH)

/obj/machinery/camera/network/engineering
	network = list(NETWORK_ENGINEERING)

/obj/machinery/camera/network/cargo
	network = list(NETWORK_CARGO)

/obj/machinery/camera/network/trajan
	network = list(NETWORK_TRAJAN)

/obj/machinery/camera/network/hadrian
	network = list(NETWORK_HADRIAN)

/obj/machinery/camera/network/antonine
	network = list(NETWORK_ANTONINE)

/obj/machinery/camera/network/prison
	network = list(NETWORK_PRISON)

/obj/machinery/camera/network/exploration
	network = list(NETWORK_EXPLO)

// Motion
/obj/machinery/camera/motion/command
	network = list(NETWORK_COMMAND)

// X-ray
/obj/machinery/camera/xray/security
	network = list(NETWORK_SECURITY)

/obj/machinery/camera/xray/second_deck //for officers dorms
	network = list(NETWORK_FIRST_DECK)

/obj/machinery/camera/xray/command //for the bridge
	network = list(NETWORK_COMMAND)

/obj/machinery/power/smes/buildable/preset/nerva/shuttle
	uncreated_component_parts = list(
	/obj/item/stock_parts/smes_coil/super_io = 1,
	/obj/item/stock_parts/smes_coil/super_capacity = 1
	)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

/obj/machinery/power/smes/buildable/preset/nerva/hangar
	uncreated_component_parts = list(
	/obj/item/stock_parts/smes_coil/super_io = 2,
	)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

/obj/item/clothing/head/helmet/space/rig/command/exploration
	camera = /obj/machinery/camera/network/command
