//resomi / teshari blood

/obj/item/reagent_containers/ivbag/blood/teshari
	abstract_type = /obj/item/reagent_containers/ivbag/blood/teshari


/obj/item/reagent_containers/ivbag/blood/teshari/Initialize(mapload, blood_type)
	return ..(mapload, blood_type, SPECIES_RESOMI)


/obj/item/reagent_containers/ivbag/blood/teshari/apos/Initialize(mapload)
	return ..(mapload, "A+")


/obj/item/reagent_containers/ivbag/blood/teshari/aneg/Initialize(mapload)
	return ..(mapload, "A-")


/obj/item/reagent_containers/ivbag/blood/teshari/bpos/Initialize(mapload)
	return ..(mapload, "B+")


/obj/item/reagent_containers/ivbag/blood/teshari/bneg/Initialize(mapload)
	return ..(mapload, "B-")


/obj/item/reagent_containers/ivbag/blood/teshari/abpos/Initialize(mapload)
	return ..(mapload, "AB+")


/obj/item/reagent_containers/ivbag/blood/teshari/abneg/Initialize(mapload)
	return ..(mapload, "AB-")


/obj/item/reagent_containers/ivbag/blood/teshari/opos/Initialize(mapload)
	return ..(mapload, "O+")


/obj/item/reagent_containers/ivbag/blood/teshari/oneg/Initialize(mapload)
	return ..(mapload, "O-")
