/datum/computer_file/programs/flashlight
	filename = "flashlight utility"
	filedesc = "Flashlight Utility"
	extended_desc = "This program may be used to toggle the flashlight on your PDA."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "mail-closed"
	size = 4
	requires_ntnet = FALSE
	available_on_ntnet = TRUE
	var/flashlight = 0
	usage_flags = PROGRAM_PDA | PROGRAM_TABLET
	category = PROG_UTIL
	nanomodule_path = /datum/nano_module/flashlight
