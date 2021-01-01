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

/obj/item/clothing/under/halperevaclothing
	name = "EVA Jumpsuit"
	desc = "A lightweight EVA jumpsuit, meant to be used in conjunction with Vessel Suits. The garment itself is not pressurized, but is standard issue uniform for EVA workers."
// Hats

/obj/item/clothing/head/halperberet
	name = "prison officer beret"
	desc = "A stylish blue beret, with a Terran logo on the front. For style over safety"
	icon_state = ""
	item_state = ""
	worn_state = ""

// Masks

/obj/item/clothing/mask/halperbalaclava
	name = "balaclava"
	desc = "A standard Terran issue balaclava, designed to obscure the user's face. Keeps you warm and unidentifiable."
	icon_state = ""
	item_state = ""
	worn_state = ""

// Helmets


/obj/item/clothing/head/wardenhelm
	name = "warden control suit helm"
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

/obj/item/clothing/head/ballistichelmet
	name = "ballistic helmet"
	desc = "A universal ballistic helmet, commonly issued to Terran prison officers, all helmets come equipped with ballistic goggles to keep the users eyes safe."
	icon_state = ""
	item_state = ""
	worn_state = ""


// Suits 
/obj/item/clothing/suit/wardenarmour
	name = "advanced warden control suit"
	desc = "An intimidating warden control suit, slowly becoming standard issue on Terran vessels that come under frequent attack. This suit, while not pressurized, offers great ballistic and melee protection."
	icon_state = ""
	item_state = ""
	worn_state = ""

/obj/item/clothing/suit/vesselEVA
	name = "Vessel EVA suit"
	desc = "A standard, military issue pressurized Terran EVA Suit. These suits contain strong ballistic and burn protection."
	icon_state = ""
	item_state = ""
	worn_state = ""

/obj/item/clothing/suit/armourvest
	name = "Officer Vest Rig"
	desc = "An armoured assault vest designed to assist and protect prison officers from harm during their line of duty. It features multiple pouches for storage."
	icon_state = ""
	item_state = ""
	worn_state = ""

/obj/item/clothing/suit/wardenarmourvest
	name = "Armoured Vest Rig"
	desc = "An advanced version of the assault vest granted to Terran Prison Wardens, it features small pouches on the front, and large internal armour plates to protect vital organs."
	icon_state = ""
	item_state = ""
	worn_state = ""


// Identification Cards:




// Weapons - LETHAL

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

/obj/item/weapon/gun/projectile/automatic/cycler/update_icon()
	if(ammo_magazine)
		icon_state = "bullpup"
	else
		icon_state = "bullpup_e"


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

// Sidearm Pistol

/obj/item/weapon/gun/projectile/pistol/halper_pistol
	item_icons = DEF_URIST_INHANDS
	name = "\improper Officers Pistol"
	desc = "A standard issue Terran Prison Officer's sidearm, known by many as 'Brusiers', due to the reliance on rubber ammo. These pistols shoot a 9mm caliber, and can be changed between lethal and non-lethal rounds, per Terran SOP."
	icon_state = ""
	item_state = ""
	w_class = 3
	force = 10
	caliber = "9mm"
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/halper_mag
	allowed_magazines = list(/obj/item/ammo_magazine/halper_mag)
	one_hand_penalty = 0
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'

/obj/item/weapon/gun/projectile/pistol/halper_pistol/update_icon()
	if(ammo_magazine)
		icon_state = "officer_f"
	else
		icon_state = "officer_e"


// Weapons - NON LETHAL

/obj/item/weapon/gun/energy/sparq_beam
	name = "Sparq Beam"
	desc = "This small handheld Sparq Beam fires a single shot prong, which can incapacitate humanoid targets with ease."
	icon_state = ""
	projectile_type = /obj/item/projectile/energy/electrode

/obj/item/projectile/bullet/pellet/stinger	// Great for soft targets, but can't penetrate armour.
	damage = 5 // Small amounts of damage from being hit.
	agony = 40
	range_step = 2 
	base_spread = 0
	spread_step = 15
	silenced = 1
	no_attack_log = 1
	embed = 0
	sharp = 0 // Can't stab or embed.
	armour_penetration = 0


/obj/item/weapon/grenade/stinger
	name = "Stinger Grenade"
	desc = "A non-lethal grenade, designed to explode with small rubber balls, to cause debilitating pain and to clear rooms."
	icon_state = ""

