/mob/living/simple_animal/hostile/npc/colonist/trader
	interact_screen = 2
	angryprob = 0
	speech_triggers = list(/datum/npc_speech_trigger/colonist/colonist_pirate, /datum/npc_speech_trigger/colonist/colonist_lactera)

//tool trader

/mob/living/simple_animal/hostile/npc/colonist/trader/tool_trader
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
	wander = 0
	interact_screen = 2

//crop trader

/mob/living/simple_animal/hostile/npc/colonist/trader/crop_trader
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
	wander = 0
	interact_screen = 2

/mob/living/simple_animal/hostile/npc/colonist/trader/crop_trader/get_trade_value(var/obj/O)
	. = get_value(O) * 25

/mob/living/simple_animal/hostile/npc/colonist/trader/crop_trader/player_sell(var/obj/O, var/mob/M, var/worth, var/resell = 1)
	return ..(O, M, worth, 0)


//mineral trader
/*
/mob/living/simple_animal/hostile/npc/colonist/mineral_trader
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

/mob/living/simple_animal/hostile/npc/colonist/trader/bartender_trader
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
	wander = 0

	npc_item_amount = 26
	randomize_value = 0
	price_increase = 1 //no price increase
	interact_screen = 2

//TC guy

/mob/living/simple_animal/hostile/npc/colonist/trader/terran_assistant_doctor
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
	wander = 0

	angryprob = 0
	npc_item_amount = 1
	randomize_value = 0
	randomize_quantity = 0
	no_resell = 1
	interact_screen = 2