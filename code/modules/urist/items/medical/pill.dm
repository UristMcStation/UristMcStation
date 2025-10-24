/obj/item/reagent_containers/pill/spacedrugs
	name = "happy pill"
	desc = "Ready to party?"
	icon_state = "pill20"

/obj/item/reagent_containers/pill/spacedrugs/New()
	..()
	reagents.add_reagent(/datum/reagent/drugs/hextro, 50)

/obj/item/reagent_containers/pill/bloodloss
	name = "Blood Restoration pill (60u)"
	desc = "Extremely strong blood restoration."
	icon_state = "pill12"

/obj/item/reagent_containers/pill/bloodloss/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment, 15)
	reagents.add_reagent(/datum/reagent/nanoblood, 15)
	reagents.add_reagent(/datum/reagent/iron, 15)
	reagents.add_reagent(/datum/reagent/sugar, 15)

/obj/item/reagent_containers/pill/peridaxon
	name = "Peridaxon (10u)"
	desc = "Regenerates internal organs and reverses organ decay."
	icon_state = "pill8"

/obj/item/reagent_containers/pill/peridaxon/New()
	..()
	reagents.add_reagent(/datum/reagent/peridaxon, 10)

/obj/item/reagent_containers/pill/rezadone
	name = "Rezadone (15u)"
	desc = "Only to be used in absolute emergencies, restores significant ceullar damage."
	icon_state = "pill18"

/obj/item/reagent_containers/pill/rezadone/New()
	..()
	reagents.add_reagent(/datum/reagent/rezadone, 15)

/obj/item/reagent_containers/pill/exspaceacillin
	name = "Spaceacillin (45u)"
	desc = "WARNING: Overdose level of spaceacillin for extreme cases of infections."
	icon_state = "pill9"

/obj/item/reagent_containers/pill/exspaceacillin/New()
	..()
	reagents.add_reagent(/datum/reagent/spaceacillin, 45)

/obj/item/reagent_containers/pill/exbicaridine
	name = "Bicaridine (45u)"
	desc = "Intended for arterial bleeding cases only."
	icon_state = "pill10"

/obj/item/reagent_containers/pill/exbicaridine/New()
	..()
	reagents.add_reagent(/datum/reagent/bicaridine, 45)

/obj/item/reagent_containers/pill/latrazine
	name = "Latrazine (5u)"
	desc = "WARNING: Unstable mixture. Do not consume under normal conditions. Only for use in critical non-compound fractures."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/latrazine/New()
	..()
	reagents.add_reagent(/datum/reagent/latrazine, 5)

/obj/item/reagent_containers/pill/clonefix
	name = "Clonefix (11u)"
	desc = "Repairs possible cloning faults to the body."
	icon_state = "pill7"

/obj/item/reagent_containers/pill/clonefix/New()
	..()
	reagents.add_reagent(/datum/reagent/alkysine, 10)
	reagents.add_reagent(/datum/reagent/ryetalyn, 1)
