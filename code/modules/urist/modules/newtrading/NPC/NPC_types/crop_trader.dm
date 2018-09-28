
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
