/*
// Discount Dan's Beer-flavored Drink.
// Somehow both watery and oddly strong.
*/

/datum/reagent/ethanol/beer/discountdans
	name = "Discount Brew"
	description = "An alcoholic beverage made from All Natural Ingredients (TM)."
	color = "#ffe04c"
	toxicity = 1
	strength = 35 // to account for being laced with hooch

	// This is effectively a watered-down moonshine foamed up with cheap, poorly-stabilized foaming agents

	// Roughly emulating a real, low-tech distillation technique - freeze out water, concentrate alcohol, repeat.
	// In this case, the booze quality is somehow so trash it actually separates out into a film, yuck.
	chilling_products = list(
		/datum/reagent/ethanol/moonshine,
		/datum/reagent/ethanol/beer/discountdans/cold,
		/datum/reagent/ethanol/beer/discountdans/cold,
		/datum/reagent/ethanol/beer/discountdans/cold,
		/datum/reagent/drink/ice
	)
	chilling_point = -20 CELSIUS
	chilling_message = "precipitates an unpleasant slush of unctuous alcohol and ice"

	heating_products = list(
		/datum/reagent/ethanol/beer/discountdans/hot,
		/datum/reagent/ethanol/beer/discountdans/hot,
		/datum/reagent/ethanol/beer/discountdans/hot,
		/datum/reagent/surfactant
	)
	heating_point = 100 CELSIUS

	glass_desc = "A chilled container of, allegedly, beer."


/datum/reagent/ethanol/beer/discountdans/hot
	chilling_products = list(
		/datum/reagent/ethanol/beer/discountdans
	)
	chilling_point = 99 CELSIUS
	chilling_message = "stops boiling."

	heating_products = list()
	heating_point = null

	glass_desc = "A container of a boiling hot... beverage, a distinct layer of soapy bubbles separating on top."


/datum/reagent/ethanol/beer/discountdans/cold
	chilling_products = list()
	chilling_point = null

	heating_products = list(/datum/reagent/ethanol/beer/discountdans)
	heating_point = -19 CELSIUS
	heating_message = null // no message, it doesn't really do much here

	glass_desc = "A freezing container of, allegedly, beer."


/*
// Discount Dan's Alcoholique Grape Beverage.
// Essentially, what hooch is to vodka, this is to wine.
*/

/datum/reagent/ethanol/wine/discountdans
	name = "Discount Dan's Alcoholique Grape Beverage"
	description = "An alcoholic... substance, possibly made from grape juice."
	taste_description = "fruity battery acid"
	color = "#7e4062" // rgb: 126, 64, 67
	strength = 12

	glass_name = "wine?"
	glass_desc = "You could pretend this is a classy drink, provided you lost your sense of taste and smell. The sight might take care of itself in a couple of sips."

	chilling_products = list(
		/datum/reagent/ethanol/wine/discountdans/cold,
		/datum/reagent/ethanol/wine/discountdans/cold,
		/datum/reagent/ethanol/wine/discountdans/cold,
		/datum/reagent/ethanol/wine/discountdans/cold,
		/datum/reagent/ethanol/wine/discountdans/cold,
		/datum/reagent/ethanol/wine/discountdans/cold,
		// Sulfides are used to sterilize containers for winemaking, and I need a ghetto source of sulfur/sulfuric acid vOv
		/datum/reagent/sulfur,
		/datum/reagent/sulfur,
		/datum/reagent/acid
	)
	chilling_point = -20 CELSIUS
	chilling_message = "turns cloudy as yellowish precipitates form at the bottom"

	heating_products = list()
	heating_point = null
	heating_message = null


/datum/reagent/ethanol/wine/discountdans/cold
	chilling_products = list()
	chilling_point = null
	chilling_message = null

	heating_products = list(/datum/reagent/ethanol/wine/discountdans)
	heating_point = -19 CELSIUS
	heating_message = null // no message, it doesn't really do much here
