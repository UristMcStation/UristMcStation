//Get the dir to the RIGHT of dir if they were on a clock
//NORTH --> NORTHEAST
/proc/get_clockwise_dir(dir)
	. = angle2dir(dir2angle(dir)+45)

//Get the dir to the LEFT of dir if they were on a clock
//NORTH --> NORTHWEST
/proc/get_anticlockwise_dir(dir)
	. = angle2dir(dir2angle(dir)-45)


//Compare A's dir, the clockwise dir of A and the anticlockwise dir of A
//To the opposite dir of the dir returned by get_dir(B,A)
//If one of them is a match, then A is facing B
/proc/is_A_facing_B(atom/A,atom/B)
	if(!istype(A) || !istype(B))
		return 0
	if(istype(A, /mob/living))
		var/mob/living/LA = A
		if(LA.lying)
			return 0
	var/goal_dir = angle2dir(dir2angle(get_dir(B,A)+180))
	var/clockwise_A_dir = get_clockwise_dir(A.dir)
	var/anticlockwise_A_dir = get_anticlockwise_dir(B.dir)

	if(A.dir == goal_dir || clockwise_A_dir == goal_dir || anticlockwise_A_dir == goal_dir)
		return 1
	return 0


/*
rough example of the "cone" made by the 3 dirs checked

 B
  \
   \
    >
      <
       \
        \
B --><-- A
        /
       /
      <
     >
    /
   /
 B

*/


/atom/movable/var/atom/orbiting = null
//This is just so you can stop an orbit.
//orbit() can run without it (swap orbiting for A)
//but then you can never stop it and that's just silly.

/atom/movable/proc/orbit(atom/A, radius = 10, clockwise = 1, angle_increment = 15)
	if(!istype(A))
		return
	orbiting = A
	var/angle = 0
	var/matrix/initial_transform = matrix(transform)
	spawn
		while(orbiting)
			loc = orbiting.loc

			angle += angle_increment

			var/matrix/shift = matrix(initial_transform)
			shift.Translate(radius,0)
			if(clockwise)
				shift.Turn(angle)
			else
				shift.Turn(-angle)
			animate(src,transform = shift,2)

			sleep(0.6) //the effect breaks above 0.6 delay
		animate(src,transform = initial_transform,2)


/atom/movable/proc/stop_orbit()
	if(orbiting)
		loc = get_turf(orbiting)
		orbiting = null

/proc/screen_loc2turf(scr_loc, turf/origin)
	var/tX = text2list(scr_loc, ",")
	var/tY = text2list(tX[2], ":")
	var/tZ = origin.z
	tY = tY[1]
	tX = text2list(tX[1], ":")
	tX = tX[1]
	tX = max(1, min(world.maxx, origin.x + (text2num(tX) - (world.view + 1))))
	tY = max(1, min(world.maxy, origin.y + (text2num(tY) - (world.view + 1))))
	return locate(tX, tY, tZ)

/proc/random_step(atom/movable/AM, steps, chance)
	var/initial_chance = chance
	while(steps > 0)
		if(prob(chance))
			step(AM, pick(alldirs))
		chance = max(chance - (initial_chance / steps), 0)
		steps--

/proc/living_player_count()
	var/living_player_count = 0
	for(var/mob in player_list)
		if(mob in living_mob_list)
			living_player_count += 1
	return living_player_count

/proc/randomColor(mode = 0)	//if 1 it doesn't pick white, black or gray
	switch(mode)
		if(0)
			return pick("white","black","gray","red","green","blue","brown","yellow","orange","darkred",
						"crimson","lime","darkgreen","cyan","navy","teal","purple","indigo")
		if(1)
			return pick("red","green","blue","brown","yellow","orange","darkred","crimson",
						"lime","darkgreen","cyan","navy","teal","purple","indigo")
		else
			return "white"

//Gets the turf this atom's *ICON* appears to inhabit
//Uses half the width/height respectively to work out
//A minimum pixel amt this icon needs to be pixel'd by
//to be considered to be in another turf

//division = world.icon_size - icon-width/2; DX = pixel_x/division
//division = world.icon_size - icon-height/2; DY = pixel_y/division

//Eg: Humans
//32 - 16; 16/16 = 1, DX = 1
//32 - 16; 15/16 = 0.9375 = 0 when round()'d, DX = 0

//NOTE: if your atom has non-standard bounds then this proc
//will handle it, but it'll be a bit slower.

/proc/get_turf_pixel(atom/movable/AM)
	if(istype(AM))
		var/rough_x = 0
		var/rough_y = 0
		var/final_x = 0
		var/final_y = 0

		//Assume standards
		var/i_width = world.icon_size
		var/i_height = world.icon_size

		//Handle snowflake objects only if necessary
		if(AM.bound_height != world.icon_size || AM.bound_width != world.icon_size)
			var/icon/AMicon = icon(AM.icon, AM.icon_state)
			i_width = AMicon.Width()
			i_height = AMicon.Height()
			del(AMicon) //qdel

		//Find a value to divide pixel_ by
		var/n_width = (world.icon_size - (i_width/2))
		var/n_height = (world.icon_size - (i_height/2))

		//DY and DX
		if(n_width)
			rough_x = round(AM.pixel_x/n_width)
		if(n_height)
			rough_y = round(AM.pixel_y/n_height)

		//Find coordinates
		final_x = AM.x + rough_x
		final_y = AM.y + rough_y

		if(final_x || final_y)
			return locate(final_x, final_y, AM.z)

//Finds the distance between two atoms, in pixels
//centered = 0 counts from turf edge to edge
//centered = 1 counts from turf center to turf center
//of course mathematically this is just adding world.icon_size on again
/proc/getPixelDistance(atom/A, atom/B, centered = 1)
	if(!istype(A)||!istype(B))
		return 0
	. = bounds_dist(A, B) + sqrt((((A.pixel_x+B.pixel_x)**2) + ((A.pixel_y+B.pixel_y)**2)))
	if(centered)
		. += world.icon_size
