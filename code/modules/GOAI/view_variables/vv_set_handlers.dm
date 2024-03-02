# ifdef GOAI_LIBRARY_FEATURES

/decl/vv_set_handler
	var/handled_type
	var/predicates
	var/list/handled_vars

/decl/vv_set_handler/proc/can_handle_set_var(var/datum/O, variable, var_value, client)
	if(!istype(O, handled_type))
		return FALSE
	if(!(variable in handled_vars))
		return FALSE
	if(istype(O) && !(variable in O.vars))
		return FALSE
	if(predicates)
		for(var/predicate in predicates)
			if(!call(predicate)(var_value, client))
				return FALSE
	return TRUE

/decl/vv_set_handler/proc/handle_set_var(var/datum/O, variable, var_value, client)
	var/proc_to_call = handled_vars[variable]
	if(proc_to_call)
		call(O, proc_to_call)(var_value)
	else
		O.vars[variable] = var_value

/decl/vv_set_handler/location_hander
	handled_type = /atom/movable
	handled_vars = list("loc","x","y","z")

/decl/vv_set_handler/location_hander/handle_set_var(var/atom/movable/AM, variable, var_value, client)
	if(variable == "loc")
		if(istype(var_value, /atom) || isnull(var_value) || var_value == "")	// Proper null or empty string is fine, 0 is not
			AM.forceMove(var_value)
		else
			to_chat(client, "<span class='warning'>May only assign null or /atom types to loc.</span>")
	else if(variable == "x" || variable == "y" || variable == "z")
		if(istext(var_value))
			var_value = text2num(var_value)
		if(!is_num_predicate(var_value, client))
			return

		// We set the default to 1,1,1 when at 0,0,0 (i.e. any non-turf location) to mimic the standard BYOND behaviour when adjusting x,y,z directly
		var/x = AM.x || 1
		var/y = AM.y || 1
		var/z = AM.z || 1
		switch(variable)
			if("x")
				x = var_value
			if("y")
				y = var_value
			if("z")
				z = var_value

		var/turf/T = locate(x,y,z)
		if(T)
			AM.forceMove(T)
		else
			to_chat(client, "<span class='warning'>Unable to locate a turf at [x]-[y]-[z].</span>")

#endif
