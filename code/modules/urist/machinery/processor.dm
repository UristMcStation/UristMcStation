/* TODO: Update to refactored grab system
/obj/machinery/processor
	name = "Food Processor"
	icon = 'icons/obj/machines/kitchen.dmi'
	icon_state = "processor"
	layer = 2.9
	density = TRUE
	anchored = TRUE
	var/broken = 0
	var/processing = 0
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 50



/datum/food_processor_process
	var/input
	var/output
	var/time = 40
	proc/process(loc, what)
		if (src.output && loc)
			new src.output(loc)
		if (what)
			qdel(what)

	/* objs */
/*	meat
		input = /obj/item/reagent_containers/food/snacks/meat
		output = /obj/item/reagent_containers/food/snacks/meatball

	potato
		input = /obj/item/reagent_containers/food/snacks/grown/potato
		output = /obj/item/reagent_containers/food/snacks/rawsticks

	carrot
		input = /obj/item/reagent_containers/food/snacks/grown/carrot
		output = /obj/item/reagent_containers/food/snacks/carrotfries

	soybeans
		input = /obj/item/reagent_containers/food/snacks/grown/soybeans
		output = /obj/item/reagent_containers/food/snacks/soydope

	wheat
		input = /obj/item/reagent_containers/food/snacks/grown/wheat
		output = /obj/item/reagent_containers/food/snacks/flour

	spaghetti
		input = /obj/item/reagent_containers/food/snacks/flour
		output = /obj/item/reagent_containers/food/snacks/spagetti*/

	/* mobs */
	mob
		process(loc, what)
			..()


		slime

			process(loc, what)

				var/mob/living/carbon/slime/S = what
				var/C = S.cores
				if(S.stat != DEAD)
					S.loc = loc
					S.visible_message("<span class='notice'> [C] crawls free of the processor!</span>")
					return
				for(var/i = 1, i <= C, i++)
					var/coreType = S.GetCoreType()
					new coreType(S.loc)
					feedback_add_details("slime_core_harvested","[replacetext(S.colour," ","_")]")
				..()
			input = /mob/living/carbon/slime
			output = null

		monkey
			process(loc, what)
				var/mob/living/carbon/human/monkey/O = what
				if (O.client) //grief-proof
					O.loc = loc
					O.visible_message("<span class='notice'> Suddenly [O] jumps out from the processor!</span>", \
							"You jump out from the processor", \
							"You hear chimp")
					return
				var/obj/item/reagent_containers/glass/bucket/bucket_of_blood = new(loc)
				var/datum/reagent/blood/B = new()
				B.holder = bucket_of_blood
				B.volume = 70
				//set reagent data
				B.data["donor"] = O

				B.data["blood_DNA"] = copytext(O.dna.unique_enzymes,1,0)
				bucket_of_blood.reagents.reagent_list += B
				bucket_of_blood.reagents.update_total()
				bucket_of_blood.on_reagent_change()
				//bucket_of_blood.reagents.handle_reactions() //blood doesn't react
				..()

			input = /mob/living/carbon/human/monkey
			output = null

/obj/machinery/processor/proc/select_recipe(X)
	for (var/Type in typesof(/datum/food_processor_process) - /datum/food_processor_process - /datum/food_processor_process/mob)
		var/datum/food_processor_process/P = new Type()
		if (!istype(X, P.input))
			continue
		return P
	return 0

/obj/machinery/processor/use_tool(obj/item/O, mob/living/user, list/click_params)
	if(src.processing)
		to_chat(user, "<span class='warning'> The processor is in the process of processing.</span>")
		return 1
	if(length(src.contents) > 0) //TODO: several items at once? several different items?
		to_chat(user, "<span class='warning'> Something is already in the processing chamber.</span>")
		return 1
	var/what = O
	if (istype(O, /obj/item/grab))
		var/obj/item/grab/G = O
		what = G.affecting

	var/datum/food_processor_process/P = select_recipe(what)
	if (!P)
		to_chat(user, "<span class='warning'> That probably won't blend.</span>")
		return 1
	user.visible_message("[user] put [what] into [src].", \
		"You put the [what] into [src].")
	user.drop_item()
	what:loc = src
	return

/obj/machinery/processor/attack_hand(mob/user as mob)
	if (src.stat != 0) //NOPOWER etc
		return
	if(src.processing)
		to_chat(user, "<span class='warning'> The processor is in the process of processing.</span>")
		return 1
	if(length(src.contents) == 0)
		to_chat(user, "<span class='warning'> The processor is empty.</span>")
		return 1
	for(var/O in src.contents)
		var/datum/food_processor_process/P = select_recipe(O)
		if (!P)
			log_admin("DEBUG: [O] in processor havent suitable recipe. How do you put it in?") //-rastaf0
			continue
		src.processing = 1
		user.visible_message("<span class='notice'> [user] turns on \a [src].</span>", \
			"You turn on \a [src].", \
			"You hear a food processor.")
		playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
		use_power(500)
		sleep(P.time)
		P.process(src.loc, O)
		src.processing = 0
	src.visible_message("<span class='notice'> \the [src] finished processing.</span>", \
		"You hear the food processor stopping/")
*/
