// Urist Specific Augments go here. - Y

// Traitor Specific
// MIU
/obj/item/device/augment_implanter/miu
	augment = /obj/item/organ/internal/augment/active/miu

/obj/item/device/augment_implanter/countermeasures
	augment = /obj/item/organ/internal/augment/active/countermeasures

/obj/item/organ/internal/augment/active/miu
	name = "Concealed MIU CBM (Head)"
	desc = "A computer system implanted into the cornea, allowing you access to any camera networks on a local station or vessel."
	icon_state = ""
	augment_slots = AUGMENT_HEAD
	origin_tech = list(TECH_DATA = 4, TECH_BIO = 3)
	augment_flags = AUGMENT_BIOLOGICAL // That's gonna hurt, bud.
	var/active = FALSE
	var/mob/observer/eye/cameranet/eye

/obj/item/organ/internal/augment/active/miu/Initialize()
	. = ..()
	eye = new(src)
	eye.name_sufix = "camera MIU"
/*
/obj/item/organ/internal/augment/active/miu/Destroy()
	if(eye)
		if(active)
			disengage_mask(eye.owner)
		qdel(eye)
		eye = null
	..()

/obj/item/organ/internal/augment/active/miu/activate()
	active = !active
	to_chat(user, SPAN_WARNING("You activate the [src]."))
	if(active)
		engage_mask(user)
	else
		disengage_mask(user)

/obj/item/organ/internal/augment/active/miu/proc/engage_mask(mob/user)
	if(!active)
		return
	if(user.get_equipped_item(slot_wear_mask) != src)
		return

	eye.possess(user)
	to_chat(eye.owner, SPAN_NOTICE("You roll your eyes up into your skull as your mind connects to the camera networks."))

/obj/item/organ/internal/augment/active/miu/proc/disengage_mask(mob/user)
	if(user == eye.owner)
		to_chat(eye.owner, SPAN_NOTICE("You roll your eyes back to normal as your mind disconnects from the camera networks."))
		eye.release(eye.owner)
		eye.forceMove(src)

*/

/obj/item/organ/internal/augment/active/countermeasures
	name = "Concealed Countermeasure System (Torso)"
	desc = "A quick release 6-shot capacity smoke-counter measurement system installed into cylindrical ports on the shoulders, allowing for manual deployment of smoke to cover movement, or escape. It cannot be reloaded."
	icon = ""
	augment_slots = AUGMENT_CHEST
	origin_tech = list(TECH_COMBAT = 3, TECH_BIO = 3)
	augment_flags = AUGMENT_BIOLOGICAL
	var/active
	var/ammo = 6




/*
/obj/item/clothing/mask/ai
	name = "camera MIU"
	desc = "Allows for direct mental connection to accessible camera networks."
	icon_state = "s-ninja"
	item_state = "s-ninja"
	flags_inv = HIDEFACE
	item_flags = null
	body_parts_covered = FACE|EYES
	action_button_name = "Toggle MUI"
	origin_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5)
	var/active = FALSE
	var/mob/observer/eye/cameranet/eye

/obj/item/clothing/mask/ai/New()
	eye = new(src)
	eye.name_sufix = "camera MIU"
	..()

/obj/item/clothing/mask/ai/Destroy()
	if(eye)
		if(active)
			disengage_mask(eye.owner)
		qdel(eye)
		eye = null
	..()

/obj/item/clothing/mask/ai/attack_self(mob/user)
	if(user.incapacitated())
		return
	active = !active
	to_chat(user, SPAN_NOTICE("You [active ? "" : "dis"]engage \the [src]."))
	if(active)
		engage_mask(user)
	else
		disengage_mask(user)

/obj/item/clothing/mask/ai/equipped(mob/user, slot)
	..(user, slot)
	engage_mask(user)

/obj/item/clothing/mask/ai/dropped(mob/user)
	..()
	disengage_mask(user)

/obj/item/clothing/mask/ai/proc/engage_mask(mob/user)
	if(!active)
		return
	if(user.get_equipped_item(slot_wear_mask) != src)
		return

	eye.possess(user)
	to_chat(eye.owner, SPAN_NOTICE("You feel disorented for a moment as your mind connects to the camera network."))

/obj/item/clothing/mask/ai/proc/disengage_mask(mob/user)
	if(user == eye.owner)
		to_chat(eye.owner, SPAN_NOTICE("You feel disorented for a moment as your mind disconnects from the camera network."))
		eye.release(eye.owner)
		eye.forceMove(src)

*/



/obj/item/device/augment_implanter/smokelauncher
	name = "Concealed Countermeasure System (Torso)"
	desc = "A concealed port located near the shoulders, that can remotely launch smoke counter-measures. Commonly used by law-enforcement and militaries for protection. \
	It is concealed from body-scanners, and cannot be manually reloaded."
