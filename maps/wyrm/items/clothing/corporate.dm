/obj/item/clothing/suit/storage/toggle/labcoat/corp
	icon = 'maps/wyrm/icons/corporate.dmi'
	item_icons = URIST_ALL_ONMOBS

/obj/item/clothing/suit/storage/toggle/labcoat/corp/wardt
	name = "\improper Ward-Takahashi labcoat"
	desc = "A labcoat decorated with the logo and scheme of Ward-Takahashi GMB."
	icon_state = "wardt_lab"
	accessories = list(/obj/item/clothing/accessory/armband/wardt)

/obj/item/clothing/suit/storage/toggle/labcoat/corp/veymed
	name = "\improper Vey-Med labcoat"
	desc = "A sterile white labcoat with Vey-Med's star on its back"
	icon_state = "veymed_lab"
	accessories = list(/obj/item/clothing/accessory/armband/veymed)

/obj/item/clothing/suit/storage/toggle/labcoat/corp/veymed/head
	name = "project director's labcoat"
	desc = "A sterile white labcoat with gilded seams and cufflinks."
	icon_state = "veymed_head_lab"

/obj/item/clothing/accessory/armband/veymed
	name = "Vey-Med armband"
	desc = "An armband, sometimes worn by employees of Vey-Med. This one is gold and green."
	icon = 'icons/urist/items/clothes/ties.dmi'
	icon_state = "veymed"
	accessory_icons = list(slot_w_uniform_str = 'icons/uristmob/ties.dmi', slot_wear_suit_str = 'icons/uristmob/ties.dmi')

/obj/item/clothing/accessory/armband/wardt
	name = "Ward-Takahashi armband"
	desc = "An armband, sometimes worn by employees of Ward-Takahashi. This one is white and orange."
	icon = 'icons/urist/items/clothes/ties.dmi'
	icon_state = "wardt"
	accessory_icons = list(slot_w_uniform_str = 'icons/uristmob/ties.dmi', slot_wear_suit_str = 'icons/uristmob/ties.dmi')
