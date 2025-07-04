GLOBAL_LIST_AS(rpd_pipe_selection, list(
	new /datum/pipe/pipe_dispenser/simple = list(
		new /datum/pipe/pipe_dispenser/simple/straight,
		new /datum/pipe/pipe_dispenser/simple/bent,
		new /datum/pipe/pipe_dispenser/simple/manifold,
		new /datum/pipe/pipe_dispenser/simple/manifold4w,
		new /datum/pipe/pipe_dispenser/simple/cap
	),
	new /datum/pipe/pipe_dispenser/supply = list(
		new /datum/pipe/pipe_dispenser/supply/straight,
		new /datum/pipe/pipe_dispenser/supply/bent,
		new /datum/pipe/pipe_dispenser/supply/manifold,
		new /datum/pipe/pipe_dispenser/supply/manifold4w,
		new /datum/pipe/pipe_dispenser/supply/cap
	),
	new /datum/pipe/pipe_dispenser/scrubber = list(
		new /datum/pipe/pipe_dispenser/scrubber/straight,
		new /datum/pipe/pipe_dispenser/scrubber/bent,
		new /datum/pipe/pipe_dispenser/scrubber/manifold,
		new /datum/pipe/pipe_dispenser/scrubber/manifold4w,
		new /datum/pipe/pipe_dispenser/scrubber/cap
	),
))

GLOBAL_LIST_AS(rpd_pipe_selection_skilled, list(
	new /datum/pipe/pipe_dispenser/simple = list(
		new /datum/pipe/pipe_dispenser/simple/straight,
		new /datum/pipe/pipe_dispenser/simple/bent,
		new /datum/pipe/pipe_dispenser/simple/manifold,
		new /datum/pipe/pipe_dispenser/simple/manifold4w,
		new /datum/pipe/pipe_dispenser/simple/cap,
		new /datum/pipe/pipe_dispenser/simple/up,
		new /datum/pipe/pipe_dispenser/simple/down
	),
	new /datum/pipe/pipe_dispenser/supply = list(
		new /datum/pipe/pipe_dispenser/supply/straight,
		new /datum/pipe/pipe_dispenser/supply/bent,
		new /datum/pipe/pipe_dispenser/supply/manifold,
		new /datum/pipe/pipe_dispenser/supply/manifold4w,
		new /datum/pipe/pipe_dispenser/supply/cap,
		new /datum/pipe/pipe_dispenser/supply/up,
		new /datum/pipe/pipe_dispenser/supply/down
	),
	new /datum/pipe/pipe_dispenser/scrubber = list(
		new /datum/pipe/pipe_dispenser/scrubber/straight,
		new /datum/pipe/pipe_dispenser/scrubber/bent,
		new /datum/pipe/pipe_dispenser/scrubber/manifold,
		new /datum/pipe/pipe_dispenser/scrubber/manifold4w,
		new /datum/pipe/pipe_dispenser/scrubber/cap,
		new /datum/pipe/pipe_dispenser/scrubber/up,
		new /datum/pipe/pipe_dispenser/scrubber/down
	),
	new /datum/pipe/pipe_dispenser/fuel = list(
		new /datum/pipe/pipe_dispenser/fuel/straight,
		new /datum/pipe/pipe_dispenser/fuel/bent,
		new /datum/pipe/pipe_dispenser/fuel/manifold,
		new /datum/pipe/pipe_dispenser/fuel/manifold4w,
		new /datum/pipe/pipe_dispenser/fuel/cap,
		new /datum/pipe/pipe_dispenser/fuel/up,
		new /datum/pipe/pipe_dispenser/fuel/down
	),
	new /datum/pipe/pipe_dispenser/device = list(
		new /datum/pipe/pipe_dispenser/device/universaladapter,
		new /datum/pipe/pipe_dispenser/device/gaspump,
		new /datum/pipe/pipe_dispenser/device/manualvalve
	)
))

/obj/item/rpd
	name = "rapid piping device"
	desc = "Portable, complex and deceptively heavy, it's the cousin of the RCD, use to dispense piping on the move."
	icon = 'icons/obj/tools/rpd.dmi'//Needs proper icon
	icon_state = "rpd"
	force = 12
	throwforce = 15
	throw_speed = 1
	throw_range = 3
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 4)

	var/datum/effect/spark_spread/spark_system
	var/datum/pipe/P
	var/pipe_color = "white"
	var/datum/browser/popup

/obj/item/rpd/Initialize()
	. = ..()
	spark_system = new /datum/effect/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	var/list/L = GLOB.rpd_pipe_selection[GLOB.rpd_pipe_selection[1]]
	P = L[1]
	//if there's no pipe selected randomize it

/obj/item/rpd/Destroy()
	QDEL_NULL(spark_system)
	return ..()

/obj/item/rpd/proc/get_console_data(list/pipe_categories, color_options = FALSE)
	. = list()
	. += "<table>"
	if(color_options)
		. += "<tr><td>Color</td><td><a href='byond://?src=\ref[src];color=\ref[src]'>[SPAN_COLOR(pipe_color, pipe_color)]</a></td></tr>"
	for(var/category in pipe_categories)
		var/datum/pipe/cat = category
		. += "<tr><td>[SPAN_COLOR("#517087", "<strong>[initial(cat.category)]</strong>")]</td></tr>"
		for(var/datum/pipe/pipe in pipe_categories[category])
			. += "<tr><td>[pipe.name]</td><td>[P.type == pipe.type ? SPAN_CLASS("linkOn", "Select") : "<a href='byond://?src=\ref[src];select=\ref[pipe]'>Select</a>"]</td></tr>"
	.+= "</table>"
	. = jointext(., null)

/obj/item/rpd/interact(mob/user)
	popup = new (user, "Pipe List", "[src] menu")
	popup.set_content(get_console_data(GLOB.rpd_pipe_selection_skilled, TRUE))
	popup.open()

/obj/item/rpd/OnTopic(user, list/href_list)
	if(href_list["select"])
		P = locate(href_list["select"])
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		interact(user)
		if(prob(10)) src.spark_system.start()
		return TOPIC_HANDLED
	if(href_list["color"])
		var/choice = input(user, "What color do you want pipes to have?") as null|anything in pipe_colors
		if(!choice || !CanPhysicallyInteract(user))
			return TOPIC_HANDLED
		pipe_color = choice
		interact(user)
		return TOPIC_HANDLED

/obj/item/rpd/dropped(mob/user)
	..()
	if(popup)
		popup.close()

/obj/item/rpd/use_after(atom/A, mob/living/user, click_parameters)
	if (istype(A, /obj/item/pipe))
		recycle(A,user)
		return TRUE
	else
		var/turf/T = get_turf(A)
		if (!T.Adjacent(loc))
			return TRUE

		playsound(get_turf(user), 'sound/machines/click.ogg', 50, 1)
		if (T.is_wall())
			if (!do_after(user, 3 SECONDS, T, DO_PUBLIC_UNIQUE))
				return TRUE
			playsound (get_turf(user), 'sound/items/Deconstruct.ogg', 50, 1)

		var/obj/item/pipe/pipe = P.Build(P, T, pipe_colors[pipe_color])
		var/num_rotations = get_placement_rotation(user, P.placement_mode, click_parameters)
		for (var/i = 0, i < num_rotations, i++)
			pipe.dir = GLOB.cw_dir[pipe.dir]
		if (prob(20))
			spark_system.start()
		return TRUE

/obj/item/rpd/proc/get_placement_rotation(mob/user, placement_mode, click_parameters)
	var/mouse_x = text2num(click_parameters["icon-x"])
	var/mouse_y = text2num(click_parameters["icon-y"])
	switch (placement_mode)
		if (PIPE_PLACEMENT_SIMPLE)
			// Zero rotations as we use the default direction of the pipe
			return 0
		if (PIPE_PLACEMENT_DIAGONAL)
			// One case for each of the four quarters of a square
			//  0 │ 1
			// ───┼───
			//  3 │ 2
			if (mouse_x <= 16)
				if (mouse_y <= 16)
					. = 3
				else
					. = 0
			else
				if (mouse_y <= 16)
					. = 2
				else
					. = 1
		if (PIPE_PLACEMENT_ORTHOGONAL)
			// One case for each of the four triangles of a square
			//  ⟍ 0 ⟋
			//  3 ⤫ 1
			//  ⟋ 2 ⟍
			if (mouse_y > mouse_x)
				if (mouse_y > 32-mouse_x)
					. = 0
				else
					. = 3
			else
				if (mouse_y > 32-mouse_x)
					. = 1
				else
					. = 2

/obj/item/rpd/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, "[SPAN_NOTICE("Current selection reads:")] [P]")

/obj/item/rpd/attack_self(mob/user)
	interact(user)
	add_fingerprint(user)

/obj/item/rpd/use_tool(obj/item/item, mob/living/user, list/click_params)
	if(istype(item, /obj/item/pipe))
		if(!user.unEquip(item))
			FEEDBACK_UNEQUIP_FAILURE(user, item)
			return TRUE
		recycle(item,user)
		return TRUE
	return ..()

/obj/item/rpd/proc/recycle(obj/item/W,mob/user)
	playsound(src.loc, 'sound/effects/pop.ogg', 50, 1)
	qdel(W)
