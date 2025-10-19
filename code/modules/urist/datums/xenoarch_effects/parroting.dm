// 'Enchants' a random nearby object with a talking_atom
// This makes the object a mild anomaly in its own right (parrots words heard)

/datum/artifact_effect/parrotify_object
	name = "parrotify object"
	effect_type = EFFECT_ENERGY

	// chance the effect applies
	var/parrotify_chance = 25
	var/parrotify_chance_pulse_domore = 25
	var/parrotify_chance_pulse_maxdo = 3

	// actual chance of talking
	var/parrotify_talk_chance_min = 2
	var/parrotify_talk_chance_max = 10
	var/parrotify_talk_chance = 6

	// talk 'throttle' rate, even if the prob() passes it can't be more frequent
	var/parrotify_interval_min = 5 SECONDS
	var/parrotify_interval_max = 2 MINUTES
	var/parrotify_interval = 60 SECONDS

	var/max_parrots = 3
	var/list/parrots = null


/datum/artifact_effect/parrotify_object/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_PULSE)
	effect_type = pick(EFFECT_BLUESPACE, EFFECT_ENERGY)

	// working copies w/ sanitization, so we can mess with them later
	var/working_parrotify_talk_chance_min = max(0, src.parrotify_talk_chance_min)
	var/working_parrotify_talk_chance_max = max(0, src.parrotify_talk_chance_max)
	var/working_parrotify_interval_min = max(0, src.parrotify_interval_min)
	var/working_parrotify_interval_max = max(0, src.parrotify_interval_max)

	var/talk_chance_range = (working_parrotify_talk_chance_max - working_parrotify_talk_chance_min)
	var/talk_interval_range = (working_parrotify_interval_max - working_parrotify_interval_min)

	// Balancing talk chance and delay.
	// If we picked the two values independently, some effects would only trigger very rarely and others would spam.
	// Instead, we instead roll a fraction of the value range of the two (together),
	// so that if we have a high delay, we have a high chance of triggering and vice versa.
	var/angle = rand()
	var/chance_ratio = sin(angle)
	//var/interval_ratio = 1 - chance_ratio // or cos(angle), but this way is cheaper

	// Add a randomly-rolled fraction of the maxima to the minima to get sane random values
	src.parrotify_talk_chance = working_parrotify_talk_chance_min + (chance_ratio * talk_chance_range)
	//src.parrotify_interval = working_parrotify_interval_min + (interval_ratio * talk_interval_range)
	src.parrotify_interval = working_parrotify_interval_min + (chance_ratio * talk_interval_range)


/obj/proc/check_still_listening()
	// Periodically checks if we still have a talking_atom and removes us from listening_objects if not.
	// This is an optimization to remove garbage from the global list.
	// This should ONLY be used for objects who are NOT listening themselves otherwise (i.e. w/o the atom)!

	if(!src.talking_atom)
		GLOB.listening_objects -= src
		return

	// schedule another check
	// not TIMER_LOOP because we only want to do this if we have a talking_atom
	addtimer(new Callback(src, TYPE_PROC_REF(/obj, check_still_listening), 2 MINUTES), TIMER_UNIQUE | TIMER_NO_HASH_WAIT | TIMER_OVERRIDE)
	return


/datum/artifact_effect/parrotify_object/DoEffectTouch(mob/user)
	if(!istype(user))
		return

	var/safe_chance = clamp(src.parrotify_chance, 0, 100)

	if(isnull(src.parrots))
		src.parrots = list()

	// We need to recheck all stored refs to see if they exist
	// Might as well rebuild a clean list to do that.
	var/list/live_parrots = list()

	if(!isnull(src.parrots))
		for(var/weakref/parrot_ref in src.parrots)
			var/atom/parrot = parrot_ref.resolve()

			if(!isnull(parrot))
				live_parrots.Add(parrot_ref)

	for(var/obj/item/I in user)
		if(length(live_parrots) >= src.max_parrots)
			break

		if(I.talking_atom)
			continue

		if(istype(I, /obj/item/organ) || istype(I, /obj/item/underwear))
			continue

		if(prob(safe_chance))
			var/datum/talking_atom/new_parrot = new(I)

			new_parrot.talk_chance = src.parrotify_talk_chance
			new_parrot.talk_interval = src.parrotify_interval

			I.visible_message("\The [I] shimmers and vibrates briefly.", "\The [I] vibrates briefly.")
			I.talking_atom = new_parrot
			GLOB.listening_objects |= I
			live_parrots.Add(weakref(I))
			addtimer(new Callback(I, TYPE_PROC_REF(/obj, check_still_listening), 2 MINUTES), TIMER_UNIQUE | TIMER_NO_HASH_WAIT | TIMER_OVERRIDE)
			break

	// update stored refs with the refreshed ones
	src.parrots = live_parrots


/datum/artifact_effect/parrotify_object/DoEffectPulse(atom/holder)
	var/safe_chance = clamp(src.parrotify_chance, 0, 100)
	var/true_holder = isnull(holder) ? src.holder : holder
	var/parrotified = 0

	if(isnull(src.parrots))
		src.parrots = list()

	// We need to recheck all stored refs to see if they exist
	// Might as well rebuild a clean list to do that.
	var/list/live_parrots = list()

	if(!isnull(src.parrots))
		for(var/weakref/parrot_ref in src.parrots)
			var/atom/parrot = parrot_ref.resolve()

			if(!isnull(parrot))
				live_parrots.Add(parrot_ref)

	if(true_holder)
		var/turf/T = get_turf(true_holder)

		for(var/obj/item/I in range(effectrange, T))
			if(length(live_parrots) >= src.max_parrots)
				break

			if(I.talking_atom)
				continue

			if(prob(safe_chance))
				var/datum/talking_atom/new_parrot = new(I)

				new_parrot.talk_chance = src.parrotify_talk_chance
				new_parrot.talk_interval = src.parrotify_interval

				I.visible_message("\The [I] shimmers and vibrates briefly.", "\The [I] vibrates briefly.")
				I.talking_atom = new_parrot
				GLOB.listening_objects |= I
				live_parrots.Add(weakref(I))

				addtimer(new Callback(I, TYPE_PROC_REF(/obj, check_still_listening), 2 MINUTES), TIMER_UNIQUE | TIMER_NO_HASH_WAIT | TIMER_OVERRIDE)

				if(++parrotified >= src.parrotify_chance_pulse_maxdo || !prob(src.parrotify_chance_pulse_domore))
					break

	// update stored refs with the refreshed ones
	src.parrots = live_parrots
