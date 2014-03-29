 /*										*****New space to put all UristMcStation Structures*****

Please keep it tidy, by which I mean put comments describing the item before the entry.I may or may not move couches and flora here. -Glloyd*/


//THA MAP

/obj/structure/sign/uristmap
	name = "station map"
	icon = 'icons/urist/uristicons.dmi'
	desc = "A framed picture of the station."

/obj/structure/sign/uristmap/left
	icon_state = "umap_left"

/obj/structure/sign/uristmap/right
	icon_state = "umap_right"

//Emergency suits locker, moved from Uristclothes.dm

/obj/structure/closet/emsuits //Tossing the closet here, because why the fuck not.
	name = "emergency suit closet"
	desc = "It's a closet for storing emergency equipment and suits. A small  sign on the bottom reads 'use only in extreme emergencies'"
	icon = 'icons/urist/uristicons.dmi'
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
	icon = 'icons/urist/uristicons.dmi'

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

