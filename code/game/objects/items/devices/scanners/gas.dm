/obj/item/device/scanner/gas
	name = "gas analyzer"
	desc = "A hand-held environmental scanner which reports current gas levels. Has a button to cycle modes."
	icon = 'icons/obj/tools/atmos_analyzer.dmi'
	icon_state = "atmos"
	item_state = "analyzer"

	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	window_width = 350
	window_height = 400

/obj/item/device/scanner/gas/is_valid_scan_target(atom/O)
	return istype(O)

/obj/item/device/scanner/gas/scan(atom/A, mob/user)
	var/air_contents = A.return_air()
	if(!air_contents)
		to_chat(user, SPAN_WARNING("Your [name] flashes a red light as it fails to analyze \the [A]."))
		return

	var/post_to_window = user.client?.get_preference_value(/datum/client_preference/scan_results_in_window) == GLOB.PREF_YES

	scan_data = atmosanalyzer_scan(A, air_contents, !post_to_window)

	if (post_to_window)
		show_menu(user)
		return

	to_chat(user, "<hr>[scan_data]<hr>")

/proc/atmosanalyzer_scan(atom/target, datum/gas_mixture/mixture, legacy = FALSE)
	var/text_summary = ""
	var/text_details = ""
	. = legacy ? SPAN_NOTICE("Results of the analysis of \the [target]:\n") : "<h1>Results of the analysis of \the [target]:</h1>"

	if (!mixture)
		mixture = target.return_air()

	if (mixture)
		var/pressure = mixture.return_pressure()
		var/total_moles = mixture.total_moles

		if (legacy)
			text_summary += abs(pressure - ONE_ATMOSPHERE) < 10 ? SPAN_NOTICE("Pressure: [round(pressure, 0.01)] kPa\n") : SPAN_WARNING("Pressure: [round(pressure, 0.01)] kPa\n")
			text_summary += SPAN_NOTICE("Volume: [mixture.volume]L\n")
			text_summary += SPAN_NOTICE("Temperature: [round(mixture.temperature-T0C)]&deg;C ([round(mixture.temperature)]K)\n")
		else
			text_summary += "<h2>Summary:</h2><ul>"
			text_summary += "<li>Pressure: [round(pressure, 0.01)] kPa</li>"
			text_summary += "<li>Total Moles: [round(total_moles, 0.01)]</li>"
			text_summary += "<li>Volume: [mixture.volume]L</li>"
			text_summary += "<li>Temperature: [round(mixture.temperature-T0C)]&deg;C ([round(mixture.temperature)]K)</li>"

		var/list/summary_gasses = list()

		if (total_moles > 0 && length(mixture.gas))
			if(!legacy)
				text_details += "<h2>Gas Details:</h2><dl>"

			for(var/mix in mixture.gas)
				var/percentage = round(mixture.gas[mix]/total_moles * 100, 0.01)
				if(!percentage)
					continue
				summary_gasses += "[percentage]% [gas_data.name[mix]]"
				if(legacy)
					continue
				text_details += "<dt>[gas_data.name[mix]]</dt><dd><ul>"
				text_details += "<li>Percentage: [percentage]%</li>"
				text_details += "<li>Moles: [round(mixture.gas[mix], 0.01)]</li>"
				text_details += "<li>Specific Heat: [gas_data.specific_heat[mix]] J/(mol*K)</li>"
				text_details += "<li>Molar Mass: [gas_data.molar_mass[mix]] kg/mol</li>"
				var/list/traits = list()
				if(gas_data.flags[mix] & XGM_GAS_FUEL)
					traits += "can be used as combustion fuel"
				if(gas_data.flags[mix] & XGM_GAS_OXIDIZER)
					traits += "can be used as oxidizer"
				if(gas_data.flags[mix] & XGM_GAS_CONTAMINANT)
					traits += "contaminates clothing with toxic residue"
				if(gas_data.flags[mix] & XGM_GAS_FUSION_FUEL)
					traits += "can be used to fuel fusion reaction"
				if (length(traits))
					text_details += "<li>This gas [english_list(traits)]</li>"
				text_details += "</ul></dd>"
			text_details += "</dl>"

		if (length(summary_gasses))
			text_summary += legacy ? SPAN_NOTICE("Composition: [english_list(summary_gasses)]") : "<li>Composition: [english_list(summary_gasses)]</li>"
		text_summary += "</ul>"
		. += "[text_summary][text_details]"

	else
		. += SPAN_DANGER("\The [target] has no gases!")
