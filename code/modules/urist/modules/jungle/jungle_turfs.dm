/turf/simulated/floor/planet
	var/animal_spawn_chance = 0
	var/plants_spawn_chance = 0
	var/small_trees_chance = 0
	var/large_trees_chance = 0
	var/reeds_spawn_chance = 0
	var/trap_spawn_chance = 0
	name = "wet grass"
	desc = "Thick, long wet grass"
	icon = 'icons/jungle.dmi'
	icon_state = "grass1"
	dynamic_lighting = 0 //Use jungle/clear turfs for 'sunlight'
	var/icon_spawn_state = "grass1"
	var/farmed = 0
	var/bushspawnchance = 0 //let's try it, why not
	var/animal_spawn_list

/turf/simulated/floor/planet/update_air_properties() //No, you can't flood the jungle with phoron silly.
	return

/turf/simulated/floor/planet/Initialize()
	if(icon_spawn_state)
		icon_state = icon_spawn_state

	if(plants_spawn_chance && prob(plants_spawn_chance))
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
	if(reeds_spawn_chance && prob(reeds_spawn_chance))
		new /obj/structure/flora/reeds(src)
	if(bushspawnchance && prob(bushspawnchance))
		new /obj/structure/bush(src)
	if(small_trees_chance && prob(small_trees_chance)) //one in four give or take, we'll see how that goes. //IT WENT TERRIBLY
		new /obj/structure/flora/tree/jungle/small(src)
	if(large_trees_chance && prob(large_trees_chance ))
		new /obj/structure/flora/tree/jungle/large(src)
	if(animal_spawn_chance && prob(animal_spawn_chance ))
		if(prob(50)) //even 1% is a fuck ton. A 100x100 area is 10000 tiles. This means that at 1% chance, 100 animals will spawn in that area.
			var/A = pick(animal_spawn_list) //A conservative estimate for possible spawning tiles in the jungle would be 22500, which is very conservative. This means that roughly 225 animals would spawn.
			new A(get_turf(src)) //thus, we half that number, which leads to more sane numbers, and I don't have to make every spawn a fraction of 1.
	if(trap_spawn_chance)
		if(prob(1)) //The natives aren't that great
			var/obj/structure/bush/B = locate() in src
			if(B) qdel(B)
			new /obj/structure/pit/punji6/hidden/dull(src)
//	weather_enable() //Fog does some odd things with duplicating the turf, need to invesi
	. = ..()

/turf/simulated/floor/planet/ex_act(severity)
	return

/turf/simulated/floor/planet/border
	density = 1
	opacity = 1
	icon = 'icons/urist/turf/scomturfs.dmi'
	icon_state = "border"
	name = ""
	desc = ""

/turf/simulated/floor/planet/border/Bumped(M as mob)
	if (istype(M, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = M
		A.loc = get_turf(src)
	else if (istype(M, /mob/living/carbon/human/monkey))
		var/mob/living/carbon/human/monkey/A = M
		A.loc = get_turf(src)

/turf/simulated/floor/planet/attackby(var/obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/shovel))
		if(!farmed) //todo; add a way to remove the soil
			user.visible_message("<span class='notice'>[user] starts to dig up some soil and prepare the ground for planting.</span>", \
			"<span class='notice'>You start to dig up some soil and prepare the ground for planting.</span>")
			if (do_after(user, 30, src))
				new /obj/machinery/portable_atmospherics/hydroponics/soil(src)
				user.visible_message("<span class='notice'>[user] digs up some soil and prepares the ground for planting.</span>", \
				"<span class='notice'>You dig up some soil and prepares the ground for planting.</span>")
				src.farmed = 1
				src.overlays = null

		else if(farmed == 1)
			var/want = input("What would you like to do?", "Shovel", "Cancel") in list ("Cancel", "Remove the farm plot", "Dig a pit")
			switch(want)
				if("Cancel")
					return
				if("Remove the farm plot")
					user.visible_message("<span class='notice'>[user] smooths over the ground, removing the farm plot.</span>", \
					"<span class='notice'>You smooth over the ground, removing the farm plot.</span>")
					for(var/obj/machinery/portable_atmospherics/hydroponics/soil/S in src.contents)
						qdel(S)
					src.overlays += image('icons/urist/jungle/turfs.dmi', "dirt", layer=2.1)
					farmed = 0
				if("Dig a pit")
					user.visible_message("<span class='notice'>[user] starts to dig up large amounts of soil to form a pit.</span>", \
					"<span class='notice'>You start to dig up large amounts of soil to form a pit.</span>")
					if (do_after(user, 30, src))
						for(var/obj/machinery/portable_atmospherics/hydroponics/soil/S in src.contents)
							qdel(S)
						farmed = 2
						user.visible_message("<span class='notice'>[user] digs up a large amount of soil, forming a pit.</span>", \
							"<span class='notice'>You dig up even more soil, forming a pit.</span>")
						new /obj/structure/pit(src)

	else if(istype(I, /obj/item/stack/tile/floor))
		var/obj/item/stack/tile/floor/R = I
		src.overlays = null
		src.ChangeTurf(/turf/simulated/floor/plating)
		R.use(1)

/turf/simulated/floor/planet/jungle
	animal_spawn_chance = 0.75
	plants_spawn_chance = 40
	small_trees_chance = 7.5
	large_trees_chance = 0
	reeds_spawn_chance = 10
	name = "wet grass"
	desc = "Thick, long wet grass"
	icon = 'icons/jungle.dmi'
	icon_state = "grass1"
	icon_spawn_state = "grass1"
	bushspawnchance = 30 //let's try it, why not
	animal_spawn_list = list(
		/mob/living/simple_animal/hostile/huntable/deer,
		/mob/living/simple_animal/parrot/jungle,
		/mob/living/simple_animal/huntable/monkey
	)

/turf/simulated/floor/planet/jungle/med
	large_trees_chance = 1
	icon_state = "grass4" //4
	icon_spawn_state = "grass1"
	bushspawnchance = 50
	small_trees_chance = 9
	trap_spawn_chance = 1
	animal_spawn_chance = 1
	animal_spawn_list = list(
		/mob/living/simple_animal/hostile/huntable/panther,
		/mob/living/simple_animal/hostile/huntable/deer,
		/mob/living/simple_animal/parrot/jungle,
		)

/turf/simulated/floor/planet/jungle/thick
	large_trees_chance = 5
	icon_state = "grass3" //3
	icon_spawn_state = "grass1"
	bushspawnchance = 70
	plants_spawn_chance = 45
	small_trees_chance = 10
	trap_spawn_chance = 2
	animal_spawn_chance = 1.2
	animal_spawn_list = list(
		/mob/living/simple_animal/hostile/huntable/panther,
		/mob/living/simple_animal/hostile/huntable/deer,
		)

/turf/simulated/floor/planet/jungle/templatethick //for templates so trees and stuff don't get deleted.
	large_trees_chance = 2
	icon_state = "grass3" //3
	icon_spawn_state = "grass1"
	bushspawnchance = 60
	animal_spawn_chance = 1
	animal_spawn_list = list(
		/mob/living/simple_animal/hostile/huntable/panther,
		/mob/living/simple_animal/hostile/huntable/deer,
		/mob/living/simple_animal/parrot/jungle,
		/mob/living/simple_animal/huntable/monkey
		)

/turf/simulated/floor/planet/jungle/clear
	animal_spawn_chance = 0
	bushspawnchance = 0
	plants_spawn_chance = 0
	small_trees_chance = 0
	reeds_spawn_chance = 0
	icon_state = "grass3" //clear
//	icon_spawn_state = "grass3"
	icon_spawn_state = null
	dynamic_lighting = 1
	light_power = 2
	light_range = 2

/turf/simulated/floor/planet/jungle/clear/grass1
	bushspawnchance = 0
	plants_spawn_chance = 0
	small_trees_chance = 0
	icon_state = "grass1" //clear
//	icon_spawn_state = "grass3"
	icon_spawn_state = null

/turf/simulated/floor/planet/jungle/clear/dark
	icon_state = "grass1" //clear
//	icon_spawn_state = "grass1"
	luminosity = 0
	icon_spawn_state = null

/turf/simulated/floor/planet/jungle/path
	bushspawnchance = 0
	small_trees_chance = 0
	name = "wet grass"
	desc = "thick, long wet grass"
	icon = 'icons/jungle.dmi'
	icon_state = "grass_path" //path
	icon_spawn_state = "grass2"
	animal_spawn_chance = 0.2
	animal_spawn_list = list(
		/mob/living/simple_animal/parrot/jungle,
		/mob/living/simple_animal/huntable/monkey
		)

/turf/simulated/floor/planet/jungle/proc/Spread(var/probability, var/prob_loss = 50)
	if(probability <= 0)
		return

	//world << "<span class='notice'> Spread([probability])</span>"
	for(var/turf/simulated/floor/planet/jungle/J in orange(1, src))
		if(!J.bushspawnchance)
			continue

		var/turf/simulated/floor/planet/jungle/P = null
		if(J.type == src.type)
			P = J
		else
			P = new src.type(J)

		if(P && prob(probability))
			P.Spread(probability - prob_loss)

/turf/simulated/floor/planet/jungle/plains
	bushspawnchance = 0
	small_trees_chance = 0
	icon = 'icons/urist/events/train.dmi'
	icon_state = "g"
	icon_spawn_state = "g"
	animal_spawn_chance = 1.8 //hostile wasteland riddled with scrap heaps.
	animal_spawn_list = list(
		/mob/living/simple_animal/hostile/huntable/bear,
		/mob/living/simple_animal/hostile/snake
		)

/turf/simulated/floor/planet/jungle/plains/Initialize()
	if(prob(4))
		new	/obj/structure/scrap/random(src)
	else if(prob(1))
		new /obj/structure/scrap/vehicle(src)
	. = ..()

/turf/simulated/floor/planet/jungle/clear/plains
	icon = 'icons/urist/events/train.dmi'
	icon_state = "g"
	icon_spawn_state = "g"
	animal_spawn_chance = 0


/turf/simulated/floor/planet/jungle/impenetrable
	animal_spawn_chance = 0.4 //very low chances. This is mainly just to populate the respawn list
	bushspawnchance = 0
	small_trees_chance = 0
	large_trees_chance = 7
	icon_state = "grass_impenetrable" //impenetrable
	icon_spawn_state = "grass1"
	animal_spawn_list = list(
		/mob/living/simple_animal/hostile/huntable/panther,
		/mob/living/simple_animal/hostile/huntable/deer,
		/mob/living/simple_animal/parrot/jungle,
		/mob/living/simple_animal/huntable/monkey
		)

/turf/simulated/floor/planet/jungle/impenetrable/Initialize()
	var/obj/structure/bush/B = new(src)
	B.indestructable = 1
	. = ..()

//copy paste from asteroid mineral turfs
/turf/simulated/floor/planet/jungle/rock
	bushspawnchance = 0
	small_trees_chance = 0
	plants_spawn_chance = 0
	animal_spawn_chance = 0
	reeds_spawn_chance = 0
	density = 1
	opacity = 1
	name = "cliffside wall"
	desc = "A massive wall of natural rock. No point in trying to mine it, try underground."
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock"
//	icon_spawn_state = "rock"
	icon_spawn_state = null
	dynamic_lighting = 1

//Rocks fall, you die
/turf/simulated/floor/planet/jungle/rock/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/pickaxe))
		to_chat(user, "You begin to mine into the [src]..")
		if(do_after(user, 12 SECONDS))
			new /obj/structure/boulder(user.loc)
			to_chat(user, "Rocks fall, and you realize what a horrible idea this was as.")
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.adjustBruteLoss(40, 0)
			else
				user.AdjustStunned(10)
		else
			to_chat(user, "You have second thoughts about mining into a [src].")
	return

/turf/simulated/floor/planet/jungle/rock/Initialize()
	var/turf/T
	if(!istype(get_step(src, NORTH), /turf/simulated/floor/planet/jungle/rock) && !istype(get_step(src, NORTH), /turf/unsimulated/wall))
		T = get_step(src, NORTH)
		if (T)
			T.overlays += image('icons/urist/turf/uristturf.dmi', "rock_side_s")
	if(!istype(get_step(src, SOUTH), /turf/simulated/floor/planet/jungle/rock) && !istype(get_step(src, SOUTH), /turf/unsimulated/wall))
		T = get_step(src, SOUTH)
		if (T)
			T.overlays += image('icons/urist/turf/uristturf.dmi', "rock_side_n", layer=6)
	if(!istype(get_step(src, EAST), /turf/simulated/floor/planet/jungle/rock) && !istype(get_step(src, EAST), /turf/unsimulated/wall))
		T = get_step(src, EAST)
		if (T)
			T.overlays += image('icons/urist/turf/uristturf.dmi', "rock_side_w", layer=6)
	if(!istype(get_step(src, WEST), /turf/simulated/floor/planet/jungle/rock) && !istype(get_step(src, WEST), /turf/unsimulated/wall))
		T = get_step(src, WEST)
		if (T)
			T.overlays += image('icons/urist/turf/uristturf.dmi', "rock_side_e", layer=6)
	. = ..()

/turf/simulated/floor/planet/jungle/rock/weather_enable()
	return

/turf/simulated/floor/planet/jungle/water
	animal_spawn_chance = 0
	bushspawnchance = 0
	small_trees_chance = 0 //fucking rivers winning the small tree RNG
	plants_spawn_chance = 0 //until I get a metric for spawning reeds only
	reeds_spawn_chance = 15 //get dem reeds boi
	name = "murky water"
	desc = "thick, murky water"
	icon = 'icons/urist/jungle/turfs.dmi'
	icon_state = "rivernew"
//	icon_spawn_state = "rivernew"
	icon_spawn_state = null
	var/bridge = 0 //has there been a bridge built?
	var/fishleft = 3 //how many fish are left? todo: replenish this shit over time
	var/fishing = 0 //are we fishing
	var/busy = 0

/turf/simulated/floor/planet/jungle/water/Initialize()
	. = ..()
	fishleft = rand(1,6)

/turf/simulated/floor/planet/jungle/water/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/weapon/fishingrod))
		if(bridge)
			to_chat(user, "<span class='notice'>There's a bridge here, try fishing somewhere else.</span>")
			return

		else if(fishleft && !fishing && !bridge)
			if(prob(1))
				to_chat(user, "<span class='notice'>Cast away, it's time to catch some fucking fish, because why the fuck not.</span>")

			else
				to_chat(user, "<span class='notice'>You cast your line into the water. Hold still and hopefully you can catch some fish.</span>")

			var/obj/item/weapon/fishingrod/F = I
			var/fishtime = (rand(40,140)) //test this shit
			fishtime *= F.fishingpower //here we account for using shitty improvised fishing rods, which increase the time
			fishing = 1

			if (do_after(user, fishtime, src))
				to_chat(user, "<span class='notice'>You feel a tug on your line!</span>")
				src.overlays += image('icons/urist/jungle/turfs.dmi', "exclamation", layer=2.1)	//exclamation mark
				fishing = 2
				var/tempfish = fishleft
				spawn(rand(35,70))
					if(fishing && fishleft == tempfish)
						to_chat(user, "<span class='notice'>Looks like it got away...</span>")
						fishing = 0
						src.overlays -= image('icons/urist/jungle/turfs.dmi', "exclamation", layer=2.1)

		else if(fishleft && fishing == 2 && !bridge)
			var/obj/item/F

			if(prob(2))
				F = new/obj/item/weapon/storage/belt/utility(user.loc)
			else if(prob(1))
				F = new	/obj/item/weapon/beartrap(user.loc)
			else if(prob(10))
				F = new/obj/item/weapon/reagent_containers/food/drinks/cans/cola(user.loc)
			else if(prob(3))
				F = new/obj/item/clothing/suit/storage/hazardvest(user.loc)
			else if(prob(5))
				F = new/obj/item/clothing/glasses/sunglasses(user.loc)
			else if(prob(2))
				if(prob(10))
					F = new/obj/item/clothing/shoes/jackboots(user.loc)
				else
					F = new/obj/item/clothing/shoes/urist/leather(user.loc)
			else
				F = new/obj/item/fish(user.loc)

			src.overlays -= image('icons/urist/jungle/turfs.dmi', "exclamation", layer=2.1)
			fishleft -= 1
			fishing = 0
			user << "<span class='notice'>You yank on your line, pulling up [F]!</span>"

		else if(!fishleft && !bridge)
			to_chat(user, "<span class='notice'>You've fished too much in this area, try fishing somewhere else.</span>")
			return

	else if(istype(I, /obj/item/stack/material/wood))
		if(!bridge)

			var/obj/item/stack/material/wood/R = I

			if(R.amount >= 3)
				to_chat(user, "<span class='notice'>You build a makeshift platform to cross the river safely.</span>")
				desc = "thick murky water. There's a makeshift platform over it."
				R.use(3)
				bridge = 1
				src.overlays += image('icons/urist/jungle/turfs.dmi', "bridge", layer=2.1)
			else
				to_chat(user, "<span class='notice'>You do not have enough wood to build a bridge.</span>")

	else if(istype(I, /obj/item/stack/material/r_wood))
		if(!bridge)
			var/obj/item/stack/material/r_wood/R = I

			if(R.amount >= 3)
				to_chat(user, "<span class='notice'>You build a makeshift platform to cross the river safely.</span>")
				desc = "thick murky water. There's a makeshift platform over it."
				R.use(3)

				src.overlays += image('icons/urist/jungle/turfs.dmi', "bridge2", layer=2.1)
				bridge = 2
			else
				to_chat(user, "<span class='notice'>You do not have enough wood to build a bridge.</span>")

	else if(istype(I, /obj/item/weapon/paddle))
		if(!bridge)
			for(var/obj/structure/raft/R in user.loc)
				if(!busy)
					if(R.built)
						busy = 1
						to_chat(user, "<span class='notice'>You stroke your paddle through the water, pulling yourself and your raft forward.</span>")
						if (do_after(user, 5, src))

							R.do_pulling_stuff(src)

							R.loc = get_turf(src)

							if(user.pulling)

								if(user.pulling.type == /obj/structure/raft || user.pulling.type == /obj/structure/raft/built)
									var/obj/structure/raft/S = user.pulling
									if(S.built)

		//								S.forceMove(get_turf(src))
										S.do_pulling_stuff(user.loc)
										S.loc = get_turf(user)

							bridge = 1
							user.loc = get_turf(src)

							bridge = 0
							spawn(12)
								busy = 0

					else if(!R.built)
						to_chat(user, "<span class='notice'>You dip your paddle into the water. Okay.</span>")


	else if(istype(I, /obj/item/weapon/crowbar))
		if(bridge)
			to_chat(user, "<span class='notice'>You begin to disassemble the bridge.</span>")
			if (do_after(user, rand(15,30), src))
				playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)

				to_chat(user, "<span class='notice'>You disassemble the bridge.</span>")

				src.overlays = null

				if(bridge == 1)
					var/obj/item/stack/material/wood/S =  new /obj/item/stack/material/wood(get_turf(src))
					S.amount = 3

				else if(bridge == 2)
					var/obj/item/stack/material/r_wood/S =  new /obj/item/stack/material/r_wood/(get_turf(src))
					S.amount = 3

				bridge = 0

	else if(istype(I, /obj/item/stack/hide/animalhide))
		to_chat(user, "<span class='notice'>You immerse the hide in the water.</span>")
		if (do_after(user, 30, src))
			var/obj/item/stack/hide/animalhide/AH = I
			var/obj/item/stack/hide/wet/WL = new /obj/item/stack/hide/wet(src.loc)
			WL.amount = AH.amount
			user.remove_from_mob(AH)
			user.put_in_hands(WL)
			qdel(AH)

	var/obj/item/weapon/reagent_containers/RG = I
	if (istype(RG) && RG.is_open_container())
		RG.reagents.add_reagent(/datum/reagent/water, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message("<span class='notice'>[user] fills \the [RG] from the water.</span>","<span class='notice'> You fill \the [RG] from the water.</span>")
		return 1

/turf/simulated/floor/planet/jungle/water/Entered(atom/movable/O)
	..()
	if(density) //to account for deep water
		return

	else if(istype(O, /mob/living/carbon) && !bridge)
		var/mob/living/carbon/M = O
		//slip in the murky water if we try to run through it
		if(prob(10 + (M.m_intent == "run" ? 40 : 0)))
			to_chat(M, pick("<span class='notice'> You slip on something slimy.</span>","<span class='notice'> You fall over into the murk.</span>"))
			M.Stun(2)
			M.Weaken(1)

		//piranhas - 25% chance to be an omnipresent risk, although they do practically no damage
		if(prob(25)) //however, I'm going to bump up the risk soon, and add a buildable bridge.
			to_chat(M, "<span class='notice'> You feel something slithering around your legs.</span>")
			spawn(rand(25,50))
				var/zone = pick(BP_R_LEG, BP_L_LEG)
				to_chat(M, pick("<span class='warning'> Something sharp bites you!</span>","<span class='warning'> Sharp teeth grab hold of you!</span>","<span class='warning'> You feel something bite into your leg!</span>"))
				M.apply_damage(rand(3,5), BRUTE, zone, 0, DAM_SHARP)


/turf/simulated/floor/planet/jungle/water/deep
	plants_spawn_chance = 0
	density = 1
	reeds_spawn_chance = 0 //too deep for reeds
	icon_state = "deepnew"
//	icon_spawn_state = "deepnew"

/turf/simulated/floor/planet/jungle/water/deep/CanPass(atom/movable/mover, turf/target)
	if(istype(mover,/obj/item/projectile))
		return 1

	else ..()

/turf/simulated/floor/planet/jungle/water/deep/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/weapon/paddle))
		if(!bridge)
			for(var/obj/structure/raft/R in user.loc)
				if(!busy)
					if(R.built)
						busy = 1
						to_chat(user, "<span class='notice'>You stroke your paddle through the water, pulling yourself and your raft forward.</span>")
						if (do_after(user, 5, src))

							R.do_pulling_stuff(src)

							R.loc = get_turf(src)

							if(user.pulling)

								if(user.pulling.type == /obj/structure/raft || user.pulling.type == /obj/structure/raft/built)
									var/obj/structure/raft/S = user.pulling
									if(S.built)

		//								S.forceMove(get_turf(src))
										S.do_pulling_stuff(user.loc)
										S.loc = get_turf(user)

							bridge = 1
							user.loc = get_turf(src)

							bridge = 0
							spawn(12)
								busy = 0

					else if(!R.built)
						to_chat(user, "<span class='notice'>You dip your paddle into the water. Okay.</span>")
	return

/turf/simulated/floor/planet/jungle/temple_wall
	name = "temple wall"
	desc = ""
	density = 1
	icon = 'icons/turf/walls.dmi'
	icon_state = "phoron0"
	mineral = "phoron"

/turf/simulated/floor/planet/jungle/water/edge
	name = "murky water"
	desc = "thick, murky water"
	icon = 'icons/urist/jungle/turfs.dmi'
	icon_state = "test"
	icon_spawn_state = null

/turf/simulated/floor/planet/jungle/clear/underground
	name = "dirt"
	icon = 'icons/turf/floors.dmi'
	icon_state = "asteroid"
	light_range = 0
	light_power = 0

/turf/simulated/floor/planet/jungle/clear/underground/weather_enable(var/override = 0)
	if(override)
		..()