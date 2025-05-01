/turf/simulated/floor/planet
	var/animal_spawn_chance = 0 //% chance to spawn animals. actual percentage is roughly divided in half bc i was an idiot 9 years ago
	var/plants_spawn_chance = 0 //%chance to spawn plants from the general plant icon database. this includes fruit bearing plants
	var/small_trees_chance = 0 //% chance to spawn small trees
	var/large_trees_chance = 0 //% chance to spawn large trees
	var/misc_plant_spawn_chance = 0 //misc plant spawn chance - this is a specifically defined type
	var/trap_spawn_chance = 0 //trap spawns??? idfk. check below for the ancient trap code
	name = "wet grass"
	desc = "Thick, long wet grass"
	icon = 'icons/jungle.dmi'
	icon_state = "grass1" //what the icon looks like when mapping/ingame if icon_spawn_state is not set
	light_power = 0.4 //these keep tiles lit. you can adjust this to make things more dim or remove lighting entirely.
	light_range = 1.5
	var/icon_spawn_state //what the icon looks like when it spawns. if this is not set it defaults to icon_state
	var/farmed = 0 //has someone tilled this soil?
	var/bushspawnchance = 0 //let's try it, why not
	var/list/animal_spawn_list //what animals types can spawn here?

	var/misc_plant_type = /obj/structure/flora/reeds
	var/bush_type = /obj/structure/bush
	var/small_tree_type = /obj/structure/flora/tree/planet/jungle/small
	var/large_tree_type = /obj/structure/flora/tree/planet/jungle/large

	var/spawn_scrap = 0

	var/planet_light = TRUE //do we use the fancy planet lighting

	var/generate_things = TRUE //do we generate things at all
	var/list/spawn_list = list()
	var/plant_overlay = FALSE //do we have an overlay for plants

/turf/simulated/floor/planet/update_air_properties() //No, you can't flood the jungle with phoron silly.
	return

/turf/simulated/floor/planet/can_engrave()
	return FALSE

/turf/simulated/floor/planet/Initialize() //oh god this sucks so fucking much. this fucking 11 year old dogshit code will be the death of me
	. = ..()
//	weather_enable() //Fog does some odd things with duplicating the turf, need to invesi //he died shortly thereafter
	if(icon_spawn_state)
		icon_state = icon_spawn_state

	if(planet_light)
		light_color = SSskybox.background_color

	if(generate_things)
		generate_planet_objects()
		return INITIALIZE_HINT_LATELOAD

/turf/simulated/floor/planet/LateInitialize(mapload)
	if(length(spawn_list))
		create_objects_in_loc(src, spawn_list)
		spawn_list = list()

/turf/simulated/floor/planet/ex_act(severity)
	return

/turf/simulated/floor/planet/on_update_icon(update_neighbors = FALSE)
	. = ..()

	if(plant_overlay)
		plant_overlay = FALSE
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
		AddOverlays(I)

/turf/simulated/floor/planet/proc/generate_planet_objects()
//	set waitfor = FALSE

	var/bushes = FALSE
	var/tree = FALSE

	if(plants_spawn_chance)
		if(prob(plants_spawn_chance)) //why were we running prob() on all of these even if they don't fucking spawn there
			if(prob(90))
				plant_overlay = TRUE
				queue_icon_update()
			else
				spawn_list.Add(/obj/structure/jungle_plant)

	if(misc_plant_spawn_chance)
		if(prob(misc_plant_spawn_chance))
			spawn_list.Add(misc_plant_type)

	if(bushspawnchance)
		if(prob(bushspawnchance))
			spawn_list.Add(bush_type)
			bushes = TRUE

	if(!bushes)
		if(small_trees_chance)
			if(prob(small_trees_chance)) //one in four give or take, we'll see how that goes. //IT WENT TERRIBLY
				spawn_list.Add(small_tree_type)
				tree = TRUE
		if(!tree && large_trees_chance)
			if(prob(large_trees_chance))
				spawn_list.Add(large_tree_type)
		if(trap_spawn_chance)
			if(prob(0.1))
				spawn_list.Add(/obj/structure/pit/punji6/hidden/dull)

	if(length(animal_spawn_list))
		if(prob(animal_spawn_chance)) //even 1% is a fuck ton. A 100x100 area is 10000 tiles. This means that at 1% chance, 100 animals will spawn in that area.
			var/A = pick(animal_spawn_list) //A conservative estimate for possible spawning tiles in the jungle would be 22500, which is very conservative. This means that roughly 225 animals would spawn.
			spawn_list.Add(A) //so set your numbers fucking low. god i hate this shit.

	if(spawn_scrap)
		if(prob(4))
			spawn_list.Add(/obj/structure/scrap/random)
		else if(prob(1))
			spawn_list.Add(/obj/structure/scrap/vehicle)

/turf/simulated/floor/planet/border
	density = TRUE
	opacity = 1
	icon = 'icons/urist/turf/scomturfs.dmi'
	icon_state = "border"
	name = ""
	desc = ""
	generate_things = FALSE

/turf/simulated/floor/planet/border/Bumped(M as mob)
	if (istype(M, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = M
		A.loc = get_turf(src)
	else if (istype(M, /mob/living/carbon/human/monkey))
		var/mob/living/carbon/human/monkey/A = M
		A.loc = get_turf(src)

	else
		..()

/turf/simulated/floor/planet/use_tool(obj/item/I, mob/living/user, list/click_params)
	if(istype(I, /obj/item/shovel))
		if(!farmed) //todo; add a way to remove the soil
			user.visible_message("<span class='notice'>[user] starts to dig up some soil and prepare the ground for planting.</span>", \
			"<span class='notice'>You start to dig up some soil and prepare the ground for planting.</span>")
			if (do_after(user, 30, src))
				new /obj/machinery/portable_atmospherics/hydroponics/soil(src)
				user.visible_message("<span class='notice'>[user] digs up some soil and prepares the ground for planting.</span>", \
				"<span class='notice'>You dig up some soil and prepares the ground for planting.</span>")
				src.farmed = 1
				ClearOverlays()

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
					AddOverlays(image('icons/urist/jungle/turfs.dmi', "dirt", layer=2.1))
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
		ClearOverlays()
		src.ChangeTurf(/turf/simulated/floor/plating)
		R.use(1)

	..()

/turf/simulated/floor/planet/jungle
	temperature = 305.15 //32C
	animal_spawn_chance = 0.35
	plants_spawn_chance = 40
	small_trees_chance = 7.5
	large_trees_chance = 0
	misc_plant_spawn_chance = 0
	name = "wet grass"
	desc = "Thick, long wet grass"
	icon = 'icons/jungle.dmi'
	icon_state = "grass1"
	light_power = 0.3
	light_range = 1.5
	light_color = "#ffffff"
	bushspawnchance = 30 //let's try it, why not
	footstep_type = /singleton/footsteps/grass
	animal_spawn_list = list(
		/mob/living/simple_animal/hostile/huntable/deer,
		/mob/living/simple_animal/hostile/retaliate/parrot/jungle,
		/mob/living/simple_animal/huntable/monkey
	)



///turf/simulated/floor/planet/jungle/get_footstep_sound()
//	return safepick(footstep_sounds[FOOTSTEP_GRASS])

/turf/simulated/floor/planet/jungle/med
	large_trees_chance = 1
	icon_state = "grass4" //4
	icon_spawn_state = "grass1"
	bushspawnchance = 50
	small_trees_chance = 9
	trap_spawn_chance = TRUE
	light_power = 0.25
	animal_spawn_chance = 0.3
	animal_spawn_list = list(
		/mob/living/simple_animal/hostile/huntable/panther,
		/mob/living/simple_animal/hostile/huntable/deer,
		/mob/living/simple_animal/hostile/retaliate/parrot/jungle,
		)

/turf/simulated/floor/planet/jungle/thick
	large_trees_chance = 5
	icon_state = "grass3" //3
	icon_spawn_state = "grass1"
	bushspawnchance = 70
	plants_spawn_chance = 45
	small_trees_chance = 10
	trap_spawn_chance = TRUE
	light_power = 0.125
	animal_spawn_chance = 0.45
	animal_spawn_list = list(
		/mob/living/simple_animal/hostile/huntable/panther,
		/mob/living/simple_animal/hostile/huntable/deer,
		)

/turf/simulated/floor/planet/jungle/templatethick //for templates so trees and stuff don't get deleted.
	large_trees_chance = 2
	icon_state = "grass3" //3
	icon_spawn_state = "grass1"
	bushspawnchance = 60
	light_power = 0.125
	animal_spawn_chance = 0.5
	animal_spawn_list = list(
		/mob/living/simple_animal/hostile/huntable/panther,
		/mob/living/simple_animal/hostile/huntable/deer,
		/mob/living/simple_animal/hostile/retaliate/parrot/jungle,
		/mob/living/simple_animal/huntable/monkey
		)

/turf/simulated/floor/planet/jungle/clear
	generate_things = FALSE
	animal_spawn_chance = 0
	bushspawnchance = 0
	plants_spawn_chance = 0
	small_trees_chance = 0
	misc_plant_spawn_chance = 0
	icon_state = "grass3" //clear
	light_power = 0.4

/turf/simulated/floor/planet/jungle/clear/grass1
	bushspawnchance = 0
	plants_spawn_chance = 0
	small_trees_chance = 0
	icon_state = "grass1" //clear

/turf/simulated/floor/planet/jungle/clear/dark
	icon_state = "grass1" //clear
	luminosity = 0

/turf/simulated/floor/planet/jungle/path
	bushspawnchance = 0
	small_trees_chance = 0
	misc_plant_spawn_chance = 5
	name = "wet grass"
	desc = "thick, long wet grass"
	icon = 'icons/jungle.dmi'
	icon_state = "grass_path" //path
	icon_spawn_state = "grass2"
	light_power = 0.3
	animal_spawn_chance = 0.07
	animal_spawn_list = list(
		/mob/living/simple_animal/hostile/retaliate/parrot/jungle,
		/mob/living/simple_animal/huntable/monkey
		)

/turf/simulated/floor/planet/plains
	bushspawnchance = 0
	small_trees_chance = 0
	icon = 'icons/urist/events/train.dmi'
	icon_state = "g"
	light_power = 0.5
	light_range = 1.5
	animal_spawn_chance = 0.7 //hostile wasteland riddled with scrap heaps.
	spawn_scrap = 1
	footstep_type = /singleton/footsteps/grass
	animal_spawn_list = list(
		/mob/living/simple_animal/hostile/huntable/bear,
		/mob/living/simple_animal/hostile/snake
		)

/turf/simulated/floor/planet/plains/clear
	icon = 'icons/urist/events/train.dmi'
	icon_state = "g"
	animal_spawn_chance = 0
	spawn_scrap = 0
	generate_things = FALSE

/turf/simulated/floor/planet/jungle/impenetrable
	animal_spawn_chance = 0.15 //very low chances. This is mainly just to populate the respawn list
	bushspawnchance = 0
	small_trees_chance = 0
	large_trees_chance = 7
	icon_state = "grass_impenetrable" //impenetrable
	icon_spawn_state = "grass1"
	light_power = 0
	light_range = 0
	animal_spawn_list = list(
		/mob/living/simple_animal/hostile/huntable/panther,
		/mob/living/simple_animal/hostile/huntable/deer,
		/mob/living/simple_animal/hostile/retaliate/parrot/jungle,
		/mob/living/simple_animal/huntable/monkey
		)

/turf/simulated/floor/planet/jungle/impenetrable/Initialize()
	var/obj/structure/bush/B = new(src)
	B.indestructable = 1
	. = ..()

//copy paste from asteroid mineral turfs
/turf/simulated/floor/planet/jungle/rock //why is this a floor, what the fuck 2014 glloyd
	generate_things = FALSE
	bushspawnchance = 0
	small_trees_chance = 0
	plants_spawn_chance = 0
	animal_spawn_chance = 0
	misc_plant_spawn_chance = 0
	density = TRUE
	opacity = 1
	name = "cliffside wall"
	desc = "A massive wall of natural rock. No point in trying to mine it, try underground."
	icon = 'icons/urist/jungle/turfs.dmi'
	icon_state = "rock"
	footstep_type = null

/turf/simulated/floor/planet/jungle/rock/underground
	name = "rock wall"
	desc = "An impossibly hard rock wall. No point in trying to mine it"
	light_power = 0
	light_range = 0

//Rocks fall, you die
/turf/simulated/floor/planet/jungle/rock/use_tool(obj/item/W, mob/living/user, list/click_params)
	if (istype(W, /obj/item/pickaxe))
		to_chat(user, "You begin to mine into the [src]..")
		if(do_after(user, 12 SECONDS))
			new /obj/structure/boulder(user.loc)
			to_chat(user, "Rocks fall, and you realize what a horrible idea this was.")
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.adjustBruteLoss(40, 0)
			else
				user.AdjustStunned(10)
		else
			to_chat(user, "You have second thoughts about mining into a [src].")
		return TRUE

	return ..()

/turf/simulated/floor/planet/jungle/rock/Initialize()
	var/turf/T
	if(!istype(get_step(src, NORTH), /turf/simulated/floor/planet/jungle/rock) && !istype(get_step(src, NORTH), /turf/unsimulated/wall))
		T = get_step(src, NORTH)
		if (T)
			T.AddOverlays(image('icons/urist/turf/uristturf.dmi', "rock_side_s"))
	if(!istype(get_step(src, SOUTH), /turf/simulated/floor/planet/jungle/rock) && !istype(get_step(src, SOUTH), /turf/unsimulated/wall))
		T = get_step(src, SOUTH)
		if (T)
			T.AddOverlays(image('icons/urist/turf/uristturf.dmi', "rock_side_n", layer=6))
	if(!istype(get_step(src, EAST), /turf/simulated/floor/planet/jungle/rock) && !istype(get_step(src, EAST), /turf/unsimulated/wall))
		T = get_step(src, EAST)
		if (T)
			T.AddOverlays(image('icons/urist/turf/uristturf.dmi', "rock_side_w", layer=6))
	if(!istype(get_step(src, WEST), /turf/simulated/floor/planet/jungle/rock) && !istype(get_step(src, WEST), /turf/unsimulated/wall))
		T = get_step(src, WEST)
		if (T)
			T.AddOverlays(image('icons/urist/turf/uristturf.dmi', "rock_side_e", layer=6))
	. = ..()

/turf/simulated/floor/planet/jungle/rock/weather_enable()
	return

/turf/simulated/floor/planet/jungle/water
	animal_spawn_chance = 0
	bushspawnchance = 0
	small_trees_chance = 0 //fucking rivers winning the small tree RNG
	plants_spawn_chance = 0 //until I get a metric for spawning reeds only
	misc_plant_spawn_chance = 15 //get dem reeds boi
	name = "murky water"
	desc = "thick, murky water"
	icon = 'icons/urist/jungle/turfs.dmi'
	icon_state = "rivernew"
	light_power = 0.5
	var/bridge = 0 //has there been a bridge built?
	var/fishleft = 3 //how many fish are left? todo: replenish this shit over time
	var/fishing = 0 //are we fishing
	var/busy = 0
	footstep_type = /singleton/footsteps/water

/turf/simulated/floor/planet/jungle/water/Initialize()
	. = ..()
	fishleft = rand(1,6)

/turf/simulated/floor/planet/jungle/water/use_tool(obj/item/I, mob/living/user, list/click_params)
	SHOULD_CALL_PARENT(FALSE)
	if(istype(I, /obj/item/fishingrod))
		if(bridge)
			to_chat(user, "<span class='notice'>There's a bridge here, try fishing somewhere else.</span>")
			return TRUE

		else if(fishleft && !fishing && !bridge)
			if(prob(1))
				to_chat(user, "<span class='notice'>Cast away, it's time to catch some fucking fish, because why the fuck not.</span>")

			else
				to_chat(user, "<span class='notice'>You cast your line into the water. Hold still and hopefully you can catch some fish.</span>")

			var/obj/item/fishingrod/F = I
			var/fishtime = (rand(40,140)) //test this shit
			fishtime *= F.fishingpower //here we account for using shitty improvised fishing rods, which increase the time
			fishing = 1

			if (do_after(user, fishtime, src))
				to_chat(user, "<span class='notice'>You feel a tug on your line!</span>")
				AddOverlays(image('icons/urist/jungle/turfs.dmi', "exclamation", layer=2.1))	//exclamation mark
				fishing = 2
				var/tempfish = fishleft
				spawn(rand(35,70))
					if(fishing && fishleft == tempfish)
						to_chat(user, "<span class='notice'>Looks like it got away...</span>")
						fishing = 0
						CutOverlays(image('icons/urist/jungle/turfs.dmi', "exclamation", layer=2.1))
			return TRUE
		else if(fishleft && fishing == 2 && !bridge)
			var/obj/item/F

			if(prob(2))
				F = new/obj/item/storage/belt/utility(user.loc)
			else if(prob(1))
				F = new	/obj/item/beartrap(user.loc)
			else if(prob(10))
				F = new/obj/item/reagent_containers/food/drinks/cans/cola(user.loc)
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

			CutOverlays(image('icons/urist/jungle/turfs.dmi', "exclamation", layer=2.1))
			fishleft -= 1
			fishing = 0
			to_chat(user, "<span class='notice'>You yank on your line, pulling up [F]!</span>")
			return TRUE

		else if(!fishleft && !bridge)
			to_chat(user, "<span class='notice'>You've fished too much in this area, try fishing somewhere else.</span>")
			return TRUE

	else if(istype(I, /obj/item/stack/material/wood))
		if(!bridge)

			var/obj/item/stack/material/wood/R = I

			if(R.amount >= 3)
				to_chat(user, "<span class='notice'>You build a makeshift platform to cross the river safely.</span>")
				desc = "thick murky water. There's a makeshift platform over it."
				R.use(3)
				bridge = 1
				AddOverlays(image('icons/urist/jungle/turfs.dmi', "bridge", layer=2.1))
			else
				to_chat(user, "<span class='notice'>You do not have enough wood to build a bridge.</span>")

			return TRUE

	else if(istype(I, /obj/item/stack/material/r_wood))
		if(!bridge)
			var/obj/item/stack/material/r_wood/R = I

			if(R.amount >= 3)
				to_chat(user, "<span class='notice'>You build a makeshift platform to cross the river safely.</span>")
				desc = "thick murky water. There's a makeshift platform over it."
				R.use(3)

				AddOverlays(image('icons/urist/jungle/turfs.dmi', "bridge2", layer=2.1))
				bridge = 2
			else
				to_chat(user, "<span class='notice'>You do not have enough wood to build a bridge.</span>")

			return TRUE

	else if(istype(I, /obj/item/paddle))
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
		return TRUE

	else if (isCrowbar(I))
		if(bridge)
			to_chat(user, "<span class='notice'>You begin to disassemble the bridge.</span>")
			if (do_after(user, rand(15,30), src))
				playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)

				to_chat(user, "<span class='notice'>You disassemble the bridge.</span>")

				ClearOverlays()

				if(bridge == 1)
					var/obj/item/stack/material/wood/S =  new /obj/item/stack/material/wood(get_turf(src))
					S.amount = 3

				else if(bridge == 2)
					var/obj/item/stack/material/r_wood/S =  new /obj/item/stack/material/r_wood/(get_turf(src))
					S.amount = 3

				bridge = 0
		return TRUE

/*	else if(istype(I, /obj/item/stack/hide/animalhide))
		to_chat(user, "<span class='notice'>You immerse the hide in the water.</span>")
		if (do_after(user, 30, src))
			var/obj/item/stack/hide/animalhide/AH = I
			var/obj/item/stack/hide/wet/WL = new /obj/item/stack/hide/wet(src.loc)
			WL.amount = AH.amount
			user.remove_from_mob(AH)
			user.put_in_hands(WL)
			qdel(AH)
*/

	var/obj/item/reagent_containers/RG = I
	if (istype(RG) && RG.is_open_container())
		RG.reagents.add_reagent(/datum/reagent/water, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message("<span class='notice'>[user] fills \the [RG] from the water.</span>","<span class='notice'> You fill \the [RG] from the water.</span>")
		return TRUE

/turf/simulated/floor/planet/jungle/water/Entered(atom/movable/O)
	..()
	if(density) //to account for deep water
		return

	else if(istype(O, /mob/living/carbon) && !bridge)
		var/mob/living/carbon/M = O
		//slip in the murky water if we try to run through it
		if(prob(10 + (!MOVING_DELIBERATELY(M) ? 40 : 0)))
			to_chat(M, pick("<span class='notice'> You slip on something slimy.</span>","<span class='notice'> You fall over into the murk.</span>"))
			M.Stun(2)
			M.Weaken(1)

		//piranhas - 25% chance to be an omnipresent risk, although they do practically no damage
		if(prob(25)) //however, I'm going to bump up the risk soon, and add a buildable bridge. //did i bump the risk up? who knows! the bridge is there though.
			to_chat(M, "<span class='notice'> You feel something slithering around your legs.</span>")
			spawn(rand(25,50))
				var/zone = pick(BP_R_LEG, BP_L_LEG)
				to_chat(M, pick("<span class='warning'> Something sharp bites you!</span>","<span class='warning'> Sharp teeth grab hold of you!</span>","<span class='warning'> You feel something bite into your leg!</span>"))
				M.apply_damage(rand(3,5), DAMAGE_BRUTE, zone, 0, DAMAGE_FLAG_SHARP)


/turf/simulated/floor/planet/jungle/water/deep
	generate_things = FALSE
	plants_spawn_chance = 0
	density = TRUE
	misc_plant_spawn_chance = 0 //too deep for reeds
	icon_state = "deepnew"

/turf/simulated/floor/planet/jungle/water/deep/CanPass(atom/movable/mover, turf/target)
	if(istype(mover,/obj/item/projectile))
		return 1

	else ..()

/turf/simulated/floor/planet/jungle/water/deep/use_tool(obj/item/I, mob/living/user, list/click_params)
	if(istype(I, /obj/item/paddle))
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

/obj/floor_decal/water_edge
	name = "murky water"
	desc = "thick, murky water"
	icon = 'icons/urist/jungle/turfs.dmi'
	icon_state = "test"

/turf/simulated/floor/planet/jungle/clear/underground
	name = "dirt"
	desc = "gritty, rough dirt, the kind found in a cave."
	icon = 'icons/turf/floors.dmi'
	icon_state = "asteroid"
	light_range = 0
	light_power = 0
	footstep_type = /singleton/footsteps/asteroid

/turf/simulated/floor/planet/jungle/clear/underground/weather_enable(override = 0)
	if(override)
		..()

//dirt

/turf/simulated/floor/planet/dirt
	name = "dirt"
	desc = "gritty, rough, dirt, the kind found outside."
	icon = 'icons/urist/jungle/turfs.dmi'
	icon_state = "dirt_full"
	misc_plant_spawn_chance = 15
	misc_plant_type = /obj/structure/flora/ausbushes/fullgrass
	footstep_type = /singleton/footsteps/asteroid

/turf/simulated/floor/planet/dirt/clear
	generate_things = FALSE
	misc_plant_spawn_chance = 0

/turf/simulated/floor/planet/dirt/city
	misc_plant_type = /obj/structure/flora/ausbushes/sparsegrass
	planet_light = FALSE
	light_power = 1
	light_range = 1

/turf/simulated/floor/planet/dirt/city/clear
	generate_things = FALSE
	misc_plant_spawn_chance = 0

//arid dirt

/turf/simulated/floor/planet/ariddirt
	name = "arid dirt"
	desc = "Arid, sandy dirt."
	icon = 'icons/urist/jungle/aridwaste.dmi'
	icon_state = "wasteland1"
	misc_plant_spawn_chance = 10
	misc_plant_type = /obj/structure/flora/grass/arid
	temperature = 305.15 //32C
	small_tree_type = /obj/structure/flora/tree/planet/arid/small
	large_tree_type = /obj/structure/flora/tree/planet/arid/large
	footstep_type = /singleton/footsteps/sand

/turf/simulated/floor/planet/ariddirt/Initialize()
	.=..()
	icon_state = "wasteland[rand(1,33)]"

/turf/simulated/floor/planet/ariddirt/clear
	misc_plant_spawn_chance = 0
	generate_things = FALSE

/turf/simulated/floor/planet/ariddirt/path
	icon_state = "wastelandp"

/turf/simulated/floor/planet/ariddirt/low
	icon_state = "wastelandl"
	misc_plant_spawn_chance = 15
	small_trees_chance = 1

/turf/simulated/floor/planet/ariddirt/high
	icon_state = "wastelandh"
	small_trees_chance = 2
	large_trees_chance = 1
	misc_plant_spawn_chance = 20

/turf/simulated/floor/planet/ariddirt/marsdirt //for future things
	color = "#b75d0e"
	desc = "Arid, sandy Martian dirt."
	temperature = 288.15 //15C

//temperate forest turfs

/turf/simulated/floor/planet/temperate
	generate_things = FALSE
	temperature = T0C+10
	name = "forest floor"
	desc = "Patchy bits of moss, grass, dirt, and leaves"
	icon = 'icons/urist/turf/floors_borders.dmi'
	icon_state = "browngrass0"
	icon_spawn_state = "browngrass"
	light_power = 0.5
	light_range = 1.5
	light_color = "#ffffff"
	bushspawnchance = 0 //let's try it, why not
	footstep_type = /singleton/footsteps/grass

/turf/simulated/floor/planet/temperate/Initialize()
	. = ..()
	icon_state = "browngrass[rand(0,4)]"

///turf/simulated/floor/planet/temperate/grass need to get more sprites for asteroid style tiling, not important ATM
//	icon = 'icons/turf/floors.dmi'
//	icon_state = "grass_dark"

/turf/simulated/floor/planet/dirt/temperate
	generate_things = FALSE
	misc_plant_spawn_chance = 0
	temperature = 283.15 //10C
	icon = 'icons/urist/jungle/turfs.dmi'
	icon_state = "dirt-rough0"
	light_power = 0.6
	light_range = 1.5
	light_color = "#ffffff"

/turf/simulated/floor/planet/dirt/temperate/Initialize()
	. = ..()
	icon_state = "dirt-rough[rand(0,4)]"

/obj/floor_decal/planet/border

	name = "forest floor"
	desc = "Patchy bits of moss, grass, dirt, and leaves"
	icon = 'icons/urist/turf/floors_borders.dmi'

/obj/floor_decal/planet/border/grasstodirt
	icon_state = "grasstodirt_new"

/obj/floor_decal/planet/border/dirttograss
	icon_state = "dirttograss_new"

/obj/floor_decal/planet/border/grasstosnow
	icon_state = "grasstosnow"

/obj/floor_decal/planet/border/snowtograss
	icon_state = "snowtograss"

/turf/simulated/floor/planet/snow
	generate_things = FALSE
	temperature = 273.15 //0C
	name = "snow"
	desc = "Cold and white"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow0"
	light_power = 0.7
	light_range = 1.5
	light_color = "#ffffff"
	footstep_type = /singleton/footsteps/snow
	has_snow = TRUE
	animal_spawn_list = list(
		/mob/living/simple_animal/hostile/huntable/deer
	)
	//	/mob/living/simple_animal/hostile/huntable/bear/polar,
	//	/mob/living/simple_animal/hostile/huntable/wolf/white,

/turf/simulated/floor/planet/snow/Initialize()
	. = ..()
	icon_state = "snow[rand(0,12)]"

/turf/simulated/open/skylight/planet
	light_power = 0.3
	light_range = 1.0
	light_color = "#ffffff"

/turf/simulated/open/skylight/planet/Initialize()
	light_color = SSskybox.background_color
	. = ..()
