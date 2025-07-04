/*
	Represents flexible bags that expand based on the size of their contents.
*/
/obj/item/storage/bag
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	slot_flags = SLOT_BELT

/obj/item/storage/bag/handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
	. = ..()
	if(.) update_w_class()

/obj/item/storage/bag/remove_from_storage(obj/item/W as obj, atom/new_location)
	. = ..()
	if(.) update_w_class()

/obj/item/storage/bag/can_be_inserted(obj/item/W, mob/user, stop_messages = 0)
	var/mob/living/carbon/human/H = ishuman(user) ? user : null // if we're human, then we need to check if bag in a pocket
	if(istype(src.loc, /obj/item/storage) || H?.is_in_pocket(src))
		if(!stop_messages)
			to_chat(user, SPAN_NOTICE("Take \the [src] out of [isobj(loc) ? "\the [src.loc]" : "the pocket"] first."))
		return 0 //causes problems if the bag expands and becomes larger than src.loc can hold, so disallow it
	. = ..()

/obj/item/storage/bag/proc/update_w_class()
	w_class = initial(w_class)
	for(var/obj/item/I in contents)
		w_class = max(w_class, I.w_class)

	var/cur_storage_space = storage_space_used()
	while(BASE_STORAGE_CAPACITY(w_class) < cur_storage_space)
		w_class++

/obj/item/storage/bag/get_storage_cost()
	var/used_ratio = storage_space_used()/max_storage_space
	return max(BASE_STORAGE_COST(w_class), round(used_ratio*BASE_STORAGE_COST(max_w_class), 1))

// -----------------------------
//          Trash bag
// -----------------------------
/obj/item/storage/bag/trash
	name = "trash bag"
	desc = "It's the heavy-duty black polymer kind. Time to take out the trash!"
	icon = 'icons/obj/bags.dmi'
	icon_state = "trashbag"
	item_state = "trashbag"

	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_HUGE //can fit a backpack inside a trash bag, seems right
	max_storage_space = DEFAULT_BACKPACK_STORAGE

/obj/item/storage/bag/trash/update_w_class()
	..()
	update_icon()

/obj/item/storage/bag/trash/on_update_icon()
	switch(w_class)
		if(2) icon_state = "[initial(icon_state)]"
		if(3) icon_state = "[initial(icon_state)]1"
		if(4) icon_state = "[initial(icon_state)]2"
		if(5 to INFINITY) icon_state = "[initial(icon_state)]3"

/obj/item/storage/bag/trash/bluespace
	name = "trash bag of holding"
	max_storage_space = 56
	desc = "The latest and greatest in custodial convenience, a trashbag that is capable of holding vast quantities of garbage."
	icon_state = "bluetrashbag"

/obj/item/storage/bag/trash/bluespace/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W, /obj/item/storage/backpack/holding) || istype(W, /obj/item/storage/bag/trash/bluespace))
		to_chat(user, SPAN_WARNING("The Bluespace interfaces of the two devices conflict and malfunction."))
		qdel(W)
		return TRUE
	return ..()

// -----------------------------
//        Plastic Bag
// -----------------------------

/obj/item/storage/bag/plasticbag
	name = "plastic bag"
	desc = "It's a very flimsy, very noisy alternative to a bag."
	icon = 'icons/obj/trash.dmi'
	icon_state = "plasticbag"
	item_state = "plasticbag"

	w_class = ITEM_SIZE_TINY
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_BOX_STORAGE

// -----------------------------
//           Cash Bag
// -----------------------------

/obj/item/storage/bag/cash
	name = "cash bag"
	icon = 'icons/obj/bags.dmi'
	icon_state = "cashbag"
	desc = "A bag for carrying lots of cash. It's got a big dollar sign printed on the front."
	max_storage_space = 100
	max_w_class = ITEM_SIZE_HUGE
	w_class = ITEM_SIZE_SMALL
	contents_allowed = list(
		/obj/item/material/coin,
		/obj/item/spacecash,
		/obj/item/stack/material/gold,
		/obj/item/stack/material/silver
	)
