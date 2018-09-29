//adding shit here later

/mob/living/simple_animal/hostile/npc/colonist/tool_trader
	name = "Tool Trader"
	npc_job_title = "Tool Trader"
	desc = "A human from one of Earth's diverse cultures. This NPC buys and sells tools for cash" //fix
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