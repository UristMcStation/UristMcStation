/obj/vehicle/train/cargo/engine/motorcycle_4dir
	name = "motorcycle"
	desc = "A fast and highly maneuverable vehicle."
	icon = 'icons/urist/vehicles/uristvehicles.dmi'
	icon_state = "motorcycle_4dir"
	emagged = FALSE
	mob_offset_y = 6
	load_offset_x = 0
	health = 150
	charge_use = 0

/obj/vehicle/train/cargo/engine/motorcycle_4dir/proc/update_dir_motorcycle_overlays()
	ClearOverlays()
	if(src.dir == NORTH||SOUTH)
		if(src.dir == NORTH)
			var/image/I = new(icon = 'icons/urist/vehicles/uristvehicles.dmi', icon_state = "motorcycle_overlay_n", layer = src.layer + 0.2) //over mobs
			AddOverlays(I)
		else if(src.dir == SOUTH)
			var/image/I = new(icon = 'icons/urist/vehicles/uristvehicles.dmi', icon_state = "motorcycle_overlay_s", layer = src.layer + 0.2) //over mobs
			AddOverlays(I)
	else
		var/image/I = new(icon = 'icons/urist/vehicles/uristvehicles.dmi', icon_state = "motorcycle_overlay_side", layer = src.layer + 0.2) //over mobs
		AddOverlays(I)

/obj/vehicle/train/cargo/engine/motorcycle_4dir/New()
	..()
	update_dir_motorcycle_overlays()

/obj/vehicle/train/cargo/engine/motorcycle_4dir/Move()
	..()
	update_dir_motorcycle_overlays()

/obj/vehicle/train/cargo/engine/motorcycle_1dir
	name = "motorcycle"
	desc = "A fast and highly maneuverable vehicle."
	icon = 'icons/urist/vehicles/uristvehicles.dmi'
	icon_state = "motorcycle"
	emagged = TRUE
	mob_offset_y = 6
	load_offset_x = 0
	health = 250
	charge_use = 0

/obj/vehicle/train/cargo/engine/motorcycle_1dir/New()
	..()
	ClearOverlays()
	var/image/I = new(icon = 'icons/urist/vehicles/uristvehicles.dmi', icon_state = "motorcycle_overlay_n", layer = src.layer + 0.2) //over mobs
	AddOverlays(I)

/obj/vehicle/train/cargo/engine/motorcycle_1dir/Move()
	..()
	load.dir = NORTH //the bikes used on the trains just speed up and slow down, so they always face north - so should the mob.

//buildable motorcylce

/obj/structure/vehicle_frame/motorcycle
	name = "motorcycle frame"
	icon = 'icons/urist/vehicles/bike.dmi'
	icon_state = "bike_frame"
	var/buildstate = 0

/obj/structure/vehicle_frame/motorcycle/examine(mob/user)
	..(user)
	switch(buildstate)
		if(1) to_chat(user, "It has a loose wheel well in place.")
		if(2) to_chat(user, "It has a wheel mount welded in place.")
		if(3) to_chat(user, "It has a back tire loosely attached.")
		if(4) to_chat(user, "It has both tires loosely attached.")
		if(5) to_chat(user, "It has both tires firmly attached.")
		if(6) to_chat(user, "It has both tires firmly attached and a transmission loosely in place.")
		if(7) to_chat(user, "It has both tires firmly attached and a transmission firmly in place.")
		if(8) to_chat(user, "It has both tires, a transmission and a loosely attached battery.")
		if(9) to_chat(user, "It has both tires, a transmission and a firmly attached battery.")

/obj/structure/vehicle_frame/motorcycle/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W,/obj/item/stack/material/rods))
		if(buildstate == 0)
			var/obj/item/stack/material/rods/R = W
			if(R.material && R.material.name == "steel")
				if(R.use(3))
					to_chat(user, "<span class='notice'>You assemble a backbone of rods, constructing a crude wheel well.</span>")
					buildstate++
					update_icon()
				else
					to_chat(user, "<span class='notice'>You need at least three rods to complete this task.</span>")
				return

	else if(istype(W,/obj/item/weldingtool))
		if(buildstate == 1)
			var/obj/item/weldingtool/T = W
			if(T.remove_fuel(0,user))
				if(!src || !T.isOn()) return
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				to_chat(user, "<span class='notice'>You weld the rods into place.</span>")
			buildstate++
		return

	else if(istype(W,/obj/item/vehicle_part/tire))
		if(buildstate == 2)
			to_chat(user, "<span class='notice'>You slide a tire into the back wheel mount.</span>")
			buildstate++
			update_icon()
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 100, 1)
			qdel(W)
			return

		else if(buildstate == 3)
			to_chat(user, "<span class='notice'>You slide a tire into the front wheel mount.</span>")
			buildstate++
			update_icon()
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 100, 1)
			qdel(W)
			return

	else if(istype(W,/obj/item/wrench))
		if(buildstate == 4)
			to_chat(user, "<span class='notice'>You secure the tires into the motorcycle frame.</span>")
			buildstate++
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			return

		else if(buildstate == 8)
			to_chat(user, "<span class='notice'>You secure the battery into the frame.</span>")
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			new /obj/vehicle/bike/motorcycle(get_turf(src))
			qdel(src)
			return

	else if(istype(W,/obj/item/vehicle_part/transmission))
		if(buildstate == 5)
			to_chat(user, "<span class='notice'>You slide the transmission into the frame.</span>")
			buildstate++
			update_icon()
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 100, 1)
			qdel(W)
			return

	else if(istype(W,/obj/item/screwdriver))
		if(buildstate == 6)
			to_chat(user, "<span class='notice'>You secure the transmission into the frame.</span>")
			buildstate++
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
			return

	else if(istype(W,/obj/item/vehicle_part/battery))
		if(buildstate == 7)
			to_chat(user, "<span class='notice'>You slide the battery into the frame.</span>")
			buildstate++
			update_icon()
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 100, 1)
			qdel(W)
			return

	else
		..()

/obj/structure/vehicle_frame/motorcycle/on_update_icon()
	icon_state = "bike_frame[buildstate]"

/obj/vehicle/bike/motorcycle
	name = "motorbike"
	desc = "Wheelies! Head trauma! Woo! "
	icon = 'icons/urist/vehicles/bike.dmi'
	icon_state = "bike_off"
	dir = SOUTH
	bike_icon = "bike"
	load_item_visible = 1
	mob_offset_y = 5
	health = 100
	maxhealth = 100
	pixel_x = -16
	pixel_y = -16
	fire_dam_coeff = 0.6
	brute_dam_coeff = 0.5
//	debris_path = /obj/structure/scrap/vehicle
	light_power = 5
	light_range = 6
	var/idle_sound = 'sound/urist/vehicle/bike_idle.ogg'
	var/start_sound = 'sound/urist/vehicle/bike_start.ogg'
	space_speed = 0
	var/collision_cooldown
	var/max_move_speed = 3
	var/cur_move_speed = 0
	var/cur_move_dir = 0
	var/moved
	land_speed = 1 //if 0 it can't go on turf

/obj/vehicle/bike/motorcycle/toggle()
	set name = "Toggle Engine"
	set category = "Vehicle"
	set src in view(0)

	if(usr.incapacitated()) return

	if(!engine)
		to_chat(usr, "<span class='warning'>\The [src] does not have an engine block installed...</span>")
		return

	if(!on)
		turn_on()
//		src.visible_message("\The [src] rumbles to life.", "You hear something rumble deeply.")
		playsound(src.loc, start_sound, 100)
	else
		turn_off()
//		src.visible_message("\The [src] putters before turning off.", "You hear something putter slowly.")

/obj/vehicle/bike/motorcycle/turn_on()
	..()
	START_PROCESSING(SSobj, src)

/obj/vehicle/bike/motorcycle/turn_off()
	..()
	STOP_PROCESSING(SSobj, src)

/*/obj/vehicle/bike/motorcycle/Move(turf/destination)
	if(kickstand) return
	//these things like space, not turf. Dragging shouldn't weigh you down.
	if(istype(destination,/turf/space) || pulledby)
		if(!space_speed)
			return 0
		move_delay = space_speed
	else
		if(!land_speed)
			return 0
		move_delay = land_speed
	moved = ..()
	return moved*/

/obj/vehicle/bike/motorcycle/Bump(atom/thing)

	if(!istype(thing, /atom/movable))
		return

	var/crashed
	var/atom/movable/A = thing

	// Bump things away!
	if(istype(A, /turf))
		var/turf/T = A
		if(T.density)
			if(collision_cooldown)
				return
			crashed = 1
	else if(!A.anchored)
		var/turf/T = get_step(A, dir)
		if(isturf(T))
			A.Move(T)
	else
		if(cur_move_speed > 1)
			if(collision_cooldown)
				return
			A.attack_generic(src, rand(30,50), "slams into")
			crashed = 1

	if(crashed)
		collision_cooldown = 1
		if(prob(50))
			var/mob/living/M = load
			unload(load, dir)
			if(istype(M))
				to_chat(M, "<span class='danger'>You are hurled off \the [src]!</span>")
				M.throw_at(get_edge_target_turf(src,src.dir),rand(1,2), move_delay)
				spawn(3)
					if(!M.lying)
						to_chat(M, "<span class='notice'>You land on your feet!</span>")

			src.ex_act(2)

	if(cur_move_speed > 1 && istype(A, /mob/living))
		var/mob/living/M = A
		if(!M.lying)
			if(istype(load, /mob/living))
				var/mob/living/driver = load
				to_chat(driver, "<span class='danger'>You collide with \the [M]!</span>")
				msg_admin_attack("[driver.name] ([driver.ckey]) hit [M.name] ([M.ckey]) with [src].")
			visible_message("<span class='danger'>\The [src] knocks \the [M] down!</span>")
			RunOver(M)
			M.Weaken(rand(5,10))
			M.throw_at(get_edge_target_turf(src,get_dir(src,M)),rand(1,2), move_delay)

/obj/vehicle/bike/motorcycle/RunOver(mob/living/carbon/human/H)
	if(istype(load, /mob/living))
		to_chat(load, "<span class='danger'>You run \the [H] down!</span>")
		to_chat(H, "<span class='danger'>\The [load] runs you down!</span>")
	else
		to_chat(H, "<span class='danger'>\The [src] runs you down!</span>")
	if(istype(H))
		var/list/parts = list(HEAD, UPPER_TORSO, LOWER_TORSO, ARMS, LEGS)
		for(var/i = 0, i < rand(1,3), i++)
			H.apply_damage((rand(1,5)), DAMAGE_BRUTE, pick(parts))


/obj/vehicle/bike/motorcycle/Process()
	if(on)
		if(moved && cur_move_speed < max_move_speed)
			cur_move_speed++
		else if(cur_move_speed > 0)
			cur_move_speed--
		playsound(src.loc, idle_sound, 100)
	else
		cur_move_speed = 0
	moved = 0
	collision_cooldown = 0

/obj/vehicle/bike/motorcycle/electric
	engine_type = /obj/item/engine/electric
	prefilled = 1

/obj/vehicle/bike/motorcycle/thermal
	engine_type = /obj/item/engine/thermal
	prefilled = 1
