
/mob/living/simple_animal/passive/npc/colonist/weapon_smuggler
	name = "NPC weapon smuggler"
	suits = list(\
		/obj/item/clothing/suit/leathercoat,\
		/obj/item/clothing/suit/wizrobe/gentlecoat,\
		/obj/item/clothing/suit/chaplain_hoodie\
	)
	suit_chance = 100
	hat_chance = 66
	wander = 0

/mob/living/simple_animal/passive/npc/colonist/weapon_smuggler/New()
	speech_triggers.Add(new /datum/npc_speech_trigger/smuggler_response())
	..()
