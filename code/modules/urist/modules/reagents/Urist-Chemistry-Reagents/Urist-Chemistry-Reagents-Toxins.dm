// All Toxic or Highly Dangerous Urist Chems go here!

// Urist Zombie Microbes
/datum/reagent/xenomicrobes/uristzombie
	metabolism = REM
	var/target_organ = BP_BRAIN

	var/symptom_msgs = list(
		"Your teeth feel loose.",
		"Your eyes are rheumy.",
		"Your blood feels scratchy.",
		"You joints feel stiff.",
		"Bumps stand out on your skin.",
		"Your intestines roil.",
		"You feel light-headed.",
		"Your throat hurts.",
		"You feel fluid sloshing inside you.",
		"Your chest feels tight.",
		"You hear a crackling noise from inside of you.",
		"Pus seeps from your eyes.",
		"Your skin comes out in lesions.",
		"The flesh at the back of your throat sloughs off.",
		"Your joints ache.",
		"Your fingernail falls off, the skin underneath blistered.",
		"You taste iron."
	)
	var/transformation_msgs = list(
		"Steel wool is scrubbing against your brain.",
		"Greasy sand seems to fill your blood vessels.",
		"Grey oil oozes out of your ears.",
		"You smell spoiling meat. You drool at the thought.",
		"Your tongue swells up and turns black."
	)

/datum/reagent/xenomicrobes/uristzombie/affect_touch(mob/living/carbon/M, alien, removed)
	affect_blood(M, alien, removed * 0.5)

/datum/reagent/xenomicrobes/uristzombie/affect_blood(mob/living/carbon/M, alien, removed)
	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/true_dose = H.chem_doses[type] + volume
		var/idlemsg_proba = 10

		if(true_dose > 10 && prob(clamp(50*(true_dose-10)/(true_dose+15), 0, 100)))
			if(prob(1))
				// psych!
				to_chat(H, "<span class='warning'>[pick(transformation_msgs)]</span>")

			else if(prob(clamp(true_dose+0.1*H.getBrainLoss(), 0, 25)))
				idlemsg_proba = 5 // symptom spam avoidance
				var/organs = list(BP_R_ARM,BP_L_LEG,BP_L_ARM,BP_R_LEG,BP_GROIN,BP_CHEST)
				var/undecayed_ctr = length(organs) // make your own immature joke here

				for(var/organ_tag in organs)
					var/obj/item/organ/external/E = H.organs_by_name[organ_tag]
					if (E && !(E.status & ORGAN_DEAD) && !(BP_IS_ROBOTIC(E) || BP_IS_CRYSTAL(E)))
						if(prob(10))
							continue

						var/decay_msg = pick(
							"Your [E.name] feels stiff.",
							"You smell something foul.",
							"Flesh on your [E.name] turns black.",
							"You can't feel the skin on your [E.name].",
							"You can feel blood clotting in your [E.name].")
						E.status |= ORGAN_DEAD
						to_chat(H, "<span class='warning'>[decay_msg]</span>")

						for (var/obj/item/organ/external/C in E.children)
							if (C && !(C.status & ORGAN_DEAD) && !(BP_IS_ROBOTIC(C) || BP_IS_CRYSTAL(C)))
								C.status |= ORGAN_DEAD
						break
					else
						undecayed_ctr--

				H.update_body(1)

				if(prob(clamp(100-100*(undecayed_ctr/length(organs)), 0, 100)))
					// NOTE: this *deliberately* does not care if the mob lost the limb.
					// So, reverse necromorph - less limbs => less tissue to infect.
					var/obj/item/organ/external/Head = H.organs_by_name[BP_HEAD]
					if (Head)
						if(!(Head.status & ORGAN_DEAD))
							Head.status |= ORGAN_DEAD
							for (var/obj/item/organ/external/C in Head.children)
								C.status |= ORGAN_DEAD
						else
							H.uZombify(1, 1, transformation_msgs)
		else
			// almost straight copy of plain reagent/toxin/affect_blood()
			M.add_chemical_effect(CE_TOXIN, 5)
			var/dam = 0.05 * rand(1, 20)
			if(target_organ)
				var/obj/item/organ/internal/I = H.internal_organs_by_name[target_organ]
				if(I)
					var/can_damage = I.max_damage - I.damage
					if(can_damage > 0)
						if(dam > can_damage)
							I.take_internal_damage(can_damage, silent=TRUE)
							dam -= can_damage
						else
							I.take_internal_damage(dam, silent=TRUE)
							dam = 0
			if(dam)
				// nerfed damage w/ target_organ here -scr
				M.adjustToxLoss(target_organ ? (dam * 0.25) : dam)
			// endcopy

		// custom sadism
		if(prob(clamp(idlemsg_proba, 0, 100)))
			to_chat(H, "<span class='warning'>[pick(symptom_msgs)]</span>")

		if(prob(clamp(true_dose, 0, 100)))
			H.reagents.add_reagent(src.type, rand(removed, 0.1*true_dose))

		H.add_chemical_effect(CE_PAINKILLER, 40)

		// transforming sanics the victim's metabolism:
		H.add_chemical_effect(CE_PULSE, 4)
		H.nutrition -= min(H.nutrition, true_dose)
		H.bodytemperature = max(H.bodytemperature, H.species.heat_discomfort_level + rand(5, 15))
		if(prob(clamp(5+true_dose, 0, 20)))
			H.make_jittery(5)
