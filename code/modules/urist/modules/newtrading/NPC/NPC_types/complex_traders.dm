//for traders who do something beyond the whole place item in your hand shtick

/mob/living/simple_animal/hostile/npc/colonist/bulky_trader
	name = "Large Goods Trader"
	npc_job_title = "Large Goods Trader"
	desc = "A human from one of Earth's diverse cultures. They sell all sorts of large goods, from furniture to welding fuel tanks" //fix
	trade_categories_by_name = list("bulky")
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

/mob/living/simple_animal/hostile/npc/colonist/atmos_trader
	name = "Atmospherics Supplies Trader"
	npc_job_title = "Atmospherics Supplies Trader"
	desc = "A human from one of Earth's diverse cultures. They sell all sorts of atmospherics supplies." //fix
	trade_categories_by_name = list("atmospherics")
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