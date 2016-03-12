//paranoia - essentially rev with more factions and the conflict being interfactional rather than rev vs heads

/datum/game_mode/paranoia
	name = "Paranoia"
	config_tag = "paranoia"
	round_description = "Secret cabals have recruited crewmembers to accomplish their goals!"
	extended_round_description = "Agents - expand your faction's influence... or double-cross it for your own gain. Crew - join the conspiracies, or try to stay out of the crossfire."
	required_players = 4
	required_enemies = 3
	auto_recall_shuttle = 1
	uplink_welcome = "Spymaster's Uplink Console:"
	uplink_uses = 10
	end_on_antag_death = 0
	shuttle_delay = 3
	antag_tags = list("Buildaborg","Freemesons","MIG","Aliuminati")
	require_all_templates = 0
	votable = 0

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
			new/datum/uplink_item(/obj/item/device/inteluplink, 8, "Intel Uplink", "UL")
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

/proc/is_other_conspiracy(var/datum/mind/player,var/datum/antagonist/agent/conspiracy)
	var/paranoia_parent = /datum/antagonist/agent
	var/nonselfsum = 0 //how many other conspiracies the mind is a member of. Shouldn't come up, but better safe than sorry.
	var/own //belongs to the target faction
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(istype(antag,paranoia_parent))
			if(istype(antag, conspiracy))
				if(player in antag.current_antagonists)
					own = 1
				if(player in antag.pending_antagonists)
					own = 1
			else
				if(player in antag.current_antagonists)
					nonselfsum++
				if(player in antag.pending_antagonists)
					nonselfsum++
		else
			continue
	if(own)
		if(nonselfsum)
			return 0 //somehow belongs to the target and other conspiracies
		else
			return -1 //doesn't need converting
	return nonselfsum //number of conspiracy factions to strip

/proc/strip_all_other_conspiracies(var/datum/mind/player,var/datum/antagonist/agent/conspiracy)
	var/list/antaglist = all_antag_types.Copy()
	var/paranoia_parent = /datum/antagonist/agent
	antaglist -= paranoia_parent //kinda hacky, but prevents weirdness
	for(var/antag_type in antaglist)
		var/datum/antagonist/antag = antaglist[antag_type]
		if(istype(antag,paranoia_parent))
			if(istype(antag, conspiracy))
				continue
			else
				if(player in antag.current_antagonists)
					antag.remove_antagonist(player)
		else
			continue

/proc/get_mob_conspiracy(var/mob/M)

	var/datum/mind/player = M.mind
	if(!player)
		return

	var/list/antaglist = all_antag_types.Copy()
	var/paranoia_parent = /datum/antagonist/agent
	var/conspiracy_number = 0 //test to prevent cases where someone belongs to more than one and it overwrites, which shouldn't happen
	var/mob_conspiracy
	antaglist -= paranoia_parent

	for(var/antag_type in antaglist)
		var/datum/antagonist/antag = antaglist[antag_type]
		if(istype(antag,paranoia_parent))
			if(player in antag.current_antagonists)
				conspiracy_number++
				mob_conspiracy = antag

	if(conspiracy_number == 0)
		return -1
	else if(conspiracy_number == 1)
		return mob_conspiracy
	return //this is an error state!