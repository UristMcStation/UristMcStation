SUBSYSTEM_DEF(worths_test)
	name = "Worths Test"
	wait = 2 SECONDS
	init_order = SS_INIT_UNIT_TESTS
	runlevels = (RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY)
	var/stage = 1
	var/new_materials = FALSE
	var/new_objects = FALSE
	var/list/processed_materials
	var/list/processed_objects
	var/list/object_queue
	var/list/material_queue
	var/obj_done = 0
	var/obj_total = 0
	var/turf/safe_loc
	var/turf/trader_loc
	var/list/traders
	var/tick_check = 0

	var/list/root_exceptions = list(
		/obj/item/magic_hand,
		/obj/item/grab,
		/obj/item/device/radio/borg,
		/obj/item/device/radio/announcer,
		/obj/item/paper/contract,
		/obj/item/organ/internal/mmi_holder,
		/obj/weathertype,
		/obj/effect,
		/obj/urist_intangible,
		/obj/machinery/ai_powersupply,
		/obj/item/proxy_debug,
		/obj/item/rig_module/mounted,
		/obj/item/psychic_power,
		/obj/screen,
		/obj/random,
		/obj/aura,
		/obj/structure/disposalholder,
		/obj/structure/stairs,
		/obj/prefab,
		/obj/procedural,
		/obj/test,
		/obj/item/mech_component,
		/obj/item/robot_module,
		/obj/random_multi,
		/obj/particle_emitter,
		/obj/singularity
	)

	var/list/exceptions = list(
		/obj/item,
		/obj/item/reagent_containers/ivbag/blood,
		/obj/item/reagent_containers/ivbag/blood/human,
		/obj/item/reagent_containers/ivbag/blood/skrell,
		/obj/item/reagent_containers/ivbag/blood/unathi,
		/obj/item/reagent_containers/ivbag/blood/vox,
		/obj/item/reagent_containers/ivbag/blood/teshari,
		/obj/item/cell,
		/obj/item/gun/energy/gun/secure/mounted,
		/obj/item/crafting_holder,
		/obj/item/pressure,
		/obj/machinery/portable_atmospherics/hydroponics/soil/invisible,
		/obj/item/reagent_containers/pill/pouch_pill,
		/obj/machinery/power/smes,
		/obj/turbolift_map_holder,
		/obj/item/material,
		/obj/item/fuel_assembly,
		/obj/item/reagent_containers/glass/mister,
		/obj/item/clothing/suit/storage/hooded,
		/obj/hotspot
	)

/datum/controller/subsystem/worths_test/Initialize(start_uptime)
	#ifndef UNIT_TEST_COLOURED
	if(world.system_type != UNIX) // Not a Unix/Linux/etc system, we probably don't want to print color escapes (unless UNIT_TEST_COLOURED was defined to force escapes)
		ascii_esc = ""
		ascii_red = ""
		ascii_green = ""
		ascii_yellow = ""
		ascii_reset = ""
	#endif

	log_worths_test("Initializing Worths Testing")

	src.processed_materials = list()
	src.processed_objects = list()
	src.traders = list()

	for(var/path in src.root_exceptions)
		src.exceptions |= typesof(path)

	SSticker.master_mode = "extended"

/datum/controller/subsystem/worths_test/proc/start_game()
	if (GAME_STATE >= RUNLEVEL_POSTGAME)
		log_worths_test("Unable to start testing - game is finished!")
		del world
		return

	if ((GAME_STATE == RUNLEVEL_LOBBY) && !SSticker.start_now())
		log_worths_test("Unable to start testing - SSticker failed to start the game!")
		del world
		return

	stage++
	log_worths_test("Game start has been requested.")

/datum/controller/subsystem/worths_test/proc/await_game_running()
	if(GAME_STATE == RUNLEVEL_GAME)
		log_worths_test("The game is now in progress.")
		stage++

/datum/controller/subsystem/worths_test/proc/init_material_queue()
	src.material_queue = list()

	for(var/material/mat in SSmaterials.materials)
		if((mat.type in src.processed_materials) || istype(mat, /material/placeholder))
			continue
		src.material_queue.Add(mat)

	if(length(src.material_queue))
		src.new_materials = TRUE

	stage++

/datum/controller/subsystem/worths_test/proc/process_materials()
	while(length(src.material_queue))
		var/material/mat = src.material_queue[length(src.material_queue)]
		LIST_DEC(src.material_queue)

		log_worths_test("**** [uppertext(mat.name)] ****")

		var/list/base_recipes = mat.dump_recipes()
		var/list/reinforced_recipes = list()

		var/mat_name = lowertext(mat.name)
		log_worths_test("-- [mat_name]: [length(base_recipes)] recipe\s")

		for(var/material/reinf_mat in SSmaterials.materials)
			if(istype(reinf_mat, /material/placeholder))
				continue

			var/list/recipes = mat.dump_recipes(reinf_mat)

			if(!length(recipes))
				continue

			log_worths_test("-- [mat_name] (Reinforced - [lowertext(reinf_mat.name)]): [length(recipes)] recipe\s")

			reinforced_recipes[lowertext(reinf_mat.name)] = recipes

		src.processed_materials[mat.type] = list(
			"id" = mat_name,
			"units_per_sheet" = mat.units_per_sheet,
			"base_recipes" = base_recipes,
			"reinforced_recipes" = reinforced_recipes
		)

		if(MC_TICK_CHECK)
			return

	if(!length(src.material_queue))
		stage++

/datum/controller/subsystem/worths_test/proc/init_object_queue()
	src.trader_loc = get_turf(locate(/obj/landmark/start))
	src.safe_loc = get_turf(locate(/obj/landmark/test/safe_turf))

	src.object_queue = (subtypesof(/obj) - (src.exceptions | src.processed_objects))
	src.obj_total = length(src.object_queue)

	if(src.obj_total)
		src.new_objects = TRUE

	stage++

/datum/controller/subsystem/worths_test/proc/spawn_traders()
	for(var/trader_path in typesof(/mob/living/simple_animal/passive/npc/colonist/trader))
		var/mob/trader = new trader_path(src.trader_loc)
		src.traders.Add(trader)

	stage++

/datum/controller/subsystem/worths_test/proc/process_objects()
	while(length(src.object_queue))
		var/object_path = src.object_queue[length(src.object_queue)]
		LIST_DEC(src.object_queue)

		var/obj/O = new object_path(src.safe_loc)

		var/trade_min
		var/trade_max
		var/value = get_value(O)

		for(var/mob/living/simple_animal/passive/npc/colonist/trader/trader in src.traders)
			if(!trader.check_tradeable(O))
				continue

			var/valued = trader.get_trade_value(O)
			if(valued == value)	//Trader doesn't actually have a different value from the fallback worth. Ignore
				continue

			if(isnull(trade_min))
				trade_min = valued
				trade_max = valued
				continue

			trade_min = min(trade_min, valued)
			trade_max = max(trade_max, valued)

		src.processed_objects[object_path] = list(
			"trade_value_low" = trade_min,
			"trade_value_high" = trade_max,
			"worth"= value,
			"composition" = O.matter
		)

		qdel(O)

		src.obj_done++

		if(MC_TICK_CHECK)
			src.tick_check++
			return

	if(!length(src.object_queue))
		for(var/mob/trader in src.traders)
			src.traders -= trader
			qdel(trader)

		stage++

/datum/controller/subsystem/worths_test/fire(resumed = 0)
	switch(stage)
		if(1)
			start_game()
		if(2)
			await_game_running()
		if(3)
			stage++
			log_worths_test("Testing started")
			log_worths_test("Initialising material list...")
		if(4)
			init_material_queue()
		if(5)
			stage++
			log_worths_test("[length(src.material_queue)] material\s readied")
			log_worths_test("----==== Collecting material recipes ====----")
		if(6)
			process_materials()
		if(7)
			stage++
			log_worths_test("Initialising object list...")
		if(8)
			init_object_queue()
		if(9)
			stage++
			log_worths_test("[src.obj_total] object\s readied")
			log_worths_test("Spawning traders...")
		if(10)
			spawn_traders()
		if(11)
			stage++
			log_worths_test("[length(src.traders)] trader\s spawned")
			log_worths_test("----==== Collecting Object Worths ====----")
		if(12)
			process_objects()
			if(!(src.tick_check % 30))
				log_worths_test("** Progress: \[[src.obj_done]\]/\[[src.obj_total]\] ([round(src.obj_done/src.obj_total*100)]%) **")
		if(13)
			log_worths_test("Tests complete!")

			if(src.new_materials || src.new_objects)
				log_worths_test("Saving to file...")

				if(src.new_materials)
					text2file(json_encode(src.processed_materials), "materials_worth.json")
				if(src.new_objects)
					text2file(json_encode(src.processed_objects), "objects_worth.json")
			else
				log_worths_test("No new materials or objects to export")

			log_worths_test("Complete!")
			del world
