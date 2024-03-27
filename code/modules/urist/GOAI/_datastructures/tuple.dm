/*
// ==   N-tuple types   ==
// Basically just a fixed-size list, not a Trve(TM) tuple, since it's mutable.
//
// Just helps ensure we get outputs of expected size at compile-time
// (of course with DM being DM, if they aren't, we just get a NULL, yey)
//
// This could be fairly trivially replaced with normal DM lists, but
// it's a bit more readable and I can't be bothered to refactor it.
*/

/datum/Tuple
	var/left = null
	var/right = null


/datum/Tuple/New(var/fst, var/snd)
	left = fst
	right = snd


/datum/Tuple/proc/operator~=(var/datum/Tuple/other)
	return (istype(other) && (left == other?.left) && (right == other?.right))


/datum/Tuple/proc/FirstCompare(var/datum/Tuple/left, var/datum/Tuple/right)
	// returns -1 if Right > Left
	// returns 1 if Right < Left
	// return 0 if Right == Left

	// Does not care about the second item - first item is the sort key.

	if (right.left > left.left)
		return -1

	if (right.left < left.left)
		return 1

	return 0



/datum/Tuple/proc/TupleCompare(var/datum/Tuple/left, var/datum/Tuple/right)
	// returns -1 if Right > Left
	// returns 1 if Right < Left
	// return 0 if Right == Left

	if (right.left > left.left)
		return -1

	if (right.left < left.left)
		return 1

	if (right.right > left.right)
		return -1

	if (right.right < left.right)
		return 1

	return 0


/datum/Triple
	var/left = null
	var/middle = null
	var/right = null


/datum/Triple/New(var/new_left, var/new_mid, var/new_right)
	left = new_left
	middle = new_mid
	right = new_right


/datum/Triple/proc/operator~=(var/datum/Triple/other)
	return (istype(other) && (left == other?.left) && (middle == other?.middle) && (right == other?.right))


/datum/Triple/proc/FirstTwoCompare(var/datum/Triple/left, var/datum/Triple/right)
	// returns 1 if Right > Left
	// returns -1 if Right < Left
	// return 0 if Right == Left

	// Does not care about the last item - first two are the hierarchical sort key.

	// NOTE: THIS IS *INVERTED* FROM THE USUAL COMPARISON - we want highest positions in the lowest locations here

	if (right.left > left.left)
		return 1

	if (right.left < left.left)
		return -1

	if (right.middle > left.middle)
		return 1

	if (right.middle < left.middle)
		return -1

	return 0


/datum/Quadruple
	var/first = null
	var/second = null
	var/third = null
	var/fourth = null


/datum/Quadruple/New(var/new_first, var/new_second, var/new_third, var/new_fourth)
	first = new_first
	second = new_second
	third = new_third
	fourth = new_fourth


/datum/Quadruple/proc/operator~=(var/datum/Quadruple/other)
	return (istype(other) && (first == other?.first) && (second == other?.second) && (third == other?.third) && (fourth == other?.fourth))


/datum/Quadruple/proc/QuadCompare(var/datum/Quadruple/left, var/datum/Quadruple/right)
	// returns -1 if Right > Left
	// returns 1 if Right < Left
	// return 0 if Right == Left

	if (right.first > left.first)
		return -1

	if (right.first < left.first)
		return 1

	if (right.second > left.second)
		return -1

	if (right.second < left.second)
		return 1

	if (right.third > left.third)
		return -1

	if (right.third < left.third)
		return 1

	if (right.fourth > left.fourth)
		return -1

	if (right.fourth < left.fourth)
		return 1

	return 0


/datum/Quadruple/proc/TriCompare(var/datum/Quadruple/left, var/datum/Quadruple/right)
	// returns -1 if Right > Left
	// returns 1 if Right < Left
	// return 0 if Right == Left

	if (left.first < right.first)
		return -1

	if (left.first > right.first)
		return 1

	if (left.second < right.second)
		return -1

	if (left.second > right.second)
		return 1

	if (left.third < right.third)
		return -1

	if (left.third > right.third)
		return 1

	return 0


/datum/Quadruple/proc/ActionCompare(var/datum/Quadruple/left, var/datum/Quadruple/right)
	/*
	// returns -1 if Right > Left
	// returns 1 if Right < Left
	// return 0 if Right == Left
	//
	// This is just a cut-down version of the QuadCompare proc.
	*/

	if (right.first > left.first)
		return -1

	if (right.first < left.first)
		return 1

	if (right.second > left.second)
		return -1

	if (right.second < left.second)
		return 1

	/* For this GOAP implementation, our standard key is at most
	// the first two values (iteration, for BFS, and cost, for
	// Astarry-ness), and the rest can be whatever, so we return 0.
	//
	// If you use a custom key generator proc, you will probably need
	// to use a custom proc instead of this one as well.
	*/
	return 0
