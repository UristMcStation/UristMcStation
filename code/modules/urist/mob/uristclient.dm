/client
	//vg color code
	var/updating_color = 0

/client/proc/color_transition(var/color_to=null, var/time=10)	// call this with no parametres to reset to default.
	var/datum/array/target_array = color_to
	if(!(target_array))
		target_array = new DEFAULT_COLOR_MATRIX()

	var/list/new_color = target_array.get()

	if(!color)
		color = new_color

	animate(src, color=new_color, time=time, easing=SINE_EASING)
