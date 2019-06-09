/datum/job/submap/lost_pirate
	title = "Hijacker"
	supervisors = "whatever's left of your conscience"
	total_positions = 3
	outfit_type = /decl/hierarchy/outfit/pirate_hijacker
	info = "You've recently become part of a small scale hijacking operation in the outer ring. The last job you did with your team was taking over this small exploration ship for the purposes of refitting it for combat, \
			however, your shift is long past due and nobody seems to have woken you up."

/obj/effect/submap_landmark/spawnpoint/hijacker
	name = "Hijacker"

/decl/hierarchy/outfit/pirate_hijacker
	name = "Hijacker Crew"
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/armor/pcarrier/light/hijacker
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/mask/bandana/red
	id = /obj/item/weapon/card/id/noctis
	flags = OUTFIT_HAS_BACKPACK

/obj/item/clothing/suit/armor/pcarrier/light/hijacker
	color = "#ff0000"

/var/const/access_noctis = 850
/datum/access/noctis
	id = access_noctis
	desc = "Explorer Crew"
	region = ACCESS_REGION_NONE

/obj/item/weapon/card/id/noctis
	access = list(access_noctis, access_merchant)

/obj/effect/spawner/carbon/human/freightercap
	hair_style = "Buzzcut 2"
	facial_hair = "5 O'clock Shadow"
	clothing = /decl/hierarchy/outfit/freightercap
	damage = list(BP_HEAD = 27, BP_CHEST = 53, "impale" = TRUE)
	killed = TRUE

/decl/hierarchy/outfit/freightercap
	name = "Freighter Captain"
	uniform = /obj/item/clothing/under/shorts/jeans/grey
	suit = /obj/item/clothing/suit/armor/vest/jacket
	shoes = /obj/item/clothing/shoes/workboots
	head = /obj/item/clothing/head/beret/solgov/customs
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar
	r_pocket = /obj/item/weapon/flame/lighter/zippo