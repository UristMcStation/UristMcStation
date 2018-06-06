//Procedures in this file: Cybernetic controller modification, augmentation manipulation
//////////////////////////////////////////////////////////////////
//					CONTROLLER INTERACTION						//
//////////////////////////////////////////////////////////////////
/datum/surgery_step/augmentation //Boilerplate. I'm sorry.
	can_infect = 0

/datum/surgery_step/augmentation/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!istype(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected == null)
		return 0
	if (affected.status & ORGAN_CUT_AWAY)
		return 0
	return 1

/datum/surgery_step/augmentation/detach_controller
	allowed_tools = list(
	/obj/item/device/multitool = 100,\
	/obj/item/weapon/crowbar = 75
	)

	min_duration = 160
	max_duration = 180

/datum/surgery_step/augmentation/detach_controller/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return target_zone == BP_CHEST && target.internal_organs_by_name["cybernetic controller"] && affected.open() == 0

/datum/surgery_step/augmentation/detach_controller/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(istype(tool, /obj/item/device/multitool))
		user.visible_message("[user] starts to deactivate \the cybernetic controller's connections to [target]'s [affected.robotic ? "data cords" : "spinal column"] with \the [tool].", \
			"You start to deactivate \the cybernetic controller's connections to [target]'s [affected.robotic ? "data cords" : "spinal column"] with \the [tool].")
	else
		user.visible_message("<span class = 'danger'>[user] starts to pry off \the cybernetic controller from [target] with \the [tool]!</span>", \
			"<span class = 'danger'>You start to pry off \the cybernetic controller from [target] with \the [tool]!</span>")
		target.custom_pain("Excruciating pain is felt in your [affected.name] as connections to your spine are being ripped out with the [tool]!",50, affecting = affected)
	..()

/datum/surgery_step/augmentation/detach_controller/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/internal/cybernetic/controller/controller = target.internal_organs_by_name["cybernetic controller"]
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(istype(tool, /obj/item/device/multitool))
		user.visible_message("[user] detaches \the cybernetic controller from [target]'s [affected.robotic ? "data cords" : "spinal column"].", \
		"You detach \the cybernetic controller from [target]'s [affected.robotic ? "data cords" : "spinal column"].")
	else //For when you really need to 'disable' your prisoners
		user.visible_message("<span class = 'danger'>[user] brutally rips [target]'s controller out of them with \the [tool]!</span>", \
			"<span class = 'danger'>You devastatingly tear [target]'s controller out of them with your [tool]!</span>")
		affected.fracture()
		controller.take_damage(10)
		target.custom_pain("<span class = 'danger'>Unbearable pain is felt as metal connections are ripped out from inside your body!</span>",100, affecting = affected)
	playsound(target.loc, 'sound/items/Ratchet.ogg', 50, 1)
	controller.change_controller(target,null)
	affected.implants |= controller
	controller.dropInto(target.loc)

/datum/surgery_step/augmentation/detach_controller/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(istype(tool, /obj/item/device/multitool))
		user.visible_message("[user]'s hand slips causing \the controller's connections reinsert themselves.", \
			"Your hand slips causing \the controller's connections to reinsert themselves.")
	else
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		var/obj/item/organ/internal/cybernetic/controller/controller = target.internal_organs_by_name["cybernetic controller"]
		user.visible_message("<span class = 'danger'>[user]'s hand slips damaging \the controller's connections.</span>", \
			"<span class = 'danger'>Your hand slips damaging \the controller's connections.</span>")
		controller.take_damage(5)
		target.custom_pain("A brief spike of pain is felt as the connectors to your controller reinsert themselves into your [affected.name].",15, affecting = affected)

/datum/surgery_step/augmentation/attach_controller
	allowed_tools = list(/obj/item/organ/internal/cybernetic/controller = 100)

	min_duration = 240
	max_duration = 260

/datum/surgery_step/augmentation/attach_controller/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return target_zone == BP_CHEST && !target.internal_organs_by_name["cybernetic controller"] && affected.open() == 0

/datum/surgery_step/augmentation/attach_controller/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

/datum/surgery_step/augmentation/attach_controller/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/internal/cybernetic/controller/I = tool
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(istype(I))
		I.change_controller(target,tool)
		user.remove_from_mob(I)
		I.forceMove(target)
		affected.implants |= I
		I.replaced(target, affected)

/datum/surgery_step/augmentation/attach_controller/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class = 'danger'>[user] misaligns \the [tool] causing its connectors to puncture into [target]!</span>", \
	"<span class = 'danger'>You misalign \the [tool] causing its connectors to puncture into [target]!</span>")
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	affected.take_damage(15,0,DAM_SHARP)
	if(prob(5))
		tool.visible_message("[tool] pings as it begins to start up, and <span class = 'danger'>embeds itself into [target]!</span>")
		target.embed(tool,affected)

//////////////////////////////////////////////////////////////////
//					AUGMENTATION INTERACTION					//
//////////////////////////////////////////////////////////////////