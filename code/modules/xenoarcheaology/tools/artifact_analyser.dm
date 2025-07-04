/obj/machinery/artifact_analyser
	name = "Anomaly Analyser"
	desc = "Studies the emissions of anomalous materials to discover their uses."
	icon = 'icons/obj/machines/research/xenoarcheology_scanner.dmi'
	icon_state = "xenoarch_console"
	anchored = TRUE
	density = TRUE
	var/scan_in_progress = FALSE
	var/scan_num = 0
	var/obj/scanned_obj
	var/obj/machinery/artifact_scanpad/owned_scanner = null
	var/scan_completion_time = 0
	var/scan_duration = 50
	var/obj/scanned_object
	var/report_num = 0
	var/list/data = list("screen" = 1)
/obj/machinery/artifact_analyser/Initialize()
	. = ..()
	sync_with_pad()

/obj/machinery/artifact_analyser/Destroy()
	stop_scanning()
	return ..()

/obj/machinery/artifact_analyser/proc/reconnect_scanner()
	//connect to a nearby scanner pad
	sync_with_pad()

/obj/machinery/artifact_analyser/DefaultTopicState()
	return GLOB.physical_state

/obj/machinery/artifact_analyser/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/artifact_analyser/use_tool(obj/item/I, mob/living/user, list/click_params)
	return ..()
/obj/machinery/artifact_analyser/interact(mob/user)
	var/dat = "<B>Anomalous material analyser</B><BR>"
	dat += "<HR>"
	if(!owned_scanner)
		reconnect_scanner()

	if(!owned_scanner)
		dat += "<b>[SPAN_COLOR("red", "Unable to locate analysis pad.")]</b><br>"
	else if(scan_in_progress)
		dat += "Please wait. Analysis in progress.<br>"
		dat += "<a href='byond://?src=\ref[src];halt_scan=1'>Halt scanning.</a><br>"
	else
		dat += "Scanner is ready.<br>"
		dat += "<a href='byond://?src=\ref[src];begin_scan=1'>Begin scanning.</a><br>"

	dat += "<br>"
	dat += "<hr>"
	dat += "<A href='byond://?src=\ref[src];syncpads=1'>Sync with nearby pad</a><BR>"
	dat += "<a href='byond://?src=\ref[src];close=1'>Close</a>"
	var/datum/browser/popup = new(user, "artanalyser", "Artifact Analyzer", 450, 500)
	popup.set_content(dat)
	popup.open()
	user.set_machine(src)
	onclose(user, "artanalyser")

/obj/machinery/artifact_analyser/Process()
	if(scan_in_progress && world.time > scan_completion_time)
		var/results = ""
		if(!owned_scanner)
			reconnect_scanner()
		if(!owned_scanner)
			results = "Error communicating with scanner."
		else if(!scanned_object || scanned_object.loc != owned_scanner.loc)
			results = "Unable to locate scanned object. Ensure it was not moved in the process."
		else
			results = get_scan_info(scanned_object)

		src.visible_message("<b>[name]</b> states, \"Scanning complete.\"")
		var/obj/item/paper/anomaly_scan/P = new(src.loc)
		P.SetName("[src] report #[++report_num]")
		P.info = "<b>[src] analysis report #[report_num]</b><br>"
		P.info += "<br>"
		P.info += "\icon[scanned_object] [results]"
		P.stamped = list(/obj/item/stamp)
		P.queue_icon_update()
		P.is_copy = FALSE

		if(GLOB.using_map.using_new_cargo)
			for(var/datum/contract/nanotrasen/anomaly/A in GLOB.using_map.contracts)
				A.Complete(1)

		stop_scanning()
		updateDialog()

/obj/machinery/artifact_analyser/proc/stop_scanning()
	scan_in_progress = FALSE
	if(!scanned_object)
		return
	if(istype(scanned_object, /obj/machinery/artifact))
		var/obj/machinery/artifact/artifact = scanned_object
		artifact.anchored = FALSE
		artifact.being_used = FALSE
	scanned_object = null

/obj/machinery/artifact_analyser/OnTopic(user, href_list)
	if(href_list["begin_scan"])
		if(!owned_scanner)
			reconnect_scanner()
		if(owned_scanner)
			var/artifact_in_use = FALSE
			for(var/obj/O in owned_scanner.loc)
				if(O == owned_scanner)
					continue
				if(O.invisibility)
					continue
				if(istype(O, /obj/machinery/artifact))
					var/obj/machinery/artifact/artifact = O
					if(artifact.being_used)
						artifact_in_use = TRUE
					else
						artifact.anchored = TRUE
						artifact.being_used = TRUE

				if(artifact_in_use)
					src.visible_message("<b>[name]</b> states, \"Cannot scan. Too much interference.\"")
				else
					scanned_object = O
					scan_in_progress = TRUE
					scan_completion_time = world.time + scan_duration
					src.visible_message("<b>[name]</b> states, \"Scanning begun.\"")
				break
			if(!scanned_object)
				src.visible_message("<b>[name]</b> states, \"Unable to isolate scan target.\"")
		. = TOPIC_REFRESH
	else if(href_list["halt_scan"])
		stop_scanning()
		src.visible_message("<b>[name]</b> states, \"Scanning halted.\"")
		. = TOPIC_REFRESH
	else if(href_list["syncpads"])
		sync_with_pad()
		. = TOPIC_REFRESH
	else if(href_list["close"])
		close_browser(user, "window=artanalyser")
		return TOPIC_HANDLED

	if(. == TOPIC_REFRESH)
		interact(user)
/obj/machinery/artifact_analyser/proc/sync_with_pad()
	for(var/obj/machinery/artifact_scanpad/scanner in range(5, src))
		owned_scanner = scanner
		src.visible_message("<b>[name]</b> states, \"Pad located, commencing sync.\"")
		return
	src.visible_message("<b>[name]</b> states, \"Scan unsuccessful, could not locate pad.\"")
	return
//hardcoded responses, oh well
/obj/machinery/artifact_analyser/proc/get_scan_info(obj/scanned_obj)
	switch(scanned_obj.type)
		if(/obj/machinery/auto_cloner)
			return "Automated cloning pod - appears to rely on an artificial ecosystem formed by semi-organic nanomachines and the contained liquid.<br>The liquid resembles protoplasmic residue supportive of unicellular organism developmental conditions.<br>The structure is composed of a titanium alloy."
		if(/obj/machinery/power/supermatter)
			return "Superdense phoron clump - appears to have been shaped or hewn, structure is composed of matter aproximately 20 times denser than ordinary refined phoron."
		if(/obj/structure/constructshell)
			return "Tribal idol - subject resembles statues/emblems built by superstitious pre-warp civilisations to honour their gods. Material appears to be a rock/plastcrete composite."
		if(/obj/machinery/giga_drill)
			return "Automated mining drill - structure composed of titanium-carbide alloy, with tip and drill lines edged in an alloy of diamond and phoron."
		if(/obj/structure/cult/pylon)
			return "Tribal pylon - subject resembles statues/emblems built by cargo cult civilisations to honour energy systems from post-warp civilisations."
		if(/obj/machinery/replicator)
			return "Automated construction unit - subject appears to be able to synthesize various objects given a material, some with simple internal circuitry. Method unknown."
		if(/obj/machinery/artifact)
			var/obj/machinery/artifact/A = scanned_obj
			var/out = "Anomalous alien device - composed of an unknown alloy.<br><br>"

			if(A.my_effect)
				out += A.my_effect.getDescription()

			if(A.secondary_effect)
				out += "<br><br>Internal scans indicate ongoing secondary activity operating independently from primary systems.<br><br>"
				out += A.secondary_effect.getDescription()

			if (A.damage_desc)
				out += "<br><br>[A.damage_desc]"

			return out
		else
			return "[scanned_obj.name] - mundane application."
