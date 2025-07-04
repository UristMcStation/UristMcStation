/mob/living/carbon/human/proc/monkeyize()
	if (HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return
	for(var/obj/item/W in src)
		if (W==w_uniform) // will be torn
			continue
		drop_from_inventory(W)
	regenerate_icons()
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	stunned = 1
	icon = null
	set_invisibility(INVISIBILITY_ABSTRACT)
	for(var/t in organs)
		qdel(t)
	var/atom/movable/fake_overlay/animation = new /atom/movable/fake_overlay(src)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	flick("h2monkey", animation)
	sleep(48)
	//animation = null

	DEL_TRANSFORMATION_MOVEMENT_HANDLER(src)
	stunned = 0
	UpdateLyingBuckledAndVerbStatus()
	set_invisibility(initial(invisibility))

	if(!species.primitive_form) //If the creature in question has no primitive set, this is going to be messy.
		gib()
		return

	for(var/obj/item/W in src)
		drop_from_inventory(W)
	set_species(species.primitive_form)
	dna.SetSEState(GLOB.MONKEYBLOCK,1)
	dna.SetSEValueRange(GLOB.MONKEYBLOCK,0xDAC, 0xFFF)

	to_chat(src, "<B>You are now [species.name]. </B>")
	qdel(animation)

	return src

/mob/new_player/AIize()
	spawning = 1
	if(length(empty_playable_ai_cores))
		var/obj/structure/AIcore/deactivated/C = empty_playable_ai_cores[1]
		empty_playable_ai_cores -= C
		var/mob/living/silicon/ai/A = ..(0)
		A.forceMove(C.loc)
		A.on_mob_init()
		qdel(C)
		return A
	else
		return ..()	//Fallback AIize, spawning a new AI at any AI landmark. This is only used by gamemode antag AI's which don't spawn & check for inactive cores (ie, malf)

/mob/living/carbon/human/AIize(move=1) // 'move' argument needs defining here too because BYOND is dumb
	if (HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return
	for(var/t in organs)
		qdel(t)
	QDEL_NULL_LIST(worn_underwear)
	return ..(move)

/mob/living/carbon/AIize()
	if (HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return
	for(var/obj/item/W in src)
		drop_from_inventory(W)
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	icon = null
	set_invisibility(INVISIBILITY_ABSTRACT)
	return ..()

/mob/proc/AIize(move=1)
	if(client)
		sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))// stop the jams for AIs


	var/mob/living/silicon/ai/O = new (loc, GLOB.using_map.default_law_type,,1)//No MMI but safety is in effect.
	O.set_invisibility(0)
	O.aiRestorePowerRoutine = 0
	if(mind)
		mind.transfer_to(O)
		O.mind.original = O
		var/datum/job/job = SSjobs.get_by_title(O.mind.assigned_role)
		O.skillset.obtain_from_job(job)
	else
		O.key = key

	if(move)
		var/obj/loc_landmark
		for(var/obj/landmark/start/sloc in landmarks_list)
			if (sloc.name != "AI")
				continue
			if (locate(/mob/living) in sloc.loc)
				continue
			loc_landmark = sloc
		if (!loc_landmark)
			for(var/obj/landmark/tripai in landmarks_list)
				if (tripai.name == "tripai")
					if((locate(/mob/living) in tripai.loc) || (locate(/obj/structure/AIcore) in tripai.loc))
						continue
					loc_landmark = tripai
		if (!loc_landmark)
			to_chat(O, "Oh god sorry we can't find an unoccupied AI spawn location, so we're spawning you on top of someone.")
			for(var/obj/landmark/start/sloc in landmarks_list)
				if (sloc.name == "AI")
					loc_landmark = sloc
		if (!loc_landmark)
			to_chat(O, SPAN_DEBUG("We still failed to find a AI spawn location. Where you're standing is now you're new home."))
		else
			O.forceMove(loc_landmark.loc)
		O.on_mob_init()

	O.add_ai_verbs()

	O.rename_self("ai",1)
	spawn(0)	// Mobs still instantly del themselves, thus we need to spawn or O will never be returned
		qdel(src)
	return O

//human -> robot
/mob/living/carbon/human/proc/Robotize(supplied_robot_type = /mob/living/silicon/robot)
	if (HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return
	QDEL_NULL_LIST(worn_underwear)
	for(var/obj/item/W in src)
		drop_from_inventory(W)
	regenerate_icons()
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	icon = null
	set_invisibility(INVISIBILITY_ABSTRACT)
	for(var/t in organs)
		qdel(t)

	var/mob/living/silicon/robot/O = new supplied_robot_type( loc )

	O.gender = gender
	O.set_invisibility(0)

	if(mind)
		mind.transfer_to(O)
		if(O.mind && O.mind.assigned_role == "Robot")
			O.mind.original = O
			var/mmi_type = SSrobots.get_mmi_type_by_title(O.mind.role_alt_title ? O.mind.role_alt_title : O.mind.assigned_role)
			if(mmi_type)
				O.mmi = new mmi_type(O)
				O.mmi.transfer_identity(src)
		if(O.mind.assigned_job && O.mind.assigned_job.faction)
			O.faction = O.mind.assigned_job.faction
			O.mind.faction = O.mind.assigned_job.faction
		else
			O.mind.faction = faction
	else
		O.key = key

	O.dropInto(loc)
	O.job = "Robot"
	callHook("borgify", list(O))
	O.Namepick()

	qdel(src) // Queues us for a hard delete
	return O

/mob/living/carbon/human/proc/slimeize(adult as num, reproduce as num)
	if (HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return
	for(var/obj/item/W in src)
		drop_from_inventory(W)
	regenerate_icons()
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	icon = null
	set_invisibility(INVISIBILITY_ABSTRACT)
	for(var/t in organs)
		qdel(t)

	var/mob/living/carbon/slime/new_slime
	if(reproduce)
		var/number = pick(14;2,3,4)	//reproduce (has a small chance of producing 3 or 4 offspring)
		var/list/babies = list()
		for(var/i=1,i<=number,i++)
			var/mob/living/carbon/slime/M = new/mob/living/carbon/slime(loc)
			M.set_nutrition(round(nutrition/number))
			step_away(M,src)
			babies += M
		new_slime = pick(babies)
	else
		new_slime = new /mob/living/carbon/slime(loc)
		if(adult)
			new_slime.is_adult = 1
		else
	new_slime.key = key

	to_chat(new_slime, "<B>You are now a slime. Skreee!</B>")
	qdel(src)
	return

/mob/living/carbon/human/proc/corgize()
	if (HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return
	for(var/obj/item/W in src)
		drop_from_inventory(W)
	regenerate_icons()
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	icon = null
	set_invisibility(INVISIBILITY_ABSTRACT)
	for(var/t in organs)	//this really should not be necessary
		qdel(t)

	var/mob/living/simple_animal/passive/corgi/new_corgi = new /mob/living/simple_animal/passive/corgi (loc)
	new_corgi.a_intent = I_HURT
	new_corgi.key = key

	to_chat(new_corgi, "<B>You are now a Corgi. Yap Yap!</B>")
	qdel(src)
	return

/mob/living/carbon/human/Animalize()

	var/list/mobtypes = typesof(/mob/living/simple_animal)
	var/mobpath = input("Which type of mob should [src] turn into?", "Choose a type") in mobtypes

	if(!safe_animal(mobpath))
		to_chat(usr, SPAN_WARNING("Sorry but this mob type is currently unavailable."))
		return

	if(HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return
	for(var/obj/item/W in src)
		drop_from_inventory(W)

	regenerate_icons()
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	icon = null
	set_invisibility(INVISIBILITY_ABSTRACT)

	for(var/t in organs)
		qdel(t)

	var/mob/new_mob = new mobpath(src.loc)

	new_mob.key = key
	new_mob.a_intent = I_HURT


	to_chat(new_mob, "You suddenly feel more... animalistic.")
	spawn()
		qdel(src)
	return

/mob/proc/Animalize()

	var/list/mobtypes = typesof(/mob/living/simple_animal)
	var/mobpath = input("Which type of mob should [src] turn into?", "Choose a type") in mobtypes

	if(!safe_animal(mobpath))
		to_chat(usr, SPAN_WARNING("Sorry but this mob type is currently unavailable."))
		return

	var/mob/new_mob = new mobpath(src.loc)

	new_mob.key = key
	new_mob.a_intent = I_HURT
	to_chat(new_mob, "You feel more... animalistic")

	qdel(src)

/* Certain mob types have problems and should not be allowed to be controlled by players.
 *
 * This proc is here to force coders to manually place their mob in this list, hopefully tested.
 * This also gives a place to explain -why- players shouldn't be turn into certain mobs and hopefully someone can fix them.
 */
/mob/proc/safe_animal(MP)

//Bad mobs! - Remember to add a comment explaining what's wrong with the mob
	if(!MP)
		return 0	//Sanity, this should never happen.

	if(ispath(MP, /mob/living/simple_animal/construct/behemoth))
		return 0 //I think this may have been an unfinished WiP or something. These constructs should really have their own class simple_animal/construct/subtype

	if(ispath(MP, /mob/living/simple_animal/construct/armoured))
		return 0 //Verbs do not appear for players. These constructs should really have their own class simple_animal/construct/subtype

	if(ispath(MP, /mob/living/simple_animal/construct/wraith))
		return 0 //Verbs do not appear for players. These constructs should really have their own class simple_animal/construct/subtype

	if(ispath(MP, /mob/living/simple_animal/construct/builder))
		return 0 //Verbs do not appear for players. These constructs should really have their own class simple_animal/construct/subtype

//Good mobs!
	if(ispath(MP, /mob/living/simple_animal/passive/cat))
		return 1
	if(ispath(MP, /mob/living/simple_animal/passive/corgi))
		return 1
	if(ispath(MP, /mob/living/simple_animal/passive/crab))
		return 1
	if(ispath(MP, /mob/living/simple_animal/hostile/carp))
		return 1
	if(ispath(MP, /mob/living/simple_animal/passive/mushroom))
		return 1
	if(ispath(MP, /mob/living/simple_animal/shade))
		return 1
	if(ispath(MP, /mob/living/simple_animal/passive/tomato))
		return 1
	if(ispath(MP, /mob/living/simple_animal/passive/mouse))
		return 1 //It is impossible to pull up the player panel for mice (Fixed! - Nodrak)
	if(ispath(MP, /mob/living/simple_animal/hostile/bear))
		return 1 //Bears will auto-attack mobs, even if they're player controlled (Fixed! - Nodrak)
	if(ispath(MP, /mob/living/simple_animal/hostile/retaliate/parrot))
		return 1 //Parrots are no longer unfinished! -Nodrak

	//Not in here? Must be untested!
	return 0
