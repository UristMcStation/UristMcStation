/obj/item/robot_module/janitor
	name = "janitorial robot module"
	display_name = "Janitor"
	channels = list(
		"Service" = TRUE
	)
	sprites = list(
		"Basic" = "JanBot2",
		"Mopbot"  = "janitorrobot",
		"Mop Gear Rex" = "mopgearrex",
		"Drone" = "drone-janitor",
		"Ravensdale" = "ravensdale-Janitor",
		"Advanced-Drone" = "Advanced-Drone-Janitor",
		"Wiredroid" = "Wiredroid-Janitor",
		"Worm" = "Worm-Janitor",
		"Spider" = "Spider-Janitor",
		"Eyebot" = "Eyebot-janitor"
	)
	equipment = list(
		/obj/item/device/flash,
		/obj/item/soap,
		/obj/item/storage/bag/trash,
		/obj/item/mop/advanced,
		/obj/item/holosign_creator,
		/obj/item/device/lightreplacer,
		/obj/item/borg/sight/hud/jani,
		/obj/item/device/plunger/robot,
		/obj/item/crowbar,
		/obj/item/weldingtool
	)
	emag = /obj/item/reagent_containers/spray

/obj/item/robot_module/janitor/finalize_emag()
	. = ..()
	emag.reagents.add_reagent(/datum/reagent/lube, 200)
	emag.SetName("Space Lube spray")

/obj/item/robot_module/janitor/respawn_consumable(mob/living/silicon/robot/R, amount)
	..()
	var/obj/item/device/lightreplacer/LR = locate() in equipment
	LR.Charge(R, amount)
	if(emag)
		var/obj/item/reagent_containers/spray/S = emag
		S.reagents.add_reagent(/datum/reagent/oil, 20 * amount)
