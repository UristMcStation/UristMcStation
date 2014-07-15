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

//Department signs, icons based off the ones from Para station

/obj/structure/sign/deptsigns
	name = "departmental sign"
	icon = 'icons/urist/structures&machinery/structures.dmi'

/obj/structure/sign/deptsigns/sec
	desc = "A sign leading to Security."
	icon_state = "sec"

/obj/structure/sign/deptsigns/sci
	desc = "A sign leading to Research."
	icon_state = "sci"

/obj/structure/sign/deptsigns/eng
	desc = "A sign leading to Engineering."
	icon_state = "eng"

/obj/structure/sign/deptsigns/med
	desc = "A sign leading to Medbay."
	icon_state = "med"

/obj/structure/sign/deptsigns/esc
	desc = "A sign leading to Escape."
	icon_state = "esc"

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

//
//                   ???
//

/obj/structure/largecrate/schrodinger
	name = "Schrodinger's Crate"
	desc = "What happens if you open it?"

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/crowbar))
			var/mob/living/simple_animal/cat/Cat1 = new(loc)
			Cat1.apply_damage(250)//,TOX)
			Cat1.name = "Schrodinger's Cat"
			Cat1.desc = "It seems it's been dead for a while."

			var/mob/living/simple_animal/cat/Cat2 = new(loc)
			Cat2.name = "Schrodinger's Cat"
			Cat2.desc = "It was alive the whole time!"
			sleep(2)
			if(prob(50))
				del Cat1
			else
				del Cat2
		..()

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