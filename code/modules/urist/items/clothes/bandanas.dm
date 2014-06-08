/*  ****************** BANDANAS AND SHIT ****************** */


//bandana

/obj/item/clothing/mask/bandana
	icon = 'icons/urist/items/clothes/masks.dmi'
	icon_override = 'icons/uristmob/mask.dmi'
	body_parts_covered = HEAD
	slot_flags = SLOT_MASK
	var/can_flip = 0
	var/is_flipped = 1

	/obj/item/clothing/mask/bandana/verb/togglemask()
		set name = "Toggle Bandana"
		set category = "Object"
		set src in usr
		if(!usr.canmove || usr.stat || usr.restrained())
			return
		if(!can_flip)
			usr << "You try flipping up your [src], but it is very uncomfortable and you look like a fool. You flip it back down."
			return
		if(src.is_flipped == 2)
			src.icon_state = initial(icon_state)
			gas_transfer_coefficient = initial(gas_transfer_coefficient)
			permeability_coefficient = initial(permeability_coefficient)
			flags = initial(flags)
			flags_inv = initial(flags_inv)
			usr << "You push down your [src]."
			src.is_flipped = 1
		else
			src.icon_state += "_up"
			usr << "You push up your [src]."
			gas_transfer_coefficient = null
			permeability_coefficient = null
			flags = null
			flags_inv = null
			src.is_flipped = 2
		usr.update_inv_wear_mask()

/obj/item/clothing/mask/bandana/attack_self()
	togglemask()