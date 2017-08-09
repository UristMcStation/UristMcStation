/datum/map/wyrm
	allowed_jobs = list(/datum/job/captain, /datum/job/hop,
						/datum/job/qm, /datum/job/cargo_tech,
						/datum/job/engineer,
						/datum/job/hos, /datum/job/officer,
						/datum/job/doctor,
						/datum/job/rd, /datum/job/scientist,
						/datum/job/merchant,
						/datum/job/ai, /datum/job/cyborg
						)

/datum/job/assistant
	alt_titles = list(
	"Technical Assistant","Medical Intern","Research Assistant", "Bartender", "Chef", "Janitor", "Botanist",
	"Clown" = /decl/hierarchy/outfit/job/clown,
	"Mime" = /decl/hierarchy/outfit/job/mime
	)
/datum/job/cargo_tech
	alt_titles = list("Resource Technician")

/datum/job/officer
	alt_titles = list("Detective")

/decl/hierarchy/outfit/job/mime
	name = OUTFIT_JOB_NAME("Mime")
	uniform = /obj/item/clothing/under/mime
	head = /obj/item/clothing/head/beret
	mask = /obj/item/clothing/mask/gas/mime
	gloves = /obj/item/clothing/gloves/white
	shoes = /obj/item/clothing/shoes/black
	suit = /obj/item/clothing/suit/suspenders
	pda_type = /obj/item/device/pda/mime
	id_type = /obj/item/weapon/card/id/civilian/mime

/decl/hierarchy/outfit/job/clown
	name = OUTFIT_JOB_NAME("Clown")
	uniform = /obj/item/clothing/under/rank/clown
	mask = /obj/item/clothing/mask/gas/clown_hat
	shoes = /obj/item/clothing/shoes/clown_shoes
	backpack_contents = list(/obj/item/weapon/reagent_containers/food/snacks/grown/banana = 1, /obj/item/weapon/bikehorn = 1,
		/obj/item/weapon/stamp/clown = 1, /obj/item/weapon/pen/crayon/rainbow = 1, /obj/item/weapon/storage/fancy/crayons = 1,
		/obj/item/weapon/reagent_containers/spray/waterflower = 1)
	back = /obj/item/weapon/storage/backpack/clown
	pda_type = /obj/item/device/pda/clown
	id_type = /obj/item/weapon/card/id/civilian/clown

/datum/job/merchant
	title = "Merchant"
	department = "Civilian"
	department_flag = CIV
	faction = "Station"
	total_positions = 0 //to be opened by admins when desired AT ROUNDSTART ONLY
	spawn_positions = 2
	supervisors = "the invisible hand of the market"
	selection_color = "#515151"
	ideal_character_age = 30
	minimal_player_age = 7
	create_record = 0
	outfit_type = /decl/hierarchy/outfit/job/merchant
	access = list(access_merchant)
	minimal_access = list(access_merchant)
	alt_titles = list(
	"Trader" = /decl/hierarchy/outfit/job/trader)

/decl/hierarchy/outfit/job/merchant
	name = OUTFIT_JOB_NAME("Merchant")
	uniform = /obj/item/clothing/under/color/black
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/device/pda
	id_type = /obj/item/weapon/card/id/merchant

/decl/hierarchy/outfit/job/trader
	name = OUTFIT_JOB_NAME("Trader")
	uniform = /obj/item/clothing/under/terran/trader
	suit = /obj/item/clothing/suit/terran/trader
	head = /obj/item/clothing/head/terran/trader
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/device/pda
	id_type = /obj/item/weapon/card/id/merchant

/obj/item/weapon/card/id/civilian/clown
	name = "identification card"
	desc = "A card issued to the ship's clown."
	icon_state = "clown"
	job_access_type = /datum/job/assistant

/obj/item/weapon/card/id/civilian/mime
	name = "identification card"
	desc = "A card issued to the ship's mime."
	icon_state = "mime"
	job_access_type = /datum/job/assistant

/obj/item/weapon/card/id/merchant
	desc = "An identification card issued to Merchants, indicating their right to sell and buy goods."
	icon_state = "trader"
	job_access_type = /datum/job/merchant