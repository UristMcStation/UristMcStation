/singleton/reaction
	var/name = null
	var/result = null
	var/list/required_reagents = list()
	var/list/catalysts = list()
	var/list/inhibitors = list()
	var/result_amount = 0
	var/hidden_from_codex
	var/maximum_temperature = INFINITY
	var/minimum_temperature = 0
	var/thermal_product
	var/mix_message = "The solution begins to bubble."
	var/reaction_sound = 'sound/effects/bubbles.ogg'
	var/log_is_important = 0 // If this reaction should be considered important for logging. Important recipes message admins when mixed, non-important ones just log to file.

/singleton/reaction/proc/can_happen(datum/reagents/holder)
	//check that all the required reagents are present
	if(!holder.has_all_reagents(required_reagents))
		return 0

	//check that all the required catalysts are present in the required amount
	if(!holder.has_all_reagents(catalysts))
		return 0

	//check that none of the inhibitors are present in the required amount
	if(holder.has_any_reagent(inhibitors))
		return 0

	var/temperature = holder.my_atom ? holder.my_atom.temperature : T20C
	if(temperature < minimum_temperature || temperature > maximum_temperature)
		return 0

	return 1

/singleton/reaction/proc/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	if(thermal_product && ATOM_IS_TEMPERATURE_SENSITIVE(holder.my_atom))
		ADJUST_ATOM_TEMPERATURE(holder.my_atom, thermal_product)

// This proc returns a list of all reagents it wants to use; if the holder has several reactions that use the same reagent, it will split the reagent evenly between them
/singleton/reaction/proc/get_used_reagents()
	. = list()
	for(var/reagent in required_reagents)
		. += reagent

/singleton/reaction/proc/get_reaction_flags(datum/reagents/holder)
	return 0

/singleton/reaction/proc/process(datum/reagents/holder, limit)
	var/data = send_data(holder)

	var/reaction_volume = holder.maximum_volume
	for(var/reactant in required_reagents)
		var/A = holder.get_reagent_amount(reactant) / required_reagents[reactant] / limit // How much of this reagent we are allowed to use
		if(reaction_volume > A)
			reaction_volume = A

	var/reaction_flags = get_reaction_flags(holder)

	for(var/reactant in required_reagents)
		holder.remove_reagent(reactant, reaction_volume * required_reagents[reactant], safety = 1)

	//add the product
	var/amt_produced = result_amount * reaction_volume
	if(result)
		holder.add_reagent(result, amt_produced, data, safety = 1)

	on_reaction(holder, amt_produced, reaction_flags)

//called after processing reactions, if they occurred
/singleton/reaction/proc/post_reaction(datum/reagents/holder)
	var/atom/container = holder.my_atom
	if(mix_message && container && !ismob(container))
		container.visible_message(SPAN_NOTICE("[icon2html(container, viewers(get_turf(container)))] [mix_message]"))
		playsound(container, reaction_sound, 80, 1)

//obtains any special data that will be provided to the reaction products
//this is called just before reactants are removed.
/singleton/reaction/proc/send_data(datum/reagents/holder, reaction_limit)
	return null

/* Common reactions */
/singleton/reaction/inaprovaline
	name = "Inaprovaline"
	result = /datum/reagent/inaprovaline
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/carbon = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/singleton/reaction/dylovene
	name = "Dylovene"
	result = /datum/reagent/dylovene
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/potassium = 1, /datum/reagent/ammonia = 1)
	result_amount = 3

/singleton/reaction/tramadol
	name = "Tramadol"
	result = /datum/reagent/tramadol
	required_reagents = list(/datum/reagent/inaprovaline = 1, /datum/reagent/ethanol = 1, /datum/reagent/acetone = 1)
	result_amount = 3

/singleton/reaction/paracetamol
	name = "Paracetamol"
	result = /datum/reagent/paracetamol
	required_reagents = list(/datum/reagent/tramadol = 1, /datum/reagent/sugar = 1, /datum/reagent/water = 1)
	result_amount = 3

/singleton/reaction/oxycodone
	name = "Oxycodone"
	result = /datum/reagent/tramadol/oxycodone
	required_reagents = list(/datum/reagent/ethanol = 1, /datum/reagent/tramadol = 1)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 1

/singleton/reaction/sterilizine
	name = "Sterilizine"
	result = /datum/reagent/sterilizine
	required_reagents = list(/datum/reagent/ethanol = 1, /datum/reagent/dylovene = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 3

/singleton/reaction/mutagen
	name = "Unstable mutagen"
	result = /datum/reagent/mutagen
	required_reagents = list(/datum/reagent/radium = 1, /datum/reagent/phosphorus = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 3

/singleton/reaction/thermite
	name = "Thermite"
	result = /datum/reagent/thermite
	required_reagents = list(/datum/reagent/aluminium = 1, /datum/reagent/iron = 1, /datum/reagent/acetone = 1)
	result_amount = 3
	mix_message = "The solution thickens into a coarse metallic paste."

/singleton/reaction/hextro
	name = "Hextromycosalinate"
	result = /datum/reagent/drugs/hextro
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/sugar = 1, /datum/reagent/lithium = 1)
	result_amount = 3
	minimum_temperature = 50 CELSIUS
	maximum_temperature = (50 CELSIUS) + 100

/singleton/reaction/pacid
	name = "Polytrinic acid"
	result = /datum/reagent/acid/polyacid
	required_reagents = list(/datum/reagent/acid = 1, /datum/reagent/acid/hydrochloric = 1, /datum/reagent/potassium = 1)
	result_amount = 3

/singleton/reaction/synaptizine
	name = "Synaptizine"
	result = /datum/reagent/synaptizine
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/lithium = 1, /datum/reagent/water = 1)
	result_amount = 3
	minimum_temperature = 30 CELSIUS
	maximum_temperature = (30 CELSIUS) + 100

/singleton/reaction/hyronalin
	name = "Hyronalin"
	result = /datum/reagent/hyronalin
	required_reagents = list(/datum/reagent/radium = 1, /datum/reagent/dylovene = 1)
	result_amount = 2

/singleton/reaction/arithrazine
	name = "Arithrazine"
	result = /datum/reagent/arithrazine
	required_reagents = list(/datum/reagent/hyronalin = 1, /datum/reagent/hydrazine = 1)
	result_amount = 2

/singleton/reaction/impedrezene
	name = "Impedrezene"
	result = /datum/reagent/impedrezene
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/acetone = 1, /datum/reagent/sugar = 1)
	result_amount = 2

/singleton/reaction/kelotane
	name = "Kelotane"
	result = /datum/reagent/kelotane
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/carbon = 1)
	result_amount = 2

/singleton/reaction/peridaxon
	name = "Peridaxon"
	result = /datum/reagent/peridaxon
	required_reagents = list(/datum/reagent/bicaridine = 2, /datum/reagent/clonexadone = 2)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 2

/singleton/reaction/leporazine
	name = "Leporazine"
	result = /datum/reagent/leporazine
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/copper = 1)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 2

/singleton/reaction/cryptobiolin
	name = "Cryptobiolin"
	result = /datum/reagent/drugs/cryptobiolin
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/acetone = 1, /datum/reagent/sugar = 1)
	minimum_temperature = 30 CELSIUS
	maximum_temperature = 60 CELSIUS
	result_amount = 3

/singleton/reaction/tricordrazine
	name = "Tricordrazine"
	result = /datum/reagent/tricordrazine
	required_reagents = list(/datum/reagent/inaprovaline = 1, /datum/reagent/dylovene = 1)
	result_amount = 2

/singleton/reaction/alkysine
	name = "Alkysine"
	result = /datum/reagent/alkysine
	required_reagents = list(/datum/reagent/acid/hydrochloric = 1, /datum/reagent/ammonia = 1, /datum/reagent/dylovene = 1)
	result_amount = 3

/singleton/reaction/dexalin
	name = "Dexalin"
	result = /datum/reagent/dexalin
	required_reagents = list(/datum/reagent/acetone = 2, /datum/reagent/toxin/phoron = 0.1)
	inhibitors = list(/datum/reagent/water = 1) // Messes with cryox
	result_amount = 1

/singleton/reaction/dermaline
	name = "Dermaline"
	result = /datum/reagent/dermaline
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/phosphorus = 1, /datum/reagent/kelotane = 1)
	result_amount = 3
	minimum_temperature = (-50 CELSIUS) - 100
	maximum_temperature = -50 CELSIUS

/singleton/reaction/dexalinp
	name = "Dexalin Plus"
	result = /datum/reagent/dexalinp
	required_reagents = list(/datum/reagent/dexalin = 1, /datum/reagent/carbon = 1, /datum/reagent/iron = 1)
	result_amount = 3

/singleton/reaction/bicaridine
	name = "Bicaridine"
	result = /datum/reagent/bicaridine
	required_reagents = list(/datum/reagent/inaprovaline = 1, /datum/reagent/carbon = 1)
	inhibitors = list(/datum/reagent/sugar = 1) // Messes up with inaprovaline
	result_amount = 2

/singleton/reaction/hyperzine
	name = "Hyperzine"
	result = /datum/reagent/hyperzine
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/phosphorus = 1, /datum/reagent/sulfur = 1)
	result_amount = 3

/singleton/reaction/ryetalyn
	name = "Ryetalyn"
	result = /datum/reagent/ryetalyn
	required_reagents = list(/datum/reagent/arithrazine = 1, /datum/reagent/carbon = 1)
	result_amount = 2

/singleton/reaction/cryoxadone
	name = "Cryoxadone"
	result = /datum/reagent/cryoxadone
	required_reagents = list(/datum/reagent/dexalin = 1, /datum/reagent/drink/ice = 1, /datum/reagent/acetone = 1)
	result_amount = 3
	minimum_temperature = (-25 CELSIUS) - 100
	maximum_temperature = -25 CELSIUS
	mix_message = "The solution becomes sludge-like."

/singleton/reaction/nanitefluid
	name = "Nanite Fluid"
	result = /datum/reagent/nanitefluid
	required_reagents = list(/datum/reagent/cryoxadone = 1, /datum/reagent/aluminium = 1, /datum/reagent/iron = 1)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 3
	minimum_temperature = (-25 CELSIUS) - 100
	maximum_temperature = -25 CELSIUS
	mix_message = "The solution becomes a metallic slime."

/singleton/reaction/venaxilin
	name = "Venaxilin"
	result = /datum/reagent/dylovene/venaxilin
	required_reagents = list(/datum/reagent/dylovene = 1, /datum/reagent/spaceacillin = 1, /datum/reagent/toxin/venom = 1)
	result_amount = 1
	minimum_temperature = 50 CELSIUS
	maximum_temperature = 100 CELSIUS
	mix_message = "The solution steams and becomes cloudy."


/singleton/reaction/clonexadone
	name = "Clonexadone"
	result = /datum/reagent/clonexadone
	required_reagents = list(/datum/reagent/cryoxadone = 1, /datum/reagent/sodium = 1)
	result_amount = 2
	minimum_temperature = -100 CELSIUS
	maximum_temperature = -75 CELSIUS
	mix_message = "The solution thickens into translucent slime."

/singleton/reaction/spaceacillin
	name = "Spaceacillin"
	result = /datum/reagent/spaceacillin
	required_reagents = list(/datum/reagent/drugs/cryptobiolin = 1, /datum/reagent/inaprovaline = 1)
	result_amount = 2

/singleton/reaction/imidazoline
	name = "Imidazoline"
	result = /datum/reagent/imidazoline
	required_reagents = list(/datum/reagent/carbon = 1, /datum/reagent/hydrazine = 1, /datum/reagent/dylovene = 1)
	result_amount = 3

/singleton/reaction/ethylredoxrazine
	name = "Ethylredoxrazine"
	result = /datum/reagent/ethylredoxrazine
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/dylovene = 1, /datum/reagent/carbon = 1)
	result_amount = 3

/singleton/reaction/soporific
	name = "Soporific"
	result = /datum/reagent/soporific
	required_reagents = list(/datum/reagent/chloralhydrate = 1, /datum/reagent/sugar = 4)
	inhibitors = list(/datum/reagent/phosphorus) // Messes with the smoke
	result_amount = 5

/singleton/reaction/chloralhydrate
	name = "Chloral Hydrate"
	result = /datum/reagent/chloralhydrate
	required_reagents = list(/datum/reagent/ethanol = 1, /datum/reagent/acid/hydrochloric = 3, /datum/reagent/water = 1)
	result_amount = 1

/singleton/reaction/vecuronium_bromide
	name = "Vecuronium Bromide"
	result = /datum/reagent/vecuronium_bromide
	required_reagents = list(/datum/reagent/ethanol = 1, /datum/reagent/mercury = 2, /datum/reagent/hydrazine = 2)
	result_amount = 1

/singleton/reaction/potassium_chloride
	name = "Potassium Chloride"
	result = /datum/reagent/toxin/potassium_chloride
	required_reagents = list(/datum/reagent/sodiumchloride = 1, /datum/reagent/potassium = 1)
	minimum_temperature = 60 CELSIUS
	maximum_temperature = (60 CELSIUS) + 100
	result_amount = 2

/singleton/reaction/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	result = /datum/reagent/toxin/potassium_chlorophoride
	required_reagents = list(/datum/reagent/toxin/potassium_chloride = 1, /datum/reagent/toxin/phoron = 1, /datum/reagent/toxin/carpotoxin = 1)
	result_amount = 3

/singleton/reaction/zombiepowder
	name = "Zombie Powder"
	result = /datum/reagent/toxin/zombiepowder
	required_reagents = list(/datum/reagent/toxin/carpotoxin = 5, /datum/reagent/soporific = 5, /datum/reagent/copper = 5)
	result_amount = 2
	minimum_temperature = 90 CELSIUS
	maximum_temperature = 99 CELSIUS
	mix_message = "The solution boils off to form a fine powder."

/singleton/reaction/mindbreaker
	name = "Mindbreaker Toxin"
	result = /datum/reagent/drugs/mindbreaker
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/hydrazine = 1, /datum/reagent/dylovene = 1)
	result_amount = 3
	mix_message = "The solution takes on an iridescent sheen."
	minimum_temperature = 75 CELSIUS
	maximum_temperature = (75 CELSIUS) + 25

/singleton/reaction/lipozine
	name = "Lipozine"
	result = /datum/reagent/lipozine
	required_reagents = list(/datum/reagent/sodiumchloride = 1, /datum/reagent/ethanol = 1, /datum/reagent/radium = 1)
	result_amount = 3

/singleton/reaction/surfactant
	name = "Azosurfactant"
	result = /datum/reagent/surfactant
	required_reagents = list(/datum/reagent/hydrazine = 2, /datum/reagent/carbon = 2, /datum/reagent/acid = 1)
	result_amount = 5
	mix_message = "The solution begins to foam gently."

/singleton/reaction/diethylamine
	name = "Diethylamine"
	result = /datum/reagent/diethylamine
	required_reagents = list (/datum/reagent/ammonia = 1, /datum/reagent/ethanol = 1)
	result_amount = 2

/singleton/reaction/space_cleaner
	name = "Space cleaner"
	result = /datum/reagent/space_cleaner
	required_reagents = list(/datum/reagent/ammonia = 1, /datum/reagent/water = 1)
	result_amount = 2

/singleton/reaction/plantbgone
	name = "Plant-B-Gone"
	result = /datum/reagent/toxin/plantbgone
	required_reagents = list(/datum/reagent/toxin = 1, /datum/reagent/water = 4)
	result_amount = 5

/singleton/reaction/foaming_agent
	name = "Foaming Agent"
	result = /datum/reagent/foaming_agent
	required_reagents = list(/datum/reagent/lithium = 1, /datum/reagent/hydrazine = 1)
	result_amount = 1
	mix_message = "The solution begins to foam vigorously."

/singleton/reaction/glycerol
	name = "Glycerol"
	result = /datum/reagent/glycerol
	required_reagents = list(/datum/reagent/nutriment/cornoil = 3, /datum/reagent/acid = 1)
	result_amount = 1

/singleton/reaction/sodiumchloride
	name = "Sodium Chloride"
	result = /datum/reagent/sodiumchloride
	required_reagents = list(/datum/reagent/sodium = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 2

/singleton/reaction/condensedcapsaicin
	name = "Condensed Capsaicin"
	result = /datum/reagent/capsaicin/condensed
	required_reagents = list(/datum/reagent/capsaicin = 2)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 1

/singleton/reaction/coolant
	name = "Coolant"
	result = /datum/reagent/coolant
	required_reagents = list(/datum/reagent/tungsten = 1, /datum/reagent/acetone = 1, /datum/reagent/water = 1)
	result_amount = 3
	log_is_important = 1
	mix_message = "The solution becomes thick and slightly slimy."

/singleton/reaction/rezadone
	name = "Rezadone"
	result = /datum/reagent/rezadone
	required_reagents = list(/datum/reagent/toxin/carpotoxin = 1, /datum/reagent/drugs/cryptobiolin = 1, /datum/reagent/copper = 1)
	result_amount = 3

/singleton/reaction/lexorin
	name = "Lexorin"
	result = /datum/reagent/lexorin
	required_reagents = list(/datum/reagent/toxin/phoron = 1, /datum/reagent/hydrazine = 1, /datum/reagent/ammonia = 1)
	result_amount = 3

/singleton/reaction/methylphenidate
	name = "Methylphenidate"
	result = /datum/reagent/methylphenidate
	required_reagents = list(/datum/reagent/drugs/mindbreaker = 1, /datum/reagent/lithium = 1)
	result_amount = 3

/singleton/reaction/citalopram
	name = "Citalopram"
	result = /datum/reagent/citalopram
	required_reagents = list(/datum/reagent/drugs/mindbreaker = 1, /datum/reagent/carbon = 1)
	result_amount = 3

/singleton/reaction/paroxetine
	name = "Paroxetine"
	result = /datum/reagent/paroxetine
	required_reagents = list(/datum/reagent/drugs/mindbreaker = 1, /datum/reagent/acetone = 1, /datum/reagent/inaprovaline = 1)
	result_amount = 3

/singleton/reaction/hair_remover
	name = "Hair Remover"
	result = /datum/reagent/toxin/hair_remover
	required_reagents = list(/datum/reagent/radium = 1, /datum/reagent/potassium = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 3
	mix_message = "The solution thins out and emits an acrid smell."

/singleton/reaction/noexcutite
	name = "Noexcutite"
	result = /datum/reagent/noexcutite
	required_reagents = list(/datum/reagent/tramadol/oxycodone = 1, /datum/reagent/dylovene = 1)
	result_amount = 2

/singleton/reaction/methyl_bromide
	name = "Methyl Bromide"
	required_reagents = list(/datum/reagent/toxin/bromide = 1, /datum/reagent/ethanol = 1, /datum/reagent/hydrazine = 1)
	result_amount = 3
	result = /datum/reagent/toxin/methyl_bromide
	mix_message = "The solution begins to bubble, emitting a dark vapor."

/singleton/reaction/adrenaline
	name = "Adrenaline"
	result = /datum/reagent/adrenaline
	required_reagents = list(/datum/reagent/inaprovaline = 1, /datum/reagent/hyperzine = 1, /datum/reagent/dexalinp = 1)
	result_amount = 3

/* Solidification */
/singleton/reaction/phoronsolidification
	name = "Solid Phoron"
	result = null
	required_reagents = list(/datum/reagent/iron = 5, /datum/reagent/toxin/phoron = 20)
	result_amount = 1
	minimum_temperature = (-80 CELSIUS) - 100
	maximum_temperature = -80 CELSIUS
	mix_message = "The solution hardens and begins to crystallize."

/singleton/reaction/phoronsolidification/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	new /obj/item/stack/material/phoron(get_turf(holder.my_atom), created_volume)

/singleton/reaction/uraniumsolidification
	name = "Solid Uranium"
	result = null
	required_reagents = list(/datum/reagent/iron = 5, /datum/reagent/uranium = 20)
	result_amount = 1
	maximum_temperature = -80 CELSIUS
	mix_message = "The solution hardens."

/singleton/reaction/uraniumsolidification/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	new /obj/item/stack/material/uranium(get_turf(holder.my_atom), created_volume)

/singleton/reaction/goldsolidification
	name = "Solid Gold"
	result = null
	required_reagents = list(/datum/reagent/iron = 5, /datum/reagent/gold = 20)
	result_amount = 1
	maximum_temperature = -80 CELSIUS
	mix_message = "The solution hardens."

/singleton/reaction/goldsolidification/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	new /obj/item/stack/material/gold(get_turf(holder.my_atom), created_volume)

/singleton/reaction/silversolidification
	name = "Solid Silver"
	result = null
	required_reagents = list(/datum/reagent/iron = 5, /datum/reagent/silver = 20)
	result_amount = 1
	maximum_temperature = -80 CELSIUS
	mix_message = "The solution hardens."

/singleton/reaction/silversolidification/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	new /obj/item/stack/material/silver(get_turf(holder.my_atom), created_volume)

/singleton/reaction/steelsolidification
	name = "Solid Steel"
	result = null
	required_reagents = list(/datum/reagent/iron = 20, /datum/reagent/carbon = 5)
	result_amount = 1
	maximum_temperature = -80 CELSIUS
	mix_message = "The solution hardens."

/singleton/reaction/steelsolidification/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	new /obj/item/stack/material/steel(get_turf(holder.my_atom), created_volume)

/singleton/reaction/mhydrogensolidification
	name = "Solid Metallic Hydrogen"
	result = null
	required_reagents = list(/datum/reagent/iron = 5, /datum/reagent/hydrazine = 20)
	result_amount = 1
	maximum_temperature = -80 CELSIUS
	mix_message = "The solution hardens."

/singleton/reaction/mhydrogensolidification/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	new /obj/item/stack/material/mhydrogen(get_turf(holder.my_atom), created_volume)

/singleton/reaction/ironsolidification
	name = "Solid Iron"
	result = null
	required_reagents = list(/datum/reagent/iron = 25)
	inhibitors = list(/datum/reagent/carbon = 5)
	result_amount = 1
	maximum_temperature = -80 CELSIUS
	mix_message = "The solution hardens."

/singleton/reaction/ironsolidification/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	new /obj/item/stack/material/iron(get_turf(holder.my_atom), created_volume)

/singleton/reaction/aluminiumsolidification
	name = "Solid Aluminium"
	result = null
	required_reagents = list(/datum/reagent/iron = 5, /datum/reagent/aluminium = 20)
	result_amount = 1
	maximum_temperature = -80 CELSIUS
	mix_message = "The solution hardens."

/singleton/reaction/aluminiumsolidification/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	new /obj/item/stack/material/aluminium(get_turf(holder.my_atom), created_volume)

/singleton/reaction/plastication
	name = "Plastic"
	result = null
	required_reagents = list(/datum/reagent/acid/polyacid = 1, /datum/reagent/toxin/plasticide = 2)
	result_amount = 1
	mix_message = "The solution solidifies into a grey-white mass."

/singleton/reaction/plastication/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	new /obj/item/stack/material/plastic(get_turf(holder.my_atom), created_volume)

/* Grenade reactions */

/singleton/reaction/explosion_potassium
	name = "Explosion"
	result = null
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/potassium = 1)
	result_amount = 2
	mix_message = null
	mix_message = "The solution bubbles vigorously!"

/singleton/reaction/explosion_potassium/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/datum/effect/reagents_explosion/e = new()
	e.set_up(round (created_volume/10, 1), holder.my_atom, 0, 0)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat != DEAD)
			e.amount *= 0.5
	e.start()
	holder.clear_reagents()

/singleton/reaction/flash_powder
	name = "Flash powder"
	result = null
	required_reagents = list(/datum/reagent/aluminium = 1, /datum/reagent/potassium = 1, /datum/reagent/sulfur = 1 )
	result_amount = 3
	mix_message = "The solution bubbles vigorously!"

/singleton/reaction/flash_powder/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
	s.set_up(2, 1, location)
	s.start()
	for(var/mob/living/carbon/M in viewers(world.view, location))
		switch(get_dist(M, location))
			if(0 to 1)
				if (M.eyecheck() < FLASH_PROTECTION_MODERATE)
					M.flash_eyes(2)
					M.weakened = min(10, (created_volume / 20))
					M.set_confused(min(20, (created_volume / 5)))
					M.eye_blurry = min(40, (created_volume / 5))
				else
					M.stunned = min(10, (created_volume / 30))
					M.set_confused(min(20, (created_volume / 10)))
					M.eye_blurry = min(40, (created_volume / 10))

			if(2 to 4)
				if (M.eyecheck() < FLASH_PROTECTION_MODERATE)
					M.flash_eyes(2)
					M.stunned = min(5, (created_volume / 30))
					M.set_confused(min(10, (created_volume / 10)))
					M.eye_blurry = min(20, (created_volume / 10))
				else
					M.stunned = min(5, (created_volume / 60))
					M.set_confused(min(20, (created_volume / 20)))
					M.eye_blurry = min(20, (created_volume / 20))
		playsound(location, 'sound/effects/bang.ogg', 50, 1, 30)

/singleton/reaction/emp_pulse
	name = "EMP Pulse"
	result = null
	required_reagents = list(/datum/reagent/uranium = 1, /datum/reagent/iron = 1) // Yes, laugh, it's the best recipe I could think of that makes a little bit of sense
	result_amount = 2
	minimum_temperature = -80 CELSIUS
	mix_message = "The solution bubbles vigorously!"

/singleton/reaction/emp_pulse/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	// 100 created volume = 4 heavy range & 7 light range. A few tiles smaller than traitor EMP grandes.
	// 200 created volume = 8 heavy range & 14 light range. 4 tiles larger than traitor EMP grenades.
	empulse(location, round(created_volume / 24), round(created_volume / 14), 1)
	holder.clear_reagents()

/singleton/reaction/nitroglycerin
	name = "Nitroglycerin"
	result = /datum/reagent/nitroglycerin
	required_reagents = list(/datum/reagent/glycerol = 1, /datum/reagent/acid/polyacid = 1, /datum/reagent/acid = 1)
	result_amount = 2
	log_is_important = 1

/singleton/reaction/nitroglycerin/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/datum/effect/reagents_explosion/e = new()
	e.set_up(round (created_volume/2, 1), holder.my_atom, 0, 0)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat!=DEAD)
			e.amount *= 0.5
	e.start()
	holder.clear_reagents()

/singleton/reaction/gunpowder
	name = "Gunpowder"
	result = /datum/reagent/gunpowder
	required_reagents = list(/datum/reagent/sodiumchloride = 1, /datum/reagent/toxin/fertilizer/potash = 1, /datum/reagent/sulfur = 1)
	result_amount = 3
	mix_message = "The solution sizzles down into ashy black powder."

/singleton/reaction/explosion_gunpowder
	name = "Explosion"
	result = null
	required_reagents = list(/datum/reagent/gunpowder = 1)
	result_amount = 3
	minimum_temperature = 200 CELSIUS
	mix_message = "The powder violently bursts into flame."

/singleton/reaction/explosion_gunpowder/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/datum/effect/reagents_explosion/e = new()
	e.set_up(round (created_volume/5, 1), holder.my_atom, 0, 0)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat!=DEAD)
			e.amount *= 0.5
	e.start()
	holder.clear_reagents()

/singleton/reaction/napalm
	name = "Napalm"
	result = /datum/reagent/napalm
	required_reagents = list(/datum/reagent/aluminium = 1, /datum/reagent/acid = 1, /datum/reagent/glycerol = 1 ) //because bananas grow on palms and palm oil is used to make napalm. =/= logic
	result_amount = 2
	mix_message = "The solution thickens and takes on a slimy sheen."

/singleton/reaction/napalmb
	name = "Napalm B"
	result = /datum/reagent/napalm/b
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/fuel = 1 )
	result_amount = 2
	mix_message = "The solution thickens and takes on a slimy sheen."

/singleton/reaction/chemsmoke
	name = "Chemsmoke"
	result = null
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/sugar = 1, /datum/reagent/phosphorus = 1)
	result_amount = 0.4
	mix_message = "The solution bubbles vigorously!"

/singleton/reaction/chemsmoke/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	var/datum/effect/smoke_spread/chem/S = new /datum/effect/smoke_spread/chem
	S.attach(location)
	S.set_up(holder, created_volume, 0, location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	spawn(0)
		S.start()
	holder.clear_reagents()

/singleton/reaction/foam
	name = "Foam"
	result = null
	required_reagents = list(/datum/reagent/surfactant = 1, /datum/reagent/water = 1)
	result_amount = 2
	mix_message = "The solution bubbles vigorously!"

/singleton/reaction/foam/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, SPAN_WARNING("The solution spews out foam!"))

	var/datum/effect/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 0)
	s.start()
	holder.clear_reagents()

/singleton/reaction/metalfoam
	name = "Metal Foam"
	result = null
	required_reagents = list(/datum/reagent/aluminium = 3, /datum/reagent/foaming_agent = 1, /datum/reagent/acid/polyacid = 1)
	result_amount = 5
	mix_message = "The solution bubbles vigorously!"

/singleton/reaction/metalfoam/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, SPAN_WARNING("The solution spews out a metalic foam!"))

	var/datum/effect/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 1)
	s.start()

/singleton/reaction/ironfoam
	name = "Iron Foam"
	result = null
	required_reagents = list(/datum/reagent/iron = 3, /datum/reagent/foaming_agent = 1, /datum/reagent/acid/polyacid = 1)
	result_amount = 5
	mix_message = "The solution bubbles vigorously!"

/singleton/reaction/ironfoam/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, SPAN_WARNING("The solution spews out a metalic foam!"))

	var/datum/effect/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 2)
	s.start()

/* Paint */

/singleton/reaction/red_paint
	name = "Red paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/red = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy red sheen."

/singleton/reaction/red_paint/send_data()
	return "#fe191a"

/singleton/reaction/orange_paint
	name = "Orange paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/orange = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy orange sheen."

/singleton/reaction/orange_paint/send_data()
	return "#ffbe4f"

/singleton/reaction/yellow_paint
	name = "Yellow paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/yellow = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy yellow sheen."

/singleton/reaction/yellow_paint/send_data()
	return "#fdfe7d"

/singleton/reaction/green_paint
	name = "Green paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/green = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy green sheen."

/singleton/reaction/green_paint/send_data()
	return "#18a31a"

/singleton/reaction/blue_paint
	name = "Blue paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/blue = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy blue sheen."

/singleton/reaction/blue_paint/send_data()
	return "#247cff"

/singleton/reaction/purple_paint
	name = "Purple paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/purple = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy purple sheen."

/singleton/reaction/purple_paint/send_data()
	return "#cc0099"

/singleton/reaction/grey_paint //mime
	name = "Grey paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/grey = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy grey sheen."

/singleton/reaction/grey_paint/send_data()
	return "#808080"

/singleton/reaction/brown_paint
	name = "Brown paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/brown = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy brown sheen."

/singleton/reaction/brown_paint/send_data()
	return "#846f35"

/singleton/reaction/blood_paint
	name = "Blood paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/blood = 2)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy red sheen."

/singleton/reaction/blood_paint/send_data(datum/reagents/T)
	var/t = T.get_data("blood")
	if(t && t["blood_colour"])
		return t["blood_colour"]
	return "#fe191a" // Probably red

/singleton/reaction/milk_paint
	name = "Milk paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/milk = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy white sheen."

/singleton/reaction/milk_paint/send_data()
	return "#f0f8ff"

/singleton/reaction/orange_juice_paint
	name = "Orange juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/orange = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy orange sheen."

/singleton/reaction/orange_juice_paint/send_data()
	return "#e78108"

/singleton/reaction/tomato_juice_paint
	name = "Tomato juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/tomato = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy red sheen."

/singleton/reaction/tomato_juice_paint/send_data()
	return "#731008"

/singleton/reaction/lime_juice_paint
	name = "Lime juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/lime = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy green sheen."

/singleton/reaction/lime_juice_paint/send_data()
	return "#365e30"

/singleton/reaction/carrot_juice_paint
	name = "Carrot juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/carrot = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy orange sheen."

/singleton/reaction/carrot_juice_paint/send_data()
	return "#973800"

/singleton/reaction/berry_juice_paint
	name = "Berry juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/berry = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy red sheen."

/singleton/reaction/berry_juice_paint/send_data()
	return "#990066"

/singleton/reaction/grape_juice_paint
	name = "Grape juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/grape = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy purple sheen."

/singleton/reaction/grape_juice_paint/send_data()
	return "#863333"

/singleton/reaction/poisonberry_juice_paint
	name = "Poison berry juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/toxin/poisonberryjuice = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy purple sheen."

/singleton/reaction/poisonberry_juice_paint/send_data()
	return "#863353"

/singleton/reaction/watermelon_juice_paint
	name = "Watermelon juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/watermelon = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy red sheen."

/singleton/reaction/watermelon_juice_paint/send_data()
	return "#b83333"

/singleton/reaction/lemon_juice_paint
	name = "Lemon juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/lemon = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy yellow sheen."

/singleton/reaction/lemon_juice_paint/send_data()
	return "#afaf00"

/singleton/reaction/banana_juice_paint
	name = "Banana juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/banana = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy yellow sheen."

/singleton/reaction/banana_juice_paint/send_data()
	return "#c3af00"

/singleton/reaction/potato_juice_paint
	name = "Potato juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/potato = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy brown sheen."

/singleton/reaction/potato_juice_paint/send_data()
	return "#302000"

/singleton/reaction/carbon_paint
	name = "Carbon paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/carbon = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy black sheen."

/singleton/reaction/carbon_paint/send_data()
	return "#333333"

/singleton/reaction/aluminium_paint
	name = "Aluminium paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/aluminium = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy white sheen."

/singleton/reaction/aluminium_paint/send_data()
	return "#f0f8ff"

/* Slime cores */

/singleton/reaction/slime
	hidden_from_codex = TRUE
	mix_message = "The slime core twitches sharply."
	var/required = null

/singleton/reaction/slime/can_happen(datum/reagents/holder)
	if(holder.my_atom && istype(holder.my_atom, required))
		var/obj/item/slime_extract/T = holder.my_atom
		if(T.Uses > 0)
			return ..()
	return 0

/singleton/reaction/slime/on_reaction(datum/reagents/holder)
	..()
	var/obj/item/slime_extract/T = holder.my_atom
	T.Uses--
	if(T.Uses <= 0)
		T.visible_message("[icon2html(T, viewers(get_turf(T)))][SPAN_NOTICE("\The [T]'s power is consumed in the reaction.")]")
		T.SetName("used slime extract")
		T.desc = "This extract has been used up."

//Grey
/singleton/reaction/slime/spawn
	name = "Slime Spawn"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/grey

/singleton/reaction/slime/spawn/on_reaction(datum/reagents/holder)
	..()
	holder.my_atom.visible_message(SPAN_WARNING("Infused with phoron, the core begins to quiver and grow, and soon a new baby slime emerges from it!"))
	new /mob/living/carbon/slime(get_turf(holder.my_atom))

/singleton/reaction/slime/monkey
	name = "Slime Monkey"
	result = null
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 1
	required = /obj/item/slime_extract/grey

/singleton/reaction/slime/monkey/on_reaction(datum/reagents/holder)
	..()
	for(var/i = 1, i <= 3, i++)
		new /obj/item/reagent_containers/food/snacks/monkeycube(get_turf(holder.my_atom))

//Green
/singleton/reaction/slime/mutate
	name = "Mutation Toxin"
	result = /datum/reagent/slimetoxin
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/green

//Metal
/singleton/reaction/slime/metal
	name = "Slime Metal"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/metal

/singleton/reaction/slime/metal/on_reaction(datum/reagents/holder)
	..()
	var/obj/item/stack/material/steel/M = new (get_turf(holder.my_atom))
	M.amount = 15
	var/obj/item/stack/material/plasteel/P = new (get_turf(holder.my_atom))
	P.amount = 5

//Gold
/singleton/reaction/slime/crit
	name = "Slime Crit"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/gold
	var/list/possible_mobs = list(
							/mob/living/simple_animal/passive/cat,
							/mob/living/simple_animal/passive/cat/kitten,
							/mob/living/simple_animal/passive/corgi,
							/mob/living/simple_animal/passive/corgi/puppy,
							/mob/living/simple_animal/passive/cow,
							/mob/living/simple_animal/passive/chick,
							/mob/living/simple_animal/passive/chicken,
							/mob/living/simple_animal/passive/crab,
							/mob/living/simple_animal/passive/opossum,
							/mob/living/simple_animal/passive/snake,
							/mob/living/simple_animal/passive/thoom
							)

/singleton/reaction/slime/crit/on_reaction(datum/reagents/holder)
	..()
	var/type = pick(possible_mobs)
	new type(get_turf(holder.my_atom))

/singleton/reaction/slime/grevive
	name = "Slime Revive"
	result = null
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 1
	required = /obj/item/slime_extract/gold

/singleton/reaction/slime/grevive/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	new /obj/item/slimepotion3(get_turf(holder.my_atom))

//Silver
/singleton/reaction/slime/bork
	name = "Slime Bork"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/silver

/singleton/reaction/slime/bork/on_reaction(datum/reagents/holder)
	..()
	var/list/borks = typesof(/obj/item/reagent_containers/food/snacks) - /obj/item/reagent_containers/food/snacks
	playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
	for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
		if(M.eyecheck() < FLASH_PROTECTION_MODERATE)
			M.flash_eyes()

	for(var/i = 1, i <= 4 + rand(1,2), i++)
		var/chosen = pick(borks)
		var/obj/B = new chosen(get_turf(holder.my_atom))
		if(B)
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(B, pick(NORTH, SOUTH, EAST, WEST))

/singleton/reaction/slime/mixer
	name = "Slime Mixer"
	result = null
	required_reagents = list(/datum/reagent/water = 1)
	result_amount = 1
	required = /obj/item/slime_extract/silver

/singleton/reaction/slime/mixer/on_reaction(datum/reagents/holder)
	..()
	var/list/mixers = typesof(/obj/item/reagent_containers/food/drinks) - typesof(/obj/item/reagent_containers/food/drinks/glass2)
	playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
	for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
		if(M.eyecheck() < FLASH_PROTECTION_MODERATE)
			M.flash_eyes()

	for(var/i = 1, i <= 4 + rand(1,2), i++)
		var/chosen = pick(mixers)
		var/obj/B = new chosen(get_turf(holder.my_atom))
		if(B)
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(B, pick(NORTH, SOUTH, EAST, WEST))

//Blue
/singleton/reaction/slime/frost
	name = "Slime Frost Oil"
	result = /datum/reagent/frostoil
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 10
	required = /obj/item/slime_extract/blue

//Dark Blue
/singleton/reaction/slime/freeze
	name = "Slime Freeze"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/darkblue
	mix_message = "The slime extract begins to vibrate violently!"

/singleton/reaction/slime/freeze/on_reaction(datum/reagents/holder)
	set waitfor = 0
	..()
	sleep(50)
	playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
	for(var/mob/living/M in range (get_turf(holder.my_atom), 7))
		M.bodytemperature -= 140
		to_chat(M, SPAN_WARNING("You feel a chill!"))

//Orange
/singleton/reaction/slime/casp
	name = "Slime Capsaicin Oil"
	result = /datum/reagent/capsaicin
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 10
	required = /obj/item/slime_extract/orange

/singleton/reaction/slime/fire
	name = "Slime fire"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/orange
	mix_message = "The slime extract begins to vibrate violently!"

/singleton/reaction/slime/fire/on_reaction(datum/reagents/holder)
	set waitfor = 0
	..()
	sleep(50)
	if(!(holder.my_atom && holder.my_atom.loc))
		return

	var/turf/location = get_turf(holder.my_atom)
	location.assume_gas(GAS_PHORON, 250, 1400)
	location.hotspot_expose(700)

//Yellow
/singleton/reaction/slime/overload
	name = "Slime EMP"
	result = null
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 1
	required = /obj/item/slime_extract/yellow

/singleton/reaction/slime/overload/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	empulse(get_turf(holder.my_atom), 3, 7)

/singleton/reaction/slime/cell
	name = "Slime Powercell"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/yellow

/singleton/reaction/slime/cell/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	new /obj/item/cell/slime(get_turf(holder.my_atom))

/singleton/reaction/slime/glow
	name = "Slime Glow"
	result = null
	required_reagents = list(/datum/reagent/water = 1)
	result_amount = 1
	required = /obj/item/slime_extract/yellow
	mix_message = "The contents of the slime core harden and begin to emit a warm, bright light."

/singleton/reaction/slime/glow/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	new /obj/item/device/flashlight/slime(get_turf(holder.my_atom))

//Purple
/singleton/reaction/slime/psteroid
	name = "Slime Steroid"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/purple

/singleton/reaction/slime/psteroid/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	new /obj/item/slimesteroid(get_turf(holder.my_atom))

/singleton/reaction/slime/jam
	name = "Slime Jam"
	result = /datum/reagent/slimejelly
	required_reagents = list(/datum/reagent/sugar = 1)
	result_amount = 10
	required = /obj/item/slime_extract/purple

//Dark Purple
/singleton/reaction/slime/plasma
	name = "Slime Plasma"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/darkpurple

/singleton/reaction/slime/plasma/on_reaction(datum/reagents/holder)
	..()
	var/obj/item/stack/material/phoron/P = new (get_turf(holder.my_atom))
	P.amount = 10

//Red
/singleton/reaction/slime/glycerol
	name = "Slime Glycerol"
	result = /datum/reagent/glycerol
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 8
	required = /obj/item/slime_extract/red

/singleton/reaction/slime/bloodlust
	name = "Bloodlust"
	result = null
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 1
	required = /obj/item/slime_extract/red

/singleton/reaction/slime/bloodlust/on_reaction(datum/reagents/holder)
	..()
	for(var/mob/living/carbon/slime/slime in viewers(get_turf(holder.my_atom), null))
		slime.rabid = 1
		slime.visible_message(SPAN_WARNING("The [slime] is driven into a frenzy!"))

//Pink
/singleton/reaction/slime/ppotion
	name = "Slime Potion"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/pink

/singleton/reaction/slime/ppotion/on_reaction(datum/reagents/holder)
	..()
	new /obj/item/slimepotion(get_turf(holder.my_atom))

//Black
/singleton/reaction/slime/mutate2
	name = "Advanced Mutation Toxin"
	result = /datum/reagent/aslimetoxin
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/black

//Oil
/singleton/reaction/slime/explosion
	name = "Slime Explosion"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/oil
	mix_message = "The slime extract begins to vibrate violently!"

/singleton/reaction/slime/explosion/on_reaction(datum/reagents/holder)
	set waitfor = 0
	..()
	sleep(50)
	explosion(get_turf(holder.my_atom), 10)

//Light Pink
/singleton/reaction/slime/potion2
	name = "Slime Potion 2"
	result = null
	result_amount = 1
	required = /obj/item/slime_extract/lightpink
	required_reagents = list(/datum/reagent/toxin/phoron = 1)

/singleton/reaction/slime/potion2/on_reaction(datum/reagents/holder)
	..()
	new /obj/item/slimepotion2(get_turf(holder.my_atom))

//Adamantine
/singleton/reaction/slime/golem
	name = "Slime Golem"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/adamantine

/singleton/reaction/slime/golem/on_reaction(datum/reagents/holder)
	..()
	var/obj/golemrune/Z = new /obj/golemrune(get_turf(holder.my_atom))
	Z.announce_to_ghosts()

//Sepia
/singleton/reaction/slime/film
	name = "Slime Film"
	result = null
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 2
	required = /obj/item/slime_extract/sepia

/singleton/reaction/slime/film/on_reaction(datum/reagents/holder)
	for(var/i in 1 to result_amount)
		new /obj/item/device/camera_film(get_turf(holder.my_atom))
	..()

/singleton/reaction/slime/camera
	name = "Slime Camera"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/sepia

/singleton/reaction/slime/camera/on_reaction(datum/reagents/holder)
	new /obj/item/device/camera(get_turf(holder.my_atom))
	..()

//Bluespace
/singleton/reaction/slime/teleport
	name = "Slime Teleport"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	required = /obj/item/slime_extract/bluespace
	reaction_sound = 'sound/effects/teleport.ogg'

/singleton/reaction/slime/teleport/on_reaction(datum/reagents/holder)
	var/list/turfs = list()
	for(var/turf/T in orange(holder.my_atom,6))
		turfs += T
	for(var/atom/movable/a in viewers(holder.my_atom,2))
		if(!a.simulated)
			continue
		a.forceMove(pick(turfs))
	..()

//pyrite
/singleton/reaction/slime/paint
	name = "Slime Paint"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	required = /obj/item/slime_extract/pyrite

/singleton/reaction/slime/paint/on_reaction(datum/reagents/holder)
	new /obj/item/reagent_containers/glass/paint/random(get_turf(holder.my_atom))
	..()

//cerulean
/singleton/reaction/slime/extract_enhance
	name = "Extract Enhancer"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	required = /obj/item/slime_extract/cerulean

/singleton/reaction/slime/extract_enhance/on_reaction(datum/reagents/holder)
	new /obj/item/slimesteroid2(get_turf(holder.my_atom))
	..()

/singleton/reaction/soap_key
	name = "Soap Key"
	result = null
	required_reagents = list(/datum/reagent/frostoil = 2, /datum/reagent/space_cleaner = 5)
	var/strength = 3

/singleton/reaction/soap_key/can_happen(datum/reagents/holder)
	if(holder.my_atom && istype(holder.my_atom, /obj/item/soap))
		return ..()
	return 0

/singleton/reaction/soap_key/on_reaction(datum/reagents/holder)
	var/obj/item/soap/S = holder.my_atom
	if(S.key_data)
		var/obj/item/key/soap/key = new(get_turf(holder.my_atom), S.key_data)
		key.uses = strength
	..()

/* Food */

/singleton/reaction/tofu
	name = "Tofu"
	result = null
	required_reagents = list(/datum/reagent/drink/milk/soymilk = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 1
	mix_message = "The solution thickens and clumps into a yellow-white substance."

/singleton/reaction/tofu/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/tofu(location)

/singleton/reaction/chocolate_bar
	name = "Chocolate Bar"
	result = null
	required_reagents = list(/datum/reagent/drink/milk/soymilk = 2, /datum/reagent/nutriment/coco = 2, /datum/reagent/sugar = 2)
	result_amount = 1
	mix_message = "The solution thickens and hardens into a glossy brown substance."

/singleton/reaction/chocolate_bar/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/chocolatebar(location)

/singleton/reaction/chocolate_bar2
	name = "Chocolate Bar"
	result = null
	required_reagents = list(/datum/reagent/drink/milk = 2, /datum/reagent/nutriment/coco = 2, /datum/reagent/sugar = 2)
	result_amount = 1
	mix_message = "The solution thickens and hardens into a glossy brown substance."

/singleton/reaction/chocolate_bar2/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/chocolatebar(location)

/singleton/reaction/chocolate_milk
	name = "Chocolate Milk"
	result = /datum/reagent/drink/milk/chocolate
	required_reagents = list(/datum/reagent/drink/milk = 5, /datum/reagent/nutriment/coco = 1)
	result_amount = 5
	mix_message = "The solution thickens into a creamy brown beverage."

/singleton/reaction/coffee
	name = "Coffee"
	result = /datum/reagent/drink/coffee
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/coffee = 1)
	result_amount = 5
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The solution thickens into a steaming dark brown beverage."

/singleton/reaction/coffee/instant
	name = "Instant Coffee"
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/coffee/instant = 1)
	maximum_temperature = INFINITY
	minimum_temperature = 0
	mix_message = "The solution thickens into dark brown beverage."

/singleton/reaction/tea
	name = "Black tea"
	result = /datum/reagent/drink/tea
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/tea = 1)
	result_amount = 5
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The solution thickens into a steaming black beverage."

/singleton/reaction/tea/instant
	name = "Instant Black tea"
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/tea/instant = 1)
	maximum_temperature = INFINITY
	minimum_temperature = 0
	mix_message = "The solution thickens into black beverage."

/singleton/reaction/hot_coco
	name = "Hot Coco"
	result = /datum/reagent/drink/hot_coco
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/coco = 1)
	result_amount = 5
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The solution thickens into a steaming brown beverage."

/singleton/reaction/ntella_hot_chocolate
	name = "NTella hot chocolate"
	result = /datum/reagent/drink/hot_coco/ntella
	required_reagents = list(/datum/reagent/drink/milk = 1, /datum/reagent/nutriment/choconutspread = 1, /datum/reagent/drink/milk/cream = 1)
	result_amount = 3

/singleton/reaction/grapejuice
	name = "Grape Juice"
	result = /datum/reagent/drink/juice/grape
	required_reagents = list(/datum/reagent/water = 3, /datum/reagent/nutriment/instantjuice/grape = 1)
	result_amount = 3
	mix_message = "The solution settles into a purplish-red beverage."

/singleton/reaction/orangejuice
	name = "Orange Juice"
	result = /datum/reagent/drink/juice/orange
	required_reagents = list(/datum/reagent/water = 3, /datum/reagent/nutriment/instantjuice/orange = 1)
	result_amount = 3
	mix_message = "The solution settles into an orange beverage."

/singleton/reaction/watermelonjuice
	name = "Watermelon Juice"
	result = /datum/reagent/drink/juice/watermelon
	required_reagents = list(/datum/reagent/water = 3, /datum/reagent/nutriment/instantjuice/watermelon = 1)
	result_amount = 3
	mix_message = "The solution settles into a red beverage."

/singleton/reaction/applejuice
	name = "Apple Juice"
	result = /datum/reagent/drink/juice/apple
	required_reagents = list(/datum/reagent/water = 3, /datum/reagent/nutriment/instantjuice/apple = 1)
	result_amount = 3
	mix_message = "The solution settles into a clear brown beverage."

/singleton/reaction/soysauce
	name = "Soy Sauce"
	result = /datum/reagent/nutriment/soysauce
	required_reagents = list(/datum/reagent/drink/milk/soymilk = 5, /datum/reagent/nutriment/vinegar = 5)
	result_amount = 10
	mix_message = "The solution settles into a glossy black sauce."

/singleton/reaction/soysauce_acid
	name = "Bitey Soy Sauce"
	result = /datum/reagent/nutriment/soysauce
	required_reagents = list(/datum/reagent/drink/milk/soymilk = 4, /datum/reagent/acid = 1)
	result_amount = 5
	mix_message = "The solution settles into a glossy black sauce."

/singleton/reaction/ketchup
	name = "Ketchup"
	result = /datum/reagent/nutriment/ketchup
	required_reagents = list(/datum/reagent/drink/juice/tomato = 2, /datum/reagent/water = 1, /datum/reagent/sugar = 1)
	result_amount = 4
	mix_message = "The solution thickens into a sweet-smelling red sauce."

/singleton/reaction/barbecue
	name = "Barbecue Sauce"
	result = /datum/reagent/nutriment/barbecue
	required_reagents = list(/datum/reagent/nutriment/ketchup = 2, /datum/reagent/blackpepper = 1, /datum/reagent/sodiumchloride = 1)
	result_amount = 4
	mix_message = "The solution thickens into a sweet-smelling brown sauce."

/singleton/reaction/garlicsauce
	name = "Garlic Sauce"
	result = /datum/reagent/nutriment/garlicsauce
	required_reagents = list(/datum/reagent/drink/juice/garlic = 1, /datum/reagent/nutriment/cornoil = 1)
	result_amount = 2
	mix_message = "The solution thickens into a creamy white oil."

/singleton/reaction/cheesewheel
	name = "Cheesewheel"
	result = null
	required_reagents = list(/datum/reagent/drink/milk = 40)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 1
	mix_message = "The solution thickens and curdles into a rich yellow substance."
	minimum_temperature = 40 CELSIUS
	maximum_temperature = (40 CELSIUS) + 100

/singleton/reaction/cheesewheel/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	for (var/i = 1 to created_volume)
		new /obj/item/reagent_containers/food/snacks/sliceable/cheesewheel/fresh (location)

/singleton/reaction/rawmeatball
	name = "Raw Meatball"
	result = null
	required_reagents = list(/datum/reagent/nutriment/protein = 3, /datum/reagent/nutriment/flour = 5)
	result_amount = 3
	mix_message = "The flour thickens the processed meat until it clumps."

/singleton/reaction/rawmeatball/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/rawmeatball(location)

/singleton/reaction/dough
	name = "Dough"
	result = null
	required_reagents = list(/datum/reagent/nutriment/protein/egg = 3, /datum/reagent/nutriment/flour = 10, /datum/reagent/water = 10)
	result_amount = 1
	mix_message = "The solution folds and thickens into a large ball of dough."

/singleton/reaction/dough/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/dough(location)

/singleton/reaction/soydough
	name = "Soy dough"
	result = null
	required_reagents = list(/datum/reagent/nutriment/softtofu = 3, /datum/reagent/nutriment/flour = 10, /datum/reagent/water = 10)
	result_amount = 1
	mix_message = "The solution folds and thickens into a large ball of dough."

/singleton/reaction/soydough/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/dough/vegan(location)

//batter reaction as food precursor, for things that don't use pliable dough precursor.

/singleton/reaction/batter
	name = "Batter"
	result = /datum/reagent/nutriment/batter
	required_reagents = list(/datum/reagent/nutriment/protein/egg = 3, /datum/reagent/nutriment/flour = 5, /datum/reagent/drink/milk = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy batter."

/singleton/reaction/cakebatter
	name = "Cake Batter"
	result = /datum/reagent/nutriment/batter/cakebatter
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/nutriment/batter = 2)
	result_amount = 3
	mix_message = "The sugar lightens the batter and gives it a sweet smell."

/singleton/reaction/soybatter
	name = "Soy Batter"
	result = /datum/reagent/nutriment/batter/soy
	required_reagents = list(/datum/reagent/nutriment/softtofu = 3, /datum/reagent/nutriment/flour = 5, /datum/reagent/drink/milk/soymilk = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy batter."

/singleton/reaction/soycakebatter
	name = "Soy Cake Batter"
	result = /datum/reagent/nutriment/batter/cakebatter/soy
	required_reagents = list(/datum/reagent/nutriment/honey = 1, /datum/reagent/nutriment/batter/soy = 2)
	result_amount = 3
	mix_message = "The honey lightens the batter and gives it a sweet smell."

/singleton/reaction/syntiflesh
	name = "Syntiflesh"
	result = null
	required_reagents = list(/datum/reagent/blood = 5, /datum/reagent/clonexadone = 1)
	result_amount = 1
	mix_message = "The solution thickens disturbingly, taking on a meaty appearance."

/singleton/reaction/syntiflesh/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/meat/syntiflesh(location)

/singleton/reaction/hot_ramen
	name = "Hot Ramen"
	result = /datum/reagent/drink/hot_ramen
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/drink/dry_ramen = 3)
	result_amount = 3
	mix_message = "The noodles soften in the hot water, releasing savoury steam."

/singleton/reaction/hell_ramen
	name = "Hell Ramen"
	result = /datum/reagent/drink/hell_ramen
	required_reagents = list(/datum/reagent/capsaicin = 1, /datum/reagent/drink/hot_ramen = 6)
	result_amount = 6
	mix_message = "The broth of the noodles takes on a hellish red gleam."

/singleton/reaction/peanutbutter
	name = "Peanut Butter"
	result = /datum/reagent/nutriment/peanutbutter
	required_reagents = list(/datum/reagent/nutriment/groundpeanuts = 5, /datum/reagent/sugar = 1, /datum/reagent/sodiumchloride = 1)
	result_amount = 5
	mix_message = "The solution thickens into a creamy, nutty spread."

/singleton/reaction/choconutspread
	name = "Choco-Nut Spread"
	result = /datum/reagent/nutriment/choconutspread
	required_reagents = list(/datum/reagent/nutriment/almondmeal = 1, /datum/reagent/sugar = 2, /datum/reagent/nutriment/coco = 1, /datum/reagent/drink/milk/soymilk = 1)
	result_amount = 4
	mix_message = "The solution thickens into a creamy, chocolate-y spread."

/singleton/reaction/sprinkles
	name = "Sprinkles"
	result = /datum/reagent/nutriment/sprinkles
	required_reagents = list(/datum/reagent/sugar = 3, /datum/reagent/drink/syrup_vanilla = 1, /datum/reagent/nutriment/cornoil = 1)
	result_amount = 5
	mix_message = "The solution thickens and hardens into sugary sprinkles."


/* Alcohol */

/singleton/reaction/goldschlager
	name = "Goldschlager"
	result = /datum/reagent/ethanol/goldschlager
	required_reagents = list(/datum/reagent/ethanol/vodka = 10, /datum/reagent/gold = 1)
	result_amount = 10
	mix_message = "The gold flakes and settles in the vodka."

/singleton/reaction/patron
	name = "Patron"
	result = /datum/reagent/ethanol/patron
	required_reagents = list(/datum/reagent/ethanol/tequilla = 10, /datum/reagent/silver = 1)
	result_amount = 10
	mix_message = "The silver flakes and settles in the tequila."

/singleton/reaction/bilk
	name = "Bilk"
	result = /datum/reagent/ethanol/bilk
	required_reagents = list(/datum/reagent/drink/milk = 1, /datum/reagent/ethanol/beer = 1)
	result_amount = 2
	mix_message = "The solution takes on an unpleasant, thick, brown appearance."

/singleton/reaction/icecoffee
	name = "Iced Coffee"
	result = /datum/reagent/drink/coffee/icecoffee
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled coffee."

/singleton/reaction/icesoylatte
	name = "Iced Soy Latte"
	result = /datum/reagent/drink/coffee/icecoffee/soy_latte
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee/soy_latte = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled soy latte."

/singleton/reaction/icecafelatte
	name = "Iced Cafe Latte"
	result = /datum/reagent/drink/coffee/icecoffee/cafe_latte
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee/cafe_latte = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled cafe latte."

/singleton/reaction/nuka_cola
	name = "Nuka Cola"
	result = /datum/reagent/drink/nuka_cola
	required_reagents = list(/datum/reagent/uranium = 1, /datum/reagent/drink/space_cola = 5)
	result_amount = 5
	mix_message = "The solution bubbles and emits an eerie green glow."

/singleton/reaction/moonshine
	name = "Moonshine"
	result = /datum/reagent/ethanol/moonshine
	required_reagents = list(/datum/reagent/nutriment = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution exudes the powerful reek of raw alcohol."

/singleton/reaction/grenadine
	name = "Grenadine Syrup"
	result = /datum/reagent/drink/grenadine
	required_reagents = list(/datum/reagent/drink/juice/berry = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/singleton/reaction/wine
	name = "Wine"
	result = /datum/reagent/ethanol/wine
	required_reagents = list(/datum/reagent/drink/juice/grape = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a rich red liquid."

/singleton/reaction/whitewine
	name = "White Wine"
	result = /datum/reagent/ethanol/wine/premium
	required_reagents = list(/datum/reagent/drink/juice/grape/white = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a pale gold liquid."

/singleton/reaction/pwine
	name = "Poison Wine"
	result = /datum/reagent/ethanol/pwine
	required_reagents = list(/datum/reagent/toxin/poisonberryjuice = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a shifting purple liquid."

/singleton/reaction/melonliquor
	name = "Melon Liquor"
	result = /datum/reagent/ethanol/melonliquor
	required_reagents = list(/datum/reagent/drink/juice/watermelon = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a pale liquor."

/singleton/reaction/bluecuracao
	name = "Blue Curacao"
	result = /datum/reagent/ethanol/bluecuracao
	required_reagents = list(/datum/reagent/drink/juice/orange = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a shockingly blue liquor."

/singleton/reaction/spacebeer
	name = "Space Beer"
	result = /datum/reagent/ethanol/beer
	required_reagents = list(/datum/reagent/nutriment/cornoil = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a foaming amber liquid."

/singleton/reaction/vodka
	name = "Vodka"
	result = /datum/reagent/ethanol/vodka
	required_reagents = list(/datum/reagent/drink/juice/potato = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/singleton/reaction/vodka2
	name = "Vodka"
	result = /datum/reagent/ethanol/vodka
	required_reagents = list(/datum/reagent/drink/juice/turnip = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/singleton/reaction/sake
	name = "Sake"
	result = /datum/reagent/ethanol/sake
	required_reagents = list(/datum/reagent/nutriment/rice = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/singleton/reaction/kahlua
	name = "Kahlua"
	result = /datum/reagent/ethanol/coffee/kahlua
	required_reagents = list(/datum/reagent/drink/coffee = 5, /datum/reagent/sugar = 5)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 5
	mix_message = "The solution roils as it rapidly ferments into a rich brown liquid."

/singleton/reaction/gin_tonic
	name = "Gin and Tonic"
	result = /datum/reagent/ethanol/gintonic
	required_reagents = list(/datum/reagent/ethanol/gin = 2, /datum/reagent/drink/tonic = 1)
	result_amount = 3

/singleton/reaction/cuba_libre
	name = "Cuba Libre"
	result = /datum/reagent/ethanol/cuba_libre
	required_reagents = list(/datum/reagent/ethanol/rum = 2, /datum/reagent/drink/space_cola = 1)
	result_amount = 3

/singleton/reaction/martini
	name = "Classic Martini"
	result = /datum/reagent/ethanol/martini
	required_reagents = list(/datum/reagent/ethanol/gin = 2, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/singleton/reaction/vodkamartini
	name = "Vodka Martini"
	result = /datum/reagent/ethanol/vodkamartini
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/singleton/reaction/white_russian
	name = "White Russian"
	result = /datum/reagent/ethanol/white_russian
	required_reagents = list(/datum/reagent/ethanol/black_russian = 2, /datum/reagent/drink/milk/cream = 1)
	result_amount = 3

/singleton/reaction/whiskey_cola
	name = "Whiskey Cola"
	result = /datum/reagent/ethanol/whiskey_cola
	required_reagents = list(/datum/reagent/ethanol/whiskey = 2, /datum/reagent/drink/space_cola = 1)
	result_amount = 3

/singleton/reaction/screwdriver
	name = "Screwdriver"
	result = /datum/reagent/ethanol/screwdrivercocktail
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/drink/juice/orange = 1)
	result_amount = 3

/singleton/reaction/battuta
	name = "Ibn Battuta"
	result = /datum/reagent/ethanol/battuta
	required_reagents = list(/datum/reagent/ethanol/herbal = 2, /datum/reagent/drink/juice/orange = 1)
	catalysts = list(/datum/reagent/nutriment/mint)
	result_amount = 3

/singleton/reaction/magellan
	name = "Magellan"
	result = /datum/reagent/ethanol/magellan
	required_reagents = list(/datum/reagent/ethanol/wine = 1, /datum/reagent/ethanol/specialwhiskey = 1)
	catalysts = list(/datum/reagent/sugar)
	result_amount = 2

/singleton/reaction/zhenghe
	name = "Zheng He"
	result = /datum/reagent/ethanol/zhenghe
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/singleton/reaction/armstrong
	name = "Armstrong"
	result = /datum/reagent/ethanol/armstrong
	required_reagents = list(/datum/reagent/ethanol/beer = 2, /datum/reagent/ethanol/vodka = 1, /datum/reagent/drink/juice/lime = 1)
	result_amount = 4

/singleton/reaction/bloody_mary
	name = "Bloody Mary"
	result = /datum/reagent/ethanol/bloody_mary
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/drink/juice/tomato = 3, /datum/reagent/drink/juice/lime = 1)
	result_amount = 6

/singleton/reaction/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	result = /datum/reagent/ethanol/gargle_blaster
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/ethanol/gin = 1, /datum/reagent/ethanol/specialwhiskey = 1, /datum/reagent/ethanol/cognac = 1, /datum/reagent/drink/juice/lime = 1)
	result_amount = 6

/singleton/reaction/brave_bull
	name = "Brave Bull"
	result = /datum/reagent/ethanol/coffee/brave_bull
	required_reagents = list(/datum/reagent/ethanol/tequilla = 2, /datum/reagent/ethanol/coffee/kahlua = 1)
	result_amount = 3

/singleton/reaction/tequilla_sunrise
	name = "Tequilla Sunrise"
	result = /datum/reagent/ethanol/tequilla_sunrise
	required_reagents = list(/datum/reagent/ethanol/tequilla = 2, /datum/reagent/drink/juice/orange = 1)
	result_amount = 3

/singleton/reaction/phoron_special
	name = "Toxins Special"
	result = /datum/reagent/ethanol/toxins_special
	required_reagents = list(/datum/reagent/ethanol/rum = 2, /datum/reagent/ethanol/vermouth = 2, /datum/reagent/toxin/phoron = 2)
	result_amount = 6

/singleton/reaction/beepsky_smash
	name = "Beepksy Smash"
	result = /datum/reagent/ethanol/beepsky_smash
	required_reagents = list(/datum/reagent/drink/juice/lime = 1, /datum/reagent/ethanol/whiskey = 1, /datum/reagent/iron = 1)
	result_amount = 2

/singleton/reaction/doctor_delight
	name = "The Doctor's Delight"
	result = /datum/reagent/drink/doctor_delight
	required_reagents = list(/datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/juice/tomato = 1, /datum/reagent/drink/juice/orange = 1, /datum/reagent/drink/milk/cream = 2, /datum/reagent/tricordrazine = 1)
	result_amount = 6

/singleton/reaction/irish_cream
	name = "Irish Cream"
	result = /datum/reagent/ethanol/irish_cream
	required_reagents = list(/datum/reagent/ethanol/whiskey = 2, /datum/reagent/drink/milk/cream = 1)
	result_amount = 3

/singleton/reaction/manly_dorf
	name = "The Manly Dorf"
	result = /datum/reagent/ethanol/manly_dorf
	required_reagents = list (/datum/reagent/ethanol/beer = 1, /datum/reagent/ethanol/ale = 2)
	result_amount = 3

/singleton/reaction/hooch
	name = "Hooch"
	result = /datum/reagent/ethanol/hooch
	required_reagents = list (/datum/reagent/sugar = 1, /datum/reagent/ethanol = 2, /datum/reagent/fuel = 1)
	minimum_temperature = 30 CELSIUS
	maximum_temperature = (30 CELSIUS) + 100
	result_amount = 3

/singleton/reaction/irish_coffee
	name = "Irish Coffee"
	result = /datum/reagent/ethanol/coffee/irishcoffee
	required_reagents = list(/datum/reagent/ethanol/irish_cream = 1, /datum/reagent/drink/coffee = 1)
	result_amount = 2

/singleton/reaction/b52
	name = "B-52"
	result = /datum/reagent/ethanol/coffee/b52
	required_reagents = list(/datum/reagent/ethanol/irish_cream = 1, /datum/reagent/ethanol/coffee/kahlua = 1, /datum/reagent/ethanol/cognac = 1)
	result_amount = 3

/singleton/reaction/atomicbomb
	name = "Atomic Bomb"
	result = /datum/reagent/ethanol/atomicbomb
	required_reagents = list(/datum/reagent/ethanol/coffee/b52 = 10, /datum/reagent/uranium = 1)
	result_amount = 10

/singleton/reaction/margarita
	name = "Margarita"
	result = /datum/reagent/ethanol/margarita
	required_reagents = list(/datum/reagent/ethanol/tequilla = 2, /datum/reagent/drink/juice/lime = 1)
	result_amount = 3

/singleton/reaction/longislandicedtea
	name = "Long Island Iced Tea"
	result = /datum/reagent/ethanol/longislandicedtea
	required_reagents = list(/datum/reagent/ethanol/vodka = 1, /datum/reagent/ethanol/gin = 1, /datum/reagent/ethanol/tequilla = 1, /datum/reagent/ethanol/cuba_libre = 3)
	result_amount = 6

/singleton/reaction/threemileisland
	name = "Three Mile Island Iced Tea"
	result = /datum/reagent/ethanol/threemileisland
	required_reagents = list(/datum/reagent/ethanol/longislandicedtea = 10, /datum/reagent/uranium = 1)
	result_amount = 10

/singleton/reaction/whiskeysoda
	name = "Whiskey Soda"
	result = /datum/reagent/ethanol/whiskeysoda
	required_reagents = list(/datum/reagent/ethanol/whiskey = 2, /datum/reagent/drink/sodawater = 1)
	result_amount = 3

/singleton/reaction/black_russian
	name = "Black Russian"
	result = /datum/reagent/ethanol/black_russian
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/ethanol/coffee/kahlua = 1)
	result_amount = 3

/singleton/reaction/manhattan
	name = "Manhattan"
	result = /datum/reagent/ethanol/manhattan
	required_reagents = list(/datum/reagent/ethanol/whiskey = 2, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/singleton/reaction/manhattan_proj
	name = "Manhattan Project"
	result = /datum/reagent/ethanol/manhattan_proj
	required_reagents = list(/datum/reagent/ethanol/manhattan = 10, /datum/reagent/uranium = 1)
	result_amount = 10

/singleton/reaction/vodka_tonic
	name = "Vodka and Tonic"
	result = /datum/reagent/ethanol/vodkatonic
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/drink/tonic = 1)
	result_amount = 3

/singleton/reaction/gin_fizz
	name = "Gin Fizz"
	result = /datum/reagent/ethanol/ginfizz
	required_reagents = list(/datum/reagent/ethanol/gin = 1, /datum/reagent/drink/sodawater = 1, /datum/reagent/drink/juice/lime = 1)
	result_amount = 3

/singleton/reaction/bahama_mama
	name = "Bahama Mama"
	result = /datum/reagent/ethanol/bahama_mama
	required_reagents = list(/datum/reagent/ethanol/rum = 2, /datum/reagent/drink/juice/orange = 2, /datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/ice = 1)
	result_amount = 6

/singleton/reaction/singulo
	name = "Singulo"
	result = /datum/reagent/ethanol/singulo
	required_reagents = list(/datum/reagent/ethanol/vodka = 5, /datum/reagent/radium = 1, /datum/reagent/ethanol/wine = 5)
	result_amount = 10

/singleton/reaction/alliescocktail
	name = "Allies Cocktail"
	result = /datum/reagent/ethanol/alliescocktail
	required_reagents = list(/datum/reagent/ethanol/vodkamartini = 1, /datum/reagent/ethanol/martini = 1)
	result_amount = 2

/singleton/reaction/demonsblood
	name = "Demon's Blood"
	result = /datum/reagent/ethanol/demonsblood
	required_reagents = list(/datum/reagent/ethanol/rum = 3, /datum/reagent/drink/spacemountainwind = 1, /datum/reagent/blood = 1, /datum/reagent/drink/dr_gibb = 1)
	result_amount = 6

/singleton/reaction/booger
	name = "Booger"
	result = /datum/reagent/ethanol/booger
	required_reagents = list(/datum/reagent/drink/milk/cream = 2, /datum/reagent/drink/juice/banana = 1, /datum/reagent/ethanol/rum = 1, /datum/reagent/drink/juice/watermelon = 1)
	result_amount = 5
	mix_message = "The solution thickens unpleasantly."

/singleton/reaction/antifreeze
	name = "Anti-freeze"
	result = /datum/reagent/ethanol/antifreeze
	required_reagents = list(/datum/reagent/ethanol/vodka = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/drink/ice = 1)
	minimum_temperature = (0 CELSIUS) - 100
	maximum_temperature = 0 CELSIUS
	result_amount = 3
	mix_message = "The solution thickens sluggishly."

/singleton/reaction/barefoot
	name = "Barefoot"
	result = /datum/reagent/ethanol/barefoot
	required_reagents = list(/datum/reagent/drink/juice/berry = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/singleton/reaction/grapesoda
	name = "Grape Soda"
	result = /datum/reagent/drink/grapesoda
	required_reagents = list(/datum/reagent/drink/juice/grape = 2, /datum/reagent/drink/space_cola = 1)
	result_amount = 3

/singleton/reaction/sbiten
	name = "Sbiten"
	result = /datum/reagent/ethanol/sbiten
	required_reagents = list(/datum/reagent/ethanol/mead = 10, /datum/reagent/capsaicin = 1)
	result_amount = 10

/singleton/reaction/red_mead
	name = "Red Mead"
	result = /datum/reagent/ethanol/red_mead
	required_reagents = list(/datum/reagent/blood = 1, /datum/reagent/ethanol/mead = 1)
	result_amount = 2

/singleton/reaction/mead
	name = "Mead"
	result = /datum/reagent/ethanol/mead
	required_reagents = list(/datum/reagent/nutriment/honey = 1, /datum/reagent/water = 1)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 2

/singleton/reaction/iced_beer
	name = "Iced Beer"
	result = /datum/reagent/ethanol/iced_beer
	required_reagents = list(/datum/reagent/ethanol/beer = 10, /datum/reagent/frostoil = 1)
	result_amount = 10
	mix_message = "The solution chills rapidly, frost forming on its surface."

/singleton/reaction/iced_beer2
	name = "Iced Beer"
	result = /datum/reagent/ethanol/iced_beer
	required_reagents = list(/datum/reagent/ethanol/beer = 5, /datum/reagent/drink/ice = 1)
	result_amount = 6
	mix_message = "The ice clinks together in the beer."

/singleton/reaction/grog
	name = "Grog"
	result = /datum/reagent/ethanol/grog
	required_reagents = list(/datum/reagent/ethanol/rum = 1, /datum/reagent/water = 1)
	result_amount = 2

/singleton/reaction/soy_latte
	name = "Soy Latte"
	result = /datum/reagent/drink/coffee/soy_latte
	required_reagents = list(/datum/reagent/drink/coffee = 1, /datum/reagent/drink/milk/soymilk = 1)
	result_amount = 2
	mix_message = "The soy milk suffuses the coffee with pale shades."

/singleton/reaction/cafe_latte
	name = "Cafe Latte"
	result = /datum/reagent/drink/coffee/cafe_latte
	required_reagents = list(/datum/reagent/drink/coffee = 1, /datum/reagent/drink/milk = 1)
	result_amount = 2
	mix_message = "The milk suffuses the coffee with pale shades."

/singleton/reaction/mocha_latte
	name = "Mocha Latte"
	result = /datum/reagent/drink/coffee/cafe_latte/mocha
	required_reagents = list(/datum/reagent/drink/coffee/cafe_latte = 2, /datum/reagent/drink/syrup_chocolate = 1)
	result_amount = 3
	mix_message = "The chocolate swirls into the latte."

/singleton/reaction/soy_mocha_latte
	name = "Mocha Soy Latte"
	result = /datum/reagent/drink/coffee/soy_latte/mocha
	required_reagents = list(/datum/reagent/drink/coffee/soy_latte = 3, /datum/reagent/drink/syrup_chocolate = 1)
	result_amount = 4
	mix_message = "The chocolate swirls into the latte."

/singleton/reaction/ice_mocha_latte
	name = "Iced Mocha Latte"
	result = /datum/reagent/drink/coffee/icecoffee/cafe_latte/mocha
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee/cafe_latte/mocha = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled mocha latte."

/singleton/reaction/ice_soy_mocha_latte
	name = "Iced Soy Mocha Latte"
	result = /datum/reagent/drink/coffee/icecoffee/soy_latte/mocha
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee/soy_latte/mocha = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled soy mocha latte."

/singleton/reaction/pumpkin_latte
	name = "Pumpkin Spice Latte"
	result = /datum/reagent/drink/coffee/cafe_latte/pumpkin
	required_reagents = list(/datum/reagent/drink/coffee/cafe_latte = 2, /datum/reagent/drink/syrup_pumpkin = 1)
	result_amount = 3
	mix_message = "The pumpkin spice swirls into the latte."

/singleton/reaction/soy_pumpkin_latte
	name = "Pumpkin Spice Soy Latte"
	result = /datum/reagent/drink/coffee/soy_latte/pumpkin
	required_reagents = list(/datum/reagent/drink/coffee/soy_latte = 3, /datum/reagent/drink/syrup_pumpkin = 1)
	result_amount = 4
	mix_message = "The pumpkin spice swirls into the latte."

/singleton/reaction/ice_pumpkin_latte
	name = "Iced Pumpkin Spice Latte"
	result = /datum/reagent/drink/coffee/icecoffee/cafe_latte/pumpkin
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee/cafe_latte/pumpkin = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled pumpkin spice latte."

/singleton/reaction/ice_soy_pumpkin_latte
	name = "Iced Pumpkin Spice Soy Latte"
	result = /datum/reagent/drink/coffee/icecoffee/soy_latte/pumpkin
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee/soy_latte/pumpkin = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled pumpkin spice soy latte."

/singleton/reaction/acidspit
	name = "Acid Spit"
	result = /datum/reagent/ethanol/acid_spit
	required_reagents = list(/datum/reagent/acid = 1, /datum/reagent/ethanol/wine = 5)
	result_amount = 6
	mix_message = "The solution curdles into an unpleasant, slimy liquid."

/singleton/reaction/amasec
	name = "Amasec"
	result = /datum/reagent/ethanol/amasec
	required_reagents = list(/datum/reagent/iron = 1, /datum/reagent/ethanol/wine = 5, /datum/reagent/ethanol/vodka = 5)
	result_amount = 10

/singleton/reaction/changelingsting
	name = "Changeling Sting"
	result = /datum/reagent/ethanol/changelingsting
	required_reagents = list(/datum/reagent/ethanol/screwdrivercocktail = 1, /datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/juice/lemon = 1)
	result_amount = 3
	mix_message = "The solution begins to shift and change colour."

/singleton/reaction/aloe
	name = "Aloe"
	result = /datum/reagent/ethanol/aloe
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/ethanol/specialwhiskey = 1, /datum/reagent/drink/juice/watermelon = 1)
	result_amount = 3

/singleton/reaction/andalusia
	name = "Andalusia"
	result = /datum/reagent/ethanol/andalusia
	required_reagents = list(/datum/reagent/ethanol/rum = 1, /datum/reagent/ethanol/whiskey = 1, /datum/reagent/drink/juice/lemon = 1)
	result_amount = 3

/singleton/reaction/neurotoxin
	name = "Neurotoxin"
	result = /datum/reagent/ethanol/neurotoxin
	required_reagents = list(/datum/reagent/ethanol/gargle_blaster = 1, /datum/reagent/soporific = 1)
	result_amount = 2

/singleton/reaction/snowwhite
	name = "Snow White"
	result = /datum/reagent/ethanol/snowwhite
	required_reagents = list(/datum/reagent/ethanol/beer = 1, /datum/reagent/drink/lemon_lime = 1)
	result_amount = 2

/singleton/reaction/irishslammer
	name = "Irish Slammer"
	result = /datum/reagent/ethanol/irishslammer
	required_reagents = list(/datum/reagent/ethanol/ale = 1, /datum/reagent/ethanol/irish_cream = 1)
	result_amount = 2

/singleton/reaction/syndicatebomb
	name = "Syndicate Bomb"
	result = /datum/reagent/ethanol/syndicatebomb
	required_reagents = list(/datum/reagent/ethanol/beer = 1, /datum/reagent/ethanol/whiskey_cola = 1)
	result_amount = 2

/singleton/reaction/erikasurprise
	name = "Erika Surprise"
	result = /datum/reagent/ethanol/erikasurprise
	required_reagents = list(/datum/reagent/ethanol/ale = 2, /datum/reagent/drink/juice/lime = 1, /datum/reagent/ethanol/whiskey = 1, /datum/reagent/drink/juice/banana = 1, /datum/reagent/drink/ice = 1)
	result_amount = 6

/singleton/reaction/devilskiss
	name = "Devils Kiss"
	result = /datum/reagent/ethanol/devilskiss
	required_reagents = list(/datum/reagent/blood = 1, /datum/reagent/ethanol/coffee/kahlua = 1, /datum/reagent/ethanol/rum = 1)
	result_amount = 3

/singleton/reaction/hippiesdelight
	name = "Hippies Delight"
	result = /datum/reagent/ethanol/hippies_delight
	required_reagents = list(/datum/reagent/drugs/psilocybin = 1, /datum/reagent/ethanol/gargle_blaster = 1)
	result_amount = 2

/singleton/reaction/bananahonk
	name = "Banana Honk"
	result = /datum/reagent/ethanol/bananahonk
	required_reagents = list(/datum/reagent/drink/juice/banana = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/singleton/reaction/silencer
	name = "Silencer"
	result = /datum/reagent/ethanol/silencer
	required_reagents = list(/datum/reagent/drink/nothing = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/singleton/reaction/driestmartini
	name = "Driest Martini"
	result = /datum/reagent/ethanol/driestmartini
	required_reagents = list(/datum/reagent/drink/nothing = 1, /datum/reagent/ethanol/gin = 1)
	result_amount = 2

/singleton/reaction/lemonade
	name = "Lemonade"
	result = /datum/reagent/drink/lemonade
	required_reagents = list(/datum/reagent/drink/juice/lemon = 1, /datum/reagent/sugar = 1, /datum/reagent/water = 1)
	result_amount = 3

/singleton/reaction/kiraspecial
	name = "Kira Special"
	result = /datum/reagent/drink/kiraspecial
	required_reagents = list(/datum/reagent/drink/juice/orange = 1, /datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/sodawater = 1)
	result_amount = 3

/singleton/reaction/triplecitrus
	name = "Triple Citrus"
	result = /datum/reagent/drink/triplecitrus
	required_reagents = list(/datum/reagent/drink/juice/orange = 1, /datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/juice/lemon = 1)
	result_amount = 3

/singleton/reaction/milkshake
	name = "Milkshake"
	result = /datum/reagent/drink/milkshake
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/drink/ice = 2, /datum/reagent/drink/milk = 2)
	result_amount = 5

/singleton/reaction/ntella_shake
	name = "NTella milkshake"
	result = /datum/reagent/drink/milkshake/ntella
	required_reagents = list(/datum/reagent/drink/milkshake = 5, /datum/reagent/nutriment/choconutspread = 1)
	result_amount = 6

/singleton/reaction/rewriter
	name = "Rewriter"
	result = /datum/reagent/drink/rewriter
	required_reagents = list(/datum/reagent/drink/spacemountainwind = 1, /datum/reagent/drink/coffee = 1)
	result_amount = 2

/singleton/reaction/suidream
	name = "Sui Dream"
	result = /datum/reagent/ethanol/suidream
	required_reagents = list(/datum/reagent/drink/space_up = 1, /datum/reagent/ethanol/bluecuracao = 1, /datum/reagent/ethanol/melonliquor = 1)
	result_amount = 3

/singleton/reaction/rum
	name = "Rum"
	result = /datum/reagent/ethanol/rum
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/water = 1)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 2
	mix_message = "The solution roils as it rapidly ferments into a red-brown liquid."

/singleton/reaction/ships_surgeon
	name = "Ship's Surgeon"
	result = /datum/reagent/ethanol/ships_surgeon
	required_reagents = list(/datum/reagent/ethanol/rum = 1, /datum/reagent/drink/dr_gibb = 2, /datum/reagent/drink/ice = 1)
	result_amount = 4

/singleton/reaction/luminol
	name = "Luminol"
	result = /datum/reagent/luminol
	required_reagents = list(/datum/reagent/hydrazine = 2, /datum/reagent/carbon = 2, /datum/reagent/ammonia = 2)
	result_amount = 6
	mix_message = "The solution begins to gleam with a fey inner light."

/singleton/reaction/oxyphoron
	name = "Oxyphoron"
	result = /datum/reagent/toxin/phoron/oxygen
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/toxin/phoron = 1)
	result_amount = 2
	mix_message = "The solution boils violently, shedding wisps of vapor."

/singleton/reaction/deuterium
	name = "Deuterium"
	result = null
	required_reagents = list(/datum/reagent/water = 10)
	catalysts = list(/datum/reagent/toxin/phoron/oxygen = 5)
	result_amount = 1
	mix_message = "The solution makes a loud cracking sound as it crystalizes."

/singleton/reaction/deuterium/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/turf/T = get_turf(holder.my_atom)
	if(istype(T)) new /obj/item/stack/material/deuterium(T, created_volume)
	return

/singleton/reaction/antidexafen
	name = "Antidexafen"
	result = /datum/reagent/antidexafen
	required_reagents = list(/datum/reagent/paracetamol = 1, /datum/reagent/carbon = 1)
	result_amount = 2

/singleton/reaction/nanoblood
	name = "Nanoblood"
	result = /datum/reagent/nanoblood
	required_reagents = list(/datum/reagent/dexalinp = 1, /datum/reagent/iron = 1, /datum/reagent/blood = 1)
	result_amount = 3

/*/singleton/reaction/tridezatane
	name = "Tridezatane"
	result = /datum/reagent/tridezatane
	required_reagents = list(/datum/reagent/spaceacillin = 3, /datum/reagent/uranium = 1)
	result_amount = 1*/

/singleton/reaction/latrazine
	name = "Latrazine"
	result = /datum/reagent/latrazine
	required_reagents = list(/datum/reagent/toxin/phoron = 10, /datum/reagent/peridaxon = 1, /datum/reagent/paroxetine = 1)
	result_amount = 1

	mix_message = "The solution thickens slowly into a glossy liquid."

/singleton/reaction/vinegar
	name = "Apple Vinegar"
	result = /datum/reagent/nutriment/vinegar
	required_reagents = list(/datum/reagent/drink/juice/apple = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a sharp-smelling liquid."

/singleton/reaction/vinegar2
	name = "Clear Vinegar"
	result = /datum/reagent/nutriment/vinegar
	required_reagents = list(/datum/reagent/ethanol = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a sharp-smelling liquid."

/singleton/reaction/mayo
	name = "Vinegar Mayo"
	result = /datum/reagent/nutriment/mayo
	required_reagents = list(/datum/reagent/nutriment/vinegar = 5, /datum/reagent/nutriment/protein/egg = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy, creamy substance."

/singleton/reaction/mayo2
	name = "Lemon Mayo"
	result = /datum/reagent/nutriment/mayo
	required_reagents = list(/datum/reagent/drink/juice/lemon = 5, /datum/reagent/nutriment/protein/egg = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy, creamy substance."

// psi-altering drug
/singleton/reaction/three_eye
	name = "Three Eye"
	result = /datum/reagent/drugs/three_eye
	result_amount = 2
	mix_message = "The surface of the oily, iridescent liquid twitches like a living thing."
	minimum_temperature = 40 CELSIUS
	reaction_sound = 'sound/effects/psi/power_used.ogg'
	hidden_from_codex = TRUE

	catalysts = list(
		/datum/reagent/toxin/carpotoxin = 1,
		/datum/reagent/enzyme = 1
	)

	required_reagents = list(
		/datum/reagent/drugs/mindbreaker = 2,
		/datum/reagent/toxin/phoron = 1,
		/datum/reagent/blood = 1
	)

// tea expansion pack content - black tea drinks
/singleton/reaction/icetea
	name = "Iced Tea"
	result = /datum/reagent/drink/tea/icetea
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the tea."

/singleton/reaction/sweettea
	name = "Sweet Tea"
	result = /datum/reagent/drink/tea/icetea/sweet
	required_reagents = list(/datum/reagent/drink/tea/icetea = 2, /datum/reagent/sugar = 1)
	result_amount = 3
	mix_message = "The ice clinks together in the sweet tea."

/singleton/reaction/barongrey
	name = "Baron Grey Tea"
	result = /datum/reagent/drink/tea/barongrey
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/drink/juice/orange = 1)
	result_amount = 3
	mix_message = "The juice swirls into the tea."

/singleton/reaction/latte_barongrey
	name = "London Fog"
	result = /datum/reagent/drink/tea/barongrey/latte
	required_reagents = list(/datum/reagent/drink/tea/barongrey = 2, /datum/reagent/drink/milk = 1)
	result_amount = 3
	mix_message = "The milk swirls into the tea."

/singleton/reaction/soy_latte_barongrey
	name = "Soy London Fog"
	result = /datum/reagent/drink/tea/barongrey/soy_latte
	required_reagents = list(/datum/reagent/drink/tea/barongrey = 2, /datum/reagent/drink/milk/soymilk = 1)
	result_amount = 3
	mix_message = "The soy swirls into the tea."

/singleton/reaction/ice_latte_barongrey
	name = "Iced London Fog"
	result = /datum/reagent/drink/tea/icetea/barongrey/latte
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/barongrey/latte = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled london fog."

/singleton/reaction/ice_soy_latte_barongrey
	name = "Iced Soy London Fog"
	result = /datum/reagent/drink/tea/icetea/barongrey/soy_latte
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/barongrey/soy_latte = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled soy london fog."

//green tea drinks
/singleton/reaction/icetea_green
	name = "Iced Green Tea"
	result = /datum/reagent/drink/tea/icetea/green
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/green = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the tea."

/singleton/reaction/sweettea_green
	name = "Sweet Green Tea"
	result = /datum/reagent/drink/tea/icetea/green/sweet
	required_reagents = list(/datum/reagent/drink/tea/icetea/green = 2, /datum/reagent/sugar = 1)
	result_amount = 3
	mix_message = "The ice clinks together in the sweet tea."

/singleton/reaction/maghreb_tea
	name = "Maghrebi tea"
	result = /datum/reagent/drink/tea/icetea/green/sweet/mint
	required_reagents = list(/datum/reagent/drink/tea/icetea/green/sweet = 3)
	catalysts = list(/datum/reagent/nutriment/mint)
	result_amount = 3
	mix_message = "The mint swirls into the drink."

/singleton/reaction/icetea_chai
	name = "Iced Chai Tea"
	result = /datum/reagent/drink/tea/icetea/chai
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/chai = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the tea."

/singleton/reaction/sweettea_chai
	name = "Iced Chai Tea"
	result = /datum/reagent/drink/tea/icetea/chai/sweet
	required_reagents = list(/datum/reagent/drink/tea/icetea/chai = 2, /datum/reagent/sugar = 1)
	result_amount = 3
	mix_message = "The ice clinks together in the sweet tea."

/singleton/reaction/latte_chai
	name = "Chai Latte"
	result = /datum/reagent/drink/tea/chai/latte
	required_reagents = list(/datum/reagent/drink/tea/chai = 2, /datum/reagent/drink/milk = 1)
	result_amount = 3
	mix_message = "The milk swirls into the drink."

/singleton/reaction/soy_latte_chai
	name = "Chai Soy Latte"
	result = /datum/reagent/drink/tea/chai/soy_latte
	required_reagents = list(/datum/reagent/drink/tea/chai = 2, /datum/reagent/drink/milk/soymilk = 1)
	result_amount = 3
	mix_message = "The milk swirls into the drink."

/singleton/reaction/ice_latte_chai
	name = "Iced Chai Latte"
	result = /datum/reagent/drink/tea/icetea/chai/latte
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/chai/latte = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled chai latte."

/singleton/reaction/ice_soy_latte_chai
	name = "Iced Chai Soy Latte"
	result = /datum/reagent/drink/tea/icetea/chai/soy_latte
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/chai/soy_latte = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled chai soy latte."

/singleton/reaction/icetea_red
	name = "Iced Rooibos tea"
	result = /datum/reagent/drink/tea/icetea/red
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/red = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the tea."

/singleton/reaction/sweettea_red
	name = "Iced Rooibos tea"
	result = /datum/reagent/drink/tea/icetea/red/sweet
	required_reagents = list(/datum/reagent/drink/tea/icetea/red = 2, /datum/reagent/sugar = 1)
	result_amount = 3
	mix_message = "The ice clinks together in the sweet tea."

/singleton/reaction/chazuke
	name = "Chazuke"
	result = /datum/reagent/nutriment/rice/chazuke
	required_reagents = list(/datum/reagent/nutriment/rice = 10, /datum/reagent/drink/tea/green = 1)
	result_amount = 10
	mix_message = "The tea mingles with the rice."

/singleton/reaction/resin_pack
	name = "Resin Globule"
	result = null
	required_reagents = list(
		/datum/reagent/crystal = 1,
		/datum/reagent/silicon = 2
	)
	catalysts = list(
		/datum/reagent/toxin/phoron = 1
	)
	result_amount = 3
	mix_message = "The solution hardens and begins to crystallize."

/singleton/reaction/resin_pack/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	..()
	var/turf/T = get_turf(holder.my_atom)
	if(istype(T))
		var/create_stacks = floor(created_volume)
		if(create_stacks > 0)
			new /obj/item/stack/medical/resin/handmade(T, create_stacks)

/singleton/reaction/crystal_agent
	result = /datum/reagent/crystal
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/tungsten = 1, /datum/reagent/acid/polyacid = 1)
	minimum_temperature = 150 CELSIUS
	maximum_temperature = 200 CELSIUS
	result_amount = 3

/singleton/reaction/immunobooster
	result = /datum/reagent/immunobooster
	required_reagents = list(/datum/reagent/drugs/cryptobiolin = 1, /datum/reagent/dylovene = 1)
	minimum_temperature = 40 CELSIUS
	result_amount = 2

// Alcohol Expansion

//Alcohol
/singleton/reaction/applecider
	name = "Apple Cider"
	result = /datum/reagent/ethanol/applecider
	required_reagents = list(/datum/reagent/drink/juice/apple = 2, /datum/reagent/sugar = 1)
	catalysts = list(/datum/reagent/nutriment = 5)
	result_amount = 3

/singleton/reaction/lunabrandy
	name = "Lunar Brandy"
	result = /datum/reagent/ethanol/lunabrandy
	required_reagents = list(/datum/reagent/drink/juice/grape = 1, /datum/reagent/ethanol/wine = 2)
	catalysts = list(/datum/reagent/nutriment = 5)
	result_amount = 3

/singleton/reaction/hellshenpa
	name = "Hellshen Pale Ale"
	result = /datum/reagent/ethanol/hellshenpa
	required_reagents = list(/datum/reagent/ethanol/beer = 1, /datum/reagent/sugar = 1, /datum/reagent/water = 1)
	result_amount = 3

/singleton/reaction/vodkacola
	name = "Vodka Cola"
	result = /datum/reagent/ethanol/vodkacola
	required_reagents = list(/datum/reagent/drink/space_cola = 1, /datum/reagent/ethanol/vodka = 2)
	result_amount = 3
	mix_message = "The vodka slowly begins to fizz"

/singleton/reaction/red_whiskey
	name = "Red Whiskey"
	result = /datum/reagent/ethanol/red_whiskey
	required_reagents = list(/datum/reagent/drink/juice/berry = 1, /datum/reagent/drink/juice/tomato = 1, /datum/reagent/ethanol/whiskey = 1, /datum/reagent/ethanol/specialwhiskey = 1)
	result_amount = 4

/singleton/reaction/nevadan_gold
	name = "Nevadan Gold Whiskey"
	result = /datum/reagent/ethanol/nevadan_gold
	required_reagents = list(/datum/reagent/ethanol/specialwhiskey = 1, /datum/reagent/ethanol/goldschlager = 1, /datum/reagent/ethanol/irish_cream = 1,)
	result_amount = 3

/singleton/reaction/arak
	name = "Arak"
	result = /datum/reagent/ethanol/arak
	required_reagents = list(/datum/reagent/ethanol/absinthe = 2, /datum/reagent/drink/juice/grape = 1)
	catalysts = list(/datum/reagent/nutriment)
	result_amount = 3
	minimum_temperature = (0 CELSIUS) - 100
	maximum_temperature = 0 CELSIUS
	mix_message = "The aniseed ferments into a translucent white mixture"

/singleton/reaction/blackstrap
	name = "Blackstrap"
	result = /datum/reagent/ethanol/blackstrap
	required_reagents = list(/datum/reagent/ethanol/whiskey = 1, /datum/reagent/ethanol/rum = 2)
	result_amount = 3
	mix_message = "The whiskey swirls into a darker tone"

/singleton/reaction/stag
	name = "Stag"
	result = /datum/reagent/ethanol/stag
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/ethanol/rum = 1)
	result_amount = 3
	mix_message = "The tea and rum blend together smoothly"

/singleton/reaction/tadmorwine
	name = "Tadmoran Wine"
	result = /datum/reagent/ethanol/tadmorwine
	required_reagents = list(/datum/reagent/ethanol/wine = 2, /datum/reagent/drink/grenadine = 1)
	catalysts = list(/datum/reagent/nutriment/mint)
	result_amount = 3
	mix_message = "The residue in the mixture sinks to the bottom"

/singleton/reaction/jagerbomb
	name = "Jagerbomb"
	result = /datum/reagent/ethanol/jagerbomb
	required_reagents = list(/datum/reagent/drink/beastenergy = 1, /datum/reagent/ethanol/jagermeister = 2)
	result_amount = 3

/singleton/reaction/jagermeister
	name = "Jagermeister"
	result = /datum/reagent/ethanol/jagermeister
	required_reagents = list(/datum/reagent/ethanol/herbal = 2, /datum/reagent/water = 1)
	catalysts = list(/datum/reagent/nutriment/mint)
	result_amount = 3

/singleton/reaction/lonestarmule
	name = "Lonestar Mule"
	result = /datum/reagent/ethanol/lonestarmule
	required_reagents = list(/datum/reagent/ethanol/whiskey = 2, /datum/reagent/drink/gingerbeer = 1, /datum/reagent/drink/juice/lime = 1)
	result_amount = 4
	mix_message = "The aroma of ginger and lime assaults the room"

/singleton/reaction/llanbrydewhiskey
	name = "Llanbryde Whiskey"
	result = /datum/reagent/ethanol/llanbrydewhiskey
	required_reagents = list(/datum/reagent/ethanol/specialwhiskey= 2, /datum/reagent/ethanol/gin = 1)
	catalysts = list(/datum/reagent/sugar)
	result_amount = 3
	mix_message = "The gin slowly mixes with the whiskey"

/singleton/reaction/kvass
	name = "Kvass"
	result = /datum/reagent/ethanol/kvass
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/ethanol/beer = 1)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 3
	mix_message = "The faint smell of rye bread wafts from the container"

/singleton/reaction/gargled
	name = "Gargled"
	result = /datum/reagent/ethanol/coffee/gargled
	required_reagents = list(/datum/reagent/ethanol/blackstrap = 1, /datum/reagent/drink/coffee = 2)
	result_amount = 3
	mix_message = "The mixture begins to pale"

/singleton/reaction/bogus
	name = "Bogus"
	result = /datum/reagent/ethanol/bogus
	required_reagents = list(/datum/reagent/ethanol/gin = 1, /datum/reagent/ethanol/blackstrap = 2)
	result_amount = 3
	mix_message = "The gin and rum swirl together smoothly"

/singleton/reaction/moscowmule
	name = "Moscow Mule"
	result = /datum/reagent/ethanol/moscowmule
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/drink/gingerbeer = 1, /datum/reagent/drink/juice/lime = 1)
	result_amount = 4
	mix_message = "The aroma of ginger and juice rises from the mixture"

/singleton/reaction/springpunch
	name = "Gilgamesh Spring Punch"
	result = /datum/reagent/ethanol/springpunch
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/drink/juice/lemon = 1,  /datum/reagent/sugar = 1)
	result_amount = 4
	mix_message = "The aroma of sweet lemon rises from the mixture"

/singleton/reaction/jimmygideon
	name = "Jimmy Gideon"
	result = /datum/reagent/ethanol/jimmygideon
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/ethanol/cognac = 1, /datum/reagent/drink/hot_coco = 1)
	result_amount = 3
	mix_message = "The liquid swirls into the color of Martian sand"

/singleton/reaction/kamikaze
	name = "Kamikaze"
	result = /datum/reagent/ethanol/kamikaze
	required_reagents = list(/datum/reagent/ethanol/vodka = 1, /datum/reagent/ethanol/triple_sec = 1, /datum/reagent/drink/juice/lime = 1)
	result_amount = 3
	mix_message = "The mixture begins to fizz and pop"

/singleton/reaction/grasshopper
	name = "Grasshopper"
	result = /datum/reagent/ethanol/grasshopper
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/ethanol/creme_de_menthe = 1, /datum/reagent/ethanol/creme_de_cacao = 1)
	result_amount = 3
	mix_message = "The aroma of mint and chocolate seeps from the mixture"

/singleton/reaction/stinger
	name = "Stinger"
	result = /datum/reagent/ethanol/stinger
	required_reagents = list(/datum/reagent/ethanol/creme_de_menthe = 1, /datum/reagent/ethanol/cognac = 2)
	result_amount = 3
	mix_message = "A gust of fresh mint wafts from the mixture"

/singleton/reaction/alexander
	name = "Alexander"
	result = /datum/reagent/ethanol/alexander
	required_reagents = list(/datum/reagent/ethanol/creme_de_cacao = 1, /datum/reagent/ethanol/cognac = 1, /datum/reagent/drink/milk/cream = 1)
	result_amount = 3
	mix_message = "The smell of chocolate wafts from the mixture"

/singleton/reaction/drifter
	name = "Drifter"
	result = /datum/reagent/ethanol/drifter
	required_reagents = list(/datum/reagent/ethanol/rum = 1, /datum/reagent/ethanol/cognac = 2, /datum/reagent/ethanol/triple_sec = 1, /datum/reagent/drink/juice/lemon = 1)
	result_amount = 5
	mix_message = "The liquid swirls into a bright yellow"

/singleton/reaction/forget_me_shot
	name = "Forget-me-shot"
	result = /datum/reagent/ethanol/forget_me_shot
	required_reagents = list(/datum/reagent/ethanol/jagermeister = 1, /datum/reagent/ethanol/gin = 1, /datum/reagent/ethanol/triple_sec = 1, /datum/reagent/nutriment/vinegar =1, /datum/reagent/ethanol/hooch = 1)
	result_amount = 3
	mix_message = "The liquid is brought to a roiling boil, and then suddenly stops."

/singleton/reaction/bad_touch
	name = "Bad Touch"
	result = /datum/reagent/ethanol/bad_touch
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/ethanol/rum = 2, /datum/reagent/ethanol/absinthe = 1, /datum/reagent/drink/lemon_lime = 1)
	result_amount = 6
	mix_message = "The liquid turns a sour green."

/singleton/reaction/sugar_rush
	name = "Sugar Rush"
	result = /datum/reagent/ethanol/sugar_rush
	required_reagents = list(/datum/reagent/drink/spacemountainwind = 4, /datum/reagent/drink/grenadine = 1, /datum/reagent/ethanol/vodka = 1)
	result_amount = 6
	mix_message = "The mixture begins to violently fizz."

/singleton/reaction/cobalt_velvet
	name = "Cobalt Velvet"
	result = /datum/reagent/ethanol/cobalt_velvet
	required_reagents = list(/datum/reagent/ethanol/champagne = 3, /datum/reagent/drink/space_cola = 1, /datum/reagent/ethanol/bluecuracao = 2)
	result_amount = 6
	mix_message = "The cola sinks to the bottom of the glass"

/singleton/reaction/fringe_weaver
	name = "Fringe Weaver"
	result = /datum/reagent/ethanol/fringe_weaver
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/ethanol = 2, /datum/reagent/water= 1)
	result_amount = 4
	mix_message = "The mixture swirls with pink foam"

// Non-Alcoholic Drinks

/singleton/reaction/nothing
	name = "Nothing"
	result = /datum/reagent/drink/nothing
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/sugar = 1, /datum/reagent/water= 1)
	result_amount = 3

/singleton/reaction/fools_gold
	name = "Fools Gold"
	result = /datum/reagent/drink/fools_gold
	required_reagents = list(/datum/reagent/water = 2, /datum/reagent/ethanol/whiskey = 1)
	result_amount = 3

/singleton/reaction/snowball
	name = "Snowball"
	result = /datum/reagent/drink/snowball
	required_reagents = list(/datum/reagent/drink/ice = 2, /datum/reagent/drink/coffee/icecoffee = 1, /datum/reagent/drink/juice/watermelon = 1)
	result_amount = 4
	minimum_temperature = (0 CELSIUS) - 100
	maximum_temperature = 0 CELSIUS
	mix_message = "The solution turns pure white."

/singleton/reaction/browndwarf
	name = "Brown Dwarf"
	result = /datum/reagent/drink/browndwarf
	required_reagents = list(/datum/reagent/drink/hot_coco = 2, /datum/reagent/drink/spacemountainwind = 1)
	result_amount = 3
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The chocolate puffs up into a semi-solid state"

/singleton/reaction/kefir
	name = "Kefir"
	result = /datum/reagent/drink/kefir
	required_reagents = list(/datum/reagent/drink/milk = 2, /datum/reagent/drink/milk/cream = 1)
	result_amount = 3
	catalysts = list(/datum/reagent/nutriment)
	mix_message = "The milk ferments into kefir"

// Alien Drinks

/singleton/reaction/skrianhi
	name = "Skrianhi Tea"
	result = /datum/reagent/drink/skrianhi
	required_reagents = list(/datum/reagent/drink/unathijuice = 2, /datum/reagent/water = 1)
	result_amount = 3
	minimum_temperature = 50 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The tea turns a bitter black."

/singleton/reaction/mumbaksting
	name = "Mumbak Sting"
	result = /datum/reagent/drink/mumbaksting
	required_reagents = list(/datum/reagent/drink/unathijuice = 2, /datum/reagent/toxin = 1)
	result_amount = 3
	mix_message = "The toxins mix with the juice to create a dark red substance."

/singleton/reaction/wasgaelhi
	name = "Wasgaelhi"
	result = /datum/reagent/ethanol/wasgaelhi
	required_reagents = list(/datum/reagent/drink/unathijuice = 2, /datum/reagent/ethanol/wine = 1)
	result_amount = 3
	mix_message = "The mixture turns a dull purple."

/singleton/reaction/kzkzaa
	name = "Kzkzaa"
	result = /datum/reagent/drink/kzkzaa
	required_reagents = list(/datum/reagent/drink/unathijuice = 2, /datum/reagent/nutriment/protein = 1)
	result_amount = 3
	mix_message = "The mixture turns a deep orange."

//Fruit Expansion

/singleton/reaction/qokkhrona
	name = "Qokk'Hrona"
	result = /datum/reagent/ethanol/qokkhrona
	required_reagents = list(/datum/reagent/ethanol/qokkloa = 2, /datum/reagent/ethanol/wine = 1)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 3
	mix_message = "The mixture turns a soft red, bubbling faintly"

/singleton/reaction/coconutmilk
	name = "Coconut Milk"
	result = /datum/reagent/drink/coconut/milk
	required_reagents = list(/datum/reagent/drink/coconut = 2)
	result_amount = 3
	minimum_temperature = 50 CELSIUS
	maximum_temperature = (50 CELSIUS) + 100
	catalysts = list(/datum/reagent/nutriment = 5)
	mix_message = "The water dilutes into delicious looking milk"

/singleton/reaction/pinacolada
	name = "Pino Colada"
	result = /datum/reagent/ethanol/pinacolada
	required_reagents = list(/datum/reagent/drink/coconut/milk = 1, /datum/reagent/ethanol/rum = 2, /datum/reagent/drink/juice/pineapple = 1)
	result_amount = 4
	mix_message = "The cocktail turns a vibrant orange"

/singleton/reaction/horchata
	name = "Horchata"
	result = /datum/reagent/ethanol/horchata
	required_reagents = list(/datum/reagent/ethanol/rum = 2, /datum/reagent/drink/milk/cream = 1, /datum/reagent/cinnamon = 1, /datum/reagent/drink/syrup_vanilla = 1)
	result_amount = 5
	mix_message = "The liquid froths up into a rich, cool mixture"

/singleton/reaction/apple_soda
	name = "Apple Soda"
	result = /datum/reagent/drink/apple_soda
	required_reagents = list(/datum/reagent/drink/sodawater = 2, /datum/reagent/drink/juice/apple = 1)
	result_amount = 3
	mix_message = "The apple juice begins to fizz"

/singleton/reaction/orange_soda
	name = "Fizzy Orange"
	result = /datum/reagent/drink/orange_soda
	required_reagents = list(/datum/reagent/drink/sodawater = 2, /datum/reagent/drink/juice/orange = 1, /datum/reagent/sugar = 1)
	result_amount = 4
	mix_message = "The orange juice begins to fizz"

/singleton/reaction/pork_soda
	name = "Pork Soda"
	result = /datum/reagent/drink/porksoda
	required_reagents = list(/datum/reagent/drink/sodawater = 2, /datum/reagent/nutriment/protein = 1)
	result_amount = 3
	mix_message = "The disgusting aroma of meat and sugar fills the air"

/singleton/reaction/strawberry_soda
	name = "Strawberry Soda"
	result = /datum/reagent/drink/strawberry_soda
	required_reagents = list(/datum/reagent/drink/sodawater = 2, /datum/reagent/drink/juice/berry = 1)
	result_amount = 3
	mix_message = "The strawberry juice begins to fizz"

/singleton/reaction/vanilla_cola
	name = "Vanilla Cola"
	result = /datum/reagent/drink/vanilla_cola
	required_reagents = list(/datum/reagent/drink/space_cola = 2, /datum/reagent/drink/syrup_vanilla = 1)
	result_amount = 3
	mix_message = "The vanilla syrup begins to fizz"

/singleton/reaction/orange_cola
	name = "Orange Cola"
	result = /datum/reagent/drink/orange_cola
	required_reagents = list(/datum/reagent/drink/space_cola = 2, /datum/reagent/drink/juice/orange = 1)
	result_amount = 3
	mix_message = "The mixture swirls into a bright orange"

/singleton/reaction/cherry_cola
	name = "Cherry Cola"
	result = /datum/reagent/drink/cherry_cola
	required_reagents = list(/datum/reagent/drink/space_cola = 2, /datum/reagent/nutriment/cherryjelly = 1)
	result_amount = 3
	mix_message = "The mixture swirls into a deep crimson"

/singleton/reaction/coffee_cola
	name = "Coffee Cola"
	result = /datum/reagent/drink/coffee/coffee_cola
	required_reagents = list(/datum/reagent/drink/space_cola = 2, /datum/reagent/drink/coffee = 1)
	result_amount = 3
	mix_message = "The coffee and cola blend together smoothly"

/singleton/reaction/diet_cola
	name = "Diet Cola"
	result = /datum/reagent/drink/diet_cola
	required_reagents = list(/datum/reagent/drink/space_cola = 2, /datum/reagent/lipozine = 1)
	result_amount = 3
	mix_message = "The cola ceases fizzing"

/singleton/reaction/cola_float
	name = "Cola Float"
	result = /datum/reagent/drink/milkshake/float
	required_reagents = list(/datum/reagent/drink/milkshake = 2, /datum/reagent/drink/space_cola = 1)
	result_amount = 3
	mix_message = "The cola turns the milkshake a dark black colour"

/singleton/reaction/posset
	name = "Posset"
	result = /datum/reagent/ethanol/posset
	required_reagents = list(/datum/reagent/drink/milk = 2, /datum/reagent/drink/juice/lemon = 1, /datum/reagent/ethanol/ale = 1)
	result_amount = 4
	mix_message = "The milk curdles sweetly"

/singleton/reaction/posca
	name = "Posca"
	result = /datum/reagent/drink/posca
	required_reagents = list(/datum/reagent/nutriment/vinegar = 1, /datum/reagent/water = 1, /datum/reagent/drink/beastenergy = 1)
	result_amount = 3
	mix_message = "The mixture turns a dilute brown"

/singleton/reaction/alcoholfreebeer
	name = "Alcohol-Free Beer"
	result = /datum/reagent/drink/alcoholfreebeer
	required_reagents = list(/datum/reagent/ethanol/beer = 2, /datum/reagent/ethylredoxrazine = 1)
	result_amount = 3
	mix_message = "The liquid ceases bubbling"

/singleton/reaction/oldfashioned
	name = "Old Fashioned"
	result = /datum/reagent/ethanol/oldfashioned
	required_reagents = list(/datum/reagent/ethanol/whiskey = 2, /datum/reagent/sugar = 1, /datum/reagent/ethanol/herbal = 1)
	result_amount = 4

/singleton/reaction/daiquiri
	name = "Daiquiri"
	result = /datum/reagent/ethanol/daiquiri
	required_reagents = list(/datum/reagent/ethanol/rum = 2, /datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/affelerin = 1)
	result_amount = 4

/singleton/reaction/sidecar
	name = "Sidecar"
	result = /datum/reagent/ethanol/sidecar
	required_reagents = list(/datum/reagent/ethanol/cognac = 2, /datum/reagent/drink/juice/lemon = 1, /datum/reagent/ethanol/bluecuracao = 1)
	result_amount = 4

/singleton/reaction/caesar
	name = "Caesar"
	result = /datum/reagent/ethanol/caesar
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/drink/juice/tomato = 1, /datum/reagent/capsaicin = 1)
	result_amount = 4

/singleton/reaction/caipirinha
	name = "Caipirinha"
	result = /datum/reagent/ethanol/caipirinha
	required_reagents = list(/datum/reagent/ethanol/cachaca = 2, /datum/reagent/drink/juice/lime = 1, /datum/reagent/sugar = 1)
	result_amount = 4

/singleton/reaction/sangria
	name = "Sangria"
	result = /datum/reagent/ethanol/sangria
	required_reagents = list(/datum/reagent/ethanol/wine = 2, /datum/reagent/drink/juice/orange = 1)
	result_amount = 3

/singleton/reaction/baijiu
	name = "Baijiu"
	result = /datum/reagent/ethanol/baijiu
	required_reagents = list(/datum/reagent/ethanol/moonshine = 2, /datum/reagent/nutriment/rice = 1)
	result_amount = 3

/singleton/reaction/doogh
	name = "Doogh"
	result = /datum/reagent/drink/doogh
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/water = 1, /datum/reagent/nutriment/mint = 1)
	result_amount = 3
	mix_message = "The mixture becomes soft and easy to stir"

/singleton/reaction/honeywine
	name = "Honey Wine"
	result = /datum/reagent/ethanol/honeywine
	required_reagents = list(/datum/reagent/nutriment/honey = 2, /datum/reagent/ethanol/hellshenpa = 1)
	result_amount = 3

/singleton/reaction/dawa
	name = "Dawa"
	result = /datum/reagent/ethanol/dawa
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/nutriment/honey = 1, /datum/reagent/drink/juice/lime = 1 )
	result_amount = 4

/singleton/reaction/rakia
	name = "Rakia"
	result = /datum/reagent/ethanol/rakia
	required_reagents = list(/datum/reagent/ethanol/lunabrandy = 2, /datum/reagent/drink/juice/grape/green = 1)
	result_amount = 4
	catalysts = list(/datum/reagent/enzyme = 5)

/singleton/reaction/ironbru
	name = "Iron-Bru"
	result = /datum/reagent/drink/ironbru
	required_reagents = list(/datum/reagent/drink/ionbru = 2, /datum/reagent/iron = 1)
	result_amount = 3

/singleton/reaction/eggnog
	name = "Eggnog"
	result = /datum/reagent/drink/eggnog
	required_reagents = list(/datum/reagent/nutriment/protein/egg = 1, /datum/reagent/drink/milk = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/singleton/reaction/espresso
	name = "Espresso"
	result = /datum/reagent/drink/coffee/espresso
	required_reagents = list(/datum/reagent/drink/coffee = 2, /datum/reagent/water = 1)
	result_amount = 3
	minimum_temperature = 80 CELSIUS
	mix_message = "The coffee boils over into a rich, dark texture."

/singleton/reaction/americano
	name = "Americano"
	result = /datum/reagent/drink/coffee/americano
	required_reagents = list(/datum/reagent/drink/coffee/espresso = 2, /datum/reagent/water = 1)
	minimum_temperature = 50 CELSIUS
	result_amount = 3
	mix_message = "The water mixes with the coffee to dilute it."

/singleton/reaction/yuenyeung
	name = "Yuenyeung"
	result = /datum/reagent/drink/coffee/yuenyeung
	required_reagents = list(/datum/reagent/drink/coffee = 1, /datum/reagent/drink/tea = 1)
	result_amount = 2

/singleton/reaction/frappe
	name = "Iced Frappe"
	result = /datum/reagent/drink/coffee/iced/frappe
	required_reagents = list(/datum/reagent/drink/coffee/icecoffee = 3, /datum/reagent/sugar = 1)
	result_amount = 4
	minimum_temperature = (0 CELSIUS) - 100
	maximum_temperature = 0 CELSIUS
	mix_message = "The solution chills"

/singleton/reaction/carajillo
	name = "Carajillo"
	result = /datum/reagent/ethanol/coffee/carajillo
	required_reagents = list(/datum/reagent/drink/coffee = 2, /datum/reagent/ethanol/coffee/kahlua = 1)
	result_amount = 3

/singleton/reaction/capilliumate
	name = "Capilliumate"
	result =/datum/reagent/capilliumate
	result_amount = 3
	required_reagents = list(
		/datum/reagent/radium = 1,
		/datum/reagent/nutriment/protein = 1,
		/datum/reagent/mutagen = 1
	)
	mix_message = "The solution bubbles and thickens into strands."

/singleton/reaction/hair_dye
	name = "Hair Dye"
	result = /datum/reagent/hair_dye
	result_amount = 2
	required_reagents = list(
		/datum/reagent/enzyme = 1,
		/datum/reagent/ammonia = 1
	)

/singleton/reaction/colored_hair_dye/red
	name = "Red Hair Dye"
	result = /datum/reagent/colored_hair_dye/red
	result_amount = 1
	required_reagents = list(
		/datum/reagent/hair_dye = 1,
		/datum/reagent/crayon_dust/red = 1
	)

/singleton/reaction/colored_hair_dye/orange
	name = "Orange Hair Dye"
	result = /datum/reagent/colored_hair_dye/orange
	result_amount = 1
	required_reagents = list(
		/datum/reagent/hair_dye = 1,
		/datum/reagent/crayon_dust/orange = 1
	)

/singleton/reaction/colored_hair_dye/yellow
	name = "Yellow Hair Dye"
	result = /datum/reagent/colored_hair_dye/yellow
	result_amount = 1
	required_reagents = list(
		/datum/reagent/hair_dye = 1,
		/datum/reagent/crayon_dust/yellow = 1
	)

/singleton/reaction/colored_hair_dye/green
	name = "Green Hair Dye"
	result = /datum/reagent/colored_hair_dye/green
	result_amount = 1
	required_reagents = list(
		/datum/reagent/hair_dye = 1,
		/datum/reagent/crayon_dust/green = 1
	)

/singleton/reaction/colored_hair_dye/blue
	name = "Blue Hair Dye"
	result = /datum/reagent/colored_hair_dye/blue
	result_amount = 1
	required_reagents = list(
		/datum/reagent/hair_dye = 1,
		/datum/reagent/crayon_dust/blue = 1
	)

/singleton/reaction/colored_hair_dye/purple
	name = "Purple Hair Dye"
	result = /datum/reagent/colored_hair_dye/purple
	result_amount = 1
	required_reagents = list(
		/datum/reagent/hair_dye = 1,
		/datum/reagent/crayon_dust/purple = 1
	)

/singleton/reaction/colored_hair_dye/grey
	name = "Grey Hair Dye"
	result = /datum/reagent/colored_hair_dye/grey
	result_amount = 1
	required_reagents = list(
		/datum/reagent/hair_dye = 1,
		/datum/reagent/crayon_dust/grey = 1
	)

/singleton/reaction/colored_hair_dye/brown
	name = "Brown Hair Dye"
	result = /datum/reagent/colored_hair_dye/brown
	result_amount = 1
	required_reagents = list(
		/datum/reagent/hair_dye = 1,
		/datum/reagent/crayon_dust/brown = 1
	)

/singleton/reaction/colored_hair_dye/black
	name = "Black Hair Dye"
	result = /datum/reagent/colored_hair_dye/black
	result_amount = 3
	required_reagents = list(
		/datum/reagent/colored_hair_dye/red = 1,
		/datum/reagent/colored_hair_dye/blue = 1,
		/datum/reagent/colored_hair_dye/yellow = 1
	)

/singleton/reaction/colored_hair_dye/chaos
	name = "Chaos Hair Dye"
	result = /datum/reagent/colored_hair_dye/chaos
	result_amount = 2
	required_reagents = list(
		/datum/reagent/hair_dye = 1,
		/datum/reagent/mutagen = 1
	)

/singleton/reaction/colored_hair_dye/light_brown
	name = "Light Brown Hair Dye"
	result = /datum/reagent/colored_hair_dye/light_brown
	result_amount = 1
	required_reagents = list(
		/datum/reagent/colored_hair_dye/brown = 1
	)
	catalysts = list(
		/datum/reagent/enzyme = 1
	)

/singleton/reaction/colored_hair_dye/white
	name = "White Hair Dye"
	result = /datum/reagent/colored_hair_dye/white
	result_amount = 1
	required_reagents = list(
		/datum/reagent/colored_hair_dye/grey = 1
	)
	catalysts = list(
		/datum/reagent/enzyme = 1
	)

/singleton/reaction/potash
	name = "Potassium Nitrate"
	result = /datum/reagent/toxin/fertilizer/potash
	required_reagents = list(/datum/reagent/acetone = 3, /datum/reagent/potassium = 1, /datum/reagent/fuel = 1)
	result_amount = 3
	minimum_temperature = 200 CELSIUS
	mix_message = "The mixture solidifies into a salt-like substance."
