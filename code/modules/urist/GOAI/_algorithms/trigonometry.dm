# ifdef GOAI_LIBRARY_FEATURES

// Trigonometric functions.
/proc/Tan(x)
	return sin(x) / cos(x)

/proc/Csc(x)
	return 1 / sin(x)

/proc/Sec(x)
	return 1 / cos(x)

/proc/Cot(x)
	return 1 / Tan(x)

/proc/Atan2(x, y)
	if(!x && !y) return 0
	var/a = arccos(x / sqrt(x*x + y*y))
	return y >= 0 ? a : -a

/proc/angle2dir(var/angle)
	var/true_angle = round(CLOCKWISE_ANGLE(angle))
	var/direction = null

	switch (true_angle)
		if (0 to 44) direction = EAST
		if (45 to 89) direction = NORTHEAST
		if (90 to 134) direction = NORTH
		if (135 to 179) direction = NORTHWEST
		if (180 to 224) direction = WEST
		if (225 to 269) direction = SOUTHWEST
		if (270 to 314) direction = SOUTH
		if (315 to 360) direction = SOUTHEAST

	return direction

# endif