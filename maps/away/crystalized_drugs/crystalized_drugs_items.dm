/obj/paint/machine_gray
	color = "#4d5968"

/obj/paint/nt_red
	color = COLOR_NT_RED

/obj/floor_decal/borderfloorbeige
	name = "border floor"
	icon_state = "borderfloor_white"
	color = COLOR_BEIGE

/obj/floor_decal/borderfloorbeige/corner
	icon_state = "borderfloorcorner_white"

/obj/floor_decal/borderfloorbeige/corner2
	icon_state = "borderfloorcorner2_white"

/obj/floor_decal/borderfloorbeige/full
	icon_state = "borderfloorfull_white"

/obj/floor_decal/borderfloorbeige/cee
	icon_state = "borderfloorcee_white"

var/global/const/access_drug_smuggler = "ACCESS_DRUG_SMUGGLER"
/datum/access/drug_smuggler
	id = access_drug_smuggler
	desc = "Bacchus Crew"
	region = ACCESS_REGION_NONE

/obj/item/card/id/drug_smuggler
	detail_color = COMMS_COLOR_SYNDICATE
	access = list(access_drug_smuggler)

/obj/machinery/button/alternate/door/bolts/pincode
	desc = "A remote control for door access. This one has a pinpad to enter some sort of code."
	var/pincode = "0451"

/obj/machinery/button/alternate/door/bolts/pincode/interface_interact(user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	var/attempt = input("Enter valid pin number to access!") as text|null
	if(attempt == pincode)
		return ..()
	else
		to_chat(user, SPAN_WARNING("Invalid code!"))

/obj/item/storage/pill_bottle/latrazine
	name = "unmarked pill bottle"
	startswith = list(/obj/item/reagent_containers/pill/latrazine = 10, /obj/item/reagent_containers/pill/happy = 4)

/obj/structure/closet/smuggler
	name = "suspicious locker"
	desc = "Rusty, greasy old locker, smelling of cigarettes and cheap alcohol."

/obj/structure/closet/smuggler/WillContain()
	return list(
		/obj/random/ammo,
		/obj/random/contraband,
		/obj/random/contraband,
		/obj/random/drinkbottle,
		/obj/random/drinkbottle,
		/obj/random/cash,
		/obj/random/cash,
		/obj/random/cash,
		/obj/random/smokes,
		new /datum/atom_creator/simple(/obj/item/reagent_containers/syringe, 50),
		new /datum/atom_creator/simple(/obj/item/reagent_containers/syringe/steroid, 10),
		new /datum/atom_creator/simple(/obj/item/reagent_containers/syringe/steroid, 10),
		new /datum/atom_creator/weighted(list(/obj/item/reagent_containers/food/drinks/cans/cola, /obj/item/reagent_containers/food/drinks/cans/waterbottle, /obj/item/reagent_containers/food/drinks/cans/dr_gibb)),
		new /datum/atom_creator/simple(/obj/item/clothing/glasses/eyepatch, 30),
		new /datum/atom_creator/simple(/obj/item/clothing/gloves/thick/duty, 80),
		new /datum/atom_creator/simple(/obj/item/clothing/mask/balaclava/tactical, 30))

/obj/random/ore
	name = "random ore"
	desc = "This is a random ore."
	icon = 'icons/obj/clothing/obj_accessories.dmi'
	icon_state = "horribletie"

/obj/random/ore_smug/spawn_choices()
	return list(
		/obj/item/ore/uranium,
		/obj/item/ore/gold,
		/obj/item/ore/silver,
		/obj/item/ore/slag,
		/obj/item/ore/phoron)

/obj/random/ammo_magazine_smug
	name = "Random Ammo Magazine"
	desc = "This is smuggler's random ammo magazine."
	icon = 'icons/obj/weapon/ammo.dmi'
	icon_state = "magnum"

/obj/random/ammo_magazine_smug/spawn_choices()
	return list(
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/speedloader,
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/rifle/military)

/obj/structure/closet/crate/plastic_smug_ammo
	name = "dirty plastic crate"
	desc = "Dirty and scrtached plastic crate."
	closet_appearance = /singleton/closet_appearance/crate/plastic

/obj/structure/closet/crate/plastic_smug_ammo/WillContain()
	return list(
		/obj/random/ammo_magazine_smug,
		/obj/random/ammo_magazine_smug,
		/obj/random/ammo_magazine_smug,
		/obj/random/ammo_magazine_smug,
		/obj/random/ammo_magazine_smug)

/obj/structure/closet/crate/plastic_smug_weapons
	name = "dirty plastic crate"
	desc = "Dirty and scrtached plastic crate."
	closet_appearance = /singleton/closet_appearance/crate/plastic

/obj/structure/closet/crate/plastic_smug_weapons/WillContain()
	return list(
		/obj/random/handgun,
		/obj/random/handgun,
		/obj/random/handgun,
		/obj/random/projectile,
		/obj/random/projectile)
