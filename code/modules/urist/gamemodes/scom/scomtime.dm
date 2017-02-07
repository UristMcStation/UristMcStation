//BYOND fucking hates this file

/datum/game_mode/scom/proc/ScomTime() //this handles the vast majority of setup for SCOM. Warping, dressing and shuttles for differentiating between pop
	for(var/mob/living/carbon/human/M in player_list)//yeah, using other code is nice. if urist doesn't die, i'll condense them all into one proc probably.
		HandleScomJoinFor(M, src)
		world << ("<span class='danger'> Your first task is to secure a Nanotrasen transit station in the Nyx system. The fate of humanity rests in your hands. Good luck!</span>")


/datum/game_mode/scom/proc/ScomRobotTime() //have to break up the proc because BYOND
	for(var/mob/living/silicon/S in player_list)
		if(istype(S, /mob/living/silicon/robot))
			S.loc = pick(scomspawn3)
			for(var/obj/item/weapon/cell/cell in S)
				cell.maxcharge = INFINITY
				cell.charge = INFINITY

		else if(istype(S, /mob/living/silicon/ai))
			var/mob/living/silicon/robot/R = new /mob/living/silicon/robot(S.loc)
			R.ckey = S.ckey
			R.loc = pick(scomspawn3)
			for(var/obj/item/weapon/cell/cell in R)
				cell.maxcharge = INFINITY
				cell.charge = INFINITY
			qdel(S)

/mob/new_player/proc/ScomRobotLateJoin(var/mob/living/silicon/L)
	if(L.mind.assigned_role == "Cyborg")
		L.loc = pick(scomspawn3)
		for(var/obj/item/weapon/cell/cell in L)
			cell.maxcharge = INFINITY
			cell.charge = INFINITY
		return 1
	return

/mob/new_player/proc/ScomLateJoin(var/mob/living/carbon/RD)
	HandleScomJoinFor(RD)
	return 1

/proc/HandleScomJoinFor(var/mob/living/carbon/L)
	if(!(scommies)) //hacky af, but there's no other easy way to hook into that
		log_and_message_admins("S-COM Operative antagonist not properly initialized!")
	var/squadpick = 0
	if(scommies.freeteams.len)
		squadpick = pick_n_take(scommies.freeteams)
	else
		squadpick = pick(scommies.teamnames)
	var/station_job = L.job
	L.delete_inventory(TRUE)
	if(station_job == "Captain")
		L.loc = pick(scomspawn1)
		L << ("<span class='notice'> You are the Commander of the S-COM forces. You are expected to control all local aspects of your S-COL base, research, medical, supply and tactical. You should not attend combat missions yourself, unless you have no other option. Your goal is to ensure the project runs smoothly. You report only to the Council and its members. Good luck, the fate of the galaxy rests on your frail shoulders.</span>")
		scommies.add_antagonist(L.mind, 1, 1, 1, 0, 1)
		scommies.update_antag_mob(L.mind, 1, RANK_COMMAND)
		scommies.equip(L, RANK_COMMAND, 0)
	else if(station_job in list("Research Director", "Scientist"))
		L.loc = pick(scomspawn2)
		L << ("<span class='notice'> You are the Researcher. It is your job to bother the operatives to bring back whatever they can recover from their missions. You will use this, along with the provided facilities to advance the cause of science. It is your job to provide the soldiers with new equipment to match the rising alien threat. It is also your duty to heal any returning injured soldiers. You report to the Commander, good luck.</span>")
		scommies.add_antagonist(L.mind, 1, 1, 1, 0, 1)
		scommies.update_antag_mob(L.mind, 1, RANK_SUPPORT)
		scommies.equip(L, RANK_SUPPORT, 0)

/*		else if(station_job in list("Clown", "Mime"))
			L.equip_to_slot_or_del(new /obj/item/device/radio/headset/syndicate(M), slot_l_ear)
			L.equip_to_slot_or_del(new /obj/item/clothing/under/psysuit(M), slot_w_uniform)
			L.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(M), slot_shoes)
			L.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/urist/military/scom(M), slot_belt)
			L.equip_to_slot_or_del(new /obj/item/clothing/head/wizard/amp(M), slot_head)
			L.equip_to_slot_or_del(new /obj/item/clothing/suit/wizrobe/psypurple(M), slot_wear_suit)
			L.equip_to_slot_or_del(new /obj/item/weapon/staff(M), slot_l_hand)
			L.mutations.Add(HEAL)
			L.spell_list += new /obj/effect/proc_holder/spell/targeted/turf_teleport/blink(M)
			L.spell_list += new /obj/effect/proc_holder/spell/aoe_turf/conjure/forcewall(M)
			L.spell_list += new /obj/effect/proc_holder/spell/targeted/smoke(M)
			L.mutations.Add(LASER) //TODO: FIX THIS SHIT

			for (var/obj/item/weapon/card/id/W in M)
				W.name = "[L.real_name]'s ID Card"
				W.icon_state = "centcom"
				W.access = get_all_accesses()
				W.assignment = "S-COM Psionic Operative"
				W.registered_name = L.real_name
			L.loc = pick(scomspawn3)
			M << ("<span class='warning'> You are the psionic operative. Handpicked from members of the Wizards Federation, you will use your advanced psionic powers to aid your fellow soldiers, and to fight the enemy. However, the Wizards Federation has a poor sense of humour, and there are many clowns among your ranks. Either way, try not using guns, it won't end well for you. You report to the commander.</span>")
*/

	else if(station_job in list("Head of Personnel", "Head of Security", "Chief Engineer", "Chief Medical Officer"))
		L.loc = pick(scomspawn1)
		//teamnum = scommies.teamnames.Find(squadpick, 1, 4)
		L << ("<span class='warning'> You are leading squad [squadpick]</span>")
			//if(station_job == "Head of Personnel")
			//	W.access += access_cent_general
			//if(station_job == "Head of Security")
			//	W.access += access_cent_thunder
			//if(station_job == "Chief Engineer")
			//	W.access += access_cent_specops
			//if(station_job == "Chief Medical Officer")
			//	W.access += access_cent_medical //keeping this for reference later when I CBA to restore access
		L << ("<span class='notice'> You are the heart of the S-COM project: the squad leaders. Divided into four squads, you are the last and greatest line of defence against the alien menace. You report to the commander. Good luck soldier, the fate of the galaxy rests on your frail shoulders.</span>")
		scommies.add_antagonist(L.mind, 1, 1, 1, 0, 1)
		scommies.update_antag_mob(L.mind, 1, RANK_OFFICER)
		scommies.equip(L, RANK_OFFICER, squadpick)
	else
		L.loc = pick(scomspawn3)
		//teamnum = scommies.teamnames.Find(squadpick, 1, 4)
		L << ("<span class='warning'> You are in squad [squadpick]</span>")
		L << ("<span class='notice'> You are the backbone of the S-COM project. The operatives. Divided into four classes (Combat Medic, Assault, Heavy, Sniper), you are the last and greatest line of defence against the alien menace. You report to your squad leaders and then to the commander. Good luck soldier, the fate of the galaxy rests on your frail shoulders.</span>")
		scommies.add_antagonist(L.mind, 1, 1, 1, 0, 1)
		scommies.update_antag_mob(L.mind, 1, RANK_SOLDIER)
		scommies.equip(L, RANK_SOLDIER, squadpick)
	L.regenerate_icons()
	return 1

/datum/game_mode/scom/proc/LoadScom()

	if(!scommapsloaded)
		world << "\red \b Loading S-COM Maps..."

		var/file = file("maps/GamemodeMaps/missions2.dmm")
		if(isfile(file))
			maploader.load_map(file)

			for(var/x = 1 to world.maxx)
				for(var/y = 1 to world.maxy)
					turfs += locate(x,y,world.maxz)

			world << "<span class='warning'> Initializing S-COM map objects...</span>"

			for(var/area/scom/mission/scom_area in world)
				for(var/atom/movable/object in scom_area)
					if(!deleted(object))
						object.initialize()

			world.log << "S-COM Maps loaded."

		world << "\red \b S-COM Maps loaded."

		scommapsloaded = 1
	else
		return
