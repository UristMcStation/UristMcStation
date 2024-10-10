var/global/const/NETWORK_SUBWYRM		= "Sub Deck"
var/global/const/NETWORK_PRIMWYRM		= "Primary Deck"
var/global/const/NETWORK_COMMAND		= "Command"
var/global/const/NETWORK_HATCHLING		= "Hatchling"

/datum/map/wyrm/get_network_access(network)
	switch(network)
		if(NETWORK_COMMAND)
			return access_heads
		if(NETWORK_SUBWYRM)
			return access_engine_equip
		if(NETWORK_PRIMWYRM)
			return access_security
	return ..()

/datum/map/wyrm
	station_networks = list(
		NETWORK_SUBWYRM,
		NETWORK_PRIMWYRM,
		NETWORK_COMMAND,
		NETWORK_ENGINEERING,
		NETWORK_MEDICAL,
		NETWORK_RESEARCH,
		NETWORK_MINE,
		NETWORK_SECURITY,
		NETWORK_ALARM_ATMOS,
		NETWORK_ALARM_CAMERA,
		NETWORK_ALARM_FIRE,
		NETWORK_ALARM_MOTION,
		NETWORK_ALARM_POWER,
		NETWORK_HATCHLING,
		NETWORK_THUNDER
	)

//
// Cameras
//

// Networks

/obj/machinery/camera/network/command
	network = list(NETWORK_COMMAND)

/obj/machinery/camera/network/primdeck
	network = list(NETWORK_PRIMWYRM)

/obj/machinery/camera/network/subdeck
	network = list(NETWORK_SUBWYRM)

/obj/machinery/camera/network/research
	network = list(NETWORK_RESEARCH)

/obj/machinery/camera/network/hatchling
	network = list(NETWORK_HATCHLING)

// Motion
/obj/machinery/camera/motion/command
	network = list(NETWORK_COMMAND)

// X-ray
/obj/machinery/camera/xray/security
	network = list(NETWORK_SECURITY)
