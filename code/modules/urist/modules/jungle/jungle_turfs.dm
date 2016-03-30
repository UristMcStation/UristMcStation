/turf/simulated/jungle
	var/bushes_spawn = 1
	var/plants_spawn = 1
	var/small_trees = 1
	var/large_trees_low = 0
	var/large_trees_high = 0
	var/reeds_spawn = 0
	name = "wet grass"
	desc = "Thick, long wet grass"
	icon = 'icons/jungle.dmi'
	icon_state = "grass1"
//	var/icon_spawn_state = "grass1"
//	luminosity = 3
	var/farmed = 0

/turf/simulated/jungle/New()
//	icon_state = icon_spawn_state

	if(plants_spawn && prob(40))
		if(prob(90))
			var/image/I
			if(prob(35))
				I = image('icons/jungle.dmi',"plant[rand(1,7)]")
			else
				if(prob(30))
					I = image('icons/obj/flora/ausflora.dmi',"reedbush_[rand(1,4)]")
				else if(prob(33))
					I = image('icons/obj/flora/ausflora.dmi',"leafybush_[rand(1,3)]")
				else if(prob(50))
					I = image('icons/obj/flora/ausflora.dmi',"fernybush_[rand(1,3)]")
				else
					I = image('icons/obj/flora/ausflora.dmi',"stalkybush_[rand(1,3)]")
			I.pixel_x = rand(-6,6)
			I.pixel_y = rand(-6,6)
			overlays += I
		else
			var/obj/structure/jungle_plant/J = new(src)
			J.pixel_x = rand(-6,6)
			J.pixel_y = rand(-6,6)
	if(bushes_spawn && prob(80))
		new /obj/structure/bush(src)
	if(small_trees && prob(10)) //one in four give or take, we'll see how that goes. //IT WENT TERRIBLY
		new /obj/structure/flora/tree/jungle/small(src)
	if(large_trees_low && prob(1))
		new /obj/structure/flora/tree/jungle/large(src)
	if(large_trees_high && prob(5)) //1 in ten? //noooooope
		new /obj/structure/flora/tree/jungle/large(src)
	if(reeds_spawn && prob(10))
		new /obj/structure/flora/reeds(src)

/turf/simulated/jungle/ex_act(severity)
	return

/turf/simulated/jungle/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/weapon/shovel && !farmed))
		new /obj/machinery/portable_atmospherics/hydroponics/soil(src.loc)

		user.visible_message("<span class='notice'>[user] digs up some soil and prepare the ground for planting.</span>", \
		"<span class='notice'>You dig up some soil and prepare the ground for planting.</span>")
		src.farmed = 1

/turf/simulated/jungle/med
	large_trees_low = 1
	icon_state = "grass1" //4
//	icon_spawn_state = "grass1"

/turf/simulated/jungle/thick
	large_trees_high = 1
	icon_state = "grass1" //3
//	icon_spawn_state = "grass1"

/turf/simulated/jungle/clear
	bushes_spawn = 0
	plants_spawn = 0
	small_trees = 0
	icon_state = "grass3" //clear
//	icon_spawn_state = "grass3"

/turf/simulated/jungle/clear/dark
	icon_state = "grass1" //clear
//	icon_spawn_state = "grass1"
	luminosity = 0

/turf/simulated/jungle/path
	bushes_spawn = 0
	small_trees = 0
	name = "wet grass"
	desc = "thick, long wet grass"
	icon = 'icons/jungle.dmi'
	icon_state = "grass2" //path
//	icon_spawn_state = "grass2"

/turf/simulated/jungle/path/New()
	..()
	for(var/obj/structure/bush/B in src)
		qdel(B)

/turf/simulated/jungle/proc/Spread(var/probability, var/prob_loss = 50)
	if(probability <= 0)
		return

	//world << "\blue Spread([probability])"
	for(var/turf/simulated/jungle/J in orange(1, src))
		if(!J.bushes_spawn)
			continue

		var/turf/simulated/jungle/P = null
		if(J.type == src.type)
			P = J
		else
			P = new src.type(J)

		if(P && prob(probability))
			P.Spread(probability - prob_loss)

/turf/simulated/jungle/impenetrable
	bushes_spawn = 0
	small_trees = 0
	large_trees_high = 1
	large_trees_low = 1
	icon_state = "grass1" //impenetrable
//	icon_spawn_state = "grass1"

/turf/simulated/jungle/impenetrable/New()
		..()
		var/obj/structure/bush/B = new(src)
		B.indestructable = 1

//copy paste from asteroid mineral turfs
/turf/simulated/jungle/rock
	bushes_spawn = 0
	small_trees = 0
	plants_spawn = 0
	density = 1
	opacity = 1
	name = "rock wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock"
//	icon_spawn_state = "rock"

/turf/simulated/jungle/rock/attackby()
	return

/turf/simulated/jungle/rock/New()
	spawn(1)
		var/turf/T
		if(!istype(get_step(src, NORTH), /turf/simulated/jungle/rock) && !istype(get_step(src, NORTH), /turf/unsimulated/wall))
			T = get_step(src, NORTH)
			if (T)
				T.overlays += image('icons/turf/walls.dmi', "rock_side_s")
		if(!istype(get_step(src, SOUTH), /turf/simulated/jungle/rock) && !istype(get_step(src, SOUTH), /turf/unsimulated/wall))
			T = get_step(src, SOUTH)
			if (T)
				T.overlays += image('icons/turf/walls.dmi', "rock_side_n", layer=6)
		if(!istype(get_step(src, EAST), /turf/simulated/jungle/rock) && !istype(get_step(src, EAST), /turf/unsimulated/wall))
			T = get_step(src, EAST)
			if (T)
				T.overlays += image('icons/turf/walls.dmi', "rock_side_w", layer=6)
		if(!istype(get_step(src, WEST), /turf/simulated/jungle/rock) && !istype(get_step(src, WEST), /turf/unsimulated/wall))
			T = get_step(src, WEST)
			if (T)
				T.overlays += image('icons/turf/walls.dmi', "rock_side_e", layer=6)

/turf/simulated/jungle/water
	bushes_spawn = 0
	small_trees = 0 //fucking rivers winning the small tree RNG
	plants_spawn = 0 //until I get a metric for spawning reeds only
	reeds_spawn = 1 //get dem reeds boi
	name = "murky water"
	desc = "thick, murky water"
	icon = 'icons/urist/jungle/turfs.dmi'
	icon_state = "rivernew"
//	icon_spawn_state = "rivernew"

/turf/simulated/jungle/water/attackby()
	return

/turf/simulated/jungle/water/New()
	..()
	for(var/obj/structure/bush/B in src)
		qdel(B)
	for(var/obj/structure/flora/tree/jungle/T in src) //fuck you random gen
		qdel(T)
	for(var/obj/structure/jungle_plant/J in src)
		qdel(J)

/turf/simulated/jungle/water/Entered(atom/movable/O)
	..()
	if(istype(O, /mob/living/))
		var/mob/living/M = O
		//slip in the murky water if we try to run through it
		if(prob(10 + (M.m_intent == "run" ? 40 : 0)))
			M << pick("\blue You slip on something slimy.","\blue You fall over into the murk.")
			M.Stun(2)
			M.Weaken(1)

		//piranhas - 25% chance to be an omnipresent risk, although they do practically no damage
		if(prob(25)) //however, I'm going to bump up the risk soon, and add a buildable bridge.
			M << "\blue You feel something slithering around your legs."
			spawn(rand(25,50))
				M << pick("\red Something sharp bites you!","\red Sharp teeth grab hold of you!","\red You feel something bite into your leg!")
				M.apply_damage(rand(1,3), BRUTE, sharp=1)


/turf/simulated/jungle/water/deep
	plants_spawn = 0
	density = 1
	reeds_spawn = 0 //too deep for reeds
	icon = 'icons/urist/jungle/turfs.dmi'
	icon_state = "deepnew"
//	icon_spawn_state = "deepnew"

/turf/simulated/jungle/temple_wall
	name = "temple wall"
	desc = ""
	density = 1
	icon = 'icons/turf/walls.dmi'
	icon_state = "phoron0"
	var/mineral = "phoron"

/turf/simulated/jungle/water/edge
	icon_state = "test"
//	icon_spawn_state = "


