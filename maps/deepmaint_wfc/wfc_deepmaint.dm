/*
// An alternative take on Deepmaint - more focused on a surreal, Backrooms-ey vibe.
//
// Technically multi-z, but the gimmick is we're mirroring stuff across z-levels, so
// 95% of Zs will be identical and the nondeterministic variation is tightly controlled.
//
// The Zs are then connected using invisible silent teleporters, which means explorers
// will have the layout subtly shifting on them, objects left behind disappearing, etc.
//
// Uses a variant of Wave Function Collapse algorithm to generate a maze.
// The generation is done using a custom Rust library DLL I (= scrdest) wrote, if
// you need to yell at someone for stuff not working.
*/

/obj/landmark/map_data/deepmaint_wfc/lvl1
	name = "Maintrooms"
	height = 1


/datum/map_template/ruin/deepmaint_wfc
	name = "Maintrooms"
	id = "deepmaint_wfc"
	description = "Somewhere in-between. How did we get here? How do we leave?"
	suffixes = list("maps/deepmaint_wfc/wfcdeepmaint-1.dmm")
