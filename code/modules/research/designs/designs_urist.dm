/*										*****New space to put all UristMcStation Science Stuff*****

Please keep it tidy, by which I mean put comments describing the item before the entry. I've pretty much got all categories now. Any science designs for UMcS
(i.e. plasma pistol) go here. At the moment, it's just the plasma pistol, but I'm sure more will pop up. -Glloyd */

//Plasma pistol

datum/design/plasmapistol
	name = "Phoron Pistol"
	desc = "Weaponized phoron... Scary."
	id = "plasmapistol"
	req_tech = list("combat" = 4, "materials" = 4, "plasmatech" = 4, "magnets" = 2)
	build_type = PROTOLATHE
	materials = list("$silver" = 1000, "$metal" = 4000, "$uranium" = 1000, "$glass" = 500, "$gold" = 500, "$plasma" = 500)
	build_path = /obj/item/weapon/gun/energy/plasmapistol
	sort_string = "URSTA"

/datum/design/circuit/tanningrack
	name = "tanning rack"
	id = "tanning rack"
	req_tech = list(TECH_BIO = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/tanningrack
	sort_string = "URSTB"

/datum/design/circuit/carpentryplaner
	name = "wood processor"
	id = "wood processor"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/carpentryplaner
	sort_string = "URSTC"

/datum/design/circuit/woodprocessor
	name = "pulp and paper processor"
	id = "pulp and paper processor"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/woodprocessor
	sort_string = "URSTD"

/datum/design/circuit/drying_rack
	name = "drying rack"
	id = "drying rack"
	req_tech = list(TECH_BIO = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/drying_rack
	sort_string = "URSTE"

/datum/design/circuit/washing_machine
	name = "washing machine"
	id = "washing machine"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/washing_machine
	sort_string = "URSTF"

/datum/design/item/stock_part/BRPED
	name = "Bluespace Rapid Part Exchange Device"
	desc = "A version of the RPED that allows for replacement of parts and scanning from a distance, along with higher capacity for parts."
	id = "bs_rped"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3, TECH_BLUESPACE = 3)
	materials = list(MATERIAL_STEEL = 15000, MATERIAL_GLASS = 5000, MATERIAL_SILVER = 2500)
	build_path = /obj/item/weapon/storage/part_replacer/bluespace
	sort_string = "CBAAB"

/datum/design/item/powercell/bluespace
	name = "bluespace"
	id = "bluespace_cell"
	req_tech = list(TECH_POWER = 7, TECH_MATERIAL = 6, TECH_BLUESPACE = 4) //The power tech a Hyper Cell will give, Material and Bluespace Tech requirements of the BoH
	materials = list(MATERIAL_STEEL = 700, MATERIAL_GOLD = 250, MATERIAL_SILVER = 250, MATERIAL_GLASS = 100, MATERIAL_PHORON = 100)
	build_path = /obj/item/weapon/cell/bluespace
	sort_string = "URSTG"

//shipweapon stuff

/datum/design/item/shipweapons
	category = WEAPON_DESIGNS

//torpedo warheads

/datum/design/item/shipweapons/bluespace_torpedo
	name = "bluespace torpedo warhead"
	desc = "A bluespace warhead for a torpedo. Shove it in a torpedo casing and you're good to go."
	id = "ship_torpedo_warhead_bluespace"
	req_tech = list(TECH_MATERIAL = 2, TECH_PHORON = 1, TECH_ENGINEERING = 1, TECH_COMBAT = 2, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_STEEL = 1200, MATERIAL_PLASTIC = 500, MATERIAL_PHORON = 800)
	build_path = /obj/item/shipweapons/torpedo_warhead/bluespace
	sort_string = "SHPWA"

/datum/design/item/shipweapons/ap_torpedo
	name = "AP torpedo warhead"
	desc = "An armour-piercing warhead for a torpedo. Shove it in a torpedo casing and you're good to go."
	id = "ship_torpedo_warhead_ap"
	req_tech = list(TECH_MATERIAL = 1, TECH_PHORON = 1, TECH_ENGINEERING = 1, TECH_COMBAT = 3)
	materials = list(MATERIAL_STEEL = 1200, MATERIAL_PLASTIC = 250, MATERIAL_DIAMOND = 300)
	build_path = /obj/item/shipweapons/torpedo_warhead/ap
	sort_string = "SHPWB"

/datum/design/item/shipweapons/emp_torpedo
	name = "EMP torpedo warhead"
	desc = "An EMP warhead for a torpedo. Shove it in a torpedo casing and you're good to go."
	id = "ship_torpedo_warhead_emp"
	req_tech = list(TECH_MATERIAL = 2, TECH_PHORON = 2, TECH_ENGINEERING = 2, TECH_COMBAT = 2)
	materials = list(MATERIAL_STEEL = 1200, MATERIAL_PLASTIC = 300, MATERIAL_URANIUM = 800)
	build_path = /obj/item/shipweapons/torpedo_warhead/emp
	sort_string = "SHPWC"

//shipweapons

/datum/design/item/shipweapons/light_autocannon
	name = "light autocannon"
	desc = "A light autocannon for ship-to-ship combat."
	id = "ship_light_autocannon"
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1, TECH_COMBAT = 2)
	materials = list(MATERIAL_STEEL = 12000)
	build_path = /obj/structure/shipweapons/incomplete_weapon/external/light_autocannon
	sort_string = "SHPWD"

/datum/design/item/shipweapons/light_autocannon/rapid
	name = "rapid light autocannon"
	desc = "A light autocannon for ship-to-ship combat. Equipped with two barrels for a faster fire rate."
	id = "ship_light_autocannon_rapid"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_COMBAT = 3)
	materials = list(MATERIAL_STEEL = 20000)
	build_path = /obj/structure/shipweapons/incomplete_weapon/external/light_autocannon/rapid
	sort_string = "SHPWE"

/datum/design/item/shipweapons/ap_heavy_autocannon
	name = "heavy autocannon ammunition (AP)"
	desc = "Armour-piercing shells for a heavy autocannon. Will not work in a light autocannon."
	id = "ship_torpedo_warhead_ap"
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1, TECH_COMBAT = 2)
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_PLASTIC = 250)
	build_path = /obj/structure/shipammo/heavy_autocannon/ap
	sort_string = "SHPWF"

/datum/design/item/shipweapons/ap_heavy_autocannon
	name = "heavy autocannon ammunition (HE)"
	desc = "High-explosive shells for a heavy autocannon. Will not work in a light autocannon."
	id = "ship_torpedo_warhead_ap"
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1, TECH_COMBAT = 2)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_PLASTIC = 500, MATERIAL_URANIUM = 200)
	build_path = /obj/structure/shipammo/heavy_autocannon/he
	sort_string = "SHPWG"