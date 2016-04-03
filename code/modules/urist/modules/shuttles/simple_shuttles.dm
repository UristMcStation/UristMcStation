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
	shuttle_tag = "MiningElevator"
	req_one_access = list(48)
	//circuit = /obj/item/weapon/circuitboard/

/obj/machinery/computer/shuttle_control/researchelevator
	name = "research elevator console"
	shuttle_tag = "ResearchElevator"
	req_one_access = list(65)
	//circuit = /obj/item/weapon/circuitboard/


/datum/shuttle/ferry/elevator
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

/datum/shuttle/ferry/elevator/research
	id = "planet_research"