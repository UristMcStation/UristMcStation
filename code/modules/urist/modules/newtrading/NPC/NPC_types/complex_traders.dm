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

/mob/living/simple_animal/hostile/npc/colonist/bulky_trader/GiveItem(/datum/trade_item/D, /mob/M)
		//create the object and pass it over
		var/obj/O = new D.item_type(M.loc)

		//tell the user
		M.visible_message("<span class='info'>[M] exchanges items with [src]</span>",\
			"<span class='info'>You split off cR-[D.value] to [src] who pulls out [O] and places it in front of you.</span>") //out of where? fuck knows.

		//update the inventory
		D.quantity -= 1
		D.value = round(D.value * 1.05)		//price goes up a little
		update_trade_item_ui(D)

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

/mob/living/simple_animal/hostile/npc/colonist/atmos_trader/GiveItem(/datum/trade_item/D, /mob/M)
		//create the object and pass it over
		var/obj/O = new D.item_type(M.loc)

		//tell the user
		M.visible_message("<span class='info'>[M] exchanges items with [src]</span>",\
			"<span class='info'>You split off cR-[D.value] to [src] who pulls out [O] and places it in front of you.</span>") //out of where? fuck knows.

		//update the inventory
		D.quantity -= 1
		D.value = round(D.value * 1.05)		//price goes up a little
		update_trade_item_ui(D)