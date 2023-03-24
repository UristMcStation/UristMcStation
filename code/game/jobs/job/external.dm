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
	outfit_type = /singleton/hierarchy/outfit/job/merchant
	access = list(access_merchant)
	alt_titles = list(
	"Trader" = /singleton/hierarchy/outfit/job/trader)

/singleton/hierarchy/outfit/job/merchant
	name = OUTFIT_JOB_NAME("Merchant")
	uniform = /obj/item/clothing/under/color/black
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/modular_computer/pda
	id_types = list(/obj/item/card/id/merchant)

/singleton/hierarchy/outfit/job/trader
	name = OUTFIT_JOB_NAME("Trader")
	uniform = /obj/item/clothing/under/urist/terran/trader
	suit = /obj/item/clothing/suit/urist/terran/trader
	head = /obj/item/clothing/head/urist/terran/trader
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/modular_computer/pda
	id_types = list(/obj/item/card/id/merchant)

/obj/item/card/id/merchant
	desc = "An identification card issued to Merchants, indicating their right to sell and buy goods."
	icon_state = "trader"
	job_access_type = /datum/job/merchant
