/obj/machinery/autolathe/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	update_recipe_list()

	// START DATA STRUCTURING
	var/list/data = list()

	// Make storage data
	var/list/storage = list()
	for (var/material in stored_material)
		storage.Add(list(list(
			"name" = capitalize(material),
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

