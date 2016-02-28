//paranoia - essentially rev with more factions and the conflict being interfactional rather than rev vs heads

/datum/game_mode/paranoia
	name = "Paranoia"
	config_tag = "paranoia"
	round_description = "Secret cabals have recruited crewmembers to accomplish their goals!"
	extended_round_description = "Agents - expand your faction's influence... or double-cross it for your own gain. Crew - try to root out "
	required_players = 4
	required_enemies = 3
	auto_recall_shuttle = 1
	uplink_welcome = "AntagCorp Uplink Console:"
	uplink_uses = 10
	end_on_antag_death = 0
	shuttle_delay = 3
	antag_tags = list("Buildaborg","Freemesons","MIG","Aliuminati")
	require_all_templates = 0

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
			new/datum/uplink_item(/obj/item/weapon/storage/backpack/satchel_flat, 1, "Smuggler's Satchel", "SU")
			),
		"Devices and Tools" = list(
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/jetfuel, 1, "Beaker of Jet Fuel (Destroys walls (maybe))", "JF"),
			new/datum/uplink_item(/obj/item/device/encryptionkey/syndicate, 2, "Encrypted Radio Channel Key", "ER"),
			new/datum/uplink_item(/obj/item/device/encryptionkey/binary, 3, "Binary Translator Key", "BT"),
			new/datum/uplink_item(/obj/item/weapon/storage/box/syndie_kit/clerical, 3, "Morphic Clerical Kit", "CK"),
			new/datum/uplink_item(/obj/item/weapon/aiModule/syndicate, 7, "Hacked AI Upload Module", "AI")
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