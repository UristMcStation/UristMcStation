/obj/item/robot_module/miner
	name = "miner robot module"
	display_name = "Miner"
	subsystems = list(
		/datum/nano_module/supply
	)
	channels = list(
		"Supply" = TRUE,
		"Science" = TRUE
	)
	networks = list(
		NETWORK_MINE
	)
	sprites = list(
		"Basic" = "Miner_old",
		"Advanced Droid" = "droid-miner",
		"Treadhead" = "Miner",
		"Drone" = "drone-miner",
		"Ravensdale" = "ravensdale-Miner",
		"Advanced-Drone" = "Advanced-Drone-Miner",
		"Wiredroid" = "Wiredroid-Miner",
		"Worm" = "Worm-Miner",
		"Spider" = "Spider-Miner",
		"Eyebot" = "Eyebot-miner"
	)
	supported_upgrades = list(
		/obj/item/borg/upgrade/jetpack
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/borg/sight/meson,
		/obj/item/wrench,
		/obj/item/screwdriver,
		/obj/item/storage/ore,
		/obj/item/pickaxe/borgdrill,
		/obj/item/storage/sheetsnatcher/borg,
		/obj/item/gripper/miner,
		/obj/item/device/scanner/mining,
		/obj/item/crowbar
	)
	emag_gear = list(
		/obj/item/melee/baton/robot/electrified_arm,
		/obj/item/rcd/borg
	)

	skills = list(
		SKILL_PILOT        = SKILL_EXPERIENCED,
		SKILL_EVA          = SKILL_MASTER,
		SKILL_CONSTRUCTION = SKILL_EXPERIENCED
	)
	no_slip = 1

/obj/item/robot_module/miner/handle_emagged()
	..()
	var/obj/item/pickaxe/D = locate(/obj/item/pickaxe/borgdrill) in equipment
	if(D)
		equipment -= D
		qdel(D)
	D = new /obj/item/pickaxe/diamonddrill(src)
	D.canremove = FALSE
	equipment += D
