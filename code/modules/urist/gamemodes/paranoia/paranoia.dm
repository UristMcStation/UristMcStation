//paranoia - essentially rev with more factions and the conflict being interfactional rather than rev vs heads

/datum/game_mode/paranoia
	name = "Paranoia"
	config_tag = "paranoia"
	round_description = "Secret cabals have recruited crewmembers to accomplish their goals!"
	extended_round_description = "Agents - expand your faction's influence... or double-cross it for your own gain. Crew - join the conspiracies, or try to stay out of the crossfire."
	required_players = 4
	required_enemies = 4
	auto_recall_shuttle = 0
	end_on_antag_death = 0
	shuttle_delay = 3
	antag_tags = list("buildaborg","freemesons","MIG","aliuminati")
	require_all_templates = 1
	votable = 0
	var/next_intel_drop = 0
	var/intel_drop_delay_min = 6000 //10 minutes
	var/intel_drop_delay_max = 9000 //15 minutes
	var/use_random_drops = 1 //intel drops around the station, based on landmarks
	var/use_leader_drops = 1 //intel drops on faction leaders
	var/max_landmark_spawns = 10 //with random drops, a cutoff for maximum spawns
	//so that even with many landmarks and high probs, intel amount is manageable

//INTEL-DROPPING CODE BEGIN//

/datum/game_mode/paranoia/Process()
	if(world.time > next_intel_drop)
		process_intel_drop()
	..()

/datum/game_mode/paranoia/proc/drop_intel()
	var/anydropped = 0
	var/spawnedany = 0
	for(var/datum/antagonist/A in antag_templates)
		if(A.leader)
			if(A.leader.current)
				var/mob/leadermob = A.leader.current
				if(use_leader_drops)
					var/intel
					if(A.faction_descriptor)
						intel = new /obj/item/conspiracyintel(presetconspiracy = A.faction_descriptor)
					else
						intel = new /obj/item/conspiracyintel()
					if(!(leadermob.equip_to_storage(intel)))
						leadermob.put_in_hands(intel)
					anydropped++
				to_chat(leadermob, "<span class='notice'><b>Intel drop!</b></span>")
		else
			spawnedany = 0 //only one per faction should spawn, if there's more than one laptop
			for(var/obj/item/device/inteluplink/IU in world)
				if(!spawnedany)
					if((A.faction_descriptor) && (IU.faction))
						if(cmptext(IU.faction,A.faction_descriptor))
							new /obj/item/conspiracyintel(IU.loc, presetconspiracy = A.faction_descriptor)
							anydropped++
							spawnedany = 1

	if(use_random_drops)
		var/landmarkspawns = 0
		for(var/obj/effect/landmark/intelspawn/IS in landmarks_list)
			if(landmarkspawns < max_landmark_spawns)
				var/spawnprob = 50
				if(IS.probability)
					spawnprob = IS.probability
				if(prob(spawnprob))
					new /obj/item/conspiracyintel/random(IS.loc)
					landmarkspawns++
					anydropped++
	return anydropped

/datum/game_mode/paranoia/proc/process_intel_drop()
	message_admins("Intel drop incoming.")

	if(drop_intel())
		next_intel_drop = world.time + rand(intel_drop_delay_min, intel_drop_delay_max)
		return

	message_admins("Intel drop failed. Yell at scrdest/other developer if unavailable.")
	next_intel_drop = world.time + intel_drop_delay_min //recheck again in the miniumum time

//INTEL-DROPPING CODE END//
