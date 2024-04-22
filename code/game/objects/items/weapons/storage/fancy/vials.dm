/obj/item/storage/fancy/vials
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox"
	name = "vial storage box"
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_TINY
	storage_slots = 12
	item_flags = ITEM_FLAG_CAN_HIDE_IN_SHOES

	key_type = /obj/item/reagent_containers/glass/beaker/vial
	startswith = list(/obj/item/reagent_containers/glass/beaker/vial = 12)

/obj/item/storage/fancy/vials/on_update_icon()
	icon_state = "[initial(icon_state)][floor(key_type_count / 2)]"
