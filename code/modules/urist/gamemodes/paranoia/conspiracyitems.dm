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

/obj/item/weapon/reagent_containers/glass/beaker/vial/random/jetfuel/New()
	..()
	desc = "Contains jet fuel. Warning: results may vary!"

/obj/item/weapon/conspiracyintel
	name = "intel"
	desc = "A file containing top-secret data."
	gender = NEUTER
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "folder"
	item_state = "paper"
	throwforce = 0
	w_class = 2
	throw_range = 2
	throw_speed = 1
	layer = 4
	pressure_resistance = 1

/obj/item/weapon/conspiracyintel/New()
	..()
	var/datatype = pick("top-secret blueprints","top-secret financial records","NOC list","valuable blackmail material","top-secret access codes")
	desc = "A file containing \a [datatype]."

/obj/item/weapon/conspiracyintel/randomfaction
	var/faction

/obj/item/weapon/conspiracyintel/randomfaction/New()
	..()
	faction = pick("Buildaborg Group","Freemesons","Men in Grey","Aliuminati")

/*	icon = 'icons/obj/bureaucracy.dmi' //reenable this for faction-specific folder icons
	switch(faction)
		if("Buildaborg Group")
			icon_state = "folder_blue
		if("Freemesons")
			icon_state = "folder_red
		if("Men in Grey")
			icon_state = "folder_white
		if("Aliuminati")
			icon_state = "folder_yellow*/

	desc = "[desc] It seems to concern the assets of \the [faction]."
