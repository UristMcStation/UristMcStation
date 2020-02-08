// Prank Items for the Clown.

// Fake Captain's Spare ID - Has no actual access.
/obj/item/weapon/card/id/captains_spare_fake
	name = "captain's spare ID"
	desc = "The spare ID of the High Lord himself. It appears to be made of... rubber?"
	icon_state = "gold"
	item_state = "gold_id"
	registered_name = "Captain?"
	assignment = "Captain?"

//Fake Replica Nuclear Authentication Disk, can't arm the nuke.
/obj/item/weapon/disk/fakenucleardisk
  name = "nuclear authentication disk"
  desc = "A nuclear authentication disk, used for arming the self-destruct system. On closer inspection, this appears to be some sort of dummy replica."
  icon = 'icons/obj/items.dmi'
  icon_state = "nucleardisk"
  item_state = "card-id"
  w_class = ITEM_SIZE_TINY

// Fake Plastic Cap Gun of the Colt Single Action
/obj/item/weapon/gun/projectile/revolver/fakecoltsaa
	name = "Colt Single Action Army"
	item_icons = DEF_URIST_INHANDS
	desc = "A poorly made plastic replica of the Colt Single Action Army revolver dating from the late 19th century. It appears to shoot pop caps, with tactical plastic painted engravings that offer no tactical advantage."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "antiquerevolver"
	item_state = "antiquerevolver"
	caliber = "caps"
	handle_casings = CYCLE_CASINGS
	max_shells = 6
	ammo_type = /obj/item/ammo_casing/cap

/obj/item/weapon/melee/baton/fake
	name = "stunbaton"
	desc = "The Donk Co Fun-For-The-Family Stunbaton, with real zapping action! Product not suitable for anyone under the age of four."
	icon_state = "stunbaton"
	item_state = "baton"
	slot_flags = SLOT_BELT
	force = 0
	sharp = 0
	edge = 0
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("bonked", "bapped", "booped")

// Discount stamps

//Coptain
/obj/item/weapon/stamp/captain/fake
	name = "\improper coptain's rubber stamp"
	icon_state = "stamp-cap"

//Chief of Securrrrity
/obj/item/weapon/stamp/hos/fake
	name = "\improper chief of securrrity's rubber stamp"
	icon_state = "stamp-hos"

//Centconk
/obj/item/weapon/stamp/centcomm/fake
	name = "\improper centconk rubber stamp"
	icon_state = "stamp-cent"

//Nonotrasen
/obj/item/weapon/stamp/nt/fake
	name = "\improper NonoTrasen rubber stamp"
	icon_state = "stamp-intaff"

// Clown Megaphone, Honk.
///obj/item/device/megaphone/clownmegaphone
//  name = "clown's megaphone"
//  desc = "A pink megaphone that a Clown would use, it looks like a child's toy."///
//	icon_state = "megaphone_clown"
//  item_state = "radio"
//  w_class = ITEM_SIZE_SMALL
//  obj_flags = OBJ_FLAG_CONDUCTIBLE

///obj/item
