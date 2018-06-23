/mob/living/simple_animal/hostile/smshard
	name = "shard of supermatter"
	desc = "A floating, iridescent shard of a supermatter."
	icon = 'icons/mob/critter.dmi'
	icon_state = "smshard"
	icon_living = "smshard"
	pass_flags = PASS_FLAG_TABLE
	health = 300
	maxHealth = 300
	melee_damage_lower = 30
	melee_damage_upper = 35
	damage_type = BURN
	attacktext = "carbonized"
	min_gas = null
	max_gas = null
	minbodytemp = 0

/mob/living/simple_animal/hostile/smshard/death(gibbed, deathmessage, show_dead_message)
	..(null,"explodes into dust!", show_dead_message)
	new /obj/item/researchshard(loc)
	qdel(src)

/obj/item/researchshard
	name = "supermatter dust"
	desc = "This looks like the opposite of safe."
	icon = 'icons/urist/items/misc.dmi'
	icon_state = "smdust"
	origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 5, TECH_POWER = 7)