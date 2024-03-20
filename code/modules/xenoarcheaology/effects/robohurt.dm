/datum/artifact_effect/robohurt
	name = "robotic harm"
	var/last_message

/datum/artifact_effect/robohurt/New()
	..()
	effect_type = pick(EFFECT_ELECTRO, EFFECT_PARTICLE)

/datum/artifact_effect/robohurt/DoEffectTouch(mob/living/user)
	if(user)
		if ((istype(user)) && (user.isSynthetic()))
			var/mob/living/R = user
			to_chat(R, SPAN_DANGER("Your systems report severe damage has been inflicted!"))
			R.adjustBruteLoss(rand(25,50))
			R.adjustFireLoss(rand(25,50))
		return 1

/datum/artifact_effect/robohurt/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange,T))
			if(M.isSynthetic())
				if(world.time - last_message > 200)
					to_chat(M, SPAN_DANGER("SYSTEM ALERT: Harmful energy field detected!"))
					last_message = world.time
				M.adjustBruteLoss(10)
				M.adjustFireLoss(10)
				M.updatehealth()
		return 1

/datum/artifact_effect/robohurt/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange,T))
			if(M.isSynthetic())
				if(world.time - last_message > 200)
					to_chat(M, SPAN_DANGER("SYSTEM ALERT: Structural damage inflicted by energy pulse!"))
					last_message = world.time
				M.adjustBruteLoss(20)
				M.adjustFireLoss(20)
				M.updatehealth()
		return 1

/datum/artifact_effect/robohurt/destroyed_effect()
	. = ..()

	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange,T))
			if(M.isSynthetic())
				if(world.time - last_message > 200)
					to_chat(M, SPAN_DANGER("SYSTEM ALERT: Extreme structural damage detected from foreign energy pulse!"))
					last_message = world.time
				M.adjustBruteLoss(50)
				M.adjustFireLoss(50)
				M.updatehealth()
