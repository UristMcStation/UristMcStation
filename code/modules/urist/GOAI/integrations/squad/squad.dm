/*
// Data structure for Squads
*/

/datum/squad
	// Who's in this squad?
	// We need this to coordinate information between members.
	// We will treat the indices here as an implicit ordering by descending seniority,
	//   i.e. idx 1 is Lead, 2 is second-in-command etc., where relevant for simulation.
	var/list/members = null

	// TODO/IDEA:
	// var/request_call_in = FALSE
	// if TRUE, all members pointed at this Squad are requested to report themselves
	// back to a members array to refresh the latter - would keep membership in sync

	/* ---       REGISTRY INDEX       --- */
	// Position in the global list of Squads.
	// As a rule, this should NEVER be null if the squad was initialized properly.
	// Can be used to forward a safe (weak) reference somewhere else, like a Pawn,
	//   so that they can look up the squad they belong to on the global list.
	var/registry_index = null

	/* ---          AUTONOMY          --- */
	// Controls to what extent the Squad is controlled by the top-ranking member,
	// (the higher, the more so) vs. how much it is controlled by external forces
	// such as faction AI or player commands.
	// Currently just boolean, but assume it could evolve to be an integer.
	var/autonomy = 1

	// tracking timer ID if we run a loop
	var/leader_sync_loop_id = null
	var/default_leader_sync_tickrate = 10

	/* ---       SQUAD POSITION       --- */
	// The squad itself has a position separate from its members.
	// That means pawns - even the team lead - can position themselves into cover
	//   around the squad position sanely instead of trying to follow the lead's
	//   purely tactical decisions on his own physical location.
	// It ALSO lets us track the squad at lower LODs and only move that around - the
	//   members will be spawned in (or teleported in from hammerspace) once the LOD
	//   is increased (by human players getting close to the squad position).

	var/x = null
	var/y = null
	var/z = null
	// fractal coordinate for 'zoom'; 0 is max zoom (1:1 with tiles)
	// everything higher 'diffuses' the squad location over a wider area;
	// for instance, assuming we dilate by a factor of 2, at (x=2, y=1, z=1, h=9),
	// the squad is somewhere in a 512x512 square from (513, 1, 1) to (1025, 513, 1).
	var/h = 0


/datum/squad/New(var/newX, var/newY, var/newZ, var/newH, var/list/new_members = null, var/registry_id = null)
	// - newX/newY/newZ/newH - respective coordinates for squad location
	// - new_members - optional; list of squaddies to include
	// - registry_id - ADVANCED - optional; reuse a registry slot, USE WITH CAUTION
	SET_IF_NOT_NULL(newX, src.x)
	SET_IF_NOT_NULL(newY, src.y)
	SET_IF_NOT_NULL(newZ, src.z)
	SET_IF_NOT_NULL(newH, src.h)
	SET_IF_NOT_NULL(new_members, src.members)

	if(isnull(registry_id))
		src.RegisterSquad()
	else
		// Overwrite an existing slot with this instance.
		// This is a VERY niche case, generally meant for either A) reusing null slots or B) fixing accidentally deleted squads.
		// If (A), make sure you know who else might be pointing at this slot, or you may get some unexpected extra squaddies.
		GOAI_LIBBED_GLOB_ATTR(global_squad_registry[registry_id]) = src
		src.registry_index = registry_id

	return


/datum/squad/proc/UndeployMembers()
	// Teleports the Squad members to a nullspace 'pocket dimension' of sorts.
	// This means they are off the map entirely.
	// Assuming the associated code is halfway sane, this should mean most systems
	//  should skip processing those squaddies until they get rematerialized.
	// This is a bit more expensive than offloading the mobs to disk entirely,
	//  but higher fidelity and cheaper to respawn into the world.
	// This is meant to be used to abstract Pawns into just the Squad at low LODs.
	if(!istype(src.members))
		return

	for(var/atom/movable/squaddie in src.members)
		if(isnull(squaddie.loc))
			// already covered
			continue

		// We call Exit() mainly to be polite and trigger hooks...
		squaddie.loc.Exit(squaddie, null)

		// ...because we force the loc to null regardless of retval.
		squaddie.loc = null

	return


/datum/squad/proc/DeployMembers(var/atom/loc_override = null, var/radius = null)
	// Teleports the Squad members *from nullspace* to the map.
	// This will therefore NOT affect already deployed squaddies.

	if(!istype(src.members))
		return

	var/atom/spawnloc = loc_override

	if(isnull(spawnloc))
		// Default to a loc corresponding to squad location
		spawnloc = locate(src.x, src.y, src.z)

	if(isnull(spawnloc))
		return

	var/squad_size = length(src.members)
	var/spawn_radius = DEFAULT_IF_NULL(radius, 1)

	while(((2+spawn_radius)*(2+spawn_radius)) < squad_size)
		// expand radius to accomodate all required spawns
		spawn_radius++

	var/list/spawnlocs = trangeGeneric(spawn_radius, spawnloc.x, spawnloc.y, spawnloc.z)

	var/spawnloc_len = spawnlocs.len // cache var for efficiency
	if(!spawnloc_len)
		return

	for(var/atom/movable/squaddie in src.members)
		if(!isnull(squaddie.loc))
			// already deployed
			continue

		if(spawnloc_len < 1)
			// Generally should not happen.
			// If we SOMEHOW run out of slots, return to using the full selection.
			// It will be messy, but we have to spawn everyone here.
			spawnloc_len = spawnlocs.len

		// 1) Pick a random item, by INDEX
		var/index = rand(1, spawnloc_len)

		// 2) Swap the picked item with the LAST item
		spawnlocs.Swap(index, spawnloc_len)

		// 3) Retrieve the picked item, now as the new last index
		var/atom/spawn_location = spawnlocs[spawnloc_len]

		// 4) Reduce the list len to yeet the pick out of the running for next iter.
		spawnloc_len--

		// 5) Actually move the atom
		squaddie.loc = spawn_location

	return


/datum/squad/proc/MoveToPos(var/x, var/y, var/z)
	// Moves the Squad Marker to a new location defined by provided coordinates.
	//
	// Coordinates are validated; if invalid, we do NOT update the position.

	if(isnull(x) || x < 1 || x > world.maxx)
		return

	if(isnull(y) || y < 1 || y > world.maxy)
		return

	if(isnull(z) || z < 1 || z > world.maxz)
		return

	src.x = x
	src.y = y
	src.z = z

	return src


/datum/squad/proc/MoveToAtom(var/atom/newpos)
	// Moves the Squad Marker to a new location defined by the position
	// of an existing game object. This is mainly intended for turfs,
	// but it'll handle any atom you throw at it.
	//
	// Null is not a valid input; if encountered, the Squad position will not change.

	if(!istype(newpos))
		return

	// We do not need to check coords here - if an atom exists, it must have a legal position.

	src.x = newpos.x
	src.y = newpos.y
	src.z = newpos.z

	return src


/datum/squad/proc/SyncToLeaderOnce()
	if(!src.members)
		return

	var/atom/leader = null

	for(var/atom/member in src.members)
		// Find first active member as the leader
		var/mob/living/M = member

		if(istype(M))
			if((M.stat == CONSCIOUS) && !isnull(M.loc))
				leader = M
				break
			else
				continue

		if(!isnull(member.loc))
			leader = member
			break

	src.x = leader.x
	src.y = leader.y
	src.z = leader.z

	return src


/datum/squad/proc/SyncToLeaderLoop(var/tickrate = null)
	set waitfor = FALSE

	var/_tickrate = DEFAULT_IF_NULL(tickrate, src.default_leader_sync_tickrate)
	_tickrate = max(1, _tickrate) // no overloading the server!!!

	// Usual singleton ticker pattern - each call has a unique identity and suicides if the stored hash mismatches
	var/our_loop_id = rand(1, 1e9)
	src.leader_sync_loop_id = our_loop_id
	sleep(-1)

	while(src.leader_sync_loop_id == our_loop_id)
		if(src.autonomy >= 1)
			src.SyncToLeaderOnce()

		sleep(_tickrate)
