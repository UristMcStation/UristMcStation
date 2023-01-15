# define FLOOR(x) round(x)
# define CEIL(x) -round(-x)
# define SQR(x) ((x) * (x))

# ifdef GOAI_LIBRARY_FEATURES
/*
/proc/floor(x)
	return round(x)
# endif

/proc/ceil(x)
	return -round(-x)
*/
# endif

# define sign(x) (x / abs(x))


/proc/greater_than(var/left, var/right)
	var/result = left > right
	return result


/proc/greater_or_equal_than(var/left, var/right)
	var/result = left >= right
	return result


/proc/dir2name(var/dir)
	var/qry = "[dir]"

	var/list/lookup = list(
		"1" = "NORTH",
		"2" = "SOUTH",
		"4" = "EAST",
		"8" = "WEST",
		"5" = "NORTHEAST",
		"9" = "NORTHWEST",
		"6" = "SOUTHEAST",
		"10" = "SOUTHWEST",
		"16" = "UP",
		"32" = "DOWN"
	)

	var/result = lookup[qry]
	return result


/proc/dir2opposite(var/dir)
	var/result = null

	switch(dir)
		if(SOUTH) result = NORTH
		if(NORTH) result = SOUTH
		if(WEST)  result = EAST
		if(EAST)  result = WEST
		if(NORTHEAST) result = SOUTHWEST
		if(NORTHWEST) result = SOUTHEAST
		if(SOUTHEAST) result = NORTHWEST
		if(SOUTHWEST) result = NORTHEAST
		if(UP) result = DOWN
		if(DOWN) result = UP

	return result

