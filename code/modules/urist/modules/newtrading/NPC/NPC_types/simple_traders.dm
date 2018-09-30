//tool trader

/mob/living/simple_animal/hostile/npc/colonist/tool_trader
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

//crop trader

/mob/living/simple_animal/hostile/npc/colonist/crop_trader
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

/mob/living/simple_animal/hostile/npc/colonist/crop_trader/get_trade_value(var/obj/O)
	. = get_value(O) * 25

/mob/living/simple_animal/hostile/npc/colonist/crop_trader/player_sell(var/obj/O, var/mob/M, var/worth, var/resell = 1)
	return ..(O, M, worth, 0)


//mineral trader

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
