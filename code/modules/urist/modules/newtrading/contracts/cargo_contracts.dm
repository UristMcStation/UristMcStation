//this type of contract has to do with shipping stuff. it's handled in the supply subsystem along with the other newtrading stuff
//this will need a balance pass

/datum/contract/cargo
	var/list/wanted_types //types of items accepted for the contract
	faction = /datum/factions/nanotrasen
	rep_points = 1

/datum/contract/cargo/New()
	..()
	money = (amount * money)

//slime extracts

/datum/contract/cargo/slime
	name = "Slime Core Delivery Contract"
	var/slime_type

/datum/contract/cargo/slime/New()
	amount = rand(4,9)
	desc = "All of NanoTrasen's xenobiologists in this sector were killed by pirates. NanoTrasen needs the scientists of the [GLOB.using_map.station_name] to send us [amount] [slime_type] slime cores in order to progress scientific research in this sector."
	..()

/datum/contract/cargo/slime/adamantine
	slime_type = "adamantine"
	wanted_types = list(/obj/item/slime_extract/adamantine)
	money = 400

/datum/contract/cargo/slime/rainbow
	slime_type = "rainbow"
	wanted_types = list(/obj/item/slime_extract/rainbow)
	money = 400

/datum/contract/cargo/slime/oil
	slime_type = "oil"
	wanted_types = list(/obj/item/slime_extract/oil)
	money = 350

/datum/contract/cargo/slime/pyrite
	slime_type = "pyrite"
	wanted_types = list(/obj/item/slime_extract/pyrite)
	money = 350

/datum/contract/cargo/slime/cerulean
	slime_type = "cerulean"
	wanted_types = list(/obj/item/slime_extract/cerulean)
	money = 350

/datum/contract/cargo/slime/mixed
	slime_type = "yellow, orange, blue, or purple"
	wanted_types = list(/obj/item/slime_extract/yellow, /obj/item/slime_extract/orange, /obj/item/slime_extract/blue, /obj/item/slime_extract/purple)
	money = 300

/*
/datum/contract/cargo/slime/random/New()
	money = 100
	var/obj/item/slime_extract/slime1 = pick(/obj/item/slime_extract/blue, /obj/item/slime_extract/green, /obj/item/slime_extract/lightpink, /obj/item/slime_extract/yellow, /obj/item/slime_extract/orange)
	slime_type = slime1.name
	wanted_types = slime1
	..()
*/

//robotics

/datum/contract/cargo/robotics/durandparts
	name = "Durand Parts Delivery Contract"
	wanted_types = list(/obj/item/mecha_parts/part/durand_torso, /obj/item/mecha_parts/part/durand_left_arm, /obj/item/mecha_parts/part/durand_left_leg, /obj/item/mecha_parts/part/durand_right_arm, /obj/item/mecha_parts/part/durand_right_leg, /obj/item/mecha_parts/part/durand_head)
	money = 600
	rep_points = 2

/datum/contract/cargo/robotics/durandparts/New()
	amount = rand(3,6)
	desc = "Pirates hit our last shipment of high-tech mech parts, and NanoTrasen Security Forces are worried about future attacks. We need the [GLOB.using_map.station_name] to ship [amount] Durand parts at the nearest trading station, as soon as possible. Any parts will do, legs, arms, whatever, we're desparate."
	..()

/datum/contract/cargo/robotics/lasercannon
	name = "Mecha Laser Cannon Delivery Contract"
	wanted_types = list(/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy)
	money = 500

/datum/contract/cargo/robotics/lasercannon/New()
	amount = rand(2,4)
	desc = "Pirates hit our last shipment of high-tech mech parts, and NanoTrasen Security Forces are worried about future attacks. We need the [GLOB.using_map.station_name] to ship [amount] CH-LC \"Solaris\" laser cannons at the nearest trading station, as soon as possible."
	..()

//chef

/datum/contract/cargo/kitchen/aesirsalad
	name = "Aesir Salad Delivery Contract"
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/aesirsalad)
	money = 350

/datum/contract/cargo/kitchen/aesirsalad/New()
	amount = rand(6,9)
	desc = "An important dignitary is visiting our station soon, and all our chefs died of radiation poisoning after last week's supermatter explosion. We desperately need the [GLOB.using_map.station_name] to deliver us [amount] Aesir Salads, so we can impress him with our fine cuisine."
	..()

/datum/contract/cargo/kitchen/dionaroast
	name = "Diona Roast Delivery Contract"
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/dionaroast)
	money = 260

/datum/contract/cargo/kitchen/dionaroast/New()
	amount = rand(4,8)
	desc = "An important dignitary is visiting our station soon, and he has some... interesting tastes. We need the [GLOB.using_map.station_name] to deliver us [amount] Diona Roasts, so we can satiate his exotic tastes."
	..()

/datum/contract/cargo/kitchen/cubancarp
	name = "Cuban Carp Delivery Contract"
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/cubancarp)
	money = 280

/datum/contract/cargo/kitchen/cubancarp/New()
	amount = rand(3,6)
	desc = "Our Head of Security is a big fan of Cuban Carp, but it's hard to get any around here. We need the [GLOB.using_map.station_name] to deliver us [amount] servings of Cuban Carp, to stop us from going crazy after months of tofu."
	..()

/datum/contract/cargo/kitchen/coldchili
	name = "Cold Chili Delivery Contract"
	wanted_types = list(/obj/item/weapon/reagent_containers/food/snacks/coldchili)
	money = 240

/datum/contract/cargo/kitchen/coldchili/New()
	amount = rand(4,8)
	desc = "The food on this station is bland as hell, but all our chefs died of radiation poisoning after last week's supermatter explosion. If the the [GLOB.using_map.station_name] could deliver us [amount] servings of Cold Chili, it would be a lifesaver."
	..()

//stuff related to awaymissions and shipcombat mostly

/datum/contract/cargo/eswords
	name = "Energy Sword Delivery Contract"
	wanted_types = list(/obj/item/weapon/melee/energy/sword, /obj/item/weapon/melee/energy/sword/pirate)
	money = 750
	rep_points = 2

/datum/contract/cargo/eswords/New()
	amount = rand(2,4)
	desc = "Pirates have been really doing a number on our underequipped security forces lately. We need the [GLOB.using_map.station_name] to deliver NanoTrasen [amount] energy swords as soon as possible."
	..()

/datum/contract/cargo/alienguns
	name = "Lactera Weapon Delivery Contract"
	wanted_types = list(/obj/item/scom/aliengun)
	money = 850
	rep_points = 3

/datum/contract/cargo/alienguns/New()
	amount = rand(2,4)
	desc = "A specialist in Lactera technology has recently arrived in this sector. The problem is that she has nothing to research. NanoTrasen needs the [GLOB.using_map.station_name] to deliver us [amount] Lactera energy weapons, of any type."
	..()