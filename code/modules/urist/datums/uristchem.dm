/singleton/reaction/pilk
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

/datum/reagent/drink/pilk/affect_ingest(mob/living/carbon/M, alien, removed)
	..()
	M.adjustBrainLoss(0.1)

/singleton/reaction/napalk
	name = "Napalk"
	result = /datum/reagent/drink/napalk
	required_reagents = list(/datum/reagent/drink/pilk = 1, /datum/reagent/napalm = 1)
	result_amount = 2
	mix_message = "The pilk mixes with the gooey napalm, forming a slick slurry of a substance that reeks of milk and gasoline. This is a crime against humanity."

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

/singleton/reaction/spacelube // Restores Space Lube from Bay Merge.
	name = "Space Lube"
	result = /datum/reagent/lube
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/silicon = 1, /datum/reagent/acetone = 1)
	result_amount = 4
	mix_message = "The solution becomes thick and slimy."

/datum/reagent/lube
	name = "Space Lube"
	description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them."
	taste_description = "slime"
	reagent_state = LIQUID
	color = "#009ca8"
	value = 0.6
	should_admin_log = TRUE // So we can see who's spraying the hallways.

/datum/reagent/lube/touch_turf(turf/simulated/T)
	if(!istype(T))
		return
	if(volume >= 1)
		T.wet_floor(80) // Restored original wet floor value.

/datum/reagent/ethanol/uristhomebrew
	name = "Urists Moonshine"
	description = "Pure 100% distilled plump helmet ethanol"
	taste_description = "liquid fire, plump helmets"
	color = "#4c3100" // Looks more spirit-like instead of wine to be less noticable.
	strength = 2 // STRIKE THE MEDBAY!
