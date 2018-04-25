/datum/job/merchant
	title = "Merchant"
	department = "Civilian"
	department_flag = CIV
	total_positions = 0 //to be opened by admins when desired AT ROUNDSTART ONLY
	spawn_positions = 0
	supervisors = "the invisible hand of the market"
	selection_color = "#515151"
	ideal_character_age = 30
	minimal_player_age = 7
	create_record = 0
	latejoin_at_spawnpoints = 1
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
	pda_type = /obj/item/modular_computer/pda
	id_type = /obj/item/weapon/card/id/merchant

/decl/hierarchy/outfit/job/trader
	name = OUTFIT_JOB_NAME("Trader")
	uniform = /obj/item/clothing/under/terran/trader
	suit = /obj/item/clothing/suit/terran/trader
	head = /obj/item/clothing/head/terran/trader
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/modular_computer/pda
	id_type = /obj/item/weapon/card/id/merchant

/obj/item/weapon/card/id/merchant
	desc = "An identification card issued to Merchants, indicating their right to sell and buy goods."
	icon_state = "trader"
	job_access_type = /datum/job/merchant
