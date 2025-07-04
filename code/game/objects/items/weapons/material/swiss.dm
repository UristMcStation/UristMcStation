#define SWISSKNF_CLOSED "Close"
#define SWISSKNF_LBLADE "Large Blade"
#define SWISSKNF_SBLADE "Small Blade"
#define SWISSKNF_CLIFTER "Cap Lifter-Screwdriver"
#define SWISSKNF_COPENER "Can Opener-Screwdriver"
#define SWISSKNF_CSCREW "Corkscrew"
#define SWISSKNF_GBLADE "Glass Cutter"
#define SWISSKNF_WCUTTER "Wirecutters"
#define SWISSKNF_WBLADE "Wood Saw"
#define SWISSKNF_CROWBAR "Pry Bar"

/obj/item/material/knife/folding/swiss
	name = "combi-knife"
	desc = "A small, colourable, multi-purpose folding knife."
	icon = 'icons/obj/tools/swiss_knife.dmi'
	icon_state = "swissknf_closed"
	handle_icon = "swissknf_handle"
	takes_colour = FALSE
	valid_colors = null
	max_force = 10

	var/active_tool = SWISSKNF_CLOSED
	var/tools = list(SWISSKNF_LBLADE, SWISSKNF_CLIFTER, SWISSKNF_COPENER)
	var/can_use_tools = TRUE
	var/sharp_tools = list(SWISSKNF_LBLADE, SWISSKNF_SBLADE, SWISSKNF_GBLADE, SWISSKNF_WBLADE)

/obj/item/material/knife/folding/swiss/attack_self(mob/user)
	var/choice
	if(user.a_intent != I_HELP && ((SWISSKNF_LBLADE in tools) || (SWISSKNF_SBLADE in tools)) && active_tool == SWISSKNF_CLOSED)
		open = TRUE
		if(SWISSKNF_LBLADE in tools)
			choice = SWISSKNF_LBLADE
		else
			choice = SWISSKNF_SBLADE
	else
		if(active_tool == SWISSKNF_CLOSED)
			choice = input("Select a tool to open.","Knife") as null|anything in tools|SWISSKNF_CLOSED
		else
			choice = SWISSKNF_CLOSED
			open = FALSE

	if(!choice || !CanPhysicallyInteract(user))
		return
	if(choice == SWISSKNF_CLOSED)
		open = FALSE
		user.visible_message(SPAN_NOTICE("\The [user] closes the [name]."))
	else
		open = TRUE
		if(choice == SWISSKNF_LBLADE || choice == SWISSKNF_SBLADE)
			user.visible_message(SPAN_WARNING("\The [user] opens the [lowertext(choice)]."))
			playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
		else
			user.visible_message(SPAN_NOTICE("\The [user] opens the [lowertext(choice)]."))

	active_tool = choice
	update_force()
	update_icon()
	add_fingerprint(user)

/obj/item/material/knife/folding/swiss/examine(mob/user)
	. = ..()
	to_chat(user, active_tool == SWISSKNF_CLOSED ? "It is closed." : "Its [lowertext(active_tool)] is folded out.")

/obj/item/material/knife/folding/swiss/update_force()
	if(active_tool in sharp_tools)
		..()
		if(active_tool == SWISSKNF_GBLADE)
			siemens_coefficient = 0
		else
			siemens_coefficient = initial(siemens_coefficient)
	else
		force = initial(force)
		edge = initial(edge)
		sharp = initial(sharp)
		hitsound = initial(hitsound)
		attack_verb = closed_attack_verbs
		siemens_coefficient = initial(siemens_coefficient)
	if(active_tool == SWISSKNF_CLOSED)
		w_class = initial(w_class)
	else if(active_tool == SWISSKNF_WBLADE)
		w_class = ITEM_SIZE_SMALL
	else
		w_class = ITEM_SIZE_NORMAL

/obj/item/material/knife/folding/swiss/on_update_icon()
	if(active_tool != null)
		ClearOverlays()
		AddOverlays(overlay_image(icon, active_tool, flags=RESET_COLOR))
		item_state = initial(item_state)
		if(active_tool == SWISSKNF_LBLADE || active_tool == SWISSKNF_SBLADE)
			item_state = "knife"
		if(blood_overlay)
			AddOverlays(blood_overlay)

/obj/item/material/knife/folding/swiss/IsCrowbar()
	return active_tool == SWISSKNF_CROWBAR

/obj/item/material/knife/folding/swiss/IsScrewdriver()
	return (active_tool == SWISSKNF_CLIFTER || active_tool == SWISSKNF_COPENER)

/obj/item/material/knife/folding/swiss/IsWirecutter()
	return active_tool == SWISSKNF_WCUTTER

/obj/item/material/knife/folding/swiss/IsHatchet()
	return active_tool == SWISSKNF_WBLADE


/obj/item/material/knife/folding/swiss/use_before(atom/target, mob/living/user, click_parameters)
	// Damage increase for windows and grilles
	if (active_tool == SWISSKNF_GBLADE && (istype(target, /obj/structure/window) || istype(target, /obj/structure/grille)))
		force *= 8

	// Allow usage on huge or smaller items
	if (isitem(target))
		var/obj/item/target_item = target
		if (target_item.w_class <= ITEM_SIZE_HUGE)
			can_use_tools = TRUE

	return ..()


/obj/item/material/knife/folding/swiss/use_after(atom/target, mob/living/user, click_parameters)
	// Reset per-use vars
	update_force()
	can_use_tools = FALSE

	return ..()


/obj/item/material/knife/folding/swiss/officer
	name = "officer's combi-knife"
	desc = "A small, blue, multi-purpose folding knife. This one adds a corkscrew."
	color = COLOR_COMMAND_BLUE

	tools = list(SWISSKNF_LBLADE, SWISSKNF_CLIFTER, SWISSKNF_COPENER, SWISSKNF_CSCREW)

/obj/item/material/knife/folding/swiss/sec
	name = "master-at-arms' combi-knife"
	desc = "A small, red, multi-purpose folding knife. This one adds no special tools."
	color = COLOR_NT_RED

	tools = list(SWISSKNF_LBLADE, SWISSKNF_CLIFTER, SWISSKNF_COPENER)

/obj/item/material/knife/folding/swiss/medic
	name = "medic's combi-knife"
	desc = "A small, green, multi-purpose folding knife. This one adds a smaller blade in place of the large blade and a glass cutter."
	color = COLOR_OFF_WHITE

	tools = list(SWISSKNF_SBLADE, SWISSKNF_CLIFTER, SWISSKNF_COPENER, SWISSKNF_GBLADE)

/obj/item/material/knife/folding/swiss/engineer
	name = "engineer's combi-knife"
	desc = "A small, yellow, multi-purpose folding knife. This one adds a wood saw and wire cutters."
	color = COLOR_AMBER

	tools = list(SWISSKNF_LBLADE, SWISSKNF_SBLADE, SWISSKNF_CLIFTER, SWISSKNF_COPENER, SWISSKNF_WBLADE, SWISSKNF_WCUTTER)

/obj/item/material/knife/folding/swiss/explorer
	name = "explorer's combi-knife"
	desc = "A small, purple, multi-purpose folding knife. This one adds a wood saw and pry bar."
	color = COLOR_PURPLE

	tools = list(SWISSKNF_LBLADE, SWISSKNF_SBLADE, SWISSKNF_CLIFTER, SWISSKNF_COPENER, SWISSKNF_WBLADE, SWISSKNF_CROWBAR)

/obj/item/material/knife/folding/swiss/loot
	name = "black combi-knife"
	desc = "A small, silver, multi-purpose folding knife. This one adds a small blade and corkscrew."
	color = COLOR_TITANIUM

	tools = list(SWISSKNF_LBLADE, SWISSKNF_SBLADE, SWISSKNF_CLIFTER, SWISSKNF_COPENER, SWISSKNF_CSCREW)

#undef SWISSKNF_CLOSED
#undef SWISSKNF_LBLADE
#undef SWISSKNF_SBLADE
#undef SWISSKNF_CLIFTER
#undef SWISSKNF_COPENER
#undef SWISSKNF_CSCREW
#undef SWISSKNF_GBLADE
#undef SWISSKNF_WCUTTER
#undef SWISSKNF_WBLADE
#undef SWISSKNF_CROWBAR
