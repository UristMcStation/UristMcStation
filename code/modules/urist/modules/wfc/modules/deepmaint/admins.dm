// Adminbuse stuff for deepmaint

/datum/admins/proc/generate_deepmaint()
	set category = "Fun"
	set desc = "(Re-)Generate DeepmaintRooms; place the map template first!"
	set name = "Generate DeepmaintRooms"

	if(!GLOB.wfc_deepmaint_zlevels_by_instance)
		log_and_message_admins("- no Deepmaint Z-levels registered!")
		return

	for(var/area/map_template/deepmaint_wfc/deepmaint_area in GLOB.wfc_deepmaint_zlevels_by_instance)
		deepmaint_area.generate_deepmaint("deepmaint.json", "genmap.json")
		log_and_message_admins("has generated a DeepmaintRooms map.")
		break

	return


/datum/admins/proc/throw_into_deepmaint(var/mob/M)
	set category = "Fun"
	set desc = "Throws the target into Deepmaint."
	set name = "Send to DeepmaintRooms"

	if(!GLOB.wfc_deepmaint_zlevels_by_instance)
		to_world_log("No Deepmaint Z-levels registered!")
		return

	var/atom/movable/target = M
	if(isnull(target))
		return

	deepmaint_send_trg(target)
	log_and_message_admins("has thrown [target] into DeepmaintRooms.")

	return
