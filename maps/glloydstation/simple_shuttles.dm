/*
/obj/machinery/computer/shuttle_control/naval
	name = "naval shuttle console"
	shuttle_tag = "Naval"
	//req_access =
	//circuit = /obj/item/weapon/circuitboard/

/obj/machinery/computer/shuttle_control/outpost
	name = "outpost shuttle console"
	shuttle_tag = "Outpost"
	//req_one_access_txt =
	//circuit = /obj/item/weapon/circuitboard/

/obj/machinery/computer/shuttle_control/miningelevator
	name = "mining elevator console"
	shuttle_tag = "Mining Elevator"
	req_one_access = list(48)
	//circuit = /obj/item/weapon/circuitboard/

/obj/machinery/computer/shuttle_control/researchelevator
	name = "research elevator console"
	shuttle_tag = "Xenoarch Elevator"
	req_one_access = list(65)
	//circuit = /obj/item/weapon/circuitboard/

/obj/machinery/computer/shuttle_control/securityoutpost
	name = "security outpost shuttle console"
	shuttle_tag = "Security"
	req_one_access = list(1)

/datum/shuttle/ferry/elevator
	category = /datum/shuttle/ferry/elevator
	name = "some elevator"
	var/id = null

/datum/shuttle/ferry/elevator/arrived()
	for(var/obj/machinery/door/blast/M in machines)
		if(M.id == src.id)
			if(M.density)
				spawn(0)
					M.open()
					return
			else
				spawn(0)
					M.close()
					return


/datum/shuttle/ferry/elevator/mining
	id = "planet_mining"
	name = "Mining Elevator"
	location = 0
	warmup_time = 5
	area_offsite = /area/shuttle/elevator/mining/underground
	area_station = /area/shuttle/elevator/mining/surface
//	docking_controller_tag = "mining_elevator_shaft"
//	dock_target_station = "mining_elevator_surface"
//	dock_target_offsite = "mining_elevator_underground"

/datum/shuttle/ferry/elevator/research
	id = "planet_research"
	name = "Xenoarch Elevator"
	location = 0
	warmup_time = 5
	area_offsite = /area/shuttle/elevator/research/underground
	area_station = /area/shuttle/elevator/research/surface
//	docking_controller_tag = "research_elevator_shaft"
//	dock_target_station = "research_elevator_surface"
//	dock_target_offsite = "research_elevator_underground"
*/