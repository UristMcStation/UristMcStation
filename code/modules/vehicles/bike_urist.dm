/*
 *	Urist Edits
 *
 * 2019-04-22 by Irrationalist (Irra)
 *	- Moved the two verbs "Toggle Engine" and "Toggle Kickstand" from "Object" to "Vehicle"
 *  - Added examination for engine
 *  - Fixed a bug related to inventory and location
 *  - Unloading an engine now puts in inactive hand, else on the ground
 *  - Loading and unloading engine now give messages in chat
 *  - Added proc 'toggle_engine' for easy engine activation
 *  - Added proc 'toggle_kickstand' for easy kickstand
 *  - Removing the engine now turns off the bike
 *  - If in any way the engine had been modified that renders it unusuable, the bike will also be turned off
 *	- Source file formatting
 *
 */

//-------------------------------------------
// Bike definition
//-------------------------------------------
/obj/vehicle/bike
	name = "space-bike"
	desc = "Space wheelies! Woo!"
	icon = 'icons/obj/bike.dmi'
	icon_state = "bike_off"
	dir = SOUTH

	load_item_visible = 1
	buckle_pixel_shift = "x=0;y=5"
	health = 100
	maxhealth = 100

	locked = 0
	fire_dam_coeff = 0.6
	brute_dam_coeff = 0.5
	var/protection_percent = 40 //0 is no protection, 100 is full protection (afforded to the pilot) from projectiles fired at this vehicle

	var/land_speed = 10 //if 0 it can't go on turf
	var/space_speed = 2
	var/bike_icon = "bike"

	var/datum/effect/effect/system/trail/trail
	var/kickstand = 1
	var/obj/item/weapon/engine/engine = null
	var/engine_type
	var/prefilled = 0

/obj/vehicle/bike/New()
	..()
	layer = ABOVE_OBJ_LAYER
	plane = ABOVE_OBJ_PLANE
	if(engine_type)
		load_engine(new engine_type(src.loc))
		if(prefilled)
			engine.prefill()
	update_icon()

/obj/vehicle/bike/update_icon()
	overlays.Cut()

	if(on)
		icon_state = "[bike_icon]_on"
	else
		icon_state = "[bike_icon]_off"
	var/image/I = new(src.icon, "[icon_state]_overlay")
	I.layer = ABOVE_HUMAN_LAYER
	I.plane = ABOVE_HUMAN_PLANE
	overlays += I
	..()

//-------------------------------------------
// Verb interaction & procs
//-------------------------------------------
/obj/vehicle/bike/verb/toggle()
	set name = "Toggle Engine"
	set category = "Vehicle"
	set src in view(0)

	src.toggle_engine(usr)

/obj/vehicle/bike/verb/kickstand()
	set name = "Toggle Kickstand"
	set category = "Vehicle"
	set src in view(0)

	src.toggle_kickstand(usr)

/obj/vehicle/bike/proc/toggle_engine(var/mob/user)
	if(!user) return
	if(user.incapacitated()) return

	if(!on)
		turn_on(user)
	else
		turn_off(user)

/obj/vehicle/bike/proc/toggle_kickstand(var/mob/user)
	if(!user) return
	if(user.incapacitated()) return

	if(kickstand)
		user.visible_message("\The [user] puts up \the [src]'s kickstand.")
	else
		if(istype(src.loc,/turf/space))
			to_chat(user, "<span class='warning'> You don't think kickstands work in space...</span>")
			return
		user.visible_message("\The [user] puts down \the [src]'s kickstand.")
		if(pulledby)
			pulledby.stop_pulling()

	kickstand = !kickstand
	anchored = (kickstand || on)

//-------------------------------------------
// Engine customization procs
//-------------------------------------------
/obj/vehicle/bike/proc/load_engine(var/obj/item/weapon/engine/E, var/mob/user)
	if(engine)
		return
	if(user && !user.unEquip(E))
		return
	engine = E
	engine.forceMove(src)

	if(trail)
		qdel(trail)
	trail = engine.get_trail()
	if(trail)
		trail.set_up(src)

/obj/vehicle/bike/proc/unload_engine(var/mob/user)
	if(!engine)
		return 0

	if (!user || !user.put_in_inactive_hand(engine))
		engine.forceMove(get_turf(src))
	. = engine // set return value to a reference to the engine as a success
	turn_off()
	engine = null

	if(trail)
		trail.stop()
		qdel(trail)
	trail = null

	return

//-------------------------------------------
// Click interaction procs
//-------------------------------------------
/obj/vehicle/bike/attackby(obj/item/W as obj, mob/user as mob)
	if(open)
		if(istype(W, /obj/item/weapon/engine))
			if(engine)
				to_chat(user, "<span class='warning'>There is already an engine block in \the [src].</span>")
				return 1
			user.visible_message("<span class='warning'>\The [user] installs \the [W] into \the [src].</span>")
			load_engine(W, user)
			return

		else if(engine && engine.attackby(W,user))
			if (!engine.can_turn_on() && on)
				turn_off()

		else if(isCrowbar(W))
			var/e = unload_engine(user)
			if (e)
				user.visible_message("<span class='warning'>\The [user] pops out \the [e] from \the [src].</span>")
			else
				to_chat(user, "<span class='warning'>There is no engine in \the [src].</span>")
			return
	return ..()

/obj/vehicle/bike/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(!load(C))
		to_chat(user, "<span class='warning'> You were unable to load \the [C] onto \the [src].</span>")
		return

/obj/vehicle/bike/attack_hand(var/mob/user as mob)
	if(user == load)
		unload(load)
		to_chat(user, "You unbuckle yourself from \the [src]")

//-------------------------------------------
// Interaction procs
//-------------------------------------------
/obj/vehicle/bike/examine(var/mob/user)
	..()
	if (engine)
		to_chat(user, "<span class='notice'>It has \an [engine] installed.</span>")
	else
		to_chat(user, "<span class='warning'>It does not have an engine installed.</span>")

/obj/vehicle/bike/load(var/atom/movable/C)
	var/mob/living/M = C
	if(!istype(C)) return 0
	if(M.buckled || M.restrained() || !Adjacent(M) || !M.Adjacent(src))
		return 0
	return ..(M)

/obj/vehicle/bike/insert_cell(var/obj/item/weapon/cell/C, var/mob/living/carbon/human/H)
	return

//-------------------------------------------
// Movement procs
//-------------------------------------------
/obj/vehicle/bike/relaymove(mob/user, direction)
	if(user != load || !on)
		return
	if(user.incapacitated())
		unload(user)
		visible_message("<span class='warning'>\The [user] falls off \the [src]!</span>")
		return
	return Move(get_step(src, direction))

/obj/vehicle/bike/Move(var/turf/destination)
	if(kickstand || (world.time <= l_move_time + move_delay)) return
	//these things like space, not turf. Dragging shouldn't weigh you down.
	if(!pulledby)
		if(istype(destination,/turf/space) || pulledby)
			if(!space_speed)
				return 0
			move_delay = space_speed
		else
			if(!land_speed)
				return 0
			move_delay = land_speed
		if(!engine || !engine.use_power())
			turn_off()
			return 0
	return ..()

//-------------------------------------------
// Engine activation procs
//-------------------------------------------
/obj/vehicle/bike/turn_on(var/mob/user)
	if(!engine)
		to_chat(user, "<span class='warning'>\The [src] does not have an engine block installed...</span>")
		return 0

	if(on)
		return 0

	if (!engine.can_turn_on())
		engine.dead_start(src, user)
		return 0

	engine.rev_engine(src)
	if(trail)
		trail.start()
	anchored = 1

	update_icon()

	if(pulledby)
		pulledby.stop_pulling()
	..()

/obj/vehicle/bike/turn_off(var/mob/user)
	if(!on)
		return
	if(engine)
		engine.putter(src)

	if(trail)
		trail.stop()

	anchored = kickstand

	update_icon()

	..()

//-------------------------------------------
// Vehicle damage procs
//-------------------------------------------
/obj/vehicle/bike/emp_act(var/severity)
	if(engine)
		engine.emp_act(severity)
	..()

/obj/vehicle/bike/bullet_act(var/obj/item/projectile/Proj)
	if(buckled_mob && prob((100-protection_percent)))
		buckled_mob.bullet_act(Proj)
		return
	..()

/obj/vehicle/bike/Destroy()
	qdel(trail)
	qdel(engine)
	. = ..()

//-------------------------------------------
// Variety defines
//-------------------------------------------
/obj/vehicle/bike/thermal
	engine_type = /obj/item/weapon/engine/thermal
	prefilled = 1

/obj/vehicle/bike/electric
	engine_type = /obj/item/weapon/engine/electric
	prefilled = 1

/obj/vehicle/bike/gyroscooter
	name = "gyroscooter"
	desc = "A fancy space scooter."
	icon_state = "gyroscooter_off"

	land_speed = 1.5
	space_speed = 0
	bike_icon = "gyroscooter"

	trail = null
	engine_type = /obj/item/weapon/engine/electric
	prefilled = 1
	protection_percent = 5
