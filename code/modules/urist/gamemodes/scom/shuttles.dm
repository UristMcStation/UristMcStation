/obj/machinery/computer/shuttle_control/scom
	name = "S-COM shuttle console"
	shuttle_tag = "SCOM1"
	var/fuckoff = 1

/obj/machinery/computer/shuttle_control/scom/attack_hand(mob/user as mob)
	if(fuckoff)
		user << "<span class='notice'>You're not on a mission yet!!</span>"
		return
	else
		for(var/mob/living/simple_animal/hostile/M in world)
			if(!M.stat)
				user << "<span class='notice'>There are still aliens left alive!</span>"
				return
		for(var/mob/living/carbon/human/H in /area/scom/mission)
			if(H.stat)
				user << "<span class='notice'>There are still S-COM operatives in the mission area!</span>"
				return

		..()

/datum/shuttle/ferry/scom
	var/missiontime = 3600 //3000 //(5) //6 minutes (add 2 to the shuttle launch). I gotta do some real testing in a full round to figure out if we're going to have 10 hour scom rounds or some bullshit like that.
	var/mission = 0
	var/missionloc = /area/shuttle/scom //shuttle
	var/missionannounce = "shit's fucked yo"
//	var/missionarea = /area/scom/mission/nolighting //temp

/datum/shuttle/ferry/scom/s1
	missionloc = /area/shuttle/scom/s1/mission0

/datum/shuttle/ferry/scom/s2
	missionloc = /area/shuttle/scom/s2/mission0

/datum/shuttle/ferry/scom/s1/arrived()
	if(location == 0)

		for(var/obj/machinery/computer/shuttle_control/scom/SC in world)
			SC.fuckoff = 1

		for(var/datum/shuttle/ferry/scom/s2/C in shuttle_controller.process_shuttles)
			if(C.location == 1)
				C.launch()
				command_announcement.Announce("Shuttle 2 has been launched automatically.", "S-COM Shuttle Control")
		mission = (mission + 1)

		for(var/R in typesof(/datum/scommissions))
			var/datum/scommissions/S = new R
			if(mission == S.mission)
				missionloc = S.missionloc1
				missionannounce = S.missionannounce //only announce it once

		spawn(missiontime)
		command_announcement.Announce("[missionannounce]", "S-COM Mission Command")

		spawn(missiontime + 50)
		command_announcement.Announce("Shuttles will be launched in two minutes. Grab your gear and get to the shuttles. If you miss them, use the teleportes in the hanger bay.", "S-COM Shuttle Control")

		spawn(missiontime + 1250)

		command_announcement.Announce("Launching shuttles...", "S-COM Shuttle Control")

		spawn(missiontime + 1300)
		launch()

	else if(location == 1)
		for(var/obj/machinery/computer/shuttle_control/scom/SC in world)
			SC.fuckoff = 0

		for(var/obj/effect/landmark/scom/enemyspawn/R in world)
			if(mission == R.mission)
				R.spawnmobs()

		for(var/datum/shuttle/ferry/scom/s2/C in shuttle_controller.process_shuttles)
			if(C.location == 0)
				C.launch()
				command_announcement.Announce("Shuttle 2 has been launched automatically.", "S-COM Shuttle Control")
	return

/datum/shuttle/ferry/scom/s2/arrived()
	if(location == 0)
		for(var/datum/shuttle/ferry/scom/s1/C in shuttle_controller.process_shuttles)
			if(C.location == 1)
				C.launch()
				command_announcement.Announce("Shuttle 1 has been launched automatically.", "S-COM Shuttle Control")
		mission = (mission + 1)

		for(var/R in typesof(/datum/scommissions))
			var/datum/scommissions/S = new R
			if(mission == S.mission)
				missionloc = S.missionloc2

	else if(location == 1)
		for(var/R in typesof (/obj/effect/landmark/scom/enemyspawn))
			var/obj/effect/landmark/scom/enemyspawn/S = new R
			if(mission == S.mission)
				S.spawnmobs()
				del(S)

		for(var/datum/shuttle/ferry/scom/s1/C in shuttle_controller.process_shuttles)
			if(C.location == 0)
				C.launch()
				command_announcement.Announce("Shuttle 1 has been launched automatically.", "S-COM Shuttle Control")

	return