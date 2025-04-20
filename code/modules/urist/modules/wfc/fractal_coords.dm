// this is a generic data structure; currently only used for this in SS13, but might be moved out to a Generic Thing later.

/* X===============================X
** X      Fractal Coordinates      X
** X===============================X
**
** Implementation of Peter Mawhorter's Fractal Coordinates for Incremental Procedural Content Generation.
** https://cs.wellesley.edu/~pmwh/papers-fcpcg/FDG2021-Mawhorter-fractal-author.pdf
** http://web.archive.org/web/20230521191701/https://www.boristhebrave.com/2023/01/28/infinite-quadtrees-fractal-coordinates/
**
** This is a neat spatial data structure for 'zooming in/out' of blocks of tiles.
** In a lot of ways, this is like a classic quadtree/octtree (2d/3d respectively),
** but built *bottom-up* rather than by subdividing a predefined space allocation.
**
**
**  --- OK, but, like, why? ---
**
** In short, MAP REGIONS and NONLOCALITIES.
**
** Abstracting blocks is quite handy, because instead of processing dozens of tiles in a loop,
** we can check/store/query the 'megatiles' instead cheaply and quickly.
**
** This is good for stuff like mapgen, where we can place multitile prefabs
** (e.g. a 3x3 corridoor with surrounding walls) and/or make sure that macro-features
** like roads or rivers connect between them properly.
**
** Instead of going tile-to-tile, we can let regions 'talk to each other'
**
**
**  --- Fine, how many PhDs I need to implement this? ---
**
** The basic idea is that we can collapse tiles into ever-larger bundles, hierarchically.
**
** For example, a 3x3x1 2D block can be treated as a single extra-large abstract super-tile,
** a 9x9 block can be viewed as a 3x3 block of those chonky (3x3) super-tiles, and
** a 27x27 block can be viewed as a 3x3 block of 9x9 tiles amd so on.
**
** In the above example, the space grows by a scale factor of 3, but this can just as easily
** be 2 or 4 or 5 or whatever; odd-sized factors are a bit more convenient because they keep
** the center of the grid in the middle of an actual tile (= turf) as opposed to a corner.
**
** Practically speaking: the structure is really simple.
** We just add an extra coordinate, let's call it 'h', representing the 'grid zoom level'.
** We also pick a scale factor ('sf' for later) as above; I'll stick with 3 for the explanation.
**
** At h=0 we're at full resolution, where the block size == 'true' grid size (in SS13 terms,
** the abstract block corresponds directly to an actual map turf).
**
** At h=1 we zoom out by one scale factor, so in this case tiles with h=0 coords:
**
** (h=0, x=1, y=3), (h=0, x=2, y=3), (h=0, x=3, y=3),
** (h=0, x=1, y=2), (h=0, x=2, y=2), (h=0, x=3, y=2),
** (h=0, x=1, y=1), (h=0, x=2, y=1), (h=0, x=3, y=1)
**
** ...all get represented by the same h=1 coordinate, (h=1, x=1, y=1).
** Tiles to the right get (h=1, x=2, ...) and ones above get (h=1, ..., y=2) etc.
**
** At h=2, we do the same thing, except with h=1 coordinates - we collapse them to h=2 coordinates.
**
** You may have noticed by staring at the numbers that this is fairly easy to calculate superblock coords
** if we're dealing with SS13-style grids indexed by positive integers only:
** we simply do floor division plus one, i.e.:
**
** coord[h, dim] = 1 + ((coord[h-1, dim] - 1) // sf).
**
** Going in the opposite direction is a bit trickier, but still simple - simply generate child coords with for-loops.
** Unfortunately, the child coords are a Cartesian product of dimensions, so we have to do (sf ** dims) passes to do that.
*/

// Core formula for transforming a coordinate of lvl N to a coordinate of lvl (N+1)
//   Technically this could be simpler, but we'd have to sacrifice positive integer-based grid coords' consistency
// between the normal SS13 coords and fractal coords, which is Not Great.
//   So, this +1/-1 magic is used instead; it's basically a transform to origin at 0,
// followed by a compression, then another transform back to origin at 1.
//   If this confused you even further, don't worry, you don't really need to understand this,
// but anyone who has dealt with linear algebra a bunch will hopefully feel more at home seeing it.
# define FRACTCOORDS_DOWNSAMPLE_TRANSFORM(x, sf) 1 + WFC_MATH_FLOOR((x - 1) / sf)

// Pattern to parse 2D fractal coordinate strings quickly. <h>/<x>,<y>,<z>
# define TWOD_FRACTCOORDS_REGEX_PATTERN @"(\d+)/(\d+),(\d+),(\d+)"
# define TWOD_FRACTCOORDS_REGEX regex(@"(\d+)/(\d+),(\d+),(\d+)")


/proc/fractal_parents_twod_numerical(x, y, z, h = 0, sf = 3)
	ASSERT(!(isnull(sf)))
	ASSERT(!(sf == 0))

	var/new_h = h + 1
	var/new_x = FRACTCOORDS_DOWNSAMPLE_TRANSFORM(x, sf)
	var/new_y = FRACTCOORDS_DOWNSAMPLE_TRANSFORM(y, sf)
	var/new_z = z

	var/outstr = "[new_h]/[new_x],[new_y],[new_z]"
	return outstr


/proc/fractal_parents_str(dimstring, sf = 3, threeD = FALSE)
	ASSERT(!(isnull(sf)))
	ASSERT(!(sf == 0))

	if(isnull(dimstring))
		return

	var/regex/matcher = TWOD_FRACTCOORDS_REGEX
	matcher.Find(dimstring)

	var/list/groups = matcher.group

	ASSERT(length(groups) == 4)

	var/in_h = text2num(groups[1])
	var/in_x = text2num(groups[2])
	var/in_y = text2num(groups[3])
	var/in_z = text2num(groups[4])

	var/new_h = in_h + 1
	var/new_x = FRACTCOORDS_DOWNSAMPLE_TRANSFORM(in_x, sf)
	var/new_y = FRACTCOORDS_DOWNSAMPLE_TRANSFORM(in_y, sf)
	var/new_z = threeD ? FRACTCOORDS_DOWNSAMPLE_TRANSFORM(in_z, sf) : in_z

	var/outstr = "[new_h]/[new_x],[new_y],[new_z]"
	return outstr


/proc/fractal_children_str(dimstring, sf = 3)
	//ASSERT(!(isnull(sf)))
	ASSERT(!(sf == 0))

	if(isnull(dimstring))
		return

	var/regex/matcher = TWOD_FRACTCOORDS_REGEX
	matcher.Find(dimstring)

	var/list/groups = matcher.group

	ASSERT(length(groups) == 4)

	var/in_h = text2num(groups[1])
	var/in_x = text2num(groups[2])
	var/in_y = text2num(groups[3])
	var/in_z = text2num(groups[4])

	var/list/outputs = list()

	var/new_h = in_h - 1

	for(var/ydim_offset = 1, ydim_offset <= sf, ydim_offset++)
		for(var/xdim_offset = 1, xdim_offset <= sf, xdim_offset++)
			// note: no 3d for now, but it'd just be one more nesting right here
			var/new_x = ((in_x - 1) * sf) + xdim_offset
			var/new_y = ((in_y - 1) * sf) + ydim_offset
			var/new_z = in_z

			var/outstr = "[new_h]/[new_x],[new_y],[new_z]"
			outputs.Add(outstr)

	return outputs


/*
// Testing stuff.

/mob/verb/test_frac_parents(inp as text)
	set category = "Fractal Coords Debug"
	var/result = fractal_parents_str(inp)
	to_chat(usr, result)


/mob/verb/test_frac_children(inp as text)
	set category = "Fractal Coords Debug"
	var/list/result = fractal_children_str(inp)
	to_chat(usr, json_encode(result))


/mob/verb/test_frac_bothways(inp as text)
	set category = "Fractal Coords Debug"
	var/true_inp = ((!inp) ? "1/2,3,4" : inp)
	to_chat(usr, true_inp)

	var/result_par = fractal_parents_str(true_inp)
	to_chat(usr, result_par)

	var/list/result_chi = fractal_children_str(result_par)
	to_chat(usr, json_encode(result_chi))
*/
