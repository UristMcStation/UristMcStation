// Urist-specific Science Crates:

//Xenobio supplies crate - for when the slimes all die. One extinguisher, one monkeycube box, two grey extracts - Octobomb
/singleton/hierarchy/supply_pack/science/xenobio_supplies
	name = "Equipment - Xenobiology Slime Resupply"
	contains = list(/obj/item/extinguisher,
					/obj/item/storage/box/monkeycubes,
					/obj/item/slime_extract/grey,
					/obj/item/slime_extract/grey)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Xenobiology resupply crate"
	access = access_rd
