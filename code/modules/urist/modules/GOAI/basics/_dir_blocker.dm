// # define DIRBLOCKER_DEBUG_LOGGING 0

# ifdef DIRBLOCKER_DEBUG_LOGGING
# define DIRBLOCKER_DEBUG_LOG(X) to_world_log(X)
# else
# define DIRBLOCKER_DEBUG_LOG(X)
# endif

/datum/directional_blocker
	/* A component that indicates that whatever object its attached to
	behaves like a directional blocker (e.g. SS13 'small' windows or flipped tables).
	*/
	var/blocks = null
	var/block_all = FALSE
	var/is_active = TRUE


/datum/directional_blocker/New(var/block_dirs, var/block_all_dirs = FALSE, var/active = TRUE)
	blocks = (block_dirs ? block_dirs : blocks)
	block_all = (isnull(block_all_dirs) ? block_all : block_all_dirs)
	is_active = (isnull(active) ? is_active : active)


/datum/directional_blocker/proc/Blocks(var/dir, var/query_user = null)

	if(!is_active)
		DIRBLOCKER_DEBUG_LOG("[src] is inactive...")
		return FALSE

	var/atom/movable/atom_user = query_user

	if(istype(atom_user))
		if(src == atom_user.directional_blocker)
			// no self-collisions!
			return FALSE

	var/datum/goai/mob_commander/commander_user = query_user

	if(commander_user && istype(commander_user))
		var/atom/commander_pawn = commander_user.GetPawn()

		if(commander_pawn && src == commander_pawn.directional_blocker)
			// no self-collisions!
			return FALSE

	if(block_all)
		DIRBLOCKER_DEBUG_LOG("[src] blocks all - TRUE!")
		return TRUE

	var/result = blocks & dir
	DIRBLOCKER_DEBUG_LOG("[src] blocks & dir - [result]")
	return result


/datum/directional_blocker/proc/AttachTo(var/atom/blockerable)
	if(!blockerable)
		return FALSE

	blockerable.directional_blocker = src
	return TRUE


/atom/proc/GenerateBlocker()
	// by default
	return null


/atom/proc/ShouldHaveBlocker()
	// by default
	return FALSE


/atom/proc/GetBlockerData(var/generate_if_missing = FALSE, var/log_on_missing = FALSE)
	var/datum/directional_blocker/myblocker = src.directional_blocker

	if(!myblocker)
		if(src.blocker_gen_enabled)
			if(generate_if_missing)
				spawn(0)
					myblocker = src.GenerateCover()
					src.directional_blocker = myblocker

			if(log_on_missing)
				to_world_log("Failed to get blocker for [src] - no blocker data!")

	return src.directional_blocker
