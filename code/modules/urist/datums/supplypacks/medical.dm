// Urist-specific Medical Crates:

// Cloning Disks

/singleton/hierarchy/supply_pack/medical/cloning_charge_1 // I'm making these all caps since they are right next to EMERGENCY - (supplies)
	name = "CLONING - Cloning Verification Disk (1 charge)"
	contains = list(/obj/item/disk/cloning_charge)
	cost = 100
	newcargocost = 200 // 9000th on Nerva
	containertype = /obj/structure/closet/crate/secure
	containername = "cloning verification disk crate"
	access = access_medical_equip

/singleton/hierarchy/supply_pack/medical/cloning_charge_2
	name = "CLONING - Cloning Verification Disk (2 charges)"
	contains = list(/obj/item/disk/cloning_charge/two)
	cost = 200
	newcargocost = 380 //17100th, 5% discount
	containertype = /obj/structure/closet/crate/secure
	containername = "cloning verification disk crate"
	access = access_medical_equip

/singleton/hierarchy/supply_pack/medical/cloning_charge_5
	name = "CLONING - Cloning Verification Disk (5 charges)"
	contains = list(/obj/item/disk/cloning_charge/five)
	cost = 500
	newcargocost = 900 //40500th, 10% discount. not just cloning DRM but cloning microtransactions.
	containertype = /obj/structure/closet/crate/secure
	containername = "cloning verification disk crate"
	access = access_medical_equip

// Blood Bags

/singleton/hierarchy/supply_pack/medical/teshblood
	name = "Refills - Teshari O- Blood"
	contains = list(
		/obj/item/storage/box/freezer/blood/teshari = 1
	)
	cost = 20
	containername = "teshari blood crate"
