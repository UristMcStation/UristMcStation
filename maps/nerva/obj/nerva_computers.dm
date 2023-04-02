/obj/machinery/computer/modular/preset/nervacommand
	uncreated_component_parts = list(
	/obj/item/stock_parts/power/apc,
	/obj/item/stock_parts/computer/nano_printer,
	/obj/item/stock_parts/computer/card_slot
	)
	default_software = list(
	/datum/computer_file/program/chatclient,
	/datum/computer_file/program/card_mod,
	/datum/computer_file/program/comm,
	/datum/computer_file/program/contract_database,
	/datum/computer_file/program/camera_monitor,
	/datum/computer_file/program/email_client,
	/datum/computer_file/program/records,
	/datum/computer_file/program/wordprocessor,
	/datum/computer_file/program/docking,
	)

/*/obj/machinery/computer/modular/preset/nervacommand/Initialize()
	default_software = list(
	/datum/computer_file/program/chatclient,
	/datum/computer_file/program/card_mod,
	/datum/computer_file/program/comm,
	/datum/computer_file/program/contract_database,
	/datum/computer_file/program/camera_monitor,
	/datum/computer_file/program/email_client,
	/datum/computer_file/program/records,
	/datum/computer_file/program/wordprocessor,
	/datum/computer_file/program/docking,
	)
/obj/machinery/computer/modular/preset/nervasci/Initialize()
	default_software = list(
	/datum/computer_file/program/chatclient,
	/datum/computer_file/program/nttransfer,
	/datum/computer_file/program/newscast,
	/datum/computer_file/program/camera_monitor,
	/datum/computer_file/program/email_client,
	/datum/computer_file/program/supply,
	/datum/computer_file/program/records,
	/datum/computer_file/program/wordprocessor,
	/datum/computer_file/program/contract_database,
	)*/

/obj/machinery/computer/modular/preset/nervasci
	uncreated_component_parts = list(
		/obj/item/stock_parts/computer/nano_printer,
	)
	default_software = list(
	/datum/computer_file/program/chatclient,
	/datum/computer_file/program/nttransfer,
	/datum/computer_file/program/newscast,
	/datum/computer_file/program/camera_monitor,
	/datum/computer_file/program/email_client,
	/datum/computer_file/program/supply,
	/datum/computer_file/program/records,
	/datum/computer_file/program/wordprocessor,
	/datum/computer_file/program/contract_database
	)
/obj/machinery/computer/modular/preset/nervasupply
	uncreated_component_parts = list(
		/obj/item/stock_parts/computer/nano_printer,
	)
	default_software = list(
	/datum/computer_file/program/contract_database,
	/datum/computer_file/program/supply,
	)
	autorun_program = /datum/computer_file/program/supply

/*/obj/machinery/computer/modular/preset/nervasupply/Initialize()
	default_software = list(
	/datum/computer_file/program/contract_database,
	/datum/computer_file/program/supply,
	)
	autorun_program = /datum/computer_file/program/supply*/

/obj/machinery/computer/modular/preset/supply_public/magic/
	uncreated_component_parts = list(
	network_card = new/obj/item/stock_parts/computer/network_card/wired/magic
	)
