/client/proc/color_transition(color_to=null, var/time=10) // call with no parametres to reset to default.
	var/datum/array/cached = src.cached_colormatrix
	var/datum/array/target_array = color_to || DEFAULT_COLOR_MATRIX

	var/list/new_color = target_array.get()
	var/list/old_color = cached ? null : cached.get()

	if(old_color != new_color)
		src.cached_colormatrix = target_array
		GLOB.colormatrix_set_event.raise_event(src, old_color, new_color)
		animate(src, color=new_color, time=time, easing=SINE_EASING)


//	Observer Pattern Implementation: Client Color Set
//		Registration type: /client
//
//		Raised when: A client's color value (i.e. the color filter applied) is changed.
//
//		Arguments that the called proc should expect:
//			/client/invisibilee:  The client that had its color set
//			/list/old_matrix: client.color before the change
//			/list/new_matrix: client.color after the change

GLOBAL_DATUM_INIT(colormatrix_set_event, /singleton/observ/colormatrix_set, new)

/singleton/observ/colormatrix_set
	name = "Client Color Set"
	expected_type = /client
