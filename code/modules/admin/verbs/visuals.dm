/proc/get_colormatrix_def_from_input()
	var/list/options = list("noir"=COLMX_EXPRESSIONIST,
							"neo-noir"=COLMX_NOIR,
							"greyscale"=COLMX_GREYSCALE,
							"wasteland"=COLMX_GRIMDARK,
							"matrix"=COLMX_CYBERPUNK,
							"custom"=null)
	var/definition = input("Select preset or custom matrix:", "Matrix", usr.client) as null|anything in options

	if(definition in options)
		if(definition == "custom")
			definition = input("Enter the new matrix (JSON):", "JSON", null) as text|null
		else
			definition = options[definition]
	return definition


/client/proc/cmd_admin_set_colormatrix()
	set category = "Fun"
	set name = "Set Color Filter"

	if(!check_rights(R_FUN))
		return

	var/datum/array/CM = null
	var/client/target = input("Select target:", "Target", usr.client) as null|anything in GLOB.clients

	if(!target)
		return

	var/definition = get_colormatrix_def_from_input()

	if(definition)
		CM = new /datum/array(definition)

	target.color_transition(CM)
	return


/client/proc/cmd_admin_mass_set_colormatrix()
	set category = "Fun"
	set name = "Color-Filter EVERYONE"

	if(!check_rights(R_FUN))
		return

	var/definition = get_colormatrix_def_from_input()

	for(var/client/target in GLOB.clients)
		var/datum/array/CM = null

		if(!target)
			return

		if(definition)
			CM = new /datum/array(definition)

		target.color_transition(CM)
	return
