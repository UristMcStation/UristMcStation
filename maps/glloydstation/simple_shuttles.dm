/obj/machinery/computer/shuttle_control/centcom/arrivals
	name = "arrivals shuttle console"
	shuttle_tag = "Arrivals"

/obj/machinery/computer/shuttle_control/centcom/transport
	name = "transport shuttle console"
	shuttle_tag = "Transport"

/obj/machinery/computer/shuttle_control/centcom/admin
	name = "administration shuttle console"
	shuttle_tag = "Administration"

/*
/obj/machinery/computer/shuttle_control/naval
	name = "naval shuttle console"
	shuttle_tag = "Naval"
	//req_access =
	//circuit = /obj/item/circuitboard

/obj/machinery/computer/shuttle_control/outpost
	name = "outpost shuttle console"
	shuttle_tag = "Outpost"
	//req_one_access_txt =
	//circuit = /obj/item/circuitboard
*/
/obj/machinery/computer/shuttle_control/elevator/mining
	name = "mining elevator console"
	shuttle_tag = "Mining Elevator"
	req_access = list("ACCESS_MINING")
	//circuit = /obj/item/circuitboard

/obj/machinery/computer/shuttle_control/elevator/research
	name = "research elevator console"
	shuttle_tag = "Xenoarch Elevator"
	req_access = list("ACCESS_XENOARCH")
	//circuit = /obj/item/circuitboard

/obj/machinery/computer/shuttle_control/securityoutpost
	name = "security outpost shuttle console"
	shuttle_tag = "Security"
	req_access = list("ACCESS_SECURITY")

/datum/shuttle/autodock/ferry/elevator
	category = /datum/shuttle/autodock/ferry/elevator
	name = "some elevator"
	sound_takeoff = null
	sound_landing = null
	var/id = null

/datum/shuttle/autodock/ferry/elevator/arrived()
	for(var/obj/machinery/door/blast/M in SSmachines.machinery)
		if(M.id_tag == src.id)
			if(M.density)
				spawn(0)
					M.open()
					return
			else
				spawn(0)
					M.close()
					return


/datum/shuttle/autodock/ferry/elevator/mining
	id = "planet_mining"
	name = "Mining Elevator"
	warmup_time = 5
	shuttle_area = /area/shuttle/elevator/mining/surface
	waypoint_station = "mining_elevator_surface"
	waypoint_offsite = "mining_elevator_underground"
//	docking_controller_tag = "mining_elevator_shaft"
//	dock_target_station = "mining_elevator_surface"
//	dock_target_offsite = "mining_elevator_underground"

/obj/shuttle_landmark/planet_elevator/mining/surface
	name = "Mining Surface"
	landmark_tag = "mining_elevator_surface"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/outpost/mining_main/refinery

/obj/shuttle_landmark/planet_elevator/mining/underground
	name = "Mining Underground"
	landmark_tag = "mining_elevator_underground"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/outpost/mining_main/eva

/datum/shuttle/autodock/ferry/elevator/research
	id = "planet_research"
	name = "Xenoarch Elevator"
	warmup_time = 5
	shuttle_area = /area/shuttle/elevator/research/surface
	waypoint_station = "science_elevator_surface"
	waypoint_offsite = "science_elevator_underground"
//	docking_controller_tag = "research_elevator_shaft"
//	dock_target_station = "research_elevator_surface"
//	dock_target_offsite = "research_elevator_underground"

/obj/shuttle_landmark/planet_elevator/science/surface
	name = "Science Surface"
	landmark_tag = "science_elevator_surface"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/outpost/research/dock

/obj/shuttle_landmark/planet_elevator/science/underground
	name = "Science Underground"
	landmark_tag = "science_elevator_underground"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/outpost/research/eva
