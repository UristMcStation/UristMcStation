
//******Area******

/area/away/wildwest
	name = "\improper Wild West"
	icon_state = null
	requires_power = 0

//******Overmap and shuttle stuff******

/datum/away_mission/wildwest
	map_path = "maps/RandomZlevels/wildwest/wildwest.dmm"
	value = 25
	random_start = TRUE

/obj/effect/overmap/sector/wild_west
	name = "settled desert exoplanet"
	desc = "System scans detect an ongoing quarantine alert; caution is advised."
	icon_state = "planet"
	generic_waypoints = list(
		"wild_west"
	)

/obj/effect/shuttle_landmark/wild_west
	name = "Landing Zone"
	landmark_tag = "wild_west"
	base_area = /area/away/wildwest
	base_turf = /turf/simulated/floor/exoplanet/desert

//******Outfits for corpse spawners******

/decl/hierarchy/outfit/wildwest/cowboy
	name = "Wild West - Cowboy"
	uniform = /obj/item/clothing/under/urist/cowboy
	shoes = /obj/item/clothing/shoes/workboots
	head = /obj/item/clothing/head/cowboy_hat
	r_hand = /obj/item/weapon/gun/projectile/revolver

/decl/hierarchy/outfit/wildwest/saloongirl
	name = "Wild West - Saloon Girl"
	uniform = /obj/item/clothing/under/dress/dress_saloon
	shoes = /obj/item/clothing/shoes/sandal

/decl/hierarchy/outfit/wildwest/poncho
	name = "Wild West - Poncho"
	uniform = /obj/item/clothing/under/casual_pants/classicjeans
	shoes = /obj/item/clothing/shoes/leather
	suit = /obj/item/clothing/suit/poncho/colored/green

/decl/hierarchy/outfit/wildwest/banker
	name = "Wild West - Banker"
	uniform = /obj/item/clothing/under/gentlesuit
	shoes = /obj/item/clothing/shoes/dress
	head = /obj/item/clothing/head/bowlerhat

//******Corpse Spawners******

/obj/effect/spawner/carbon/human/wildwest/cowboy
	new_gender = MALE
	clothing = /decl/hierarchy/outfit/wildwest/cowboy
	killed = TRUE
	damage = list("damage_all_brute" = 30)

/obj/effect/spawner/carbon/human/wildwest/saloongirl
	new_gender = FEMALE
	clothing = /decl/hierarchy/outfit/wildwest/saloongirl
	killed = TRUE
	damage = list("damage_all_brute" = 30)

/obj/effect/spawner/carbon/human/wildwest/poncho
	new_gender = MALE
	clothing = /decl/hierarchy/outfit/wildwest/poncho
	killed = TRUE
	damage = list("damage_all_brute" = 30)

/obj/effect/spawner/carbon/human/wildwest/banker
	new_gender = MALE
	clothing = /decl/hierarchy/outfit/wildwest/banker
	killed = TRUE
	damage = list("damage_all_brute" = 30)