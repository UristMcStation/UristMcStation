 /*										*****New space to put all UristMcStation Structures*****

Please keep it tidy, by which I mean put comments describing the item before the entry.I may or may not move couches and flora here. -Glloyd*/


//THA MAP

/obj/structure/sign/uristmap
	name = "station map"
	icon = 'icons/urist/structures&machinery/structures.dmi'
	desc = "A framed picture of the station."

/obj/structure/sign/uristmap/left
	icon_state = "umap_left"

/obj/structure/sign/uristmap/right
	icon_state = "umap_right"

//Emergency suits locker, moved from Uristclothes.dm

/obj/structure/closet/emsuits //Tossing the closet here, because why the fuck not.
	name = "emergency suit closet"
	desc = "It's a closet for storing emergency equipment and suits. A small  sign on the bottom reads 'use only in extreme emergencies'"
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "ecloset"
	icon_closed = "ecloset"
	icon_opened = "eclosetopen"

/obj/structure/closet/emsuits/New()
	..()

	new /obj/item/clothing/head/emergencyhood(src)
	new /obj/item/clothing/suit/emergencysuit(src)
	new /obj/item/weapon/tank/emergency_oxygen(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/weapon/storage/toolbox/emergency(src)
	new /obj/item/weapon/tank/emergency_oxygen(src)

//Armored sec biosuit locker, moved from Uristclothes.dm

/obj/structure/closet/secure_closet/armoredbiosuit
	name = "armoured bio suit locker"
	req_access = list(access_armory)
	icon_state = "wardensecure1"
	icon_closed = "wardensecure"
	icon_locked = "wardensecure1"
	icon_opened = "wardensecureopen"
	icon_broken = "wardensecurebroken"
	icon_off = "wardensecureoff"

/obj/structure/closet/secure_closet/armoredbiosuit/New()
	..()

	new /obj/item/clothing/head/bio_hood/asec(src)
	new /obj/item/clothing/suit/bio_suit/asec(src)

//Psychologists locker

/obj/structure/closet/secure_closet/psychologist
	name = "Psychologist's Locker"
	req_access = list(access_psychiatrist)
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"

//signnnnnnnnnssssssssssss

/obj/structure/sign/urist
	icon = 'icons/urist/structures&machinery/structures.dmi'

//Department signs, icons based off the ones from Para station

/obj/structure/sign/urist/deptsigns
	name = "departmental sign"

/obj/structure/sign/urist/deptsigns/sec
	desc = "A sign leading to Security."
	icon_state = "sec"

/obj/structure/sign/urist/deptsigns/sci
	desc = "A sign leading to Research."
	icon_state = "sci"

/obj/structure/sign/urist/deptsigns/eng
	desc = "A sign leading to Engineering."
	icon_state = "eng"

/obj/structure/sign/urist/deptsigns/med
	desc = "A sign leading to Medbay."
	icon_state = "med"

/obj/structure/sign/urist/deptsigns/esc
	desc = "A sign leading to Escape."
	icon_state = "esc"

//nt4lyfe

/obj/structure/sign/urist/nt
	name = "Nanotrasen Sign"
	desc = "A large sign proudly displaying the logo of Nanotrasen."
	icon_state = "ntsign"

//ads

/obj/structure/sign/urist/ad/sign1
	icon_state = "sign1"
	name = "Cosmetic Surgery advertisement"
	desc = "An advertisment for Nanotrasen Cosmetic Surgery. Their catchy jingle is still stuck in your head: 'Hate yourself? So do we! Don't choose a bullet, choose Nanotrasen surgery!'"
/obj/structure/sign/urist/ad/sign2
	icon_state = "sign2"
	name = "Luna advertisement"
	desc = "An advertisement for Nanotrasen's offices on Luna. The picture shows an image of Luna before it was terraformed."

/obj/structure/sign/urist/ad/sign3
	icon_state = "sign3"
	name = "5555 Lotto advertisement"
	desc = "An advertisement for the Nanotrasen run 5555 Lotto. You suddenly feel an impulse to buy a ticket next time you're back here."

/obj/structure/sign/urist/ad/sign4
	name = "Space Beer advertisement"
	desc = "An advertisement for Space Beer. The text reads 'Best beer this side of Tau Ceti!'"
	icon_state = "sign4"

/obj/structure/sign/urist/ad/sign5
	name = "Cheesy Honkers advertisement"
	desc = "An advertisement for Cheesy Honkers. The text reads 'Cheesy Honkers! Guaranteed not to give you a miscarriage!'"
	icon_state = "sign5"

//transitmap

/obj/structure/sign/urist/transitmap
	name = "transit map"
	desc = "A handy map giving directions through Central Command's extensive transit network."
	icon_state = "transitmap"

//hacky, but I don't give a fuck. nicer beds

/obj/structure/stool/bed/nice
	name = "bed"
	icon = 'icons/urist/structures&machinery/structures.dmi'
	desc = "This is used to lie in, sleep in or strap on. Looks comfortable."
	icon_state = "bed"

//poker tables

/obj/structure/table/poker //No specialties, Just a mapping object.
	name = "gambling table"
	desc = "A seedy table for seedy dealings in seedy places."
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "pokertable_table"
	parts = /obj/item/weapon/table_parts/poker
	health = 50

/obj/item/weapon/table_parts/poker
	name = "poker table parts"
	desc = "Keep away from fire, and keep near seedy dealers."
	icon = 'icons/urist/items/tgitems.dmi'
	icon_state = "poker_tableparts"
	flags = null

/obj/item/weapon/table_parts/wood/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/stack/tile/grass))
		var/obj/item/stack/tile/grass/R = I
		var/obj/item/weapon/table_parts/poker/H = new /obj/item/weapon/table_parts/poker
		R.use(1)

		user.before_take_item(src)

		user.put_in_hands(H)
		user << "<span class='notice'>You strap a sheet of metal to the hazard vest. Now to tighten it in.</span>"

		del(src)
		del(I)

//captain's lockers. got sick of the lag when rightclicking.

/obj/structure/closet/secure_closet/captainsclothes
	name = "Captain's Clothing Locker"
	req_access = list(access_captain)
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"

	New()
		..()
		sleep(2)
		new /obj/item/weapon/storage/backpack/duffel/duffel_cap(src)
		new /obj/item/weapon/storage/backpack/captain(src)
		new /obj/item/weapon/storage/backpack/satchel_cap(src)
		new /obj/item/clothing/suit/captunic(src)
		new /obj/item/clothing/suit/captunic/capjacket(src)
		new /obj/item/clothing/under/rank/captain(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/clothing/gloves/captain(src)
		new /obj/item/clothing/under/dress/dress_cap(src)
		new /obj/item/clothing/suit/coat/captain(src)
		new /obj/item/clothing/head/helmet/cap(src)
		new /obj/item/clothing/under/urist/rank/capdressalt(src)
		return

/obj/structure/closet/secure_closet/captainsequipment
	name = "Captain's Equipment Locker"
	req_access = list(access_captain)
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"

	New()
		..()
		sleep(2)
		new /obj/item/clothing/suit/armor/vest(src)
		new /obj/item/weapon/cartridge/captain(src)
		new /obj/item/clothing/head/helmet/swat(src)
		new /obj/item/device/radio/headset/heads/captain(src)
		new /obj/item/weapon/gun/energy/gun(src)
		new /obj/item/clothing/suit/armor/captain(src)
		new /obj/item/weapon/melee/telebaton(src)
		new /obj/item/clothing/suit/armor/vest/capcarapace(src)
		new /obj/item/clothing/head/helmet/cap(src)
		new /obj/item/clothing/head/helmet/space/capspace(src)
		new /obj/item/weapon/tank/jetpack/oxygen(src)
		new /obj/item/clothing/mask/gas(src)
		return

//blooshield locker

/obj/structure/closet/secure_closet/blueshield
	name = "Blueshield Locker"
	icon = 'icons/urist/structures&machinery/structures.dmi'
	req_access = list(access_blueshield)
	icon_state = "bssecure1"
	icon_closed = "bssecure"
	icon_locked = "bssecure1"
	icon_opened = "bssecureopen"
	icon_broken = "bssecurebroken"
	icon_off = "bssecureoff"

	New()
		..()
		sleep(2)
		new	/obj/item/weapon/storage/firstaid/adv(src)
		new /obj/item/weapon/gun/projectile/detective/fluff/callum_leamas(src)
		new /obj/item/weapon/storage/belt/security(src)
		new /obj/item/weapon/grenade/flashbang(src)
		new /obj/item/weapon/melee/baton(src)
		new /obj/item/weapon/gun/energy/taser(src)
		new /obj/item/clothing/tie/storage/black_vest(src)
		new /obj/item/clothing/glasses/sunglasses(src)
		new /obj/item/clothing/under/rank/centcom_officer(src)
		new /obj/item/device/flash(src)
		new /obj/item/weapon/handcuffs(src)
		return

//shuttle chairs

/obj/structure/stool/bed/chair/urist
	icon = 'icons/urist/structures&machinery/structures.dmi'

/obj/structure/stool/bed/chair/urist/shuttle
	name = "shuttle chair"
	desc = "A specially padded chair made for shuttles."
	icon_state = "shuttlechair"
	var/image/armrest = null

/obj/structure/stool/bed/chair/urist/shuttle/New()
	armrest = image('icons/urist/structures&machinery/structures.dmi', "shuttlechair_armrest")
	armrest.layer = MOB_LAYER + 0.1

	return ..()

/obj/structure/stool/bed/chair/urist/shuttle/afterbuckle()
	if(buckled_mob)
		overlays += armrest
	else
		overlays -= armrest

//random benches

/obj/structure/stool/bed/chair/urist/bench
	name = "bench"
	desc = "A grey bench. No matter how hard you try, you can't seem to get comfortable on it."

/obj/structure/stool/bed/chair/urist/bench/bench1/left
	icon_state = "benchleft"

/obj/structure/stool/bed/chair/urist/bench/bench1/right
	icon_state = "benchright"

/obj/structure/stool/bed/chair/urist/bench/bench1/mid
	icon_state = "benchmid"

/obj/structure/stool/bed/chair/urist/bench/bench2
	desc = "A blue bench found on the Central Command transit system. You'd think it would be padded, but your ass says otherwise."

/obj/structure/stool/bed/chair/urist/bench/bench2/top
	icon_state = "bench2top"

/obj/structure/stool/bed/chair/urist/bench/bench2/mid
	icon_state = "bench2mid"

/obj/structure/stool/bed/chair/urist/bench/bench2/bot
	icon_state = "bench2bot"

//stools

/obj/structure/stool/bar
	name = "bar stool"
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "barstool"
	style = 1 //0 is regular, 1 is bar, 2 is wood

/obj/structure/stool/wood
	name = "wood stool"
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "woodstool"
	style = 2 //0 is regular, 1 is bar, 2 is wood

/obj/item/weapon/stool/bar
	name = "bar stool"
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "barstool"
	item_state = "stool"
	style = 1 //0 is regular, 1 is bar, 2 is wood

/obj/item/weapon/stool/wood
	urist_only = 1
	name = "wood stool"
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "woodstool"
	item_state = "stool"
	style = 2 //0 is regular, 1 is bar, 2 is wood