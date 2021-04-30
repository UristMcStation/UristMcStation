//random items

/obj/item/weapon/storage/box/radiokeys
	name = "box of radio encryption keys"
	desc = "A box full of assorted encryption keys."
	startswith = list(/obj/item/device/encryptionkey/nerva/sec = 3,
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

/obj/item/device/radio/headset/heads/firstofficer
	name = "first officer's headset"
	desc = "The headset of the ICS Nerva's first officer."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/nerva/cap

/obj/item/device/radio/headset/heads/nerva_cap
	name = "captain's headset"
	desc = "The headset of the ICS Nerva's captain."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/nerva/cap

/obj/item/device/radio/headset/heads/nerva_cos
	name = "chief of security's headset"
	desc = "The headset of the man who protects your worthless lives."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/nerva/cos

/obj/item/device/radio/headset/heads/nerva_qm
	name = "quartermaster's headset"
	desc = "The headset of the ICS Nerva's quartermaster."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/nerva/qm

/obj/item/device/radio/headset/nerva_sec
	name = "security radio headset"
	desc = "This is used by your elite security force."
	icon_state = "sec_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/nerva/sec

/obj/item/device/radio/headset/heads/nerva_senior
	name = "senior scientist headset"
	desc = "The headset of the Nerva's Senior Scientist."
	icon_state = "nt_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/nerva/senior

//encryption keys

/obj/item/device/encryptionkey/nerva/nt
	name = "nanotrasen radio encryption key"
	icon_state = "nt_cypherkey"
	channels = list("Science" = 1)

/obj/item/device/encryptionkey/nerva/so
	name = "second officer's encryption key"
	icon_state = "hop_cypherkey"
	channels = list("Command" = 1, "Service" = 1, "Supply" = 1, "Security" = 0, "Combat" = 0)

/obj/item/device/encryptionkey/nerva/qm
	name = "quartermaster's encryption key"
	icon_state = "hop_cypherkey"
	channels = list("Supply" = 1, "Service" = 1, "Command" = 1)

/obj/item/device/encryptionkey/nerva/cap
	name = "captain's encryption key"
	icon_state = "cap_cypherkey"
	channels = list("Command" = 1, "Security" = 1, "Engineering" = 0, "Science" = 0, "Medical" = 0, "Supply" = 0, "Service" = 0, "Combat" = 0)

/obj/item/device/encryptionkey/nerva/cos
	name = "chief of security's encryption key"
	icon_state = "hos_cypherkey"
	channels = list("Security" = 1, "Command" = 1, "Combat" = 0)

/obj/item/device/encryptionkey/nerva/sec
	name = "security radio encryption key"
	icon_state = "sec_cypherkey"
	channels = list("Security" = 1, "Combat" = 0)

/obj/item/device/encryptionkey/nerva/senior
	name = "senior nanotrasen encryption key"
	icon_state = "rd_cypherkey"
	channels = list("Command" = 1, "Science" = 1)

/obj/item/weapon/stamp/nt
	name = "\improper NanoTrasen rubber stamp"
	icon_state = "stamp-intaff"

/obj/item/weapon/stamp/seniornt
	name = "\improper Senior Researcher rubber stamp"
	icon_state = "stamp-intaff"

//paint

/obj/effect/paint/hull
	color = COLOR_HULL

/obj/effect/paint/expeditionary
	color = "#68099e"

//station account card

/obj/item/weapon/card/id/station_account
	name = "ICS Nerva account card"
	desc = "A banking card with access to the ICS Nerva's main account."
	item_state = "silver_id"
	detail_color = COLOR_COMMAND_BLUE

/*
/obj/item/weapon/card/station_account/New()
	..()
	associated_account_number = station_account.account_number
*/

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
	startswith = list(/obj/item/weapon/card/id/station_account)
	var/linked = FALSE //fucking card setup doesn't work with New() or Initialize(), so we're getting hacky up in here.

/obj/item/weapon/storage/lockbox/station_account/attack_hand(mob/living/user as mob)
	if(!linked)
		for(var/obj/item/weapon/card/id/station_account/C in src.contents)
			C.associated_account_number = station_account.account_number
			linked = TRUE

	..()

/obj/item/weapon/storage/lockbox/station_account/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(!linked)
		for(var/obj/item/weapon/card/id/station_account/C in src.contents)
			C.associated_account_number = station_account.account_number
			linked = TRUE

	..()

/obj/item/weapon/storage/lockbox/station_account/emag_act()
	if(!linked)
		for(var/obj/item/weapon/card/id/station_account/C in src.contents)
			C.associated_account_number = station_account.account_number
			linked = TRUE

	..()

//ammo boxes

/obj/item/weapon/storage/box/nervaammo
	name = "box of combat ammunition"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death. \
	Contains everything you need to kill hostiles boarding the ICS Nerva."
	startswith = list(
		/obj/item/ammo_magazine/c44 = 1,
		/obj/item/ammo_magazine/hi2521smg9mm = 2
		)

/obj/item/weapon/storage/box/boardingammo
	name = "box of HI-2521-P pistol magazines"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death. \
	Contains everything you need to kill hostiles boarding the ICS Nerva."
	startswith = list(/obj/item/ammo_magazine/hi2521pistol9mm = 2)
