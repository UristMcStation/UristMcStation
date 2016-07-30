var/global/datum/shuttle_controller/shuttle_controller


/datum/shuttle_controller
	var/list/shuttles	//maps shuttle tags to shuttle datums, so that they can be looked up.
	var/list/process_shuttles	//simple list of shuttles, for processing
	var/missionloc1 = /area/shuttle/scom/s1
	var/missionloc2 = /area/shuttle/scom/s2

/datum/shuttle_controller/proc/process()
	//process ferry shuttles
	for (var/datum/shuttle/ferry/shuttle in process_shuttles)
		if (shuttle.process_state)
			shuttle.process()

	for (var/datum/shuttle/ferry/scom/s1/SO in process_shuttles)
		missionloc1 = SO.missionloc
		SO.area_offsite = locate(missionloc1)
		SO.process()

	for (var/datum/shuttle/ferry/scom/s2/ST in process_shuttles)
		missionloc2 = ST.missionloc
		ST.area_offsite = locate(missionloc2)
		ST.process()

//This is called by gameticker after all the machines and radio frequencies have been properly initialized
/datum/shuttle_controller/proc/setup_shuttle_docks()
	for(var/shuttle_type in subtypesof(/datum/shuttle))
		var/datum/shuttle/shuttle = shuttle_type
		if(initial(shuttle.category) == shuttle_type)
			continue
		shuttle = new shuttle()
		shuttle.init_docking_controllers()
		shuttle.dock() //makes all shuttles docked to something at round start go into the docked state

	for(var/obj/machinery/embedded_controller/C in machines)
		if(istype(C.program, /datum/computer/file/embedded_program/docking))
			C.program.tag = null //clear the tags, 'cause we don't need 'em anymore

/datum/shuttle_controller/New()
	shuttles = list()
	process_shuttles = list()
