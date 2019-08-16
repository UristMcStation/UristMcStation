/obj/machinery/autolathe
	name = "autolathe"
	desc = "It produces items using metal, glass and wood."
	icon_state = "autolathe"
	density = 1
	anchored = 1
	idle_power_usage = 10
	active_power_usage = 2000
	clicksound = "keyboard"
	clickvol = 30

	var/list/machine_recipes
	var/list/stored_material =  list(MATERIAL_STEEL = 0, MATERIAL_ALUMINIUM = 0, MATERIAL_GLASS = 0, MATERIAL_PLASTIC = 0, MATERIAL_WOOD = 0)
	var/list/storage_capacity = list(MATERIAL_STEEL = 0, MATERIAL_ALUMINIUM = 0, MATERIAL_GLASS = 0, MATERIAL_PLASTIC = 0, MATERIAL_WOOD = 0)
	var/show_category = "All"

	var/hacked = 0
	var/disabled = 0
	var/shocked = 0
	var/busy = 0

	var/mat_efficiency = 1
	var/build_time = 50
	var/list/datum/autolathe/recipe/queue = list()
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

/obj/machinery/autolathe/interact(mob/user as mob)

	update_recipe_list()

	if(..() || (disabled && !panel_open))
		to_chat(user, "<span class='danger'>\The [src] is disabled!</span>")
		return

	if(shocked)
		shock(user, 50)

	var/dat = "<center><h1>Autolathe Control Panel</h1><hr/>"

	if(!disabled)
		dat += "<table width = '100%'>"
		var/material_top = "<tr>"
		var/material_bottom = "<tr>"

		for(var/material in stored_material)
			material_top += "<td width = '25%' align = center><b>[material]</b></td>"
			material_bottom += "<td width = '25%' align = center>[stored_material[material]]<b>/[storage_capacity[material]]</b></td>"

		dat += "[material_top]</tr>[material_bottom]</tr></table><hr>"
		dat += "<h2>Printable Designs</h2><h3>Showing: <a href='?src=\ref[src];change_category=1'>[show_category]</a>.</h3></center><table width = '100%'>"

		var/index = 0
		dat += "<h2> Designs in Queue: </h2>"
		var/tmp = 1
		for(var/datum/autolathe/recipe/D in queue)
			dat += "<b>[tmp]: [D.name]</b><BR>"
			++tmp
		dat += "<hr>"
		for(var/datum/autolathe/recipe/R in machine_recipes)
			index++
			if(R.hidden && !hacked || (show_category != "All" && show_category != R.category))
				continue
			var/can_make = 1
			var/material_string = ""
			var/multiplier_string = ""
			var/max_sheets
			var/comma
			if(!R.resources || !R.resources.len)
				material_string = "No resources required.</td>"
			else
				//Make sure it's buildable and list requires resources.
				for(var/material in R.resources)
					var/sheets = round(stored_material[material]/round(R.resources[material]*mat_efficiency))
					if(isnull(max_sheets) || max_sheets > sheets)
						max_sheets = sheets
					if(!isnull(stored_material[material]) && stored_material[material] < round(R.resources[material]*mat_efficiency))
						can_make = 0
					if(!comma)
						comma = 1
					else
						material_string += ", "
					material_string += "[round(R.resources[material] * mat_efficiency)] [material]"
				material_string += ".<br></td>"
				//Build list of multipliers for sheets

			dat += "<tr><td width = 180>[R.hidden ? "<font color = 'red'>*</font>" : ""]<b>[can_make ? "<a href='?src=\ref[src];make=[index];multiplier=1'>" : ""][R.name][can_make ? "</a>" : ""]</b>[R.hidden ? "<font color = 'red'>*</font>" : ""][multiplier_string]</td><td align = right>[material_string]</tr>"

		dat += "</table><hr>"
	//Hacking.
	if(panel_open)
		dat += "<h2>Maintenance Panel</h2>"
		dat += wires.GetInteractWindow()

		dat += "<hr>"

	var/datum/browser/popup = new(user, "autolathenew", "Autholathe", 450, 600)
	popup.set_content(dat)
	popup.open()

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
	var/list/taking_matter = eating.matter

	var/found_useful_mat
	if(LAZYLEN(taking_matter))
		for(var/material in taking_matter)
			if(!isnull(stored_material[material]) && !isnull(storage_capacity[material]))
				found_useful_mat = TRUE
				break

	if(!found_useful_mat)
		to_chat(user, "<span class='warning'>\The [eating] does not contain any accessible useful materials and cannot be accepted.</span>")
		return

	var/amount_available = 1
	if(istype(eating, /obj/item/stack))
		var/obj/item/stack/stack = eating
		amount_available = stack.get_amount()
	var/amount_used = 0    // Amount of material sheets used, if a stack, or whether the item was used, if not.
	var/space_left = FALSE

	for(var/material in taking_matter)

		if(stored_material[material] >= storage_capacity[material])
			continue

		var/total_material = taking_matter[material]
		if(stored_material[material] + total_material > storage_capacity[material])
			total_material = storage_capacity[material] - stored_material[material]
		else
			space_left = TRUE // We filled it with a material, but it could have been filled further had we had more.

		stored_material[material] += total_material
		amount_used = max(ceil(amount_available * total_material/taking_matter[material]), amount_used) // Use only as many sheets as needed, rounding up

	if(!amount_used)
		to_chat(user, "<span class='notice'>\The [src] is full. Please remove material from the autolathe in order to insert more.</span>")
		return
	else if(!space_left)
		to_chat(user, "You fill \the [src] to capacity with \the [eating].")
	else
		to_chat(user, "You fill \the [src] with \the [eating].")

	flick("autolathe_o", src) // Plays metal insertion animation. Work out a good way to work out a fitting animation. ~Z

	if(istype(eating,/obj/item/stack))
		var/obj/item/stack/stack = eating
		stack.use(amount_used)
	else if(user.unEquip(O))
		qdel(O)

	updateUsrDialog()

/obj/machinery/autolathe/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/machinery/autolathe/OnTopic(user, href_list, state)
	set waitfor = 0
	if(href_list["change_category"])
		var/choice = input("Which category do you wish to display?") as null|anything in autolathe_categories+"All"
		if(!choice)
			return TOPIC_HANDLED
		show_category = choice
		. = TOPIC_REFRESH

	else if(!busy && href_list["make"] && machine_recipes)
		. = TOPIC_REFRESH
		var/index = text2num(href_list["make"])
		var/datum/autolathe/recipe/making

		if(index > 0 && index <= machine_recipes.len)
			making = machine_recipes[index]

		//Exploit detection, not sure if necessary after rewrite.
		if(!making)
			log_and_message_admins("tried to exploit an autolathe to duplicate an item!", user)
			return TOPIC_HANDLED
		if(queue.len > max_queue_length)
			to_chat(user, "<span class='warning'>[src] buzzes, 'Queue full!' </span>")
			return
		addToQueue(making)
		to_chat(user, "<span class='notice'>[src] chimes, '[making.name] added to queue!' </span>")

/obj/machinery/autolathe/on_update_icon()
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

	storage_capacity[MATERIAL_STEEL] = mb_rating  * 25000
	storage_capacity[MATERIAL_ALUMINIUM] = mb_rating  * 25000
	storage_capacity[MATERIAL_GLASS] = mb_rating  * 12500
	storage_capacity[MATERIAL_PLASTIC] = mb_rating  * 12500
	storage_capacity[MATERIAL_WOOD] = mb_rating  * 12500
	build_time = 50 / man_rating
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
	queue += D
	return

/obj/machinery/autolathe/proc/removeFromQueue(var/index)
	queue.Cut(index, index + 1)
	return

/obj/machinery/autolathe/Process()
	if(queue.len == 0)
		return
	if(busy)
		return
	var/datum/autolathe/recipe/D = queue[1]
	if(queue.len)
		build(D)

/obj/machinery/autolathe/proc/build(var/datum/autolathe/recipe/D)
	busy = 1
	update_use_power(2)
	var/datum/autolathe/recipe/making
	making = D

	//Check if we still have the materials.
	for(var/material in making.resources)
		if(!isnull(stored_material[material]))
			if(stored_material[material] < round(making.resources[material] * mat_efficiency))
				visible_message("<span class='warning'>[src] buzzes, 'Not enough materials for [making.name], flushing queue.'</span>")
				queue.Cut(1)
				return TOPIC_REFRESH

	//Consume materials.
	for(var/material in making.resources)
		if(!isnull(stored_material[material]))
			stored_material[material] = max(0, stored_material[material] - round(making.resources[material] * mat_efficiency))

	//Fancy autolathe animation.
	flick("autolathe_n", src)

	sleep(build_time)

	busy = 0
	update_use_power(1)

	//Sanity check.
	if(!making || QDELETED(src)) return TOPIC_HANDLED
	//Create the desired item.
	new making.path(loc)
	removeFromQueue(1)

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


