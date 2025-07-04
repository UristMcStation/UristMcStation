#define DISPENSER_REAGENT_VALUE 0.2

/datum/reagent/acetone
	name = "Acetone"
	description = "A colorless liquid solvent used in chemical synthesis."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#808080"
	metabolism = REM * 0.2
	value = DISPENSER_REAGENT_VALUE
	accelerant_quality = 3

/datum/reagent/acetone/affect_blood(mob/living/carbon/M, removed)
	if (HAS_TRAIT(M, /singleton/trait/general/serpentid_adapted))
		return

	M.adjustToxLoss(removed * 3)

/datum/reagent/acetone/touch_obj(obj/O)	//I copied this wholesale from ethanol and could likely be converted into a shared proc. ~Techhead
	if(istype(O, /obj/item/paper))
		var/obj/item/paper/paperaffected = O
		paperaffected.clearpaper()
		to_chat(usr, "The solution dissolves the ink on the paper.")
		return
	if(istype(O, /obj/item/book))
		if(volume < 5)
			return
		if(istype(O, /obj/item/book/tome))
			to_chat(usr, SPAN_NOTICE("The solution does nothing. Whatever this is, it isn't normal ink."))
			return
		var/obj/item/book/affectedbook = O
		affectedbook.dat = null
		to_chat(usr, SPAN_NOTICE("The solution dissolves the ink on the book."))
	return

/datum/reagent/aluminium
	name = "Aluminium"
	taste_description = "metal"
	taste_mult = 1.1
	description = "A silvery white and ductile member of the boron group of chemical elements."
	reagent_state = SOLID
	color = "#a8a8a8"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/ammonia
	name = "Ammonia"
	taste_description = "mordant"
	taste_mult = 2
	description = "A caustic substance commonly used in fertilizer or household cleaners."
	reagent_state = LIQUID
	color = "#404030"
	metabolism = REM * 0.5
	overdose = 5
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/ammonia/affect_blood(mob/living/carbon/M, removed)
	if (M.species.breath_type == GAS_AMMONIA)
		M.add_chemical_effect(CE_OXYGENATED, 2)
	else if (!IS_METABOLICALLY_INERT(M))
		M.adjustToxLoss(removed * 1.5)

/datum/reagent/ammonia/overdose(mob/living/carbon/M)
	if (M.species.breath_type != GAS_AMMONIA || volume > overdose*6)
		..()

/datum/reagent/carbon
	name = "Carbon"
	description = "A chemical element, the building block of life."
	taste_description = "sour chalk"
	taste_mult = 1.5
	reagent_state = SOLID
	color = "#1c1300"
	ingest_met = REM * 5
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/carbon/affect_ingest(mob/living/carbon/M, removed)
	if (METABOLIC_INERTNESS(M) > TRAIT_LEVEL_MINOR)
		return
	var/datum/reagents/ingested = M.get_ingested_reagents()
	if (ingested && length(ingested.reagent_list) > 1) // Need to have at least 2 reagents - cabon and something to remove
		var/effect = 1 / (length(ingested.reagent_list) - 1)
		for(var/datum/reagent/R in ingested.reagent_list)
			if(R == src)
				continue
			ingested.remove_reagent(R.type, removed * effect)

/datum/reagent/carbon/touch_turf(turf/T)
	if(!istype(T, /turf/space))
		var/obj/decal/cleanable/dirt/dirtoverlay = locate(/obj/decal/cleanable/dirt, T)
		if (!dirtoverlay)
			dirtoverlay = new/obj/decal/cleanable/dirt(T)
			dirtoverlay.alpha = volume * 30
		else
			dirtoverlay.alpha = min(dirtoverlay.alpha + volume * 30, 255)

/datum/reagent/copper
	name = "Copper"
	description = "A highly ductile metal."
	taste_description = "copper"
	color = "#6e3b08"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/ethanol
	name = "Ethanol" //Parent class for all alcoholic reagents.
	description = "A well-known alcohol with a variety of applications."
	taste_description = "pure alcohol"
	reagent_state = LIQUID
	color = "#404030"
	alpha = 180
	touch_met = 5
	sugar_amount = 0.5
	var/nutriment_factor = 3 //Baseline nutriment is 10; empty calories with no real nutritious value.
	var/hydration_factor = 3 //Water is 10.
	var/strength = 10 // This is, essentially, units between stages - the lower, the stronger. Less fine tuning, more clarity.
	var/toxicity = 1

	var/druggy = 0
	var/adj_temp = 0
	var/targ_temp = 310
	var/halluci = 0

	glass_name = "ethanol"
	glass_desc = "A well-known alcohol with a variety of applications."
	value = DISPENSER_REAGENT_VALUE
	accelerant_quality = 5

/datum/reagent/ethanol/touch_mob(mob/living/L, amount)
	if(istype(L))
		L.adjust_fire_stacks(amount / 15)

/datum/reagent/ethanol/affect_blood(mob/living/carbon/M, removed)
	M.adjustToxLoss(removed * 2 * toxicity)
	return

/datum/reagent/ethanol/affect_ingest(mob/living/carbon/M, removed)
	M.adjust_nutrition(nutriment_factor * removed)
	M.adjust_hydration(hydration_factor * removed)
	var/strength_mod = (M.GetTraitLevel(/singleton/trait/malus/ethanol) * 2.5) || 1
	if (IS_METABOLICALLY_INERT(M))
		strength_mod = 0

	M.add_chemical_effect(CE_ALCOHOL, 1)
	var/effective_dose = M.chem_doses[type] * strength_mod * (1 + volume/60) //drinking a LOT will make you go down faster

	if(effective_dose >= strength) // Early warning
		M.make_dizzy(6) // It is decreased at the speed of 3 per tick
	if(effective_dose >= strength * 2) // Slurring
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		M.slurring = max(M.slurring, 30)
	if(effective_dose >= strength * 3) // Confusion - walking in random directions
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		M.set_confused(20)
	if(effective_dose >= strength * 4) // Blurry vision
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		M.eye_blurry = max(M.eye_blurry, 10)
	if(effective_dose >= strength * 5) // Drowsyness - periodically falling asleep
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		M.drowsyness = max(M.drowsyness, 20)
	if(effective_dose >= strength * 6) // Toxic dose
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, toxicity)
	if(effective_dose >= strength * 7) // Pass out
		M.Paralyse(20)
		M.Sleeping(30)

	if(druggy != 0)
		M.druggy = max(M.druggy, druggy)

	if(adj_temp > 0 && M.bodytemperature < targ_temp) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(targ_temp, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > targ_temp)
		M.bodytemperature = min(targ_temp, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

	if(halluci)
		M.adjust_hallucination(halluci, halluci)

/datum/reagent/ethanol/touch_obj(obj/O)
	if(istype(O, /obj/item/paper))
		var/obj/item/paper/paperaffected = O
		paperaffected.clearpaper()
		to_chat(usr, "The solution dissolves the ink on the paper.")
		return
	if(istype(O, /obj/item/book))
		if(volume < 5)
			return
		if(istype(O, /obj/item/book/tome))
			to_chat(usr, SPAN_NOTICE("The solution does nothing. Whatever this is, it isn't normal ink."))
			return
		var/obj/item/book/affectedbook = O
		affectedbook.dat = null
		to_chat(usr, SPAN_NOTICE("The solution dissolves the ink on the book."))
	return

/datum/reagent/hydrazine
	name = "Hydrazine"
	description = "A toxic, colorless, flammable liquid with a strong ammonia-like odor, in hydrate form."
	taste_description = "sweet tasting metal"
	reagent_state = LIQUID
	color = "#808080"
	metabolism = REM * 0.2
	touch_met = 5
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/hydrazine/affect_blood(mob/living/carbon/M, removed)
	M.adjustToxLoss(4 * removed)

/datum/reagent/hydrazine/affect_touch(mob/living/carbon/M, removed) // Hydrazine is both toxic and flammable.
	M.adjust_fire_stacks(removed / 12)
	M.adjustToxLoss(0.2 * removed)

/datum/reagent/hydrazine/touch_turf(turf/T)
	new /obj/decal/cleanable/liquid_fuel(T, volume)
	remove_self(volume)
	return

/datum/reagent/iron
	name = "Iron"
	description = "Pure iron is a metal."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#353535"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/iron/affect_ingest(mob/living/carbon/M, removed)
	if (!IS_METABOLICALLY_INERT(M))
		M.add_chemical_effect(CE_BLOODRESTORE, 8 * removed)

/datum/reagent/lithium
	name = "Lithium"
	description = "A chemical element, used as antidepressant."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#808080"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/lithium/affect_blood(mob/living/carbon/M, removed)
	if (!IS_METABOLICALLY_INERT(M))
		if(istype(M.loc, /turf/space))
			M.SelfMove(pick(GLOB.cardinal))
		if(prob(5))
			M.emote(pick("twitch", "drool", "moan"))

/datum/reagent/mercury
	name = "Mercury"
	description = "A chemical element."
	taste_mult = 0 //mercury apparently is tasteless. IDK
	reagent_state = LIQUID
	color = "#484848"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/mercury/affect_blood(mob/living/carbon/M, removed)
	if (!IS_METABOLICALLY_INERT(M))
		if(istype(M.loc, /turf/space))
			M.SelfMove(pick(GLOB.cardinal))
		if(prob(5))
			M.emote(pick("twitch", "drool", "moan"))
		M.adjustBrainLoss(0.1)

/datum/reagent/phosphorus
	name = "Phosphorus"
	description = "A chemical element, the backbone of biological energy carriers."
	taste_description = "vinegar"
	reagent_state = SOLID
	color = "#832828"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/potassium
	name = "Potassium"
	description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	taste_description = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.
	reagent_state = SOLID
	color = "#a0a0a0"
	value = DISPENSER_REAGENT_VALUE
	should_admin_log = TRUE

/datum/reagent/potassium/affect_blood(mob/living/carbon/M, removed)
	if(volume > 3)
		M.add_chemical_effect(CE_PULSE, 1)
	if(volume > 10)
		M.add_chemical_effect(CE_PULSE, 1)

/datum/reagent/radium
	name = "Radium"
	description = "Radium is an alkaline earth metal. It is extremely radioactive."
	taste_description = "the color blue, and regret"
	reagent_state = SOLID
	color = "#c7c7c7"
	value = DISPENSER_REAGENT_VALUE
	should_admin_log = TRUE

/datum/reagent/radium/affect_blood(mob/living/carbon/M, removed)
	M.apply_damage(10 * removed, DAMAGE_RADIATION, armor_pen = 100) // Radium may increase your chances to cure a disease

/datum/reagent/radium/touch_turf(turf/T)
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/decal/cleanable/greenglow/glow = locate(/obj/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/decal/cleanable/greenglow(T)
			return

/datum/reagent/acid
	name = "Sulphuric Acid"
	description = "A very corrosive mineral acid with the molecular formula H2SO4."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#db5008"
	metabolism = REM * 2
	touch_met = 50 // It's acid!
	var/power = 5
	var/meltdose = 10 // How much is needed to melt
	var/max_damage = 40
	value = DISPENSER_REAGENT_VALUE
	should_admin_log = TRUE

/datum/reagent/acid/affect_blood(mob/living/carbon/M, removed)
	M.take_organ_damage(0, removed * power)

/datum/reagent/acid/affect_touch(mob/living/carbon/M, removed) // This is the most interesting

	M.visible_message(
		SPAN_WARNING("\The [M]'s skin sizzles and burns on contact with the liquid!"),
		SPAN_DANGER("Your skin sizzles and burns!.")
		)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.head)
			if(H.head.unacidable)
				to_chat(H, SPAN_WARNING("Your [H.head] protects you from the liquid."))
				remove_self(volume)
				return
			else if(removed > meltdose)
				to_chat(H, SPAN_DANGER("Your [H.head] melts away!"))
				qdel(H.head)
				H.update_inv_head(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.wear_mask)
			if(H.wear_mask.unacidable)
				to_chat(H, SPAN_WARNING("Your [H.wear_mask] protects you from the liquid."))
				remove_self(volume)
				return
			else if(removed > meltdose)
				to_chat(H, SPAN_DANGER("Your [H.wear_mask] melts away!"))
				qdel(H.wear_mask)
				H.update_inv_wear_mask(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.glasses)
			if(H.glasses.unacidable)
				to_chat(H, SPAN_WARNING("Your [H.glasses] partially protect you from the liquid!"))
				removed /= 2
			else if(removed > meltdose)
				to_chat(H, SPAN_DANGER("Your [H.glasses] melt away!"))
				qdel(H.glasses)
				H.update_inv_glasses(1)
				removed -= meltdose / 2
		if(removed <= 0)
			return

	if(M.unacidable)
		return

	if(removed < meltdose) // Not enough to melt anything
		M.take_organ_damage(0, min(removed * power * 0.1, max_damage)) //burn damage, since it causes chemical burns. Acid doesn't make bones shatter, like brute trauma would.
	else
		M.take_organ_damage(0, min(removed * power * 0.2, max_damage))
		if(ishuman(M)) // Applies disfigurement
			var/mob/living/carbon/human/H = M
			var/screamed
			for(var/obj/item/organ/external/affecting in H.organs)
				if(!screamed && affecting.can_feel_pain())
					screamed = 1
					H.emote("scream")
				affecting.status |= ORGAN_DISFIGURED

/datum/reagent/acid/touch_obj(obj/O)
	if(O.unacidable)
		return
	if((istype(O, /obj/item) || istype(O, /obj/vine)) && (volume > meltdose))
		var/obj/decal/cleanable/molten_item/I = new/obj/decal/cleanable/molten_item(O.loc)
		I.desc = "Looks like this was \an [O] some time ago."
		for(var/mob/M in viewers(5, O))
			to_chat(M, SPAN_WARNING("\The [O] melts."))
		qdel(O)
		remove_self(meltdose) // 10 units of acid will not melt EVERYTHING on the tile

/datum/reagent/acid/hydrochloric //Like sulfuric, but less toxic and more acidic.
	name = "Hydrochloric Acid"
	description = "A very corrosive mineral acid with the molecular formula HCl."
	taste_description = "stomach acid"
	reagent_state = LIQUID
	color = "#808080"
	power = 3
	meltdose = 8
	max_damage = 30
	value = DISPENSER_REAGENT_VALUE * 2

/datum/reagent/silicon
	name = "Silicon"
	description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	reagent_state = SOLID
	color = "#a8a8a8"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/sodium
	name = "Sodium"
	description = "A chemical element, readily reacts with water."
	taste_description = "salty metal"
	reagent_state = SOLID
	color = "#808080"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/sugar
	name = "Sugar"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	taste_description = "sugar"
	taste_mult = 3
	reagent_state = SOLID
	color = "#ffffff"
	scannable = 1
	sugar_amount = 1

	glass_name = "sugar"
	glass_desc = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	glass_icon = DRINK_ICON_NOISY
	value = DISPENSER_REAGENT_VALUE

	condiment_name = "sugar sack"
	condiment_desc = "Cavities in a bag."
	condiment_icon_state = "sugar"

/datum/reagent/sugar/affect_blood(mob/living/carbon/human/M, removed)
	handle_sugar(M, src)
	M.adjust_nutrition(removed * 3)

/datum/reagent/sulfur
	name = "Sulfur"
	description = "A chemical element with a pungent smell."
	taste_description = "old eggs"
	reagent_state = SOLID
	color = "#bf8c00"
	value = DISPENSER_REAGENT_VALUE

/datum/reagent/tungsten
	name = "Tungsten"
	description = "A chemical element, and a strong oxidising agent."
	taste_mult = 0 //no taste
	reagent_state = SOLID
	color = "#dcdcdc"
	value = DISPENSER_REAGENT_VALUE

#undef DISPENSER_REAGENT_VALUE
