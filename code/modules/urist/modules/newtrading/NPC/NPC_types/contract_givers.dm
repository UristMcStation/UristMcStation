/mob/living/simple_animal/passive/npc/colonist/contract
	angryprob = 0
	randomize_value = 0
	randomize_quantity = 0
	no_resell = 1
	interact_screen = 2
	speech_triggers = list(/datum/npc_speech_trigger/colonist/colonist_pirate, /datum/npc_speech_trigger/colonist/colonist_lactera)

//nt scientist

/mob/living/simple_animal/passive/npc/colonist/contract/ntscientist
	name = "scientist"
	npc_job_title = "NanoTrasen Chief Scientist"
	desc = "A human from one of Earth's diverse cultures. They are a Chief Scientist."
	trade_categories_by_name =  list("ntsciencecontract")
	jumpsuits = list(\
		/obj/item/clothing/under/rank/scientist/nanotrasen\
		)
	suits = list(\
		/obj/item/clothing/suit/storage/toggle/labcoat/science/nanotrasen \
	)
	suit_chance = 100
	hat_chance = 0
	glove_chance = 0

	angryprob = 0
	npc_item_amount = 5
	randomize_value = 0
	randomize_quantity = 0
	no_resell = 1
	interact_screen = 2

//nt hos

/mob/living/simple_animal/passive/npc/colonist/contract/nthos
	name = "security"
	npc_job_title = "NanoTrasen Head of Security"
	desc = "A human from one of Earth's diverse cultures. They are a Head of Security."
	trade_categories_by_name =  list("ntseccontract")
	jumpsuits = list(\
		/obj/item/clothing/under/rank/head_of_security\
		)
	suits = list(\
		/obj/item/clothing/suit/armor/hos \
	)
	hats = list(\
		/obj/item/clothing/head/HoS \
	)
	gloves = list(\
		/obj/item/clothing/gloves/thick \
	)
	suit_chance = 100
	hat_chance = 100
	glove_chance = 100

	angryprob = 0
	npc_item_amount = 4
	randomize_value = 0
	randomize_quantity = 0
	no_resell = 1
	interact_screen = 2

//nt chef

/mob/living/simple_animal/passive/npc/colonist/contract/ntchef
	name = "chef"
	npc_job_title = "NanoTrasen Head Chef"
	desc = "A human from one of Earth's diverse cultures. They are a Head Chef."
	trade_categories_by_name =  list("ntkitchencontract")
	jumpsuits = list(\
		/obj/item/clothing/under/rank/chef\
		)
	suits = list(\
		/obj/item/clothing/suit/chef \
	)
	hats = list(\
		/obj/item/clothing/head/chefhat \
	)
	suit_chance = 100
	hat_chance = 100
	glove_chance = 0

	angryprob = 0
	npc_item_amount = 4
	randomize_value = 0
	randomize_quantity = 0
	no_resell = 1
	interact_screen = 2

/mob/living/simple_animal/passive/npc/colonist/contract/terran_doctor
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

	angryprob = 0
	npc_item_amount = 1
	randomize_value = 0
	randomize_quantity = 0
	no_resell = 1
	interact_screen = 2
