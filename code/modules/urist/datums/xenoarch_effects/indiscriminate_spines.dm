/obj/item/projectile/bullet/thorn
	name = "spike"
	icon_state = "SpearFlight"
	damage = 20
	damage_type = DAMAGE_BRUTE
	armor_penetration = 20
	penetrating = 3
	fire_sound = 'sound/effects/attackblob.ogg'

/datum/artifact_effect/spines
	name = "spines"
	effect_type = EFFECT_ORGANIC
	effect = EFFECT_TOUCH

/datum/artifact_effect/spines/proc/shoot(list/exempt = list())
	var/atom/A = holder
	A.visible_message(SPAN_DANGER("\The [holder] fires spines wildly in all directions!"))
	for(var/mob/living/L in oview(world.view, get_turf(holder)))
		if(chargelevel < 3)
			break

		if(L in exempt)
			continue

		var/obj/item/projectile/P = new /obj/item/projectile/bullet/thorn(get_turf(holder))
		P.launch(L, BP_CHEST)
		chargelevel -= 3


/datum/artifact_effect/spines/DoEffectTouch(mob/living/user)
	if(chargelevel < 3)
		return
	shoot(list(user))
