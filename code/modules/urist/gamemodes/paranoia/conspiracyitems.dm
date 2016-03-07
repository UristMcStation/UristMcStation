//Holds items added specifically for the Paranoia mode

//Jet Fuel: silly replacement for C4 as a proof-of-concept
/obj/item/weapon/storage/box/syndie_kit/jetfuel
	name = "jet fuel kit"
	desc = "Certified chemical demolitions kit. May or may not melt steel beams."

/obj/item/weapon/storage/box/syndie_kit/jetfuel/New()
	..()
	new /obj/item/weapon/reagent_containers/glass/beaker/vial/random/jetfuel(src)

/obj/item/weapon/reagent_containers/glass/beaker/vial/random/jetfuel
	random_reagent_list = list(
		list("fuel" = 15, "thermite" = 15)	= 9,
		list("fuel" = 30)	 = 1,) //10% chance, the mix cannot, in fact, melt steel beams.