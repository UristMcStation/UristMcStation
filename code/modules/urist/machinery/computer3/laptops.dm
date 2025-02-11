/obj/machinery/modular_computer/laptop/captain
	name = "Captain's Portable Laptop"
	desc = "A clamshell laptop preloaded with specific files for productive captains. It is open."
	spawn_files =	list(/datum/file/program/arcade,/datum/file/program/security,/datum/file/program/crew,/datum/file/program/crew,/datum/file/program/med_data,
						/datum/file/camnet_key,/datum/file/camnet_key/mining,/datum/file/camnet_key/entertainment)
	spawn_parts =	list(/obj/item/part/computer/storage/hdd/big,/obj/item/part/computer/storage/removable,/obj/item/part/computer/networking/cameras)
	New(var/L,var/built=0)
		if(!built && !battery)
			battery = new /obj/item/cell/high(src)
		..(L,built)
