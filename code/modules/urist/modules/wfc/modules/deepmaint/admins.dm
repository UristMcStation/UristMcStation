// Adminbuse stuff for deepmaint

/datum/admins/proc/generate_deepmaint()
	set category = "Fun"
	set desc = "(Re-)Generate DeepmaintRooms; place the map template first!"
	set name = "Generate DeepmaintRooms"

	if(!GLOB.wfc_deepmaint_zlevels_by_instance)
		log_and_message_admins("failed to generate Deepmaint - no Deepmaint Z-levels registered!")
		return

	for(var/area/map_template/deepmaint_wfc/deepmaint_area in GLOB.wfc_deepmaint_zlevels_by_instance)
		var/success = deepmaint_area.generate_deepmaint("deepmaint.json", "genmap.json")
		if(success)
			log_and_message_admins("has generated a DeepmaintRooms map.")
			break
		else
			log_and_message_admins("has unsuccessfully attempted to generate a DeepmaintRooms map.")

	return


/datum/admins/proc/throw_into_deepmaint(mob/M)
	set category = "Fun"
	set desc = "Throws the target into Deepmaint."
	set name = "Send to DeepmaintRooms"

	if(!GLOB.wfc_deepmaint_zlevels_by_instance)
		log_and_message_admins("tried to throw \a [M] into Deepmaint, but no Deepmaint Z-levels are currently registered!")
		return

	var/atom/movable/target = M
	if(isnull(target))
		return

	var/success = deepmaint_send_trg(target)
	if(success)
		log_and_message_admins("has thrown [target] into DeepmaintRooms.")
	else
		log_and_message_admins("has tried to throw [target] into DeepmaintRooms, but failed!")

	return
