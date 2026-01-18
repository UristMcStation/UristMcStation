// Urist-specific Contraband Crates:

// Firearms:

// Surplus Bolt Action Rifles - Cargonia will rise again...
/singleton/hierarchy/supply_pack/security/revolt
	name = "UNLISTED - Bolt Action Rifles"
	contains = list(/obj/item/gun/projectile/manualcycle/mosinnagant = 2)
	cost = 30
	newcargocost = 75 // 2250th w/ inflation
	containername = "bolt action rifle crate"
	access = null
	hidden = 1

// Equipment

/singleton/hierarchy/supply_pack/security/nvg
	name = "UNLISTED - Surplus Night-Vision Goggles"
	contains = list(/obj/item/clothing/head/helmet/nvgmount/nvg = 2) // no helmets however
	cost = 50
	newcargocost = 50 //2500th
	hidden = 1 // emag only so it isn't just a quick ez goggles for sec
	containername = "surplus nvg crate"

// Critters:

/singleton/hierarchy/supply_pack/livecargo/fakecat
	name = "Live - 'Cat' Crate" // Panther Crate
	contains = list()
	cost = 50
	newcargocost = 50 //2500th
	containertype = /obj/structure/largecrate/animal/fakecat
	contraband = 1
	containername = "cat crate"

/singleton/hierarchy/supply_pack/livecargo/pikecube
	name = "Inert - Pike Cubes"
	contains = list(/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/pikecube = 3) // decentish amount
	cost = 50
	newcargocost = 48 //2400th
	hidden = 1
	containertype = /obj/structure/closet/crate/freezer
	containername = "pike crate"
