/obj/machinery/autolathe
	name = "autolathe"
	desc = "It produces items using metal, glass and wood."
	icon_state = "autolathe"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 2000
	clicksound = "keyboard"
	clickvol = 30

	var/list/machine_recipes
	var/list/stored_material =  list(DEFAULT_WALL_MATERIAL = 0, "glass" = 0, "wood" = 0)
	var/list/storage_capacity = list(DEFAULT_WALL_MATERIAL = 0, "glass" = 0, "wood" = 0)
	var/show_category = "All"

	var/hacked = 0
	var/disabled = 0
	var/shocked = 0
	var/busy = 0

	var/mat_efficiency = 1
	var/print_time_rating = 1

	var/datum/autolathe/printjob/current_job
	var/list/datum/autolathe/printjob/job_queue = list()
	var/max_queue_length = 12

	var/datum/wires/autolathe/wires = null


/obj/machinery/autolathe/New()

	..()
	wires = new(src)
	//Create parts for lathe.
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/autolathe(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	RefreshParts()

/obj/machinery/autolathe/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/autolathe/proc/update_recipe_list()
	if(!machine_recipes)
		machine_recipes = autolathe_recipes

/obj/machinery/autolathe/attackby(var/obj/item/O as obj, var/mob/user as mob)

	if(busy)
		to_chat(user, "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>")
		return

	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return

	if(stat)
		return

	if(panel_open)
		//Don't eat multitools or wirecutters used on an open lathe.
		if(isMultitool(O) || isWirecutter(O))
			attack_hand(user)
			return

	attempt_fill(O,user)

/obj/machinery/autolathe/proc/attempt_fill(var/obj/item/O, var/mob/user)
	if(!(O.Adjacent(user)))
		return 0

	if(is_robot_module(O))
		return 0

	//Resources are being loaded.
	var/obj/item/eating = O

	var/list/taking_matter
	if(istype(eating, /obj/item/stack/material))
		var/obj/item/stack/material/mat = eating
		taking_matter = list()
		for(var/matname in eating.matter)
			taking_matter[matname] = Floor(eating.matter[matname]/mat.amount)
	else
		taking_matter = eating.matter

	var/found_useful_mat
	if(LAZYLEN(taking_matter))
		for(var/material in taking_matter)
			if(!isnull(stored_material[material]) && !isnull(storage_capacity[material]))
				found_useful_mat = TRUE
				break

	if(!found_useful_mat)
		to_chat(user, "<span class='warning'>\The [eating] does not contain any accessible useful materials and cannot be accepted.</span>")
		return

	var/filltype = 0       // Used to determine message.
	var/total_used = 0     // Amount of material used.
	var/mass_per_sheet = 0 // Amount of material constituting one sheet.

	for(var/material in taking_matter)

		if(stored_material[material] >= storage_capacity[material])
			continue

		var/total_material = taking_matter[material]

		//If it's a stack, we eat multiple sheets.
		if(istype(eating,/obj/item/stack))
			var/obj/item/stack/stack = eating
			total_material *= stack.get_amount()

		if(stored_material[material] + total_material > storage_capacity[material])
			total_material = storage_capacity[material] - stored_material[material]
			filltype = 1
		else
			filltype = 2

		stored_material[material] += total_material
		total_used += total_material
		mass_per_sheet += taking_matter[material]

	if(!filltype)
		to_chat(user, "<span class='notice'>\The [src] is full. Please remove material from the autolathe in order to insert more.</span>")
		return
	else if(filltype == 1)
		to_chat(user, "You fill \the [src] to capacity with \the [eating].")
	else
		to_chat(user, "You fill \the [src] with \the [eating].")

	flick("autolathe_o", src) // Plays metal insertion animation. Work out a good way to work out a fitting animation. ~Z

	if(istype(eating,/obj/item/stack))
		var/obj/item/stack/stack = eating
		stack.use(max(1, round(total_used/mass_per_sheet))) // Always use at least 1 to prevent infinite materials.
	else if(user.unEquip(O))
		qdel(O)

	updateUsrDialog()

/obj/machinery/autolathe/attack_hand(mob/user as mob)
	if(..() || (disabled && !panel_open))
		to_chat(user, "<span class='danger'>\The [src] is disabled!</span>")
		return

	if(shocked)
		shock(user, 50)

	wires.Interact(user)
	ui_interact(user)

/obj/machinery/autolathe/OnTopic(user, href_list, state)
	set waitfor = 0

	if(href_list["show"])
		show_category = href_list["show"]
		. = TOPIC_REFRESH

	else if(href_list["make"] && machine_recipes)
		. = TOPIC_REFRESH
		var/index = text2num(href_list["make"])
		var/datum/autolathe/recipe/making

		if(index > 0 && index <= machine_recipes.len)
			making = machine_recipes[index]

		//Exploit detection, not sure if necessary after rewrite.
		if(!making)
			log_and_message_admins("tried to exploit an autolathe to duplicate an item!", user)
			return TOPIC_HANDLED
		if(job_queue.len > max_queue_length)
			to_chat(user, "<span class='warning'>[src] buzzes, 'Queue full!' </span>")
			return
		addToQueue(making)
		to_chat(user, "<span class='notice'>[src] chimes, '[making.name] added to queue!' </span>")

	else if (href_list["eject"] && stored_material)
		var/amount = Clamp(text2num(href_list["eject_amount"]),0,60)
		world.log << "[src] got href 'eject' with the amount [amount]"

/obj/machinery/autolathe/update_icon()
	icon_state = (panel_open ? "autolathe_t" : "autolathe")

//Updates overall lathe storage size.
/obj/machinery/autolathe/RefreshParts()
	..()
	var/mb_rating = 0
	var/man_rating = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/MB in component_parts)
		mb_rating += MB.rating
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		man_rating += M.rating

	storage_capacity[DEFAULT_WALL_MATERIAL] = mb_rating  * 25000
	storage_capacity["glass"] = mb_rating  * 12500
	storage_capacity["wood"] = mb_rating  * 12500
	print_time_rating = man_rating
	mat_efficiency = 1.1 - man_rating * 0.1// Normally, price is 1.25 the amount of material, so this shouldn't go higher than 0.8. Maximum rating of parts is 3

/obj/machinery/autolathe/dismantle()

	for(var/mat in stored_material)
		var/material/M = SSmaterials.get_material_by_name(mat)
		if(!istype(M))
			continue
		var/obj/item/stack/material/S = M.place_sheet(get_turf(src), 1, M.name)
		if(stored_material[mat] > S.perunit)
			S.amount = round(stored_material[mat] / S.perunit)
		else
			qdel(S)
	..()
	return 1

/obj/machinery/autolathe/MouseDrop(var/over_location)
	..()
	if(!isliving(usr))
		return
	if(!isturf(over_location))
		over_location = get_turf(over_location)
	if(Adjacent(over_location) && Adjacent(usr))
		for(var/obj/item/O in over_location)
			attempt_fill(O, usr)

/obj/machinery/autolathe/proc/addToQueue(var/datum/autolathe/recipe/D)
	job_queue += new /datum/autolathe/printjob(src, D)
	return

/obj/machinery/autolathe/proc/popFromQueue()
	var/datum/autolathe/printjob/J = job_queue[1]
	job_queue.Cut(1, 2)
	return J

/obj/machinery/autolathe/proc/removeFromQueue(var/index)
	job_queue.Cut(index, index + 1)
	return

/obj/machinery/autolathe/Process()
	..()
	if (stat)
		return
	if (!current_job && job_queue.len)
		current_job = popFromQueue()

	if (current_job && !QDELING(current_job))
		if (!current_job.started)
			if (current_job.can_make())
				current_job.start()
		else
			current_job.tick(print_time_rating)

/obj/machinery/autolathe/proc/on_job_finished(var/atom/movable/product)
	product.forceMove(src.loc)
	visible_message("\The [src] pings, indicating that \the [product] is complete.", "You hear a ping.")
	qdel(current_job)
	current_job = null

/obj/machinery/autolathe/verb/extract_materials()
	set name = "Extract Materials"
	set category = "Object"
	set src in view(1)
	var/mob/living/user = usr

	if(user.incapacitated() || !istype(user, /mob/living))
		to_chat(user, "<span class='warning'>You can't do that.</span>")
		return

	if(!Adjacent(user))
		to_chat(user, "<span class='warning'>You can't reach it.</span>")
		return
	var/extraction_choices = list("steel", "glass", "wood")
	var/material = input(user, "What do you want to extract?", "Materials Extraction") as null|anything in extraction_choices
	var/mat_number = input(user, "How much do you want to extract? (Max: 60)", "Materials Extraction") as num
	if(!mat_number)
		return
	mat_number = Clamp(mat_number, 0, 60)
	var/extraction_path
	switch(material)
		if("steel")
			extraction_path = /obj/item/stack/material/steel
		if("glass")
			extraction_path = /obj/item/stack/material/glass
		if("wood")
			extraction_path = /obj/item/stack/material/wood
	//We have all the info we need now - calculate how much it'll cost.
	var/mat_cost = mat_number * SHEET_MATERIAL_AMOUNT
	var/stored_materials = stored_material[material]
	if(stored_materials < mat_cost) //Not enough material stored. Settle for the next best thing.
		var/new_mat_number = stored_materials / SHEET_MATERIAL_AMOUNT
		mat_number = new_mat_number
	mat_number = Clamp(mat_number, 0, 60) // Clamp and round to prevent decimal issues.
	mat_number = Floor(mat_number)
	mat_cost = mat_number * SHEET_MATERIAL_AMOUNT
	if(SHEET_MATERIAL_AMOUNT > stored_materials)
		return //And all was for naught, because you didn't have enough.
	new extraction_path(loc, mat_number)
	stored_material[material] -= mat_cost


