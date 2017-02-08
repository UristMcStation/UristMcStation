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
					if(!H.stat && H.z != SCOM_ZLEVEL)
						user << "<span class='notice'>There are still S-COM operatives in the mission area!</span>"
						return
					else
						C.launch()
						fuckoff = 1



/datum/shuttle/ferry/scom
	category = /datum/shuttle/ferry/scom //parent, hide he
	name = "SCOM-BU66Y5H1T" //really nobody should see it ever, and I couldn't resist. I'll see myself out.
	var/missiontime = 3600 //3000 //(5) //6 minutes (add 2 to the shuttle launch), 8 minutes in total. I gotta do some real testing in a full round to figure out if we're going to have 10 hour scom rounds or some bullshit like that.
	var/mission = 0
	var/missionloc = /area/shuttle/scom //shuttle
	var/missionannounce = "shit's fucked yo"
//	var/missionarea = /area/scom/mission/nolighting //temp
	var/basemission = 0
	var/missiondelayed = 0
	transit_direction = EAST

/datum/shuttle/ferry/scom/s1
	name = "SCOM-400"
	area_station = /area/shuttle/scom/s1/base
	area_offsite = /area/shuttle/scom/s1/mission0


/datum/shuttle/ferry/scom/s2
	name = "SCOM-402"
	area_station = /area/shuttle/scom/s2/base
	area_offsite = /area/shuttle/scom/s2/mission0

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
				area_offsite = locate(missionloc)
				for(var/datum/shuttle/ferry/scom/s2/C in shuttle_controller.process_shuttles)
					C.missionloc = S.missionloc2
					C.area_offsite = locate(C.missionloc)

		spawn(missiontime - 300)
		command_announcement.Announce("Incoming transmission, please stand by for orders...", "S-COM Mission Command")

		spawn(missiontime)
		command_announcement.Announce("[missionannounce]", "S-COM Mission Command")

		spawn(missiontime + 50)
		command_announcement.Announce("Shuttles will be launched in two minutes. Grab your gear and get to the shuttles. If you miss them, use the teleporters in the hangar bay.", "S-COM Shuttle Control")

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

		for(var/mob/living/carbon/C in human_mob_list)
			if(isscom(C) || (ishuman(C) && !(C.mind))) //no need to teleport random non-operatives
				if(C.z != 2) //already on-site, skip teleporting
					if(C.z != 0 || (isobj(C.loc) && C.loc.z != 2)) //being in stuff sets coords to 0, so rechecks for holder
						var/obj/machinery/scom/teleporter2/destination
						var/list/all_destinations = list()
						for(var/obj/machinery/scom/teleporter2/T in machines)
							all_destinations += T
						if(all_destinations.len)
							destination = pick(all_destinations)
						if(destination)
							destination.teleport_to(C)

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