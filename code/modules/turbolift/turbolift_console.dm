// Base type, do not use.
/obj/structure/lift
	name = "turbolift control component"
	icon = 'icons/obj/structures/turbolift.dmi'
	anchored = TRUE
	density = FALSE
	layer = ABOVE_OBJ_LAYER

	var/datum/turbolift/lift

/obj/structure/lift/set_dir(newdir)
	. = ..()
	pixel_x = 0
	pixel_y = 0
	if(dir & NORTH)
		pixel_y = -32
	else if(dir & SOUTH)
		pixel_y = 32
	else if(dir & EAST)
		pixel_x = -32
	else if(dir & WEST)
		pixel_x = 32

/obj/structure/lift/proc/pressed(mob/user)
	if(!istype(user, /mob/living/silicon))
		if(user.a_intent == I_HURT)
			user.visible_message(SPAN_DANGER("\The [user] hammers on the lift button!"))
		else
			user.visible_message(SPAN_NOTICE("\The [user] presses the lift button."))


/obj/structure/lift/New(newloc, datum/turbolift/_lift)
	lift = _lift
	return ..(newloc)

/obj/structure/lift/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/structure/lift/attack_generic(mob/user)
	attack_hand(user)

/obj/structure/lift/attack_hand(mob/user)
	return interact(user)

/obj/structure/lift/interact(mob/user)
	if(!lift.is_functional())
		return 0
	return 1
// End base.

// Button. No HTML interface, just calls the associated lift to its floor.
/obj/structure/lift/button
	name = "elevator button"
	desc = "A call button for an elevator. Be sure to hit it three hundred times."
	icon_state = "button"
	var/light_up = FALSE
	var/datum/turbolift_floor/floor
	mouse_opacity = 2 //No more eyestrain aiming at tiny pixels

/obj/structure/lift/button/Destroy()
	if(floor && floor.ext_panel == src)
		floor.ext_panel = null
	floor = null
	return ..()

/obj/structure/lift/button/proc/reset()
	light_up = FALSE
	update_icon()

/obj/structure/lift/button/interact(mob/user)
	if(!..())
		return
	light_up()
	pressed(user)
	if(floor == lift.current_floor)
		lift.open_doors()
		spawn(3)
			reset()
		return
	lift.queue_move_to(floor)

/obj/structure/lift/button/proc/light_up()
	light_up = TRUE
	update_icon()

/obj/structure/lift/button/on_update_icon()
	if(light_up)
		icon_state = "button_lit"
	else
		icon_state = initial(icon_state)

/obj/structure/lift/button/railing
	icon_state = "railing_button"

/obj/structure/lift/button/railing/New()
	..()
	pixel_x = -10
	pixel_y = 14

// End button.

// Panel. Lists floors (HTML), moves with the elevator, schedules a move to a given floor.
/obj/structure/lift/panel
	name = "elevator control panel"
	icon_state = "panel"
	mouse_opacity = 2 //No more eyestrain aiming at tiny pixels


/obj/structure/lift/panel/attack_ghost(mob/user)
	return interact(user)

/obj/structure/lift/panel/interact(mob/user)
	if(!..())
		return

	var/dat = list()
	dat += "<html><body><hr><b>Lift panel</b><hr>"

	//the floors list stores levels in order of increasing Z
	//therefore, to display upper levels at the top of the menu and
	//lower levels at the bottom, we need to go through the list in reverse
	for(var/i in length(lift.floors) to 1 step -1)
		var/datum/turbolift_floor/floor = lift.floors[i]
		var/label = floor.label? floor.label : "Level #[i]"
		dat += "[SPAN_COLOR((floor in lift.queued_floors) ? COLOR_YELLOW : COLOR_WHITE, "<a href='byond://?src=\ref[src];move_to_floor=["\ref[floor]"]'>[label]</a>: [floor.name]")]<br>"

	dat += "<hr>"
	if(lift.doors_are_open())
		dat += "<a href='byond://?src=\ref[src];close_doors=1'>Close Doors</a><br>"
	else
		dat += "<a href='byond://?src=\ref[src];open_doors=1'>Open Doors</a><br>"
	dat += "<a href='byond://?src=\ref[src];emergency_stop=1'>Emergency Stop</a>"
	dat += "<hr></body></html>"

	var/datum/browser/popup = new(user, "turbolift_panel", "Lift Panel", 230, 260)
	popup.set_content(jointext(dat, null))
	popup.open()
	return

/obj/structure/lift/panel/OnTopic(user, href_list)
	if(href_list["move_to_floor"])
		lift.queue_move_to(locate(href_list["move_to_floor"]))
		. = TOPIC_REFRESH
	if(href_list["open_doors"])
		lift.open_doors()
		. = TOPIC_REFRESH
	if(href_list["close_doors"])
		lift.close_doors()
		. = TOPIC_REFRESH
	if(href_list["emergency_stop"])
		lift.emergency_stop()
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		pressed(user)

// End panel.
