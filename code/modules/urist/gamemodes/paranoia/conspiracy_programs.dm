/obj/item/computer_hardware/intel_scanner //shitty ripoff of ai slot; I thought nanoprinters could handle that but no
	name = "intel scanner"
	desc = "A specialized device for encrypting and uploading sensitive documents. Contains an integrated paper shredder. Too large to fit into tablets."
	icon_state = "aislot"
	hardware_size = 2
	critical = 0
	power_usage = 100
	origin_tech = list(TECH_POWER = 2, TECH_DATA = 4)
	var/obj/item/conspiracyintel/stored_intel

/obj/item/computer_hardware/intel_scanner/attackby(obj/item/W as obj, var/mob/user as mob)
	if(..())
		return 1
	if(istype(W, /obj/item/conspiracyintel))
		if(stored_intel)
			to_chat(user, "\The [src] is already occupied.")
			return
		user.drop_from_inventory(W)
		stored_intel = W
		W.forceMove(src)
	if(istype(W, /obj/item/screwdriver))
		to_chat(user, "You manually remove \the [stored_intel] from \the [src].")
		stored_card.forceMove(get_turf(src))
		stored_card = null
		update_power_usage()

/obj/item/computer_hardware/intel_scanner/Destroy()
	if(holder2 && (holder2.ai_slot == src))
		holder2.ai_slot = null
	if(stored_card)
		stored_intel.forceMove(get_turf(holder2))
	holder2 = null
	return ..()

/datum/computer_file/program/conspiracy_uplink
	filename = "babylon"
	filedesc = "BABYLON Uplink Client"
	//nanomodule_path = /datum/nano_module/camera_monitor/hacked
	program_icon_state = "command"
	extended_desc = "A secure client for accessing and uploading data to remote darknets, rumored to be popular among covert organizations."
	size = 13
	available_on_ntnet = 0
	available_on_syndinet = 1
	requires_ntnet = 1
	requires_ntnet_feature = NTNET_PEERTOPEER
