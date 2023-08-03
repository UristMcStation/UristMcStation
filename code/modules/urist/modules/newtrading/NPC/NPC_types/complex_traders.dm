//for traders who do something beyond the whole place item in your hand shtick

/mob/living/simple_animal/passive/npc/colonist/trader/bulky_trader
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
	interact_screen = 2

/mob/living/simple_animal/passive/npc/colonist/trader/atmos_trader
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
	interact_screen = 2

/mob/living/simple_animal/passive/npc/colonist/trader/nt_merchant
	name = "NanoTrasen Trader"
	npc_job_title = "Trader"
	desc = "A human from one of Earth's diverse cultures. They are a NanoTrasen trader, and likely sell a wide range of things."
	trade_categories_by_name = list("atmospherics","tools","bulky","medical")

	sell_modifier = 0.8
	price_modifier = 0.1
	npc_item_amount = 30
	interact_screen = 2
