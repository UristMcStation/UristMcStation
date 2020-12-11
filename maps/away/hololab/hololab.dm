#include "hololab.dm"

/obj/effect/overmap/sector/hololab
	name = "errant signal"
	desc = "garbled ghost chatter and radio messages are detected."
	icon_state = "object"

/datum/map_template/ruin/away_site/hololab
	name = "errant signal"
	id = "awaysite_hololab"
	description = "An advanced hologram research facility."
	suffixes = list("hololab/hololab.dmm")
	cost = 1

// **  HOLONAUT MOBS ** //
/mob/living/simple_animal/hostile/urist/hololab
	name = "Holo Lab hostile mob"
	desc = "You shouldn't see me, report this to an admin if you do!"
	icon = 'icons/uristmob/simple_animal.dmi'
	faction = "holonaut"
	speak = list("...?<>D-d-d-£$D<>Id it()<> work?", "I<> T-<>%$£I'm b-<C-cant feel <>ANYT-thing.</C-cant>", "?:PO$&<S-Someone...", "Three. Nine. <<><Seven-n-n-n.. One..$£% Five.")
	speak_chance = 50
	emote_hear = list("gasps suddenly", "garbles something unintelligible", "jitters audibly", "garbles some sort of radio message.")
	emote_see = list("jitters uncontrollably", "stares at their palms")
	response_help = "holds tightly"
	response_disarm = "pulls down"
	response_harm = "grasps"

/mob/living/simple_animal/hostile/urist/hololab/holonautgrunt  // Weakest Holonaut
	name = "\improper flickering figure"
	desc = "A once humanoid figure, flickering uncontrollably in and out of existence."
	icon_state = "holoman1"
	health = 100 // Less strong, as he isn't wearing anything.
	ranged = 0
	attacktext = "grasps"
	melee_damage_lower = 10
	melee_damage_upper = 20

/mob/living/simple_animal/hostile/urist/hololab/holonautregular // More dangerous holonaut, with some resistance.
	name = "\improper distorted holonaut"
	desc = "A distorted flickering humanoid, wearing a spacesuit. The limbs inside the suit seem to struggle to move."
	icon_state = "holonaut2"
	health = 150
	resistance = 15 //
	ranged = 0
	attacktext = "grasps"
	melee_damage_lower = 15
	melee_damage_upper = 25

/mob/living/simple_animal/hostile/urist/hololab/holonautexploder // These Holonauts will explode when they get close enough to a target.
	name = "\improper gesticulating Holonaut"
	desc = "A humanoid gesticulating wildly, wearing a orange spacesuit. The limbs inside seems to animate wildly, as if something were crawling inside it. It looks full of energy!"
	icon_state = "holonaut3"
	health = 50 // Weak, but dangerous up close.
	resistance = 
	ranged = 0
	attacktext = "grasps tightly"
	melee_damage_lower = 25
	melee_damage_upper = 30

// Time to write up some blow-y uppy code.

