/client
	//vg color code
	var/updating_colour = 0

/client/proc/colour_transition(var/list/colour_to = default_colour_matrix,var/time = 10)	// call this with no parametres to reset to default.
	if(!color)
		color = default_colour_matrix
	if(!(colour_to.len))
		colour_to = default_colour_matrix
	animate(src, color=colour_to, time=time, easing=SINE_EASING)