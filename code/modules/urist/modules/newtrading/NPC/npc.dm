mob/living/simple_animal/hostile/var/hiddenfaction = null

/mob/living/simple_animal/hostile/npc
	anchored = 1
	name = "NPC"
	desc = "npc"
	var/npc_job_title
	icon = 'code/modules/urist/modules/newtrading/NPC/npc.dmi'
	icon_state = "Human_m"
	speak_chance = 0
	turns_per_move = 5
	response_help = "pushes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 4
	stop_automated_movement_when_pulled = 0
	maxHealth = 100
	health = 100
	faction = "neutral"
	wander = 0
	var/list/jumpsuits = list()
	var/list/shoes = list()
	var/list/hats = list()
	var/hat_chance = 33
	var/list/gloves = list()
	var/glove_chance = 10
	var/list/suits = list()
	var/suit_chance = 25

//	unsuitable_atoms_damage = 15
//	corpse = /obj/effect/landmark/mobcorpse/pirate
	var/weapon1 = /obj/item/weapon/melee/energy/sword/pirate

	var/list/speech_triggers = list()
	var/angryspeak = 0
	var/angryprob = 0

	var/icon/interact_icon
	var/mob/interacting_mob

	var/list/trade_items = list()
	var/list/trade_items_by_type = list()
	var/list/trade_items_inventory = list()
	var/list/trade_items_inventory_by_type = list()
	var/list/trade_items_inventory_by_name = list()
	var/list/trade_categories_by_name = list()
	var/total_trade_weight = 0
	//
	var/list/interact_inventory = list()

	var/datum/controller/process/trade_controller/trade_controller_debug

	var/sell_modifier = 0.90 //how much less than the sell price will the merchants buy items from you
	var/price_increase = 1.02 //how much does the price go up after they sell an item. a value of 1 means no increase.
	var/no_resell = 0

	var/npc_item_amount = 8
	var/randomize_value = 1
	var/randomize_quantity = 1
	var/inflate_value = 0 //only use this with randomize_value = 0, otherwise it will have no effect

	var/species_type = SPECIES_HUMAN
	var/datum/species/my_species



/mob/living/simple_animal/hostile/npc/proc/can_use(var/mob/M)
	if(M.stat || M.restrained() || M.lying || !istype(M, /mob/living) || get_dist(M, src) > 1)
		return 0
	return 1

/mob/living/simple_animal/hostile/npc/death(gibbed, deathmessage = "dies!", show_dead_message)
	. = ..()

	//fall over
	src.dir = 2
	var/matrix/M = src.transform
	M.Turn(90)
	M.Translate(1,-6)
	src.transform = M