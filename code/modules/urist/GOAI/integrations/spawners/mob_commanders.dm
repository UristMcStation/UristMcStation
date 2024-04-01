# ifdef GOAI_AGENTS_INCLUDED
/proc/spawn_commanded_combatant(var/atom/loc, var/name = null, var/mob_icon = null, var/mob_icon_state = null, var/spawn_commander = TRUE)
	var/true_name = name

	var/mob/goai/combatant/M = new(active = FALSE)
	if(true_name)
		M.name = true_name

	M.pLobotomizeGoai(stop_life = FALSE) // probably should refactor to not make a brain in the first place!

	if(mob_icon)
		M.icon = mob_icon

	if(mob_icon_state)
		M.icon_state = mob_icon_state

	M.loc = loc

	if(spawn_commander)
		var/datum/goai/mob_commander/combat_commander/new_commander = new()

		new_commander.pawn = M
		var/dict/pawn_attachments = M.attachments

		if(isnull(pawn_attachments))
			pawn_attachments = new()
			M.attachments = pawn_attachments

		pawn_attachments[ATTACHMENT_CONTROLLER_BACKREF] = new_commander.registry_index

		new_commander.name = "AI of [M.name] (#[rand(0, 100000)])"

		if(true_name)
			new_commander.name = true_name

	return



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
		mob_icon_state = true_mob_icon_state,
		spawn_commander = spawn_commander
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

	var/obj/item/gun/projectile/colt/gun = null

	if(!gun)
		gun = new(M)
		M.equip_to_slot_or_del(gun, slot_r_hand)

	if(!gun)
		gun = new(M)
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

	var/datum/utility_ai/mob_commander/combat_commander/new_commander = new()

	# ifdef GOAI_SS13_SUPPORT
	new_commander.pawn_ref = weakref(M)
	# endif

	# ifdef GOAI_LIBRARY_FEATURES
	new_commander.pawn = M
	# endif

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

