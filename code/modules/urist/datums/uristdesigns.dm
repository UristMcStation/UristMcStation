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
	materials = list(DEFAULT_WALL_MATERIAL = 15000, "glass" = 5000, "silver" = 2500)
	build_path = /obj/item/weapon/storage/part_replacer/bluespace
	sort_string = "CBAAB"

/datum/design/item/powercell/bluespace
	name = "bluespace"
	id = "bluespace_cell"
	req_tech = list(TECH_POWER = 7, TECH_MATERIAL = 6, TECH_BLUESPACE = 4) //The power tech a Hyper Cell will give, Material and Bluespace Tech requirements of the BoH
	materials = list(DEFAULT_WALL_MATERIAL = 700, "gold" = 250, "silver" = 250, "glass" = 100)
	build_path = /obj/item/weapon/cell/bluespace
	sort_string = "URSTG"
