//BYOND fucking hates this file

/datum/game_mode/scom/proc/ScomTime() //this handles the vast majority of setup for SCOM. Warping, dressing and shuttles for differentiating between pop
	world<<("<span class='danger'> Welcome to the S-COM project... Congratulations! If you are reading this, then the time has come for you to drop your death commando armor, Syndicate assault squad hardsuit, Terran Republic marine gear or other and work with your most hated foes to fight a threat that will likely destroy us all! Ahead of you is a life of training, fighting supernatural and alien threats, and protecting the galaxy and all within it! Because we worry about our soldiers, we feel it needed to warn you of threats you will likely face. You will be fighting unknown threats that we have no information on, known alien lifeforms, and in the event of a Council corporation splitting off, subduing any possible leaks in the  project. It will not be an easy task, and many of you will likely die. Your first task is to secure a Nanotrasen transit station in the Nyx system. The fate of humanity rests in your hands. Good luck!</span>")
	for(var/mob/living/carbon/human/M in player_list)//yeah, using other code is nice. if urist doesn't die, i'll condense them all into one proc probably.
		HandleScomJoinFor(M, src)

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

/mob/new_player/proc/ScomLateJoin(var/mob/living/carbon/RD)
	HandleScomJoinFor(RD)

/proc/HandleScomJoinFor(var/mob/living/carbon/L, var/datum/game_mode/scom/caller)
	if(!(caller)) //hacky af, but there's no other easy way to hook into that
		log_and_message_admins("HandleScomJoinFor was called by something that is not the SCOM gamemode. That's bad.")
	//var/teamnum
	L.delete_inventory(TRUE)
	if(L.job == "Captain")
		L.loc = pick(scomspawn1)
		//scom_dressup(L, /decl/hierarchy/outfit/scom/scommander, TRUE)
		//temporary workaround -scr
		var/obj/item/weapon/card/id/W = new /obj/item/weapon/card/id/centcom(L.loc)
		L.set_id_info(W)
		W.assignment = "Commander"
		//end workaround
		L << ("<span class='warning'> You are the Commander of the S-COL forces. You are expected to control all local aspects of your S-COL base, research, medical, supply and tactical. You should not attend combat missions yourself, unless you have no other option. Your goal is to ensure the project runs smoothly. You report only to the Council and its members. Good luck, the fate of the galaxy rests on your frail shoulders.</span>")
	else if(L.job in list("Research Director", "Scientist"))
		L.loc = pick(scomspawn2)
		//scom_dressup(L, /decl/hierarchy/outfit/scom/scomscientist, TRUE)
		//temporary workaround -scr
		var/obj/item/weapon/card/id/W = new /obj/item/weapon/card/id/centcom(L.loc)
		L.set_id_info(W)
		W.assignment = "Researcher"
		//end workaround
		L << ("<span class='warning'> You are the Researcher. It is your job to bother the operatives to bring back whatever they can recover from their missions. You will use this, along with the provided facilities to advance the cause of science. It is your job to provide the soldiers with new equipment to match the rising alien threat. It is also your duty to heal any returning injured soldiers. You report to the Commander, good luck.</span>")

/*		else if(L.job in list("Clown", "Mime"))
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

	else if(L.job in list("Head of Personnel", "Head of Security", "Chief Engineer", "Chief Medical Officer"))
		var/squadpick
		if(caller.freeteams.len)
			squadpick = pick_n_take(caller.freeteams)
		else
			squadpick = pick(caller.teamnames)
		L.loc = pick(scomspawn1)
		//teamnum = caller.teamnames.Find(squadpick, 1, 4)
		//scom_dressup(L, /decl/hierarchy/outfit/scom/squaddie/scomofficer, TRUE, teamnum)
		//temporary workaround -scr
		var/obj/item/weapon/card/id/W = new /obj/item/weapon/card/id/centcom(L.loc)
		L.set_id_info(W)
		W.assignment = "Team Leader"
		//end workaround
		L << ("<span class='notice'> You are leading squad [squadpick]</span>")
			//if(L.job == "Head of Personnel")
			//	W.access += access_cent_general
			//if(L.job == "Head of Security")
			//	W.access += access_cent_thunder
			//if(L.job == "Chief Engineer")
			//	W.access += access_cent_specops
			//if(L.job == "Chief Medical Officer")
			//	W.access += access_cent_medical //keeping this for reference later when I CBA to restore access
		L << ("<span class='warning'> You are the heart of the S-COM project: the squad leaders. Divided into four squads, you are the last and greatest line of defence against the alien menace. You report to the commander. Good luck soldier, the fate of the galaxy rests on your frail shoulders.</span>")
	else
		var/squadpick
		L.loc = pick(scomspawn3)
		squadpick = pick(caller.teamnames)
		//teamnum = caller.teamnames.Find(squadpick, 1, 4)
		//scom_dressup(L, /decl/hierarchy/outfit/scom/squaddie/scomgrunt, TRUE, teamnum)
		//temporary workaround -scr
		var/obj/item/weapon/card/id/W = new /obj/item/weapon/card/id/centcom(L.loc)
		L.set_id_info(W)
		W.assignment = "S-COM Operative"
		//end workaround
		L << ("<span class='notice'> You are in squad [squadpick]</span>")
		L << ("<span class='warning'> You are the backbone of the S-COM project. The operatives. Divided into four classes (Combat Medic, Assault, Heavy, Sniper), you are the last and greatest line of defence against the alien menace. You report to your squad leaders and then to the commander. Good luck soldier, the fate of the galaxy rests on your frail shoulders.</span>")
	L.regenerate_icons()

/datum/game_mode/scom/proc/LoadScom()

	if(!scommapsloaded)
		world << "<span class='danger'> Loading S-COM Maps...</span>"

		var/file = file("maps/GamemodeMaps/missions2.dmm")
		if(isfile(file))
			maploader.load_map(file)

			for(var/x = 1 to world.maxx)
				for(var/y = 1 to world.maxy)
					turfs += locate(x,y,world.maxz)

			world.log << "S-COM Maps loaded."

		world << "<span class='danger'> S-COM Maps loaded.</span>"

		scommapsloaded = 1
	else
		return
