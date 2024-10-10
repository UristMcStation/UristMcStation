/*  ****************** BANDANAS AND SHIT ****************** */


//bandana

/obj/item/clothing/mask/urist/bandana
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/masks.dmi'
//	icon_override = 'icons/uristmob/mask.dmi'
	item_state = "greenbandana"
	body_parts_covered = HEAD
	slot_flags = SLOT_MASK
	var/can_flip = 0
	var/is_flipped = 1
	var/on = 1

/obj/item/clothing/mask/urist/bandana/verb/togglemask()
	set name = "Toggle Bandana"
	set category = "Object"
	set src in usr
	var/mob/living/carbon/human/user = usr
	if(user.incapacitated())
		return 0
	if(!can_flip)
		to_chat(usr, "You try flipping up [src], but it is very uncomfortable and you look like a fool. You flip it back down.")
		return
	if(src.is_flipped == 2)
		src.icon_state = initial(icon_state)
		gas_transfer_coefficient = initial(gas_transfer_coefficient)
		permeability_coefficient = initial(permeability_coefficient)
		obj_flags = initial(obj_flags)
		flags_inv = initial(flags_inv)
		to_chat(usr, "You push down [src].")
		src.is_flipped = 1
	else
		src.icon_state += "_up"
		to_chat(usr, "You push up [src].")
		gas_transfer_coefficient = null
		permeability_coefficient = null
		obj_flags = null
		flags_inv = null
		src.is_flipped = 2
	usr.update_inv_wear_mask()

/obj/item/clothing/mask/urist/bandana/attack_self()
	togglemask()

//botany bandana

/obj/item/clothing/mask/urist/bandana/botany
	name = "green bandana"
	desc = "It's a green bandana with some fine nanotech lining."
	icon_state = "bandbotany"
	item_state = "bandbotany"
	can_flip = 1

//bedsheet bandana

/obj/item/clothing/mask/urist/bandana/bedsheet
	can_flip = 1
	var/can_roll = 1
	var/is_rolled = 1

/obj/item/clothing/mask/urist/bandana/bedsheet/verb/rollmask()
	set name = "Roll Bandana"
	set category = "Object"
	set src in usr
	var/mob/living/carbon/human/user = usr
	if(user.incapacitated())
		return 0
	if(!can_roll)
		to_chat(usr, "You try rolling up [src], but it doesn't work!")
		return
	if(src.is_rolled == 2)
		src.icon_state = initial(icon_state)
		gas_transfer_coefficient = initial(gas_transfer_coefficient)
		permeability_coefficient = initial(permeability_coefficient)
		obj_flags = initial(obj_flags)
		flags_inv = initial(flags_inv)
		to_chat(usr, "You unroll [src].")
		src.is_rolled = 1
	else
		src.icon_state += "_roll"
		to_chat(usr, "You roll up [src].")
		gas_transfer_coefficient = null
		permeability_coefficient = null
		obj_flags = null
		flags_inv = null
		src.is_rolled = 2
	usr.update_inv_wear_mask()

//bedsheet bandanas.

/obj/item/clothing/mask/urist/bandana/bedsheet/white
	name = "white bedsheet bandana"
	desc = "It's a bandana made out of a white bedsheet."
	icon_state = "white"

/obj/item/clothing/mask/urist/bandana/bedsheet/blue
	name = "blue bedsheet bandana"
	desc = "It's a bandana made out of a blue bedsheet."
	icon_state = "blue"

/obj/item/clothing/mask/urist/bandana/bedsheet/orange
	name = "orange bedsheet bandana"
	desc = "It's a bandana made out of an orange bedsheet."
	icon_state = "orange"

/obj/item/clothing/mask/urist/bandana/bedsheet/red
	name = "red bedsheet bandana"
	desc = "It's a bandana made out of a red bedsheet."
	icon_state = "red"

/obj/item/clothing/mask/urist/bandana/bedsheet/purple
	name = "purple bedsheet bandana"
	desc = "It's a bandana made out of a purple bedsheet."
	icon_state = "purple"

/obj/item/clothing/mask/urist/bandana/bedsheet/green
	name = "green bedsheet bandana"
	desc = "It's a bandana made out of a green bedsheet."
	icon_state = "green"

/obj/item/clothing/mask/urist/bandana/bedsheet/yellow
	name = "yellow bedsheet bandana"
	desc = "It's a bandana made out of a yellow bedsheet."
	icon_state = "yellow"

/obj/item/clothing/mask/urist/bandana/bedsheet/rainbow
	name = "rainbow bedsheet bandana"
	desc = "It's a bandana made out of a rainbow bedsheet."
	icon_state = "rainbow"

/obj/item/clothing/mask/urist/bandana/bedsheet/brown
	name = "brown bedsheet bandana"
	desc = "It's a bandana made out of a brown bedsheet."
	icon_state = "brown"

/obj/item/clothing/mask/urist/bandana/bedsheet/captain
	name = "captain's bedsheet bandana"
	desc = "It's a bandana made out of the captain's bedsheet."
	icon_state = "captain"

/obj/item/clothing/mask/urist/bandana/bedsheet/hop
	name = "HoP's bedsheet bandana"
	desc = "It's a bandana made out of the HoP's bedsheet."
	icon_state = "hop"

/obj/item/clothing/mask/urist/bandana/bedsheet/ce
	name = "CE's bedsheet bandana"
	desc = "It's a bandana made out of the CE's bedsheet."
	icon_state = "ce"

/obj/item/clothing/mask/urist/bandana/bedsheet/hos
	name = "HoS's bedsheet bandana"
	desc = "It's a bandana made out of the HoS's bedsheet."
	icon_state = "hos"

/obj/item/clothing/mask/urist/bandana/bedsheet/medical
	name = "medical bedsheet bandana"
	desc = "It's a bandana made out of a medical bedsheet."
	icon_state = "medical"

/obj/item/clothing/mask/urist/bandana/bedsheet/cmo
	name = "CMO's bedsheet bandana"
	desc = "It's a bandana made out of the CMO's bedsheet."
	icon_state = "cmo"

/obj/item/clothing/mask/urist/bandana/bedsheet/rd
	name = "RD's bedsheet bandana"
	desc = "It's a bandana made out of the RD's bedsheet."
	icon_state = "rd"

/obj/item/clothing/mask/urist/bandana/bedsheet/qm
	name = "Quartermaster's bedsheet bandana"
	desc = "It's a bandana made out of the QM's bedsheet."
	icon_state = "qm"

/obj/item/clothing/mask/urist/bandana/bedsheet/centcom
	name = "CentComm bedsheet bandana"
	desc = "It's a bandana made out of a CentComm bedsheet."
	icon_state = "cent"

/obj/item/clothing/mask/urist/bandana/bedsheet/syndie
	name = "Syndicate bedsheet bandana"
	desc = "It's a bandana made out of a Syndicate bedsheet."
	icon_state = "syndi"

/obj/item/clothing/mask/urist/bandana/bedsheet/cult
	name = "cult bedsheet bandana"
	desc = "It's a bandana made out of a cultist's bedsheet."
	icon_state = "cult"

/obj/item/clothing/mask/urist/bandana/bedsheet/wiz
	name = "wizard's bedsheet bandana"
	desc = "It's a bandana made out of a wizard's bedsheet."
	icon_state = "wiz"

/obj/item/clothing/mask/urist/bandana/bedsheet/clown
	name = "clown's bedsheet bandana"
	desc = "It's a bandana made out of a clown's bedsheet."
	icon_state = "clown"

/obj/item/clothing/mask/urist/bandana/bedsheet/mime
	name = "mime's bedsheet bandana"
	desc = "It's a bandana made out of a mime's bedsheet."
	icon_state = "mime"

//bedsheet bandanas

/*/obj/item/clothing/mask/bandana/bedsheet/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/B = new /obj/item/bedsheet

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)*/

//I fixed the bugs. I'll clean this up too when I get a chance.
/*
/obj/item/clothing/mask/bandana/bedsheet/white/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/B = new /obj/item/bedsheet

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/blue/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/blue/B = new /obj/item/bedsheet/blue

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/orange/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/orange/B = new /obj/item/bedsheet/orange

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/red/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/red/B = new /obj/item/bedsheet/red

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/purple/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/purple/B = new /obj/item/bedsheet/purple

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/green/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/green/B = new /obj/item/bedsheet/green

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/yellow/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/yellow/B = new /obj/item/bedsheet/yellow

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/rainbow/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/rainbow/B = new /obj/item/bedsheet/rainbow

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/brown/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/brown/B = new /obj/item/bedsheet/brown

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/captain/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/captain/B = new /obj/item/bedsheet/captain

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/hop/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/hop/B = new /obj/item/bedsheet/hop

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/ce/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/ce/B = new /obj/item/bedsheet/ce

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/hos/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/hos/B = new /obj/item/bedsheet/hos

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)


/obj/item/clothing/mask/bandana/bedsheet/medical/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/medical/B = new /obj/item/bedsheet/medical

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/cmo/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/cmo/B = new /obj/item/bedsheet/cmo

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/rd/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/rd/B = new /obj/item/bedsheet/rd

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/qm/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/qm/B = new /obj/item/bedsheet/qm

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/centcom/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/centcom/B = new /obj/item/bedsheet/centcom

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/syndie/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/syndie/B = new /obj/item/bedsheet/syndie

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/cult/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/cult/B = new /obj/item/bedsheet/cult

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/wiz/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/wiz/B = new /obj/item/bedsheet/wiz

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/clown/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/clown/B = new /obj/item/bedsheet/clown

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)

/obj/item/clothing/mask/bandana/bedsheet/mime/verb/toggle_bandana()
	set name = "Unfold Bedsheet"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(on)
		var/obj/item/bedsheet/mime/B = new /obj/item/bedsheet/mime

		user.remove_from_mob(src)

		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You unfold the bandana back into a bedsheet.</span>")
		qdel(src)
*/
