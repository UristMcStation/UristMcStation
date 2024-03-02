/proc/SpawnTableFlipped(var/spawnloc, var/flip_dir)
	var/obj/cover/table/newtable = new(spawnloc)

	if(flip_dir)
		newtable.pFlip(flip_dir)


/obj/spawner/oneshot/table_flipped
	name = "Flipped Table (Random)"

	icon = 'icons/obj/structures.dmi'
	icon_state = "woodflip0"
	alpha = 255

	var/flip_direction = null


/obj/spawner/oneshot/table_flipped/Setup()
	if(isnull(flip_direction))
		flip_direction = pick(NORTH, EAST, SOUTH, WEST)


/obj/spawner/oneshot/table_flipped/CallScript()
	SpawnTableFlipped(src.loc, src.flip_direction)


/obj/spawner/oneshot/table_flipped/north
	name = "Flipped Table (North)"
	dir = NORTH
	flip_direction = NORTH


/obj/spawner/oneshot/table_flipped/south
	name = "Flipped Table (South)"
	dir = SOUTH
	flip_direction = SOUTH


/obj/spawner/oneshot/table_flipped/east
	name = "Flipped Table (East)"
	dir = EAST
	flip_direction = EAST


/obj/spawner/oneshot/table_flipped/west
	name = "Flipped Table (West)"
	dir = WEST
	flip_direction = WEST
