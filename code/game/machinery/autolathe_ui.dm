/obj/machinery/autolathe/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	update_recipe_list()

	// START DATA STRUCTURING
	var/list/data = list()

	// Make display mode data
	data["show_page"] = show_page
	data["pages"] = list("Recipes", "Jobs")

	// Make storage data
	var/list/storage = list()
	for (var/material in stored_material)
		storage.Add(list(list(
			"name" = capitalize(material),
			"id" = material,
			"amount" = stored_material[material],
			"capacity" = storage_capacity[material],
			"sheets" = stored_material[material]/SHEET_MATERIAL_AMOUNT
		)))

	data["storage"] = storage
	data["eject_amount_options"] = list(1,5,10)

	// Make category data
	var/list/categories = list("All") // initialize with "All" added
	for (var/category in autolathe_categories)
		categories.Add(category)

	data["categories"] = categories
	data["show_category"] = show_category

	// Make available recipes data
	data["show_hidden"] = hacked

	var/list/recipes = list()
	for (var/key = 1 to src.machine_recipes.len)
		var/datum/autolathe/recipe/R = src.machine_recipes[key]

		var/list/resources = list()
		if (R.resources && R.resources.len)
			for (var/material in R.resources)
				resources += "[capitalize(material)]: [round(R.resources[material] * mat_efficiency)]"
		else
			resources += "<i>n/a</i>"


		recipes += list(list(
			"key" = key,
			"name" = capitalize(R.name),
			"category" = R.category,
			"resources" = english_list(resources, and_text = ", "),
			"is_stack" = R.is_stack,
			"hidden" = R.hidden,
			"time" = time2text(round(10 * R.print_time / print_time_rating), "mm:ss")
		))

	data["recipes"] = recipes

	// Make design queue data
	var/list/Q = list()
	if (job_queue.len)
		for (var/key = 1 to job_queue.len)
			if (!job_queue[key])
				break
			var/datum/autolathe/printjob/job = job_queue[key]
			var/list/J = job.get_ui_data()
			J["time_left"] = time2text(10 * (job.target.print_time - job.progress)  / print_time_rating, "mm:ss")
			Q += list(J)

	if (current_job)
		var/list/C = current_job.get_ui_data()
		C["time_left"] = time2text(10 * (current_job.target.print_time - current_job.progress)  / print_time_rating, "mm:ss")
		data["current"] = C
	data["queue"] = Q

	// END DATA STRUCTURING

	// Actually do UI interaction
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "autolathe.tmpl", "Autolathe Control Panel", 800, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/machinery/autolathe/OnTopic(user, href_list, state)
	set waitfor = 0

	// COMMON HREFS

	if(href_list["change_category"])
		show_category = href_list["change_category"]
		. = TOPIC_REFRESH

	else if(href_list["change_page"])
		show_page = href_list["change_page"]
		. = TOPIC_REFRESH

	else if (href_list["eject"] && stored_material)
		var/amount = Clamp(text2num(href_list["eject_amount"]),0,60)
		if (amount)
			if(eject_material(href_list["eject"], amount))
				. = TOPIC_REFRESH

	// RECIPE PAGE HREFS

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

	// JOB PAGE HREFS

	else if (href_list["pause"] && current_job)
		pause_job()
		. = TOPIC_REFRESH

	else if (href_list["abort"] && current_job)
		abort_job()
		. = TOPIC_REFRESH

	else if (href_list["move_up"] && job_queue.len)
		var/argument = text2num(href_list["move_up"])
		if (argument && job_queue[argument])
			move_job(argument, argument - 1)
		. = TOPIC_REFRESH

	else if (href_list["move_down"] && job_queue.len)
		var/argument = text2num(href_list["move_down"])
		if (argument && job_queue[argument])
			move_job(argument, argument + 1)
		. = TOPIC_REFRESH

	else if (href_list["cancel"] && job_queue.len)
		var/argument = text2num(href_list["cancel"])
		if (argument && job_queue[argument])
			cancel_job(argument)
		. = TOPIC_REFRESH


/obj/machinery/autolathe/proc/abort_job()
	if (!current_job.finished() && !QDELING(current_job))
		current_job.abort()
		current_job = null

/obj/machinery/autolathe/proc/pause_job()
	if (!QDELING(current_job))
		current_job.pause()

/obj/machinery/autolathe/proc/move_job(var/source, var/destination)
	if (source == destination || source < 1 || source > job_queue.len)
		return
	if (destination >= 1 && destination <= job_queue.len)
		job_queue.Swap(source, destination)


/obj/machinery/autolathe/proc/cancel_job(var/target)
	if (target >= 1 && target <= job_queue.len)
		removeFromQueue(target)
