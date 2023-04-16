/datum/chemical_reaction/pilk
	name = "Pilk"
	result = /datum/reagent/drink/pilk
	required_reagents = list(/datum/reagent/drink/milk = 1, /datum/reagent/drink/space_cola = 1)
	result_amount = 2
	mix_message = "The cola mixes together with the milk, forming a gross, off-brown substance. A chill goes down your spine, and in the distance, you think you can hear someone weeping."

/datum/reagent/drink/pilk
	name = "Pilk"
	description = "Hell, in drink form."
	taste_description = "crushing depression and lactose"
	reagent_state = LIQUID
	color = "#bfa17b"
	adj_drowsy = -1
	adj_temp = -2

	glass_name = "Pilk"
	glass_desc = "A glass of pilk, an unholy combination of milk and cola. There's a special place in hell for people who mix this drink."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/pilk/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.adjustBrainLoss(0.1)

/datum/reagent/coagulant
	name = "Coagulant"
	description = "An experimental coagulant capable of staunching both internal and external bleeding."
	taste_description = "iron"
	reagent_state = LIQUID
	color = "#bf0000"
	metabolism = REM * 0.05
	scannable = TRUE

/datum/reagent/coagulant/affect_blood(mob/living/carbon/M, alien, removed)
	if(alien == IS_DIONA)
		return
	if(ishuman(M))
		for(var/obj/item/organ/external/E in M.organs)
			if(E.status & ORGAN_ARTERY_CUT && prob(10))
				E.status &= ~ORGAN_ARTERY_CUT
			for(var/datum/wound/W in E.wounds)
				if(W.bleeding() && prob(20))
					W.bleed_timer = 0
					W.clamped = TRUE
					E.status &= ~ORGAN_BLEEDING