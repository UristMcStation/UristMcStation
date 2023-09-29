/obj/item/storage/toolbox/repairs
	name = "electronics toolbox"
	desc = "A box full of boxes, with electrical machinery parts and tools needed to get them where they're needed."
	icon = 'maps/wyrm/icons/toolbox.dmi'
	icon_state = "yellow_striped"
	item_state = "toolbox_yellow"
	max_storage_space = 25
	startswith = list(
		/obj/item/stack/cable_coil,
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/crowbar,
		/obj/item/wirecutters,
		/obj/item/storage/box/parts_pack/manipulator,
		/obj/item/storage/box/parts_pack/laser,
		/obj/item/storage/box/parts_pack/capacitor,
		/obj/item/storage/box/parts_pack/keyboard,
		/obj/item/storage/box/parts
	)

// machinery stock parts
/obj/item/storage/box/parts
	name = "assorted parts pack"
	icon = 'icons/obj/part_pack.dmi'
	icon_state = "big"
	icon_state = "part"
	w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_BOX_STORAGE
	startswith = list(
		/obj/item/stock_parts/power/apc/buildable = 3,
		/obj/item/stock_parts/console_screen = 2,
		/obj/item/stock_parts/matter_bin = 2
	)

/obj/item/storage/box/parts_pack
	name = "parts pack"
	desc = "A densely-stuffed box containing some small eletrical parts."
	icon = 'icons/obj/part_pack.dmi'
	icon_state = "part"
	w_class = ITEM_SIZE_SMALL

/obj/item/storage/box/parts_pack/Initialize()
	if(length(startswith))
		var/obj/item/I = startswith[1]
		SetName("[initial(I.name)] pack")
	return ..()

/obj/item/storage/box/parts_pack/manipulator
	icon_state = "mainpulator"
	startswith = list(/obj/item/stock_parts/manipulator = 7)

/obj/item/storage/box/parts_pack/laser
	icon_state = "laser"
	startswith = list(/obj/item/stock_parts/micro_laser = 7)

/obj/item/storage/box/parts_pack/capacitor
	icon_state = "capacitor"
	startswith = list(/obj/item/stock_parts/capacitor = 7)

/obj/item/storage/box/parts_pack/keyboard
	icon_state = "keyboard"
	startswith = list(/obj/item/stock_parts/keyboard = 7)
