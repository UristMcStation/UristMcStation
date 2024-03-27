
# ifdef GOAI_LIBRARY_FEATURES

// Spawns ladders on adjacent z-levels
// If you want to chain them longer, pick a direction (all above or all below) and loop
// This will make a best effort to reuse existing ladders in the target.
/proc/spawn_ladders(var/turf/target_loc, var/turf/lower_loc = null, var/turf/upper_loc = null)
	if(isnull(target_loc))
		return

	var/obj/structure/ladder/lowladder = null
	var/obj/structure/ladder/refladder = new(target_loc)
	var/obj/structure/ladder/hiladder = null

	if(istype(lower_loc))
		lowladder = locate() in lower_loc
		if(isnull(lowladder))
			lowladder = new(lower_loc)

		lowladder.above = refladder
		lowladder.UpdateIconstate()

		refladder.below = lowladder

	if(istype(upper_loc))
		hiladder = locate() in upper_loc
		if(isnull(lowladder))
			hiladder = new(upper_loc)

		hiladder.below = refladder
		hiladder.UpdateIconstate()

		refladder.above = hiladder

	refladder.UpdateIconstate()
	return


/obj/spawner/oneshot/create_ladders
	icon = 'icons/obj/structures.dmi'
	icon_state = "ladder11"

	script = /proc/spawn_ladders

	var/lower_position_x = null
	var/lower_position_y = null

	var/upper_position_x = null
	var/upper_position_y = null


/obj/spawner/oneshot/create_ladders/CallScript()
	if(!active)
		return

	if(isnull(src.loc))
		return

	// find below
	var/turf/lowerloc = null

	if(src.lower_position_x && src.lower_position_y)
		var/lower_z = src.z - 1
		if(lower_z > 0)
			lowerloc = locate(src.lower_position_x, src.lower_position_y, lower_z)

	var/turf/upperloc = null

	// find above
	if(src.upper_position_x && src.lower_position_y)
		var/upper_z = src.z + 1
		if(upper_z <= world.maxz)
			upperloc = locate(src.upper_position_x, src.upper_position_y, upper_z)

	if(!(lowerloc || upperloc))
		// default to upper
		var/upper_z = src.z + 1
		if(upper_z <= world.maxz)
			upperloc = locate(src.x, src.y, upper_z)

	var/script_args = list(
		target_loc = src.loc,
		lower_loc = lowerloc,
		upper_loc = upperloc
	)

	call(script)(arglist(script_args))


// Spawns stairs on adjacent z-levels (this one and above/below)
/proc/spawn_stairs(var/turf/target_loc, var/turf/other_loc)
	if(isnull(target_loc))
		return

	if(isnull(other_loc))
		return

	var/obj/structure/stairs/this = new(target_loc)
	var/obj/structure/stairs/other = null

	other = locate() in other_loc
	if(isnull(other))
		other = new(other_loc)

	other.dir = get_dir(other, this)
	other.UpdateIconstate()

	this.dir = get_dir(this, other)
	this.UpdateIconstate()

	if(other.z > this.z)
		this.above = other_loc
		var/turf/clearance_pos = locate(this.x, this.y, other.z)
		var/turf/simulated/open/clearance_turf = clearance_pos
		if(!istype(clearance_turf))
			clearance_turf = new(clearance_pos)
	else
		other.above = target_loc
		var/turf/clearance_pos = locate(other.x, other.y, this.z)
		var/turf/simulated/open/clearance_turf = clearance_pos
		if(!istype(clearance_turf))
			clearance_turf = new(clearance_pos)
	return


/obj/spawner/oneshot/create_stairs
	icon = 'icons/obj/structures.dmi'
	icon_state = "rampbottom"

	script = /proc/spawn_stairs

	var/other_position_x = null
	var/other_position_y = null
	var/other_position_z = null

	var/up = TRUE


/obj/spawner/oneshot/create_stairs/CallScript()
	if(!active)
		return

	if(isnull(src.loc))
		return

	// find target position
	var/turf/otherloc = null

	var/other_x = other_position_x
	var/other_y = other_position_x

	if(isnull(other_x) || isnull(other_y))
		// infer the output position from the direction
		var/turf/samez_adj = get_step(src, src.dir)
		if(samez_adj)
			other_x = isnull(other_x) ? samez_adj.x : other_x
			other_y = isnull(other_y) ? samez_adj.y : other_y

	var/other_z = src.other_position_z
	if(isnull(other_z))
		// infer z-level
		other_z = (src.up ? (src.z + 1) : (src.z - 1))

	otherloc = locate(other_x, other_y, other_z)

	var/script_args = list(
		target_loc = src.loc,
		other_loc = otherloc
	)

	call(script)(arglist(script_args))

# endif
