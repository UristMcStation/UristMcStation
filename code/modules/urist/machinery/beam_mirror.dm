/obj/machinery/beam_mirror // i'l probably regret this.
	name = "beam collimator"
	desc = "A specially designed mirror that redirects photonic energy into a singular direction."
	icon = 'icons/urist/beam_mirrors.dmi'
	icon_state = "reflector_base"
	density = 1
	dir = NORTH
	var/degrees_from_north = 0 //needed for vectors
	var/compass_directions = list("North", "South", "East", "West")

/obj/machinery/beam_mirror/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj, /obj/item/projectile/beam/))
		var/new_x = (1 * round(10 * cos(degrees_from_north - 90))) + x //Vectors vectors vectors.
		var/new_y = (-1 * round(10 * sin(degrees_from_north - 90))) + y
		var/turf/curloc = get_turf(src)
		Proj.penetrating += 1
		Proj.redirect(new_x, new_y, curloc, null)
	else
		return

/obj/machinery/beam_mirror/verb/rotate_clockwise()
	set category = "Object"
	set name = "Rotate Mirror"
	set src in view(1)

	if (usr.stat || usr.restrained() || anchored)
		return
	var/choice = input("What point do you want to set \the [src] to?", "[name]") as null|anything in compass_directions
	switch(choice)
		if("North")
			dir = NORTH
			degrees_from_north = 0
		if("South")
			dir = SOUTH
			degrees_from_north = 180
		if("East")
			dir = EAST
			degrees_from_north = 90
		if("West")
			dir = WEST
			degrees_from_north = 270
