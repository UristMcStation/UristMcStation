/obj/machinery/computer/cloning
	name = "cloning control console"
	desc = "A console used for controlling a cloning pod and a DNA scanner. Owing to NanoTrasen's monopoly on cloning software and technology, the computer requires 'cloning verification disks' to be inserted before cloning can take place."
	icon = 'icons/obj/machines/computer.dmi'
	icon_keyboard = "med_key"
	icon_screen = "dna"
	light_color = "#315ab4"
	req_access = list(access_medical_equip) //Only used for record deletion right now.
	var/obj/machinery/dna_scannernew/scanner = null //Linked scanner. For scanning.
	var/list/pods = list() //Linked cloning pods.
	var/temp = ""
	var/scantemp = "Scanner unoccupied"
	var/menu = 1 //Which menu screen to display
	var/list/records = list()
	var/datum/dna2/record/active_record = null
	var/obj/item/disk/data/diskette = null //Mostly so the geneticist can steal everything.
	var/loading = FALSE // Nice loading text
	var/charges = 0 // how many times can we clone

/obj/machinery/computer/cloning/Initialize()
	.=..()
	set_extension(src, /datum/extension/interactive/multitool)
	updatemodules()

/obj/machinery/computer/cloning/Destroy()
	releasecloner()
	return ..()

/obj/machinery/computer/cloning/proc/updatemodules()
	src.scanner = findscanner()
	releasecloner()
	findcloner()

/obj/machinery/computer/cloning/proc/findscanner()
	var/obj/machinery/dna_scannernew/scannerf = null

	//Try to find scanner on adjacent tiles first
	for(var/direction in list(NORTH,EAST,SOUTH,WEST))
		scannerf = locate(/obj/machinery/dna_scannernew, get_step(src, direction))
		if (scannerf)
			return scannerf

	//Then look for a free one in the area
	if(!scannerf)
		var/area/A = get_area(src)
		for(var/obj/machinery/dna_scannernew/S in A.get_contents())
			return S

	return

/obj/machinery/computer/cloning/proc/releasecloner()
	for(var/obj/machinery/clonepod/P in pods)
		P.connected = null
		P.name = initial(P.name)
	pods.Cut()

/obj/machinery/computer/cloning/proc/connect_pod(obj/machinery/clonepod/P)
	if(P in pods)
		return FALSE

	if(P.connected)
		P.connected.release_pod(P)
	P.connected = src
	pods += P
	rename_pods()

	return TRUE

/obj/machinery/computer/cloning/proc/release_pod(obj/machinery/clonepod/P)
	if(!(P in pods))
		return

	P.connected = null
	P.name = initial(P.name)
	pods -= P
	rename_pods()
	return TRUE

/obj/machinery/computer/cloning/proc/rename_pods()
	for(var/i = 1 to length(pods))
		var/atom/P = pods[i]
		P.name = "[initial(P.name)] #[i]"

/obj/machinery/computer/cloning/proc/findcloner()
	var/num = 1
	var/area/A = get_area(src)
	for(var/obj/machinery/clonepod/P in A.get_contents())
		if(!P.connected)
			pods += P
			P.connected = src
			P.name = "[initial(P.name)] #[num++]"

/obj/machinery/computer/cloning/use_tool(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/disk/data)) //INSERT SOME DISKETTES
		if (!src.diskette)
			user.drop_item()
			W.forceMove(src)
			src.diskette = W
			to_chat(user, "You insert \the [W].")
			src.updateUsrDialog()
			return
	else if (istype(W, /obj/item/disk/cloning_charge))
		var/obj/item/disk/cloning_charge/disk = W
		charges += disk.charges
		user.visible_message("[user] loads \an [disk] into \the [src], which whirrs and hums as it scans the disk, destroying it in the process.", "You insert \an [disk] into \the [src], which whirrs and hums as it scans the disk, destroying it in the process. [disk.charges] charge\s have been added the system.")
		qdel(disk)

	else
		..()
	return

/obj/machinery/computer/cloning/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/computer/cloning/interact(mob/user)
	if(stat & (inoperable()))
		return

	updatemodules()

	var/dat = "<h3>Cloning System Control</h3>"
	dat += "<font size=-1><a href='byond://?src=\ref[src];refresh=1'>Refresh</a></font>"

	dat += "<br><tt>[temp]</tt><br>"

	switch(src.menu)
		if(1)
			// Modules
			dat += "<h4>Modules</h4>"
			//dat += "<a href='byond://?src=\ref[src];relmodules=1'>Reload Modules</a>"
			if (isnull(src.scanner))
				dat += " <font color=red>DNA scanner not found.</font><br>"
			else
				dat += " <font color=green>DNA scanner found.</font><br>"
			if (length(pods))
				dat += " <font color=green>[length(pods)] cloning vat\s found.</font><br>"
			else
				dat += " <font color=red>No cloning vats found.</font><br>"

			// Scanner
			dat += "<h4>Scanner Functions</h4>"

			if(loading)
				dat += "<b>Scanning...</b><br>"
			else
				dat += "<b>[scantemp]</b><br>"

			if (isnull(src.scanner))
				dat += "No scanner connected!<br>"
			else
				if (src.scanner.occupant)
					if(scantemp == "Scanner unoccupied") scantemp = "" // Stupid check to remove the text

					dat += "<a href='byond://?src=\ref[src];scan=1'>Scan - [src.scanner.occupant]</a><br>"
				else
					scantemp = "Scanner unoccupied"

//				dat += "Lock status: <a href='byond://?src=\ref[src];lock=1'>[src.scanner.locked ? "Locked" : "Unlocked"]</a><br>"

			if (length(pods))
				for (var/obj/machinery/clonepod/pod in pods)
					dat += "[pod] biomass: <i>[pod.biomass]</i><br>"

			dat += "Verification Charges: [charges]"

			// Database
			dat += "<h4>Database Functions</h4>"
			dat += "<a href='byond://?src=\ref[src];menu=2'>View Records</a><br>"
			if (src.diskette)
				dat += "<a href='byond://?src=\ref[src];disk=eject'>Eject Disk</a>"


		if(2)
			dat += "<h4>Current records</h4>"
			dat += "<a href='byond://?src=\ref[src];menu=1'>Back</a><br><br>"
			for(var/datum/dna2/record/R in src.records)
				dat += "<li><a href='byond://?src=\ref[src];view_rec=\ref[R]'>[R.dna.real_name]</a></li>"

		if(3)
			dat += "<h4>Selected Record</h4>"
			dat += "<a href='byond://?src=\ref[src];menu=2'>Back</a><br>"

			if (!src.active_record)
				dat += "<font color=red>ERROR: Record not found.</font>"
			else
				dat += {"<br><font size=1><a href='byond://?src=\ref[src];del_rec=1'>Delete Record</a></font><br>
					<b>Name:</b> [src.active_record.dna.real_name]<br>"}
				var/obj/item/implant/health/H = null
				if(src.active_record.implant)
					H=locate(src.active_record.implant)

				if ((H) && (istype(H)))
					dat += "<b>Health:</b> [H.sensehealth()] | OXY-BURN-TOX-BRUTE<br>"
				else
					dat += "<font color=red>Unable to locate implant.</font><br>"

				if (!isnull(src.diskette))
					dat += "<a href='byond://?src=\ref[src];disk=load'>Load from disk.</a>"

					dat += " | Save: <a href='byond://?src=\ref[src];save_disk=ue'>UI + UE</a>"
					dat += " | Save: <a href='byond://?src=\ref[src];save_disk=ui'>UI</a>"
					dat += " | Save: <a href='byond://?src=\ref[src];save_disk=se'>SE</a>"
					dat += "<br>"
				else
					dat += "<br>" //Keeping a line empty for appearances I guess.

				dat += {"<b>UI:</b> [src.active_record.dna.uni_identity]<br>
				<b>SE:</b> [src.active_record.dna.struc_enzymes]<br><br>"}

				if(length(pods))
					dat += {"<a href='byond://?src=\ref[src];clone=\ref[src.active_record]'>Clone</a><br>"}

		if(4)
			if (!src.active_record)
				src.menu = 2
			dat = "[src.temp]<br>"
			dat += "<h4>Confirm Record Deletion</h4>"

			dat += "<b><a href='byond://?src=\ref[src];del_rec=1'>Scan card to confirm.</a></b><br>"
			dat += "<b><a href='byond://?src=\ref[src];menu=3'>No</a></b>"


	show_browser(user, dat, "window=cloning")
	onclose(user, "cloning")
	return

/obj/machinery/computer/cloning/Topic(href, href_list)
	if(..())
		return

	if(loading)
		return

	if ((href_list["scan"]) && (!isnull(src.scanner)))
		scantemp = ""

		loading = TRUE
		src.updateUsrDialog()

		spawn(20)
			src.scan_mob(src.scanner.occupant)

			loading = FALSE
			src.updateUsrDialog()


/*		//No locking an open scanner.
	else if ((href_list["lock"]) && (!isnull(src.scanner)))
		if ((!src.scanner.locked) && (src.scanner.occupant))
			src.scanner.locked = TRUE
			src.updateUsrDialog()
		else
			src.scanner.locked = FALSE
			src.updateUsrDialog()*/

	else if (href_list["view_rec"])
		src.active_record = locate(href_list["view_rec"])
		if(istype(src.active_record,/datum/dna2/record))
			if ((isnull(src.active_record.ckey)))
				qdel(src.active_record)
				src.temp = "ERROR: Record Corrupt"
				src.updateUsrDialog()
			else
				src.menu = 3
				src.updateUsrDialog()
		else
			src.active_record = null
			src.temp = "Record missing."
			src.updateUsrDialog()

	else if (href_list["del_rec"])
		if ((!src.active_record) || (src.menu < 3))
			return
		if (src.menu == 3) //If we are viewing a record, confirm deletion
			src.temp = "Delete record?"
			src.menu = 4
			src.updateUsrDialog()
		else if (src.menu == 4)
			var/obj/item/card/id/C = usr.get_active_hand()
			if (istype(C)||istype(C, /obj/item/modular_computer/pda))
				if(src.check_access(C))
					src.records.Remove(src.active_record)
					qdel(src.active_record)
					src.temp = "Record deleted."
					src.menu = 2
					src.updateUsrDialog()
				else
					src.temp = "Access Denied."
					src.updateUsrDialog()

	else if (href_list["disk"]) //Load or eject.
		switch(href_list["disk"])
			if("load")
				if ((isnull(src.diskette)) || isnull(src.diskette.buf))
					src.temp = "Load error."
					src.updateUsrDialog()
					return
				if (isnull(src.active_record))
					src.temp = "Record error."
					src.menu = 1
					src.updateUsrDialog()
					return

				src.active_record = src.diskette.buf

				src.temp = "Load successful."
			if("eject")
				if (!isnull(src.diskette))
					src.diskette.dropInto(loc)
					src.diskette = null
					src.updateUsrDialog()

	else if (href_list["save_disk"]) //Save to disk!
		if ((isnull(src.diskette)) || (src.diskette.read_only) || (isnull(src.active_record)))
			src.temp = "Save error."
			src.updateUsrDialog()
			return

		// DNA2 makes things a little simpler.
		src.diskette.buf=src.active_record
		src.diskette.buf.types=0
		switch(href_list["save_disk"]) //Save as Ui/Ui+Ue/Se
			if("ui")
				src.diskette.buf.types=DNA2_BUF_UI
			if("ue")
				src.diskette.buf.types=DNA2_BUF_UI|DNA2_BUF_UE
			if("se")
				src.diskette.buf.types=DNA2_BUF_SE
		src.diskette.name = "data disk - '[src.active_record.dna.real_name]'"
		src.temp = "Save \[[href_list["save_disk"]]\] successful."

	else if (href_list["refresh"])
		src.updateUsrDialog()
		temp = ""

	else if (href_list["clone"])
		var/datum/dna2/record/C = locate(href_list["clone"])
		//Look for that player! They better be dead!
		if(istype(C))
			temp = ""
			//Can't clone without someone to clone.  Or a pod.  Or if the pod is busy. Or full of gibs.
			if(!length(pods))
				temp = "Error: No clone pods detected."
				src.updateUsrDialog()
			else
				var/obj/machinery/clonepod/pod = pods[1]
				if (length(pods) > 1)
					pod = input(usr,"Select a cloning pod to use", "Pod selection") as anything in pods
					src.updateUsrDialog()
				if(pod.occupant)
					temp = "Error: Clonepod is currently occupied."
					src.updateUsrDialog()
				else if(pod.biomass < CLONE_BIOMASS)
					temp = "Error: Not enough biomass."
					src.updateUsrDialog()
				else if(pod.mess)
					temp = "Error: Clonepod malfunction."
					src.updateUsrDialog()
				else if(!charges)
					temp = "Error: No remaining verification charges."
					src.updateUsrDialog()
//				else if(!config.revival_cloning)
//					temp = "Error: Unable to initiate cloning cycle."
				else
					var/cloning
					if(config.use_cortical_stacks)
						cloning = TRUE
						pod.growclone(C)
						src.updateUsrDialog()
					else
						var/mob/selected = find_dead_player("[C.ckey]")
						sound_to(selected, 'sound/machines/chime.ogg')//probably not the best sound but I think it's reasonable

						var/answer = alert(selected,"Do you want to return to life?","Cloning","Yes","No")
						if(answer == "Yes" && pod.growclone(C))
							cloning = TRUE
							src.updateUsrDialog()
					if(cloning)
						temp = "Initiating cloning cycle..."
						charges--
						if(!config.use_cortical_stacks)
							records.Remove(C)
						qdel(C)
						menu = 1
						src.updateUsrDialog()
					else
						temp = "Initiating cloning cycle...<br>Error: Post-initialisation failed. Cloning cycle aborted."
					src.updateUsrDialog()

		else
			temp = "Error: Data corruption."

	else if (href_list["menu"])
		src.menu = text2num(href_list["menu"])
		src.updateUsrDialog()

	src.add_fingerprint(usr)

/obj/machinery/computer/cloning/proc/scan_mob(mob/living/carbon/human/subject as mob)
	if ((isnull(subject)) || (!(ishuman(subject))) || (!subject.dna))
		scantemp = "Error: Unable to locate valid genetic data."
		return
	if(!config.use_cortical_stacks)
		if (!subject.has_brain())
			if(ishuman(subject))
				var/mob/living/carbon/human/H = subject
				if(H.should_have_organ(BP_BRAIN))
					scantemp = "Error: No signs of intelligence detected."
			else
				scantemp = "Error: No signs of intelligence detected."
			return
		if ((!subject.ckey) || (!subject.client))
			scantemp = "Error: Mental interface failure."
			return
		if(subject.isSynthetic())
			scantemp = "Error: Subject is not organic."
			return
//	if (MUTATION_NOCLONE in subject.mutations)
//		scantemp = "Error: Major genetic degradation."
//		return
	if (subject.species && subject.species.species_flags & SPECIES_FLAG_NO_SCAN)
		scantemp = "Error: Incompatible species."
		return
	if (subject.ckey && !isnull(find_record(subject.ckey)))
		scantemp = "Subject already in database."
		return

	subject.dna.check_integrity()

	var/datum/dna2/record/R = new /datum/dna2/record()
	R.dna=subject.dna
	R.ckey = subject.ckey ? subject.ckey : "no ckey"
	R.id= copytext(md5(subject.real_name), 2, 6)
	R.name=R.dna.real_name
	R.types=DNA2_BUF_UI|DNA2_BUF_UE|DNA2_BUF_SE
	R.languages=subject.languages
	R.flavor=subject.flavor_texts.Copy()

	//Add an implant if needed
	var/obj/item/implant/health/imp = locate(/obj/item/implant/health, subject)
	if (isnull(imp))
		imp = new /obj/item/implant/health(subject)
		imp.implanted = subject
		R.implant = "\ref[imp]"
	//Update it if needed
	else
		R.implant = "\ref[imp]"

	if (!isnull(subject.mind)) //Save that mind so traitors can continue traitoring after cloning.
		R.mind = "\ref[subject.mind]"

	src.records += R
	scantemp = "Subject successfully scanned."

//Find a specific record by key.
/obj/machinery/computer/cloning/proc/find_record(find_key)
	var/selected_record = null
	for(var/datum/dna2/record/R in src.records)
		if (R.ckey == find_key)
			selected_record = R
			break
			return selected_record


/// cloning DRM disks. The now is future.
/obj/item/disk/cloning_charge
	name = "cloning verification disk (one charge)"
	desc = "A disk that is required for the cloning process. Thanks to NanoTrasen's monopoly on cloning technology, all cloning requires an expensive verification disk to add 'verification charges' to a cloning machine, that are used upon cloning. This disk has one charge."
	icon = 'icons/obj/datadisks.dmi'
	icon_state = "datadisk1"
	var/charges = 1

/obj/item/disk/cloning_charge/two
	name = "cloning verification disk (two charges)"
	desc = "A disk that is required for the cloning process. Thanks to NanoTrasen's monopoly on cloning technology, all cloning requires an expensive verification disk to add 'verification charges' to a cloning machine, that are used upon cloning. This disk has two charges."
	charges = 2

/obj/item/disk/cloning_charge/five
	name = "cloning verification disk (five charges)"
	desc = "A disk that is required for the cloning process. Thanks to NanoTrasen's monopoly on cloning technology, all cloning requires an expensive verification disk to add 'verification charges' to a cloning machine, that are used upon cloning. This disk has five charges."
	charges = 5
