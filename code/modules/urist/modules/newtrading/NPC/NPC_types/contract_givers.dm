//nt scientist

/mob/living/simple_animal/hostile/npc/colonist/ntscientist
	name = "scientist"
	npc_job_title = "scientist"
	desc = "A human from one of Earth's diverse cultures. They are a scientist."
	trade_categories_by_name =  list("ntsciencecontract")
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

/mob/living/simple_animal/hostile/npc/colonist/terran_doctor
	name = "Chief Doctor"
	npc_job_title = "Chief Doctor"
	desc = "A human from one of Earth's diverse cultures. They are the colony's chief doctor. They look stressed and very tired."
	trade_categories_by_name =  list("tcmedcontract")
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

