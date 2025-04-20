/datum/map_template/ruin/exoplanet/skrell_biodome
	name = "Skrellian Biodome"
	id = "skrell_biodome"
	description = "Strange round structure."
	suffixes = list("skrell_biodome/skrell_biodome.dmm")
	spawn_cost = 0.5
	apc_test_exempt_areas = list(/area/map_template/biodome/atmos = NO_SCRUBBER|NO_VENT)
	ruin_tags = RUIN_HUMAN
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS

/area/map_template/biodome/living
	name = "\improper Life support area"
	icon_state = "bridge"

/area/map_template/biodome/medbay
	name = "\improper Medical Bay"
	icon_state = "medbay"

/area/map_template/biodome/engineering
	name = "\improper Power supply area"
	icon_state = "engineering_supply"

/area/map_template/biodome/atmos
	name = "\improper Gas compartment"
	icon_state = "atmos"

// Bay accidentally coupled this template and Skrell Scout Ship, so this is a 'fork' version of scout ones

var/global/const/access_skrellbiodome = "ACCESS_SKRELLBIODOME"

/datum/access/skrell_biodome
	id = access_skrellbiodome
	desc = "Access to the Skrell Biodome"

/obj/machinery/vending/medical/skrell_biodome
	req_access = list(access_skrellbiodome)

/obj/machinery/space_heater/skrell_biodome
	color = "#40e0d0"
	name = "thermal induction generator"
	desc = "Made by Krri'gli Corp using thermal induction technology, this heater is guaranteed not to set anything, or anyone, on fire."
	set_temperature = T0C+40

/obj/machinery/alarm/skrell_biodome
	req_access = list(access_skrellbiodome)
	target_temperature = T0C+40

/obj/machinery/light/skrell_biodome
	name = "skrellian light"
	light_type = /obj/item/light/tube/skrell_biodome
	desc = "Some kind of strange alien lighting technology."

/obj/item/light/tube/skrell_biodome
	name = "skrellian light filament"
	color = LIGHT_COLOUR_SKRELL
	b_colour = LIGHT_COLOUR_SKRELL
	desc = "Some kind of strange alien lightbulb technology."
	random_tone = FALSE

/obj/item/light/tube/large/skrell_biodome
	name = "skrellian light filament"
	color = LIGHT_COLOUR_SKRELL
	b_colour = LIGHT_COLOUR_SKRELL
	desc = "Some kind of strange alien lightbulb technology."

/obj/item/tape_roll/skrell_biodome
	name = "modular adhesive dispenser"
	desc = "A roll of sticky tape. Possibly for taping ducks... or was that ducts?"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "taperoll"
	color = "#40e0d0"
	w_class = ITEM_SIZE_SMALL
