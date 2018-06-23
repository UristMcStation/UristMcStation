//For organs that don't have biological counterparts
/obj/item/organ/internal/cybernetic
	robotic = ORGAN_ROBOT
	status = 0

/obj/item/organ/internal/cybernetic/controller
	name = "cybernetic controller"
	desc = "A control center and power supply for all your augmentations. It inserts synthetic nerves endings into you to allow instanenous control."
	var/obj/item/weapon/cell/augcell = /obj/item/weapon/cell/standard

/obj/item/organ/internal/cybernetic/controller/proc/change_controller(var/mob/living/carbon/human/owner, var/target_controller)
	for(var/obj/item/organ/internal/cybernetic/aug/O in owner.internal_organs)
		O.controller = target_controller

/obj/item/organ/internal/cybernetic/aug
	var/obj/item/organ/internal/cybernetic/controller/controller
	var/use_cost = 25

/obj/item/organ/internal/cybernetic/aug/proc/find_controller()
	for(var/obj/item/organ/internal/cybernetic/controller/O in owner.internal_organs)
		controller = O
		src.visible_message("<span class = 'notice'>\The [src] pings as a green light flickers on.</span>")
		return 1
	src.visible_message("<span class = 'notice'>\The [src] beeps as a red light flashes for a moment.</span>")
	return 0

/obj/item/organ/internal/cybernetic/aug/proc/use()
	if(!controller)
		return 0
	else if(!controller.augcell.checked_use(use_cost))
		return 0
	else
		return activate()

/obj/item/organ/internal/cybernetic/aug/verb/activate()
	return