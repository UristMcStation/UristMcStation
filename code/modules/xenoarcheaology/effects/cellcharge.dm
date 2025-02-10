//todo
/datum/artifact_effect/cellcharge
	name = "cell charge"
	effect_icon = "sparks"
	effect_type = EFFECT_ELECTRO
	var/last_message

/datum/artifact_effect/cellcharge/DoEffectTouch(mob/user)
	if(user)
		if(istype(user, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = user
			for (var/obj/item/cell/D in R.contents)
				D.charge += rand() * 100 + 50
				to_chat(R, SPAN_WARNING("SYSTEM ALERT: Large energy boost detected!"))
			return 1
		if(istype(user, /mob/living/carbon/human))
			if(user.isSynthetic())
				var/mob/living/carbon/human/H = user
				for (var/obj/item/organ/internal/cell/potato in H.contents)
					potato.cell.charge += rand() * 100 + 50
					to_chat(H, SPAN_WARNING("SYSTEM ALERT: Large energy boost detected!"))
			return 1

/datum/artifact_effect/cellcharge/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/obj/machinery/power/apc/C in range(200, T))
			for (var/obj/item/cell/B in C.contents)
				B.charge += 25
		for (var/obj/machinery/power/smes/S in range (src.effectrange,src))
			S.charge += 25
		for (var/mob/living/silicon/robot/M in range(50, T))
			for (var/obj/item/cell/D in M.contents)
				D.charge += 25
				if(world.time - last_message > 200)
					to_chat(M, SPAN_WARNING("SYSTEM ALERT: Energy boost detected!"))
					last_message = world.time
		for (var/mob/living/carbon/human/H in range(50, T))
			if(H.isSynthetic())
				for (var/obj/item/organ/internal/cell/potato in H.contents)
					potato.cell.charge += 25
					if(world.time - last_message > 200)
						to_chat(H, SPAN_WARNING("SYSTEM ALERT: Energy boost detected!"))
						last_message = world.time
		return 1

/datum/artifact_effect/cellcharge/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/obj/machinery/power/apc/C in range(200, T))
			for (var/obj/item/cell/B in C.contents)
				B.charge += rand() * 100
		for (var/obj/machinery/power/smes/S in range (src.effectrange,src))
			S.charge += 250
		for (var/mob/living/silicon/robot/M in range(100, T))
			for (var/obj/item/cell/D in M.contents)
				D.charge += rand() * 100
				if(world.time - last_message > 200)
					to_chat(M, SPAN_WARNING("SYSTEM ALERT: Energy boost detected!"))
					last_message = world.time
		for (var/mob/living/carbon/human/H in range(100, T))
			if(H.isSynthetic())
				for (var/obj/item/organ/internal/cell/potato in H.contents)
					potato.cell.charge += rand() * 100
					if(world.time - last_message > 200)
						to_chat(H, SPAN_WARNING("SYSTEM ALERT: Energy boost detected!"))
						last_message = world.time
		return 1
