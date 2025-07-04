// This file is for actual fighting. Targeting is in a seperate file.

/datum/ai_holder
	var/firing_lanes = TRUE					// If true, tries to refrain from shooting allies or the wall.
	var/conserve_ammo = FALSE				// If true, the mob will avoid shooting anything that does not have a chance to hit a mob. Requires firing_lanes to be true.
	var/pointblank = FALSE					// If ranged is true, and this is true, people adjacent to the mob will suffer the ranged instead of using a melee attack.

	var/can_breakthrough = TRUE				// If false, the AI will not try to open a path to its goal, like opening doors.
	var/violent_breakthrough = TRUE			// If false, the AI is not allowed to destroy things like windows or other structures in the way. Requires above var to be true.

	var/stand_ground = FALSE				// If true, the AI won't try to get closer to an enemy if out of range.

	var/prying = FALSE                      // True when the mob is trying to force open a door.

	/// Bitflag (Any of `src.PRY_FLAG_*`). Bitflags used for configuring what and how this AI can pry. Not used if `holder.can_pry` is `FALSE`.
	var/pry_flags = FLAGS_OFF
	/// This AI can only perform special unlocking if the AI control wire is intact.
	var/const/PRY_FLAG_AI_CONTROL_ONLY = FLAG_01
	/// This AI can unbolt doors.
	var/const/PRY_FLAG_UNBOLT = FLAG_02
	/// This AI can 'hack' open working doors.
	var/const/PRY_FLAG_CAN_HACK = FLAG_03

	// Excludes doors, shutters and windows, which are processed separately
	var/list/valid_obstacles_by_priority = list(
		/obj/structure/closet,
		/obj/structure/table,
		/obj/structure/grille,
		/obj/structure/barricade,
		/obj/structure/wall_frame,
		/obj/structure/railing
	)

	var/aggro_sound = null //what sound, if any, do we play when aggroing
	var/yelled = FALSE //have we played an aggro sound already?

// This does the actual attacking.
/datum/ai_holder/proc/engage_target()
	ai_log("engage_target() : Entering.", AI_LOG_DEBUG)
	if(aggro_sound && yelled == 0)
		playsound(holder, aggro_sound, 50, 1)
		yelled = 1

	// Can we still see them?
	if (!target || !can_attack(target))
		ai_log("engage_target() : Lost sight of target.", AI_LOG_TRACE)
		if (lose_target()) // We lost them (returns TRUE if we found something else to do)
			ai_log("engage_target() : Pursuing other options (last seen, or a new target).", AI_LOG_TRACE)
			return

	var/distance = get_dist(holder, target)
	ai_log("engage_target() : Distance to target ([target]) is [distance].", AI_LOG_TRACE)
	holder.face_atom(target)
	last_conflict_time = world.time

	// Break down tables or low walls first.
	if (distance <= 1 && can_violently_breakthrough())
		var/turf/target_turf = get_turf(target)
		for (var/obj/obstacle_obj in target_turf.contents)
			if (obstacle_obj.density)
				ai_log("engage_target() : Target standing on an obstacle, attacking: [obstacle_obj]", AI_LOG_TRACE)
				melee_attack(obstacle_obj)
				return

	// Break into closets if necessary.
	if (distance <= 1 && istype(target.loc, /obj/structure/closet) && intelligence_level >= AI_NORMAL)
		var/obj/structure/closet/closet = target.loc
		if (closet.welded || closet.locked)
			ai_log("engage_target() : Target hiding inside a secure locker, giving up.", AI_LOG_TRACE)
			lose_target()
		else
			ai_log("engage_target() : Target hiding in a locker, opening.", AI_LOG_TRACE)
			closet.open()
		return

	// Do a 'special' attack, if one is allowed.
	if (holder.ICheckSpecialAttack(target))
		ai_log("engage_target() : Attempting a special attack.", AI_LOG_TRACE)
		on_engagement(target)
		if (special_attack(target)) // If this fails, then we try a regular melee/ranged attack.
			ai_log("engage_target() : Successful special attack. Exiting.", AI_LOG_DEBUG)
			return

	// Stab them.
	else if (distance <= 1 && !pointblank)
		ai_log("engage_target() : Attempting a melee attack.", AI_LOG_TRACE)
		on_engagement(target)
		melee_attack(target)

	else if (distance <= 1 && !holder.ICheckRangedAttack(target)) // Doesn't have projectile, but is pointblank
		ai_log("engage_target() : Attempting a melee attack.", AI_LOG_TRACE)
		on_engagement(target)
		melee_attack(target)

	// Shoot them.
	else if (holder.ICheckRangedAttack(target) && (distance <= max_range(target)) )
		on_engagement(target)
		if (firing_lanes && !test_projectile_safety(target))
			// Nudge them a bit, maybe they can shoot next time.
			var/turf/T = get_step(holder, pick(GLOB.cardinal))
			if (T)
				holder.IMove(get_step_towards(holder, T)) // IMove() will respect movement cooldown.
				holder.face_atom(target)
			ai_log("engage_target() : Could not safely fire at target. Exiting.", AI_LOG_DEBUG)
			return

		ai_log("engage_target() : Attempting a ranged attack.", AI_LOG_TRACE)
		ranged_attack(target)

	// Run after them.
	else if (!stand_ground)
		ai_log("engage_target() : Target ([target]) too far away. Exiting.", AI_LOG_DEBUG)
		set_stance(STANCE_APPROACH)

// We're not entirely sure how holder will do melee attacks since any /mob/living could be holder, but we don't have to care because Interfaces.
/datum/ai_holder/proc/melee_attack(atom/A)
	pre_melee_attack(A)
	. = holder.IAttack(A)
	if (. == ATTACK_SUCCESSFUL)
		post_melee_attack(A)

// Ditto.
/datum/ai_holder/proc/ranged_attack(atom/A)
	pre_ranged_attack(A)
	. = holder.IRangedAttack(A)
	if (. == ATTACK_SUCCESSFUL)
		post_ranged_attack(A)

// Attack selection for destroying obstacles.
// If we have an indiscriminate ranged attack, use that. Otherwise use melee.
/datum/ai_holder/proc/obstacle_attack(atom/A)
	if (!conserve_ammo && holder.ICheckRangedAttack(target))
		return ranged_attack(A)
	return melee_attack(A)

// Most mobs probably won't have this defined but we don't care.
/datum/ai_holder/proc/special_attack(atom/movable/AM)
	pre_special_attack(AM)
	. = holder.ISpecialAttack(AM)
	if (. == ATTACK_SUCCESSFUL)
		post_special_attack(AM)

// Called when within striking/shooting distance, however cooldown is not considered.
// Override to do things like move in a random step for evasiveness.
// Note that this is called BEFORE the attack.
/datum/ai_holder/proc/on_engagement(atom/A)

// Called before a ranged attack is attempted.
/datum/ai_holder/proc/pre_ranged_attack(atom/A)

// Called before a melee attack is attempted.
/datum/ai_holder/proc/pre_melee_attack(atom/A)

// Called before a 'special' attack is attempted.
/datum/ai_holder/proc/pre_special_attack(atom/A)

// Called after a successful (IE not on cooldown) ranged attack.
// Note that this is not whether the projectile actually hit, just that one was launched.
/datum/ai_holder/proc/post_ranged_attack(atom/A)

// Ditto but for melee.
/datum/ai_holder/proc/post_melee_attack(atom/A)

// And one more for special snowflake attacks.
/datum/ai_holder/proc/post_special_attack(atom/A)

// Used to make sure projectiles will probably hit the target and not the wall or a friend.
/datum/ai_holder/proc/test_projectile_safety(atom/movable/AM)
	ai_log("test_projectile_safety([AM]) : Entering.", AI_LOG_TRACE)

	// If they're right next to us then lets just say yes. check_trajectory() tends to spaz out otherwise.
	if (holder.Adjacent(AM))
		ai_log("test_projectile_safety() : Adjacent to target. Exiting with TRUE.", AI_LOG_TRACE)
		return TRUE

	// This will hold a list of all mobs in a line, even those behind the target, and possibly the wall.
	// By default the test projectile goes through things like glass and grilles, which is desirable as otherwise the AI won't try to shoot through windows.
	var/hit_thing = check_trajectory(AM, holder) // This isn't always reliable but its better than the previous method.

	// Test to see if the primary target actually has a chance to get hit.
	// We'll fire anyways if not, if we have conserve_ammo turned off.
	var/would_hit_primary_target = FALSE
	if (hit_thing == AM)
		would_hit_primary_target = TRUE
	ai_log("test_projectile_safety() : Test projectile did[!would_hit_primary_target ? " NOT " : " "]hit \the [AM]", AI_LOG_DEBUG)

	// Make sure we don't have a chance to shoot our friends.
	if (hit_thing)
		var/atom/A = hit_thing
		ai_log("test_projectile_safety() : Evaluating \the [A] ([A.type]).", AI_LOG_TRACE)
		if (isliving(A)) // Don't shoot at our friends, even if they're behind the target, as RNG can make them get hit.
			var/mob/living/L = A
			if (holder.IIsAlly(L))
				ai_log("test_projectile_safety() : Would threaten ally, exiting with FALSE.", AI_LOG_DEBUG)
				return FALSE

	// Don't fire if we cannot hit the primary target, and we wish to be conservative with our projectiles.
	// We make an exception for turf targets because manual commanded AIs targeting the floor are generally intending to fire blindly.
	if (!would_hit_primary_target && !isturf(AM) && conserve_ammo)
		ai_log("test_projectile_safety() : conserve_ammo is set, and test projectile failed to hit primary target. Exiting with FALSE.", AI_LOG_DEBUG)
		return FALSE

	ai_log("test_projectile_safety() : Passed other tests, exiting with TRUE.", AI_LOG_TRACE)
	return TRUE

// Test if we are within range to attempt an attack, melee or ranged.
/datum/ai_holder/proc/within_range(atom/movable/AM)
	var/distance = get_dist(holder, AM)
	if (distance <= 1)
		return TRUE // Can melee.
	else if (holder.ICheckRangedAttack(AM) && distance <= max_range(AM))
		return TRUE // Can shoot.
	return FALSE

// Determines how close the AI will move to its target.
/datum/ai_holder/proc/closest_distance(atom/movable/AM)
	return max(max_range(AM) - 1, 1) // Max range -1 just because we don't want to constantly get kited

// Can be used to conditionally do a ranged or melee attack.
/datum/ai_holder/proc/max_range(atom/movable/AM)
	return holder.ICheckRangedAttack(AM) ? 7 : 1

// Resists out of things.
// Sometimes there are times you want your mob to be buckled to something, so override this for when that is needed.
/datum/ai_holder/proc/handle_resist()
	holder.resist()

// Used to break through windows and barriers to a target on the other side.
// This does two passes, so that if its just a public access door, the windows nearby don't need to be smashed.
/datum/ai_holder/proc/breakthrough(atom/target_atom)
	ai_log("breakthrough() : Entering", AI_LOG_TRACE)

	if (!can_breakthrough)
		ai_log("breakthrough() : Not allowed to breakthrough. Exiting.", AI_LOG_TRACE)
		return FALSE

	if (!isturf(holder.loc))
		ai_log("breakthrough() : Trapped inside \the [holder.loc]. Exiting.", AI_LOG_TRACE)
		return FALSE

	var/dir_to_target = get_dir(holder, target_atom)
	holder.face_atom(target_atom)

	// Sometimes the mob will try to hit something diagonally, and generally this fails.
	// So instead we will try two more times with some adjustments if the attack fails.
	var/list/directions_to_try = list(
		null, // Try our own turf first
		dir_to_target,
		turn(dir_to_target, 45),
		turn(dir_to_target, -45)
		)

	ai_log("breakthrough() : Starting peaceful pass.", AI_LOG_DEBUG)

	var/result = FALSE

	// First, we will try to peacefully make a path, I.E opening a door we have access to.
	for(var/direction in directions_to_try)
		result = destroy_surroundings(direction, violent = FALSE)
		if (result)
			break

	// Alright, lets smash some shit instead, if it didn't work and we're allowed to be violent.
	if (!result && can_violently_breakthrough())
		ai_log("breakthrough() : Starting violent pass.", AI_LOG_DEBUG)
		for(var/direction in directions_to_try)
			result = destroy_surroundings(direction, violent = TRUE)
			if (result)
				break

	ai_log("breakthrough() : Exiting with [result].", AI_LOG_TRACE)
	return result

// Pry open a door, if it's unpowered/broken
/datum/ai_holder/proc/pry_door(obj/machinery/door/door)
	if (door.operable())
		if (!HAS_FLAGS(pry_flags, PRY_FLAG_CAN_HACK))
			return FALSE
		if (isairlock(door))
			var/obj/machinery/door/airlock/airlock = door
			if (HAS_FLAGS(pry_flags, PRY_FLAG_AI_CONTROL_ONLY) && airlock.ai_control_disabled)
				return FALSE
			if (airlock.locked && (!HAS_FLAGS(pry_flags, PRY_FLAG_UNBOLT) || !airlock.unlock()))
				return FALSE
			if (airlock.welded) // Welding check after the bolt check so the bot can still unbolt the door before trying to break it open.
				return FALSE
		door.open()
		return TRUE

	var/mob/living/simple_animal/holder_simple = holder
	if (!prying && holder_simple.can_pry)
		prying = TRUE
		var/pry_time_holder = (door.pry_mod * holder_simple.pry_time)
		holder_simple.pry_door(holder_simple, pry_time_holder, door)
		return TRUE

	return FALSE

// Despite the name, this can also be used to help clear a path without any destruction.
/datum/ai_holder/proc/destroy_surroundings(direction, violent = TRUE)
	ai_log("destroy_surroundings() : Entering.", AI_LOG_TRACE)

	// Follow a direction, otherwise destroy obstacles on our own tile.
	var/turf/problem_turf = direction ? get_step(holder, direction) : get_turf(holder)

	// First, give peace a chance.
	if (!violent)
		ai_log("destroy_surroundings() : Going to try to peacefully clear [problem_turf].", AI_LOG_DEBUG)
		for(var/obj/machinery/door/door in problem_turf)
			if (door.density && holder.Adjacent(door))
				//Try to open the door if we're allowed too.
				if (door.allowed(holder) && door.operable())
					// First, try to open the door if possible without smashing it. We might have access.
					ai_log("destroy_surroundings() : Opening closed door.", AI_LOG_INFO)
					return door.Bumped(holder)

				//Try to force the door if its broken/has no power
				return pry_door(door)

		// Open any closets in the way.
		for(var/obj/structure/closet/closet in problem_turf)
			if (closet.density && !closet.locked && !closet.welded)
				ai_log("destroy_surroundings() : Opening closed closet.", AI_LOG_INFO)
				return closet.open()

	// Peace has failed us, can we just smash the things in the way?
	else
		ai_log("destroy_surroundings() : Going to try to violently clear [problem_turf].", AI_LOG_DEBUG)

		// First, check for hull shields in the way.
		for(var/obj/energy_field/shield in problem_turf)
			if (shield.density) // Don't attack shields that are already down.
				ai_log("destroy_surroundings() : Attacking hull shield.", AI_LOG_INFO)
				return obstacle_attack(shield)

		for(var/obj/machinery/door/door in problem_turf)
			if (door.density)
				ai_log("destroy_surroundings() : Attacking closed door [door].", AI_LOG_INFO)
				return obstacle_attack(door)

		// Kill windows in the way.
		for(var/obj/structure/window/window in problem_turf)
			if (window.dir == GLOB.reverse_dir[holder.dir]) // So that windows get smashed in the right order
				ai_log("destroy_surroundings() : Attacking side window.", AI_LOG_INFO)
				return obstacle_attack(window)

			else if (window.is_fulltile())
				ai_log("destroy_surroundings() : Attacking full tile window.", AI_LOG_INFO)
				return obstacle_attack(window)

		// Kill common obstacles in the way like tables.
		for(var/obstacle_type in valid_obstacles_by_priority)
			for(var/atom/obstacle in problem_turf)
				if (!istype(obstacle, obstacle_type))
					continue
				if (!obstacle.density)
					continue
				ai_log("destroy_surroundings() : Attacking obstacle [obstacle]", AI_LOG_INFO)
				if (obstacle.throwpass) // If bullets would fly over it, default to melee.
					return melee_attack(obstacle)
				return obstacle_attack(obstacle) // Otherwise let us choose.


	ai_log("destroy_surroundings() : Exiting due to nothing to attack.", AI_LOG_INFO)
	return ATTACK_FAILED // Nothing to attack.

// Override for special behaviour.
/datum/ai_holder/proc/can_violently_breakthrough()
	return violent_breakthrough
