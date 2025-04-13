/obj/item/watertank
	item_icons = URIST_ALL_ONMOBS
	name = "backpack water tank"
	desc = "A S.U.N.S.H.I.N.E. brand watertank backpack with nozzle to water plants."
	icon = 'icons/urist/items/tgitems.dmi'
	icon_state = "waterbackpack"
	item_state = "waterbackpack"
	w_class = 4.0
	slot_flags = SLOT_BACK
	action_button_name = "Toggle Mister"

	var/obj/item/reagent_containers/glass/mister/noz
	var/on = 0
	var/volume = 500

/obj/item/watertank/New()
	..()
	slowdown_per_slot[slot_back] = 1
	create_reagents(volume)
	return

/obj/item/watertank/verb/toggle_mister()
	set name = "Toggle Mister"
	set category = "Object"
	on = !on

	var/mob/living/carbon/human/user = usr
	if(on)
		//Detach the nozzle into the user's hands
		noz = new(src)
		var/list/L = list("left hand" = slot_l_hand,"right hand" = slot_r_hand)
		if(!user.equip_in_one_of_slots(noz, L))
			on = 0
			to_chat(user, "<span class='notice'>You need a free hand to hold the mister!</span>")
	else
		//Remove from their hands and put back "into" the tank
		remove_noz(user)
	return

/obj/item/watertank/equipped(mob/user, slot)
	if (slot != slot_back)
		remove_noz(user)

/obj/item/watertank/proc/remove_noz(mob/user)
	if (noz != null)
		var/mob/living/carbon/human/M = user
		M.u_equip(noz)
	return

/obj/item/reagent_containers/glass/mister/proc/get_nozholder()
	// localized port of the old get() helper; recursive parent search
	while(loc)
		if(istype(loc, /mob))
			return loc
		loc = loc.loc
	return null

/obj/item/watertank/Destroy()
	if(noz)
		var/mob/M = noz.get_nozholder()
		remove_noz(M)
	..()
	return

// This mister item is intended as an extension of the watertank and always attached to it.
// Therefore, it's designed to be "locked" to the player's hands or extended back onto
// the watertank backpack. Allowing it to be placed elsewhere or created without a parent
// watertank object will likely lead to weird behaviour or runtimes.
/obj/item/reagent_containers/glass/mister
	item_icons = URIST_ALL_ONMOBS
	name = "water mister"
	desc = "A mister nozzle attached to a water tank."
	icon = 'icons/urist/items/tgitems.dmi'
	icon_state = "mister"
	item_state = "mister"
	w_class = 4.0
	amount_per_transfer_from_this = 50
	possible_transfer_amounts = list(25,50,100)
	volume = 500
	can_be_placed_into = list(/obj/structure/hygiene/sink)

	var/obj/item/watertank/tank

/obj/item/reagent_containers/glass/mister/New(parent_tank)
	..()
	if (!parent_tank || !istype(parent_tank, /obj/item/watertank))	//To avoid weird issues from admin spawns
		var/mob/living/carbon/human/M = usr
		M.u_equip(src)
		qdel() //test this -GLLOYDTODO
	else
		tank = parent_tank
		reagents = tank.reagents	//This mister is really just a proxy for the tank's reagents
		return

/obj/item/reagent_containers/glass/mister/dropped(mob/user as mob)
	to_chat(user, "<span class='notice'>The mister snaps back onto the watertank!</span>")
	tank.on = 0
	qdel(src)
