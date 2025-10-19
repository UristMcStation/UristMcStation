/*************
* Ammunition *
*************/
/datum/uplink_item/item/ammo
	item_cost = 4
	category = /datum/uplink_category/ammunition

/datum/uplink_item/item/ammo/holdout
	name = "Small Pistol Magazine (9mm)"
	desc = "A magazine for small 9mm pistols. Contains 8 rounds."
	item_cost = 3
	path = /obj/item/ammo_magazine/pistol/small

/datum/uplink_item/item/ammo/empslug
	name = "Haywire Slug (12g)"
	desc = "Single 12-gauge shotgun slug fitted with a single-use ion pulse generator."
	item_cost = 1
	path = /obj/item/ammo_casing/shotgun/emp

/datum/uplink_item/item/ammo/holdout_speedloader
	name = "Small Speedloader (9mm)"
	desc = "A speedloader for small 9mm revolvers. Contains 6 rounds."
	item_cost = 3
	path = /obj/item/ammo_magazine/speedloader/small

/datum/uplink_item/item/ammo/darts
	name = "Dart Cartridge"
	desc = "A small cartridge for a gas-powered dart gun. Contains 5 hollow darts."
	path = /obj/item/ammo_magazine/chemdart

/datum/uplink_item/item/ammo/speedloader
	name = "Standard Speedloader (10mm)"
	desc = "A speedloader for standard 10mm revolvers. Contains 6 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/speedloader

/datum/uplink_item/item/ammo/rifle
	name = "Assault Rifle Magazine (7.62mm)"
	desc = "A 7.62mm magazine designed primairly used for the STS-35, whilst also fitting the SD-Panther & L6 Saw. Contains 20 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/rifle

/datum/uplink_item/item/ammo/bullpup
	name = "Bullpup Rifle Magazine (5.56mm)"
	desc = "A 5.56mm magazine designed to fit the Z8 Bulldog & variants, as well as the Battle Rifle. Contains 15 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/mil_rifle

/datum/uplink_item/item/ammo/bullpup/heavy // is there actually a difference between these??
	name = "Heavy Bullpup Rifle Magazine (5.56mm)"
	desc = "A 5.56mm magazine designed to fit the Z8 Bulldog & variants, as well as the Battle Rifle. Contains 15 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/mil_rifle/heavy

/datum/uplink_item/item/ammo/sniperammo
	name = "Ammobox of Sniper Rounds (14.5mm)"
	desc = "A container of 14.5mm rounds for a anti-materiel rifle. Contains 7 rounds."
	item_cost = 8
	path = /obj/item/storage/box/ammo/sniperammo
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/ammo/sniperammo/apds
	name = "Ammobox of APDS Sniper Rounds (14.5MM APDS)" // yeah im reiterating it again just for label sake
	desc = "A container of armor piercing rounds for a anti-materiel rifle. Contains 3 rounds."
	item_cost = 12
	path = /obj/item/storage/box/ammo/sniperammo/apds
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/ammo/shotgun_shells
	name = "Ammobox of Shotgun Shells (12g)"
	desc = "An ammobox with 2 sets of shell holders. Contains 8 buckshot shells total."
	item_cost = 8
	path = /obj/item/storage/box/ammo/shotgunshells

/datum/uplink_item/item/ammo/flechette_shells
	name = "Ammobox of Flechette Shells (12g)"
	desc = "An ammobox with 2 sets of shell holders. Contains 8 extra accurate flechette shells."
	item_cost = 12
	path = /obj/item/storage/box/ammo/flechetteshells
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/ammo/shotgun_slugs
	name = "Ammobox of Shotgun Slugs (12g)"
	desc = "An ammobox with 2 sets of shell holders. Contains 8 slugs total."
	item_cost = 8
	path = /obj/item/storage/box/ammo/shotgunammo

/datum/uplink_item/item/ammo/machine_pistol
	name = "MP6 Vesper Stick Magazine (10mm)"
	desc = "A stick magazine for the MP6 Vesper 10mm machine pistol. Contains 16 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/machine_pistol

/datum/uplink_item/item/ammo/smg
	name = "C20r SMG Magazine (10mm)"
	desc = "A box magazine for 10mm C20r SMGs. Contains 20 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/smg
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/ammo/pistol
	name = "Doublestack Magazine (10mm)"
	desc = "A magazine for 10mm military pistols. Contains 15 rounds."
	item_cost = 9
	path = /obj/item/ammo_magazine/pistol/double

/datum/uplink_item/item/ammo/pistol_single
	name = "Standard Singlestack Magazine"
	desc = "A 10mm magazine for small, light military pistols. Contains 8 rounds."
	item_cost = 6
	path = /obj/item/ammo_magazine/pistol

/datum/uplink_item/item/ammo/magnum
	name = "Magnum Magazine (15mm)"
	desc = "A magazine for 15mm magnum pistols. Contains 7 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/magnum

/datum/uplink_item/item/ammo/speedloader_magnum
	name = "Magnum Speedloader (15mm)"
	desc = "A speedloader for 15mm magnum revolvers. Contains 6 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/speedloader/magnum

/datum/uplink_item/item/ammo/flechette
	name = "Flechette Rifle Magazine"
	desc = "A rifle magazine loaded with flechette rounds. Contains 9 rounds."
	item_cost = 8
	path = /obj/item/magnetic_ammo
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/ammo/pistol_emp
	name = "EMP Ammo Box (10mm)"
	desc = "A box of 10mm EMP ammo for standard pistols. Contains 15 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/box/emp/pistol

/datum/uplink_item/item/ammo/holdout_emp
	name = "Small EMP Ammo Box (9mm)"
	desc = "A box of 9mm EMP ammo for small pistols and revolvers. Contains 8 rounds."
	item_cost = 6
	path = /obj/item/ammo_magazine/box/emp/smallpistol

/datum/uplink_item/item/ammo/stripperclip
	name = "Stripper Clip (7.62mm)"
	desc = "A stripper clip used to load bolt action rifles chambered in 7.62mm. Contains 5 rounds."
	item_cost = 2
	path = /obj/item/ammo_magazine/speedloader/clip

/datum/uplink_item/item/ammo/shotgun_drum_buckshot
	name = "Shotgun Drum Magazine (12g)"
	desc = "A drum magazine that can hold fifteen 12g shotgun shells. Loaded with buckshot."
	item_cost = 12
	path = /obj/item/ammo_magazine/shotgunmag/shot

/datum/uplink_item/item/ammo/shotgun_drum_slugs
	name = "Shotgun Slug Drum Magazine (12g)"
	desc = "A drum magazine that can hold fifteen 12g shotgun shells. Loaded with slugs."
	item_cost = 12
	path = /obj/item/ammo_magazine/shotgunmag

/datum/uplink_item/item/ammo/shotgun_drum_flechette
	name = "Shotgun Flechette Drum Magazine (12g)"
	desc = "A drum magazine that can hold fifteen 12g shotgun shells. Loaded with flechettes."
	item_cost = 12
	path = /obj/item/ammo_magazine/shotgunmag/flechette

/datum/uplink_item/item/ammo/stripperclip_broomstick
	name = "Broomstick Pistol Stripper Clip (9mm)"
	desc = "A pistol stripper clip used to load antique broomstick pistols chambered in 9mm. Contains 10 rounds."
	item_cost = 6
	path = /obj/item/ammo_magazine/speedloader/broomstick
