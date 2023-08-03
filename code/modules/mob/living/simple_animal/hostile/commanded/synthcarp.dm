/*/mob/living/simple_animal/hostile/commanded/synthcarp //commanded mobs are not yet integrated by bay
	name = "\improper C.A.R.P. Unit"
	desc = "A tiny synthetic carp designed for personal defense."
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "synthcarp"
	attacktext = "bites"
	health = 100
	maxHealth = 100
	natural_weapon = /obj/item/natural_weapon/bite
	response_help = "pets"

/obj/item/synthcarp
	name = "\improper inactive C.A.R.P. unit"
	desc = "An inactive synthetic carp, simply press the button and it'll register you as its master."
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "synthcarp"

/obj/item/synthcarp/attack_self(mob/user)
	var/mob/living/simple_animal/hostile/commanded/synthcarp/SC = new(get_turf(src))
	SC.master = user
	visible_message("<span class = 'notice'>\icon[src] The [src] pings as it floats out of [user]'s hands.</span>", \
					"<span class = 'notice'>\icon[src] The [src] pings as it floats out of your hands.</span>")
	if(!QDELETED(src))
		qdel(src)
*/
