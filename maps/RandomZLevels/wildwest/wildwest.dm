
//******Area******

/area/away/wildwest
	name = "\improper Wild West"
	icon_state = null
	requires_power = 0

//******Overmap and shuttle stuff******

/datum/map_template/ruin/away_site/wildwest
 	name = "Wild West"
 	spawn_weight = 0.5
 	id = "awaysite_western"
 	description = "Zombie-infested Wild West map!"
 	suffixes = list("../RandomZLevels/wildwest/wildwest.dmm")
 	cost = 2

/obj/effect/overmap/visitable/wild_west
	name = "desert planetoid"
	desc = "System scans detect an ongoing quarantine alert; caution is well advised."
	in_space = 0
	known = 0
	icon_state = "globe"
	generic_waypoints = list(
		"wild_west_1",
		"wild_west_2",
		"wild_west_3"
	)

/obj/effect/overmap/visitable/wild_west/New(nloc, max_x, max_y)
	name = "[generate_planet_name()], \a [name]"
	..()

/obj/effect/shuttle_landmark/nav_wildwest
	base_area = /area/away/wildwest
	base_turf = /turf/simulated/floor/exoplanet/desert

/obj/effect/shuttle_landmark/nav_wildwest/nav1
	name = "Desert Planetoid Landing Zone #1"
	landmark_tag = "wild_west_1"

/obj/effect/shuttle_landmark/nav_wildwest/nav2
	name = "Desert Planetoid Landing Zone #2"
	landmark_tag = "wild_west_2"

/obj/effect/shuttle_landmark/nav_wildwest/nav3
	name = "Desert Planetoid Landing Zone #3"
	landmark_tag = "wild_west_3"

//******Outfits for corpse spawners******

/obj/effect/landmark/corpse/wildwest/cowboy
	genders_per_species = list(SPECIES_HUMAN = list(MALE))
	damage = list("damage_all_brute" = 25)
	corpse_outfits = list(/singleton/hierarchy/outfit/wildwest/cowboy)

/obj/effect/landmark/corpse/wildwest/saloongirl
	genders_per_species = list(SPECIES_HUMAN = list(FEMALE))
	damage = list("damage_all_brute" = 25)
	corpse_outfits = list(/singleton/hierarchy/outfit/wildwest/saloongirl)

/obj/effect/landmark/corpse/wildwest/poncho
	genders_per_species = list(SPECIES_HUMAN = list(MALE))
	damage = list("damage_all_brute" = 25)
	corpse_outfits = list(/singleton/hierarchy/outfit/wildwest/poncho)

/obj/effect/landmark/corpse/wildwest/banker
	genders_per_species = list(SPECIES_HUMAN = list(MALE))
	damage = list("damage_all_brute" = 25)
	corpse_outfits = list(/singleton/hierarchy/outfit/wildwest/banker)

/singleton/hierarchy/outfit/wildwest/cowboy
	name = "Wild West - Cowboy"
	uniform = /obj/item/clothing/under/urist/cowboy
	shoes = /obj/item/clothing/shoes/workboots
	head = /obj/item/clothing/head/cowboy_hat
	r_hand = /obj/item/gun/projectile/revolver

/singleton/hierarchy/outfit/wildwest/saloongirl
	name = "Wild West - Saloon Girl"
	uniform = /obj/item/clothing/under/dress/dress_saloon
	shoes = /obj/item/clothing/shoes/sandal

/singleton/hierarchy/outfit/wildwest/poncho
	name = "Wild West - Poncho"
	uniform = /obj/item/clothing/under/casual_pants/classicjeans
	shoes = /obj/item/clothing/shoes/leather
	suit = /obj/item/clothing/suit/poncho/colored/green

/singleton/hierarchy/outfit/wildwest/banker
	name = "Wild West - Banker"
	uniform = /obj/item/clothing/under/gentlesuit
	shoes = /obj/item/clothing/shoes/dress
	head = /obj/item/clothing/head/bowlerhat

//******Corpse Spawners******
/*
/obj/effect/spawner/carbon/human/wildwest/cowboy
	new_gender = MALE
	clothing = /singleton/hierarchy/outfit/wildwest/cowboy
	killed = TRUE
	damage = list("damage_all_brute" = 25)

/obj/effect/spawner/carbon/human/wildwest/saloongirl
	new_gender = FEMALE
	clothing = /singleton/hierarchy/outfit/wildwest/saloongirl
	killed = TRUE
	damage = list("damage_all_brute" = 25)

/obj/effect/spawner/carbon/human/wildwest/poncho
	new_gender = MALE
	clothing = /singleton/hierarchy/outfit/wildwest/poncho
	killed = TRUE
	damage = list("damage_all_brute" = 25)

/obj/effect/spawner/carbon/human/wildwest/banker
	new_gender = MALE
	clothing = /singleton/hierarchy/outfit/wildwest/banker
	killed = TRUE
	damage = list("damage_all_brute" = 25)*/
