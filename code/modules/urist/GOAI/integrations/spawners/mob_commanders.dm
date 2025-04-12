//#define GOAI_AGENTS_INCLUDED 0

# ifdef GOAI_AGENTS_INCLUDED
/proc/spawn_commanded_combatant(var/atom/loc, var/name = null, var/mob_icon = null, var/mob_icon_state = null)
	var/true_name = name

	var/mob/living/simple_animal/aitester/squadtester/M = new(loc)
	if(true_name)
		M.name = true_name

	if(mob_icon)
		M.icon = mob_icon

	if(mob_icon_state)
		M.icon_state = mob_icon_state

	M.loc = loc

	return M


/obj/spawner/oneshot/commanded_mob
	var/commander_name = null
	var/mob_icon = null
	var/mob_icon_state = null
	var/spawn_commander = TRUE

	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "ANTAG"

	script = /proc/spawn_commanded_combatant


/obj/spawner/oneshot/commanded_mob/CallScript()
	if(!active)
		return

	var/true_mob_icon = src.mob_icon || src.icon
	var/true_mob_icon_state = src.mob_icon_state || src.icon_state

	var/script_args = list(
		loc = src.loc,
		name = src.commander_name,
		mob_icon = true_mob_icon,
		mob_icon_state = true_mob_icon_state
	)

	call(script)(arglist(script_args))


// SQUAD VARIANT


/proc/spawn_commanded_squad(var/atom/loc, var/count = 4, var/radius = null, var/faction = null, var/mob_icon = null, var/mob_icon_state = null, var/with_squad_brain = TRUE)
	if(isnull(loc))
		return

	var/to_spawn_count = DEFAULT_IF_NULL(count, 4)
	if(to_spawn_count <= 0)
		return

	var/spawn_radius = DEFAULT_IF_NULL(radius, 1)
	while(((2+spawn_radius)*(2+spawn_radius)) < to_spawn_count)
		// expand radius to accomodate all required spawns
		spawn_radius++

	var/list/spawnlocs = trangeGeneric(spawn_radius, loc.x, loc.y, loc.z)
	var/spawned_amt = 0

	var/true_faction = faction

	var/datum/squad/spawn_squad = null
	var/datum/brain/squad_brain = null

	while(spawned_amt < to_spawn_count)
		// A slightly tricky, but efficient, random pop (i.e. 'destructive' pick()).
		var/spawnloc_len = spawnlocs.len // cache var for efficiency
		if(!spawnloc_len)
			break

		// 1) Pick a random item, by INDEX
		var/index = rand(1, spawnloc_len)

		// 2) Swap the picked item with the LAST item
		spawnlocs.Swap(index, spawnloc_len)

		// 3) Retrieve the picked item, now as the new last index
		var/atom/spawn_location = spawnlocs[spawnloc_len]

		// 4) Reduce the list len to yeet the pick out of the running for next iter.
		spawnlocs.len--

		if(spawn_location.density)
			// don't wallspawn; just pop and move on
			continue

		// Actually spawn the mob
		var/mob/M = spawn_commanded_combatant(spawn_location, null, mob_icon, mob_icon_state)

		if(!istype(M))
			break

		// Wire the mob up to a faction
		if(isnull(true_faction))
			// if unspecified, just default to first spawnee's faction
			true_faction = M.faction
		else
			// overwrite all factions to be uniform
			M.faction = true_faction

		// for devmobs, adjust sprite to appropriate team's
		var/mob/living/simple_animal/aitester/testmob = M
		if(istype(testmob))
			testmob.icon_state = testmob.SpriteForFaction(testmob.faction)

		// ...and a Squad
		if(isnull(spawn_squad))
			// lazy init
			spawn_squad = new /datum/squad(spawn_location.x, spawn_location.y, spawn_location.z)

			if(isnull(spawn_squad.members))
				spawn_squad.members = list()

		// ...and a shared 'hivemind' Brain
		if(isnull(squad_brain))
			// lazy init
			squad_brain = new /datum/brain()
			squad_brain.name = "Brain of Squad [spawn_squad.registry_index]"

		/* Spawn a new Commander, so we don't have to go chasing one down from vars or crashing if it's null */
		// TODO: make sure this does not create duplicate mob AIs for one mob
		// As of writing, the mob-spawning proc uses a variant that has no AI, so it's safe,
		// but want to make sure it stays this way if we switch it out.
		var/datum/utility_ai/mob_commander/new_commander = new(TRUE, FALSE, FALSE) // Active, No Pawn Spawner (handled already), No Relations Init (yet)
		#ifdef UTILITY_SMARTOBJECT_SENSES
		// Spec for Dev senses!
		new_commander.sense_filepaths = DEFAULT_UTILITY_AI_SENSES
		#endif
		AttachUtilityCommanderTo(M, new_commander)
		new_commander.min_lod = 7

		// We deferred relations init in the AI's new to attach the preexisting mob first, so we need to init it now.
		new_commander.InitRelations()
		/* ---  AI get!  --- */

		var/datum/brain/aibrain = new_commander.brain

		aibrain.SetSquad(spawn_squad)
		aibrain.hivemind = squad_brain

		spawn_squad.members.Add(M)

		// Increase the success counter
		spawned_amt++

		M.name = "[faction][isnull(faction) ? "" : "-"][aibrain.squad_idx]-[spawned_amt]"
		new_commander.name = "AI of [M.name]"
		aibrain.name = "Brain of [M.name]"

	return


/obj/spawner/oneshot/commanded_squad_mob
	var/count = 3
	var/radius = 2
	var/mob_faction = null
	var/mob_icon = null
	var/mob_icon_state = null
	var/with_squad_brain = TRUE

	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "ANTAG"

	script = /proc/spawn_commanded_squad


/obj/spawner/oneshot/commanded_squad_mob/CallScript()
	if(!active)
		return

	var/true_mob_icon = src.mob_icon || src.icon
	var/true_mob_icon_state = src.mob_icon_state || src.icon_state

	var/script_args = list(
		loc = src.loc,
		count = src.count,
		radius = src.radius,
		faction = src.mob_faction,
		mob_icon = true_mob_icon,
		mob_icon_state = true_mob_icon_state,
		with_squad_brain = with_squad_brain
	)

	call(script)(arglist(script_args))

# endif

/*
// Humanoid (i.e. regular spessman)
*/


# ifdef GOAI_SS13_SUPPORT

/proc/spawn_commanded_humanoid(var/atom/loc, var/name = null, var/spawn_commander = TRUE)
	var/true_name = name

	var/mob/living/carbon/human/M = new(loc)
	var/mob_gender = pick(MALE, FEMALE)
	M.gender = mob_gender

	if(true_name)
		M.real_name = true_name
	else
		M.real_name = random_name(mob_gender, SPECIES_HUMAN)

	M.head_hair_style = random_hair_style(mob_gender, SPECIES_HUMAN)
	M.facial_hair_style = random_facial_hair_style(mob_gender, SPECIES_HUMAN)

	// hopefully disabling SSD through a self-reference
	// might have to add a flag in the SSD checks instead
	M.teleop = M

	var/singleton/hierarchy/outfit/antag = outfit_by_type(/singleton/hierarchy/outfit/ANTAG)
	antag.equip(M, equip_adjustments = OUTFIT_ADJUSTMENT_SKIP_SURVIVAL_GEAR)

	var/list/gun_types = list(
		/obj/item/gun/projectile/colt,
		/obj/item/gun/projectile/pistol/sec/lethal,
		/obj/item/gun/projectile/pistol/sec/wood/lethal,
		/obj/item/gun/projectile/pistol/holdout
	)

	var/obj/item/gun/projectile/gun = null
	var/selected_gun = pick(gun_types)

	if(!gun)
		gun = new selected_gun(M)
		M.equip_to_slot_or_del(gun, slot_r_hand)

	if(!gun)
		gun = new selected_gun(M)
		M.equip_to_slot_or_del(gun, slot_l_hand)

	if(spawn_commander)
		AttachUtilityCommanderTo(M)

	return


/obj/spawner/oneshot/commanded_humanoid
	var/commander_name = null
	var/spawn_commander = TRUE

	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "ANTAG"

	script = /proc/spawn_commanded_humanoid


/obj/spawner/oneshot/commanded_humanoid/CallScript()
	if(!active)
		return

	var/script_args = list(
		loc = src.loc,
		name = src.commander_name,
		spawn_commander = spawn_commander
	)

	call(script)(arglist(script_args))

/*
// SimpleAnimal
*/
/proc/spawn_commanded_simpleanimal(var/atom/loc, var/name = null, var/spawn_commander = TRUE)
	if(!loc)
		return

	var/true_name = name

	var/mobtype = rand(1, 3)
	var/mob/living/simple_animal/hostile/M = null

	switch(mobtype)
		if(1)
			var/mob/living/simple_animal/hostile/urist/commando/komandoh = new()
			M = komandoh
		if(2)
			var/mob/living/simple_animal/hostile/urist/skrellterrorist/skrellie = new()
			M = skrellie
		if(3)
			var/mob/living/simple_animal/hostile/urist/ANTAG/eggsalt = new()
			M = eggsalt

	if(true_name)
		M.name = true_name

	M.loc = loc
	M.movement_cooldown = 1

	if(spawn_commander)
		AttachUtilityCommanderTo(M)

	return


/obj/spawner/oneshot/commanded_simpleanimal
	var/commander_name = null
	var/spawn_commander = TRUE

	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "ANTAG"

	script = /proc/spawn_commanded_simpleanimal


/obj/spawner/oneshot/commanded_simpleanimal/CallScript()
	if(!active)
		return

	var/script_args = list(
		loc = src.loc,
		name = src.commander_name,
		spawn_commander = spawn_commander
	)

	call(script)(arglist(script_args))

# endif

/*
// Object, because why not?
*/

/proc/spawn_commanded_object(var/atom/loc, var/name = null)
	var/true_name = name

	# ifdef GOAI_SS13_SUPPORT
	var/obj/item/gun/projectile/colt/M = new(loc)
	# endif

	# ifdef GOAI_LIBRARY_FEATURES
	var/obj/item/gun/M = new(loc)
	# endif

	if(true_name)
		M.name = true_name

	var/datum/utility_ai/mob_commander/new_commander = new()

	new_commander.pawn = REFERENCE_PAWN(M)

	new_commander.name = "AI of [M.name] (#[rand(0, 100000)])"

	return



/obj/spawner/oneshot/commanded_object
	var/commander_name = null

	# ifdef GOAI_SS13_SUPPORT
	icon = 'icons/obj/guns/small_egun.dmi'
	icon_state = "smallgunkill75"
	# endif

	# ifdef GOAI_LIBRARY_FEATURES
	icon = 'icons/obj/gun.dmi'
	icon_state = "laser"
	# endif

	script = /proc/spawn_commanded_object


/obj/spawner/oneshot/commanded_object/CallScript()
	if(!active)
		return

	var/script_args = list(
		loc = src.loc,
		name = src.commander_name
	)

	call(script)(arglist(script_args))

