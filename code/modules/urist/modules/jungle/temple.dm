//TEMPLE SHIT

//turf

/turf/unsimulated/floor/temple
	name = "temple floor"
	icon = 'icons/urist/jungle/turfs.dmi'
	icon_state = "templefloor"

/turf/unsimulated/wall/temple
	name = "temple wall"
	icon = 'icons/urist/jungle/turfs.dmi'
	icon_state = "templewall"

//false wall

/obj/structure/temple_falsewall
	name = "temple wall"
	anchored = TRUE
	icon = 'icons/urist/jungle/turfs.dmi'
	icon_state = "templewall"
	opacity = 1
	var/opening = 0

/obj/structure/temple_falsewall/attack_hand(mob/user as mob)
	if(opening)
		return

	if(density)
		opening = 1
		to_chat(user, "<span class='notice'>You slide the heavy wall open.</span>")
		flick("templewall_opening", src)
		sleep(5)
		density = FALSE
		opacity = 0
		icon_state = "templewall_open"

//******//
// Loot //
//******//

/*/obj/effect/landmark/glowshroom_spawn
	icon_state = "x3"
	invisibility = 101
	New()
		if(prob(10))
			new /obj/effect/plant(src.loc)
		qdel(src)*/ //restore once it DOESN'T RUNTIME

/obj/effect/landmark/loot_spawn
	name = "loot spawner"
	icon_state = "grabbed1"
	var/low_probability = 0

/obj/effect/landmark/loot_spawn/New()

	switch(pick( \
	low_probability * 1000;"nothing", \
	200 - low_probability * 175;"treasure", \
	25 + low_probability * 75;"remains", \
	25 + low_probability * 75;"plants", \
/*	5; "blob", \*/
	50 + low_probability * 50;"clothes", \
	"glasses", \
	100 - low_probability * 50;"weapons", \
	100 - low_probability * 50;"spacesuit", \
	"health", \
	25 + low_probability * 75;"snacks", \
	25;"alien", \
	"lights", \
	25 - low_probability * 25;"engineering", \
	25 - low_probability * 25;"coffin", \
	25;"mimic", \
	25;"viscerator", \
	))
		if("treasure")
			var/obj/structure/closet/crate/C = new(src.loc)
			if(prob(33))
				//coins

				var/amount = rand(2,6)
				var/list/possible_spawns = list()
				for(var/coin_type in typesof(/obj/item/material/coin))
					possible_spawns += coin_type

				var/coin_type = pick(possible_spawns)
				for(var/i=0,i<amount,i++)
					new coin_type(C)
			else if(prob(50))
				//bars

				var/amount = rand(2,6)
				var/quantity = rand(10,50)
				var/list/possible_spawns = list()
				for(var/bar_type in typesof(/obj/item/stack/material) - /obj/item/stack/material)
					possible_spawns += bar_type

				var/bar_type = pick(possible_spawns)
				for(var/i=0,i<amount,i++)
					var/obj/item/stack/material/M = new bar_type(C)
					M.amount = quantity
			else
				//credits

				var/amount = rand(2,6)
				var/list/possible_spawns = list()
				for(var/cash_type in typesof(/obj/item/stack/material))
					possible_spawns += cash_type

				var/cash_type = pick(possible_spawns)
				for(var/i=0,i<amount,i++)
					new cash_type(C)
		if("remains")
			if(prob(50))
				new /obj/item/remains/human(src.loc)
			else
				new /obj/item/remains/xeno(src.loc)
		if("plants")
			if(prob(25))
				new /obj/item/bananapeel(src.loc)
			else if(prob(33))
				new /obj/item/reagent_containers/food/snacks/grown/mushroom/libertycap(src.loc)
			else if(prob(50))
				new /obj/item/reagent_containers/food/snacks/grown/ambrosiavulgaris(src.loc)
//		if("blob")
//			new /obj/effect/blob/core(src.loc) //blob will lag out the planet
			return
		if("clothes")
			var/obj/structure/closet/C = new(src.loc)
			if(prob(33))
				new /obj/item/clothing/under/color/rainbow(C)
				new /obj/item/clothing/shoes/rainbow(C)
				new /obj/item/clothing/head/soft/rainbow(C)
				new /obj/item/clothing/gloves/rainbow(C)
			else if(prob(50))
				new /obj/item/clothing/under/psyche(C)
			else
				new /obj/item/clothing/under/syndicate/combat(C)
				new /obj/item/clothing/shoes/swat(C)
				new /obj/item/clothing/gloves/thick/swat(C)
				new /obj/item/clothing/mask/balaclava(C)
		if("glasses")
			var/obj/structure/closet/C = new(src.loc)
			var/new_type = pick(
			/obj/item/clothing/glasses/material, \
			/obj/item/clothing/glasses/thermal, \
			/obj/item/clothing/glasses/meson, \
			/obj/item/clothing/glasses/night, \
			/obj/item/clothing/glasses/hud/health, \
			/obj/item/clothing/glasses/hud/health \
			)
			new new_type(C)
		if("weapons")
			var/obj/structure/closet/crate/secure/weapon/C = new(src.loc)
			var/new_type = pick(
			200; /obj/item/material/hatchet, \
			/obj/item/gun/projectile/pistol, \
			/obj/item/gun/projectile/pistol/magnum_pistol, \
			// /obj/item/gun/projectile/revolver/russian, \ //got commented out in revolver.dm
			)
			new new_type(C)
		if("spacesuit")
			var/obj/structure/closet/syndicate/C = new(src.loc)
			if(prob(25))
				new /obj/item/clothing/suit/space/syndicate/black(C)
				new /obj/item/clothing/head/urist/helmet(C)
				new /obj/item/tank/oxygen_scba(C)
				new /obj/item/clothing/mask/breath(C)
			else if(prob(33))
				new /obj/item/clothing/suit/urist/space/syndicate/blue(C)
				new /obj/item/clothing/head/urist/helmet/space/syndicate/blue(C)
				new /obj/item/tank/oxygen_scba(C)
				new /obj/item/clothing/mask/breath(C)
			else if(prob(50))
				new /obj/item/clothing/suit/urist/space/syndicate/green(C)
				new /obj/item/clothing/head/urist/helmet/space/syndicate/green(C)
				new /obj/item/tank/oxygen_scba(C)
				new /obj/item/clothing/mask/breath(C)
			else
				new /obj/item/clothing/suit/urist/space/syndicate/orange(C)
				new /obj/item/clothing/head/urist/helmet/space/syndicate/orange(C)
				new /obj/item/tank/oxygen_scba(C)
				new /obj/item/clothing/mask/breath(C)
		if("health")
			//hopefully won't be necessary, but there were an awful lot of traps to get through...
			var/obj/structure/closet/crate/medical/C = new(src.loc)
			if(prob(50))
				new /obj/item/storage/firstaid/regular(C)
			if(prob(50))
				new /obj/item/storage/firstaid/fire(C)
			if(prob(50))
				new /obj/item/storage/firstaid/o2(C)
			if(prob(50))
				new /obj/item/storage/firstaid/toxin(C)
		if("snacks")
			//you're come so far, you must be in need of refreshment
			var/obj/structure/closet/crate/freezer/C = new(src.loc)
			var/num = rand(2,6)
			var/new_type = pick(
			/obj/item/reagent_containers/food/drinks/bottle/small/beer, \
			/obj/item/reagent_containers/food/drinks/tea, \
			/obj/item/reagent_containers/food/drinks/dry_ramen, \
			/obj/item/reagent_containers/food/snacks/candiedapple, \
			/obj/item/reagent_containers/food/snacks/chocolatebar, \
			/obj/item/reagent_containers/food/snacks/cookie, \
			/obj/item/reagent_containers/food/snacks/meatball, \
			/obj/item/reagent_containers/food/snacks/plump_pie, \
			)
			for(var/i=0,i<num,i++)
				new new_type(C)
		if("alien")
			qdel(src)
			return
			//ancient aliens
			//var/obj/structure/closet/acloset/C = new(src.loc)
			/*if(prob(33))
				//facehuggers
				var/num = rand(1,3)
				for(var/i=0,i<num,i++)
					new /obj/item/clothing/mask/facehugger(C)*/
			/*else if(prob(50))
				//something else very much alive and angry
				var/spawn_type = pick(/mob/living/simple_animal/hostile/alien, /mob/living/simple_animal/hostile/alien/drone, /mob/living/simple_animal/hostile/alien/sentinel)
				new spawn_type(C)*/

			//33% chance of nothing

		if("lights")
			//flares, candles, matches
			var/obj/structure/closet/crate/secure/gear/C = new(src.loc)
			var/num = rand(2,6)
			for(var/i=0,i<num,i++)
				var/spawn_type = pick(/obj/item/device/flashlight/flare, /obj/item/trash/candle, /obj/item/flame/candle, /obj/item/storage/box/matches)
				new spawn_type(C)
		if("engineering")
			var/obj/structure/closet/crate/secure/gear/C = new(src.loc)

			//chance to have any combination of up to two electrical/mechanical toolboxes and one cell
			if(prob(33))
				new /obj/item/storage/toolbox/electrical(C)
			else if(prob(50))
				new /obj/item/storage/toolbox/mechanical(C)

			if(prob(33))
				new /obj/item/storage/toolbox/mechanical(C)
			else if(prob(50))
				new /obj/item/storage/toolbox/electrical(C)

			if(prob(25))
				new /obj/item/cell(C)

		if("coffin")
			new /obj/structure/closet/coffin(src.loc)
			if(prob(33))
				new /obj/item/remains/human(src)
			else if(prob(50))
				new /obj/item/remains/xeno(src)
		/*if("mimic")
			//a guardian of the tomb!
			new /mob/living/simple_animal/hostile/mimic/crate(src.loc)*/
		if("viscerator")
			//more tomb guardians!
			var/num = rand(1,3)
			var/obj/structure/closet/crate/secure/gear/C = new(src.loc)
			for(var/i=0,i<num,i++)
				new /mob/living/simple_animal/hostile/viscerator(C)
	..()
	qdel(src)

/obj/effect/landmark/loot_spawn/low
	name = "low prob loot spawner"
	icon_state = "grabbed"
	low_probability = 1

//********//
// Traps! //
//********//

/obj/effect/step_trigger/trap
	name = "trap"
	icon = 'icons/jungle.dmi'
	icon = 'icons/jungle.dmi'
	icon_state = "trap"
	var/trap_type

/obj/effect/step_trigger/trap/New()
	trap_type = pick(50;"thrower","sawburst","poison_dart","flame_burst",10;"phoron_gas",5;"n2_gas")
//	if( (trap_type == "phoron_gas" || trap_type == "n2_gas") && prob(10))
//		new /obj/effect/plant(src.loc)

	//hint that this tile is dangerous
	if(prob(90))
		var/turf/T = get_turf(src)
		T.desc = pick("There is a faint sheen of moisture over the top.","It looks a little unstable.","Something doesn't seem right.")
	..()

/obj/effect/step_trigger/trap/Trigger(atom/A)
	var/mob/living/M = A
	if(!istype(M))
		return

	switch(trap_type)
		if("sawburst")
			to_chat(M, "<span class='danger'>A sawblade shoots out of the ground and strikes you!</span>")
			M.apply_damage(rand(5,10), DAMAGE_BRUTE, DAMAGE_FLAG_SHARP, DAMAGE_FLAG_EDGE)

			var/atom/myloc = src.loc
			var/image/flicker = image('icons/jungle.dmi',"sawblade")
			myloc.overlays += flicker
			spawn(8)
				myloc.overlays -= flicker
				qdel(flicker)
			//flick("sawblade",src)
		if("poison_dart")
			to_chat(M, "<span class='danger'>You feel something small and sharp strike you!</span>")
			M.apply_damage(rand(5,10), DAMAGE_TOXIN)

			var/atom/myloc = src.loc
			var/image/flicker = image('icons/jungle.dmi',"dart[rand(1,3)]")
			myloc.overlays += flicker
			spawn(8)
				myloc.overlays -= flicker
				qdel(flicker)
			//flick("dart[rand(1,3)]",src)
		if("flame_burst")
			to_chat(M, "<span class='danger'>A jet of fire comes out of nowhere!</span>")
			M.apply_damage(rand(5,10), DAMAGE_BURN)

			var/atom/myloc = src.loc
			var/image/flicker = image('icons/jungle.dmi',"flameburst")
			myloc.overlays += flicker
			spawn(8)
				myloc.overlays -= flicker
				del flicker
			//flick("flameburst",src)
		if("phoron_gas")
			//spawn a bunch of phoron
		if("n2_gas")
			//spawn a bunch of sleeping gas
		if("thrower")
			//edited version of obj/effect/step_trigger/thrower
			var/throw_dir = pick(1,2,4,8)
			M.visible_message("<span class='danger'>The floor under [M] suddenly tips upward!</span>","<span class='danger'>The floor tips upward under you!</span>")

			var/atom/myloc = src.loc
			var/image/flicker = image('icons/jungle.dmi',"throw[throw_dir]")
			myloc.overlays += flicker
			var/turf/my_turf = get_turf(loc)
			if(!my_turf.density)
				my_turf.density = TRUE
				spawn(8)
					my_turf.density = FALSE
			spawn(8)
				myloc.overlays -= flicker
				qdel(flicker)

			var/dist = rand(1,5)
			var/curtiles = 0
			while(M)
				if(curtiles >= dist)
					break
				if(M.z != src.z)
					break

				curtiles++
				sleep(1)

				var/predir = M.dir
				step(M, throw_dir)
				M.dir = predir

//gives turf a different description, to try and trick players
/obj/effect/step_trigger/trap/fake
	icon_state = "faketrap"
	name = "fake trap"

/obj/effect/step_trigger/trap/fake/New()
	if(prob(90))
		var/turf/T = get_turf(src)
		T.desc = pick("It looks a little dustier than the surrounding tiles.","It is somewhat ornate.","It looks a little darker than the surrounding tiles.")
		..()
	qdel(src)

//50% chance of being a trap
/obj/effect/step_trigger/trap/fifty
	icon_state = "trap"
	name = "fifty fifty trap"
	icon_state = "fiftytrap"

/obj/effect/step_trigger/trap/fifty/New()
	if(prob(50))
		..()
	else
		qdel(src)

//structures

/obj/structure/fountain/strange/urist
	name = "fountain"
	desc = "A fountain that appears to be spewing red water. Wait... Is that blood?"
	icon = 'icons/urist/jungle/64x64.dmi'
	icon_state = "fountain"
