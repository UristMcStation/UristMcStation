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