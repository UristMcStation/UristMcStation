/obj/machinery/computer/shuttle_control/scom
	name = "S-COM shuttle console"
	shuttle_tag = "SCOM1"
//	var/fuckoff = 1

/*/obj/machinery/computer/shuttle_control/scom/attack_hand(mob/user as mob)
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


		..()*/

/obj/machinery/scom/shuttle_control
	name = "S-COM shuttle console"
	var/fuckoff = 1
	icon_state = "shuttle"
	icon = 'icons/obj/computer.dmi'
	density = 1
	anchored = 1

/obj/machinery/scom/shuttle_control/attack_hand(mob/user as mob)
	if(fuckoff)
		user << "<span class='notice'>You're not on a mission yet!</span>"
		return
	else
		for(var/datum/shuttle/ferry/scom/s1/C in shuttle_controller.process_shuttles)
			if(C.location == 0)
				return

			else if(C.location == 1)

				for(var/mob/living/simple_animal/hostile/M in mob_list)
					if(!M.stat && M.faction != "neutral")
						user << "<span class='notice'>There are still aliens left alive!</span>"
						return
					else
						break

				for(var/mob/living/carbon/human/H in player_list)
					if(!H.stat && H.z != 2)
						user << "<span class='notice'>There are still S-COM operatives in the mission area!</span>"
						return
					else
						C.launch()
						fuckoff = 1



/datum/shuttle/ferry/scom
	var/missiontime = 3600 //3000 //(5) //6 minutes (add 2 to the shuttle launch), 8 minutes in total. I gotta do some real testing in a full round to figure out if we're going to have 10 hour scom rounds or some bullshit like that.
	var/mission = 0
	var/missionloc = /area/shuttle/scom //shuttle
	var/missionannounce = "shit's fucked yo"
//	var/missionarea = /area/scom/mission/nolighting //temp
	var/basemission = 0
	var/missiondelayed = 0

/datum/shuttle/ferry/scom/s1
	missionloc = /area/shuttle/scom/s1/mission0

/datum/shuttle/ferry/scom/s2
	missionloc = /area/shuttle/scom/s2/mission0

/datum/shuttle/ferry/scom/s1/launch()
	command_announcement.Announce("Launching shuttles...", "S-COM Shuttle Control")

	..()

	for(var/datum/shuttle/ferry/scom/s2/C in shuttle_controller.process_shuttles)
		C.launch()


/datum/shuttle/ferry/scom/s1/arrived()
	if(location == 0)
		onmission = 0
//		for(var/obj/machinery/scom/shuttle_control/SC in world)
//			SC.fuckoff = 1

//		for(var/datum/game_mode/scom/D in world)
//			D.declared = 0

		basemission = (basemission + 1)

		for(var/R in typesof(/datum/scommissions))
			var/datum/scommissions/S = new R
			if(basemission == S.basemission)
				missionloc = S.missionloc1
				missionannounce = S.missionannounce //only announce it once
				mission = S.mission
				for(var/datum/shuttle/ferry/scom/s2/C in shuttle_controller.process_shuttles)
					C.missionloc = S.missionloc2

		spawn(missiontime - 300)
		command_announcement.Announce("Incoming transmission, please stand by for orders...", "S-COM Mission Command")

		spawn(missiontime)
		command_announcement.Announce("[missionannounce]", "S-COM Mission Command")

		spawn(missiontime + 50)
		command_announcement.Announce("Shuttles will be launched in two minutes. Grab your gear and get to the shuttles. If you miss them, use the teleporters in the hanger bay.", "S-COM Shuttle Control")

//		spawn(missiontime + 1250)

//		command_announcement.Announce("Launching shuttles...", "S-COM Shuttle Control")

		spawn(missiontime + 1300)
		if(missiondelayed)
			return

		else
			launch()

	else if(location == 1)
		onmission = 1
		for(var/obj/machinery/scom/shuttle_control/SC in world)
			SC.fuckoff = 0

		for(var/obj/effect/landmark/scom/enemyspawn/R in world)
			if(mission == R.mission)
				R.spawnmobs()

	return

/datum/shuttle/ferry/scom/s2/arrived()
	if(location == 0)
//		for(var/datum/shuttle/ferry/scom/s1/C in shuttle_controller.process_shuttles)
//			if(C.location == 1)
//				C.launch()
//				command_announcement.Announce("Shuttle 1 has been launched automatically.", "S-COM Shuttle Control")

//		basemission = (basemission + 1)


//		for(var/R in typesof(/datum/scommissions))
//			var/datum/scommissions/S = new R
//			if(basemission == S.basemission)
//				missionloc = S.missionloc2
//				mission = S.mission

		for(var/mob/living/carbon/C in mob_list)
			if(C.z != 2)
				for(var/obj/machinery/scom/teleporter2/T in world)
					C.x = T.x
					C.y = T.y
					C.z = T.z

//	else if(location == 1)
		/*for(var/R in typesof (/obj/effect/landmark/scom/enemyspawn))
			var/obj/effect/landmark/scom/enemyspawn/S = new R
			if(mission == S.mission)
				S.spawnmobs()
				qdel(S)*/

//		for(var/datum/shuttle/ferry/scom/s1/C in shuttle_controller.process_shuttles)
//			if(C.location == 0)
//				C.launch()
//				command_announcement.Announce("Shuttle 1 has been launched automatically.", "S-COM Shuttle Control")

	return