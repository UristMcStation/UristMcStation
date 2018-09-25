var/const/NETWORK_FIRST_DECK		= "First Deck" //top
var/const/NETWORK_SECOND_DECK		= "Second Deck" //central
var/const/NETWORK_THIRD_DECK		= "Third Deck" //bottom
var/const/NETWORK_COMMAND			= "Command"
var/const/NETWORK_CARGO				= "Cargo"

/datum/map/nerva/get_network_access(var/network)
	if(network == NETWORK_COMMAND)
		return access_heads
	return ..()

/datum/map/nerva
	station_networks = list(
		NETWORK_FIRST_DECK,
		NETWORK_SECOND_DECK,
		NETWORK_THIRD_DECK,
		NETWORK_COMMAND,
		NETWORK_ENGINEERING,
		NETWORK_MEDICAL,
		NETWORK_RESEARCH,
		NETWORK_CARGO,
		NETWORK_MINE,
		NETWORK_ROBOTS,
		NETWORK_SECURITY,
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

/obj/machinery/camera/network/research
	network = list(NETWORK_RESEARCH)

/obj/machinery/camera/network/engineering
	network = list(NETWORK_ENGINEERING)

/obj/machinery/camera/network/cargo
	network = list(NETWORK_CARGO)

// Motion
/obj/machinery/camera/motion/command
	network = list(NETWORK_COMMAND)

// X-ray
/obj/machinery/camera/xray/security
	network = list(NETWORK_SECURITY)

/obj/machinery/camera/xray/first_deck //for officers dorms
	network = list(NETWORK_FIRST_DECK)

/obj/machinery/camera/xray/command //for the bridge
	network = list(NETWORK_COMMAND)

/obj/machinery/power/smes/buildable/preset/nerva/shuttle/configure_and_install_coils()
	component_parts += new /obj/item/weapon/smes_coil/super_io(src)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE