/datum/artifact_effect/roboheal
	name = "robotic healing"
	var/last_message

/datum/artifact_effect/roboheal/New()
	..()
	effect_type = pick(EFFECT_ELECTRO, EFFECT_PARTICLE)

/datum/artifact_effect/roboheal/DoEffectTouch(mob/user)
	if(user)
		if ((istype(user)) && (user.isSynthetic()))
			var/mob/living/R = user
			to_chat(R, SPAN_NOTICE("Your systems report damaged components mending by themselves!"))
			R.adjustBruteLoss(rand(-25,-50))
			R.adjustFireLoss(rand(-25,-50))
		return 1

/datum/artifact_effect/roboheal/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange,T))
			if(M.isSynthetic())
				if(world.time - last_message > 200)
					to_chat(M, SPAN_NOTICE("SYSTEM ALERT: Beneficial energy field detected!"))
					last_message = world.time
				M.adjustBruteLoss(-10)
				M.adjustFireLoss(-10)
				M.updatehealth()
		return 1

/datum/artifact_effect/roboheal/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange,T))
			if(M.isSynthetic())
				if(world.time - last_message > 200)
					to_chat(M, SPAN_NOTICE("SYSTEM ALERT: Structural damage has been repaired by energy pulse!"))
					last_message = world.time
				M.adjustBruteLoss(-20)
				M.adjustFireLoss(-20)
				M.updatehealth()
		return 1

/datum/artifact_effect/roboheal/destroyed_effect()
	. = ..()

	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange,T))
			if(M.isSynthetic())
				if(world.time - last_message > 200)
					to_chat(M, SPAN_NOTICE("SYSTEM ALERT: All structural damage has been repaired by an energy pulse!"))
					last_message = world.time
				M.adjustBruteLoss(-50000)
				M.adjustFireLoss(-50000)
				M.updatehealth()
