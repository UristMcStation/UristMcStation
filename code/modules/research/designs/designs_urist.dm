/*										*****New space to put all UristMcStation Science Stuff*****

Please keep it tidy, by which I mean put comments describing the item before the entry. I've pretty much got all categories now. Any science designs for UMcS
(i.e. plasma pistol) go here. At the moment, it's just the plasma pistol, but I'm sure more will pop up. -Glloyd */

//Plasma pistol

/datum/design/plasmapistol
	name = "Phoron Pistol"
	desc = "Weaponized phoron... Scary."
	id = "plasmapistol"
	req_tech = list("combat" = 4, "materials" = 4, "plasmatech" = 4, "magnets" = 2)
	build_type = PROTOLATHE
	materials = list("$silver" = 1000, "$metal" = 4000, "$uranium" = 1000, "$glass" = 500, "$gold" = 500, "$plasma" = 500)
	build_path = /obj/item/gun/energy/plasmapistol
	sort_string = "URSTA"

// circuits
/datum/design/circuit/carpentryplaner
	name = "wood processor"
	id = "wood_processor"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/carpentryplaner
	sort_string = "URSTC"

/datum/design/circuit/woodprocessor
	name = "pulp and paper processor"
	id = "paper_processor"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/woodprocessor
	sort_string = "URSTD"

/datum/design/circuit/drying_rack
	name = "drying rack"
	id = "drying_rack"
	req_tech = list(TECH_BIO = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/stock_parts/circuitboard/drying_rack
	sort_string = "URSTE"

/datum/design/circuit/account_manager
	name = "account manager"
	id = "accountmanager"
	build_path = /obj/item/stock_parts/circuitboard/account_manager
	sort_string = "URSTF"

/datum/design/item/stock_part/BRPED
	name = "Bluespace Rapid Part Exchange Device"
	desc = "A version of the RPED that allows for replacement of parts and scanning from a distance, along with higher capacity for parts."
	id = "bs_rped"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3, TECH_BLUESPACE = 3)
	materials = list(MATERIAL_STEEL = 15000, MATERIAL_GLASS = 5000, MATERIAL_SILVER = 2500)
	build_path = /obj/item/storage/part_replacer/bluespace
	sort_string = "CBAAB"

/datum/design/item/powercell/bluespace
	name = "bluespace"
	id = "bluespace_cell"
	req_tech = list(TECH_POWER = 7, TECH_MATERIAL = 6, TECH_BLUESPACE = 4) //The power tech a Hyper Cell will give, Material and Bluespace Tech requirements of the BoH
	materials = list(MATERIAL_STEEL = 700, MATERIAL_GOLD = 250, MATERIAL_SILVER = 250, MATERIAL_GLASS = 100, MATERIAL_PHORON = 100)
	build_path = /obj/item/cell/bluespace
	sort_string = "URSTG"

/datum/design/circuit/reagent_sublimator
	name = "reagent sublimator"
	id = "reagent_sub"
	req_tech = list(TECH_ENGINEERING = 3, TECH_BIO = 2)
	build_path = /obj/item/stock_parts/circuitboard/sublimator
	sort_string = "URSTI"

/datum/design/circuit/blast_door_comp
	name = "blast door computer"
	id = "blastcomp"
	build_path = /obj/item/stock_parts/circuitboard/blast_comp
	sort_string = "URSTJ"

/datum/design/circuit/bioprinter
	name = "bioprinter"
	id = "bioprinter"
	req_tech = list(TECH_BIO = 3)
	build_path = /obj/item/stock_parts/circuitboard/bioprinter
	sort_string = "URSTK"

/datum/design/circuit/merch_comp
	name = "merchandise computer"
	id = "merch"
	build_path = /obj/item/stock_parts/circuitboard/merch
	sort_string = "URSTL"

/datum/design/circuit/holopad
	name = "holopad"
	id = "holopad"
	build_path = /obj/item/stock_parts/circuitboard/telecomms/holopad
	sort_string = "URSTM"

/datum/design/circuit/longrangeholopad
	name = "long-range holopad"
	id = "lrholopad"
	build_path = /obj/item/stock_parts/circuitboard/telecomms/holopad/longrange
	sort_string = "URSTN"

/datum/design/circuit/combat_comp
	name = "unrecognized combat computer"
	id = "combatcomp"
	req_tech = list(TECH_ESOTERIC = 9) //just meeting travis reqs...
	build_path = /obj/item/stock_parts/circuitboard/combat_computer
	sort_string = "URSTX"

/datum/design/circuit/nerva_combat_comp
	name = "ICS Nerva combat computer"
	id = "nervacombatcomp"
	req_tech = list(TECH_ESOTERIC = 9) //just meeting travis reqs...
	build_path = /obj/item/stock_parts/circuitboard/combat_computer/nerva
	sort_string = "URSTY"

/datum/design/circuit/dnascanner
	name = "cloning scanner"
	id = "dnascanner"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/stock_parts/circuitboard/clonescanner
	sort_string = "URSCA"

/datum/design/circuit/cloningpod
	name = "cloning pod"
	id = "cloningpod"
	req_tech = list(TECH_ENGINEERING = 2, TECH_BIO = 4, TECH_DATA = 4)
	build_path = /obj/item/stock_parts/circuitboard/clonepod
	sort_string = "URSCB"

/datum/design/circuit/cloning_computer
	name = "cloning control console"
	id = "cloning_computer"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/stock_parts/circuitboard/cloning_computer
	sort_string = "URSCC"

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

/datum/design/item/shipweapons/ap_torpedo
	name = "AP torpedo warhead"
	desc = "An armour-piercing warhead for a torpedo. Shove it in a torpedo casing and you're good to go."
	id = "ship_torpedo_warhead_ap"
	req_tech = list(TECH_MATERIAL = 1, TECH_PHORON = 1, TECH_ENGINEERING = 1, TECH_COMBAT = 3)
	materials = list(MATERIAL_STEEL = 1600, MATERIAL_PLASTIC = 300, MATERIAL_URANIUM = 200, MATERIAL_PHORON = 200)
	build_path = /obj/item/shipweapons/torpedo_warhead/ap
	sort_string = "SHPWH"

//shipweapons

/datum/design/item/shipweapons/light_autocannon
	name = "light autocannon"
	desc = "A light autocannon for ship-to-ship combat."
	id = "ship_light_autocannon"
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1, TECH_COMBAT = 2)
	materials = list(MATERIAL_STEEL = 12000, MATERIAL_ALUMINIUM = 1000)
	build_path = /obj/structure/shipweapons/incomplete_weapon/external/light_autocannon
	sort_string = "SHPWD"

/datum/design/item/shipweapons/light_autocannon/rapid
	name = "rapid light autocannon"
	desc = "A light autocannon for ship-to-ship combat. Equipped with two barrels for a faster fire rate."
	id = "ship_light_autocannon_rapid"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_COMBAT = 3)
	materials = list(MATERIAL_STEEL = 20000, MATERIAL_ALUMINIUM = 1500)
	build_path = /obj/structure/shipweapons/incomplete_weapon/external/light_autocannon/rapid
	sort_string = "SHPWE"

/datum/design/item/shipweapons/ap_heavy_autocannon
	name = "heavy autocannon ammunition (AP)"
	desc = "Armour-piercing shells for a heavy autocannon. Will not work in a light autocannon."
	id = "ship_heavy_autocannon_ap"
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1, TECH_COMBAT = 2)
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_PLASTIC = 250)
	build_path = /obj/structure/shipammo/heavy_autocannon/ap
	sort_string = "SHPWF"

/datum/design/item/shipweapons/he_heavy_autocannon
	name = "heavy autocannon ammunition (HE)"
	desc = "High-explosive shells for a heavy autocannon. Will not work in a light autocannon."
	id = "ship_heavy_autocannon_he"
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1, TECH_COMBAT = 2)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_PLASTIC = 500, MATERIAL_URANIUM = 200)
	build_path = /obj/structure/shipammo/heavy_autocannon/he
	sort_string = "SHPWG"

// laces

/datum/design/item/biostorage/neural_lace
	id = "neural lace"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4, TECH_MAGNET = 2, TECH_DATA = 3)
	materials = list (MATERIAL_STEEL = 10000, MATERIAL_GLASS = 7500, MATERIAL_SILVER = 1000, MATERIAL_GOLD = 1000, MATERIAL_PHORON = 200)
	build_path = /obj/item/organ/internal/stack
	sort_string = "VACBA"

// Utility

/datum/design/item/utility/advanced_flashlight
	name = "advanced flashlight"
	desc = "An upgraded flashlight, allowing you to see further into the dark than your usual flashlight. "
	req_tech = list(TECH_ENGINEERING = 1, TECH_MATERIAL = 2, TECH_POWER = 3)
	materials = list (MATERIAL_STEEL = 350, MATERIAL_GLASS = 250, MATERIAL_PLASTIC = 200) // Cheap enough to replace without rare mats.
	build_path = /obj/item/device/flashlight/maglight/advanced
	sort_string = "URSTZ"

/datum/design/item/utility/geiger_counter
	name = "geiger counter"
	desc = "A geiger counter"
	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 1, TECH_POWER = 1)
	materials = list (MATERIAL_STEEL = 150, MATERIAL_GLASS = 100, MATERIAL_PLASTIC = 400)
	build_path = /obj/item/device/geiger
	sort_string = "URSCD"
