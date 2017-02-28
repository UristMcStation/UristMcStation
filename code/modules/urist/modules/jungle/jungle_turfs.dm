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
	var/icon_spawn_state = "grass1"
//	luminosity = 3
	var/farmed = 0
	light_color = null
	light_power = 2
	light_range = 2 //for some reason, range 1 doesn't apply at all.
	var/bushspawnchance = 35 //let's try it, why not

/turf/simulated/jungle/update_air_properties() //No, you can't flood the jungle with phoron silly.
	return

/turf/simulated/jungle/New()
	if(icon_spawn_state)
		icon_state = icon_spawn_state

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
	if(reeds_spawn && prob(10))
		new /obj/structure/flora/reeds(src)
	if(bushes_spawn && prob(bushspawnchance))
		new /obj/structure/bush(src)
	else if(small_trees && prob(9)) //one in four give or take, we'll see how that goes. //IT WENT TERRIBLY
		new /obj/structure/flora/tree/jungle/small(src)
	else if(large_trees_low && prob(1))
		new /obj/structure/flora/tree/jungle/large(src)
	else if(large_trees_high && prob(4)) //1 in ten? //noooooope
		new /obj/structure/flora/tree/jungle/large(src)

	update_light()

/turf/simulated/jungle/ex_act(severity)
	return

/turf/simulated/jungle/attackby(var/obj/item/I as obj, mob/user as mob)
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

	else if(istype(I, /obj/item/stack/tile/floor_steel))
		var/obj/item/stack/tile/floor_steel/R = I
		src.overlays = null
		src.ChangeTurf(/turf/simulated/floor/plating)
		R.use(1)


/turf/simulated/jungle/med
	large_trees_low = 1
	icon_state = "grass4" //4
	icon_spawn_state = "grass1"
	bushspawnchance = 54

/turf/simulated/jungle/thick
	large_trees_high = 1
	icon_state = "grass3" //3
	icon_spawn_state = "grass1"
	bushspawnchance = 73

/turf/simulated/jungle/clear
	bushes_spawn = 0
	plants_spawn = 0
	small_trees = 0
	icon_state = "grass3" //clear
//	icon_spawn_state = "grass3"
	icon_spawn_state = null

/turf/simulated/jungle/clear/New()
	//set_light(2)

	for(var/obj/structure/bush/B in src)
		qdel(B)
	for(var/obj/structure/flora/F in src)
		qdel(F)

	update_light()

/turf/simulated/jungle/clear/grass1
	bushes_spawn = 0
	plants_spawn = 0
	small_trees = 0
	icon_state = "grass1" //clear
//	icon_spawn_state = "grass3"
	icon_spawn_state = null

/turf/simulated/jungle/clear/dark
	icon_state = "grass1" //clear
//	icon_spawn_state = "grass1"
	luminosity = 0
	icon_spawn_state = null

/turf/simulated/jungle/path
	bushes_spawn = 0
	small_trees = 0
	name = "wet grass"
	desc = "thick, long wet grass"
	icon = 'icons/jungle.dmi'
	icon_state = "grass_path" //path
	icon_spawn_state = "grass2"

/turf/simulated/jungle/path/New()
	..()
	for(var/obj/structure/bush/B in src)
		qdel(B)

/turf/simulated/jungle/proc/Spread(var/probability, var/prob_loss = 50)
	if(probability <= 0)
		return

	//world << "<span class='notice'> Spread([probability])</span>"
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
	icon_state = "grass_impenetrable" //impenetrable
	icon_spawn_state = "grass1"

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
	name = "impassable rock wall"
	desc = "A massive wall of natural rock. No point in trying to mine it, try underground."
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock"
//	icon_spawn_state = "rock"
	icon_spawn_state = null
	light_range = 0
	light_power = 0

/turf/simulated/jungle/rock/attackby()
	return

/turf/simulated/jungle/rock/New()
	spawn(1)
		var/turf/T
		if(!istype(get_step(src, NORTH), /turf/simulated/jungle/rock) && !istype(get_step(src, NORTH), /turf/unsimulated/wall))
			T = get_step(src, NORTH)
			if (T)
				T.overlays += image('icons/urist/turf/uristturf.dmi', "rock_side_s")
		if(!istype(get_step(src, SOUTH), /turf/simulated/jungle/rock) && !istype(get_step(src, SOUTH), /turf/unsimulated/wall))
			T = get_step(src, SOUTH)
			if (T)
				T.overlays += image('icons/urist/turf/uristturf.dmi', "rock_side_n", layer=6)
		if(!istype(get_step(src, EAST), /turf/simulated/jungle/rock) && !istype(get_step(src, EAST), /turf/unsimulated/wall))
			T = get_step(src, EAST)
			if (T)
				T.overlays += image('icons/urist/turf/uristturf.dmi', "rock_side_w", layer=6)
		if(!istype(get_step(src, WEST), /turf/simulated/jungle/rock) && !istype(get_step(src, WEST), /turf/unsimulated/wall))
			T = get_step(src, WEST)
			if (T)
				T.overlays += image('icons/urist/turf/uristturf.dmi', "rock_side_e", layer=6)
		update_light()

/turf/simulated/jungle/rock/weather_enable()
	return

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
	icon_spawn_state = null
	var/bridge = 0 //has there been a bridge built?
	var/fishleft = 3 //how many fish are left? todo: replenish this shit over time
	var/fishing = 0 //are we fishing


/turf/simulated/jungle/water/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/weapon/fishingrod))
		if(bridge)
			user << "<span class='notice'>There's a bridge here, try fishing somewhere else.</span>"
			return

		else if(fishleft && !fishing && !bridge)
			if(prob(1))
				user << "<span class='notice'>Cast away, it's time to catch some fucking fish, because why the fuck not.</span>"

			else
				user << "<span class='notice'>You cast your line into the water. Hold still and hopefully you can catch some fish.</span>"

			var/obj/item/weapon/fishingrod/F = I
			var/fishtime = (rand(40,140)) //test this shit
			fishtime *= F.fishingpower //here we account for using shitty improvised fishing rods, which increase the time
			fishing = 1

			if (do_after(user, fishtime, src))
				user << "<span class='notice'>You feel a tug on your line!</span>"
				src.overlays += image('icons/urist/jungle/turfs.dmi', "exclamation", layer=2.1)	//exclamation mark
				fishing = 2
				var/tempfish = fishleft
				spawn(rand(35,70))
					if(fishing && fishleft == tempfish)
						user << "<span class='notice'>Looks like it got away...</span>"
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
			else
				F = new/obj/item/fish(user.loc)
			src.overlays -= image('icons/urist/jungle/turfs.dmi', "exclamation", layer=2.1)
			fishleft -= 1
			fishing = 0
			user << "<span class='notice'>You yank on your line, pulling up [F]!</span>"

		else if(!fishleft && !bridge)
			user << "<span class='notice'>You've fished too much in this area, try fishing somewhere else.</span>"
			return

	else if(istype(I, /obj/item/stack/material/wood))
		if(!bridge)

			var/obj/item/stack/material/wood/R = I

			if(R.amount >= 3)
				user << "<span class='notice'>You build a makeshift platform to cross the river safely.</span>"
				desc = "thick murky water. There's a makeshift platform over it."
				R.use(3)
				bridge = 1
				src.overlays += image('icons/urist/jungle/turfs.dmi', "bridge", layer=2.1)
			else
				user << "<span class='notice'>You do not have enough wood to build a bridge.</span>"

	else if(istype(I, /obj/item/stack/material/r_wood))
		if(!bridge)
			var/obj/item/stack/material/r_wood/R = I

			if(R.amount >= 3)
				user << "<span class='notice'>You build a makeshift platform to cross the river safely.</span>"
				desc = "thick murky water. There's a makeshift platform over it."
				R.use(3)

				src.overlays += image('icons/urist/jungle/turfs.dmi', "bridge2", layer=2.1)
				bridge = 2
			else
				user << "<span class='notice'>You do not have enough wood to build a bridge.</span>"



	else if(istype(I, /obj/item/weapon/crowbar))
		if(bridge)
			user << "<span class='notice'>You begin to disassemble the bridge.</span>"
			spawn(rand(15,30))
				if(get_dist(user,src) < 2)
					playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)

					user << "<span class='notice'>You disassemble the bridge.</span>"

					src.overlays = null

					if(bridge == 1)
						var/obj/item/stack/material/wood/S =  new /obj/item/stack/material/wood(get_turf(src))
						S.amount = 3

					else if(bridge == 2)
						var/obj/item/stack/material/r_wood/S =  new /obj/item/stack/material/r_wood/(get_turf(src))
						S.amount = 3

					bridge = 0

	else if(istype(I, /obj/item/weapon/paddle))
		if(!bridge)
			for(var/obj/structure/raft/R in user.loc)
				if(R.built)
					user << "<span class='notice'>You stroke your paddle through the water, pulling yourself and your raft forward.</span>"
					user.loc = get_turf(src)
					R.loc = get_turf(src)

				else
					user << "<span class='notice'>You dip your paddle into the water. Okay.</span>"

	var/obj/item/weapon/reagent_containers/RG = I
	if (istype(RG) && RG.is_open_container())
		RG.reagents.add_reagent("water", min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message("<span class='notice'>[user] fills \the [RG] from the water.</span>","<span class='notice'> You fill \the [RG] from the water.</span>")
		return 1

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
	if(density) //to account for deep water
		return

	if(bridge)
		return


	else if(istype(O, /mob/living/))
		var/mob/living/M = O
		//slip in the murky water if we try to run through it
		if(prob(10 + (M.m_intent == "run" ? 40 : 0)))
			M << pick("<span class='notice'> You slip on something slimy.</span>","<span class='notice'> You fall over into the murk.</span>")
			M.Stun(2)
			M.Weaken(1)

		//piranhas - 25% chance to be an omnipresent risk, although they do practically no damage
		if(prob(25)) //however, I'm going to bump up the risk soon, and add a buildable bridge.
			M << "<span class='notice'> You feel something slithering around your legs.</span>"
			spawn(rand(25,50))
				M << pick("<span class='warning'> Something sharp bites you!</span>","<span class='warning'> Sharp teeth grab hold of you!</span>","<span class='warning'> You feel something bite into your leg!</span>")
				M.apply_damage(rand(3,5), BRUTE, sharp=1)


/turf/simulated/jungle/water/deep
	plants_spawn = 0
	density = 1
	reeds_spawn = 0 //too deep for reeds
	icon_state = "deepnew"
//	icon_spawn_state = "deepnew"

/turf/simulated/jungle/water/deep/attackby()
	return

/turf/simulated/jungle/temple_wall
	name = "temple wall"
	desc = ""
	density = 1
	icon = 'icons/turf/walls.dmi'
	icon_state = "phoron0"
	var/mineral = "phoron"

/turf/simulated/jungle/water/edge
	name = "murky water"
	desc = "thick, murky water"
	icon = 'icons/urist/jungle/turfs.dmi'
	icon_state = "test"
	icon_spawn_state = null

/turf/simulated/jungle/clear/underground
	name = "dirt"
	icon = 'icons/turf/floors.dmi'
	icon_state = "asteroid"
	light_range = 0
	light_power = 0