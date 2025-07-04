/obj/machinery/fabricator
	name = "autolathe"
	desc = "It produces common day to day items from a variety of materials."
	icon = 'icons/obj/machines/fabricators/autolathe.dmi'
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 10
	active_power_usage = 2000
	clicksound = "keyboard"
	clickvol = 30
	uncreated_component_parts = null
	stat_immune = 0
	wires =           /datum/wires/fabricator
	base_type =       /obj/machinery/fabricator
	construct_state = /singleton/machine_construction/default/panel_closed

	machine_name = "autolathe"
	machine_desc = "Autolathes can produce a very wide array of useful objects from raw materials."

	var/has_recycler = TRUE
	var/base_icon_state = "autolathe"
	var/image/panel_image

	var/list/queued_orders = list()
	var/datum/fabricator_build_order/currently_building

	var/fabricator_class = FABRICATOR_CLASS_GENERAL

	var/list/stored_material
	var/list/storage_capacity
	var/list/base_storage_capacity = list(
		/material/steel =     25000,
		/material/aluminium = 25000,
		/material/glass =     12500,
		/material/plastic =   12500,
		/material/wood =      12500,
		/material/plasteel = 6000,
		/material/silver = 6000,
		/material/gold = 6000,
		/material/uranium = 6000,
		/material/diamond = 6000
	)

	var/show_category = "All"
	var/fab_status_flags = 0
	var/mat_efficiency = 1.1
	var/build_time_multiplier = 1
	var/static/list/stored_substances_to_names = list()

/obj/machinery/fabricator/Destroy()
	QDEL_NULL(currently_building)
	QDEL_NULL_LIST(queued_orders)
	. = ..()

/obj/machinery/fabricator/examine(mob/user)
	. = ..()
	if(length(storage_capacity))
		var/list/material_names = list()
		for(var/thing in storage_capacity)
			material_names += "[storage_capacity[thing]] [stored_substances_to_names[thing]]"
		to_chat(user, SPAN_NOTICE("It can store [english_list(material_names)]."))
	if(has_recycler)
		to_chat(user, SPAN_NOTICE("It has a built-in shredder that can recycle most items, although any materials it cannot use will be wasted."))

/obj/machinery/fabricator/Initialize()
	panel_image = image(icon, "[base_icon_state]_panel")
	. = ..()
	// Initialize material storage lists.
	stored_material = list()
	for(var/mat in base_storage_capacity)
		stored_material[mat] = 0

		// Update global type to string cache.
		if(!stored_substances_to_names[mat])
			if(ispath(mat, /material))
				var/material/mat_instance = mat
				mat_instance = SSmaterials.get_material_by_name(initial(mat_instance.name))
				if(istype(mat_instance))
					stored_substances_to_names[mat] = mat_instance.display_name
			else if(ispath(mat, /datum/reagent))
				var/datum/reagent/reg = mat
				stored_substances_to_names[mat] = initial(reg.name)

/obj/machinery/fabricator/CanUseTopic(mob/user, datum/topic_state/state, href_list = list())
	if (isAI(user))
		return STATUS_INTERACTIVE
	. = ..()

/obj/machinery/fabricator/state_transition(singleton/machine_construction/default/new_state)
	. = ..()
	if(istype(new_state))
		updateUsrDialog()

/obj/machinery/fabricator/components_are_accessible(path)
	return !(fab_status_flags & FAB_BUSY) && ..()

/obj/machinery/fabricator/cannot_transition_to(state_path)
	if(fab_status_flags & FAB_BUSY)
		return SPAN_NOTICE("You must wait for \the [src] to finish first.")
	return ..()

/obj/machinery/fabricator/proc/is_functioning()
	. = use_power != POWER_USE_OFF && is_powered() && !MACHINE_IS_BROKEN(src) && !(fab_status_flags & FAB_DISABLED)

/obj/machinery/fabricator/Process(wait)
	..()
	if(use_power == POWER_USE_ACTIVE && (fab_status_flags & FAB_BUSY))
		update_current_build(wait)

/obj/machinery/fabricator/on_update_icon()
	ClearOverlays()
	if(panel_open)
		AddOverlays("[icon_state]_panel")
	if(currently_building)
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights_working"))
		AddOverlays("[icon_state]_lights_working")
	else if(is_powered())
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights"))
		AddOverlays("[icon_state]_lights")

/obj/machinery/fabricator/proc/remove_mat_overlay(mat_overlay)
	CutOverlays(mat_overlay)
	update_icon()

//Updates overall lathe storage size.
/obj/machinery/fabricator/RefreshParts()
	..()
	var/mb_rating = clamp(total_component_rating_of_type(/obj/item/stock_parts/matter_bin), 0, 10)
	var/man_rating = clamp(total_component_rating_of_type(/obj/item/stock_parts/manipulator), 0.5, 3.5)
	storage_capacity = list()
	for(var/mat in base_storage_capacity)
		storage_capacity[mat] = mb_rating * base_storage_capacity[mat]
	mat_efficiency = initial(mat_efficiency) - man_rating * 0.1
	build_time_multiplier = initial(build_time_multiplier) * man_rating

/obj/machinery/fabricator/dismantle()
	for(var/mat in stored_material)
		if(ispath(mat, /material))
			var/mat_name = stored_substances_to_names[mat]
			var/material/M = SSmaterials.get_material_by_name(mat_name)
			if(stored_material[mat] > M.units_per_sheet)
				M.place_sheet(get_turf(src), round(stored_material[mat] / M.units_per_sheet), M.name)
	..()
	return TRUE
