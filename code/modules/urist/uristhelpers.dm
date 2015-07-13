/////////////////////////////////////////////////////////
/* A FILE FOR ASSORTED HELPER PROCS USED BY URIST CODE */
/////////////////////////////////////////////////////////

//vg/ proc, used by vampire mode. Should be self-explanatory.//

/mob/living/carbon/human/proc/is_on_ears(var/typepath)
	return max(istype(l_ear,typepath),istype(r_ear,typepath))

//checks if a given text's characters are allowed hexadecimal values, null on failure

/proc/ishex(var/String, var/Start = 1, var/End = 0)
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

/proc/hex2rgblist(var/Color)
	if (!(istext(Color)))
		return

	var/ColorR = 0
	var/ColorG = 0
	var/ColorB = 0
	var/ColorA = 255

	Color = uppertext(Color) //just in case

	if(!(findtext(Color, "#", 1, 2)))
		world.log << "Please use a # before hex color values for hex2rgb."
		return

	if(!(ishex(Color, 2, 9)))
		world.log << "Value for hex2rgb contains non-hexadecimal characters."
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
			world.log << "Please use a full #RRGGBB(AA) format for hex2rgb"

	var/list/rgbcolors = list(ColorR, ColorG, ColorB, ColorA)
	return rgbcolors

//takes a list of rgb colors and picks out a color; 1 for Red, 2 for Green, etc.
/proc/GetColorFromRGB(var/list/L, var/Color = 1)
	if (!L)
		return
	var/colorvalue = L[Color]
	return colorvalue

//weightless, 2 color Average blend with adjustable min/max values (low/high respectively).
/proc/SimpleOneColorMix(var/color1 = 0, var/color2 = 0, var/low = 0, var/high = 255, var/ignorezeros)

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
			resultcolor = Clamp(color2, low, high)
		else if(color2 == 0)
			resultcolor = Clamp(color1, low, high)
		else
			resultcolor = Clamp(((color1 + color2)/2), low, high)
	else
		resultcolor = Clamp(((color1 + color2)/2), low, high)
	return resultcolor

//as above, but handles 2 RGB color lists and the min/max are for lightness; defaults to unbound, so can be black to white)
//assumes it's just RGB, not RGBA, for RGBA use MixColors with alpha as weights or whatever

/proc/SimpleRGBMix(var/list/ColorsA, var/list/ColorsB, var/low = 0, var/high = 765) //3*255
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