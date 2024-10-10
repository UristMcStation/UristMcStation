var/global/const/NETWORK_MAINTENANCE         = "Maintenance Deck"
var/global/const/NETWORK_PRISON              = "Prison"
var/global/const/NETWORK_RESEARCH_OUTPOST    = "Research Outpost"
var/global/const/NETWORK_TELECOM             = "Tcomsat"
var/global/const/NETWORK_URIST               = "Urist"
var/global/const/NETWORK_COMMAND             = "Command"
var/global/const/NETWORK_ENGINE              = "Engine"
var/global/const/NETWORK_ENGINEERING_OUTPOST = "Engineering Outpost"
var/global/const/NETWORK_EXPLO  	          = "Exploration"

/datum/map/proc/get_shared_network_access(network)
	switch(network)
		if(NETWORK_COMMAND)
			return access_heads
		if(NETWORK_ENGINE, NETWORK_ENGINEERING_OUTPOST)
			return access_engine

/datum/map/glloydstation/get_network_access(network)
	switch(network)
		if(NETWORK_RESEARCH_OUTPOST)
			return access_research
		if(NETWORK_TELECOM)
			return access_heads
		if(NETWORK_URIST)
			return
	return get_shared_network_access(network) || ..()

/datum/map/glloydstation
	station_networks = list(
		NETWORK_URIST,
		NETWORK_COMMAND,
		NETWORK_ENGINE,
		NETWORK_ENGINEERING,
		NETWORK_ENGINEERING_OUTPOST,
		NETWORK_MAINTENANCE,
		NETWORK_MEDICAL,
		NETWORK_MINE,
		NETWORK_RESEARCH,
		NETWORK_RESEARCH_OUTPOST,
		NETWORK_PRISON,
		NETWORK_SECURITY,
		NETWORK_ALARM_ATMOS,
		NETWORK_ALARM_CAMERA,
		NETWORK_ALARM_FIRE,
		NETWORK_ALARM_MOTION,
		NETWORK_ALARM_POWER,
		NETWORK_THUNDER,
		NETWORK_TELECOM
	)


//
// Cameras
//

// Networks
/obj/machinery/camera/network/command
	network = list(NETWORK_COMMAND)

/obj/machinery/camera/network/urist
	network = list(NETWORK_URIST)

/obj/machinery/camera/network/maintenance
	network = list(NETWORK_MAINTENANCE)

/obj/machinery/camera/network/prison
	network = list(NETWORK_PRISON)

/obj/machinery/camera/network/research
	network = list(NETWORK_RESEARCH)

/obj/machinery/camera/network/research_outpost
	network = list(NETWORK_RESEARCH_OUTPOST)

/obj/machinery/camera/network/telecom
	network = list(NETWORK_TELECOM)

/obj/machinery/camera/network/crescent
	network = list(NETWORK_CRESCENT)

/obj/machinery/camera/network/engine
	network = list(NETWORK_ENGINE)

/obj/machinery/camera/network/engineering_outpost
	network = list(NETWORK_ENGINEERING_OUTPOST)

/obj/machinery/camera/network/exploration
	network = list(NETWORK_EXPLO)


// Motion
/obj/machinery/camera/motion/engineering_outpost
	network = list(NETWORK_ENGINEERING_OUTPOST)

/obj/machinery/camera/motion/command
	network = list(NETWORK_COMMAND)

/obj/machinery/camera/motion/urist
	network = list(NETWORK_URIST)

// X-ray
/obj/machinery/camera/xray/medbay
	network = list(NETWORK_MEDICAL)

/obj/machinery/camera/xray/research
	network = list(NETWORK_RESEARCH)

/obj/machinery/camera/xray/security
	network = list(NETWORK_SECURITY)

/obj/machinery/camera/xray/prison
	network = list(NETWORK_PRISON)

//emp proof
/obj/machinery/camera/emp_proof/engine
	network = list(NETWORK_ENGINE)

// All Upgrades
/obj/machinery/camera/all/command
	network = list(NETWORK_COMMAND)
