/mob/living/simple_animal/hostile/commanded/synthcarp
	name = "\improper C.A.R.P. Unit"
	desc = "A tiny synthetic carp designed for personal defense."
	icon_state = "synthcarp"
	attacktext = "bites"
	health = 100
	maxHealth = 100
	melee_damage_lower = 15
	melee_damage_upper = 25

	response_help = "pets"

/obj/item/synthcarp
	name = "\improper inactive C.A.R.P. unit"
	desc = "An inactive synthetic carp, simply press the button and it'll register you as it's master."
	icon = 'icons/mob/critter.dmi'
	icon_state = "synthcarp"

/obj/item/synthcarp/attack_self(var/mob/user)
	var/mob/living/simple_animal/hostile/commanded/synthcarp/SC = new(get_turf(src))
	SC.master = user
	visible_message("<span class = 'notice'>\icon[src] The [src] pings as it floats out of [user]'s hands.</span>", \
					"<span class = 'notice'>\icon[src] The [src] pings as it floats out of your hands.</span>")
	if(!QDELETED(src))
		qdel(src)