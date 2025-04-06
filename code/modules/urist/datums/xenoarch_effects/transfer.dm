// Will transfer the 'sibling' effect into other objects around. Have fun containing!
// Kinda works but is also fairly janky

/datum/artifact_effect/transfer_other_effect
	name = "transfer other effect"
	effect = EFFECT_PULSE
	effect_type = EFFECT_BLUESPACE

	var/jump_chance = 50
	var/activate_other_chance = 90
	var/return_to_parent_chance = 10

	var/last_transfer_time = 0
	var/transfer_delay = 20 SECONDS

	// The other effect we're transferring
	var/weakref/associated_effect = null


/datum/artifact_effect/transfer_other_effect/New()
	..()
	effect_type = pick(EFFECT_BLUESPACE, EFFECT_ENERGY)


/datum/artifact_effect/transfer_other_effect/DoEffectGeneric(atom/holder)
	// As the Artifact code is too spaghetti to allow non-artifact objects to check triggers
	// and I CBA to refactor it just yet, we'll also allow this to trigger the other effect.
	set waitfor = FALSE

	if((world.time - src.last_transfer_time) < src.transfer_delay)
		return

	var/true_holder = isnull(holder) ? src.holder : holder

	var/datum/artifact_effect/resolved_other_effect = src.associated_effect?.resolve()

	if(isnull(resolved_other_effect) || !istype(resolved_other_effect))
		// If we don't have a sibling effect, get one
		var/obj/machinery/artifact/parent = true_holder

		if(isnull(parent) || !istype(parent))
			return

		var/datum/artifact_effect/primary_effect = parent.my_effect
		var/datum/artifact_effect/secondary_effect = parent.secondary_effect

		var/datum/artifact_effect/other_effect = primary_effect

		if(other_effect == src)
			if(isnull(secondary_effect))
				// force a secondary effect if transfer is the only one
				var/list/options = typesof(/datum/artifact_effect)
				options -= /datum/artifact_effect
				options -= /datum/artifact_effect/transfer_other_effect
				var/effecttype = pick(options)
				secondary_effect = new effecttype(src)
				parent.secondary_effect = secondary_effect

			other_effect = secondary_effect

		var/weakref/other_effect_ref = weakref(other_effect)
		src.associated_effect = other_effect_ref
		resolved_other_effect = other_effect

	var/safe_jump_chance = clamp(src.jump_chance, 0, 100)
	var/safe_activate_chance = clamp(src.activate_other_chance, 0, 100)
	var/safe_return_chance = clamp(src.return_to_parent_chance, 0, 100)

	if(isnull(resolved_other_effect.holder) || prob(safe_jump_chance))
		if(true_holder && prob(safe_return_chance))
			// return to sender
			resolved_other_effect.holder = true_holder
			src.last_transfer_time = world.time

		else
			// find a new home for our sibling
			var/processed = 0
			var/turf/T = get_turf(true_holder)

			for(var/obj/O in range(effectrange, T))
				processed++

				if(!(processed % 20))
					sleep(0)

				resolved_other_effect.holder = O
				src.last_transfer_time = world.time
				break

	if(prob(safe_activate_chance))
		resolved_other_effect.DoActivation(TRUE)

	return


/datum/artifact_effect/transfer_other_effect/DoEffectTouch(mob/toucher)
	src.DoEffectGeneric(src.holder)


/datum/artifact_effect/cultify/DoEffectAura(atom/holder)
	src.DoEffectGeneric(holder)


/datum/artifact_effect/transfer_other_effect/DoEffectPulse(atom/holder)
	src.DoEffectGeneric(holder)

