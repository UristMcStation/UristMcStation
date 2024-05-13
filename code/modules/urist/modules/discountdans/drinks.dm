/obj/item/reagent_containers/food/drinks/cans/dd_koala
	// Discount cola
	name = "space cola"
	desc = "Discount Dan's Koala, same great flavour, zero trademark infringement. Extra carbonated."
	icon_state = "cola"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/cans/dd_koala/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/space_cola, 20)

	var/free_volume = 10

	if(prob(50))
		// Putting the 'coal' in cola.
		var/add_volume = rand(1, 5)
		if(add_volume)
			reagents.add_reagent(/datum/reagent/carbon, add_volume)
			free_volume -= add_volume

	if(prob(50))
			// Colas are normally made with phosphoric acid flavoring, but why use acid if pure phosphorus do trick?
		var/add_volume = rand(1, 5)
		if(add_volume)
			reagents.add_reagent(/datum/reagent/phosphorus, add_volume)
			free_volume -= add_volume

	if(prob(50))
		// Tar
		var/add_volume = rand(1, 5)
		if(add_volume)
			reagents.add_reagent(/datum/reagent/toxin/tar, add_volume)
			free_volume -= add_volume

	if(free_volume)
		reagents.add_reagent(/datum/reagent/drink/space_cola, free_volume)
		free_volume = 0

	return


/obj/item/reagent_containers/food/drinks/cans/dd_ironbruh
	// Discount ion-brew, source of iron (because girders) and, unreliably, fuel/hydrazine (to melt the steel beams).
	name = "iron-bruh"
	desc = "Discount Dan's Iron-Bruh. Girder flavored."
	icon_state = "ionbru"
	center_of_mass = "x=16;y=6"

/obj/item/reagent_containers/food/drinks/cans/dd_ironbruh/Initialize()
	. = . = ..()
	reagents.add_reagent(/datum/reagent/drink/ionbru, 20)

	var/iron_amt = rand(1, 9)
	reagents.add_reagent(/datum/reagent/iron, iron_amt)

	var/fuel_amt = 10 - iron_amt

	if(fuel_amt > 0)
		// Either fuel or hydrazine (rocket fuel)
		if(prob(80))
			reagents.add_reagent(/datum/reagent/fuel, fuel_amt)
		else
			reagents.add_reagent(/datum/reagent/hydrazine, fuel_amt)

	return


/obj/item/reagent_containers/food/drinks/cans/dd_drpepe
	// An absolute hot mess; what a snake-oil salesman would create a proto-cola syrup out of.
	// A versatile ghetto source of basic chems, but in fairly low and unpredictable amounts.
	name = "doctor Pepe"
	desc = "One of the products that launched Discount Dan's empire, this once-purported 'health tonic' eventually found popularity as a soft drink despite its indescribably medicinal flavor."
	icon_state = "dr_gibb"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/cans/dd_drpepe/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/dr_gibb, 22)

	var/free_volume = 10

	var/list/potential_ingredients = list(
		/datum/reagent/drink/dr_gibb,
		/datum/reagent/sugar,
		/datum/reagent/nutriment/glucose,
		/datum/reagent/blackpepper,
		/datum/reagent/toxin/chlorine,
		/datum/reagent/mercury,
		/datum/reagent/lithium,
		/datum/reagent/radium,
		/datum/reagent/ammonia
	)

	while(free_volume > 0)
		var/reagent_to_add = pick(potential_ingredients)
		var/add_volume = 0.5 + rand() // floor is 0.5 to keep it from taking too long
		reagents.add_reagent(reagent_to_add,  min(add_volume, free_volume))
		free_volume -= add_volume

	return


/obj/item/reagent_containers/food/drinks/cans/dd_sodawater
	name = "sodium water"
	desc = "A can of Discount Dan's Sodium Water, a valiant attempt to enter the mineral water market. Sparkling and slightly metallic."
	icon_state = "sodawater"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/cans/sodawater/Initialize()
	. = ..()
	var/total_vol = 30
	var/metal_amt = rand(1, (total_vol / 6))
	var/water_vol = total_vol - metal_amt

	reagents.add_reagent(/datum/reagent/drink/sodawater, water_vol)

	var/sodium_amt = rand(1, metal_amt) // will always have at least SOME sodium. Dan has a zero-telerance policy on false advertisement.
	var/potassium_amt = metal_amt - sodium_amt

	// Do not ask how these don't react with water.
	// The Dan side is a pathway to many abilities some consider to be... unnatural.
	if(sodium_amt)
		reagents.add_reagent(/datum/reagent/sodium, sodium_amt)

	if(potassium_amt)
		reagents.add_reagent(/datum/reagent/potassium, potassium_amt)

	return


/obj/item/reagent_containers/food/drinks/cans/dd_beer
	// Discount beer, potential source of aluminium, sulfur, moonshine and surfactant
	name = "space brew"
	desc = "Discount Dan's 'Beer'. Comes in a very, very recycled aluminum can, most definitely for environment's sake."
	icon_state = "beercan"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/cans/dd_beer/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/beer/discountdans, 20)

	var/free_volume = 10

	if(prob(30))
		// From sterilization process
		var/add_volume = rand() * 2
		if(add_volume)
			reagents.add_reagent(/datum/reagent/sulfur, add_volume)
			free_volume -= add_volume

	if(prob(50))
		// Leaching from the cheap can
		var/add_volume = max(0, free_volume * rand())
		if(add_volume)
			reagents.add_reagent(/datum/reagent/aluminium, add_volume)
			free_volume -= add_volume

	if(free_volume)
		// top up
		reagents.add_reagent(/datum/reagent/ethanol/beer/discountdans, free_volume)
		free_volume = 0

	return


/obj/item/reagent_containers/food/drinks/bottle/dd_wine
	name = "carton of Discount Dan's Alcoholique Grape Beverage"
	desc = "Discount Dan's Alcoholique Grape Beverage. Not boxed wine, technically speaking!"
	icon_state = "thoom"
	item_state = "carton"
	center_of_mass = "x=16;y=8"
	can_shatter = FALSE


/obj/item/reagent_containers/food/drinks/bottle/dd_wine/Initialize()
	. = ..()

	var/total_volume = 50
	var/oxidation = rand(0, (total_volume / 10))
	var/wine_amt = total_volume - oxidation

	reagents.add_reagent(/datum/reagent/ethanol/wine/discountdans, wine_amt)

	if(oxidation)
		// Poorly sealed containers, starts to go sour
		reagents.add_reagent(/datum/reagent/nutriment/vinegar, oxidation)

	return
