/datum/artifact_effect/ghostpowers
	name = "ghostly haunting"

	effect = EFFECT_PULSE
	effect_type = EFFECT_PSIONIC

	on_time = 5 MINUTES
	var/active_spoop = 0

	// anti-spam measures
	var/message_interval = 5 MINUTES
	var/list/messaged_clients = null

	// shamelessly ripped from badfeeling.dm!
	var/list/messages = list("You feel worried.",
		"Something doesn't feel right.",
		"You get a strange feeling in your gut.",
		"Your instincts are trying to warn you about something.",
		"Someone just walked over your grave.",
		"There's a strange feeling in the air.",
		"There's a strange smell in the air.",
		"The tips of your fingers feel tingly.",
		"You feel witchy.",
		"You have a terrible sense of foreboding.",
		"You've got a bad feeling about this.",
		"Your scalp prickles.",
		"The light seems to flicker.",
		"The shadows seem to lengthen.",
		"The walls are getting closer.",
		"Something is wrong."
	)


/datum/artifact_effect/ghostpowers/proc/remove_spookiness()
	if(src.active_spoop)
		src.active_spoop--
		GLOB.globally_spooky--

	return


/mob/observer/ghost/proc/flick_lights_artifact()
	// This is a 'fork' of the normal Cult verb because the Bay one doesn't have proper spoop checks -_-
	set category = "Cult"
	set name = "Flick lights"
	set desc = "Flick some lights around you."

	if(!round_is_spooky())
		to_chat(src, SPAN_NOTICE("The veil is not thin enough to let you use this power."))
		return

	if(!ghost_ability_check())
		return

	for(var/obj/machinery/light/L in range(3))
		L.flicker()

	ghost_magic_cd = world.time + 10 SECONDS


/mob/observer/ghost/proc/bloody_doodle_artifact()
	// This is a 'fork' of the normal Cult verb because the Bay one doesn't have proper spoop checks -_-
	set category = "Cult"
	set name = "Write in blood"
	set desc = "Write a short message in blood on the floor or a wall. Remember, no IC in OOC or OOC in IC."

	if(!round_is_spooky())
		return

	bloody_doodle_proc(0)


/datum/artifact_effect/ghostpowers/proc/add_ghost_powers(mob/observer/ghost/M)
	M.verbs |= /mob/observer/ghost/proc/flick_lights_artifact
	M.verbs |= /mob/observer/ghost/proc/bloody_doodle_artifact
	M.verbs |= /mob/observer/ghost/proc/ghost_dream_invasion
	return


/datum/artifact_effect/ghostpowers/New()
	..()
	if(!istype(trigger, /datum/artifact_trigger/touch))
		effect = pick(EFFECT_PULSE, EFFECT_AURA)


/datum/artifact_effect/ghostpowers/process()
	. = ..()

	if(activated)
		src.active_spoop++
		GLOB.globally_spooky++

	else
		src.active_spoop--
		GLOB.globally_spooky--


/datum/artifact_effect/ghostpowers/DoEffectGeneric(atom/holder)
	if(isnull(src.messaged_clients))
		src.messaged_clients = list()

	var/atom/true_holder = holder || src.holder

	var/turf/T = get_turf(true_holder)

	for(var/mob/observer/ghost/D in range(src.effectrange,T))
		var/client/C = resolve_client(D)

		if(isnull(C))
			continue

		if(jobban_isbanned(D, "Animal") || jobban_isbanned(D, "Spooky"))
			// Using Animal as a placeholder mostly
			continue

		var/old_message_time = src.messaged_clients[C.ckey] || 0
		var/delta_msgtime = world.time - old_message_time

		if(delta_msgtime > src.message_interval)
			to_chat(D, SPAN_WARNING("An artifact effect has made things spooky. You can mess with the living, but please respect the usual rules on such interactions; no OOC in IC!"))
			src.messaged_clients[C.ckey] = world.time

		src.add_ghost_powers(D)

	return 1


/datum/artifact_effect/ghostpowers/DoEffectTouch(mob/toucher)
	src.DoEffectGeneric(src.holder)


/datum/artifact_effect/ghostpowers/DoEffectAura(atom/holder)
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/human/H in range(src.effectrange,T))
			if(prob(30))
				to_chat(H, SPAN_WARNING("[pick(messages)]"))

	src.DoEffectGeneric(holder)


/datum/artifact_effect/ghostpowers/DoEffectPulse(atom/holder)
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/carbon/human/H in range(src.effectrange,T))
			if(prob(30))
				to_chat(H, SPAN_WARNING("[pick(messages)]"))

	src.DoEffectGeneric(holder)
