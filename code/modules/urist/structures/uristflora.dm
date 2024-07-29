// Urist Specific Flora

// Shimmering Asteroid Growths
/obj/structure/flora/shimmering_orb
	name = "bioluminescent orb"
	desc = "A floating vaguely translucent orb often found growing on clusters of asteroids, small cracks of bioluminescent growths within give off a calming light."
	icon = 'icons/urist/obj/asteroidflora.dmi'
	icon_state = "shimmering_orb"
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER

/obj/structure/flora/shimmering_orb/Initialize()
	. = ..()
	set_light(1, 3, 5, 2, "#0066ff")

// Shimmering Spawner -

/obj/effect/spawner/structure/shimmeringorb/Initialize()
	. = ..()
	if(prob(25))
		new /obj/structure/flora/shimmering_orb(loc)
	return INITIALIZE_HINT_QDEL
