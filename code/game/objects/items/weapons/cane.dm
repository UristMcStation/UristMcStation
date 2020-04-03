/obj/item/weapon/cane
	name = "cane"
	desc = "A cane used by a true gentlemen. Or a clown."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cane"
	item_state = "stick"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 5.0
	throwforce = 7.0
	w_class = ITEM_SIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 50)
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")

/obj/item/weapon/cane/concealed
	var/concealed_blade

/obj/item/weapon/cane/concealed/New()
	..()
	var/obj/item/weapon/material/butterfly/switchblade/temp_blade = new(src)
	concealed_blade = temp_blade
	temp_blade.attack_self()

/obj/item/weapon/cane/concealed/attack_self(var/mob/user)
	if(concealed_blade)
		user.visible_message("<span class='warning'>[user] has unsheathed \a [concealed_blade] from [src]!</span>", "You unsheathe \the [concealed_blade] from [src].")
		// Calling drop/put in hands to properly call item drop/pickup procs
		playsound(user.loc, 'sound/weapons/flipblade.ogg', 50, 1)
		user.drop_from_inventory(src)
		user.put_in_hands(concealed_blade)
		user.put_in_hands(src)
		concealed_blade = null
		update_icon()
		user.update_inv_l_hand()
		user.update_inv_r_hand()
	else
		..()

/obj/item/weapon/cane/concealed/attackby(var/obj/item/weapon/material/butterfly/W, var/mob/user)
	if(!src.concealed_blade && istype(W) && user.unEquip(W, src))
		user.visible_message("<span class='warning'>[user] has sheathed \a [W] into [src]!</span>", "You sheathe \the [W] into [src].")
		src.concealed_blade = W
		update_icon()
		user.update_inv_l_hand()
		user.update_inv_r_hand()
	else
		..()

/obj/item/weapon/cane/concealed/update_icon()
	if(concealed_blade)
		SetName(initial(name))
		icon_state = initial(icon_state)
		item_state = initial(item_state)
	else
		SetName("cane shaft")
		icon_state = "nullrod"
		item_state = "foldcane"

/obj/item/weapon/cane/crutch
	name ="crutch"
	desc = "A long stick with a crosspiece at the top, used to help with walking."
	icon_state = "crutch"
	item_state = "crutch"

/obj/item/weapon/cane/white
	name = "white cane"
	desc = "A white cane. They are commonly used by the blind or visually impaired as a mobility tool or as a courtesy to others."
	icon_state = "whitecane"
	item_state = "whitecane"

/obj/item/weapon/cane/white/attack(mob/M as mob, mob/user as mob)
	if(user.a_intent == I_HELP)
		user.visible_message("<span class='notice'>\The [user] has lightly tapped [M] on the ankle with their white cane!</span>")
		return TRUE
	else
		. = ..()


//Code for Telescopic White Cane writen by Gozulio

/obj/item/weapon/cane/white/collapsible
	name = "telescopic white cane"
	desc = "A telescopic white cane. They are commonly used by the blind or visually impaired as a mobility tool or as a courtesy to others."
	icon_state = "whitecane1in"
	item_state = "whitecanein"
	item_icons = list(
			slot_l_hand_str = 'icons/mob/onmob/items/lefthand.dmi',
			slot_r_hand_str = 'icons/mob/onmob/items/righthand.dmi',
		)
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	force = 3
	var/on = 0

/obj/item/weapon/cane/white/collapsible/attack_self(mob/user as mob)
	on = !on
	if(on)
		user.visible_message("<span class='notice'>\The [user] extends the white cane.</span>",\
				"<span class='warning'>You extend the white cane.</span>",\
				"You hear an ominous click.")
		icon_state = "whitecane1out"
		item_state_slots = list(slot_r_hand_str = "whitecane", slot_l_hand_str = "whitecane")
		w_class = ITEM_SIZE_NORMAL
		force = 5
		attack_verb = list("smacked", "struck", "cracked", "beaten")
	else
		user.visible_message("<span class='notice'>\The [user] collapses the white cane.</span>",\
		"<span class='notice'>You collapse the white cane.</span>",\
		"You hear a click.")
		icon_state = "whitecane1in"
		item_state_slots = list(slot_r_hand_str = "whitecanein", slot_l_hand_str = "whitecanein")
		w_class = ITEM_SIZE_SMALL
		force = 3
		attack_verb = list("hit", "poked", "prodded")

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
	add_fingerprint(user)
	return TRUE