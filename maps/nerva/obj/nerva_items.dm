//random items

/obj/item/storage/box/radiokeys
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

/obj/item/device/radio/headset/nervananotrasen/alt
	name = "nanotrasen bowman headset"
	desc = "A larger headset for corporate drones."
	icon_state = "nt_headset_alt"
	item_state = "nt_headset_alt"
	ks1type = /obj/item/device/encryptionkey/nerva/nt

/obj/item/device/radio/headset/heads/secondofficer
	name = "second officer's headset"
	desc = "The headset of the ICS Nerva's second officer."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/nerva/so

/obj/item/device/radio/headset/heads/secondofficer/alt
	name = "second officer's bowman headset"
	desc = "The more comfortable headset of the ICS Nerva's second officer."
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"
	ks1type = /obj/item/device/encryptionkey/nerva/so

/obj/item/device/radio/headset/heads/firstofficer
	name = "first officer's headset"
	desc = "The headset of the ICS Nerva's first officer."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/nerva/cap

/obj/item/device/radio/headset/heads/firstofficer/alt
	name = "first officer's bowman headset"
	desc = "The thicker headset of the ICS Nerva's first officer."
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"
	ks1type = /obj/item/device/encryptionkey/nerva/cap

/obj/item/device/radio/headset/heads/nerva_cap
	name = "captain's headset"
	desc = "The headset of the ICS Nerva's captain."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/nerva/cap

/obj/item/device/radio/headset/heads/nerva_cap/alt
	name = "captain's bowman headset"
	desc = "The fortified headset of the ICS Nerva's captain."
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"
	ks1type = /obj/item/device/encryptionkey/nerva/cap

/obj/item/device/radio/headset/heads/nerva_cos
	name = "chief of security's headset"
	desc = "The headset of the man who protects your worthless lives."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/nerva/cos

/obj/item/device/radio/headset/heads/nerva_cos/alt
	name = "chief of security's bowman headset"
	desc = "The bigger headset of the man who protects your worthless lives."
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"
	ks1type = /obj/item/device/encryptionkey/nerva/cos

/obj/item/device/radio/headset/heads/nerva_qm
	name = "quartermaster's headset"
	desc = "The headset of the ICS Nerva's quartermaster."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/nerva/qm

/obj/item/device/radio/headset/heads/nerva_qm/alt
	name = "quartermaster's bowman headset"
	desc = "The more robust headset of the ICS Nerva's quartermaster."
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"
	ks1type = /obj/item/device/encryptionkey/nerva/qm

/obj/item/device/radio/headset/nerva_sec
	name = "security radio headset"
	desc = "This is used by your elite security force."
	icon_state = "sec_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/nerva/sec

/obj/item/device/radio/headset/nerva_sec/alt
	name = "security bowman radio headset"
	desc = "This is used by your elite security force to look more tactical."
	icon_state = "sec_headset_alt"
	item_state = "sec_headset_alt"
	ks1type = /obj/item/device/encryptionkey/nerva/sec

/obj/item/device/radio/headset/heads/nerva_senior
	name = "senior scientist headset"
	desc = "The headset of the ICS Nerva's Senior Scientist."
	icon_state = "nt_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/nerva/senior

/obj/item/device/radio/headset/heads/nerva_senior/alt
	name = "senior scientist bowman headset"
	desc = "The bigger headset of the ICS Nerva's Senior Scientist."
	icon_state = "nt_headset_alt"
	item_state = "nt_headset_alt"
	ks1type = /obj/item/device/encryptionkey/nerva/senior

/obj/item/device/radio/headset/nerva_guard
	name = "bodyguard's radio headset"
	desc = "This is used by the captain's escort."
	icon_state = "com_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/nerva/guard

/obj/item/device/radio/headset/nerva_guard/alt
	name = "bodyguard's bowman radio headset"
	desc = "This is used by the captain's escort to look more operator."
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"
	ks1type = /obj/item/device/encryptionkey/nerva/guard

//encryption keys

/obj/item/device/encryptionkey/nerva/nt
	name = "nanotrasen radio encryption key"
	icon_state = "nt_cypherkey"
	channels = list("Science" = 1)

/obj/item/device/encryptionkey/nerva/so
	name = "second officer's encryption key"
	icon_state = "hop_cypherkey"
	channels = list("Command" = 1, "Service" = 1, "Supply" = 1, "Security" = 0, "Combat" = 0, "Hailing" = 1)

/obj/item/device/encryptionkey/nerva/qm
	name = "quartermaster's encryption key"
	icon_state = "hop_cypherkey"
	channels = list("Supply" = 1, "Service" = 1, "Command" = 1, "Hailing" = 1)

/obj/item/device/encryptionkey/nerva/cap
	name = "captain's encryption key"
	icon_state = "cap_cypherkey"
	channels = list("Command" = 1, "Security" = 1, "Engineering" = 0, "Science" = 0, "Medical" = 0, "Supply" = 0, "Service" = 0, "Combat" = 0, "Hailing" = 1)

/obj/item/device/encryptionkey/nerva/cos
	name = "chief of security's encryption key"
	icon_state = "hos_cypherkey"
	channels = list("Security" = 1, "Command" = 1, "Combat" = 0, "Hailing" = 1)

/obj/item/device/encryptionkey/nerva/sec
	name = "security radio encryption key"
	icon_state = "sec_cypherkey"
	channels = list("Security" = 1, "Combat" = 0)

/obj/item/device/encryptionkey/nerva/senior
	name = "senior nanotrasen encryption key"
	icon_state = "rd_cypherkey"
	channels = list("Command" = 1, "Science" = 1)

/obj/item/device/encryptionkey/nerva/guard
	name = "bodyguard radio encryption key"
	icon_state = "com_cypherkey"
	channels = list("Command" = 1, "Security" = 1)

//stamps

/obj/item/stamp/nt
	name = "\improper NanoTrasen rubber stamp"
	icon_state = "stamp-rd"

/obj/item/stamp/seniornt
	name = "\improper Senior Researcher's rubber stamp"
	icon_state = "stamp-rd"

/obj/item/stamp/fo
	name = "\improper First Officer's rubber stamp"
	icon_state = "stamp-xo"

/obj/item/stamp/so
	name = "\improper Second Officer's rubber stamp"
	icon_state = "stamp-xo"

/obj/item/stamp/cos
	name = "\improper Chief of Security's rubber stamp"
	icon_state = "stamp-cos"

//paint

/obj/effect/paint/hull
	color = COLOR_HULL

/obj/effect/paint/expeditionary
	color = "#68099e"

//station account card

/obj/item/card/id/station_account
	name = "ICS Nerva account card"
	desc = "A banking card with access to the ICS Nerva's main account."
	item_state = "silver_id"
	detail_color = COLOR_COMMAND_BLUE

/*
/obj/item/card/station_account/New()
	..()
	associated_account_number = station_account.account_number
*/

/obj/item/storage/lockbox/station_account
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
	startswith = list(/obj/item/card/id/station_account)
	var/linked = FALSE //fucking card setup doesn't work with New() or Initialize(), so we're getting hacky up in here.

/obj/item/storage/lockbox/station_account/open(mob/user)
	if(!linked)
		linked = TRUE
		for(var/obj/item/card/id/station_account/C in contents)
			C.associated_account_number = station_account.account_number
	..()

//Nanotrasen account card and accompanying box for chief egghead
/obj/item/card/id/station_account/nanotrasen
	name = "Nanotrasen account card"
	desc = "A company banking card with access to the local Nanotrasen budget, for job-related expenses."
	item_state = "silver_id"
	detail_color = COLOR_INDIGO

/obj/item/storage/lockbox/nanotrasen_account
	name = "Nanotrasen account card lockbox"
	desc = "A locked box used to store Nanotrasen's company card."
	icon = 'icons/urist/items/tgitems.dmi'
	icon_state = "medalbox+l"
	item_state = "syringe_kit"
	w_class = 3
	max_w_class = 2
	storage_slots = 7
	icon_locked = "medalbox+l"
	icon_closed = "medalbox"
	icon_broken = "medalbox+b"
	var/linked = FALSE
	req_access = list(access_seniornt)
	startswith = list(/obj/item/card/id/station_account/nanotrasen)

/obj/item/storage/lockbox/nanotrasen_account/open(mob/user)
	if(!linked)
		linked = TRUE
		for(var/obj/item/card/id/station_account/nanotrasen/N in contents)
			N.associated_account_number = nanotrasen_account.account_number
	..()

//ammo boxes

/obj/item/storage/box/nervaammo
	name = "box of combat ammunition"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death. \
	Contains everything you need to kill hostiles boarding the ICS Nerva."
	startswith = list(
		/obj/item/ammo_magazine/speedloader = 1,
		/obj/item/ammo_magazine/hi2521smg9mm = 2
		)

/obj/item/storage/box/boardingammo
	name = "box of HI-2521-P pistol magazines"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death. \
	Contains everything you need to kill hostiles boarding the ICS Nerva."
	startswith = list(/obj/item/ammo_magazine/hi2521pistol9mm = 2)
