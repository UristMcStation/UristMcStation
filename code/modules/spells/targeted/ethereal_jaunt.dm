/spell/targeted/ethereal_jaunt
	name = "Ethereal Jaunt"
	desc = "This spell creates your ethereal form, temporarily making you invisible and able to pass through walls."
	feedback = "EJ"
	school = "transmutation"
	charge_max = 40 SECONDS
	spell_flags = Z2NOCAST | NEEDSCLOTHES | INCLUDEUSER
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0
	max_targets = 1
	level_max = list(Sp_TOTAL = 4, Sp_SPEED = 4, Sp_POWER = 3)
	cooldown_min = 30 SECONDS //2.5 seconds reduction per rank
	duration = 5 SECONDS

	hud_state = "wiz_jaunt"

	var/reappear_duration = 5
	var/obj/dummy/spell_jaunt/jaunt_holder
	var/atom/movable/fake_overlay/animation

/spell/targeted/ethereal_jaunt/Destroy()
	if (jaunt_holder) // eject our user in case something happens and we get deleted
		var/turf/T = get_turf(jaunt_holder)
		for(var/mob/living/L in jaunt_holder)
			L.forceMove(T)
	QDEL_NULL(jaunt_holder)
	QDEL_NULL(animation)
	return ..()

/spell/targeted/ethereal_jaunt/cast(list/targets) //magnets, so mostly hardcoded
	for(var/mob/living/target in targets)
		if(HAS_TRANSFORMATION_MOVEMENT_HANDLER(target))
			continue

		if(target.buckled)
			target.buckled.unbuckle_mob()
		spawn(0)
			var/mobloc = get_turf(target.loc)
			jaunt_holder = new/obj/dummy/spell_jaunt(mobloc)
			animation = new/atom/movable/fake_overlay(mobloc)
			animation.SetName("residue")
			animation.set_density(FALSE)
			animation.anchored = TRUE
			animation.icon = 'icons/mob/mob.dmi'
			animation.layer = FLY_LAYER
			target.ExtinguishMob()
			if(target.buckled)
				target.buckled = null
			jaunt_disappear(animation, target)
			jaunt_steam(mobloc)
			target.forceMove(jaunt_holder)
			addtimer(new Callback(src, PROC_REF(start_reappear), target), duration)

/spell/targeted/ethereal_jaunt/proc/start_reappear(mob/living/user)
	var/mob_loc = jaunt_holder.last_valid_turf
	jaunt_holder.reappearing = TRUE
	jaunt_steam(mob_loc)
	jaunt_reappear(animation, user)
	animation.forceMove(mob_loc)
	addtimer(new Callback(src, PROC_REF(reappear), mob_loc, user), reappear_duration)

/spell/targeted/ethereal_jaunt/proc/reappear(mob_loc, mob/living/user)
	if(!user.forceMove(mob_loc))
		for(var/direction in list(1,2,4,8,5,6,9,10))
			var/turf/T = get_step(mob_loc, direction)
			if(T && user.forceMove(T))
				break
	user.client.eye = user
	QDEL_NULL(animation)
	QDEL_NULL(jaunt_holder)

/spell/targeted/ethereal_jaunt/empower_spell()
	if(!..())
		return 0
	duration += 2 SECONDS

	return "[src] now lasts longer."

/spell/targeted/ethereal_jaunt/proc/jaunt_disappear(atom/movable/fake_overlay/animation, mob/living/target)
	animation.icon_state = "liquify"
	flick("liquify",animation)
	playsound(get_turf(target), 'sound/magic/ethereal_enter.ogg', 30)

/spell/targeted/ethereal_jaunt/proc/jaunt_reappear(atom/movable/fake_overlay/animation, mob/living/target)
	flick("reappear",animation)
	playsound(get_turf(target), 'sound/magic/ethereal_exit.ogg', 30)

/spell/targeted/ethereal_jaunt/proc/jaunt_steam(mobloc)
	var/datum/effect/steam_spread/steam = new /datum/effect/steam_spread()
	steam.set_up(10, 0, mobloc)
	steam.start()

/obj/dummy/spell_jaunt
	name = "water"
	icon = 'icons/effects/effects.dmi'
	icon_state = "nothing"
	var/canmove = 1
	var/reappearing = 0
	density = FALSE
	anchored = TRUE
	var/turf/last_valid_turf

/obj/dummy/spell_jaunt/New(location)
	..()
	last_valid_turf = get_turf(location)

/obj/dummy/spell_jaunt/Destroy()
	// Eject contents if deleted somehow
	for(var/atom/movable/AM in src)
		AM.dropInto(loc)
	return ..()

/obj/dummy/spell_jaunt/relaymove(mob/user, direction)
	if (!canmove || reappearing) return
	var/turf/newLoc = get_step(src, direction)
	if (direction == UP || direction == DOWN)
		to_chat(user, SPAN_WARNING("You cannot go that way."))
	if (!newLoc)
		to_chat(user, SPAN_WARNING("You cannot go that way."))
	else if (!(newLoc.turf_flags & TURF_FLAG_NOJAUNT))
		forceMove(newLoc)
		var/turf/T = get_turf(loc)
		if(!T.contains_dense_objects())
			last_valid_turf = T
	else
		to_chat(user, SPAN_WARNING("Some strange aura is blocking the way!"))
	canmove = 0
	addtimer(new Callback(src, PROC_REF(allow_move)), 2)

/obj/dummy/spell_jaunt/onDropInto(atom/movable/AM)	//no dropping things while jaunting
	return

/obj/dummy/spell_jaunt/proc/allow_move()
	canmove = TRUE

/obj/dummy/spell_jaunt/ex_act(blah)
	return
/obj/dummy/spell_jaunt/bullet_act(blah)
	return

/spell/targeted/ethereal_jaunt/tower
	charge_max = 2
	spell_flags = Z2NOCAST | INCLUDEUSER
