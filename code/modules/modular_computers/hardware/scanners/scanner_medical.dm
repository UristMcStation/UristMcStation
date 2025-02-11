/obj/item/stock_parts/computer/scanner/medical
	name = "medical scanner module"
	desc = "A medical scanner module. It can be used to scan patients and display medical information."
	default_post_action = TRUE

/obj/item/stock_parts/computer/scanner/medical/do_on_afterattack(mob/user, atom/target, proximity)
	if(!can_use_scanner(user, target, proximity))
		return

	var/dat = medical_scan_action(target, user, loc, 1)

	playsound(src, 'sound/effects/fastbeep.ogg', 20)

	if(!dat || !driver?.using_scanner)
		return

	driver.data_buffer = dat	//html2pencode(dat) --Unnecessary conversion? NanoUI accepts html....
	SSnano.update_uis(driver.NM)

	if (!driver.post_output)
		return

	if (user.client?.get_preference_value(/datum/client_preference/scan_results_in_window) == GLOB.PREF_YES)
		var/datum/browser/popup = new(user, "scanner", "[capitalize(name)] scan - [target]", 450, 600)
		popup.set_content("<hr>[driver.data_buffer]")
		popup.open()
	else
		to_chat(user, "<hr>[driver.data_buffer]<hr>")
