/mob/living/simple_animal/passive/npc/colonist/trader
	interact_screen = 2
	angryprob = 0
	speech_triggers = list(/datum/npc_speech_trigger/colonist/colonist_pirate, /datum/npc_speech_trigger/colonist/colonist_lactera)
	hiddenfaction = /datum/factions/nanotrasen

//tool trader

/mob/living/simple_animal/passive/npc/colonist/trader/tool_trader
	name = "Tool Trader"
	npc_job_title = "Tool Trader"
	desc = "A human from one of Earth's diverse cultures. They are a trader who buys and sells tools for cash"
	trade_categories_by_name = list("tools")
	suits = list(\
		/obj/item/clothing/suit/apron/overalls\
	)
	jumpsuits = list(\
		/obj/item/clothing/under/rank/miner,\
		/obj/item/clothing/under/overalls\
		)
	hat_chance = 50
	glove_chance = 50
	interact_screen = 2

//crop trader

/mob/living/simple_animal/passive/npc/colonist/trader/crop_trader
	name = "Crop Trader"
	npc_job_title = "Crop Trader"
	desc = "A human from one of Earth's diverse cultures. They are a trader who buys crops for cash"
	trade_categories_by_name =  list("crops")
	suits = list(\
		/obj/item/clothing/suit/apron \
	)
	jumpsuits = list(\
		/obj/item/clothing/under/rank/hydroponics\
		)
	suit_chance = 100
	hat_chance = 50
	glove_chance = 50
	interact_screen = 2

/mob/living/simple_animal/passive/npc/colonist/trader/crop_trader/get_trade_value(obj/O)
	. = get_value(O) * 25

/mob/living/simple_animal/passive/npc/colonist/trader/crop_trader/player_sell(obj/O, mob/M, resell = 1)
	return ..(O, M, 0)


//mineral trader
/*
/mob/living/simple_animal/passive/npc/colonist/mineral_trader
	name = "Ore Trader"
	npc_job_title = "Ore Trader"
	desc = "A human from one of Earth's diverse cultures. They are a trader who buys and sells ore for cash"
	trade_categories_by_name = list("ore")
	suits = list(\
		/obj/item/clothing/suit/apron/overalls\
	)
	jumpsuits = list(\
		/obj/item/clothing/under/rank/miner,\
		/obj/item/clothing/under/overalls\
		)
	hat_chance = 50
	glove_chance = 50
	wander = 0
*/

//bartender

/mob/living/simple_animal/passive/npc/colonist/trader/bartender_trader
	name = "Bartender"
	npc_job_title = "Bartender"
	desc = "A human from one of Earth's diverse cultures. They are a bartender."
	trade_categories_by_name =  list("refreshments")
	jumpsuits = list(\
		/obj/item/clothing/under/rank/bartender\
		)
	suit_chance = 0
	hat_chance = 0
	glove_chance = 0

	npc_item_amount = 26
	randomize_value = 0
	price_modifier = 0 //no price increase
	interact_screen = 2

//TC guy

/mob/living/simple_animal/passive/npc/colonist/trader/terran_assistant_doctor
	name = "doctor"
	npc_job_title = "doctor"
	desc = "A human from one of Earth's diverse cultures. They are a doctor. They look stressed and very tired."
	trade_categories_by_name =  list("medical")
	jumpsuits = list(\
		/obj/item/clothing/under/rank/scientist\
		)
	suits = list(\
		/obj/item/clothing/suit/storage/toggle/labcoat/science \
	)
	suit_chance = 100
	hat_chance = 0
	glove_chance = 0

	angryprob = 0
	npc_item_amount = 1
	randomize_value = 0
	randomize_quantity = 0
	no_resell = 1
	interact_screen = 2

//organ smuggler

/mob/living/simple_animal/passive/npc/colonist/trader/organsmuggler
	name = "organ smuggler"
	npc_job_title = "organ smuggler"
	desc = "A human from one of Earth's diverse cultures. They buy and sell organs for cash."
	trade_categories_by_name =  list("organs")
	interact_screen = 2
	starting_trade_items = 10

	jumpsuits = list(\
		/obj/item/clothing/under/sterile,\
		/obj/item/clothing/under/rank/medical,\
		/obj/item/clothing/under/rank/medical/scrubs/black,\
		/obj/item/clothing/under/rank/medical/scrubs/blue,\
		/obj/item/clothing/under/rank/medical/scrubs/green,\
		/obj/item/clothing/under/rank/medical/scrubs/navyblue,\
		/obj/item/clothing/under/rank/medical/scrubs/purple)
	shoes = list(\
		/obj/item/clothing/shoes/dress,\
		/obj/item/clothing/shoes/dress/white,\
		/obj/item/clothing/shoes/workboots,\
		/obj/item/clothing/shoes/sandal,\
		/obj/item/clothing/shoes/slippers)
	glasses = list(\
		/obj/item/clothing/glasses/hud/health,\
		/obj/item/clothing/glasses/threedglasses,\
		/obj/item/clothing/glasses/science,\
		/obj/item/clothing/glasses/eyepatch,\
		/obj/item/clothing/glasses/monocle,\
		/obj/item/clothing/glasses)
	glasses_chance = 50
	suits = list(\
		/obj/item/clothing/suit/storage/det_trench,\
		/obj/item/clothing/suit/storage/det_trench/grey,\
		/obj/item/clothing/suit/storage/hazardvest/white,\
		/obj/item/clothing/suit/storage/hooded/hoodie,\
		/obj/item/clothing/suit/storage/toggle/labcoat,\
		/obj/item/clothing/suit/storage/toggle/labcoat/blue,\
		/obj/item/clothing/suit/storage/toggle/labcoat/mad,\
		/obj/item/clothing/suit/apron,\
		/obj/item/clothing/suit/surgicalapron,\
		/obj/item/clothing/suit/apron/overalls)
	suit_chance = 90
	gloves = list(/obj/item/clothing/gloves/latex, /obj/item/clothing/gloves/rainbow)
	glove_chance = 75
	hats = list(\
		/obj/item/clothing/head/boaterhat,\
		/obj/item/clothing/head/feathertrilby,\
		/obj/item/clothing/head/fedora,\
		/obj/item/clothing/head/bandana)
	hat_chance = 33
	masks = list(\
		/obj/item/clothing/mask/gas,\
		/obj/item/clothing/mask/fakemoustache,\
		/obj/item/clothing/mask/breath/medical,\
		/obj/item/clothing/mask/surgical)
	mask_chance = 50
