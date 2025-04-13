/*										*****Goonstation Related Animal Ports*****

Credits to Goonstation - https://github.com/goonstation/goonstation  for all of the following mobs that use code/icons, etc. - Y

*/

/mob/living/simple_animal/hostile/man_eater
	name = "maneating plant"
	desc = "A large green plant, IT HUNGERS!"
	icon = 'icons/uristmob/goonstation_mobs.dmi'
	icon_state = "maneater"
	icon_living = "maneater"
	icon_dead = "maneater_dead"
	speak_emote = list("shouts")
	response_help = "hungrily hugs"
	response_disarm = "swipes"
	response_harm = "chomps"
	health = 200
	maxHealth = 250
	natural_weapon = /obj/item/natural_weapon/bite/immense
	pass_flags = PASS_FLAG_TABLE
	faction = "maneater"
	attacktext = "chomps"
	say_list_type = /datum/say_list/man_eater
	ai_holder = /datum/ai_holder/simple_animal/man_eater

/datum/say_list/man_eater
	speak = list("BEWARE, I LIVE!","RUN COWARD!", "I HUNGER!", "RAAAAAAAAAAARGH!!")
/datum/ai_holder/simple_animal/man_eater
	speak_chance = 40
