/obj/item/robot_module/medical
	name = "medical robot module"
	channels = list(
		"Medical" = TRUE
	)
	networks = list(
		NETWORK_MEDICAL
	)
	subsystems = list(
		/datum/nano_module/crew_monitor
	)
	can_be_pushed = 0

	sprites = list(
		"Basic" = "Medbot",
		"Standard" = "surgeon",
		"Advanced Droid" = "droid-medical",
		"Needles" = "medicalrobot",
		"Drone" = "drone-medical",
		"Drone - Surgery" = "drone-surgery",
		"Drone - Chemistry" = "drone-chemistry",
		"Ravensdale" = "ravensdale-Medical",
		"Advanced-Drone" = "Advanced-Drone-Medical",
		"Wiredroid" = "Wiredroid-Medical",
		"Worm" = "Worm-Crisis",
		"Spider" = "Spider-Crisis",
		"Spider - Surgery" = "Spider-Surgeon",
		"Eyebot" = "Eyebot-crisis",
		)

/obj/item/robot_module/medical/build_equipment()
	. = ..()
	equipment += new /obj/item/robot_rack/roller_bed(src, 1)

/obj/item/robot_module/medical/surgeon
	name = "medical robot module"
	display_name = "Medical"
	equipment = list(
		/obj/item/device/flash,
		/obj/item/borg/sight/hud/med,
		/obj/item/device/scanner/health,
		/obj/item/scalpel/manager,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/cautery,
		/obj/item/bonegel,
		/obj/item/FixOVein,
		/obj/item/bonesetter,
		/obj/item/circular_saw,
		/obj/item/surgicaldrill,
		/obj/item/gripper/organ,
		/obj/item/shockpaddles/robot,
		/obj/item/reagent_containers/syringe,
		/obj/item/crowbar,
		/obj/item/stack/nanopaste,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/spray/cleaner/drone,
		/obj/item/reagent_containers/spray/sterilizine,
		/obj/item/device/scanner/reagent/adv,
		/obj/item/robot_rack/body_bag,
		/obj/item/reagent_containers/borghypo/crisis,
		/obj/item/robot_rack/bottle,
		/obj/item/reagent_containers/dropper/industrial,
		/obj/item/gripper/chemistry,
		/obj/item/extinguisher/mini,
		/obj/item/taperoll/medical,
		/obj/item/inflatable_dispenser/robot,
		/obj/item/stack/medical/splint
	)
	synths = list(
		/datum/matter_synth/medicine = 15000,
	)
	emag = /obj/item/reagent_containers/spray
	skills = list(
		SKILL_ANATOMY     = SKILL_PROF,
		SKILL_MEDICAL     = SKILL_EXPERT,
		SKILL_CHEMISTRY   = SKILL_ADEPT,
		SKILL_BUREAUCRACY = SKILL_ADEPT,
		SKILL_DEVICES     = SKILL_EXPERT,
		SKILL_EVA         = SKILL_EXPERT
	)

/obj/item/robot_module/medical/surgeon/finalize_equipment()
	. = ..()
	for(var/thing in list(
		 /obj/item/stack/nanopaste,
		 /obj/item/stack/medical/advanced/ointment,
		 /obj/item/stack/medical/advanced/bruise_pack,
		 /obj/item/stack/medical/splint
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.uses_charge = 1
		stack.charge_costs = list(1000)

/obj/item/robot_module/medical/surgeon/finalize_emag()
	. = ..()
	emag.reagents.add_reagent(/datum/reagent/acid/polyacid, 250)
	emag.SetName("Polyacid spray")

/obj/item/robot_module/medical/surgeon/finalize_synths()
	. = ..()
	var/datum/matter_synth/medicine/medicine = locate() in synths
	for(var/thing in list(
		 /obj/item/stack/nanopaste,
		 /obj/item/stack/medical/advanced/ointment,
		 /obj/item/stack/medical/advanced/bruise_pack,
		 /obj/item/stack/medical/splint
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.synths = list(medicine)

/obj/item/robot_module/medical/surgeon/respawn_consumable(mob/living/silicon/robot/R, amount)
	var/obj/item/reagent_containers/syringe/S = locate() in equipment
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	if(emag)
		var/obj/item/reagent_containers/spray/PS = emag
		PS.reagents.add_reagent(/datum/reagent/acid/polyacid, 2 * amount)
	..()

/* unincluded as the medical module has all of this
/obj/item/robot_module/medical/crisis
	name = "crisis robot module"
	display_name = "Crisis"
	equipment = list(
		/obj/item/crowbar,
		/obj/item/device/flash,
		/obj/item/borg/sight/hud/med,
		/obj/item/device/scanner/health,
		/obj/item/device/scanner/reagent/adv,
		/obj/item/robot_rack/body_bag,
		/obj/item/reagent_containers/borghypo/crisis,
		/obj/item/robot_rack/bottle,
		/obj/item/shockpaddles/robot,
		/obj/item/reagent_containers/dropper/industrial,
		/obj/item/reagent_containers/syringe,
		/obj/item/gripper/chemistry,
		/obj/item/extinguisher/mini,
		/obj/item/taperoll/medical,
		/obj/item/inflatable_dispenser/robot,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/splint,
		/obj/item/reagent_containers/spray/cleaner/drone
	)
	synths = list(
		/datum/matter_synth/medicine = 15000
	)
	emag = /obj/item/reagent_containers/spray
	skills = list(
		SKILL_ANATOMY     = SKILL_BASIC,
		SKILL_MEDICAL     = SKILL_PROF,
		SKILL_CHEMISTRY   = SKILL_ADEPT,
		SKILL_BUREAUCRACY = SKILL_ADEPT,
		SKILL_EVA         = SKILL_EXPERT
	)

/obj/item/robot_module/medical/crisis/finalize_equipment()
	. = ..()
	for(var/thing in list(
		 /obj/item/stack/medical/advanced/ointment,
		 /obj/item/stack/medical/advanced/bruise_pack,
		 /obj/item/stack/medical/splint
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.uses_charge = 1
		stack.charge_costs = list(1000)

/obj/item/robot_module/medical/crisis/finalize_emag()
	. = ..()
	emag.reagents.add_reagent(/datum/reagent/acid/polyacid, 250)
	emag.SetName("Polyacid spray")

/obj/item/robot_module/medical/crisis/finalize_synths()
	. = ..()
	var/datum/matter_synth/medicine/medicine = locate() in synths
	for(var/thing in list(
		 /obj/item/stack/medical/advanced/ointment,
		 /obj/item/stack/medical/advanced/bruise_pack,
		 /obj/item/stack/medical/splint
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.synths = list(medicine)

/obj/item/robot_module/medical/crisis/respawn_consumable(mob/living/silicon/robot/R, amount)
	var/obj/item/reagent_containers/syringe/S = locate() in equipment
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	if(emag)
		var/obj/item/reagent_containers/spray/PS = emag
		PS.reagents.add_reagent(/datum/reagent/acid/polyacid, 2 * amount)
	..()
*/
