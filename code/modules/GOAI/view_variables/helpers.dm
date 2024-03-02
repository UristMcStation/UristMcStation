# ifdef GOAI_LIBRARY_FEATURES

// Keep these two together, they *must* be defined on both
// If /client ever becomes /datum/client or similar, they can be merged
/datum/proc/get_view_variables_header()
	return "<b>[src]</b>"

/atom/get_view_variables_header()
	return {"
		<a href='?_src_=vars;datumedit=\ref[src];varnameedit=name'><b>[src]</b></a>
		<br><font size='1'>
		<a href='?_src_=vars;rotatedatum=\ref[src];rotatedir=left'><<</a>
		<a href='?_src_=vars;datumedit=\ref[src];varnameedit=dir'>[dir2text(dir)]</a>
		<a href='?_src_=vars;rotatedatum=\ref[src];rotatedir=right'>>></a>
		</font>
		"}

/mob/living/get_view_variables_header()
	return {"
		<a href='?_src_=vars;rename=\ref[src]'><b>[src]</b></a><font size='1'>
		<br><a href='?_src_=vars;rotatedatum=\ref[src];rotatedir=left'><<</a> <a href='?_src_=vars;datumedit=\ref[src];varnameedit=dir'>[dir2text(dir)]</a> <a href='?_src_=vars;rotatedatum=\ref[src];rotatedir=right'>>></a>
		<br><a href='?_src_=vars;datumedit=\ref[src];varnameedit=ckey'>[ckey ? ckey : "No ckey"]</a> / <a href='?_src_=vars;datumedit=\ref[src];varnameedit=real_name'>[real_name ? real_name : "No real name"]</a>
		<br>
		</font>
		"}

// Same for these as for get_view_variables_header() above
/datum/proc/get_view_variables_options()
	return ""

/mob/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;mob_player_panel=\ref[src]'>Show player panel</option>
		<option>---</option>
		<option value='?_src_=vars;direct_control=\ref[src]'>Assume Direct Control</option>
		<option>---</option>
		"}

/mob/living/get_view_variables_options()
	return ..() + {"
		"}

/mob/living/carbon/human/get_view_variables_options()
	return ..() + {"
		"}

/obj/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;delthis=\ref[src]'>Delete instance</option>
		<option value='?_src_=vars;delall=\ref[src]'>Delete all of type</option>
		"}

/turf/get_view_variables_options()
	return ..() + {"
		"}

/datum/proc/get_variables()
	. = vars - VV_hidden()

/datum/proc/get_variable_value(varname)
	return vars[varname]

/datum/proc/set_variable_value(varname, value)
	vars[varname] = value

/datum/proc/get_initial_variable_value(varname)
	return initial(vars[varname])

/datum/proc/make_view_variables_variable_entry(var/varname, var/value, var/hide_watch = 0)
	return {"
			(<a href='?_src_=vars;datumedit=\ref[src];varnameedit=[varname]'>E</a>)
			(<a href='?_src_=vars;datumchange=\ref[src];varnamechange=[varname]'>C</a>)
			(<a href='?_src_=vars;datummass=\ref[src];varnamemass=[varname]'>M</a>)
			"}

/*
// No mass editing of clients
/client/make_view_variables_variable_entry(var/varname, var/value, var/hide_watch = 0)
	return {"
			(<a href='?_src_=vars;datumedit=\ref[src];varnameedit=[varname]'>E</a>)
			(<a href='?_src_=vars;datumchange=\ref[src];varnamechange=[varname]'>C</a>)
			[hide_watch ? "" : "(<a href='?_src_=vars;datumwatch=\ref[src];varnamewatch=[varname]'>W</a>)"]
			"}
*/

// These methods are all procs and don't use stored lists to avoid VV exploits

// The following vars cannot be viewed by anyone
/datum/proc/VV_hidden()
	return list()

// The following vars can only be viewed by R_ADMIN|R_DEBUG
/datum/proc/VV_secluded()
	return list()

/datum/configuration/VV_secluded()
	return vars

// The following vars cannot be edited by anyone
/datum/proc/VV_static()
	return list("parent_type")

/atom/VV_static()
	return ..() + list("bound_x", "bound_y", "bound_height", "bound_width", "bounds", "step_x", "step_y", "step_size")

/datum/admins/VV_static()
	return vars

// The following vars require R_DEBUG to edit
/datum/proc/VV_locked()
	return list("vars", "virus", "viruses", "cuffed")

/mob/VV_locked()
	return ..() + list("client")

// The following vars require R_FUN|R_DEBUG to edit
/datum/proc/VV_icon_edit_lock()
	return list()

/atom/VV_icon_edit_lock()
	return ..() + list("icon", "icon_state", "overlays", "underlays")

// The following vars require R_SPAWN|R_DEBUG to edit
/datum/proc/VV_ckey_edit()
	return list()

/mob/VV_ckey_edit()
	return list("key", "ckey")

/datum/proc/may_edit_var(var/user, var/var_to_edit)
	if(!user)
		return FALSE
	if(!(var_to_edit in vars))
		to_chat(user, "<span class='warning'>\The [src] does not have a var '[var_to_edit]'</span>")
		return FALSE
	if(var_to_edit in VV_static())
		return FALSE
	return TRUE

/proc/forbidden_varedit_object_types()
 	return list(
		/datum/admins						//Admins editing their own admin-power object? Yup, sounds like a good idea.
	)

#endif
