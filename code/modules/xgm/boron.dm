//Hacky addition for Urist

/decl/xgm_gas/hydrogen/boron
	id = "boron"
	name = "Boron-11"

	molar_mass = 0.011	// kg/mol
	breathed_product = /datum/reagent/toxin/boron
	flags = XGM_GAS_FUSION_FUEL

/datum/reagent/toxin/boron
	name = "Boron"
	description = "A chemical that is highly valued in fusion energy."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#837E79"
	value = 4
	strength = 7