// Ethanol Based Recipes go here - Y





// Traitor Ethanol Recipes

/datum/reagent/ethanol/uristhomebrew
	name = "Urists Moonshine"
	description = "Pure 100% distilled plump helmet ethanol"
	taste_description = "liquid fire, plump helmets"
	color = "#b31978"
	strength = 5 // STRIKE THE MEDBAY!
	glass_name = "urist's"
	glass_desc = "It smells like pure grain alcohol, and has small clumps of plump helmet floating in it."

// Gimmick Ethanol Recipes

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

/datum/reagent/drink/pilk/affect_ingest(mob/living/carbon/M, alien, removed)
	..()
	M.adjustBrainLoss(0.1)

/datum/reagent/drink/napalk
	name = "Napalk"
	description = "A horrible flurry of substance."
	taste_description = "curdled milk and gasoline"
	reagent_state = LIQUID
	color = "#76685f"

	glass_name = "Napalk"
	glass_desc = "A glass of napalk, a combination of napalm and pilk. What compells you to drink this?"
	glass_special = list(DRINK_VAPOR)

/datum/reagent/drink/napalk/affect_ingest(mob/living/carbon/M, alien, removed)
	..()
	M.adjustToxLoss(0.5)
	M.adjustBrainLoss(0.2)
