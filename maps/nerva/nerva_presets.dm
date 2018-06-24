var/const/NETWORK_FIRST_DECK		= "First Deck"
var/const/NETWORK_SECOND_DECK		= "Second Deck"
var/const/NETWORK_THIRD_DECK		= "Third Deck"
var/const/NETWORK_COMMAND		= "Command"

/datum/map/wyrm/get_network_access(var/network)
	if(network == NETWORK_COMMAND)
		return access_heads
	return ..()

/datum/map/wyrm
	station_networks = list(
		NETWORK_FIRST_DECK,
		NETWORK_SECOND_DECK,
		NETWORK_THIRD_DECK,
		NETWORK_COMMAND,
		NETWORK_ENGINEERING,
		NETWORK_MEDICAL,
		NETWORK_RESEARCH,
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

// Motion
/obj/machinery/camera/motion/command
	network = list(NETWORK_COMMAND)

// X-ray
/obj/machinery/camera/xray/security
	network = list(NETWORK_SECURITY)