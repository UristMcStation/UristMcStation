//TODO - make the other shuttle launch() if the other one hasn't, make mission announce go only once

/obj/machinery/computer/shuttle_control/scom
	name = "S-COM shuttle console"
//	shuttle_tag = "SCOM"
	var/fuckoff = 0

/obj/machinery/computer/shuttle_control/scom/attack_hand(mob/user as mob)
	if(fuckoff)
		return
	else
		for(var/mob/living/simple_animal/hostile/M in /area/scom/mission)
			if(!M.stat)
				user << "<span class='notice'>There are still aliens left alive!</span>"
				return
		for(var/mob/living/carbon/human/H in /area/scom/mission)
			if(H.stat)
				user << "<span class='notice'>There are still S-COM operatives in the mission area!</span>"
				return

		..()

/obj/machinery/computer/shuttle_control/scom/s1
	shuttle_tag = "SCOM1"

/obj/machinery/computer/shuttle_control/scom/s2
	shuttle_tag = "SCOM2"

/datum/shuttle/ferry/scom
	var/missiontime = 2400 //3000 //5 minutes. I gotta do some real testing in a full round to figure out if we're going to have 10 hour scom rounds or some bullshit like that.
	var/mission = 0
	var/missionloc = /area/shuttle/scom //shuttle
	var/missionannounce = "shit's fucked yo"
//	var/scomshuttle = 0

/datum/shuttle/ferry/scom/s1
	missionloc = /area/shuttle/scom/s1/mission0
//	scomshuttle = 1

/datum/shuttle/ferry/scom/s2
	missionloc = /area/shuttle/scom/s2/mission0
//	scomshuttle = 2

/datum/shuttle/ferry/scom/s1/arrived() //well, datum based missions are here to stay, no more of that horrible tree of else ifs. now i just need to condense these into 1
	if(location == 0)
		for(var/datum/shuttle/ferry/scom/s2/C in shuttle_controller.process_shuttles)
			if(C.location == 1)
				C.launch()
				command_announcement.Announce("Shuttle 2 has been launched automatically.", "S-COM Shuttle Control")
		mission = (mission + 1)
//		world << "PLUS ONE"
		for(var/R in typesof(/datum/scommissions))
			var/datum/scommissions/S = new R
			if(mission == S.mission)
				missionloc = S.missionloc1
				missionannounce = S.missionannounce //only announce it once
//				world << "ANNOUNCE SET"
		for(var/obj/machinery/computer/shuttle_control/scom/s1/SC in area_station)
			SC.fuckoff = 1
//			world << "FUCKOFF"
		spawn(missiontime)
		command_announcement.Announce("[missionannounce]", "S-COM Mission Command")
		for(var/obj/machinery/computer/shuttle_control/scom/s1/SC in area_station)
			SC.fuckoff = 0
//			world << "NO MORE FUCKOFF"


	else if(location == 1)
		for(var/R in typesof (/obj/effect/landmark/scom/enemyspawn))
			var/obj/effect/landmark/scom/enemyspawn/S = new R
			if(mission == S.mission)
				S.spawnmobs()
//				world << "MOBS SPAWNED"
				del(S)
		for(var/datum/shuttle/ferry/scom/s2/C in shuttle_controller.process_shuttles)
			if(C.location == 0)
				C.launch()
				command_announcement.Announce("Shuttle 2 has been launched automatically.", "S-COM Shuttle Control")
	return

/datum/shuttle/ferry/scom/s2/arrived() //well, datum based missions are here to stay, no more of that horrible tree of else ifs. now i just need to condense these into 1
	if(location == 0)
		for(var/datum/shuttle/ferry/scom/s1/C in shuttle_controller.process_shuttles)
			if(C.location == 1)
				C.launch()
				command_announcement.Announce("Shuttle 1 has been launched automatically.", "S-COM Shuttle Control")
		mission = (mission + 1)
//		world << "PLUS ONE"
		for(var/R in typesof(/datum/scommissions))
			var/datum/scommissions/S = new R
			if(mission == S.mission)
				missionloc = S.missionloc2
		for(var/obj/machinery/computer/shuttle_control/scom/s2/SC in area_station)
			SC.fuckoff = 1
//			world << "FUCKOFF"
		spawn(missiontime)
//		command_announcement.Announce("[missionannounce]", "S-COM Mission Command")
		for(var/obj/machinery/computer/shuttle_control/scom/s2/SC in area_station)
			SC.fuckoff = 0
//			world << "NO MORE FUCKOFF"


	else if(location == 1)
		for(var/R in typesof (/obj/effect/landmark/scom/enemyspawn))
			var/obj/effect/landmark/scom/enemyspawn/S = new R
			if(mission == S.mission)
				S.spawnmobs()
//				world << "MOBS SPAWNED"
				del(S)
		for(var/datum/shuttle/ferry/scom/s1/C in shuttle_controller.process_shuttles)
			if(C.location == 0)
				C.launch()
				command_announcement.Announce("Shuttle 1 has been launched automatically.", "S-COM Shuttle Control")


	return