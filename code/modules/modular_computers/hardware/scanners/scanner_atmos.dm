/obj/item/stock_parts/computer/scanner/atmos
	name = "atmospheric scanner module"
	desc = "An atmospheric scanner module. It can scan the surroundings and report the composition of gases."
	can_run_scan = 1
	default_post_action = TRUE

/obj/item/stock_parts/computer/scanner/atmos/can_use_scanner(mob/user, atom/target, proximity = TRUE)
	if(!..())
		return 0
	if(!target.simulated)
		return 0
	return 1

/obj/item/stock_parts/computer/scanner/atmos/run_scan(mob/user, datum/computer_file/program/scanner/program)
	program.data_buffer = html2pencode(scan_data(user, user.loc)) || program.data_buffer

/obj/item/stock_parts/computer/scanner/atmos/do_on_afterattack(mob/user, atom/target, proximity)
	if (!can_use_scanner(user, target, proximity))
		return
	user.visible_message(
		SPAN_NOTICE("\The [user] runs \the [src] over \the [target]."),
		SPAN_NOTICE("You run \the [src] over \the [target]."),
		range = 2
	)

	var/post_to_window = user.client?.get_preference_value(/datum/client_preference/scan_results_in_window) == GLOB.PREF_YES

	var/data = scan_data(user, target, proximity, !post_to_window)
	if (!data || !driver?.using_scanner)
		return

	driver.data_buffer = data //html2pencode(data)
	SSnano.update_uis(driver.NM)

	if(!driver.post_output)
		return

	if (post_to_window)
		var/datum/browser/popup = new(user, "scanner", "[capitalize(name)] scan - [target]", 350, 400)
		popup.set_content("<hr>[driver.data_buffer]")
		popup.open()
	else
		to_chat(user, "<hr>[driver.data_buffer]<hr>")

/obj/item/stock_parts/computer/scanner/atmos/proc/scan_data(mob/user, atom/target, proximity = TRUE, legacy = FALSE)
	if(!can_use_scanner(user, target, proximity))
		return 0
	var/air_contents = target.return_air()
	if(!air_contents)
		return 0
	return atmosanalyzer_scan(target, air_contents, legacy)

/obj/item/stock_parts/computer/scanner/atmos/can_use_scanner(mob/user, atom/target, proximity)
	if (!isobj(target) && !isturf(target))
		return FALSE
	return ..()
