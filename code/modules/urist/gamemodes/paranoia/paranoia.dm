//paranoia - essentially rev with more factions and the conflict being interfactional rather than rev vs heads

/datum/game_mode/paranoia
	name = "Paranoia"
	config_tag = "paranoia"
	round_description = "Secret cabals have recruited crewmembers to accomplish their goals!"
	extended_round_description = "Agents - expand your faction's influence... or double-cross it for your own gain. Crew - join the conspiracies, or try to stay out of the crossfire."
	required_players = 4
	required_enemies = 4
	auto_recall_shuttle = 0
	uplink_welcome = "Spymaster's Uplink Console:"
	uplink_uses = 10
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

	//Paranoia uplink, cut down on the combat-heavy items.

	uplink_items = list(
		"Ammunition" = list(
			new/datum/uplink_item(/obj/item/ammo_magazine/mc9mm, 2, "9mm", "R9"),
			new/datum/uplink_item(/obj/item/ammo_magazine/chemdart, 2, "Darts", "AD")
			),
		"Highly Visible and Dangerous Weapons" = list(
			 new/datum/uplink_item(/obj/item/weapon/gun/projectile/dartgun, 5, "Dart Gun", "DG"),
			 new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/g9mm, 5, "Silenced 9mm", "S9")
			),
		"Stealthy and Inconspicuous Weapons" = list(
			new/datum/uplink_item(/obj/item/weapon/cane/concealed, 2, "Concealed Cane Sword", "CC"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/cigarette, 4, "Cigarette Kit", "BH"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/toxin, 4, "Random Toxin - Beaker", "RT")
			),
		"Stealth and Camouflage Items" = list(
			new/datum/uplink_item(/obj/item/weapon/card/id/syndicate, 2, "Agent ID card", "AC"),

			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/spy, 2, "Bug Kit", "BK"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/chameleon, 3, "Chameleon Kit", "CB"),

			new/datum/uplink_item(/obj/item/clothing/mask/gas/voice, 4, "Voice Changer", "VC"),
			new/datum/uplink_item(/obj/item/weapon/disk/file/cameras/syndicate, 6, "Camera Network Access - Floppy", "SF"),
			new/datum/uplink_item(/obj/item/weapon/storage/backpack/satchel_flat, 1, "Smuggler's Satchel", "SU"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/fleshsuit, 4, "Human-suit", "FS")
			),
		"Devices and Tools" = list(
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/jetfuel, 1, "Beaker of Jet Fuel (Destroys walls (maybe))", "JF"),
			new/datum/uplink_item(/obj/item/device/encryptionkey/syndicate, 2, "Encrypted Radio Channel Key", "ER"),
			new/datum/uplink_item(/obj/item/device/encryptionkey/binary, 3, "Binary Translator Key", "BT"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/clerical, 3, "Morphic Clerical Kit", "CK"),
			new/datum/uplink_item(/obj/item/weapon/aiModule/syndicate, 7, "Hacked AI Upload Module", "AI"),
			new/datum/uplink_item(/obj/item/device/inteluplink, 8, "Intel Uplink", "UL"),
			new/datum/uplink_item(/obj/item/weapon/storage/secure/briefcase/money, 3, "Operations Funding", "OF")
			),
		"Implants" = list(
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/imp_freedom, 3, "Freedom Implant", "FI"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/imp_compress, 4, "Compressed Matter Implant", "CI"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/imp_explosive, 6, "Explosive Implant (DANGER!)", "EI"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/imp_uplink, 10, "Uplink Implant (Contains 5 Telecrystals)", "UI")
			),
		"Medical" = list(
			new/datum/uplink_item(/obj/item/weapon/storage/box/sinpockets, 1, "Box of Sin-Pockets", "DP"),
			new/datum/uplink_item(/obj/item/weapon/storage/firstaid/surgery, 5, "Surgery kit", "SK")
		),
		"(Pointless) Badassery" = list(
			new/datum/uplink_item(/obj/item/weapon/storage/fancy/cigarettes/urist/syndicate, 2, "Syndicate Cigarettes", "SC")
			)
		)

//INTEL-DROPPING CODE BEGIN//

/datum/game_mode/paranoia/process()
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
						intel = new /obj/item/weapon/conspiracyintel(presetconspiracy = A.faction_descriptor)
					else
						intel = new /obj/item/weapon/conspiracyintel()
					if(!(leadermob.equip_to_storage(intel)))
						leadermob.put_in_hands(intel)
					anydropped++
				leadermob << "<span class='notice'><b>Intel drop!</b></span>"
		else
			spawnedany = 0 //only one per faction should spawn, if there's more than one laptop
			for(var/obj/item/device/inteluplink/IU in world)
				if(!spawnedany)
					if((A.faction_descriptor) && (IU.faction))
						if(cmptext(IU.faction,A.faction_descriptor))
							new /obj/item/weapon/conspiracyintel(IU.loc, presetconspiracy = A.faction_descriptor)
							anydropped++
							spawnedany = 1

	if(use_random_drops)
		var/landmarkspawns = 0
		for(var/obj/effect/landmark/intelspawn/IS in world)
			if(landmarkspawns < max_landmark_spawns)
				var/spawnprob = 50
				if(IS.probability)
					spawnprob = IS.probability
				if(prob(spawnprob))
					new /obj/item/weapon/conspiracyintel/random(IS.loc)
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
