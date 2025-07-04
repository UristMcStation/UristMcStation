/mob/living/carbon/Initialize(mapload)
	//setup reagent holders
	bloodstr = new/datum/reagents/metabolism(120, src, CHEM_BLOOD)
	touching = new/datum/reagents/metabolism(1000, src, CHEM_TOUCH)
	reagents = bloodstr

	if (!default_language && species_language)
		default_language = all_languages[species_language]
	. = ..()


/mob/living/carbon/Destroy()
	QDEL_NULL(touching)
	bloodstr = null // We don't qdel(bloodstr) because it's the same as qdel(reagents)
	QDEL_NULL_LIST(internal_organs)
	QDEL_NULL_LIST(hallucinations)
	if(loc)
		for(var/mob/M in contents)
			M.dropInto(loc)
	else
		for(var/mob/M in contents)
			qdel(M)
	return ..()

/mob/living/carbon/rejuvenate()
	bloodstr.clear_reagents()
	touching.clear_reagents()
	var/datum/reagents/R = get_ingested_reagents()
	if(istype(R))
		R.clear_reagents()
	set_nutrition(400)
	set_hydration(400)
	stop_allergy()
	..()

/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(!.)
		return

	if(stat != DEAD)

		if((MUTATION_FAT in src.mutations) && (move_intent.flags & MOVE_INTENT_EXERTIVE) && src.bodytemperature <= 360)
			bodytemperature += 2

		var/nut_removed = DEFAULT_HUNGER_FACTOR/10
		var/hyd_removed = DEFAULT_THIRST_FACTOR/10
		if (move_intent.flags & MOVE_INTENT_EXERTIVE)
			nut_removed *= 2
			hyd_removed *= 2
		adjust_nutrition(-nut_removed)
		adjust_hydration(-hyd_removed)

	// Moving around increases germ_level faster
	if(germ_level < GERM_LEVEL_MOVE_CAP && prob(8))
		germ_level++

/mob/living/carbon/relaymove(mob/living/user, direction)
	if((user in contents) && istype(user))
		if(user.last_special <= world.time)
			user.last_special = world.time + 50
			src.visible_message(SPAN_DANGER("You hear something rumbling inside [src]'s stomach..."))
			var/obj/item/I = user.get_active_hand()
			if(I && I.force)
				var/d = rand(round(I.force / 4), I.force)
				if(istype(src, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = src
					var/obj/item/organ/external/organ = H.get_organ(BP_CHEST)
					if (istype(organ))
						organ.take_external_damage(d, 0)
					H.updatehealth()
				else
					src.take_organ_damage(d, 0)
				user.visible_message(SPAN_DANGER("[user] attacks [src]'s stomach wall with the [I.name]!"))
				playsound(user.loc, 'sound/effects/attackblob.ogg', 50, 1)

				if(prob(src.getBruteLoss() - 50))
					gib()

/mob/living/carbon/gib()
	for(var/mob/M in contents)
		if(is_species(SPECIES_DIONA) && istype(M, /mob/living/carbon/alien/diona) && (M.stat != DEAD))
			continue
		M.dropInto(loc)
		visible_message(SPAN_DANGER("\The [M] bursts out of \the [src]!"))
	..()

/mob/living/carbon/proc/clear_coughedtime()
	coughedtime = 0

/mob/living/carbon/attack_hand(mob/M as mob)
	if(!istype(M, /mob/living/carbon)) return
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
		if (H.hand)
			temp = H.organs_by_name[BP_L_HAND]
		if(temp && !temp.is_usable())
			to_chat(H, SPAN_WARNING("You can't use your [temp.name]"))
			return

	return

///Processes stabbing eyes with any sharp items. Only works for normal sized or smaller items; if attacking eyes with a large sword will default to parent use_weapon and do a regular attack.
/mob/living/carbon/use_weapon(obj/item/weapon, mob/living/user, list/click_params)
	if (iscarbon(user) && user.a_intent == I_HURT && user.zone_sel.selecting == BP_EYES && weapon.can_puncture() && get_max_health() && weapon.w_class <= ITEM_SIZE_NORMAL)
		var/hit_zone = resolve_item_attack(weapon, user, user.zone_sel.selecting)
		if (!hit_zone) //Miss message to user is processed in resolve_item_attack.
			return TRUE
		if (hit_zone == BP_HEAD || hit_zone == BP_EYES) //Resolve_item_attack on non-self mobs never returns BP_EYES, but changes it to BP_HEAD because of check_zone()
			return weapon.eyestab(src, user)
	else return ..()


/mob/living/carbon/electrocute_act(shock_damage, obj/source, siemens_coeff = 1.0, def_zone = null)
	if(status_flags & GODMODE)	return 0	//godmode

	shock_damage = apply_shock(shock_damage, def_zone, siemens_coeff)

	if(!shock_damage)
		return 0

	stun_effect_act(agony_amount=shock_damage, def_zone=def_zone)

	playsound(loc, "sparks", 50, 1, -1)
	if (shock_damage > 15)
		src.visible_message(
			SPAN_WARNING("[src] was electrocuted[source ? " by the [source]" : ""]!"), \
			SPAN_DANGER("You feel a powerful shock course through your body!"), \
			SPAN_WARNING("You hear a heavy electrical crack.") \
		)
	else
		src.visible_message(
			SPAN_WARNING("[src] was shocked[source ? " by the [source]" : ""]."), \
			SPAN_WARNING("You feel a shock course through your body."), \
			SPAN_WARNING("You hear a zapping sound.") \
		)

	switch(shock_damage)
		if(11 to 15)
			Stun(1)
		if(16 to 20)
			Stun(2)
		if(21 to 25)
			Weaken(2)
		if(26 to 30)
			Weaken(5)
		if(31 to INFINITY)
			Weaken(10) //This should work for now, more is really silly and makes you lay there forever

	make_jittery(min(shock_damage*5, 200))

	var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
	s.set_up(5, 1, loc)
	s.start()

	return shock_damage

/mob/living/carbon/proc/apply_shock(shock_damage, def_zone, siemens_coeff = 1.0)
	shock_damage *= siemens_coeff
	if(shock_damage < 0.5)
		return 0
	if(shock_damage < 1)
		shock_damage = 1
	apply_damage(shock_damage, DAMAGE_BURN, def_zone, used_weapon="Electrocution")
	return(shock_damage)


/mob/proc/swap_hand()
	GLOB.hands_swapped_event.raise_event(src)


/mob/living/carbon/swap_hand()
	. = ..()
	hand = !hand
	if(hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		if(hand)	//This being 1 means the left hand is in use
			hud_used.l_hand_hud_object.icon_state = "l_hand_active"
			hud_used.r_hand_hud_object.icon_state = "r_hand_inactive"
		else
			hud_used.l_hand_hud_object.icon_state = "l_hand_inactive"
			hud_used.r_hand_hud_object.icon_state = "r_hand_active"
	var/obj/item/I = get_active_hand()
	if(istype(I))
		I.on_active_hand(src)

/mob/living/carbon/proc/activate_hand(selhand) //0 or "r" or "right" for right hand; 1 or "l" or "left" for left hand.

	if(istext(selhand))
		selhand = lowertext(selhand)

		if(selhand == "right" || selhand == "r")
			selhand = 0
		if(selhand == "left" || selhand == "l")
			selhand = 1

	if(selhand != src.hand)
		swap_hand()

/mob/living/carbon/proc/help_shake_act(mob/living/carbon/M)
	var/datum/pronouns/P = src.choose_from_pronouns()
	if(!is_asystole())
		if (on_fire)
			playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			if (M.on_fire)
				M.visible_message(SPAN_WARNING("[M] tries to pat out [src]'s flames, but to no avail!"),
				SPAN_WARNING("You try to pat out [src]'s flames, but to no avail! Put yourself out first!"))
			else
				M.visible_message(SPAN_WARNING("[M] tries to pat out [src]'s flames!"),
				SPAN_WARNING("You try to pat out [src]'s flames! Hot!"))
				if(do_after(M, 1.5 SECONDS, src, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
					src.fire_stacks -= 0.5
					if (prob(10) && (M.fire_stacks <= 0))
						M.fire_stacks += 1
					M.IgniteMob()
					if (M.on_fire)
						M.visible_message(SPAN_DANGER("The fire spreads from [src] to [M]!"),
						SPAN_DANGER("The fire spreads to you as well!"))
					else
						src.fire_stacks -= 0.5 //Less effective than stop, drop, and roll - also accounting for the fact that it takes half as long.
						if (src.fire_stacks <= 0)
							M.visible_message(SPAN_WARNING("[M] successfully pats out [src]'s flames."),
							SPAN_WARNING("You successfully pat out [src]'s flames."))
							src.ExtinguishMob()
							src.fire_stacks = 0
		else
			if (istype(src,/mob/living/carbon/human) && src:w_uniform)
				var/mob/living/carbon/human/H = src
				H.w_uniform.add_fingerprint(M)

			var/show_ssd
			var/mob/living/carbon/human/H = src
			if(istype(H)) show_ssd = H.species.show_ssd
			if(show_ssd && ssd_check())
				M.visible_message(SPAN_NOTICE("[M] shakes [src] trying to wake [P.him] up!"), \
				SPAN_NOTICE("You shake [src], but they do not respond... Maybe they have S.S.D?"))
			else if(lying || sleeping || player_triggered_sleeping)
				player_triggered_sleeping = 0
				AdjustSleeping(-5)
				M.visible_message(SPAN_NOTICE("[M] shakes [src] trying to wake [P.him] up!"), \
									SPAN_NOTICE("You shake [src] trying to wake [P.him] up!"))
			else
				var/mob/living/carbon/human/hugger = M
				if(istype(hugger))
					hugger.species.hug(hugger,src)
				else
					M.visible_message(SPAN_NOTICE("[M] hugs [src] to make [P.him] feel better!"), \
								SPAN_NOTICE("You hug [src] to make [P.him] feel better!"))

				if(M.fire_stacks >= (src.fire_stacks + 3))
					src.fire_stacks += 1
					M.fire_stacks -= 1
				if(M.on_fire)
					src.IgniteMob()

			if(stat != DEAD)
				AdjustParalysis(-3)
				AdjustStunned(-3)
				AdjustWeakened(-3)

			playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

/mob/living/carbon/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /obj/screen/fullscreen/flash)
	if(eyecheck() < intensity || override_blindness_check)
		return ..()

// ++++ROCKDTBEN++++ MOB PROCS -- Ask me before touching.
// Stop! ... Hammertime! ~Carn

/mob/living/carbon/proc/getDNA()
	return dna

/mob/living/carbon/proc/setDNA(datum/dna/newDNA)
	dna = newDNA

// ++++ROCKDTBEN++++ MOB PROCS //END

//Throwing stuff
/mob/proc/throw_item(atom/target)
	return

/mob/living/carbon/throw_item(atom/target)
	if (istype(loc, /obj/item/holder))
		var/obj/item/holder/H = loc
		if (istype(H.loc, /obj/item/organ/internal/stomach))
			return

	src.throw_mode_off()
	if(src.stat || !target)
		return
	if(target.type == /obj/screen) return

	var/atom/movable/item = src.get_active_hand()

	if(!item) return

	var/throw_range = item.throw_range
	var/itemsize
	if (istype(item, /obj/item/grab))
		var/obj/item/grab/G = item
		item = G.throw_held() //throw the person instead of the grab
		if(ismob(item))
			var/mob/M = item

			//limit throw range by relative mob size
			throw_range = round(M.throw_range * min(src.mob_size/M.mob_size, 1))
			itemsize = round(M.mob_size/4)
			var/turf/start_T = get_turf(loc) //Get the start and target tile for the descriptors
			var/turf/end_T = get_turf(target)
			if(start_T && end_T && usr == src)
				var/start_T_descriptor = SPAN_COLOR("#6b5d00", "[start_T] \[[start_T.x],[start_T.y],[start_T.z]\] ([start_T.loc])")
				var/end_T_descriptor = SPAN_COLOR("#6b4400", "[start_T] \[[end_T.x],[end_T.y],[end_T.z]\] ([end_T.loc])")
				admin_attack_log(usr, M, "Threw the victim from [start_T_descriptor] to [end_T_descriptor].", "Was from [start_T_descriptor] to [end_T_descriptor].", "threw, from [start_T_descriptor] to [end_T_descriptor], ")

	else if (istype(item, /obj/item))
		var/obj/item/I = item
		itemsize = I.w_class

	if(!unEquip(item))
		return
	if(!item || !isturf(item.loc))
		return

	//actually throw it!
	var/message = "\The [src] has thrown \the [item]."
	src.visible_message(SPAN_WARNING("[message]"), range = min(itemsize*2,world.view))

	if(!src.lastarea)
		src.lastarea = get_area(src.loc)
	if(!check_space_footing())
		if(prob((itemsize * itemsize * 10) * MOB_MEDIUM/src.mob_size))
			var/direction = get_dir(target, src)
			step(src,direction)
			space_drift(direction)


/*
	if(istype(src.loc, /turf/space) || (src.flags & NOGRAV)) //they're in space, move em one space in the opposite direction
		src.inertia_dir = get_dir(target, src)
		step(src, inertia_dir)
*/


	item.throw_at(target, throw_range, item.throw_speed, src)

	playsound(src, 'sound/effects/throw.ogg', 50, 1)
	animate_throw(src)

/mob/living/carbon/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if (status_flags & GODMODE)
		return
	..()
	var/temp_inc = max(min(BODYTEMP_HEATING_MAX*(1-get_heat_protection()), exposed_temperature - bodytemperature), 0)
	bodytemperature += temp_inc

/mob/living/carbon/can_use_hands()
	if(handcuffed)
		return 0
	if(buckled && ! istype(buckled, /obj/structure/bed/chair)) // buckling does not restrict hands
		return 0
	return 1

/mob/living/carbon/restrained()
	if (handcuffed)
		return 1
	return

/mob/living/carbon/u_equip(obj/item/W as obj)
	if(!W)	return 0

	else if (W == handcuffed)
		handcuffed = null
		update_inv_handcuffed()
		if(buckled && buckled.buckle_require_restraints)
			buckled.unbuckle_mob()
	else
		..()

	return

/mob/living/carbon/verb/mob_sleep()
	set name = "Sleep"
	set category = "IC"

	if(alert("Are you sure you want to [player_triggered_sleeping ? "wake up?" : "sleep for a while? Use 'sleep' again to wake up"]", "Sleep", "No", "Yes") == "Yes")
		player_triggered_sleeping = !player_triggered_sleeping

/mob/living/carbon/Bump(atom/movable/AM, called)
	if(now_pushing || !called)
		return
	..()

/mob/living/carbon/slip(slipped_on, stun_duration = 8)
	if(!has_gravity())
		return FALSE

	if(buckled)
		return FALSE

	stop_pulling()
	to_chat(src, SPAN_WARNING("You slipped on [slipped_on]!"))
	playsound(loc, 'sound/misc/slip.ogg', 50, 1, -3)
	Weaken(floor(stun_duration/2))
	return TRUE

/mob/living/carbon/proc/add_chemical_effect(effect, magnitude = 1)
	if(effect in chem_effects)
		chem_effects[effect] += magnitude
	else
		chem_effects[effect] = magnitude

/mob/living/carbon/proc/add_up_to_chemical_effect(effect, magnitude = 1)
	if(effect in chem_effects)
		chem_effects[effect] = max(magnitude, chem_effects[effect])
	else
		chem_effects[effect] = magnitude

/mob/living/carbon/get_default_language()
	if(default_language && can_speak(default_language))
		return default_language

/mob/living/carbon/proc/get_any_good_language(set_default=FALSE)
	var/datum/language/result = get_default_language()
	if (!result)
		for (var/datum/language/L in languages)
			if (can_speak(L))
				result = L
				if (set_default)
					set_default_language(result)
				break
	return result

/mob/living/carbon/show_inv(mob/user as mob)
	var/dat = {"
	<BR><B>Head(Mask):</B> <A href='byond://?src=\ref[src];item=mask'>[(wear_mask ? wear_mask : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='byond://?src=\ref[src];item=l_hand'>[(l_hand ? l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='byond://?src=\ref[src];item=r_hand'>[(r_hand ? r_hand : "Nothing")]</A>
	<BR><B>Back:</B> <A href='byond://?src=\ref[src];item=back'>[(back ? back : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/tank) && !( internal )) ? text(" <A href='byond://?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR>[(internal ? text("<A href='byond://?src=\ref[src];item=internal'>Remove Internal</A>") : "")]
	<BR><A href='byond://?src=\ref[src];item=pockets'>Empty Pockets</A>
	<BR><A href='byond://?src=\ref[user];refresh=1'>Refresh</A>
	<BR>"}
	var/datum/browser/popup = new(user, "mob[name]", name, 325, 500)
	popup.set_content(dat)
	popup.open()
	return

/**
 *  Return FALSE if victim can't be devoured, DEVOUR_FAST if they can be devoured quickly, DEVOUR_SLOW for slow devour
 */
/mob/living/carbon/proc/can_devour(atom/movable/victim)
	return FALSE

/mob/living/carbon/proc/should_have_organ(organ_check)
	return 0

/mob/living/carbon/proc/can_feel_pain(check_organ)
	if(isSynthetic())
		return 0
	return !(species && species.species_flags & SPECIES_FLAG_NO_PAIN)

/mob/living/carbon/proc/get_adjusted_metabolism(metabolism)
	return metabolism

/mob/living/carbon/proc/need_breathe()
	return

/mob/living/carbon/check_has_mouth()
	// carbon mobs have mouths by default
	// behavior of this proc for humans is overridden in human.dm
	return 1

/mob/living/carbon/proc/check_mouth_coverage()
	// carbon mobs do not have blocked mouths by default
	// overridden in human_defense.dm
	return null

/mob/living/carbon/proc/SetStasis(factor, source = "misc")
	if((species && (species.species_flags & SPECIES_FLAG_NO_SCAN)) || isSynthetic())
		return
	stasis_sources[source] = factor

/mob/living/carbon/InStasis()
	if(!stasis_value)
		return FALSE
	return life_tick % stasis_value

// call only once per run of life
/mob/living/carbon/proc/UpdateStasis()
	stasis_value = 0
	if((species && (species.species_flags & SPECIES_FLAG_NO_SCAN)) || isSynthetic())
		return
	for(var/source in stasis_sources)
		stasis_value += stasis_sources[source]
	stasis_sources.Cut()

/mob/living/carbon/has_chem_effect(chem, threshold)
	return (chem_effects[chem] >= threshold)

/mob/living/carbon/get_sex()
	return species.get_sex(src)

/mob/living/carbon/proc/get_ingested_reagents()
	return reagents

/mob/living/carbon/proc/set_nutrition(amt)
	nutrition = clamp(amt, 0, initial(nutrition))

/mob/living/carbon/proc/adjust_nutrition(amt)
	set_nutrition(nutrition + amt)

/mob/living/carbon/proc/set_hydration(amt)
	hydration = clamp(amt, 0, initial(hydration))

/mob/living/carbon/proc/adjust_hydration(amt)
	set_hydration(hydration + amt)

/mob/living/carbon/proc/set_internals(obj/item/tank/source, source_string)
	var/old_internal = internal

	internal = source

	if(!old_internal && internal)
		if(!source_string)
			source_string = source.name
		to_chat(src, SPAN_NOTICE("You are now running on internals from \the [source_string]."))
		playsound(src, 'sound/effects/internals.ogg', 50, 0)
	if(old_internal && !internal)
		to_chat(src, SPAN_WARNING("You are no longer running on internals."))
	if(internals)
		internals.icon_state = "internal[!!internal]"

/mob/living/carbon/proc/vomit(timevomit = 1, level = 3, delay = 0)
	return
