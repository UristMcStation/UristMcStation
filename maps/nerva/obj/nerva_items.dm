//random items

/obj/item/weapon/storage/box/radiokeys
	name = "box of radio encryption keys"
	desc = "A box full of assorted encryption keys."
	startswith = list(/obj/item/device/encryptionkey/headset_sec = 3,
					  /obj/item/device/encryptionkey/headset_med = 3,
					  /obj/item/device/encryptionkey/headset_cargo = 3)

//headsets

/obj/item/device/radio/headset/nervananotrasen
	name = "nanotrasen headset"
	desc = "A headset for corporate drones."
	icon_state = "nt_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/nerva/nt

/obj/item/device/radio/headset/heads/secondofficer
	name = "second officer's headset"
	desc = "The headset of the ICS Nerva's second officer."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/nerva/so

/obj/item/device/radio/headset/heads/nerva_qm
	name = "quatermaster's headset"
	desc = "The headset of the ICS Nerva's quatermaster."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/nerva/qm



//encryption keys

/obj/item/device/encryptionkey/nerva/nt
	name = "nanotrasen radio encryption key"
	icon_state = "nt_cypherkey"
	channels = list("Science" = 1)

/obj/item/device/encryptionkey/nerva/so
	name = "second officer's encryption key"
	icon_state = "hop_cypherkey"
	channels = list("Service" = 1, "Command" = 1, "Security" = 1)

/obj/item/device/encryptionkey/nerva/qm
	name = "quatermaster's encryption key"
	icon_state = "hop_cypherkey"
	channels = list("Supply" = 1, "Service" = 1, "Command" = 1)

/obj/item/weapon/stamp/nt
	name = "\improper NanoTrasen rubber stamp"
	icon_state = "stamp-intaff"

//paint

/obj/effect/paint/hull
	color = COLOR_HULL

/obj/effect/paint/expeditionary
	color = "#68099e"

//station account card

/obj/item/weapon/card/station_account
	name = "ICS Nerva account card"
	desc = "A banking card with access to the ICS Nerva's main account."
	icon_state = "data"

/obj/item/weapon/card/station_account/Initialize()
	..()
	associated_account_number = station_account.account_number


/obj/item/weapon/storage/lockbox/station_account
	name = "station account card lockbox"
	desc = "A locked box used to store the ICS Nerva's account card."
	icon = 'icons/urist/items/tgitems.dmi'
	icon_state = "medalbox+l"
	item_state = "syringe_kit"
	w_class = 3
	max_w_class = 2
	storage_slots = 7
	req_access = list(access_captain)
	icon_locked = "medalbox+l"
	icon_closed = "medalbox"
	icon_broken = "medalbox+b"
	startswith = list(/obj/item/weapon/card/station_account)