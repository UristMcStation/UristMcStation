// subtypes of stuff in here will be avoided when randomizing interactions.
GLOBAL_LIST_AS(random_chem_interaction_blacklist, list(
	/datum/reagent/adminordrazine,
	/datum/reagent/nanites,
	/datum/reagent/water/holywater,
	/datum/reagent/chloralhydrate/beer,
	/datum/reagent/tobacco,
	/datum/reagent/drink,
	/datum/reagent/crayon_dust,
	/datum/reagent/random,
	/datum/reagent/toxin/phoron,
	/datum/reagent/ethanol // Includes alcoholic beverages
))

#define FOR_ALL_EFFECTS \
	var/list/all_effects = Singletons.GetList(data);\
	for(var/singleton/random_chem_effect/effect in all_effects)

/datum/reagent/random
	name = "exotic chemical"
	description = "A strange and exotic chemical substance."
	taste_mult = 0 // Random taste not yet implemented
	hidden_from_codex = TRUE
	reagent_state = LIQUID
	var/max_effect_number = 8

/datum/reagent/random/New(datum/reagents/holder, override = FALSE)
	if(override)
		return // This is used for random prototypes, so we bypass further init
	return ..(holder)

/datum/reagent/random/initialize_data(list/newdata)
	var/datum/reagent/random/other = SSchemistry.get_prototype(type)
	if(istype(newdata))
		data = newdata.Copy()
	else
		data = other.data.Copy()
	chilling_products = other.chilling_products
	heating_products = other.heating_products
	recompute_properties()

/datum/reagent/random/proc/randomize_data(temperature)
	data = list()
	var/list/effects_to_get = subtypesof(/singleton/random_chem_effect/random_properties)
	if(length(effects_to_get) > max_effect_number)
		shuffle(effects_to_get)
		effects_to_get.Cut(max_effect_number + 1)
	effects_to_get += subtypesof(/singleton/random_chem_effect/general_properties)

	var/list/singletons = Singletons.GetList(effects_to_get)
	for(var/item in singletons)
		var/singleton/random_chem_effect/effect = item
		effect.prototype_process(src, temperature)

	var/whitelist = subtypesof(/datum/reagent)
	for(var/bad_type in GLOB.random_chem_interaction_blacklist)
		whitelist -= typesof(bad_type)

	chilling_products = list()
	for(var/i in 1 to rand(1,3))
		chilling_products += pick_n_take(whitelist) // it's possible that these form a valid reaction, but we're OK with that.
	heating_products = list()
	for(var/i in 1 to rand(1,3))
		heating_products += pick_n_take(whitelist)

	for(var/singleton/random_chem_effect/random_properties/effect in singletons)
		effect.set_caches(src, whitelist)

/datum/reagent/random/proc/stable_at_temperature(temperature)
	if(temperature > chilling_point && temperature < heating_point)
		return TRUE

/datum/reagent/random/mix_data(list/other_data, amount)
	if(volume <= 0)
		return // ?? but we're about to divide by 0 if this happens, so let's avoid.
	var/old_amount = max(volume - amount, 0) // how much we had prior to the addition
	var/ratio = old_amount/volume
	FOR_ALL_EFFECTS
		data[effect.type] = effect.mix_data(data[effect.type], ratio, other_data[effect.type])

/datum/reagent/random/proc/recompute_properties()
	FOR_ALL_EFFECTS
		effect.on_property_recompute(src, data[effect.type])

/datum/reagent/random/custom_temperature_effects(temperature, datum/reagents/reagents)
	if(temperature in (heating_point - 20) to heating_point)
		FOR_ALL_EFFECTS
			var/result = effect.distillation_act(src, reagents, data[effect.type])
			if(!isnull(result))
				data[effect.type] = result
				. = TRUE
	else if(temperature in chilling_point to (chilling_point + 20))
		FOR_ALL_EFFECTS
			var/result = effect.cooling_act(src, reagents, data[effect.type])
			if(!isnull(result))
				data[effect.type] = result
				. = TRUE
	if(.)
		reagents.my_atom.visible_message("The chemicals in \the [reagents.my_atom] bubble slightly!")

/datum/reagent/random/affect_blood(mob/living/carbon/M, removed)
	FOR_ALL_EFFECTS
		effect.affect_blood(M, removed, data[effect.type])

/datum/reagent/random/proc/on_chemicals_analyze(mob/user)
	to_chat(user, get_scan_data(user))

/datum/reagent/random/proc/get_scan_data(mob/user)
	var/list/dat = list()
	dat += "The readings are very unusual and intriguing. You suspect it may be of alien origin."
	var/beneficial
	var/harmful
	var/list/effect_descs = list()
	var/list/interactions = list()
	FOR_ALL_EFFECTS
		if(effect.beneficial > 0)
			beneficial = 1
		if(effect.beneficial < 0)
			harmful = 1
		if(effect.desc)
			effect_descs += effect.desc
		var/interaction = effect.get_interactions(src)
		if(interaction)
			interactions += interaction
		if(beneficial)
			dat += "The scan suggests that the chemical has some potentially beneficial effects!"
		if(harmful)
			dat += "The readings confirm that the chemical is not safe for human use."
		dat += "A close analysis of the scan suggests that the chemical has some of the following effects: [english_list(effect_descs)]."
		dat += "Here are the chemicals you suspect this one will interact with, probably when heated or cooled:"
		dat += jointext(interactions, ", ")
	return jointext(dat, "<br>")

/datum/reagent/random/Value()
	. = 0
	FOR_ALL_EFFECTS
		. += effect.get_value(data[effect.type])
	. = max(., 0)

// Extra unique types for exoplanet spawns, etc.
/datum/reagent/random/one
/datum/reagent/random/two

#undef FOR_ALL_EFFECTS
