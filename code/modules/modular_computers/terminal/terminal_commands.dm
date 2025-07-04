/// To cut down on unneeded creation/deletion, these are global.
GLOBAL_LIST_AS(terminal_commands, init_subtypes(/datum/terminal_command))

/datum/terminal_command
	/// The name of the command. Used for display and also in syntax checking.
	var/name
	/// Shown when man name is entered. Can be a list of strings, which will then be shown on separate lines.
	var/man_entry
	/// Matched using regex against terminal input
	var/pattern
	/// Used in the regex
	var/regex_flags
	/// The actual regex, produced from above.
	var/regex/regex
	/// The skill which is checked
	var/core_skill = SKILL_COMPUTER
	/// How much skill the user needs to use this. This is not for critical failure effects at unskilled; those are handled globally.
	var/skill_needed = SKILL_UNSKILLED
	/// Access needed, if any
	var/req_access = list()

/datum/terminal_command/New()
	regex = new (pattern, regex_flags)
	..()

/datum/terminal_command/proc/check_access(mob/user, datum/terminal/terminal)
	return has_access(req_access, user.GetAccess())

/// null return: continue. "" return will break and show a blank line. Return list() to break and not show anything.
/datum/terminal_command/proc/parse(text, mob/user, datum/terminal/terminal)
	if(!findtext(text, regex))
		return
	if(!check_access(user, terminal))
		return "[name]: ACCESS DENIED"
	return proper_input_entered(text, user, terminal)

/// Should not return null unless you want parser to continue.
/datum/terminal_command/proc/proper_input_entered(text, mob/user, datum/terminal/terminal)
	return list()

/datum/terminal_command/proc/skill_fail_message()
	var/message = pick(list(
		"Possible encoding mismatch detected.",
		"Update packages found; download suggested.",
		"No such option found.",
		"Flag mismatch."
	))
	return list("Command not understood.", message)

/// Returns list of arguments (if any), or null on syntax error
/datum/terminal_command/proc/get_arguments(text)
	var/list/arguments = splittext(text, " ")
	if(!length(arguments) || arguments[1] != name)
		return

	if(length(arguments) == 1)
		return list()
	arguments.Cut(1,2)
	return arguments

/datum/terminal_command/proc/syntax_error()
	return "[name]: Error; invalid input. Enter 'man [name]' for syntax help."

/datum/terminal_command/proc/network_error()
	return "[name]: Error; unable to establish connection to NTNet. Check network hardware."

/** Core commands are included here */

/datum/terminal_command/clear
	name = "clear"
	man_entry = list(
		"Format: clear",
		"Erases terminal output."
	)
	pattern = "^clear$"

/datum/terminal_command/clear/proper_input_entered(text, mob/user, datum/terminal/terminal)
	terminal.history = list()
	return list()

/datum/terminal_command/exit
	name = "exit"
	man_entry = list(
		"Format: exit",
		"Exits terminal immediately."
	)
	pattern = "^exit$"

/datum/terminal_command/exit/proper_input_entered(text, mob/user, datum/terminal/terminal)
	qdel(terminal)
	return list()

/datum/terminal_command/man
	name = "man"
	man_entry = list(
		"Format: man \[command\]",
		"Without command specified, shows list of available commands.",
		"With command, provides instructions on command use."
	)
	pattern = "^man"

/datum/terminal_command/man/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/list/arguments = get_arguments(text)
	if(isnull(arguments))
		return syntax_error()
	if(!length(arguments))
		. = list("The following commands are available.", "Some may require additional access.")
		for(var/command in GLOB.terminal_commands)
			var/datum/terminal_command/command_datum = command
			. += command_datum.name
		return
	else if(length(arguments) == 1)
		var/datum/terminal_command/command_datum = terminal.command_by_name(arguments[1])
		if(!command_datum)
			return "[name]: Error; command '[arguments[1]]' not found."
		return command_datum.man_entry
	return syntax_error()
