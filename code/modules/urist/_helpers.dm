/////////////////////////////////////////////////////////
/* A FILE FOR ASSORTED HELPER PROCS USED BY URIST CODE */
/////////////////////////////////////////////////////////

//vg/ proc, used by vampire mode. Should be self-explanatory.//

/mob/living/carbon/human/proc/is_on_ears(typepath)
	return max(istype(l_ear,typepath),istype(r_ear,typepath))

//checks if a given text's characters are allowed hexadecimal values, null on failure

/proc/ishex(String, var/Start = 1, var/End = 0)
	if(!(istext(String)))
		return

	End = round(End)
	if(End < 0)
		End = (length(String) + End) //supports reading from the back, same as BYOND native procs

	if((End > length(String)) || (End == 0))
		End = length(String)

	Start = round(Start)
	if(Start < 0)
		Start = (length(String) + Start)

	if((Start > End) && (End > 0)) //weird case, but you can use it to skip characters inside a sequence, in cases like FCFlelhexABA
		var/back = copytext(String, Start)
		var/front = copytext(String, 1, (End + 1))
		String = back + front

	for(var/i=Start, i<=End, i++)
		switch(text2ascii(String,i))
			if(48 to 57) //0-9
				continue
			if(65 to 70) //A-F
				continue
			else
				return
	return 1

//complementary to BYOND's rgb() proc - instead of turning a rgba value to a #RRGGBB(AA) hex, turns a hex into a rgb value.
//kinda reduntant with GetHexColors, but more idiot-proof.

/proc/hex2rgblist(Color)
	if (!(istext(Color)))
		return

	var/ColorR = 0
	var/ColorG = 0
	var/ColorB = 0
	var/ColorA = 255

	Color = uppertext(Color) //just in case

	if(!(findtext(Color, "#", 1, 2)))
		to_world_log("Please use a # before hex color values for hex2rgb.")
		return

	if(!(ishex(Color, 2, 9)))
		to_world_log("Value for hex2rgb contains non-hexadecimal characters.")
		return

	switch(length(Color))
		if(9)
			ColorR = (hex2num(copytext(Color, 2, 4)))
			ColorG = (hex2num(copytext(Color, 4, 6)))
			ColorB = (hex2num(copytext(Color, 6, 8)))
			ColorA = (hex2num(copytext(Color, 8, 10)))
		if(7)
			ColorR = (hex2num(copytext(Color, 2, 4)))
			ColorG = (hex2num(copytext(Color, 4, 6)))
			ColorB = (hex2num(copytext(Color, 6, 8)))
			ColorA = 255
		else //I cannot be bothered to code handling trunctation just yet.
			to_world_log("Please use a full #RRGGBB(AA) format for hex2rgb")

	var/list/rgbcolors = list(ColorR, ColorG, ColorB, ColorA)
	return rgbcolors

//takes a list of rgb colors and picks out a color; 1 for Red, 2 for Green, etc.
/proc/GetColorFromRGB(list/L, var/Color = 1)
	if (!L)
		return
	var/colorvalue = L[Color]
	return colorvalue

//weightless, 2 color Average blend with adjustable min/max values (low/high respectively).
/proc/SimpleOneColorMix(color1 = 0, var/color2 = 0, var/low = 0, var/high = 255, var/ignorezeros)

	if((!(isnum(color1))) || (!(isnum(color2))))
		return

	color1 = round(color1)
	color2 = round(color2)

	if(low > high)
		return

	var/resultcolor = 0

	if(ignorezeros) //prevents very pure colors from averaging asymptotically to black
		//note that the parameter being set to 1 makes the coloring non-symmetrical!
		if(color1 == 0)
			resultcolor = clamp(color2, low, high)
		else if(color2 == 0)
			resultcolor = clamp(color1, low, high)
		else
			resultcolor = clamp(((color1 + color2)/2), low, high)
	else
		resultcolor = clamp(((color1 + color2)/2), low, high)
	return resultcolor

//as above, but handles 2 RGB color lists and the min/max are for lightness; defaults to unbound, so can be black to white)
//assumes it's just RGB, not RGBA, for RGBA use MixColors with alpha as weights or whatever

/proc/SimpleRGBMix(list/ColorsA, var/list/ColorsB, var/low = 0, var/high = 765) //3*255
	if((!ColorsA) || (!ColorsB) || (!(length(ColorsA) == length(ColorsB))))
		return
	var/results[3]
	for(var/i = 1, i <= 3, i++)
		var/CA = GetColorFromRGB(ColorsA, i)
		var/CB = GetColorFromRGB(ColorsB, i)
		results[i] = SimpleOneColorMix(CA, CB)


	var/lightness = (results[1] + results[2] + results[3]) //basically an average, but it's easier to use that way

	if(lightness < low)
		var/adjustment = round(((low - lightness) / 3),1)
		for(var/i = 1, i <= 3, i++)
			results[i] += adjustment

	if(lightness > high)
		var/adjustment = round(((lightness - high) / 3),1)
		for(var/i = 1, i <= 3, i++)
			results[i] -= adjustment

	return results

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
* rough example of the "cone" made by the 3 dirs checked
*
*   B
*    \
*     \
*      >
*       <
*        \
*         \
* B --><-- A
*   	  /
*        /
*       <
*      >
*     /
*    /
*   B
*
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

/*/proc/screen_loc2turf(scr_loc, turf/origin)
	var/tX = splittext(scr_loc, ",")
	var/tY = splittext(tX[2], ":")
	var/tZ = origin.z
	tY = tY[1]
	tX = splittext(tX[1], ":")
	tX = tX[1]
	tX = max(1, min(world.maxx, origin.x + (text2num(tX) - (world.view + 1))))
	tY = max(1, min(world.maxy, origin.y + (text2num(tY) - (world.view + 1))))
	return locate(tX, tY, tZ)*/

/proc/random_step(atom/movable/AM, steps, chance)
	var/initial_chance = chance
	while(steps > 0)
		if(prob(chance))
			step(AM, pick(GLOB.alldirs))
		chance = max(chance - (initial_chance / steps), 0)
		steps--

/proc/living_player_count()
	var/living_player_count = 0
	for(var/mob in GLOB.player_list)
		if(mob in GLOB.living_players)
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

/*/proc/get_turf_pixel(atom/movable/AM)
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
			qdel(AMicon) //qdel

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


//Interface for using DrawBox() to draw 1 pixel on a coordinate.
//Returns the same icon specifed in the argument, but with the pixel drawn
/proc/DrawPixel(icon/I,var/colour,var/drawX,var/drawY)
	if(!I)
		return 0
	var/Iwidth = I.Width()
	var/Iheight = I.Height()
	if(drawX > Iwidth || drawX <= 0)
		return 0
	if(drawY > Iheight || drawY <= 0)
		return 0
	I.DrawBox(colour,drawX, drawY)
	return I

//Interface for easy drawing of one pixel on an atom.
/atom/proc/DrawPixelOn(colour, var/drawX, var/drawY)
	var/icon/I = new(icon)
	var/icon/J = DrawPixel(I, colour, drawX, drawY)
	if(J) //Only set the icon if it succeeded, the icon without the pixel is 1000x better than a black square.
		icon = J
		return J
	return 0*/

//Monkeys et al being a human type mess with the purpose of regular ishuman; ishumanoid is intended to check strictly 'sentient' races
/proc/ishumanoid(A)
	if(istype(A, /mob/living/carbon/human) && !(istype (A, /mob/living/carbon/human/monkey)) && !(istype (A, /mob/living/carbon/human/stok)) && !(istype (A, /mob/living/carbon/human/farwa))) // && !(istype (A, /mob/living/carbon/human/neara)))
		return 1 //whoever thought subtyping all these under /human/monkey or whatever was a bad idea is literally Hitler
	return 0

//Creates a lying down icon by matrix transform. Made it a helper for less boilerplate --scr.
/mob/proc/matrix_groundicon(turndegrees = 90)
	var/matrix/M = matrix() //shamelessly stolen from human update_icons
	M.Turn(turndegrees)
	M.Translate(1,-6)
	src.transform = M

/proc/get_light_amt(turf/T, var/ignore_red = 0)
	// Stolen from diona/life.dm since it was needed in various places. Ignore_red parameter for extra spoopy.
	var/light_amount = 0
	var/atom/movable/lighting_overlay/L = locate(/atom/movable/lighting_overlay) in T

	if(L)
		if(ignore_red)
			light_amount = L.lum_g + L.lum_b
		else
			light_amount = L.lum_r + L.lum_g + L.lum_b //hardcapped so it's not abused by having a ton of flashlights
	else
		light_amount =  10

	return light_amount

/proc/shadow_check(turf/T, var/max_light = 2, var/or_equal = 0)
	//True if light below max_light threshold, false otherwise
	var/light_amt = get_light_amt(T)
	if(or_equal)
		if(light_amt <= max_light)
			return 1
	else
		if(light_amt < max_light)
			return 1
	return 0

//for throwing things from one turf to another

/proc/launch_atom(var/projectile_type, var/turf/start_turf, var/turf/target_turf)
	if(ispath(projectile_type))
		var/atom/movable/projectile = new projectile_type(start_turf)
		if(istype(projectile, /obj/item/projectile))
			var/obj/item/projectile/P = projectile
			P.launch(target_turf) //projectiles have their own special proc

		else if(istype(projectile, /obj/meteor))
			var/obj/meteor/M = projectile
			M.dest = target_turf
			spawn(0)
				walk_towards(M, M.dest, 3) //meteors do their own thing too

		else
			projectile.throw_at(target_turf) //anything else just uses the default throw proc. this potentially allows for ship weapons that do things like throw mobs. clown cannon anyone?

//bay removed this area proc for some reason. it gets the contents in an area
/area/proc/get_contents()
	return contents
