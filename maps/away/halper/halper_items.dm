// Clothing/Items used in the IFF Halper Vessel

// Standard Clothes
/obj/item/clothing/under/color/orange/halper
	name = "prison jumpsuit"
	desc = "A standard jumpsuit used for all prisoners onboard this vessel. Its suit sensor controls are permanently set to the \"Fully On\" position."
	icon_state = "orange"
	item_state = "o_suit"
	worn_state = "orange"
	has_sensor = 2
	sensor_mode = 3

/obj/item/clothing/under/halperofficer
	name = "prison officer's uniform"
	desc = "A stylish Terran prisoner officer's uniform. It has a small crescent on it's shoulder stating 'FEDERAL OFICER'"
	icon_state = ""
	item_state = ""
	worn_state = ""

/obj/item/clothing/under/halperwarden
	name = "prison warden's uniform"
	desc = "A stylish Terran prison warden's uniform, with golden shoulder insignias to designate their importance. It has 'WARDEN' stitched onto the back."
	icon_state = ""
	item_state = ""
	worn_state = ""

/obj/item/clothing/head/halperberet
	name = "prison officer beret"
	desc = "A stylish blue beret, with a Terran logo on the front. For style over safety"
	icon_state = ""
	item_state = ""
	worn_state = ""

/obj/item/clothing/mask/halperbalaclava
	name = "balaclava"
	desc = "A standard Terran issue balaclava, designed to show more of the user's face. Keeps you warm and unidentifiable."
	icon_state = ""
	item_state = ""
	worn_state = ""

// Armour
/obj/item/clothing/suit/wardenarmour
	name = "advanced warden control suit"
	desc = "An intimidating warden control suit, slowly becoming standard issue on Terran vessels that come under frequent attack. This suit, while not pressurized, offers great ballistic and melee protection."
	icon_state = ""
	item_state = ""
	worn_state = ""

/obj/item/clothing/head/wardenhelm
	name = "advanced warden control suit helm"
	desc = "An intimidating warden control suit helmet. It features a large glowing central eye, which can be turned on and off. These helmets offer great armour protection."
	icon_state = ""
	item_state = ""
	worn_state = ""

/obj/item/clothing/suit/halperriothelm
	name = "riot helmet"
	desc = "A riot helmet, designined for protests and angry prisoners. It has a neck guard to provide additional head protection."
	icon_state = ""
	item_state = ""
	worn_state = ""
// Identification Cards:




// Weapons

// Cycler (Bullpup)

/obj/item/weapon/gun/projectile/automatic/cycler
	item_icons = DEF_URIST_INHANDS
	name = "\improper Cycler"
	desc = "A 10mm Bullpup, known as a Cycler. It is standard issue for Terran Prisoner Wardens. The Cycler uses circular magazines, with visible bullet windows, and is able to fire in both single and burst."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "bullpup"
	item_state = "bullpup"
	w_class = 4
	force = 10
	caliber = "10mm"
	origin_tech = "combat=3;materials=1;"
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/ka14
	allowed_magazines = list(/obj/item/ammo_magazine/ka14, /obj/item/ammo_magazine/ka14/flash, obj/item/ammo_magazine/ka14/stun)
	one_hand_penalty = 1
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, one_hand_penalty = 1, move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, move_delay=6, fire_delay=null, one_hand_penalty = 2, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.0, 0.6, 0.6)),
		list(mode_name="short bursts", 	burst=5, move_delay=6, fire_delay=null, one_hand_penalty = 3, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/projectile/automatic/td10_smg/update_icon()
	if(ammo_magazine)
		icon_state = "smg10mm-fo"
	else
		icon_state = "smg10mm-fo-empty"


// KA-14 (MP7)

/obj/item/weapon/gun/projectile/automatic/mp14
	item_icons = DEF_URIST_INHANDS
	name = "\improper KA14-SMG"
	desc = "A caseless 9mm submachine gun. Based of an ancient SMG design, with a set of iron sights and laser sight. It has a fire selecter for different modes of fire."
	icon = 'icons/urist/items/guns.dmi'
	icon_state = "smg10mm-fo"
	item_state = "smg10mm-fo"
	w_class = 3
	force = 10
	caliber = "9mm"
	origin_tech = "combat=3;materials=1;"
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/ka14
	allowed_magazines = list(/obj/item/ammo_magazine/ka14, /obj/item/ammo_magazine/ka14/flash, obj/item/ammo_magazine/ka14/stun)
	one_hand_penalty = 1
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, one_hand_penalty = 1, move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, move_delay=6, fire_delay=null, one_hand_penalty = 2, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.0, 0.6, 0.6)),
		list(mode_name="short bursts", 	burst=5, move_delay=6, fire_delay=null, one_hand_penalty = 3, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

